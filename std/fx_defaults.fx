// SH-ERG-2 - minimal bootstrap defaults (allocator sizes; `core_Err` via `using core`).
// Reference doc artifact: validation/reference/fx_defaults/fx-defaults.fx
// Note: Result helpers must stay module-local until cross-module Result ABI unifies.
module fx_defaults;

using core;

fn arena_boot() -> i32 {
    return 4096;
}

fn arena_parse() -> i32 {
    return 32768;
}

fn arena_emit() -> i32 {
    return 16384;
}
