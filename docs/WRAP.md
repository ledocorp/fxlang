# Wrapping C: host `main` + fx library

fx’s only FFI is the C ABI. That is intentional: wrap mature C, emit readable C, and let other
languages reach fx output through their own C interop.

Canonical web copy: https://www.ledocorp.org/fx/docs/wrap/

## Two ownership patterns

- **fx owns main** · normal `fx run main.fx` (scaffolds)
- **C owns main** · `fx run lib.fx --host host.c` · fx exports functions C calls

For argv CLIs, prefer the shared helpers in `examples/cli_host/fx_cli_host.h`
(fx owns logic; C owns argv / usage / stderr / exit). See dogfood App 2/4/5 hosts.

## Bundled demos

```text
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
```

Expected exit code **42**.

| File | Role |
|------|------|
| `examples/showcase_wrap/compute.fx` | fx functions (`score`, `clamp01`) |
| `examples/showcase_wrap/host.c` | C `main` that calls into fx |

Larger WRAP footholds (dual-path → **42**):

| Example | What it wraps |
|---------|----------------|
| `examples/wrap_sqlite/` | SQLite amalgamation — `:memory:` open / exec / query |
| `examples/wrap_llhttp/` | llhttp — parse-only Content-Length (optional NetCap allow host) |

Priorities and honesty bounds: [LIBRARIES.md](LIBRARIES.md).

## Declaring C functions from fx

```fx
extern "c" {
    fn puts(s: string) -> i32;
    fn sha256_hex_equals(msg: string, expected: string) -> i32;
}
```

fx emits a prototype and expects the real symbol at link time.
Provide the implementation via **`--use <dir>`** (preferred for native libs), `--host`, and/or `--link-args-file` / `--link-lib` / `--link-dir`.

## Self-linking folders (`--use`) — FX-HOST-LINK

Ship headers + `.a`/`.lib` + a `link.args` beside them. Do **not** invent OS system-lib lists in chat.

```text
fx run app.fx --host host.c --use ./third_party/raylib/src --emit-c
```

`--use <dir>` adds include + library search for `<dir>` and expands `<dir>/link.args` when present (same format as `--link-args-file`). Notice on stderr: `fx: --use … (loaded link.args)`.

Golden: `examples/gui_microui/` — prefer `--use …/raylib/src`. Host+GUI: prefer **`--emit-c`** until IR host/struct parity is claimed.

Escape hatch: raw `--link-include` / `--link-dir` / `--link-lib` / `--link-args-file`.

## Related flags

```text
fx run lib.fx --host host.c
fx run app.fx --host host.c --use ./lib_unit --emit-c
fx build lib.fx --host host.c -o out
fx run lib.fx --link-args-file link.args
fx emit-c lib.fx -o out_c
```

Full flag list: [CLI.md](CLI.md).

## Why this matters

- Reuse existing C libraries with a thin host instead of rewriting everything
- Keep policy and algorithms in fx with visible effects and regions
- Inspect emitted C with `fx emit-c` when you want to see the lowering

## Generating Level 1 stubs (`fx bind`)

```text
fx bind path/to/cleaned.h --out lib_raw.fx [--module name]
```

Produces inspectable `extern "c"` stubs (skips macros / unknown types as comments).
Smoke: `examples/bind_smoke` — `fx run main.fx --link host.c` (exit 42).
Level 2 (hand-written Result wrapper over real lib): `examples/bind_stb_sprintf` — bind stubs → `stb_safe` → stb_sprintf shim (exit 42).

## Honesty bound

- C FFI works; `fx bind` covers Level 1 raw stubs — ownership policy is not invented for you
- Level 2 wrappers stay hand-written (see `bind_stb_sprintf/stb_safe.fx`)
- There is no direct Rust/Go/Zig FFI · those ecosystems speak C on their side
- `std/io` itself uses `extern "c"` for host puts / file ops

## Checklist: new `--link` example

When you add an `examples/*` tree with `main.fx` that needs C sidecars:

1. Document the exact `fx run` / `fx build` link line in that example’s README.  
2. Confirm both `fx run` and `fx run --emit-c` when you claim dual-path quality.  
3. Keep host/link flags next to the example so strangers can copy them without hunting.

## What’s next for wraps

Priority list (JSON deepen, fs/paths, hashes, compress, backlog items such as
package managers and large SDKs): [LIBRARIES.md](LIBRARIES.md).
Overall sequence: [NEXT.md](NEXT.md).
