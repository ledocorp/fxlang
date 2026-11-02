# wire_smoke

Monorepo T3 smoke for `std/wire` endian load foothold. Not staged to fxlang T0.

```text
fx run examples/wire_smoke/main.fx
fx run examples/wire_smoke/main.fx --emit-c
```

Expect exit **42** on `--emit-c`. IR is **out-of-claim** for this foothold (skipped in IR COVER); deepen under a later pull.
