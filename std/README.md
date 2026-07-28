# fx `std/` · standard library facades

Ordinary `.fx` modules for applications. Copyright Shawn Londono · Apache-2.0
(see repo `LICENSE` / `NOTICE`).

## Included (0.7.2)

| Module | Purpose |
|--------|---------|
| `vec` | Vec helpers (`new` / `push` / `get` / `len`) |
| `box` | Box / ownership helpers |
| `string` | String helpers |
| `math` | Small math helpers |
| `map` / `set` | Map / set facades |
| `queue` | Bounded queue facade |
| `buf` | Growable byte buffer (`Buf`) + `Bytes` view |
| `pair` | Pair helpers |
| `fmt` / `io` | Format / I/O facades |
| `fx_defaults` | Defaults-related helpers |

`fx new` (simple) stages these so `import std/vec` works in a new project.
It also stages `lib/ring_queue.fx` so `import std/queue` resolves.

## Later expansion

Richer collections, paths, JSON/config, time/RNG, and app testing helpers may
land in future packages, still as explicit fx modules.
