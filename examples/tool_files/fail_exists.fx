// Expect exit 2: missing file must not exist.
import std/io;

fn main() -> i32 effects { alloc, io } {
    region r = arena(4096);
    let path = "fx_week2_definitely_missing_xyz.tmp";
    if (io.file_exists(path) == false) {
        return 2;
    }
    return 99;
}
