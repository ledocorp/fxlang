// :memory: open → exec → SELECT 42 → close (dual-path).
using core;
import sqlite_safe;

fn main() -> Result<i32, core_Err> effects { alloc } {
    let h = sqlite_safe.open_memory()?;
    let _e = sqlite_safe.exec(h, "CREATE TABLE t(x INTEGER); INSERT INTO t VALUES(42);")?;
    let n = sqlite_safe.query_i32(h, "SELECT x FROM t;")?;
    let _c = sqlite_safe.close(h)?;
    if (n != 42) {
        return Ok(4);
    }
    return Ok(42);
}
