// std/fs - file helpers over std/io.
// Directory listing: std/fs_walk.
module fs;

using core;
import std/io;

fn copy_file(src: string, dst: string) -> Result<i32, core_Err> effects { alloc, io } {
    let body = io.read_file(src)?;
    if (io.write_file(dst, body) != 0) {
        return Err(2);
    }
    return Ok(0);
}

fn exists(path: string) -> bool effects { io } {
    return io.file_exists(path);
}

fn remove(path: string) -> i32 effects { io } {
    return io.delete_file(path);
}
