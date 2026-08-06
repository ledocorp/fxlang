// bind stubs → safe wrapper → program (exit 42).
// Link: --link <repo>/fx-compiler/tests/fixtures/ffi/stb_sprintf_ref.c
//       --link-include <same ffi dir>
using core;
import stb_safe;

fn main() -> Result<i32, core_Err> {
    let n = stb_safe.format_i32(42)?;
    return Ok(n);
}
