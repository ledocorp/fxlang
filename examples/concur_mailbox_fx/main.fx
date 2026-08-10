// std/mailbox facade → exit 42
using core;
import std/mailbox;

fn main() -> Result<i32, core_Err> effects { concur, alloc } {
    let m = mailbox.create(4)?;
    let _a = mailbox.send(m, 20)?;
    let _b = mailbox.send(m, 22)?;
    let x = mailbox.recv(m)?;
    let y = mailbox.recv(m)?;
    let _c = mailbox.close(m)?;
    let _d = mailbox.destroy(m)?;
    if (x + y != 42) {
        return Ok(1);
    }
    return Ok(42);
}
