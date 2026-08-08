# cap_dogfood_jsonget (FX-DYN-6)

App 2 (JSON path) as a **guest under FsCap** — teachable sandbox on a real dogfood slice.

## Truth

- Guest reads only via `io_cap` + host-minted `FsCap` (no ambient `std/io`)
- Path extract uses the same `cjson_safe` facade as `dogfood_jsonget`
- Session: begin → mint → run(sample) → escape deny → end → stale deny; two sessions
- Process-trust CLI (`dogfood_jsonget`) stays ambient for non-sandbox hosts

## Run

```powershell
.\scripts\test-cap-regions-smoke.ps1
```
