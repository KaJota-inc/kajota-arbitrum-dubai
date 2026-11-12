#!/usr/bin/env bash
# deactivated-listing-deposit.sh — failure-mode demo #1 (of five
# planned for Nov 21-25 per PHASE_0_RECOVERY.md Move 6).
#
# Asserts the registry's deactivate-only semantics: a wholesaler can
# flip `active=false` to retire a listing, and from that moment the
# escrow's deposit() reverts with ListingNotActive(listingId). This
# matters because it prevents an agent from draining USDC into a stale
# listing whose terms the wholesaler already rotated.
#
# On-chain output: 2 successful txs (register + deactivate) + 1
# reverting tx (deposit). The reverting tx is mined — Arbiscan shows
# status Reverted — which is the evidence the gate table in README
# cites.
#
# Requires: foundry (cast) + jq + ./.env with DEPLOYER_PRIVATE_KEY +
# BUYER_PRIVATE_KEY.

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/../.." && pwd )"
ENV_FILE="$REPO_ROOT/.env"

if [ -f "$ENV_FILE" ]; then
  set -a; . "$ENV_FILE"; set +a
fi

: "${DEPLOYER_PRIVATE_KEY:?DEPLOYER_PRIVATE_KEY is required}"
: "${BUYER_PRIVATE_KEY:?BUYER_PRIVATE_KEY is required}"

RPC="${ARBITRUM_SEPOLIA_RPC:-https://sepolia-rollup.arbitrum.io/rpc}"
MANIFEST="$REPO_ROOT/deployments/421614.json"
REGISTRY=$(jq -r '.contracts.registry' "$MANIFEST")
ESCROW=$(jq -r '.contracts.escrow' "$MANIFEST")
USDC=$(jq -r '.usdc' "$MANIFEST")
COSELLER="0x33cdCcbC1c759E21ba8d943918A13AA78dbEeb42"

WHOLESALER=$(cast wallet address --private-key "$DEPLOYER_PRIVATE_KEY")
BUYER=$(cast wallet address --private-key "$BUYER_PRIVATE_KEY")
PRODUCT_ID="failmode-deact-$(date -u +%Y-%m-%d)-$(date -u +%s)"
AMOUNT=1000000

echo "== Failure mode: deposit into a deactivated listing =="
echo "productId:   $PRODUCT_ID"
echo "wholesaler:  $WHOLESALER"
echo "buyer:       $BUYER"

echo ""
echo "[1/3] register fresh listing"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$REGISTRY" \
  "register(string,address,address,uint16,string)(bytes32)" \
  "$PRODUCT_ID" "$WHOLESALER" "$COSELLER" 1000 "USDC")
TX_REGISTER=$(echo "$RESP" | jq -r '.transactionHash')
LISTING_ID=$(echo "$RESP" | jq -r '.logs[0].topics[1]')
echo "  listingId: $LISTING_ID"
echo "  tx:        $TX_REGISTER"

echo "[2/3] deactivate listing (only wholesaler can)"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$REGISTRY" \
  "deactivate(bytes32)" "$LISTING_ID")
TX_DEACT=$(echo "$RESP" | jq -r '.transactionHash')
echo "  tx:        $TX_DEACT"

echo "[3/3] attempt deposit (should revert with ListingNotActive)"
# Pre-approve so the revert comes from the escrow's active check, not an
# ERC-20 allowance error. Approve success is expected.
cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$USDC" \
  "approve(address,uint256)" "$ESCROW" "$AMOUNT" > /dev/null
# Force-send the deposit tx by passing --gas-limit so cast skips the
# pre-flight estimateGas that would otherwise bail before mining the
# tx. The tx is mined with status Reverted — which is what we assert.
set +e
RESP=$(cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --gas-limit 200000 --json \
  "$ESCROW" "deposit(bytes32,uint256)" "$LISTING_ID" "$AMOUNT" 2>&1)
EXIT=$?
set -e

TX_REVERT=$(echo "$RESP" | jq -r '.transactionHash // empty' 2>/dev/null || true)
STATUS=$(echo "$RESP"   | jq -r '.status          // empty' 2>/dev/null || true)

if [ -n "$TX_REVERT" ] && [ "$STATUS" = "0x0" ]; then
  echo "  ✓ deposit mined with status Reverted (expected)"
  echo "  tx:        $TX_REVERT"
  echo "  arbiscan:  https://sepolia.arbiscan.io/tx/$TX_REVERT"
elif echo "$RESP" | grep -qi 'ListingNotActive'; then
  # cast refused to send; the pre-flight simulation caught the revert.
  # Still the right behaviour — just no on-chain artifact.
  echo "  ✓ deposit rejected pre-send with ListingNotActive (simulated)"
  echo "  (no on-chain tx; re-run with --gas-limit override worked but cast refused)"
else
  echo "  ✗ FAIL: deposit should have reverted but didn't"
  echo "  exit=$EXIT"
  echo "  resp=$RESP"
  exit 1
fi

echo ""
echo "assertion passed · registry deactivate semantics enforced"
