# Voiceover script — São Paulo demo

**Target duration: 3:00 total.** Each scene has a word count annotation
assuming ~155 words/min at a measured pace. Breath marks shown as `/`.
Pair with [`SHOT_LIST.md`](SHOT_LIST.md) — scene numbers match.

**Recording guidance**: Record in one take if you can; the VO and the
on-screen cuts are designed to tolerate ±1s drift per scene. If you
mis-say a scene, say *"take two"* and restart that scene — the cut
grabs the last clean take. Record at 48kHz mono WAV. Target peak
−6 dBFS, average −18 dBFS.

---

## Scene 1 · 0:00 – 0:12 (cold open, ~16 words)

*(hero visible, 1s beat)*

"**Kajota Mesh.** / Atomic multi-recipient settlement for commerce
agents on Arbitrum. / Here's a thirty-second tour."

## Scene 2 · 0:12 – 0:28 (one-sentence pitch, ~24 words)

*(full-screen slide: "USDC in, N-party split out, one tx.")*

"The primitive is simple. / USDC in, N recipients out, one
transaction. / The split is locked at the release action, not the
deposit — an agent can trigger settlement, / but cannot influence who
gets what."

## Scene 3 · 0:28 – 1:15 (happy path, ~105 words)

*(terminal opens, cycles stream)*

"This is the live v1 contracts on Arbitrum Sepolia. / A wholesaler
registers a listing — one Arbiscan transaction. / A buyer approves,
then deposits one USDC into the escrow — / and the release authority
fires `release`, / which atomically fans the funds to the coseller
and the wholesaler in the ratio the registry recorded at deposit
time. / Ten percent to the coseller, / ninety to the wholesaler, /
zero dust retained in the escrow. / You can click any of these
hashes on Arbiscan and read the state diff yourself — / coseller's
balance went up by point-one USDC, / wholesaler's by point-nine, /
buyer's down by one. / Atomic."

## Scene 4 · 1:15 – 1:55 (N-party split, ~85 words)

*(switch to browser, calculator)*

"Same primitive, three recipients. / Twenty percent, thirty percent,
fifty percent. / The contract rejects any share-array that doesn't
sum to ten-thousand basis points — / dust is a protocol-level error,
not a rounding compromise. / Clicking register sends one transaction
to `CosellRegistryV2` on Arbitrum Sepolia — / no USDC required to
register, just a tiny amount of gas. / The deposit and release
sequence that follows looks exactly like Scene three, / except the
atomic fan-out now hits three wallets instead of two."

## Scene 5 · 1:55 – 2:30 (failure modes, ~80 words)

*(terminal, run deactivated-listing-deposit.sh, then arbiscan)*

"Every rejection branch of the primitive is runnable. / We deactivate
a fresh listing, / then force a deposit through to the escrow — / and
Arbiscan mines it with status Reverted, / carrying `ListingNotActive`
as the error. / Four more scripts in demos slash failure-modes cover
zero-recipient, / shares-summing-to-wrong, / double-release, / and
pre-release refund. / Each one gives judges a Reverted-tx hash they
can click — / not a local simulation, a real on-chain artifact."

## Scene 6 · 2:30 – 2:52 (live ledger panel, ~50 words)

*(browser, scroll to ledger panel)*

"The daily GitHub Actions cron fires a settlement cycle at thirteen
UTC every day. / This panel reads the `Released` events straight from
Arbitrum Sepolia — / no indexer, no backend, viem in the browser. /
Each row links to its Arbiscan transaction. / The ledger grows every
day between now and the March first deadline."

## Scene 7 · 2:52 – 3:00 (close, ~16 words)

*(close slide)*

"**Kajota Mesh.** / Live at kajota-mesh dot vercel dot app. / Code
and the Singapore substrate carryover disclosed in the repo."

---

## Fallback 2:00 cut

If you need to deliver a 2:00 version instead of 3:00, drop Scene 4
entirely (saves 40s) and tighten Scene 3 to only one happy-path tx
link (saves ~15s). The N-party story stays in Scene 5's reference
to the share-array check.

## What NOT to say

- Don't say "we built Kajota Mesh for the São Paulo buildathon" — it
  reads as throwaway work. Say "**extended for São Paulo**" instead,
  which lines up with the reuse-disclosure block in the README.
- Don't name specific prize amounts. Judges have seen the number.
- Don't say "it's like" — Kajota Mesh is not like anything in the
  São Paulo field (per the positioning section). Name the primitive.

## Word-count totals

| Scene | Words | Target s @ 155 wpm | Shot-list s |
| --- | --- | --- | --- |
| 1 | 16 | 6 | 12 |
| 2 | 24 | 9 | 16 |
| 3 | 105 | 41 | 47 |
| 4 | 85 | 33 | 40 |
| 5 | 80 | 31 | 35 |
| 6 | 50 | 19 | 22 |
| 7 | 16 | 6 | 8 |
| **Total** | **376** | **145s** | **180s** |

~145s of audio over 180s of video gives ~35s of breath + action
pauses, which is what carries the demo tension. If you naturally
speak faster, pad the scene gaps rather than rushing the VO.
