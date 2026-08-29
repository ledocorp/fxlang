// FX-WF-3/5 — Level 2 cJSON facade (repo lib; link cjson_ref.c + cJSON.c).
// Opaque trees stay in C; fx sees Result / i32 only.
module cjson_safe;

using core;

extern "c" {
    fn cjson_ref_parse_number(json: string) -> i32;
    fn cjson_ref_path_i32(json: string, path: string) -> i32;
    fn cjson_ref_path_exists(json: string, path: string) -> i32;
    fn cjson_ref_path_eq_str(json: string, path: string, expect: string) -> i32;
    fn cjson_ref_path_print(json: string, path: string, raw: i32) -> i32;
}

fn parse_number(json: string) -> Result<i32, core_Err> {
    let n = cjson_ref_parse_number(json);
    if (n < 0) {
        return Err(1);
    }
    return Ok(n);
}

fn path_i32(json: string, path: string) -> Result<i32, core_Err> {
    let n = cjson_ref_path_i32(json, path);
    if (n < 0) {
        return Err(2);
    }
    return Ok(n);
}

fn path_exists(json: string, path: string) -> Result<i32, core_Err> {
    let n = cjson_ref_path_exists(json, path);
    if (n == 0) {
        return Err(3);
    }
    return Ok(1);
}

/// 1 if path resolves, 0 if missing (no Err — for negative checks).
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

/// Print path value to stdout (raw!=0 → bare; else JSON fragment). Ok(0) on success.
fn path_print(json: string, path: string, raw: i32) -> Result<i32, core_Err> {
    let n = cjson_ref_path_print(json, path, raw);
    if (n != 0) {
        return Err(5);
    }
    return Ok(0);
}
