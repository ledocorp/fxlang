# fx

**Version:** [0.9.75](VERSION) · [Release notes](docs/releases/0.9.75.md) · [GitHub](https://github.com/ledocorp/fxlang)

**Copyright © 2026 Shawn Londono** · **LedoCorp** · http://www.ledocorp.org
**License:** [GNU GPL v3](LICENSE) · [NOTICE](NOTICE) · [third-party licenses](docs/LICENSES.md)

---

## What fx is

**fx is a systems language with visible control.**

Named **regions** + **effects** in signatures. **Native-first** `fx run` (the primary compiler path when the program fits; otherwise a built-in fallback engine inside `bin/fx`). **IR → native** on that fallback path when QBE is present. **Emit-C** stays first-class and readable. Wrap mature C libraries instead of rewriting them.

This repo is the **language package**: put `bin/` on your `PATH` and write fx.
**License:** GNU GPL v3 — see [LICENSE](LICENSE).

---

## Install / try (2 minutes)

**Needs:** this repo · `gcc` (or clang/zig) · **Windows or Linux x86_64** (no macOS prebuilt).

```text
# put bin/ on PATH, then:
fx doctor
fx version # v0.9.75
fx new hello
cd hello
fx run main.fx # expect exit 42
```

Prove the package: `./scripts/verify-pack.sh` (or `.\scripts\verify-pack.ps1` on Windows) — [docs/QUALITY.md](docs/QUALITY.md).

| OS | Binary | IR (when staged) |
|----|--------|------------------|
| Windows | [`bin/fx.exe`](bin/fx.exe) | `third_party/qbe/windows/qbe.exe` |
| Linux | [`bin/fx`](bin/fx) | `third_party/qbe/obj/qbe` |

Without QBE, use `fx run main.fx --emit-c`. Layout: [PACKAGE.md](PACKAGE.md).
**Argv:** `fx run` does not forward program args — use `--scaffold cli` / `--host`.
**Pins:** `fx new` writes `fx.mod`. Optional `fx mod vendor` / `verify` checksum `std`;
compile still uses the `std/` beside your project (or `FX_STD_ROOT`).

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
| 2 Weekend path | [docs/WEEKEND.md](docs/WEEKEND.md) — hello → CLI → fxserve |
| 3 Backends | [docs/DRIVERS.md](docs/DRIVERS.md) — Auto / emit-C / IR / `--driver sh` |
| 4 Ship a tool | [docs/SHIP.md](docs/SHIP.md) — pins, `--cli`/`--host`, dual-path before claim |
| 5 C shape | [docs/C_SHAPE.md](docs/C_SHAPE.md) — how regions / Result / Vec look in emit-C |
| 6 Patterns | [docs/PATTERNS.md](docs/PATTERNS.md) — SoA / Result / caps / wire recipes |
| 7 Language | [docs/LANGUAGE.md](docs/LANGUAGE.md) |
| 8 Composition | [docs/COMPOSITION.md](docs/COMPOSITION.md) |
| 9 Regions / caps | [docs/REGIONS.md](docs/REGIONS.md) |
| 10 Wrap / C host | [docs/WRAP.md](docs/WRAP.md) |
| 11 CLI | [docs/CLI.md](docs/CLI.md) |
| Map | [docs/SURFACE.md](docs/SURFACE.md) — as-implemented cheatsheet |
| Tracking | [docs/TRACKING.md](docs/TRACKING.md) |
| Std / Reference | [docs/STD.md](docs/STD.md) · [docs/REFERENCE.md](docs/REFERENCE.md) |
| Quality | [docs/QUALITY.md](docs/QUALITY.md) — verify-pack |
| Never / may | [docs/GAPS.md](docs/GAPS.md) |

What’s next: [docs/NEXT.md](docs/NEXT.md).

---

## Companion tools (separate packs)

Install from GitHub Releases (Win + Linux x86_64). Requires fx **0.9.6+** (prefer **0.9.75+**). **GPL-3.0**.

| Tool | Role | Repo |
|------|------|------|
| **fxrun** | Task runner (`fxrun.toml`) | [ledocorp/fxrun](https://github.com/ledocorp/fxrun/releases) |
| **fxql** | SQLite one-shot + FsCap | [ledocorp/fxql](https://github.com/ledocorp/fxql/releases) |
| **fxlz4** | LZ4 pack/unpack | [ledocorp/fxlz4](https://github.com/ledocorp/fxlz4/releases) |
| **fxblake3** | BLAKE3 file/tree hash | [ledocorp/fxblake3](https://github.com/ledocorp/fxblake3/releases) |
| **fxfetch** | HTTPS GET + NetCap | [ledocorp/fxfetch](https://github.com/ledocorp/fxfetch/releases) |
| **fxpipe** | Parallel BLAKE3 + nursery | [ledocorp/fxpipe](https://github.com/ledocorp/fxpipe/releases) |
| **fxguest** | Cap speech (allow/deny/fuel) | [ledocorp/fxguest](https://github.com/ledocorp/fxguest/releases) |
| **fxserve** | Local static HTTP(S) | [ledocorp/fxserve](https://github.com/ledocorp/fxserve/releases) |

Site index: https://www.ledocorp.org/fx/tools/ · Detail: [docs/LIBRARIES.md](docs/LIBRARIES.md).

---

## What’s in 0.9.75

- **Trust / teach surface** — [C_SHAPE.md](docs/C_SHAPE.md) · [SHIP.md](docs/SHIP.md) · [PATTERNS.md](docs/PATTERNS.md)
- **`scripts/verify-pack`** — doctor + exit-42 smokes (+ Auto when QBE present)
- **`examples/wire_smoke`** in the T0 teaching set
- **Linux CI** — dual-path showcase + verify-pack
- Carry-forward: GPL-3.0, default Auto `fx run`, `--emit-c`, IR when QBE is present, pin-only `fx.mod`

Full notes: [docs/releases/0.9.75.md](docs/releases/0.9.75.md). Prior: [0.9.74](docs/releases/0.9.74.md) · [0.9.73](docs/releases/0.9.73.md).

---

## Tooling

- `fx doctor` · `fx lsp` · `fx mcp` (check / locate / run)
- Editor day-one: [docs/EDITOR.md](docs/EDITOR.md)

---

## Contributing & security

Maintained by Shawn Londono / LedoCorp. PRs not accepted; issues welcome for bugs.
[CONTRIBUTING.md](CONTRIBUTING.md) · [SECURITY.md](SECURITY.md)

---

## Releases

Newest first under [docs/releases/](docs/releases/). **Latest: [0.9.75](docs/releases/0.9.75.md).**
