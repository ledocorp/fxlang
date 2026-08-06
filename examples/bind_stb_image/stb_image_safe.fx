// Level 2 safe wrapper over stb_image FFI shim (FX-0.8-STD-2).
module stb_image_safe;

using core;

extern "c" {
    fn stb_image_ref_decode_1x1() -> i32;
}

/// Decode embedded 1×1 PNG in C; Ok(42) on success.
fn decode_smoke_1x1() -> Result<i32, core_Err> {
    let n = stb_image_ref_decode_1x1();
    if (n < 0) {
        return Err(1);
    }
    return Ok(n);
}
