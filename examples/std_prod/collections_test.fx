// vec/map/set smoke (buf in buf_test.fx - avoid emit monomorph clash).
using core;
import std/testing;
import std/vec;
import std/map;
import std/set;

fn test_vec_map_set() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(8192);
    let v0: Vec<i32> = vec.new(0);
    let v1 = vec.push(v0, 20);
    let v2 = vec.push(v1, 22);
    let s = vec.get(v2, 0) + vec.get(v2, 1);
    let _a = testing.assert_eq_i32(s, 42)?;

    let m0 = map.new();
    let m1 = map.insert(m0, "n", 42);
    let n = map.get(m1, "n")?;
    let _b = testing.assert_eq_i32(n, 42)?;

    let s0 = set.new();
    let s1 = set.insert(s0, "k");
    return testing.assert_true(set.contains(s1, "k"));
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_vec_map_set()?;
    return Ok(0);
}
