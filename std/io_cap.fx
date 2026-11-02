// Cap-required I/O - parallel to ambient std/io.
// Honest: process-trust apps may keep `import std/io`; sandbox guests use this facade.
// Host must link `fx_io_cap_*` (examples/cap_runtime + cap_regions_*).
module io_cap;

using core;
import std/cap;

extern "c" {
    effects { io, alloc } fn fx_io_cap_read_file(fs_handle: i64, path: string) -> i32;
    effects { io, alloc } fn fx_io_cap_last_text() -> string;
    effects { io, alloc } fn fx_io_cap_write_file(out_handle: i64, path: string, data: string) -> i32;
}

/// Read text under FsCap. Err(5) = denied; Err(2) = IO; Ok(contents).
fn read_file_cap(fs: FsCap, path: string) -> Result<string, core_Err> effects { io, alloc } {
    let st: i32 = fx_io_cap_read_file(cap.fs_handle(fs), path);
    if (st == 5) {
        return Err(5);
    }
    if (st != 0) {
        return Err(2);
    }
    let s: string = fx_io_cap_last_text();
    return Ok(s);
}

/// Write text under OutCap. Err(5) = denied; Err(2) = IO; Ok(0).
fn write_file_cap(out: OutCap, path: string, data: string) -> Result<i32, core_Err> effects { io, alloc } {
    let st: i32 = fx_io_cap_write_file(cap.out_handle(out), path, data);
    if (st == 5) {
        return Err(5);
    }
    if (st != 0) {
        return Err(2);
    }
    return Ok(0);
}
