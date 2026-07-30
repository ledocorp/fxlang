// Expect exit 6: delete of missing file must fail (nonzero).
import std/io;

fn main() -> i32 effects { alloc, io } {
    region r = arena(4096);
    let path = "fx_week2_delete_missing_xyz.tmp";
    if (io.delete_file(path) != 0) {
        return 6;
    }
    return 99;
}
