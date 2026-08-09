// Parse Content-Length: 42 via llhttp (dual-path).
using core;
import llhttp_safe;

fn main() -> Result<i32, core_Err> effects { alloc } {
    let req = llhttp_safe.sample_req42();
    let _ok = llhttp_safe.req_ok(req)?;
    let n = llhttp_safe.req_content_length(req)?;
    if (n != 42) {
        return Ok(4);
    }
    return Ok(42);
}
