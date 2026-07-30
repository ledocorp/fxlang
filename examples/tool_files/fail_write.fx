// Expect exit 1: write into a non-existent directory must fail.
import std/io;

fn main() -> i32 effects { alloc, io } {
    region r = arena(4096);
    let path = "fx_week2_no_dir/missing/write.tmp";
    if (io.write_file(path, "nope") != 0) {
        return 1;
    }
    return 99;
}
