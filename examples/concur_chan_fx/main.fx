// std/chan facade → exit 42
using core;
import std/chan;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let c = chan.create(2)?;
    let _a = chan.send(c, 20)?;
    let _b = chan.send(c, 22)?;
    let x = chan.recv(c)?;
    let y = chan.recv(c)?;
    let _cl = chan.close(c)?;
    let _d = chan.destroy(c)?;
    if (x + y != 42) {
        return Ok(1);
    }
    return Ok(42);
}
