// dogfood - import std so tidy keeps require std.
using core;
import std/testing;

fn main() -> Result<i32, core_Err> effects { io } {
    return testing.assert_eq_i32(1, 1);
}
