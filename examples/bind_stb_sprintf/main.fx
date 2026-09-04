// bind stubs → safe wrapper → program (exit 42).
// Link: --link host/stb_sprintf_ref.c (or your local shim)
//       --link-include host

using core;
import stb_safe;

fn main() -> Result<i32, core_Err> {
    let n = stb_safe.format_i32(42)?;
    return Ok(n);
}
