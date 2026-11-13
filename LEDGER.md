# Kajota Mesh — São Paulo settlement ledger

Automated on-chain settlements against the live v1 contracts on
Arbitrum Sepolia. Each row is one full `register → approve → deposit →
release` cycle driven by [`.github/workflows/saopaulo-runner.yml`](.github/workflows/saopaulo-runner.yml).
The `deposit` and `release` columns link to Arbiscan.

| UTC timestamp | productId | amount | split | deposit | release |
| --- | --- | --- | --- | --- | --- |
| 2026-11-12T13:55:50Z | `runner-2026-11-12-1794491734` | 1.000000 USDC | 10% / 90% | [`0x40f9fc10…b5fb`](https://sepolia.arbiscan.io/tx/0x40f9fc10c62737dd2c8e573b09286dc445d3673c8cab3a96d5eb30126982b5fb) | [`0xf45bf0b7…0daf`](https://sepolia.arbiscan.io/tx/0xf45bf0b7524d94037d8fc6ed657bbcae15f25a0c0ef685c01b93025d42d40daf) |
| 2026-11-13T06:34:33Z | `runner-2026-11-13-1794551662` | 1.000000 USDC | 10% / 90% | [`0x370d8618…2c3e`](https://sepolia.arbiscan.io/tx/0x370d86188dc9391cebba0dd8bc6d98190159b3a019b30c433db1721ec1702c3e) | [`0xde61b4d6…7c01`](https://sepolia.arbiscan.io/tx/0xde61b4d662de0e9b1b6299f3e9952a49b2ccde333e89c9427fb8de3cbd087c01) |
