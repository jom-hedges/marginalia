## 2026-06-04
Worked on tonight
- brief feedback generator
- wired up Req
- blocker: can a local LLM generate feedback that would actually save me time grading?
- next session: create a liveview with textarea, handle analysis

## 2026-06-19
An entry from last week did not get pushed. 
Here is the notes from last week, and this week.
- wired up a liveview with textarea
- goal for next session: handle response and streaming in UI
- goal next session: add non-streaming fallback endpoint
- blockers: currently some compilation errors surrounding the case statement in Ollama.client


## 2026-07-13
A month long break to focus on Osmanthus.
I think settling on OWL for a name might be good.
Like the Online Writing Lab
This program seems like an updated version of tech in the Writing Center

### [Ollama Client] Streaming buffer fixes
- root caused intermittent parse errors in `parse_chunk/1`: Req's `into:` chunks don't align with Ollama's NDJSON line boundaries
- Therefore, I added a buffer `acc <> chunk` in the client and `split_complete_lines/1` to only give `parse_chunk/1` complete lines.

Added `:done` handling:
- `parse_chunk/1` now matches `%{"done" => true}` explicitly, and returns `{:done, final}`
- which the client turns into `send(pid, :done)`, so LiveView knows the stream ended

Wired up the `Req.post/2` return value instead of dropping it - non-200 statuses and conn errors now get sent to`pid`

Goal for next session 
- confirm the `Req` version and whether `into:` needs an explicit initial accumulator or a bare function - accumulator start value needs verifying before trusting the buffer logic end-to-end

## 2026-07-14
Blocker: This morning I switched to my laptop. Earlier in the month, I updated to OTP 29, which unknowingly conflicted with my local Elixir toolchain. I aligned Elixir and OTP 29, so `mix phx.server` could run.
For today's session, I will write contexts for for submissions and assignments schema 



# [Security] cowlib advisory GHSA-g2wm-735q-3f56 — acknowledged, not reachable. July 14, 2026

- cowlib 2.18.0 (latest on hex.pm) still carries this advisory as of
  July 2026; no patched release exists yet upstream.
- Assessed exposure: app does not construct cookies from
  user-controlled input (student submission text goes to DB/LiveView,
  not headers/cookies). Not reachable in our code paths.
- Ignoring via `mix deps.audit --ignore-advisory-ids ...` until
  upstream ships a fix. Revisit: check hex.pm/packages/cowlib
  periodically for a new release referencing this CVE.

- Req 0.5.18: HIGH (decompression bomb DoS, CVE-2026-49755) and LOW
  (multipart header injection, CVE-2026-49756). Fixed in 0.6.1+.
  Action: `mix deps.update req` (pin `~> 0.6.2`), then re-test
  Ollama streaming client — 0.5→0.6 is a minor bump pre-1.0, check
  changelog for `into:`/accumulator behavior changes before trusting
  the buffer logic end-to-end.
