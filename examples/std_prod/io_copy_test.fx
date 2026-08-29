// FX-PROD-STD-4 — std/fs.copy_file roundtrip.
using core;
import std/testing;
import std/io;
import std/fs;

fn test_copy() -> Result<i32, core_Err> effects { alloc, io } {
    let src = "std_prod_copy_src.tmp";
    let dst = "std_prod_copy_dst.tmp";
    if (io.write_file(src, "hello") != 0) {
        return testing.fail("write src");
    }
    let _c = fs.copy_file(src, dst)?;
    let body = io.read_file(dst)?;
    let _d = io.delete_file(src);
    let _e = io.delete_file(dst);
    return testing.assert_eq_i32(str_len(body), 5);
}

fn main() -> Result<i32, core_Err> effects { alloc, io } {
    let _a = test_copy()?;
    return Ok(0);
}
