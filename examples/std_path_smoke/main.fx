// path production deepen → 42.
using core;
import std/path;
import std/strutil;

fn main() -> Result<i32, core_Err> effects { alloc } {
    let p = path.join("a", "b")?;
    if (!strutil.contains(p, "a")) {
        return Ok(1);
    }
    if (!path.starts_with(p, "a")) {
        return Ok(2);
    }
    let pl = path.parent_len("x/y");
    if (pl < 0) {
        return Ok(3);
    }
    let bo = path.basename_off("dir/file.txt");
    if (bo != 4) {
        return Ok(4);
    }
    let eo = path.ext_off("dir/file.txt");
    if (eo < 0) {
        return Ok(5);
    }
    if (!path.is_abs("/tmp")) {
        return Ok(6);
    }
    if (!path.has_double_sep("a//b")) {
        return Ok(7);
    }
    return Ok(42);
}
