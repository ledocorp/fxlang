# cap_alloc_budget

Budgeted guest allocation via host-minted `AllocCap`.

## Truth

- Host: `fx_guest_begin` → `fx_guest_mint_alloccap(budget)` → guest `try_alloc`
- Over-budget and post-`end` → deny **5**
- Session `fx_guest_alloc` remains for host scratch; guest dogfood uses AllocCap only
- same bump arena physics

## Run

```powershell
.\scripts\test-cap-regions-smoke.ps1 # includes this example
```

Or manually: `fx run main.fx` → 42; host probe via smoke script.
