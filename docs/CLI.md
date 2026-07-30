# Command-line interface

The `fx` binary in [`bin/`](../bin/) is the compiler and driver for this package.

## Everyday commands

| Command | Purpose |
|---------|---------|
| `fx doctor` | Check C toolchain + zspec paths |
| `fx version` | Print version (expect `v0.7.3`) |
| `fx help` | Show help |
| `fx new <name>` | Create a project from a scaffold |
| `fx check <file.fx>` | Parse and typecheck |
| `fx run <file.fx>` | Emit C, link, run |
| `fx build <file.fx>` | Emit C and link (do not run) |
| `fx emit-c <file.fx> -o <dir>` | Emit `.c` / `.h` only |

### `fx doctor`

Reports C toolchains on `PATH`, zspec include/library discovery, and whether `std/` facades resolve (`FX_STD_ROOT` or nearby `std/`). Exit **1** if there is no C toolchain or zspec is incomplete (link would fail). Exit **0** with an explicit hint if std is missing but CC+zspec are ok.

### `fx new`

```text
fx new hello
fx new tiny --scaffold minimal
fx new firmware --scaffold embedded
```

| Scaffold | Intent |
|----------|--------|
| `simple` (default) | Named region + `import std/vec`; stages `std/` |
| `minimal` | Bare `main` returning 42 |
| `embedded` | Tiny arena footprint; builtin `vec_*`; no staged `std/` |

→ [SCAFFOLDS.md](SCAFFOLDS.md)

### `fx run` / `fx build`

```text
fx run main.fx
fx run main.fx --release
fx build main.fx -o out
```

Useful flags:

| Flag | Meaning |
|------|---------|
| `-o <dir>` | Output directory (default `out/`) |
| `--release` | Optimize more; less debug instrumentation |
| `--watch` | Rebuild when sources change |
| `--no-zspec` | Do not link zspec (only when appropriate) |
| `--host <file.c>` | Use this C file as `main`; link fx objects with it |
| `--link-args-file <path>` | Extra linker args, one per line |
| `--link-include` / `--link-dir` / `--link-lib` | Extra include/lib paths |

Default linking expects **gcc** and the zspec library that matches your OS (`build/gcc` or `build/gcc-linux`).

### `fx emit-c`

```text
fx emit-c main.fx -o out_c
```

Inspect the generated C without linking.

### Power path: `fx cc`

Same family of flags as run/build, for hosts who want full control over emit + link.

### Agent / editor helpers

| Command | Role |
|---------|------|
| `fx lsp` | Language server (stdio) |
| `fx mcp` | Lean MCP server (`fx_check`, `fx_locate`, `fx_run`, …) |
| `fx locate --c-file <f.c> --line <n>` | Map a C line back to fx via `.fxmap` |

---

## Exit codes

Application `main` return values become process exit codes when you `fx run` (for example the simple scaffold returns **42**). Tooling failures use non-zero codes and print an error message. `fx doctor` exits 1 when no C toolchain is found.
