# Wrapping C: host `main` + fx library

fx’s only FFI is the C ABI. That is intentional: wrap mature C, emit readable C, and let other
languages reach fx output through their own C interop.

Canonical web copy: https://www.ledocorp.org/fx/docs/wrap/

## Two ownership patterns

- **fx owns main** · normal `fx run main.fx` (scaffolds)
- **C owns main** · `fx run lib.fx --host host.c` · fx exports functions C calls

## Bundled demo

```text
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
```

Expected exit code **42**.

| File | Role |
|------|------|
| `examples/showcase_wrap/compute.fx` | fx functions (`score`, `clamp01`) |
| `examples/showcase_wrap/host.c` | C `main` that calls into fx |

## Declaring C functions from fx

```fx
extern "c" {
    fn puts(s: string) -> i32;
    fn sha256_hex_equals(msg: string, expected: string) -> i32;
}
```

fx emits a prototype and expects the real symbol at link time.
Provide the implementation via `--host` and/or `--link-args-file` / `--link-lib` / `--link-dir`.

## Related flags

```text
fx run lib.fx --host host.c
fx build lib.fx --host host.c -o out
fx run lib.fx --link-args-file link.args
fx emit-c lib.fx -o out_c
```

Full flag list: [CLI.md](CLI.md).

## Why this matters

- Reuse existing C libraries with a thin host instead of rewriting everything
- Keep policy and algorithms in fx with visible effects and regions
- Inspect emitted C with `fx emit-c` when you want to see the lowering

## Honesty bound

- C FFI works; large-library wrapping is still **manual** (no wrapper generator yet)
- There is no direct Rust/Go/Zig FFI · those ecosystems speak C on their side
- `std/io` itself uses `extern "c"` for host puts / file ops
