# Examples

Optional demos. **Not** required to install fx or create apps.

| Path | Description |
|------|-------------|
| [showcase_core/](showcase_core/) | fx-only: region + `std/vec` → exit 42 |
| [showcase_wrap/](showcase_wrap/) | C `main` + fx library → exit 42 |
| [showcase_072/](showcase_072/) | 0.7.2: Map iterate + Vec `v[i]` → exit 42 |
| [facet_writer/](facet_writer/) | Season F: facet + `where T: Writer` → exit 42 |
| [capdict_writer/](capdict_writer/) | Season F: CapDict mint + invoke → exit 42 (`--fallback-emit-c`) |
| [tool_files/](tool_files/) | Week-two: file write/append/rename/delete |
| [tool_bytes/](tool_bytes/) | Week-two: `Buf` / `Bytes` sum |
| [tool_tally/](tool_tally/) | Week-two: Map tally + StrBuilder report |
| [tool_text/](tool_text/) | StrBuilder → file → bytes walk |
| [tool_result/](tool_result/) | Result/`?` → exit 42 |
| [pattern_ids/](pattern_ids/) | Composition: graph as ids (SoA Vecs) → exit 42 |
| [pattern_mut_table/](pattern_mut_table/) | Composition: `&mut [T]` fixed table → exit 42 |
| [pattern_grow_freeze/](pattern_grow_freeze/) | Composition: grow then read-only walk → exit 42 |
| [pattern_ring/](pattern_ring/) | Composition: fixed array ring + cursors → exit 42 |
| [pattern_pool/](pattern_pool/) | Composition: `std/pool` id-pool → exit 42 |
| [composition_tally/](composition_tally/) | Multi-pass Map `add_i32` tally → exit 42 |
| [composition_reach/](composition_reach/) | Typed pool Ids + reachability → exit 42 |
| [cap_host_smoke/](cap_host_smoke/) | Host mints file read; guest has no `io` → exit 42 / deny 5 |
| [cap_regions_ext/](cap_regions_ext/) | FsCap / OutCap hosted path |
| [cap_guest_ctx/](cap_guest_ctx/) | Guest session begin / mint / end |
| [wrap_sqlite/](wrap_sqlite/) | SQLite amalgamation WRAP - `:memory:` → exit 42 |
| [wrap_llhttp/](wrap_llhttp/) | llhttp parse-only WRAP → exit 42 |
| [bind_smoke/](bind_smoke/) | `fx bind` stubs + `--link` C → exit 42 |
| [bind_stb_sprintf/](bind_stb_sprintf/) | bind → Result wrapper → stb_sprintf → exit 42 |
| [bind_cjson/](bind_cjson/) | bind → Result wrapper → cJSON → exit 42 |
| [wasm_smoke/](wasm_smoke/) | Minimal program exit 42 (+ emit-C / wasm twin) |

```text
fx run examples/showcase_core/main.fx
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
fx run examples/wrap_sqlite/main.fx
fx run examples/wrap_llhttp/main.fx
fx run examples/cap_host_smoke/main.fx
fx run examples/bind_smoke/main.fx --link examples/bind_smoke/host.c
```

After cloning, put `bin/` on your `PATH` (or prefix commands with `bin/fx` / `bin/fx.exe`).
Requires package `std/` (or `FX_STD_ROOT`) for imports. Hosted guests link `host/cap/`.

Composition method: [docs/COMPOSITION.md](../docs/COMPOSITION.md) · dual-emit tracking: [docs/TRACKING.md](../docs/TRACKING.md).
