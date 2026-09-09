// FX-WF-3/5 — path-get helper over lib/cjson_safe.
module json_path;

using core;
import cjson_safe;

fn get_i32(json: string, path: string) -> Result<i32, core_Err> {
    return cjson_safe.path_i32(json, path);
}

fn exists(json: string, path: string) -> Result<i32, core_Err> {
    return cjson_safe.path_exists(json, path);
}

fn eq_str(json: string, path: string, expect: string) -> Result<i32, core_Err> {
    return cjson_safe.path_eq_str(json, path, expect);
}

fn print(json: string, path: string, raw: i32) -> Result<i32, core_Err> {
    return cjson_safe.path_print(json, path, raw);
}
