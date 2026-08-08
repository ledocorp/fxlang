// FX-DYN Phase B.1 — guest under a host GuestCtx.
// Authority = minted FsCap only (no ambient std/io). Same physics; no Soft-fx.
using core;
import std/cap;
import std/io_cap;
import score_lib;

/// Read + score under FsCap. Err(5) = denied / revoked.
fn run(fs: FsCap, path: string) -> Result<i32, core_Err> effects { io, alloc } {
    let src = io_cap.read_file_cap(fs, path)?;
    let s: i32 = score_lib.score(src);
    if (s != 42) {
        return Err(s);
    }
    return Ok(42);
}
