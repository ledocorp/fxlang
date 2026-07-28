# Start here

Welcome to **fx**: a systems language with visible memory and dual emission to readable C.

**Version:** 0.7.1 · Copyright © 2026 Shawn Londono · LedoCorp · Apache-2.0  
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
# From the repo root, or with bin/ already on PATH:
fx version                    # expect v0.7.1

fx new hello
cd hello
fx run main.fx                # expect exit code 42
```

Windows without PATH:

```text
.\bin\fx.exe doctor
.\bin\fx.exe new hello
cd hello
..\bin\fx.exe run main.fx
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
```

→ [SCAFFOLDS.md](SCAFFOLDS.md)

---

## Where things live

| You want… | Look here |
|-----------|-----------|
| Understand the language | [LANGUAGE.md](LANGUAGE.md) |
| Regions / effects | [REGIONS.md](REGIONS.md) |
| `import std/…` | [STD.md](STD.md) |
| Commands and flags | [CLI.md](CLI.md) |
| Call fx from C / wrap a library | [WRAP.md](WRAP.md) |
| Copy-paste demos | [../examples/](../examples/) |
| What’s in the repo | [../PACKAGE.md](../PACKAGE.md) |
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
