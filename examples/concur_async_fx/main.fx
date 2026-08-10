// foothold - std/nursery facade → exit 42.
using core;
import std/nursery;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let n = nursery.create()?;
    let s0 = nursery.slot_new()?;
    let s1 = nursery.slot_new()?;
    let _a = nursery.spawn_store(n, s0, 20)?;
    let _b = nursery.spawn_store(n, s1, 22)?;
    let _j = nursery.join_all(n)?;
    let sum = nursery.slot_get(s0) + nursery.slot_get(s1);
    let _d = nursery.destroy(n)?;
    if (sum != 42) {
        return Ok(1);
    }
    return Ok(42);
}
