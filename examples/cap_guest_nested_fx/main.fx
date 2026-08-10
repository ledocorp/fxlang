// fx-hosted nested guest (no C host.c).
using core;
import std/guest;
import std/cap;
import std/io_cap;

extern "c" {
    effects { io, alloc } fn fx_io_cap_read_file(fs_handle: i64, path: string) -> i32;
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let parent = guest.begin("fixtures", 4096)?;
    let child = guest.begin_nested(parent, "", 2048)?;
    let fs = guest.mint_fs(child, "")?;
    let body = io_cap.read_file_cap(fs, "fixtures/ok.txt")?;
    if (str_len(body) < 1) {
        let _e1 = guest.end(child)?;
        let _e2 = guest.end(parent)?;
        return Err(1);
    }
    let _ec = guest.end(child)?;
    let st: i32 = fx_io_cap_read_file(cap.fs_handle(fs), "fixtures/ok.txt");
    if (st != 5) {
        let _ep = guest.end(parent)?;
        return Err(2);
    }
    let _ep = guest.end(parent)?;
    return Ok(0);
}
