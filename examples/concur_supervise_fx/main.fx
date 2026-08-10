// std/supervise policy normalize → exit 42
using core;
import std/supervise;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let p = supervise.normalize(supervise.one_for_one())?;
    if (p != 1) {
        return Ok(1);
    }
    let q = supervise.normalize(supervise.escalate())?;
    if (q != 4) {
        return Ok(2);
    }
    return Ok(42);
}
