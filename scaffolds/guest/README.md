# Guest scaffold

Caps-shaped guest: host mints `GuestCtx` + `FsCap`; guest has **no** ambient `std/io`.

```text
fx build guest_lib.fx -o out --emit-c --host host.c `
  --link host/cap/fx_cap_runtime.c --link-include . --link-include host/cap
./out/prog    # expect exit 42 (Ok payload)
```

Staged: `std/cap.fx`, `fx_cli_host.h`, `host/cap/fx_cap_runtime.{h,c}`.
