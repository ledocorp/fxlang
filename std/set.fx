// HashSet-like facade over Map<string, i32> (presence = value 1).
module set;

import std/map;

fn new() -> Map<string, i32> effects { alloc } {
    return map.new();
}

fn insert(s: Map<string, i32>, key: string) -> Map<string, i32> effects { alloc, mut } {
    return map.insert(s, key, 1);
}

fn remove(s: Map<string, i32>, key: string) -> Map<string, i32> effects { alloc, mut } {
    return map.remove(s, key);
}

fn contains(s: Map<string, i32>, key: string) -> bool {
    return map.contains(s, key);
}

fn len(s: Map<string, i32>) -> i32 {
    return map.len(s);
}
