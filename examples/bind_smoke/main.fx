// FX-0.7-BINDGEN-1 - smoke: Level 1 `extern "c"` stubs + host C -> exit 42
// Stubs match `fx bind tests/fixtures/bind/smoke_add.h` (see smoke_raw.fx for generated form).
extern "c" {
    fn smoke_add(a: i32, b: i32) -> i32;
}

fn main() -> i32 {
    return smoke_add(10, 32);
}
