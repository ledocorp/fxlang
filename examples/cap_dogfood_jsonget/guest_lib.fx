// App 2 (jsonget) under FsCap: no ambient std/io.
// Host mints session + FsCap; guest reads via io_cap and scores JSON paths.
using core;
import std/cap;
import std/io_cap;
import cjson_safe;

/// Read JSON under FsCap; return meta.answer + bonus (expect 42).
/// Err(5) = cap deny; Err(2) = IO; Err(3) = path/value reject.
fn run(fs: FsCap, file: string) -> Result<i32, core_Err> effects { io, alloc } {
    let json = io_cap.read_file_cap(fs, file)?;
    let answer = cjson_safe.path_i32(json, "meta.answer")?;
    let bonus = cjson_safe.path_i32(json, "bonus")?;
    let sum: i32 = answer + bonus;
    if (sum != 42) {
        return Err(3);
    }
    let name_ok = cjson_safe.path_eq_str(json, "users[0].name", "Ada")?;
    if (name_ok != 1) {
        return Err(3);
    }
    return Ok(42);
}
