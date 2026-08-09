# Project scaffolds (`fx new`)

Scaffolds are starter programs under [`scaffolds/`](../scaffolds/). `fx new` copies one into a new directory.

## Kinds

| Kind | Flag | When to use it |
|------|------|----------------|
| **simple** | `--scaffold simple` (default) | Everyday apps: named region + `import std/vec`; stages `std/` into the project |
| **minimal** | `--scaffold minimal` | Smallest possible `main`; add region/effects yourself |
| **embedded** | `--scaffold embedded` | Tiny arena footprint; builtin `vec_*`; no staged `std/` |
| **cli** | `--scaffold cli` | Result library + thin C host for argv (product CLIs) |
| **guest** | `--scaffold guest` | Caps-shaped guest + host `GuestCtx` mint session |

```text
fx new hello
fx new tiny --scaffold minimal
fx new firmware --scaffold embedded
fx new mytool --scaffold cli
fx new sandbox --scaffold guest
```

## What “simple” teaches

Open `scaffolds/simple/main.fx` (or your new project’s `main.fx`):

- `effects { alloc, mut }` · heap + mutation are declared  
- `region r = arena(4096)` · named lifetime  
- `import std/vec` · portable standard library  

That combination is the recommended first experience: **Go-feel lifetimes, not a GC**.

## CLI / guest

`fx run` does not pass program argv. For CLIs and sandboxed guests, use the staged C host:

```text
# cli
fx build tool_lib.fx -o out --emit-c --host host_cli.c --link-include .
./out/prog hello

# guest
fx build guest_lib.fx -o out --emit-c --host host.c \
  --link host/cap/fx_cap_runtime.c --link-include . --link-include host/cap
./out/prog
```

Related: [REGIONS.md](REGIONS.md) · [STD.md](STD.md) · [LANGUAGE.md](LANGUAGE.md) · [WRAP.md](WRAP.md)
