// `dynamic region` sugar → fx_guest_begin; exit path → fx_guest_end.
using core;
import std/guest;
import std/cap;
import guest_lib;

extern "c" {
    effects { io, alloc } fn fx_io_cap_read_file(fs_handle: i64, path: string) -> i32;
}

fn run_session() -> Result<i64, core_Err> effects { alloc, io } {
    dynamic region g = guest(4096);
    let ctx = guest.from_handle(g);
    let fs = guest.mint_fs(ctx, "fixtures")?;
    let score = guest_lib.run(fs, "fixtures/ok.txt")?;
    if (score != 42) {
        return Err(1);
    }
    // Return FsCap handle; function exit ends the guest session (tombstone deny).
    return Ok(cap.fs_handle(fs));
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let fs_h = run_session()?;
    let st: i32 = fx_io_cap_read_file(fs_h, "fixtures/ok.txt");
    if (st != 5) {
        return Err(1);
    }
    return Ok(0);
}
