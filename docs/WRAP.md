# Wrapping C: host `main` + fx library

fx is comfortable living **beside** C. A common pattern:

- **C** owns `main` and process startup.  
- **fx** owns pure logic (scoring, validation, data transforms, …).  
- `fx run … --host …` emits fx to C objects and links them with your host file.

## Try the bundled demo

```text
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
```

Expected exit code **42**.

| File | Role |
|------|------|
| [`examples/showcase_wrap/compute.fx`](../examples/showcase_wrap/compute.fx) | fx functions (`score`, `clamp01`) |
| [`examples/showcase_wrap/host.c`](../examples/showcase_wrap/host.c) | C `main` that calls into fx |

## Why this matters

- Reuse **existing C libraries** by writing a thin host (or extern declarations) instead of rewriting everything.  
- Keep policy/algorithms in fx with visible effects/regions.  
- Inspect emitted C with `fx emit-c` when you want to see the lowering.

## Related flags

```text
fx run lib.fx --host host.c
fx build lib.fx --host host.c -o out
fx run lib.fx --link-args-file link.args
```

→ [CLI.md](CLI.md) · [examples/README.md](../examples/README.md)
