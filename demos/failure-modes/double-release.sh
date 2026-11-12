#!/usr/bin/env bash
# double-release.sh — failure-mode #4 of 5.
# A second release() on the same depositId must revert
# DepositNotPending(depositId). Guarantees at-most-once settlement
# against a deposit — the state machine advances Pending → Released
# and stays there.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

PRODUCT_ID="failmode-doublerel-$(today)-$(now)"
AMOUNT=1000000

echo "== Failure mode: double release() on the same depositId =="
echo "productId:   $PRODUCT_ID"

echo ""
echo "[1/5] register"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$REGISTRY" \
  "register(string,address,address,uint16,string)(bytes32)" \
  "$PRODUCT_ID" "$WHOLESALER" "$COSELLER" 1000 "USDC")
LISTING_ID=$(echo "$RESP" | jq -r '.logs[0].topics[1]')
echo "  listingId: $LISTING_ID"

echo "[2/5] approve"
cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$USDC" \
  "approve(address,uint256)" "$ESCROW" "$AMOUNT" > /dev/null

echo "[3/5] deposit"
RESP=$(cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$ESCROW" \
  "deposit(bytes32,uint256)" "$LISTING_ID" "$AMOUNT")
DEPOSIT_ID=$(echo "$RESP" | jq -r '.logs[-1].topics[1]')
echo "  depositId: $DEPOSIT_ID"

echo "[4/5] first release (expected success)"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$ESCROW" \
  "release(bytes32)" "$DEPOSIT_ID")
echo "  tx: $(tx_hash "$RESP")"

echo "[5/5] second release (should revert)"
RESP=$(send_force "$DEPLOYER_PRIVATE_KEY" "$ESCROW" "release(bytes32)" "$DEPOSIT_ID")
assert_revert "second release rejected" "$RESP" "DepositNotPending"
echo ""
echo "assertion passed · escrow state machine blocks double-release"
