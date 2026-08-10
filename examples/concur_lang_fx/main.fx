// nursery spawn_i32 / await_i32 (keyword sugar lowers here).
using core;
import std/nursery;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let n = nursery.create()?;
    let s0 = nursery.spawn_i32(n, 20)?;
    let s1 = nursery.spawn_i32(n, 22)?;
    let _j = nursery.join_all(n)?;
    let sum = nursery.await_i32(s0) + nursery.await_i32(s1);
    let _d = nursery.destroy(n)?;
    if (sum != 42) {
        return Ok(1);
    }
    return Ok(42);
}
