// begin → end → stale FsCap deny (5).
using core;
import std/testing;
import std/guest;
import std/cap;

extern "c" {
    effects { io, alloc } fn fx_io_cap_read_file(fs_handle: i64, path: string) -> i32;
}

fn test_stale_deny() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin(".", 4096)?;
    let fs = guest.mint_fs(g, "")?;
    let _e = guest.end(g)?;
    if (guest.is_live(g) != 0) {
        return testing.fail("session still live");
    }
    let st: i32 = fx_io_cap_read_file(cap.fs_handle(fs), "nope.txt");
    return testing.assert_eq_i32(st, 5);
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let _a = test_stale_deny()?;
    return Ok(0);
}
