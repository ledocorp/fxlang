# Package contents

**Version:** 0.9.0 (see [VERSION](VERSION))  

**Copyright:** Shawn Londono · LedoCorp · http://www.ledocorp.org · Apache-2.0  

This repository is the **fx language package**: everything you need to install the compiler and write programs.

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
| `docs/` | User documentation (incl. `docs/releases/`) |
| `examples/` | Optional demos |
| `compiler-source/` | Inspectable fx compiler modules (read-only; not how you run fx) |
| `third_party/qbe/obj/qbe` | Linux QBE (IR → native on Linux) |
| `third_party/qbe/windows/qbe.exe` | Windows QBE when staged (IR → PE, `amd64_win`); if missing, use `--emit-c` |
| `LICENSE` / `NOTICE` | Apache-2.0 |
| `docs/LICENSES.md` | Third-party open-source inventory (QBE, …) |
| `CONTRIBUTING.md` / `SECURITY.md` | Project policy |

## How to use it

1. Put `bin/` on your `PATH` (or invoke `bin/fx` / `bin/fx.exe` directly).  
2. Run `fx doctor`, then install **gcc** if needed.  
3. `fx new hello` → `fx run main.fx`.

Start here: [docs/START_HERE.md](docs/START_HERE.md)
