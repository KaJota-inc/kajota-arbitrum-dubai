# Stylus `#146` upstream — silence tracker

Move 3 of the hackathon-winning playbook ("merge an upstream PR before
the halfway point"). Target:
[OffchainLabs/stylus-sdk-rs#146](https://github.com/OffchainLabs/stylus-sdk-rs/issues/146).

| field | value |
| --- | --- |
| Last `KaJota-inc` comment | `2026-11-03T07:49:09Z` |
| Last maintainer reply | `2024-08-20T21:13:33Z` (`@rory-ocl`, pre-dating our comment) |
| Days silent (since our Nov 3 comment) | **15** |
| Drop criterion date | `2026-12-15` — 26 days away |
| Halfway merge gate | `2027-01-15` — 57 days away |
| São Paulo submission close | `2027-03-01 03:59 UTC` — 102 days away |
| Verdict | **CONTINUE WAITING** — well under the 42-day drop line |

## Decision ladder

- **Silence ≤ 42 days** (through 2026-12-15) → wait. No nudge unless the
  user says "nudge Stylus" per `[[project_arbitrum_stylus_contribution]]`.
- **Maintainer replies between now and Dec 15** → build the PR fast and
  ship it before `2027-01-15` so the "merged before halfway" claim holds.
  Draft lives at `../dubai-phase-0-24172d/UPSTREAM_PR.md` (commit
  `dce80bc`).
- **Silence > 42 days** (after 2026-12-15) → drop the Stylus upstream
  angle. Pivot to **Stylus Plan B**: port the Mesh contract to a plain
  Arbitrum Stylus deployment (not upstreaming to the SDK) and keep the
  `#146` comment thread open as the shipped-integration receipt.
- **Reply after Jan 15 2027** → still worth building for post-submission
  reward window but no longer counts toward São Paulo narrative.

## Check cadence

Re-read the issue weekly. Next check: **2026-11-25**.

Update this file every check with the fresh silence count and any
maintainer activity. Do not open a PR without user approval.
