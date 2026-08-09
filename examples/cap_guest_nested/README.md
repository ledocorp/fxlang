# cap_guest_nested

Host-only smoke for **nested `GuestCtx`**: child sessions under a parent; parent `end` cascades revoke.

```text
gcc -I../../host/cap -I../../host/cli host.c ../../host/cap/fx_cap_runtime.c -o nested_probe
```

Exit **0** = nested mint/read, child-end stale deny, parent-end cascade deny.

Also covers NetCap mint + allow check + revoke (no dial). Not language concurrency.
