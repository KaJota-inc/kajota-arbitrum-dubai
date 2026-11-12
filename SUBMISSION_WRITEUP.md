# Kajota Mesh — São Paulo submission writeup

*Draft for the HackQuest project description field — paste as-is or
trim to the field's char cap. Current body length ~2,470 chars.*

---

**Kajota Mesh is the atomic N-party commission settlement primitive
for commerce agents on Arbitrum.** USDC in, up to 16 recipients out,
one tx, zero dust retained. The split is on `release`, not on
`deposit` — a release-authority agent can trigger settlement but
cannot influence who gets what. The registry is deactivate-only, so
an agent that drafted a listing cannot retroactively cut its
counterparty's share after volume lands.

**Reuse disclosure.** This submission builds on the Singapore
submission at [`kajota-arbitrum-singapore @ 9f8fb5e`][sg]
— 17 verified contracts, 97 passing tests, Robinhood Chain variant,
USDG variant, live Vercel hero. São Paulo-specific additions since
Oct 4, 2026: (1) a daily GitHub Actions settlement runner that fires
one full register → approve → deposit → release cycle on the v1
contracts and accrues real on-chain evidence in [`LEDGER.md`][ledger],
(2) five runnable failure-mode scripts in [`demos/failure-modes/`][fm]
each producing a judge-verifiable Reverted-tx Arbiscan artifact
(deactivated-listing deposit, zero-recipient register, BPS sum
mismatch, double-release, pre-release refund), and (3) an in-browser
ledger panel on the live hero that reads `Released` events via
viem's `eth_getLogs` — no indexer, no backend.

**Live evidence.** [kajota-mesh.vercel.app](https://kajota-mesh.vercel.app)
reads contract state in-browser via viem. Full on-chain happy path
reproducible via `./scripts/arbitrum-demo.sh` with four Arbiscan tx
links in the README. Robinhood Chain testnet deployment live and
Sourcify-verified for the 1-of-3 reserved prize slot per Prizes &
Judging. USDG variant deployed on both chains for the Paxos
tiebreaker bonus.

**Why this wins.** Contract quality: 97 tests, `ReentrancyGuard` on
every value-moving path, mainnet-chainId guardrail, sum-to-10000
basis-point invariant on N-party shares. PMF: Kajota is a live
Nigerian social-commerce app with real co-sellers doing off-chain
splits today — the pain is not hypothetical. Innovation: splits
locked at deposit time, not at release, flips the trust model from
"trust the agent" to "trust the contract". Real problem-solving:
sub-$1 commissions on $5-$50 trades only clear positive on an L2
with $0.01-tier fees — Arbitrum isn't decorative, it's the reason
the primitive is economically possible.

[sg]: https://github.com/KaJota-inc/kajota-arbitrum-singapore/tree/9f8fb5e
[ledger]: ./LEDGER.md
[fm]: ./demos/failure-modes/
