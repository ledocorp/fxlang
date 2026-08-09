# host/cap - guest + capability runtime

Compile `fx_cap_runtime.c` into host apps (or language spokes).

```text
gcc -Ihost/cap your_host.c host/cap/fx_cap_runtime.c -o your_app
```

Supports nested guest sessions, FsCap / OutCap / AllocCap / FuelCap, and NetCap
allowlists (`fx_guest_mint_netcap` + `fx_netcap_allows` - no dial). ABI stamp:
`FX_HOST_SPINE_ABI` in `fx_cap_runtime.h`.
