// Level 2 safe wrapper over cJSON FFI shim (BINDGEN-3 + FX-WF-3/5).
// Kept local for bind smoke; durable copy also at lib/cjson_safe.fx.
module cjson_safe;

using core;

extern "c" {
    fn cjson_ref_parse_number(json: string) -> i32;
    fn cjson_ref_path_i32(json: string, path: string) -> i32;
    fn cjson_ref_path_exists(json: string, path: string) -> i32;
    fn cjson_ref_path_eq_str(json: string, path: string, expect: string) -> i32;
    fn cjson_ref_path_print(json: string, path: string, raw: i32) -> i32;
}

/// Parse a JSON number literal (e.g. "42"); Err on failure.
fn parse_number(json: string) -> Result<i32, core_Err> {
    let n = cjson_ref_parse_number(json);
    if (n < 0) {
        return Err(1);
    }
    return Ok(n);
}

/// Walk a dotted / `[index]` path to a JSON number.
fn path_i32(json: string, path: string) -> Result<i32, core_Err> {
    let n = cjson_ref_path_i32(json, path);
    if (n < 0) {
        return Err(2);
    }
    return Ok(n);
}

/// True when the path resolves to any JSON value.
fn path_exists(json: string, path: string) -> Result<i32, core_Err> {
    let n = cjson_ref_path_exists(json, path);
    if (n == 0) {
        return Err(3);
    }
    return Ok(1);
}

/// 1 if path resolves, 0 if missing (no Err - for negative checks).
fn path_resolved(json: string, path: string) -> i32 {
    return cjson_ref_path_exists(json, path);
}

fn path_eq_str(json: string, path: string, expect: string) -> Result<i32, core_Err> {
    let n = cjson_ref_path_eq_str(json, path, expect);
    if (n == 0) {
        return Err(4);
    }
    return Ok(1);
}

fn path_print(json: string, path: string, raw: i32) -> Result<i32, core_Err> {
    let n = cjson_ref_path_print(json, path, raw);
    if (n != 0) {
        return Err(5);
    }
    return Ok(0);
}
