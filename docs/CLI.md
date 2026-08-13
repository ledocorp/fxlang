# Command-line interface

The `fx` binary in [`bin/`](../bin/) is the compiler and driver for this package.

## Everyday commands

| Command | Purpose |
|---------|---------|
| `fx doctor` | Check C toolchain + zspec paths |
| `fx version` | Print version (expect `v0.9.66`) |
| `fx help` | Show help |
| `fx new <name>` | Create a project from a scaffold |
| `fx check <file.fx>` | Parse and typecheck |
| `fx run <file.fx>` | IR → native (default); link and run (**does not forward program argv**) |
| `fx build <file.fx>` | Same backends as run (link; do not run) |
| `fx emit-c <file.fx> -o <dir>` | Emit `.c` / `.h` only (no link) |
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
fx run main.fx                 # IR → native (default)
fx run main.fx --emit-c        # emit-C → native
fx run main.fx --release
fx build main.fx -o out
fx run lib.fx --host host.c    # C owns process main / argv
```

By default, `fx run` / `fx build` lower through the **IR → native** path. Pass **`--emit-c`** to use the readable C emission path instead (same checked program, different lowering). Advanced: `--backend auto|ir|c`.

**Argv (frozen):** `fx run` does **not** forward program arguments into the fx program. The auto-shim is `main(void)`. Product CLIs use **`--scaffold cli`**, **`--host <file.c>`**, and shared helpers in `host/cli/` — C owns argc/argv at the process edge. → [SCAFFOLDS.md](SCAFFOLDS.md) · [WRAP.md](WRAP.md)

**Windows vs Linux IR:** Linux discovers `third_party/qbe/obj/qbe`. Windows discovers `third_party/qbe/windows/qbe.exe` when present and links native PE (`amd64_win`). On that path, the same differential set as Linux is supported (COVER **50** + **24** extras = **74**). Without `qbe.exe`, use `--emit-c`. Emit-C stays first-class on both OSes. Prebuilt compilers in this package are **Windows + Linux x86_64 only** (no macOS binary).

Useful flags:

| Flag | Meaning |
|------|---------|
| `--emit-c` | Use emit-C → native instead of IR → native |
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
→ [TRACKING.md](TRACKING.md)

### Power path: `fx cc`

Same family of flags as run/build, for hosts who want full control over emit + link.
`fx cc` uses debug-source internally so C toolchain messages can remap to `.fx`.

### Agent / editor helpers

| Command | Role |
|---------|------|
| `fx lsp` | Language server (stdio) — see [EDITOR.md](EDITOR.md) |
| `fx mcp` | Lean MCP server (`fx_check`, `fx_locate`, `fx_run`, …) |
| `fx locate --c-file <f.c> --line <n>` | Map a C line back to fx via `.fxmap` |

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
