# Guest context smoke

Host owns a **guest session**: bump arena + minted caps. `fx_guest_end` frees the
arena and **revokes** caps (stale handles → deny **5**). Guest uses `io_cap` only
- no ambient `std/io`. Same region / slot-mut physics; Soft-fx refused.

```text
fx run examples/cap_guest_ctx/main.fx            # exit 42
fx run examples/cap_guest_ctx/main.fx --emit-c   # exit 42

fx build examples/cap_guest_ctx/guest_lib.fx -o build/cap_guest_ctx --emit-c `
  --host examples/cap_guest_ctx/host.c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime

# from examples/cap_guest_ctx:
../../build/cap_guest_ctx/prog.exe                 # session + teardown deny → 0
../../build/cap_guest_ctx/prog.exe fixtures/ok.txt # live run → 0
../../build/cap_guest_ctx/prog.exe fixtures/nope.txt # guest reject → 3
../../build/cap_guest_ctx/prog.exe ../secret.txt     # deny → 5
```

API: `std/guest.fx` + `examples/cap_runtime` (`fx_guest_begin` / `mint_*` / `end`).
See `docs/specs/CAPABILITY_REGIONS_LITE.md` Phase B.
