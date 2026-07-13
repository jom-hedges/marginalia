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


