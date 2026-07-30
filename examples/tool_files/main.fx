// Week-two tool: file lifecycle without Result/? (general emit).
// write → exists → append → rename → delete → exit 42
// Content-verified read+? is proven in monorepo programs/p2_file_io (fx-owned bridge).
import std/io;

fn main() -> i32 effects { alloc, io } {
    region r = arena(4096);
    let path = "fx_week2_a.tmp";
    let path2 = "fx_week2_b.tmp";

    if (io.write_file(path, "week2") != 0) {
        return 1;
    }
    if (io.file_exists(path) == false) {
        return 2;
    }
    if (io.append_file(path, "-ok") != 0) {
        return 3;
    }
    if (io.rename_file(path, path2) != 0) {
        return 4;
    }
    if (io.file_exists(path2) == false) {
        return 5;
    }
    if (io.delete_file(path2) != 0) {
        return 6;
    }
    if (io.file_exists(path2)) {
        return 7;
    }
    io.write_line("tool_files: ok");
    return 42;
}
