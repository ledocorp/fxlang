# Standard library (`std/`)

The [`std/`](../std/) directory holds **ordinary fx modules**. You import them like any other library:

```fx
import std/vec;
```

They are **not** the C runtime and **not** the compiler. Linking still uses **zspec** headers/libraries when your program allocates through the usual paths.

## Modules in this package

| Module | Role |
|--------|------|
| `vec` | Growable vectors (`new` / `push` / `get` / `len`, …) |
| `box` | Boxed values / ownership helpers |
| `string` | String helpers |
| `math` | Small math helpers |
| `map` / `set` | Map and set facades |
| `queue` | Bounded queue facade |
| `pair` | Pair helpers |
| `fmt` / `io` | Format and I/O footholds |
| `fx_defaults` | Defaults-related helpers |

See also [`std/README.md`](../std/README.md).

## How projects find `std/`

- **`fx new` (simple)** stages a copy of `std/` next to your project so imports resolve offline.  
- You can also point tools at a shared `std/` (environment / layout depending on your setup).

## Growth

This release’s stdlib is intentionally small. Later packages may add richer collections, paths, JSON, time/RNG, and testing helpers, still as explicit, allocator-aware fx code.

Language overview: [LANGUAGE.md](LANGUAGE.md)
