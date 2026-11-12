# demos/failure-modes/_lib.sh — shared boilerplate for Move 6 scripts.
# Source from each script. Loads env + addresses + wallet derivations,
# and provides cast helpers for asserting reverting txs.

set -euo pipefail

LIB_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$LIB_DIR/../.." && pwd )"
ENV_FILE="$REPO_ROOT/.env"

if [ -f "$ENV_FILE" ]; then
  set -a; . "$ENV_FILE"; set +a
fi

: "${DEPLOYER_PRIVATE_KEY:?DEPLOYER_PRIVATE_KEY is required}"
: "${BUYER_PRIVATE_KEY:?BUYER_PRIVATE_KEY is required}"

RPC="${ARBITRUM_SEPOLIA_RPC:-https://sepolia-rollup.arbitrum.io/rpc}"
MANIFEST="$REPO_ROOT/deployments/421614.json"
[ -f "$MANIFEST" ] || { echo "manifest missing: $MANIFEST" >&2; exit 1; }

REGISTRY=$(jq -r '.contracts.registry'   "$MANIFEST")
ESCROW=$(jq -r   '.contracts.escrow'     "$MANIFEST")
REGISTRY_V2=$(jq -r '.contracts.registryV2' "$MANIFEST")
ESCROW_V2=$(jq -r   '.contracts.escrowV2'   "$MANIFEST")
USDC=$(jq -r     '.usdc'                 "$MANIFEST")
COSELLER="0x33cdCcbC1c759E21ba8d943918A13AA78dbEeb42"

WHOLESALER=$(cast wallet address --private-key "$DEPLOYER_PRIVATE_KEY")
BUYER=$(cast wallet address      --private-key "$BUYER_PRIVATE_KEY")

now()    { date -u +%s; }
today()  { date -u +%Y-%m-%d; }

# Force-send a tx that is expected to revert. Passes --gas-limit so
# cast skips the pre-flight estimateGas (which would otherwise bail
# before mining). Returns the JSON receipt on stdout; exit status is
# NOT a reliable signal on revert.
send_force() {
  local key="$1" to="$2" sig="$3"
  shift 3
  set +e
  cast send --rpc-url "$RPC" --private-key "$key" --gas-limit 300000 --json "$to" "$sig" "$@" 2>&1
  set -e
}

tx_hash()   { echo "$1" | jq -r '.transactionHash // empty' 2>/dev/null || true; }
tx_status() { echo "$1" | jq -r '.status          // empty' 2>/dev/null || true; }

# Assert a cast receipt represents a mined-and-reverted tx (status 0x0)
# or a pre-send simulation revert matching the optional pattern.
# Prints the result + tx hash. Exits non-zero on failure.
assert_revert() {
  local label="$1" resp="$2" pattern="${3:-}"
  local h s
  h=$(tx_hash   "$resp")
  s=$(tx_status "$resp")
  if [ -n "$h" ] && [ "$s" = "0x0" ]; then
    printf '  \033[32m✓\033[0m %s — mined with status Reverted\n' "$label"
    echo "  tx:        $h"
    echo "  arbiscan:  https://sepolia.arbiscan.io/tx/$h"
    return 0
  fi
  if [ -n "$pattern" ] && echo "$resp" | grep -qi "$pattern"; then
    printf '  \033[32m✓\033[0m %s — rejected pre-send matching %s (simulated)\n' "$label" "$pattern"
    return 0
  fi
  printf '  \033[31m✗\033[0m %s — expected revert but got success or unknown\n' "$label" >&2
  echo "  resp=$resp" >&2
  return 1
}
