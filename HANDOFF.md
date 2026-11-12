# Handoff — São Paulo submission actions

Everything Phase 0 produced lives in this branch
(`claude/saopaulo-phase-0`). Everything that still has to happen
between now and the **Mar 1, 2027 03:59 UTC** submission close needs
either your hands or on-chain gas on your keys. This file is the
checklist.

Last updated: 2026-11-12. Items checked (`[x]`) as of commit
`5433a91`.

---

## Immediate · now

- [ ] **Push the branch.**
  ```bash
  git push -u origin claude/saopaulo-phase-0
  ```
  Nothing below works until the branch is on GitHub.

- [ ] **Add three Actions secrets** (Settings → Secrets and variables
      → Actions → Repository secrets):
  | Name | Value | Notes |
  | --- | --- | --- |
  | `DEPLOYER_PRIVATE_KEY` | key for `0xe10CFF27…24A4` | matches `releaseAuth` in `deployments/421614.json`; already holds ~3.6 USDC + gas |
  | `BUYER_PRIVATE_KEY` | key for `0xB15Ecd8E…7380` | burner from the Singapore cycle; currently 8.1 USDC → good for ~8 cron fires before refill from https://faucet.circle.com |
  | `ARBITRUM_SEPOLIA_RPC` | *(optional)* Alchemy/QuickNode URL | only if the public RPC starts rate-limiting the cron |

- [ ] **Smoke-test the cron** manually. GitHub → Actions → `saopaulo-runner`
      → **Run workflow** on `claude/saopaulo-phase-0`. A green run
      appends a row to `LEDGER.md` and pushes it back to the branch.

- [ ] **Confirm Vercel redeploys `demo/ui/index.html`.** The site at
      kajota-mesh.vercel.app auto-deploys on any push that touches
      `demo/ui/` — the `#runner` ledger panel appears on the next
      load after Vercel's build completes (~45s).

## HackQuest project page · this week

- [ ] Decide between (a) a fresh São Paulo project page on HackQuest
      or (b) re-attaching the existing kajota-mesh page from the
      Singapore cycle to the São Paulo event. Option (b) preserves
      hearts/feedback history; option (a) avoids confusion if judges
      skim both.
- [ ] Paste the body of `SUBMISSION_WRITEUP.md` into the HackQuest
      project description field. Trim if the field's cap is < 2,470
      chars (current body is right at that).
- [ ] Project Link → `https://github.com/KaJota-inc/kajota-arbitrum-dubai`
- [ ] Demo URL → `https://kajota-mesh.vercel.app`
- [ ] Video URL → leave blank until the Dec 1-3 recording lands.

## Demo video · Dec 1-3

- [ ] Record VO against [`demo/VOICEOVER.md`](demo/VOICEOVER.md) in
      a 48kHz mono WAV. One take if you can; the script tolerates
      ±1s drift per scene.
- [ ] Capture scenes per [`demo/SHOT_LIST.md`](demo/SHOT_LIST.md).
      Do-Not-Disturb on, no OS notifications, terminal at 1280x720
      with font size 16+.
- [ ] Cut + caption + mux (DaVinci Resolve or your pick). Hard cap
      3:00; `SHOT_LIST.md` names two trim points if any scene runs
      long.
- [ ] Upload to HackQuest's CDN, add the URL to the project page's
      Video field. Oct 4 pattern: CDN upload latency ran ~2 hours.

## Monitor · passive between now and Mar 1

- [ ] **Stylus `#146`** — [issue thread](https://github.com/OffchainLabs/stylus-sdk-rs/issues/146).
      Comment posted by `KaJota-inc` on Nov 3, 2026. If a maintainer
      replies greenlighting the design change, the draft PR in
      [`UPSTREAM_PR.md`](../dubai-phase-0-24172d/UPSTREAM_PR.md)
      ships as Move 3 of the winning playbook. Drop criterion is
      **Dec 15, 2026** (relaxed from the Dubai Nov 10 gate).
- [ ] **LEDGER.md** — the cron commits a new row daily. If the row
      stops appearing for 3+ days, the buyer burner is dry or the
      workflow broke; check Actions logs.
- [ ] **HackQuest Prizes & Judging tab** — re-check early Feb 2027
      for silently added tracks or bonus clauses per `OQ-8` in the
      [[hackathon_arbitrum_sao_paulo]] memory. The rubric was
      verbatim-identical to Singapore at the Nov 3 scouting pass.

## Final · Feb 26 – Mar 1, 2027

- [ ] **Feb 26** — submit on HackQuest 48 h early. Freeze any new
      commits except typo/link-health fixes.
- [ ] **Verify in a fresh incognito session** that the HackQuest
      submission renders complete and public (every link, every
      image, every tx hash resolvable without authentication).
- [ ] **Mar 1 03:59 UTC** — submission closes.
- [ ] **Mar 8 18:00** — reward announcement. Record outcome in
      [[hackathon_arbitrum_sao_paulo]] memory. If win, ping the
      hackathon desk coordinator with the ASP milestone update.

## Not-in-scope reminders

- Don't register the hackathon from an automation — do it manually
  at `arbitrum-sao-paulo.hackquest.io` so the account trail is
  clean.
- Don't push force to `main`. If you need to merge `claude/
  saopaulo-phase-0` → `main`, do it via a PR (preserves the commit
  history + attribution footers).
- Don't rename the GitHub repo. Keep it `kajota-arbitrum-dubai` per
  the [[hackathon_arbitrum_sao_paulo]] memory decision — a rename
  would break the Arbiscan source-verification links embedded in
  the Singapore manifest (`deployments/421614.json`).
