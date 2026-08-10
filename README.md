# fx

**Version:** [0.9.5](VERSION) · [Release notes](docs/releases/0.9.5.md) · [GitHub Release](https://github.com/ledocorp/fxlang/releases/tag/v0.9.5)

**Copyright © 2026 Shawn Londono** · **LedoCorp** · http://www.ledocorp.org  
**License:** [Apache License 2.0](LICENSE) · [NOTICE](NOTICE) · [third-party licenses](docs/LICENSES.md)

---

## What fx is

**fx is a systems language that refuses hidden control.**

Named **regions** + **effects** in signatures. **IR → native** by default. **Emit-C** stays first-class and readable. Wrap mature C libraries instead of rewriting them.

This repo is the **language package**: put `bin/` on your `PATH` and write fx.

---

## Install / try (2 minutes)

**Needs:** this repo · `gcc` (or clang/zig) · Windows or Linux x86_64.

```text
# put bin/ on PATH, then:
fx doctor
fx version                 # v0.9.5
fx new hello
cd hello
fx run main.fx             # expect exit 42
```

| OS | Binary | IR (when staged) |
|----|--------|------------------|
| Windows | [`bin/fx.exe`](bin/fx.exe) | `third_party/qbe/windows/qbe.exe` |
| Linux | [`bin/fx`](bin/fx) | `third_party/qbe/obj/qbe` |

Without QBE, use `fx run main.fx --emit-c`. Layout: [PACKAGE.md](PACKAGE.md).

---

## The idea in one screen

```fx
import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    let v: Vec<i32> = vec.new(0);
    let v2: Vec<i32> = vec.push(v, 40);
    let v3: Vec<i32> = vec.push(v2, 2);
    return vec.get(v3, 0) + vec.get(v3, 1);  // 42
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

What’s next (honest): [docs/NEXT.md](docs/NEXT.md).

---

## What’s in 0.9.5

- Native `fx test` / `fx fuzz` + `std/testing`
- Structured concurrency (nursery / chan / select / mailbox / supervise)
- Stronger std packs (path, encoding, walk, time, env, http parse, json, sync, sqlite)
- Capability regions + IR dual-path; `std/net` TCP dial (**TLS refused**)
- `fx mod vendor` / `tidy` / `verify` + `fx.sum` (offline **std** pin — **not** a registry)

Full notes: [docs/releases/0.9.5.md](docs/releases/0.9.5.md).

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

Newest first under [docs/releases/](docs/releases/). **Latest: [0.9.5](docs/releases/0.9.5.md).**
