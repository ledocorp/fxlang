# cap_guest_reload - reload-shaped guest sessions

Two independent host sessions: **begin → mint → run → end → stale deny**, twice.

Shows the sandbox mental model without a second language:

- throwaway guest work
- kill / revoke caps between sessions
- start again with a fresh context (reload-shaped)

Guest uses `std/io_cap` only (ambient `std/io` rejected by `--host` / `--guest`).

```text
fx run examples/cap_guest_reload/main.fx          # dual-path score → 42
fx build examples/cap_guest_reload/guest_lib.fx -o build/cap_guest_reload --emit-c `
  --host examples/cap_guest_reload/host.c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime
# then run build/cap_guest_reload/prog.exe  → exit 0
```

Negative fixture (must fail with FX0031):

```text
fx check examples/cap_guest_reload/fixtures_err/guest_with_std_io.fx --guest
```
