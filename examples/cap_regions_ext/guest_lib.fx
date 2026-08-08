// FX-DYN-1 extension surface: guest calls io_cap read/write under host caps.
// Deny outside root → Err(5). Same region physics; no Soft-fx.
using core;
import std/cap;
import std/io_cap;
import score_lib;

/// Extension entry: authority is FsCap + OutCap (copyable handles).
/// On score 42: write fixtures/_cap_status.txt then read it back.
fn run(fs: FsCap, out: OutCap, path: string) -> Result<i32, core_Err> effects { io, alloc } {
    let src = io_cap.read_file_cap(fs, path)?;
    let s: i32 = score_lib.score(src);
    if (s != 42) {
        return Err(s);
    }
    let _w = io_cap.write_file_cap(out, "fixtures/_cap_status.txt", "ok")?;
    let back = io_cap.read_file_cap(fs, "fixtures/_cap_status.txt")?;
    let check: i32 = score_lib.score(back);
    if (check != 42) {
        return Err(3);
    }
    return Ok(42);
}

/// Write probe for deny smoke (path outside OutCap root → Err(5)).
fn probe_write(out: OutCap, path: string, data: string) -> Result<i32, core_Err> effects { io, alloc } {
    let _w = io_cap.write_file_cap(out, path, data)?;
    return Ok(0);
}
