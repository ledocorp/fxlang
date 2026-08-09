# fx host spine

Packageable host-side C that is **not** inside `libzspec.a`:

| Path | Role |
|------|------|
| [`cap/`](cap/) | Guest / capability session runtime (`fx_cap_runtime`) |
| [`cli/`](cli/) | Shared argv / stdio helpers (`fx_cli_host.h`) |

Link `host/cap/fx_cap_runtime.c` with hosted guests; include `host/cli` for argv tools.

Compat shims under `examples/cap_runtime/` and `examples/cli_host/` redirect here so older
`--link` paths keep working.

User guides: [docs/COMPOSITION.md](../docs/COMPOSITION.md) · [docs/WRAP.md](../docs/WRAP.md) ·
[docs/SCAFFOLDS.md](../docs/SCAFFOLDS.md).
