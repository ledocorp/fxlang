// std/path - join / starts_with / parent_len / basename_off / ext_off / is_abs.
// String-returning basename/ext/clean wait on str_slice; offsets are the production deepen.
module path;

using core;
import std/string;
import std/strutil;

fn join(dir: string, name: string) -> Result<string, core_Err> effects { alloc } {
    let dl = string.len(dir);
    let nl = string.len(name);
    if (dl == 0) {
        return Ok(name);
    }
    if (nl == 0) {
        return Ok(dir);
    }
    let last = string.byte_at(dir, dl - 1);
    if (last == 47) {
        return string.concat(dir, name);
    }
    if (last == 92) {
        return string.concat(dir, name);
    }
    let mid = string.concat(dir, "/")?;
    return string.concat(mid, name);
}

fn starts_with(s: string, prefix: string) -> bool {
    return strutil.starts_with(s, prefix);
}

fn parent_len(s: string) -> i32 {
    let n = string.len(s);
    let i: i32 = n - 1;
    while (i >= 0) {
        let b = string.byte_at(s, i);
        if (b == 47) {
            return i;
        }
        if (b == 92) {
            return i;
        }
        i = i - 1;
    }
    return -1;
}

/// Start index of the basename component (after last separator), or 0.
fn basename_off(s: string) -> i32 {
    let pl = parent_len(s);
    if (pl < 0) {
        return 0;
    }
    return pl + 1;
}

/// Start index of the extension (first char after final `.` in basename), or -1.
fn ext_off(s: string) -> i32 {
    let n = string.len(s);
    let start = basename_off(s);
    let i: i32 = n - 1;
    while (i >= start) {
        let b = string.byte_at(s, i);
        if (b == 46) {
            if (i + 1 >= n) {
                return -1;
            }
            return i + 1;
        }
        i = i - 1;
    }
    return -1;
}

fn is_abs(s: string) -> bool {
    let n = string.len(s);
    if (n == 0) {
        return false;
    }
    let b0 = string.byte_at(s, 0);
    if (b0 == 47) {
        return true;
    }
    if (b0 == 92) {
        return true;
    }
    return false;
}

/// Nonzero if `s` contains consecutive separators (`//` or `\\`).
fn has_double_sep(s: string) -> bool {
    let n = string.len(s);
    let i: i32 = 0;
    while (i + 1 < n) {
        let a = string.byte_at(s, i);
        let b = string.byte_at(s, i + 1);
        let a_sep: i32 = 0;
        let b_sep: i32 = 0;
        if (a == 47) {
            a_sep = 1;
        }
        if (a == 92) {
            a_sep = 1;
        }
        if (b == 47) {
            b_sep = 1;
        }
        if (b == 92) {
            b_sep = 1;
        }
        if ((a_sep == 1) && (b_sep == 1)) {
            return true;
        }
        i = i + 1;
    }
    return false;
}
