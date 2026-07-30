// Expect exit 4: rename of missing source must fail.
import std/io;

fn main() -> i32 effects { alloc, io } {
    region r = arena(4096);
    if (io.rename_file("fx_week2_rename_missing_a.tmp", "fx_week2_rename_missing_b.tmp") != 0) {
        return 4;
    }
    return 99;
}
