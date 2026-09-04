# Start here

Welcome to **fx**: a systems language with visible memory and dual emission to readable C.

**Version:** 0.9.69 · Copyright © 2026 Shawn Londono · LedoCorp · GPL-3.0  

**Site:** http://www.ledocorp.org/fx/ · **Package:** https://github.com/ledocorp/fxlang

---

## What you need

1. **This repository** (compiler in `bin/`, plus `std/`, scaffolds, headers).  
2. A **C toolchain** on your `PATH` for linking. **gcc** is the default today.  
3. **Windows** or **Linux x86_64** for the prebuilt compiler in this release — **macOS is not shipped** as a prebuilt (build from source elsewhere if needed).

No other language toolchain is required to write and run fx programs.

Check your machine:

```text
fx doctor
```

---

## Five-minute hello

```text
# Put package bin/ on PATH (zspec is found next to bin/, any cwd):
fx version                    # expect v0.9.69
fx doctor

fx new hello
cd hello
fx run main.fx                # Auto: live sh_* when supported, else foundry (IR/emit-C); expect exit 42
fx run main.fx --emit-c       # optional: force emit-C backend (also the fallback if QBE is missing)
```

**Argv:** `fx run` does **not** pass program arguments into your fx `main`. For CLIs, use `fx new mytool --scaffold cli` then `fx build … --cli` (autohost argv). Or `fx build … --host host.c` for WRAP/GUI. → [CLI.md](CLI.md) · [SCAFFOLDS.md](SCAFFOLDS.md)

**IR on Windows and Linux:** Linux uses `third_party/qbe/obj/qbe`. Windows uses `third_party/qbe/windows/qbe.exe` when that file is in the package (native PE, `amd64_win`). The same everyday programs run on both paths. If `qbe.exe` is absent, pass `--emit-c`. Emit-C stays first-class either way.

Windows without PATH:

```text
.\bin\fx.exe doctor
.\bin\fx.exe new hello
cd hello
..\bin\fx.exe run main.fx     # or absolute path to bin\fx.exe
```

Linux without PATH:

```text
./bin/fx doctor
./bin/fx new hello
cd hello
../bin/fx run main.fx
```

### What just happened?

`fx new` wrote a **simple** scaffold: a named `region`, `effects { alloc, mut }`, `import std/vec`, and grow via **`v.push`** (same physics as `vec_push` / reassign — not Soft-fx). That is the recommended starting point: Go-feel lifetimes, not a GC.

Try other shapes:

```text
fx new tiny --scaffold minimal      # no default region
fx new firmware --scaffold embedded # small arena, no staged std
fx new mytool --scaffold cli        # Result library; build with --cli (alias: tool)
fx new sandbox --scaffold guest     # caps-shaped guest + host session
```

→ [SCAFFOLDS.md](SCAFFOLDS.md)

---

## Where things live

| You want… | Look here |
|-----------|-----------|
| **What’s next** | [NEXT.md](NEXT.md) |
| **Quality habits** | [QUALITY.md](QUALITY.md) |
| **Planned dogfood apps** | [DOGFOOD.md](DOGFOOD.md) |
| **C library wrap priorities** | [LIBRARIES.md](LIBRARIES.md) |
| **Everything that exists (cheatsheet)** | [SURFACE.md](SURFACE.md) |
| **How to compose hard programs** | [COMPOSITION.md](COMPOSITION.md) |
| **Map C errors back to fx** | [TRACKING.md](TRACKING.md) |
| Understand the language | [LANGUAGE.md](LANGUAGE.md) |
| Compact reference | [REFERENCE.md](REFERENCE.md) |
| Regions / effects / ownership | [REGIONS.md](REGIONS.md) |
| `import std/…` | [STD.md](STD.md) |
| Commands and flags | [CLI.md](CLI.md) |
| Call fx from C / wrap a library | [WRAP.md](WRAP.md) |
| Project templates | [SCAFFOLDS.md](SCAFFOLDS.md) |
| Copy-paste demos | [../examples/](../examples/) |
| What’s in the repo | [../PACKAGE.md](../PACKAGE.md) |
| Web docs (same content) | https://www.ledocorp.org/fx/docs/ |
| Read compiler modules (fx) | [../compiler-source/](../compiler-source/) |

---

## Linking notes

When `fx run` or `fx build` links:

- Include path: `zspec/include/`  
- Library: `build/gcc/libzspec.a` (Windows) or `build/gcc-linux/libzspec.a` (Linux)

If linking fails with “gcc not found,” install a C compiler and ensure it is on your `PATH`. Run `fx doctor` to confirm.

---

## Contributing

Pull requests are **not** accepted. Bug reports via GitHub Issues are OK for now. See [CONTRIBUTING.md](../CONTRIBUTING.md).
