#!/usr/bin/env bash
# pre-release-refund.sh — failure-mode #5 of 5.
# Buyer calling refund() before REFUND_DELAY (14 days post-deposit)
# must revert RefundTooEarly(depositedAt, unlockAt). Prevents a buyer
# from side-stepping the escrow's settlement window with an immediate
# clawback.
#
# Cleanup: the deployer releases the stranded deposit at the end so
# the 1 USDC is not locked in escrow for 14 days.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

PRODUCT_ID="failmode-prerefund-$(today)-$(now)"
AMOUNT=1000000

echo "== Failure mode: refund() before REFUND_DELAY (14 days) =="
echo "productId:   $PRODUCT_ID"

echo ""
echo "[1/4] register"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$REGISTRY" \
  "register(string,address,address,uint16,string)(bytes32)" \
  "$PRODUCT_ID" "$WHOLESALER" "$COSELLER" 1000 "USDC")
LISTING_ID=$(echo "$RESP" | jq -r '.logs[0].topics[1]')

echo "[2/4] approve + deposit"
cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$USDC" \
  "approve(address,uint256)" "$ESCROW" "$AMOUNT" > /dev/null
RESP=$(cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$ESCROW" \
  "deposit(bytes32,uint256)" "$LISTING_ID" "$AMOUNT")
DEPOSIT_ID=$(echo "$RESP" | jq -r '.logs[-1].topics[1]')
echo "  depositId: $DEPOSIT_ID"

echo "[3/4] attempt refund immediately (should revert)"
RESP=$(send_force "$BUYER_PRIVATE_KEY" "$ESCROW" "refund(bytes32)" "$DEPOSIT_ID")
assert_revert "immediate refund rejected" "$RESP" "RefundTooEarly"

echo ""
echo "[4/4] cleanup: deployer releases stranded deposit"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$ESCROW" \
  "release(bytes32)" "$DEPOSIT_ID")
echo "  release: $(tx_hash "$RESP")"
echo ""
echo "assertion passed · refund window enforced; funds unstranded"
