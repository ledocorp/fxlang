# Examples

Optional demos. **Not** required to install fx or create apps.

| Path | Description |
|------|-------------|
| [showcase_core/](showcase_core/) | fx-only: region + `std/vec` → exit 42 |
| [showcase_wrap/](showcase_wrap/) | C `main` + fx library → exit 42 |
| [showcase_072/](showcase_072/) | 0.7.2: Map iterate + Vec `v[i]` → exit 42 |

```text
fx run examples/showcase_core/main.fx
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
fx run examples/showcase_072/main.fx
```

After cloning, put `bin/` on your `PATH` (or prefix commands with `bin/fx` / `bin/fx.exe`).
