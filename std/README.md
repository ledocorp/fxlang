# fx `std/` · standard library facades

Ordinary `.fx` modules for applications. Copyright Shawn Londono · GPL-3.0
(see repo `LICENSE` / `NOTICE`).

## Included (0.9.68)

| Module | Purpose |
|--------|---------|
| `vec` / `string` / `map` / `set` / `buf` | Core collections |
| `box` / `pair` / `math` / `fmt` / `io` | Helpers + ambient I/O |
| `queue` / `pool` / `fx_defaults` | Bounded queue, typed `Id` pool, defaults |
| `cap` / `guest` / `io_cap` / `net` | Caps, guest sessions, cap I/O, TCP dial |
| `nursery` / `chan` / `select` / `mailbox` / `supervise` / `sync` | Structured concurrency |
| `async` | Deprecated stub — prefer `nursery` |
| `path` / `strutil` / `encoding` / `fs` / `fs_walk` | Paths, strings, bytes, files, walk |
| `log` / `json` / `json_validate` / `json_full` / `sqlite` / `http` | Log, JSON, SQLite, HTTP parse |
| `time` / `env` | Clock / sleep / getenv (argv stays host/cli) |
| `testing` / `proptest` | Native asserts + property helpers |

`fx new` (simple) stages these so `import std/vec` works in a new project.
It also stages `lib/ring_queue.fx` / `lib/id_pool.fx` so `queue` / `pool` resolve.

Public inventory: `docs/SURFACE.md` §D · `docs/STD.md`.

## Growth

Richer domains land when pulled — still as explicit, allocator-aware fx modules.
