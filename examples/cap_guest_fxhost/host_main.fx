// fx-hosted guest session (no C host driver).
// begin → mint FsCap → guest run → end → stale deny (5).
// Soft-fx refused: same physics; B.2 keyword comes later.
using core;
import std/guest;
import std/cap;
import guest_lib;

extern "c" {
    effects { io, alloc } fn fx_io_cap_read_file(fs_handle: i64, path: string) -> i32;
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin("fixtures", 4096)?;
    let fs = guest.mint_fs(g, "")?;
    let score = guest_lib.run(fs, "fixtures/ok.txt")?;
    if (score != 42) {
        let _x = guest.end(g)?;
        return Err(1);
    }
    let _e = guest.end(g)?;
    if (guest.is_live(g) != 0) {
        return Err(1);
    }
    let st: i32 = fx_io_cap_read_file(cap.fs_handle(fs), "fixtures/ok.txt");
    if (st != 5) {
        return Err(1);
    }
    return Ok(0);
}
