# stb_image bind

Safe fx wrapper over vendored **stb_image** (public domain) via the in-tree FFI shim.

```text
fx run main.fx `
 --link host/stb_image_ref.c `
 --link-include host `
 --link-lib m

fx run main.fx --emit-c --link ... --link-include ... --link-lib m
```

Adjust `--link` / `--link-include` to the shim paths shipped with this example (or your local copies). Exit **42** on successful 1×1 PNG decode. `--link-lib m` is required for the IR→native link (stb uses `pow`).
