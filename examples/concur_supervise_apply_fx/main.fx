// one_for_all cancel + escalate status → 42.
using core;
import std/nursery;
import std/supervise;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let n = nursery.create()?;
    let p_all = supervise.one_for_all();
    let _ok = supervise.apply(nursery.raw(n), p_all, 0)?;
    let _cancel = supervise.apply(nursery.raw(n), p_all, 1)?;
    let _nd = nursery.destroy(n)?;

    let n2 = nursery.create()?;
    let st = supervise.apply_status(nursery.raw(n2), supervise.escalate(), 1);
    let _n2d = nursery.destroy(n2)?;
    if (st != 4) {
        return Ok(1);
    }
    return Ok(42);
}
