// std/fs_walk - immediate directory entry names.
module fs_walk;

using core;

extern "c" {
    fn fx_fs_list_names(path: string) -> string;
    fn fx_fs_list_ok(path: string) -> i32;
}

/// Immediate children as newline-joined names (no recursion / no glob).
fn list_names(path: string) -> Result<string, core_Err> effects { io } {
    if (fx_fs_list_ok(path) == 0) {
        return Err(1);
    }
    return Ok(fx_fs_list_names(path));
}
