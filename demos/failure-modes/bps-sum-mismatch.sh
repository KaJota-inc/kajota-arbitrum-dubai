#!/usr/bin/env bash
# bps-sum-mismatch.sh — failure-mode #3 of 5.
# V2 CosellRegistryV2.register where the share BPS array doesn't sum
# to 10000 must revert SharesDoNotSumToDenominator(supplied, 10000).
# This is the invariant that makes the split atomic: the contract will
# never accept a listing whose shares leave dust behind.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

PRODUCT_ID="failmode-bps-$(today)-$(now)"

echo "== Failure mode: V2 register with shares summing to 9000 (not 10000) =="
echo "productId:   $PRODUCT_ID"

RESP=$(send_force "$DEPLOYER_PRIVATE_KEY" "$REGISTRY_V2" \
  "register(string,address[],uint16[],string)(bytes32)" \
  "$PRODUCT_ID" "[$WHOLESALER,$COSELLER]" "[2000,7000]" "USDC")
assert_revert "V2 register rejected 9000 BPS sum" "$RESP" "SharesDoNotSumToDenominator"
echo ""
echo "assertion passed · V2 register enforces 10000 BPS total"
