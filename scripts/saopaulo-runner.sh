#!/usr/bin/env bash
# saopaulo-runner.sh — automated on-chain settlement for the Arbitrum
# Open House São Paulo Online Buildathon. Fires one full register →
# approve → deposit → release cycle against the live v1 contracts on
# Arbitrum Sepolia and appends a Markdown ledger line to LEDGER.md.
#
# Runs locally with keys from ./.env (symlink or copy). In GH Actions,
# keys come from the DEPLOYER_PRIVATE_KEY + BUYER_PRIVATE_KEY secrets
# — see .github/workflows/saopaulo-runner.yml.
#
# Requires: foundry (cast) + jq on PATH.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
ENV_FILE="$REPO_ROOT/.env"

if [ -f "$ENV_FILE" ]; then
  set -a; . "$ENV_FILE"; set +a
fi

: "${DEPLOYER_PRIVATE_KEY:?DEPLOYER_PRIVATE_KEY is required (env or .env)}"
: "${BUYER_PRIVATE_KEY:?BUYER_PRIVATE_KEY is required (env or .env)}"

RPC="${ARBITRUM_SEPOLIA_RPC:-https://sepolia-rollup.arbitrum.io/rpc}"

MANIFEST="$REPO_ROOT/deployments/421614.json"
[ -f "$MANIFEST" ] || { echo "manifest missing: $MANIFEST" >&2; exit 1; }

REGISTRY=$(jq -r '.contracts.registry' "$MANIFEST")
ESCROW=$(jq -r '.contracts.escrow' "$MANIFEST")
USDC=$(jq -r '.usdc' "$MANIFEST")
COSELLER="0x33cdCcbC1c759E21ba8d943918A13AA78dbEeb42"

WHOLESALER=$(cast wallet address --private-key "$DEPLOYER_PRIVATE_KEY")
BUYER=$(cast wallet address --private-key "$BUYER_PRIVATE_KEY")

PRODUCT_ID="runner-$(date -u +%Y-%m-%d)-$(date -u +%s)"
COMMISSION_BPS=1000
AMOUNT=1000000

echo "== Settlement runner on Arbitrum Sepolia =="
echo "productId:   $PRODUCT_ID"
echo "wholesaler:  $WHOLESALER"
echo "buyer:       $BUYER"
echo "coseller:    $COSELLER"
echo "registry:    $REGISTRY"
echo "escrow:      $ESCROW"

RAW=$(cast call --rpc-url "$RPC" "$USDC" "balanceOf(address)(uint256)" "$BUYER")
RAW="${RAW%% *}"
if [ "$RAW" -lt "$AMOUNT" ]; then
  echo "buyer $BUYER has $RAW USDC (<$AMOUNT); top up at https://faucet.circle.com (Arbitrum Sepolia)" >&2
  exit 1
fi

echo ""
echo "[1/4] register"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$REGISTRY" \
  "register(string,address,address,uint16,string)(bytes32)" \
  "$PRODUCT_ID" "$WHOLESALER" "$COSELLER" "$COMMISSION_BPS" "USDC")
TX_REGISTER=$(echo "$RESP" | jq -r '.transactionHash')
LISTING_ID=$(echo "$RESP" | jq -r '.logs[0].topics[1]')
echo "  listingId: $LISTING_ID"
echo "  tx:        $TX_REGISTER"

echo "[2/4] approve"
RESP=$(cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$USDC" \
  "approve(address,uint256)" "$ESCROW" "$AMOUNT")
TX_APPROVE=$(echo "$RESP" | jq -r '.transactionHash')
echo "  tx:        $TX_APPROVE"

echo "[3/4] deposit"
RESP=$(cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$ESCROW" \
  "deposit(bytes32,uint256)" "$LISTING_ID" "$AMOUNT")
TX_DEPOSIT=$(echo "$RESP" | jq -r '.transactionHash')
DEPOSIT_ID=$(echo "$RESP" | jq -r '.logs[-1].topics[1]')
echo "  depositId: $DEPOSIT_ID"
echo "  tx:        $TX_DEPOSIT"

echo "[4/4] release"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$ESCROW" \
  "release(bytes32)" "$DEPOSIT_ID")
TX_RELEASE=$(echo "$RESP" | jq -r '.transactionHash')
echo "  tx:        $TX_RELEASE"

LEDGER="$REPO_ROOT/LEDGER.md"
if [ ! -f "$LEDGER" ]; then
  cat > "$LEDGER" <<'HEADER_EOF'
# Kajota Mesh — São Paulo settlement ledger

Automated on-chain settlements against the live v1 contracts on
Arbitrum Sepolia. Each row is one full `register → approve → deposit →
release` cycle driven by [`.github/workflows/saopaulo-runner.yml`](.github/workflows/saopaulo-runner.yml).
The `deposit` and `release` columns link to Arbiscan.

| UTC timestamp | productId | amount | split | deposit | release |
| --- | --- | --- | --- | --- | --- |
HEADER_EOF
fi

TS=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
TX_DEP_SHORT="${TX_DEPOSIT:0:10}…${TX_DEPOSIT: -4}"
TX_REL_SHORT="${TX_RELEASE:0:10}…${TX_RELEASE: -4}"
printf '| %s | `%s` | 1.000000 USDC | 10%% / 90%% | [`%s`](https://sepolia.arbiscan.io/tx/%s) | [`%s`](https://sepolia.arbiscan.io/tx/%s) |\n' \
  "$TS" "$PRODUCT_ID" "$TX_DEP_SHORT" "$TX_DEPOSIT" "$TX_REL_SHORT" "$TX_RELEASE" >> "$LEDGER"

echo ""
echo "Ledger line appended to $LEDGER"
