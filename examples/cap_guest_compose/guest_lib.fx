// FX-DYN-4 — compose FsCap + AllocCap under one guest run.
// Read under FsCap; scratch under AllocCap; no session alloc_bytes (host scratch only).
using core;
import std/cap;
import std/io_cap;
import std/guest;
import score_lib;

/// Read + budgeted scratch + score. Err(5) = cap deny / over-budget / revoked.
fn run(fs: FsCap, a: AllocCap, path: string) -> Result<i32, core_Err> effects { io, alloc } {
    let src = io_cap.read_file_cap(fs, path)?;
    let _scratch: i64 = guest.alloc(a, 16)?;
    let s: i32 = score_lib.score(src);
    if (s != 42) {
        return Err(s);
    }
    return Ok(42);
}

/// Alloc-only probe (over-budget / stale). Err(5) on deny.
fn try_alloc(a: AllocCap, nbytes: i64) -> Result<i32, core_Err> effects { alloc } {
    let _p: i64 = guest.alloc(a, nbytes)?;
    return Ok(42);
}
