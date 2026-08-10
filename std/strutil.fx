// std/strutil - contains / starts_with / ends_with.
// Separate from std/string so normal emit applies (string has hand-rolled C).
module strutil;

using core;

fn contains(s: string, needle: string) -> bool {
    let n = str_len(s);
    let m = str_len(needle);
    if (m == 0) {
        return true;
    }
    if (m > n) {
        return false;
    }
    let i: i32 = 0;
    while (i + m <= n) {
        let j: i32 = 0;
        let matched: i32 = 1;
        while (j < m) {
            if (str_byte_at(s, i + j) != str_byte_at(needle, j)) {
                matched = 0;
                break;
            }
            j = j + 1;
        }
        if (matched == 1) {
            return true;
        }
        i = i + 1;
    }
    return false;
}

fn starts_with(s: string, prefix: string) -> bool {
    let n = str_len(s);
    let m = str_len(prefix);
    if (m > n) {
        return false;
    }
    let i: i32 = 0;
    while (i < m) {
        if (str_byte_at(s, i) != str_byte_at(prefix, i)) {
            return false;
        }
        i = i + 1;
    }
    return true;
}

fn ends_with(s: string, suffix: string) -> bool {
    let n = str_len(s);
    let m = str_len(suffix);
    if (m > n) {
        return false;
    }
    let i: i32 = 0;
    while (i < m) {
        if (str_byte_at(s, n - m + i) != str_byte_at(suffix, i)) {
            return false;
        }
        i = i + 1;
    }
    return true;
}
