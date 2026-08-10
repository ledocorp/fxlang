// nursery + channel IPC pipeline → sum 42.
using core;
import std/nursery;
import std/chan;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let n = nursery.create()?;
    let c = chan.create(4)?;
    let _a = nursery.spawn_send(n, chan.raw(c), 20)?;
    let _b = nursery.spawn_send(n, chan.raw(c), 22)?;
    let x = chan.recv(c)?;
    let y = chan.recv(c)?;
    let _j = nursery.join_all(n)?;
    let _cc = chan.close(c)?;
    let _cd = chan.destroy(c)?;
    let _nd = nursery.destroy(n)?;
    let sum = x + y;
    if (sum != 42) {
        return Ok(1);
    }
    return Ok(42);
}
