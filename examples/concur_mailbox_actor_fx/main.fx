// mailbox actor inbox via spawn_mb_send → 42.
using core;
import std/nursery;
import std/mailbox;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let n = nursery.create()?;
    let mb = mailbox.create(4)?;
    let _a = nursery.spawn_mb_send(n, mailbox.raw(mb), 20)?;
    let _b = nursery.spawn_mb_send(n, mailbox.raw(mb), 22)?;
    let x = mailbox.recv(mb)?;
    let y = mailbox.recv(mb)?;
    let _j = nursery.join_all(n)?;
    let _mc = mailbox.close(mb)?;
    let _md = mailbox.destroy(mb)?;
    let _nd = nursery.destroy(n)?;
    if ((x + y) != 42) {
        return Ok(1);
    }
    return Ok(42);
}
