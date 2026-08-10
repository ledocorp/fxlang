# cap_guest_fxhost

Fx-hosted guest session: `guest.begin` → `mint_fs` → `guest_lib.run` → `guest.end` → stale deny **5**.

No C `host.c` driver - proves B.1 APIs work from fx before B.2 keyword sugar.

```powershell
# Dual-path score
fx run examples/cap_guest_fxhost/main.fx

# Session probe (link cap runtime)
fx build examples/cap_guest_fxhost/host_main.fx -o build/cap_guest_fxhost --emit-c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime
# run from example dir so fixtures/ resolves
```
