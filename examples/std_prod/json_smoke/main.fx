// FX-PROD-STD-6 — std/json path get → 42 (needs cJSON link).
using core;
import std/json;

fn main() -> Result<i32, core_Err> {
    let body = "{\"meta\":{\"code\":40},\"bonus\":2}";
    let code = json.path_i32(body, "meta.code")?;
    let bonus = json.path_i32(body, "bonus")?;
    let sum = code + bonus;
    if (sum != 42) {
        return Ok(1);
    }
    return Ok(42);
}
