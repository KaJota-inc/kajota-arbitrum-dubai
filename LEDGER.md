# Kajota Mesh — São Paulo settlement ledger

Automated on-chain settlements against the live v1 contracts on
Arbitrum Sepolia. Each row is one full `register → approve → deposit →
release` cycle driven by [`.github/workflows/saopaulo-runner.yml`](.github/workflows/saopaulo-runner.yml).
The `deposit` and `release` columns link to Arbiscan.

| UTC timestamp | productId | amount | split | deposit | release |
| --- | --- | --- | --- | --- | --- |
| 2026-11-12T13:55:50Z | `runner-2026-11-12-1794491734` | 1.000000 USDC | 10% / 90% | [`0x40f9fc10…b5fb`](https://sepolia.arbiscan.io/tx/0x40f9fc10c62737dd2c8e573b09286dc445d3673c8cab3a96d5eb30126982b5fb) | [`0xf45bf0b7…0daf`](https://sepolia.arbiscan.io/tx/0xf45bf0b7524d94037d8fc6ed657bbcae15f25a0c0ef685c01b93025d42d40daf) |
| 2026-11-13T06:34:33Z | `runner-2026-11-13-1794551662` | 1.000000 USDC | 10% / 90% | [`0x370d8618…2c3e`](https://sepolia.arbiscan.io/tx/0x370d86188dc9391cebba0dd8bc6d98190159b3a019b30c433db1721ec1702c3e) | [`0xde61b4d6…7c01`](https://sepolia.arbiscan.io/tx/0xde61b4d662de0e9b1b6299f3e9952a49b2ccde333e89c9427fb8de3cbd087c01) |
| 2026-11-13T20:11:40Z | `runner-2026-11-13-1794600689` | 1.000000 USDC | 10% / 90% | [`0x43387796…1627`](https://sepolia.arbiscan.io/tx/0x43387796eb35b37e68f44f7c53c6215291fd45f3005bccc86ffe9e622f811627) | [`0xecacf8b3…9e1f`](https://sepolia.arbiscan.io/tx/0xecacf8b35dc21d4b8cff81b0fcb5d87db8c22cebdc9a14d7184c532c7d3f9e1f) |
| 2026-11-14T18:37:02Z | `runner-2026-11-14-1794681412` | 1.000000 USDC | 10% / 90% | [`0x9616371c…164c`](https://sepolia.arbiscan.io/tx/0x9616371c296681757338730216b63a55dec2c1a40bbcf191e1f6be62ae7b164c) | [`0x5b667c0b…5538`](https://sepolia.arbiscan.io/tx/0x5b667c0bbf4237e130f01be11097a90b4ce1bf30d4b580f92dedcea338145538) |
| 2026-11-14T19:50:14Z | `runner-2026-11-14-1794685805` | 1.000000 USDC | 10% / 90% | [`0x1429b6b9…c30e`](https://sepolia.arbiscan.io/tx/0x1429b6b938a358493a0b1563f5f5626ff40cc5c8cc79bc0a8136c7031b3cc30e) | [`0x25b69e28…ab07`](https://sepolia.arbiscan.io/tx/0x25b69e28b8720c015557a8c91a551af0deb72ee1d980ca5640f23af936a2ab07) |
