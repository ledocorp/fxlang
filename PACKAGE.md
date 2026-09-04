# Package contents

**Version:** 0.9.69 (see [VERSION](VERSION))  

**Copyright:** Shawn Londono · LedoCorp · http://www.ledocorp.org · GPL-3.0  

This repository is the **fx language package**: everything you need to install the compiler and write programs.

**No Rust source is shipped here.** The package is a native `bin/fx` (+ headers, `std/`, scaffolds, inspectable `compiler-source/*.fx`). Users need **gcc**, not a Rust toolchain.

**Prebuilt platforms:** Windows + Linux **x86_64** only. There is **no** macOS `bin/fx` in this package.

## Layout

| Path | Role |
|------|------|
| `bin/fx.exe` | Compiler (Windows x86_64) |
| `bin/fx` | Compiler (Linux x86_64) |
| `build/gcc/libzspec.a` | zspec library (Windows / MinGW) |
| `build/gcc-linux/libzspec.a` | zspec library (Linux) |
| `zspec/include/zspec/` | C headers for linking emitted C |
| `scaffolds/` | Templates used by `fx new` |
| `std/` | Standard library (fx modules) |
| `host/cap/` | Guest / capability session runtime (+ NetCap dial shim) |
| `host/cli/` | Shared argv / exit helpers for thin C hosts |
| `host/process/` | Shared OS process edge (spawn / mkdir / cwd) |
| `host/concur/` | Structured concurrency substrate (nursery, chan, select, …) |
| `host/std_time/` · `host/std_env/` · `host/std_fs_walk/` | Thin host shims for time / env / walk |
| `docs/` | User documentation (incl. `docs/releases/`) |
| `examples/` | Optional demos (caps, concur, assure, wraps, …) |
| `compiler-source/` | Inspectable fx compiler modules (read-only; not how you run fx) |
| `third_party/qbe/obj/qbe` | Linux QBE (IR → native on Linux) |
| `third_party/qbe/windows/qbe.exe` | Windows QBE when staged (IR → PE, `amd64_win`); if missing, use `--emit-c` |
| `LICENSE` / `NOTICE` | GPL-3.0 |
| `docs/LICENSES.md` | Third-party open-source inventory (QBE, …) |
| `CONTRIBUTING.md` / `SECURITY.md` | Project policy |

## How to use it

1. Put `bin/` on your `PATH` (or invoke `bin/fx` / `bin/fx.exe` directly).  
2. Run `fx doctor`, then install **gcc** if needed.  
3. `fx new hello` → `fx run main.fx`.

Start here: [docs/START_HERE.md](docs/START_HERE.md)

Release notes: [docs/releases/0.9.69.md](docs/releases/0.9.69.md)
