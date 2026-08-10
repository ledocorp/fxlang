// fx-native fuzz driver (run via `fx fuzz` / `fx test --fuzz`).
using core;
import std/testing;
import std/proptest;

fn test_append_invariant_batch() -> Result<i32, core_Err> effects { io } {
    let i: i32 = 0;
    while (i < 256) {
        if (!proptest.checksum_append_z_ok("abcd")) {
            return testing.fail("fuzz: append invariant failed");
        }
        if (!proptest.checksum_append_z_ok("")) {
            return testing.fail("fuzz: empty append invariant failed");
        }
        if (!proptest.checksum_append_z_ok("hello")) {
            return testing.fail("fuzz: hello append invariant failed");
        }
        i = i + 1;
    }
    return Ok(0);
}

fn main() -> Result<i32, core_Err> effects { io } {
    return test_append_invariant_batch();
}
