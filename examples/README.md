# Examples

**Teaching set (T0)** for the fx language package. Optional - not required to install or use fx.

Policy: season proofs and tool demos are **not** mirrored here. Full rules live in the monorepo as `PACKAGING_EXAMPLES_LITE` (private); public speech: thin language package + separate tool repos.

| Path | Description |
|------|-------------|
| [showcase_core/](showcase_core/) | fx-only: region + `std/vec` → exit 42 |
| [showcase_wrap/](showcase_wrap/) | C `main` + fx library → exit 42 |
| [showcase_072/](showcase_072/) | Map iterate + Vec `v[i]` → exit 42 |
| [tool_files/](tool_files/) | File write/append/rename/delete |
| [tool_bytes/](tool_bytes/) | `Buf` / `Bytes` sum |
| [tool_tally/](tool_tally/) | Map tally + StrBuilder report |
| [tool_text/](tool_text/) | StrBuilder → file → bytes walk |
| [tool_result/](tool_result/) | Result/`?` → exit 42 |
| [pattern_ids/](pattern_ids/) | Graph as ids (SoA Vecs) → exit 42 |
| [pattern_mut_table/](pattern_mut_table/) | `&mut [T]` fixed table → exit 42 |
| [pattern_grow_freeze/](pattern_grow_freeze/) | Grow then read-only walk → exit 42 |
| [pattern_ring/](pattern_ring/) | Fixed array ring + cursors → exit 42 |
| [pattern_pool/](pattern_pool/) | `std/pool` id-pool → exit 42 |
| [composition_tally/](composition_tally/) | Multi-pass Map tally → exit 42 |
| [composition_reach/](composition_reach/) | Typed pool Ids + reachability → exit 42 |
| [facet_writer/](facet_writer/) | Facet + `where T: Writer` → exit 42 |
| [capdict_writer/](capdict_writer/) | CapDict mint + invoke → exit 42 |
| [bind_smoke/](bind_smoke/) | `fx bind` stubs + `--link` C → exit 42 |
| [wasm_smoke/](wasm_smoke/) | Minimal program exit 42 (+ emit-C / wasm path) |
| [cap_host_smoke/](cap_host_smoke/) | Host-minted file read; guest has no `io` |
| [concur_nursery_smoke/](concur_nursery_smoke/) | Nursery foothold |
| [std_path_smoke/](std_path_smoke/) | `std/path` smoke |

```text
fx run examples/showcase_core/main.fx
fx run examples/wasm_smoke/main.fx
```

Scaffolds: `fx new hello` / `fx new mysite web` - see [docs/SCAFFOLDS.md](../docs/SCAFFOLDS.md).  
Product CLIs (fxrun, fxfetch, fxserve, …) live in separate LedoCorp repos with their own samples.
