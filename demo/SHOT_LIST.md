# Demo video — São Paulo shot list

**Hard cap: 3:00.** Six scenes, timestamps in `mm:ss`. Pair this file
with [`VOICEOVER.md`](VOICEOVER.md): the scene numbers match 1-to-1.
User records a VO take against VOICEOVER.md; this session cuts the
captured scenes to the timings here + muxes the audio over.

Capture environment: 1920x1080, OBS or `macOS Screen Recording`
(`cmd+shift+5`), **no OS-level notifications** (toggle Do-Not-Disturb
in Focus), terminal = iTerm2 at font size 16+, window at 1280x720
centered. Browser = Chrome at 1440x900, one tab per Arbiscan URL
pre-opened in advance (tabs stay open, we switch between them).

## Scene 1 · 0:00 – 0:12 · Cold open
- [B-roll] 3s of the Kajota Mesh hero at
  [kajota-mesh.vercel.app](https://kajota-mesh.vercel.app), scrolled
  to show the pill bar + headline, no cursor movement.
- [Text overlay] "KAJOTA MESH / Arbitrum Open House São Paulo"
- [Transition] 200ms crossfade to Scene 2.

## Scene 2 · 0:12 – 0:28 · The primitive in one sentence
- [Full-screen slide] Dark background, serif headline center-screen:
  "**USDC in, N-party split out, one tx.**"
- [Sub-caption] "The split is on the release, not the deposit."
- Hold 10s.

## Scene 3 · 0:28 – 1:15 · Happy path on Arbitrum Sepolia
- [Terminal] Pre-cleared. Pre-sourced `.env` from
  `kajota-arbitrum-singapore`. Type (or paste-and-"run"):
  `./scripts/arbitrum-demo.sh`
- Let the four cycles stream (register → approve → deposit → release),
  pausing briefly on each Arbiscan URL.
- [Browser cut-in at 1:05] Click the final `release` Arbiscan link.
  Show the state-diff pane (Deployer +0.9 USDC, Coseller +0.1 USDC).
- Return to terminal for the "Balance deltas" summary line.

## Scene 4 · 1:15 – 1:55 · N-party split (v2, 3 recipients)
- [Browser] Open `kajota-mesh.vercel.app#calc`. Scroll so the split
  calculator fills the frame.
- Edit the bps rows to 20 / 30 / 50 (the Sep 22 reference case). The
  bar chart updates live.
- Click **"Register this listing on CosellRegistryV2 →"**; wallet
  prompt (use the burner on `0xB15E…7380`, 1-click sign).
- [Browser cut-in] The Arbiscan link that pops into the UI; hover
  it once to show the href, do NOT follow (keeps the scene short).

## Scene 5 · 1:55 – 2:30 · Failure modes
- [Terminal] Run:
  `./demos/failure-modes/deactivated-listing-deposit.sh`
- Let the three steps print (register, deactivate, reverting deposit).
- [Browser cut-in at 2:20] Click the Reverted-tx Arbiscan link the
  script printed. Scroll to the red "**Status: Fail**" banner + the
  `ListingNotActive(...)` field in Error. Hold 5s.
- Voice-over names the other four scripts as the frame holds.

## Scene 6 · 2:30 – 2:52 · Live ledger panel (Move 1)
- [Browser] `kajota-mesh.vercel.app#runner`. Scroll so the
  Settlement-Ledger card fills the frame.
- Point (literal mouse cursor) at the "N releases in the last ~11
  days" status chip.
- Hover the most-recent Arbiscan link in the first row (show href),
  do NOT follow.

## Scene 7 · 2:52 – 3:00 · Close
- [Full-screen slide] Dark background.
  - Line 1: "Live: **kajota-mesh.vercel.app**"
  - Line 2: "Repo: **github.com/KaJota-inc/kajota-arbitrum-dubai**"
  - Line 3 (small): "Builds on `kajota-arbitrum-singapore @ 9f8fb5e`"
- Hold 6s. Hard cut to black at 3:00.

## Timing audit

| Scene | Start | End | Dur | Dominant visual |
| --- | --- | --- | --- | --- |
| 1 | 0:00 | 0:12 | 12s | hero scroll |
| 2 | 0:12 | 0:28 | 16s | title slide |
| 3 | 0:28 | 1:15 | 47s | terminal + arbiscan cuts |
| 4 | 1:15 | 1:55 | 40s | split calculator |
| 5 | 1:55 | 2:30 | 35s | terminal + reverted-tx |
| 6 | 2:30 | 2:52 | 22s | ledger panel |
| 7 | 2:52 | 3:00 | 8s | close slide |
| **Total** |  |  | **180s** |  |

Any scene that runs long gets trimmed at the Arbiscan hold in Scene 3
(drop from 10s to 5s) or Scene 5 (drop from 5s to 3s) — both are
visual padding, not load-bearing content.
