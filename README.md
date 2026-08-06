# fx

**Version:** [0.8.0](VERSION)  
**Copyright © 2026 Shawn Londono** · **LedoCorp** · http://www.ledocorp.org  
**License:** [Apache License 2.0](LICENSE) · [NOTICE](NOTICE)

---

## What fx is

**fx is a systems language that refuses hidden control.**

No garbage collector quietly rewriting your heap.  
No implicit allocator.  
No framework magic between what you wrote and what runs.

Every important decision (**who allocates, who mutates, how long memory lives**) is visible in the source.

fx is built for people who still live in the C universe (or need to) and want a sharper language on top of it, not a replacement religion:

| You care about…          | fx’s answer |
|--------------------------|-------------|
| Predictable memory       | **Named regions** + **effects** (`alloc`, `mut`) in the signature |
| Shipping beside C        | **Dual emission**: run natively *and* emit **readable C** |
| Existing C libraries     | **Wrap / host**: C owns `main`, fx owns the logic |
| Auditability             | Lowering targets a small, explicit C substrate (**zspec**) |
| Humans *and* agents      | Low-ceremony, local style: easy to read, easy to generate, hard to “accidentally GC” |

This repository is the full language package: compiler binary, standard library, scaffolds, docs, link materials, and optional **inspectable** compiler sources under [`compiler-source/`](compiler-source/). Clone it, put `bin/` on your `PATH`, and write fx. To *read* how the frontend is expressed in fx, open `compiler-source/` (that folder is not a rebuild SDK).

---

## The idea in one screen

```fx
import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);              // this heap lives here
    let v: Vec<i32> = vec.new(0);
    let v2: Vec<i32> = vec.push(v, 40);
    let v3: Vec<i32> = vec.push(v2, 2);
    return vec.get(v3, 0) + vec.get(v3, 1);  // 42
}
```

When `r` ends, that arena is gone. The effects clause told you the function may allocate and mutate **before** you read the body. That is the product: **locality of reasoning**.

When you need the C world:

```text
fx run main.fx --emit-c             # emit-C → native
fx emit-c main.fx -o out_c          # inspect .c / .h only
fx run lib.fx --host host.c         # C main + fx library
```

Emitted C is meant to look like something a competent C programmer could maintain.

---

## Who fx is for

- Systems and embedded developers who want structure without surrendering the heap to a GC
- Teams wrapping mature C libraries who want a better language for new code, not a full rewrite
- People building with AI assistants who need a language that stays mechanical and explicit so generated code remains auditable

It is **not** trying to be a batteries-included application platform, a GC scripting language, or a marketing-site ecosystem. This release ships a serious core: language + compiler + std foothold + C interop.

---

## Quick start

**Requirements:** this repo · a C toolchain (`gcc` default) · Windows or Linux x86_64 (macOS binary comes later).

```text
# put bin/ on PATH, then:
fx doctor                  # check gcc/clang/zig + zspec paths
fx version                 # v0.8.0
fx new hello
cd hello
fx run main.fx             # IR → native; exit 42
fx run main.fx --emit-c    # optional: emit-C → native
```

| OS      | Binary              |
|---------|---------------------|
| Windows | [`bin/fx.exe`](bin/fx.exe) |
| Linux   | [`bin/fx`](bin/fx)  |

More: [docs/START_HERE.md](docs/START_HERE.md)

```text
fx new tiny --scaffold minimal
fx new firmware --scaffold embedded
```

---

## What you get in this package

| Path | Role |
|------|------|
| [`bin/`](bin/) | Prebuilt **fx** compiler |
| [`scaffolds/`](scaffolds/) | Official `fx new` templates |
| [`std/`](std/) | Standard library (`import std/vec`, …) |
| [`zspec/`](zspec/) + [`build/`](build/) | Headers + **libzspec** for linking emitted C |
| [`docs/`](docs/) | Language and tooling guides |
| [`examples/`](examples/) | Optional demos (core + C-host wrap) |
| [`compiler-source/`](compiler-source/) | Read-only fx compiler modules (inspect; run `bin/fx`) |

Map: [PACKAGE.md](PACKAGE.md)

---

## Dual native paths

Same checked programs, two native lowerings:

- **`fx run` / `fx build`**: **IR → native** by default
- **`fx run --emit-c`**: emit-C → native when you want the C path
- **`fx emit-c`**: generate `.c` / `.h` you can read and own (no link)
- **`--host`**: keep your C `main`, link fx as the library

Demo:

```text
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
```

→ [docs/WRAP.md](docs/WRAP.md) · [docs/CLI.md](docs/CLI.md) · [docs/TRACKING.md](docs/TRACKING.md)

---

## Language guides

Also on the web: https://www.ledocorp.org/fx/docs/

| Doc | Topic |
|-----|--------|
| [docs/START_HERE.md](docs/START_HERE.md) | Install and hello |
| [docs/SURFACE.md](docs/SURFACE.md) | **As-implemented surface map** (full cheatsheet) |
| [docs/LANGUAGE.md](docs/LANGUAGE.md) | Language tour (types, Result, collections, modules, …) |
| [docs/REFERENCE.md](docs/REFERENCE.md) | Compact surface reference |
| [docs/REGIONS.md](docs/REGIONS.md) | Effects, region kinds, ownership / borrows |
| [docs/STD.md](docs/STD.md) | Standard library map and APIs |
| [docs/WRAP.md](docs/WRAP.md) | C host / `extern "c"` |
| [docs/SCAFFOLDS.md](docs/SCAFFOLDS.md) | Project templates |
| [docs/CLI.md](docs/CLI.md) | Full command surface (incl. `fx doctor` / `fx lsp` / `fx mcp`) |

---

## Tooling for humans and agents

This package’s compiler includes:

- **`fx doctor`**: check C toolchain + zspec paths
- **`fx lsp`**: editor language server  
- **`fx mcp`**: lean MCP tools for agents (`check` / `locate` / `run`, …)

Same explicit language, usable from Cursor and friends once `fx` is on your `PATH`.

---

## Contributing & security

fx is stewarded by Shawn Londono / LedoCorp.

- GitHub pull requests are not accepted at this time.
- Issues are welcome for bugs.

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

---

## Release notes

See **[docs/releases/](docs/releases/)** (newest first). Latest: [0.8.0](docs/releases/0.8.0.md).

**0.8.0** leads with **IR → native** by default, keeps **readable emit-C** first-class (annotate / `.fxmap` / `fx locate`), and ships writeable-fx dogfood Apps 1–5 (CHIP‑8, JSON wrap + pure, textdiff) plus adoption polish (clearer diagnostics, shared CLI host recipe, wilder JSON including `\uXXXX`). Composition under regions, typed pool `Id`, `vec_set`, and dual paths remain the method — still no `v[i]=x`, no unsafe dialect. Compiler, scaffolds, Windows/Linux binaries, C wrap path, docs, and inspectable `compiler-source/` stay in the tree. The standard library is still small; macOS binaries will follow.

The thesis is not small: **explicit systems programming with dual emission to readable C.**
