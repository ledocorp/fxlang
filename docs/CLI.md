# Command-line interface

The `fx` binary in [`bin/`](../bin/) is the compiler and driver for this package.

## Everyday commands

| Command | Purpose |
|---------|---------|
| `fx doctor` | Check C toolchain + zspec paths |
| `fx version` | Print version (expect `v0.9.68`) |
| `fx help` | Show help |
| `fx new <name>` | Create a project from a scaffold |
| `fx check <file.fx>` | Parse and typecheck |
| `fx run <file.fx>` | **Auto** driver: live `sh_*` when the program fits; otherwise the built-in fallback engine (IR → native by default). Link and run (**does not forward program argv**) |
| `fx build <file.fx>` | Same backends as run (link; do not run) |
| `fx emit-c <file.fx> -o <dir>` | Emit `.c` / `.h` only (no link); `--surface` also writes `.fxsurface.*` |
| `fx surface <file.fx> [-o <dir>]` | Static module passport (JSON + Markdown) |
| `fx mod vendor\|tidy\|verify` | Offline `vendor/std` + `fx.sum` pin (checksum; see below) |
| `fx bind <header.h> --out <file.fx>` | Cleaned C header → inspectable `extern "c"` stubs (`[--module name]`) |

### `fx doctor`

Reports C toolchains on `PATH`, zspec include/library discovery, and whether `std/` facades resolve (`FX_STD_ROOT` or nearby `std/`). Exit **1** if there is no C toolchain or zspec is incomplete (link would fail). Exit **0** with an explicit hint if std is missing but CC+zspec are ok.

### `fx new`

```text
fx new hello
fx new tiny --scaffold minimal
fx new firmware --scaffold embedded
fx new mytool --scaffold cli
fx new sandbox --scaffold guest
```

| Scaffold | Intent |
|----------|--------|
| `simple` (default) | Named region + `import std/vec`; stages `std/` |
| `minimal` | Bare `main` returning 42 |
| `embedded` | Tiny arena footprint; builtin `vec_*`; no staged `std/` |
| `cli` | Result library + thin C host for argv (see `host/cli`) |
| `guest` | Caps-shaped guest + host `GuestCtx` mint (see `host/cap`) |

→ [SCAFFOLDS.md](SCAFFOLDS.md)

### `fx run` / `fx build`

```text
fx run main.fx                 # Auto driver: live sh_* when supported, else foundry
fx run main.fx --emit-c        # emit-C → native (backend)
fx run main.fx --driver foundry  # force foundry oracle
fx run main.fx --release
fx build main.fx -o out
fx run lib.fx --host host.c    # C owns process main / argv (foundry path)
```

By default, `fx run` / `fx build` use **driver Auto**: try the live `sh_*` path for supported programs; if that cannot serve the program (FX0036 / toolchain), fall back to the **built-in engine** inside `bin/fx` (CLI name: `--driver foundry` — not a separate Rust install). On that path, lowering defaults to **IR → native** when QBE is staged. Pass **`--emit-c`** for readable C. Advanced: `--backend auto|ir|c` · `--driver auto|sh|foundry`.

**Argv (frozen):** `fx run` does **not** forward program arguments into the fx program. The auto-shim is `main(void)`. Product CLIs use **`--scaffold cli`**, **`--host <file.c>`**, and shared helpers in `host/cli/` — C owns argc/argv at the process edge. → [SCAFFOLDS.md](SCAFFOLDS.md) · [WRAP.md](WRAP.md)

**Windows vs Linux IR:** Linux discovers `third_party/qbe/obj/qbe`. Windows discovers `third_party/qbe/windows/qbe.exe` when present and links native PE (`amd64_win`). On that path, the same differential set as Linux is supported (COVER **50** + **24** extras = **74**). Without `qbe.exe`, use `--emit-c`. Emit-C stays first-class on both OSes. Prebuilt compilers in this package are **Windows + Linux x86_64 only** (no macOS binary).

Useful flags:

| Flag | Meaning |
|------|---------|
| `--emit-c` | Use emit-C → native instead of IR → native |
| `--driver auto\|sh\|foundry` | Parse/emit driver (`auto` = live `sh_*` first, foundry fallback; `fx cc` defaults foundry) |
| `-o <dir>` | Output directory (default `out/`) |
| `--release` | Optimize more; less debug instrumentation |
| `--watch` | Rebuild when sources change |
| `--no-zspec` | Do not link zspec (only when appropriate) |
| `--host <file.c>` | Use this C file as `main`; link fx objects with it |
| `--link-args-file <path>` | Extra linker args, one per line |
| `--use <dir>` | Self-linking unit: include+lib dir + optional `dir/link.args` (prefer over inventing `--link-lib` lists) |
| `--link-include` / `--link-dir` / `--link-lib` | Extra include/lib paths (escape hatch) |
| `--backend auto\|ir\|c` | Advanced backend select (`auto` = IR-first with emit-C fallback) |

Default linking expects **gcc** and the zspec library that matches your OS (`build/gcc` or `build/gcc-linux`).

### `fx emit-c`

```text
fx emit-c main.fx -o out_c
fx emit-c main.fx -o out_c --debug-source   # .fxmap + #line
```

Inspect the generated C without linking. Default emit includes `/* fx: … */` annotate comments.
`--debug-source` adds a machine map for `fx locate` and debugger `#line`s.
`--surface` also writes `.fxsurface.json` + `.fxsurface.md` (types, effects, caps, regions).
→ [TRACKING.md](TRACKING.md)

### `fx surface`

```text
fx surface main.fx
fx surface main.fx -o out
```

Emits a static passport for public types and functions (effects, regions, capabilities). Does not change codegen. Companion of `fx emit-c --surface`.

### Power path: `fx cc`

Same family of flags as run/build, for hosts who want full control over emit + link.
`fx cc` uses debug-source internally so C toolchain messages can remap to `.fx`.

### Agent / editor helpers

| Command | Role |
|---------|------|
| `fx lsp` | Language server (stdio) — see [EDITOR.md](EDITOR.md) |
| `fx mcp` | Lean MCP server (`fx_check`, `fx_locate`, `fx_run`, `fx_surface`, …) |
| `fx locate --c-file <f.c> --line <n>` | Map a C line back to fx via `.fxmap` |
| `fx surface <file.fx>` | Module passport JSON + Markdown |

### `fx mod` (offline std pin)

```text
fx mod vendor    # copy std → vendor/std; write fx.sum
fx mod verify    # check fx.sum against vendor/std
fx mod tidy      # sync fx.mod require std with import scan
```

**Integrity (frozen):** `vendor/std` + `fx.sum` are a **checksum pin** for reproducibility. Compile still resolves `import std/…` via nearby `std/` or `FX_STD_ROOT` — **not** via `vendor/` yet. This is intentional: edit live `std/` while developing; vendor when you want a pinned tree you can verify. Not a download registry.

---

## Exit codes

Application `main` return values become process exit codes when you `fx run` (for example the simple scaffold returns **42**). Tooling failures use non-zero codes and print an error message. `fx doctor` exits 1 when no C toolchain is found.
