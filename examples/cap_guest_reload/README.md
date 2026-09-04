# cap_guest_reload - reload-shaped guest sessions

Two independent host sessions: **begin → mint → run → end → stale deny**, twice.

Shows the sandbox mental model without a second language:

- throwaway guest work
- kill / revoke caps between sessions
- start again with a fresh context (reload-shaped)

Guest uses `std/io_cap` only (ambient `std/io` rejected by `--host` / `--guest`).

**Host stay-up** (keep a C window / process while reminting guests) is documented on
`examples/guest_plugin/README.md` - remint is the semantic reload; rebuilding the guest
TU + re-link is the default way to pick up edited `.fx`. Shared-lib swap is **not** the
product default.

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
