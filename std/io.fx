// / Z3 - user-facing io facade (stdout, stderr, minimal file I/O)
using core;
module io;

extern "c" {
    effects { io } fn puts(s: string) -> i32;
}

fn write_line(msg: string) -> i32 effects { io } {
    return puts(msg);
}

fn write_err(msg: string) -> i32 effects { io } {
    return io_write_stderr(msg);
}

fn write_file(path: string, text: string) -> i32 effects { io } {
    return fs_write_text(path, text);
}

fn read_file(path: string) -> Result<string, core_Err> effects { io, alloc } {
    return fs_read_text(path);
}

fn file_exists(path: string) -> bool effects { io } {
    return fs_exists(path);
}

fn delete_file(path: string) -> i32 effects { io } {
    return fs_remove(path);
}

fn append_file(path: string, text: string) -> i32 effects { io } {
    return fs_append_text(path, text);
}

fn rename_file(old_path: string, new_path: string) -> i32 effects { io } {
    return fs_rename(old_path, new_path);
}
