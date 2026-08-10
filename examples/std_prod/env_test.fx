// getenv / get_or (argv stays host/cli).
using core;
import std/env;
import std/strutil;

fn test_missing() -> Result<i32, core_Err> effects { alloc, io } {
    if (env.has("FX_ENV_TEST_MISSING_XYZ")) {
        return Err(1);
    }
    let v = env.get_or("FX_ENV_TEST_MISSING_XYZ", "fallback");
    if (!strutil.contains(v, "fallback")) {
        return Err(2);
    }
    if (str_len(v) != 8) {
        return Err(3);
    }
    return Ok(0);
}

fn test_path_present() -> Result<i32, core_Err> effects { alloc, io } {
    if (!env.has("PATH")) {
        return Err(4);
    }
    let p = env.get("PATH")?;
    if (str_len(p) < 1) {
        return Err(5);
    }
    return Ok(0);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_missing()?;
    let _b = test_path_present()?;
    return Ok(0);
}
