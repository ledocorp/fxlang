// user-facing Map<string, i32> facade (LV5)
module map;

fn new() -> Map<string, i32> effects { alloc } {
    return map_new();
}

fn insert(m: Map<string, i32>, key: string, value: i32) -> Map<string, i32> effects { alloc, mut } {
    return map_insert(m, key, value);
}

fn remove(m: Map<string, i32>, key: string) -> Map<string, i32> effects { alloc, mut } {
    return map_remove(m, key);
}

fn get(m: Map<string, i32>, key: string) -> Result<i32, core_Err> {
    return map_get(m, key);
}

fn contains(m: Map<string, i32>, key: string) -> bool {
    return map_contains(m, key);
}

fn len(m: Map<string, i32>) -> i32 {
    return map_len(m);
}

fn nth_key(m: Map<string, i32>, i: i32) -> string {
    return map_nth_key(m, i);
}

fn nth_value(m: Map<string, i32>, i: i32) -> i32 {
    return map_nth_value(m, i);
}
