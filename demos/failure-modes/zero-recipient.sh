#!/usr/bin/env bash
# zero-recipient.sh — failure-mode #2 of 5.
# V2 CosellRegistryV2.register with a zero-address recipient must
# revert ZeroRecipient(index). Prevents a drafted listing from
# accidentally fanning out funds to a burn address.
source "$(dirname "${BASH_SOURCE[0]}")/_lib.sh"

PRODUCT_ID="failmode-zerorecip-$(today)-$(now)"
ZERO="0x0000000000000000000000000000000000000000"

echo "== Failure mode: V2 register with zero-address recipient =="
echo "productId:   $PRODUCT_ID"

RESP=$(send_force "$DEPLOYER_PRIVATE_KEY" "$REGISTRY_V2" \
  "register(string,address[],uint16[],string)(bytes32)" \
  "$PRODUCT_ID" "[$ZERO,$COSELLER]" "[2000,8000]" "USDC")
assert_revert "V2 register rejected zero recipient" "$RESP" "ZeroRecipient"
echo ""
echo "assertion passed · V2 register validates recipients"
