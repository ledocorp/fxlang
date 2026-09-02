# fx host spine

Packageable host-side C that is **not** inside `libzspec.a`:

| Path | Role |
|------|------|
| [`cap/`](cap/) | Guest / capability session runtime (`fx_cap_runtime`) + NetCap TCP dial (`fx_net_dial.c`; TLS not in default dial) |
| [`cli/`](cli/) | Shared argv / stdio helpers (`fx_cli_host.h`) - used by `--cli` |
| [`concur/`](concur/) | Nursery, chan, select, mailbox, supervise, mutex (`fx_task_nursery`, …) |
| [`process/`](process/) | OS process edge (spawn / mkdir / cwd) for product CLIs |
| [`std_env/`](std_env/) | Thin getenv shim for `std/env` |
| [`std_time/`](std_time/) | Wall clock / sleep shim for `std/time` |
| [`std_fs_walk/`](std_fs_walk/) | Directory listing shim for `std/fs_walk` |

Link `host/cap/fx_cap_runtime.c` with hosted guests; include `host/cli` for argv tools;
link `host/concur/*.c` for structured concurrency (Linux: `-pthread`);
link the matching `host/std_*` unit when importing those std modules.

Compat shims under `examples/cap_runtime/` and `examples/cli_host/` redirect to cap/cli so older
`--link` paths keep working.

User guides: package `docs/COMPOSITION.md` · `docs/WRAP.md` · `docs/SCAFFOLDS.md` · `docs/SURFACE.md`.
