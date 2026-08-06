// bind stubs → safe wrapper → cJSON program (exit 42).
// Link: --link cjson_ref.c --link cJSON.c --link-include <ffi dir>
using core;
import cjson_safe;

fn main() -> Result<i32, core_Err> {
    let n = cjson_safe.parse_number("42")?;
    return Ok(n);
}
