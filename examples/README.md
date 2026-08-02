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
| [composition_tally/](composition_tally/) | 0.7.5-A3: multi-pass Map `add_i32` → exit 42 |
| [composition_reach/](composition_reach/) | 0.7.5-A3: pool Ids + reachability → exit 42 |
| [bind_smoke/](bind_smoke/) | BINDGEN-1: `fx bind` stubs + `--link` C → exit 42 |
| [bind_stb_sprintf/](bind_stb_sprintf/) | BINDGEN-2: bind → Result wrapper → stb_sprintf → exit 42 |
| [bind_cjson/](bind_cjson/) | BINDGEN-3: bind → Result wrapper → cJSON → exit 42 |
| [wasm_smoke/](wasm_smoke/) | BIND-3: fx-native exit 42 (+ emit-C / wasm32 twin) |

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
fx run examples/composition_tally/main.fx
fx run examples/composition_reach/main.fx
fx run examples/bind_smoke/main.fx --link examples/bind_smoke/host.c
```

After cloning, put `bin/` on your `PATH` (or prefix commands with `bin/fx` / `bin/fx.exe`).
Requires package `std/` (or `FX_STD_ROOT`) for imports.

Composition method: [docs/COMPOSITION.md](../docs/COMPOSITION.md) · dual-emit tracking: [docs/TRACKING.md](../docs/TRACKING.md).
