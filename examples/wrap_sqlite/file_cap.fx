// File DB under FsCap: allow fixtures path, deny escape; dual-path → 42.
// Paths are relative to examples/wrap_sqlite (test harness cwd).
using core;
import std/guest;
import std/cap;
import sqlite_safe;

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let g = guest.begin("fixtures", 65536)?;
    let fs = guest.mint_fs(g, "")?;

    let deny = sqlite_safe.open_file_cap_code(fs, "fixtures/../escape.db");
    if (deny != -5) {
        let _e0 = guest.end(g)?;
        return Ok(5);
    }

    let h = sqlite_safe.open_file_cap(fs, "fixtures/wrap_demo.db")?;
    let sql = "CREATE TABLE IF NOT EXISTS t(x INTEGER); DELETE FROM t; INSERT INTO t VALUES(42);";
    let _cr = sqlite_safe.exec(h, sql)?;
    let n = sqlite_safe.query_i32(h, "SELECT x FROM t;")?;
    let _cl = sqlite_safe.close(h)?;
    let _end = guest.end(g)?;
    if (n != 42) {
        return Ok(4);
    }
    return Ok(42);
}
