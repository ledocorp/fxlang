// std/select facade → exit 42
using core;
import std/chan;
import std/select;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let a = chan.create(1)?;
    let b = chan.create(1)?;
    let _s = chan.send(b, 42)?;
    let r = select.recv2(chan.raw(a), chan.raw(b), 100)?;
    let _da = chan.destroy(a)?;
    let _db = chan.destroy(b)?;
    if (select.which_of(r) != 1) {
        return Ok(1);
    }
    if (select.value_of(r) != 42) {
        return Ok(2);
    }
    return Ok(42);
}
