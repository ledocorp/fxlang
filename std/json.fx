// std/json - thin cJSON path facade. Link cjson_ref.c + cJSON.c.
// Full validator remains programs/p2_json.
module json;

using core;

extern "c" {
    fn cjson_ref_parse_number(json: string) -> i32;
    fn cjson_ref_path_i32(json: string, path: string) -> i32;
    fn cjson_ref_path_exists(json: string, path: string) -> i32;
    fn cjson_ref_path_eq_str(json: string, path: string, expect: string) -> i32;
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

fn path_eq_str(json: string, path: string, expect: string) -> Result<i32, core_Err> {
    let n = cjson_ref_path_eq_str(json, path, expect);
    if (n == 0) {
        return Err(4);
    }
    return Ok(1);
}
