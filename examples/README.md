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
| [pattern_ids/](pattern_ids/) | Composition: graph as ids (SoA Vecs) → exit 42 |
| [pattern_mut_table/](pattern_mut_table/) | Composition: `&mut [T]` fixed table → exit 42 |
| [pattern_grow_freeze/](pattern_grow_freeze/) | Composition: grow then read-only walk → exit 42 |
| [pattern_ring/](pattern_ring/) | Composition: fixed array ring + cursors → exit 42 |
| [pattern_pool/](pattern_pool/) | Composition: `std/pool` id-pool → exit 42 |

```text
fx run examples/showcase_core/main.fx
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
fx run examples/showcase_072/main.fx
fx run examples/tool_files/main.fx
fx run examples/tool_bytes/main.fx
fx run examples/tool_tally/main.fx
fx run examples/tool_text/main.fx
fx run examples/tool_result/main.fx
fx run examples/pattern_ids/main.fx
fx run examples/pattern_mut_table/main.fx
fx run examples/pattern_grow_freeze/main.fx
fx run examples/pattern_ring/main.fx
fx run examples/pattern_pool/main.fx
```

After cloning, put `bin/` on your `PATH` (or prefix commands with `bin/fx` / `bin/fx.exe`).
Requires package `std/` (or `FX_STD_ROOT`) for imports.

Composition method: [docs/COMPOSITION.md](../docs/COMPOSITION.md) · dual-emit tracking: [docs/TRACKING.md](../docs/TRACKING.md).
