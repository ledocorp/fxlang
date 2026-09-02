// now_ms / sleep / rand_next.
using core;
import std/testing;
import std/time;

fn test_rand_steps() -> Result<i32, core_Err> effects { alloc, io } {
    let a = time.rand_next(1);
    let b = time.rand_next(a);
    if (a == 0) {
        return Err(1);
    }
    if (a == b) {
        return Err(2);
    }
    return Ok(0);
}

fn test_now_and_sleep() -> Result<i32, core_Err> effects { alloc, io } {
    let t0 = time.now_ms();
    time.sleep_ms(5);
    let t1 = time.now_ms();
    if (t1 < t0) {
        return Err(3);
    }
    return Ok(0);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_rand_steps()?;
    let _b = test_now_and_sleep()?;
    return Ok(0);
}
