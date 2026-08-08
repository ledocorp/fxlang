# Capability regions — scripting smoke (FX-DYN-1)

Host mints an **`FsCap`** rooted at `fixtures/`, reads under that cap, and passes
the **handle + bytes** into guest fx. Guest has **no ambient `io`**.

```text
fx run examples/cap_regions_script/main.fx            # exit 42
fx run examples/cap_regions_script/main.fx --emit-c   # exit 42

fx build examples/cap_regions_script/guest_lib.fx -o build/cap_regions_script --emit-c `
  --host examples/cap_regions_script/host.c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime
# from examples/cap_regions_script:
../../build/cap_regions_script/prog.exe fixtures/ok.txt     # exit 0
../../build/cap_regions_script/prog.exe fixtures/nope.txt   # exit 3
../../build/cap_regions_script/prog.exe ../secret.txt       # exit 5 denied
```

See `docs/specs/CAPABILITY_REGIONS_LITE.md`. Soft-fx refused — same region physics.
