# Project starters (`fx new`)

Starter trees live under [`scaffolds/`](../scaffolds/) (repo folder name). Product speech is just **`fx new`** — same idea as **`cargo new`**, with an optional **kind**.

Not `go mod init` (module path only). Not Rails “scaffold” (CRUD generators).

## Kinds

| Kind | Example | When to use it |
|------|---------|----------------|
| **simple** (default) | `fx new hello` | Everyday apps: named region + `import std/vec`; stages `std/` |
| **minimal** | `fx new tiny minimal` | Smallest possible `main` |
| **embedded** | `fx new firmware embedded` | Tiny arena; builtin `vec_*`; no staged `std/` |
| **cli** | `fx new mytool cli` | Result library + **`--cli`** autohost (`tool` alias) |
| **guest** | `fx new sandbox guest` | Caps-shaped guest + host `GuestCtx` |
| **web** | `fx new mysite web` | Static HTML/CSS/JS for local **fxserve** |

```text
fx new hello
fx new tiny minimal
fx new mytool cli
fx new mysite web
```

## What “simple” teaches

Open `scaffolds/simple/main.fx` (or your new project’s `main.fx`):

- `effects { alloc, mut }` · heap + mutation are declared
- `region r = arena(4096)` · named lifetime
- `import std/vec` · portable standard library
- **Grow** via `v.push(x)` (or `v = vec.push(v, x)`) — same physics as `vec_push`

## CLI / guest / web

```text
# cli
fx build tool_lib.fx -o out --emit-c --cli
./out/prog hello # Ok(42) → exit 42

# guest
fx build guest_lib.fx -o out --emit-c --host host.c \
 --link host/cap/fx_cap_runtime.c --link-include . --link-include host/cap
./out/prog

# web
fxserve ./site --port 8765
```

Related: [REGIONS.md](REGIONS.md) · [STD.md](STD.md) · [LANGUAGE.md](LANGUAGE.md) · [WRAP.md](WRAP.md) · [CLI.md](CLI.md)
