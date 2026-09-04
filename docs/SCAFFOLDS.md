# Project scaffolds (`fx new`)

Scaffolds are starter programs under [`scaffolds/`](../scaffolds/). `fx new` copies one into a new directory.

## Kinds

| Kind | Flag | When to use it |
|------|------|----------------|
| **simple** | `--scaffold simple` (default) | Everyday apps: named region + `import std/vec`; stages `std/` into the project |
| **minimal** | `--scaffold minimal` | Smallest possible `main`; add region/effects yourself |
| **embedded** | `--scaffold embedded` | Tiny arena footprint; builtin `vec_*`; no staged `std/` |
| **cli** | `--scaffold cli` (alias: `tool`) | Result library + **`--cli`** autohost for argv (product CLIs) |
| **guest** | `--scaffold guest` | Caps-shaped guest + host `GuestCtx` mint session |

```text
fx new hello
fx new tiny --scaffold minimal
fx new firmware --scaffold embedded
fx new mytool --scaffold cli
fx new mytool --scaffold tool     # same as cli
fx new sandbox --scaffold guest
```

## What “simple” teaches

Open `scaffolds/simple/main.fx` (or your new project’s `main.fx`):

- `effects { alloc, mut }` · heap + mutation are declared  
- `region r = arena(4096)` · named lifetime  
- `import std/vec` · portable standard library  
- **Grow** via `v.push(x)` (or `v = vec.push(v, x)`) — same physics as `vec_push`; not a Soft-fx second model  

That combination is the recommended first experience: **Go-feel lifetimes, not a GC**.

## CLI / guest

`fx run` does not pass program argv. For product CLIs, use **`--cli`** (no author `host_cli.c`). For custom WRAP/GUI hosts, use `--host`.

```text
# cli / tool scaffold
fx build tool_lib.fx -o out --emit-c --cli
./out/prog hello                # Ok(42) → exit 42

# guest
fx build guest_lib.fx -o out --emit-c --host host.c \
  --link host/cap/fx_cap_runtime.c --link-include . --link-include host/cap
./out/prog
```

Related: [REGIONS.md](REGIONS.md) · [STD.md](STD.md) · [LANGUAGE.md](LANGUAGE.md) · [WRAP.md](WRAP.md) · [CLI.md](CLI.md)
