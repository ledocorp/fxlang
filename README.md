# fx

**Version:** [0.9.73](VERSION) · [Release notes](docs/releases/0.9.73.md) · [GitHub](https://github.com/ledocorp/fxlang)

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
fx version # v0.9.73
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
| 4 Language | [docs/LANGUAGE.md](docs/LANGUAGE.md) |
| 5 Composition | [docs/COMPOSITION.md](docs/COMPOSITION.md) |
| 6 Regions / caps | [docs/REGIONS.md](docs/REGIONS.md) |
| 7 Wrap / C host | [docs/WRAP.md](docs/WRAP.md) |
| 8 CLI | [docs/CLI.md](docs/CLI.md) |
| Map | [docs/SURFACE.md](docs/SURFACE.md) — as-implemented cheatsheet |
| Tracking | [docs/TRACKING.md](docs/TRACKING.md) |
| Std / Reference | [docs/STD.md](docs/STD.md) · [docs/REFERENCE.md](docs/REFERENCE.md) |

What’s next: [docs/NEXT.md](docs/NEXT.md).

---

## Companion tools (separate packs)

Install from GitHub Releases (Win + Linux x86_64). Requires fx **0.9.6+** (prefer **0.9.73+**). **GPL-3.0**.

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

## What’s in 0.9.73

- **Stable baseline** for building real tools (platforms, argv, package pins locked; not labeled v1.0)
- **Weekend path** — [docs/WEEKEND.md](docs/WEEKEND.md) · compile map — [docs/DRIVERS.md](docs/DRIVERS.md)
- **`fx new` writes `fx.mod`** — optional `fx mod vendor` / `verify` for checksums
- **Thin teaching examples** — language-focused demos only
- **Web scaffold** — `fx new mysite web`
- **Companion tools** — fxserve and other CLIs in separate GitHub releases
- Carry-forward: GPL-3.0, default Auto `fx run`, `--emit-c`, IR when QBE is present

Full notes: [docs/releases/0.9.73.md](docs/releases/0.9.73.md).

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

Newest first under [docs/releases/](docs/releases/). **Latest: [0.9.73](docs/releases/0.9.73.md).**
