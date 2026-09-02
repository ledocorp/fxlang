// parse-only HTTP via std/http (no dial).
using core;
import std/http;

fn main() -> Result<i32, core_Err> effects { alloc } {
    let req = http.sample_req42();
    let _ok = http.req_ok(req)?;
    let n = http.req_content_length(req)?;
    if (n != 42) {
        return Ok(4);
    }
    return Ok(42);
}
