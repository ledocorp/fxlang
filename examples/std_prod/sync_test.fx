// Mutex create/lock/unlock/destroy.
using core;
import std/sync;

fn test_mutex_roundtrip() -> Result<i32, core_Err> effects { alloc, io } {
    let m = sync.mutex_create()?;
    let _a = sync.lock(m)?;
    let _b = sync.unlock(m)?;
    let _c = sync.destroy(m)?;
    return Ok(0);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_mutex_roundtrip()?;
    return Ok(0);
}
