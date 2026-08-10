// std/sqlite memory open → 42.
using core;
import std/sqlite;

fn main() -> Result<i32, core_Err> effects { alloc } {
    let h = sqlite.open_memory()?;
    let _e = sqlite.exec(h, "CREATE TABLE t(x INTEGER); INSERT INTO t VALUES(42);")?;
    let n = sqlite.query_i32(h, "SELECT x FROM t;")?;
    let _c = sqlite.close(h)?;
    if (n != 42) {
        return Ok(4);
    }
    return Ok(42);
}
