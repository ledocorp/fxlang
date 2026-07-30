// Expect exit 2: write into missing directory must fail (same path as tool_files).
import std/string;
import std/io;

fn main() -> i32 effects { alloc, mut, io } {
    region r = arena(4096);
    let path = "fx_m3a_no_dir/missing/text.tmp";
    if (io.write_file(path, "fx-m3") != 0) {
        return 2;
    }
    return 99;
}
