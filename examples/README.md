# Examples

Optional demos. **Not** required to install fx or create apps.

| Path | Description |
|------|-------------|
| [showcase_core/](showcase_core/) | fx-only: region + `std/vec` → exit 42 |
| [showcase_wrap/](showcase_wrap/) | C `main` + fx library → exit 42 |
| [showcase_072/](showcase_072/) | 0.7.2: Map iterate + Vec `v[i]` → exit 42 |
| [tool_files/](tool_files/) | Week-two: file write/append/rename/delete |
| [tool_bytes/](tool_bytes/) | Week-two: `Buf` / `Bytes` sum |
| [tool_tally/](tool_tally/) | Week-two: Map tally + StrBuilder report |
| [tool_text/](tool_text/) | M3a: StrBuilder → file → bytes walk |
| [tool_result/](tool_result/) | P1: unbridged Result/`?` → exit 42 |

```text
fx run examples/showcase_core/main.fx
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
fx run examples/showcase_072/main.fx
fx run examples/tool_files/main.fx
fx run examples/tool_bytes/main.fx
fx run examples/tool_tally/main.fx
fx run examples/tool_text/main.fx
fx run examples/tool_result/main.fx
```

After cloning, put `bin/` on your `PATH` (or prefix commands with `bin/fx` / `bin/fx.exe`).
Requires package `std/` (or `FX_STD_ROOT`) for imports.

Week-two regression (check / run / fail fixtures / build+exe / public tree):

```text
.\scripts\test-week2-tools.ps1
```

