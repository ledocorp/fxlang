// fx facade over SQLite amalgamation (opaque handles in C).
module sqlite_safe;

using core;
import std/cap;

extern "c" {
    fn fx_sqlite_open_memory() -> i32;
    fn fx_sqlite_open_path(path: string) -> i32;
    fn fx_sqlite_open_fscap(fs_handle: i64, path: string) -> i32;
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

/// Process-trust path open (no FsCap). Prefer open_file_cap for guests.
fn open_path(path: string) -> Result<i32, core_Err> {
    let h = fx_sqlite_open_path(path);
    if (h < 1) {
        return Err(1);
    }
    return Ok(h);
}

/// Open DB file under FsCap allowlist. Err(5) = denied.
fn open_file_cap(fs: FsCap, path: string) -> Result<i32, core_Err> {
    let h = fx_sqlite_open_fscap(cap.fs_handle(fs), path);
    if (h == -5) {
        return Err(5);
    }
    if (h < 1) {
        return Err(1);
    }
    return Ok(h);
}

/// Raw open code for probes (-5 = denied; >=1 = handle).
fn open_file_cap_code(fs: FsCap, path: string) -> i32 {
    return fx_sqlite_open_fscap(cap.fs_handle(fs), path);
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
