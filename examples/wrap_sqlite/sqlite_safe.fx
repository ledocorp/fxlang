// fx facade over SQLite amalgamation (opaque handles in C).
module sqlite_safe;

using core;

extern "c" {
    fn fx_sqlite_open_memory() -> i32;
    fn fx_sqlite_exec(h: i32, sql: string) -> i32;
    fn fx_sqlite_query_i32(h: i32, sql: string) -> i32;
    fn fx_sqlite_close(h: i32) -> i32;
}

fn open_memory() -> Result<i32, core_Err> {
    let h = fx_sqlite_open_memory();
    if (h < 1) {
        return Err(1);
    }
    return Ok(h);
}

fn exec(h: i32, sql: string) -> Result<i32, core_Err> {
    let st = fx_sqlite_exec(h, sql);
    if (st != 0) {
        return Err(2);
    }
    return Ok(0);
}

fn query_i32(h: i32, sql: string) -> Result<i32, core_Err> {
    let n = fx_sqlite_query_i32(h, sql);
    // Negative codes are shim errors; 0+ are column values (incl. 0).
    if (n < 0) {
        return Err(3);
    }
    return Ok(n);
}

fn close(h: i32) -> Result<i32, core_Err> {
    let st = fx_sqlite_close(h);
    if (st != 0) {
        return Err(4);
    }
    return Ok(0);
}
