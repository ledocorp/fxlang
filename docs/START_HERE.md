# Start here

Welcome to **fx**: a systems language with visible memory and dual emission to readable C.

**Version:** 0.9.1 · Copyright © 2026 Shawn Londono · LedoCorp · Apache-2.0  

**Site:** http://www.ledocorp.org

---

## What you need

1. **This repository** (compiler in `bin/`, plus `std/`, scaffolds, headers).  
2. A **C toolchain** on your `PATH` for linking. **gcc** is the default today.  
3. **Windows** or **Linux x86_64** for the prebuilt compiler in this release.

No other language toolchain is required to write and run fx programs.

Check your machine:

```text
fx doctor
```

---

## Five-minute hello

```text
# Put package bin/ on PATH (zspec is found next to bin/, any cwd):
fx version                    # expect v0.9.1
fx doctor

fx new hello
cd hello
fx run main.fx                # IR → native when QBE is in the package; expect exit 42
fx run main.fx --emit-c       # optional: readable C path (also the fallback if QBE is missing)
```

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

`fx new` wrote a **simple** scaffold: a named `region`, `effects { alloc, mut }`, and `import std/vec`. That is the recommended starting point: Go-feel lifetimes, not a GC.

Try other shapes:

```text
fx new tiny --scaffold minimal      # no default region
fx new firmware --scaffold embedded # small arena, no staged std
fx new mytool --scaffold cli        # Result library + thin C argv host
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
