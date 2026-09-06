# fx

**Version:** [0.9.71](VERSION) · [Release notes](docs/releases/0.9.71.md) · [GitHub](https://github.com/ledocorp/fxlang)

**Copyright © 2026 Shawn Londono** · **LedoCorp** · http://www.ledocorp.org 
**License:** [GNU GPL v3](LICENSE) · [NOTICE](NOTICE) · [third-party licenses](docs/LICENSES.md)

---

## What fx is

**fx is a systems language with visible control.**

Named **regions** + **effects** in signatures. **Native-first** `fx run` (live `sh_*` when the program fits; otherwise a built-in fallback engine inside `bin/fx`). **IR → native** on that fallback path when QBE is present. **Emit-C** stays first-class and readable. Wrap mature C libraries instead of rewriting them.

This repo is the **language package**: put `bin/` on your `PATH` and write fx. 
**License:** GNU GPL v3 — see [LICENSE](LICENSE). No Rust toolchain required.

---

## Install / try (2 minutes)

**Needs:** this repo · `gcc` (or clang/zig) · **Windows or Linux x86_64** (no macOS prebuilt).

```text
# put bin/ on PATH, then:
fx doctor
fx version # v0.9.71
fx new hello
cd hello
fx run main.fx # expect exit 42
```

| OS | Binary | IR (when staged) |
|----|--------|------------------|
| Windows | [`bin/fx.exe`](bin/fx.exe) | `third_party/qbe/windows/qbe.exe` |
| Linux | [`bin/fx`](bin/fx) | `third_party/qbe/obj/qbe` |

Without QBE, use `fx run main.fx --emit-c`. Layout: [PACKAGE.md](PACKAGE.md). 
**Argv:** `fx run` does not forward program args — use `--scaffold cli` / `--host`. 
**Vendor:** `fx mod` pins checksums; compile still uses `std/` / `FX_STD_ROOT`.

---

## The idea in one screen

```fx
import std/vec;

fn main() -> i32 effects { alloc, mut } {
 region r = arena(4096);
 let v: Vec<i32> = vec.new(0);
 let v2: Vec<i32> = vec.push(v, 40);
 let v3: Vec<i32> = vec.push(v2, 2);
 return vec.get(v3, 0) + vec.get(v3, 1); // 42
}
```

```text
fx run main.fx --emit-c
fx emit-c main.fx -o out_c
fx run lib.fx --host host.c
```

---

## Learn path (read in order)

Also on the web: https://www.ledocorp.org/fx/docs/

| Step | Doc |
|------|-----|
| 1 Install | [docs/START_HERE.md](docs/START_HERE.md) |
| 2 Language | [docs/LANGUAGE.md](docs/LANGUAGE.md) |
| 3 Composition | [docs/COMPOSITION.md](docs/COMPOSITION.md) |
| 4 Regions / caps | [docs/REGIONS.md](docs/REGIONS.md) |
| 5 Wrap / C host | [docs/WRAP.md](docs/WRAP.md) |
| 6 CLI | [docs/CLI.md](docs/CLI.md) |
| Map | [docs/SURFACE.md](docs/SURFACE.md) — as-implemented cheatsheet |
| Tracking | [docs/TRACKING.md](docs/TRACKING.md) |
| Std / Reference | [docs/STD.md](docs/STD.md) · [docs/REFERENCE.md](docs/REFERENCE.md) |

What’s next: [docs/NEXT.md](docs/NEXT.md).

---

## What’s in 0.9.71

- **IR coverage** — Atomic · MMIO · CapDict on IR → native when QBE is staged (emit-C still first-class)
- **Systems footing** from **0.9.70** — `--freestanding`, `Atomic<i32>` + explicit orders, `MmioCap` + mmio ops
- Examples: `examples/kern_atomic/`, `examples/kern_mmio/`, `examples/capdict_writer/` (exit **42** dual-path)
- **GPL-3.0** · **native-first Auto** · facets from **0.9.69+**
- IRQ IR still out of claim — prefer `--emit-c` for IRQ demos

Full notes: [docs/releases/0.9.71.md](docs/releases/0.9.71.md).

---

## Tooling

- `fx doctor` · `fx lsp` · `fx mcp` (check / locate / run)
- Editor day-one: [docs/EDITOR.md](docs/EDITOR.md)

---

## Contributing & security

Stewarded by Shawn Londono / LedoCorp. PRs not accepted; issues welcome for bugs. 
[CONTRIBUTING.md](CONTRIBUTING.md) · [SECURITY.md](SECURITY.md)

---

## Releases

Newest first under [docs/releases/](docs/releases/). **Latest: [0.9.71](docs/releases/0.9.71.md).**
