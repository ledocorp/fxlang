// FX-PROD-STD-WALK — list immediate dir names (cwd = fx -o out dir).
using core;
import std/io;
import std/fs;
import std/fs_walk;
import std/strutil;

fn test_list_cwd() -> Result<i32, core_Err> effects { alloc, io } {
    if (io.write_file("walk_marker.txt", "ok") != 0) {
        return Err(2);
    }
    let names = fs_walk.list_names(".")?;
    if (!strutil.contains(names, "walk_marker.txt")) {
        return Err(3);
    }
    let _rm = fs.remove("walk_marker.txt");
    return Ok(0);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_list_cwd()?;
    return Ok(0);
}
