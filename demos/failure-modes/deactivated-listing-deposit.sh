#!/usr/bin/env bash
# deactivated-listing-deposit.sh — failure-mode #1 of 5.
# Deposit into a listing the wholesaler deactivated must revert
# ListingNotActive(bytes32). Enforces the registry's deactivate-only
# semantics so stale terms can't be re-bound to new deposits.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

PRODUCT_ID="failmode-deact-$(today)-$(now)"
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
LISTING_ID=$(echo "$RESP" | jq -r '.logs[0].topics[1]')
echo "  listingId: $LISTING_ID"
echo "  tx:        $(tx_hash "$RESP")"

echo "[2/3] deactivate listing"
RESP=$(cast send --rpc-url "$RPC" --private-key "$DEPLOYER_PRIVATE_KEY" --json "$REGISTRY" \
  "deactivate(bytes32)" "$LISTING_ID")
echo "  tx:        $(tx_hash "$RESP")"

echo "[3/3] attempt deposit (should revert)"
cast send --rpc-url "$RPC" --private-key "$BUYER_PRIVATE_KEY" --json "$USDC" \
  "approve(address,uint256)" "$ESCROW" "$AMOUNT" > /dev/null
RESP=$(send_force "$BUYER_PRIVATE_KEY" "$ESCROW" "deposit(bytes32,uint256)" "$LISTING_ID" "$AMOUNT")
assert_revert "deposit rejected on deactivated listing" "$RESP" "ListingNotActive"
echo ""
echo "assertion passed · registry deactivate semantics enforced"
