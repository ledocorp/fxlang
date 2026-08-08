# cap_guest_compose (FX-DYN-4)

Compose **FsCap + AllocCap** in one guest `run`, with reload-shaped dual sessions.

## Truth

- Guest reads under FsCap and scratch-allocates under AllocCap only
- Session `alloc_bytes` / `fx_guest_alloc` are host scratch — not used in guest libs
- Two sessions: begin → mint both → run → over-budget deny → end → stale deny
- Soft-fx refused

## Run

```powershell
.\scripts\test-cap-regions-smoke.ps1
```
