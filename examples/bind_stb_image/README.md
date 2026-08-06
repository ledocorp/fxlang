# stb_image bind (STD-2)

Safe fx wrapper over vendored **stb_image** (public domain) via the in-tree FFI shim.

```text
fx run main.fx `
  --link <repo>/fx-compiler/tests/fixtures/ffi/stb_image_ref.c `
  --link-include <repo>/fx-compiler/tests/fixtures/ffi `
  --link-lib m

fx run main.fx --emit-c --link ... --link-include ... --link-lib m
```

Exit **42** on successful 1×1 PNG decode. `--link-lib m` is required for the IR→native link (stb uses `pow`).
