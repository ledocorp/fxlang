// FX-0.7-BIND-3 — fx-native wasm contract smoke (exit 42).
// Native: `fx run examples/wasm_smoke/main.fx`
// Dual-emit: `fx emit-c` then optional clang --target=wasm32-… (see test-bind-wasm.ps1)
// Freestanding wasm32 packaging twin: bindings/wasm/smoke (fx_wasm_smoke_answer).

fn main() -> i32 {
    return 42;
}
