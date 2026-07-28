// / P1b-2 - std/fmt format_i64 + format_tag_i64
module fmt;

import string;

fn format_i32(n: i32) -> Result<string, core_Err> effects { alloc } {
    return str_from_i32(n);
}

fn format_i64(n: i64) -> Result<string, core_Err> effects { alloc } {
    return str_from_i64(n);
}

fn format_tag_i32(tag: string, n: i32) -> Result<string, core_Err> effects { alloc } {
    let num = str_from_i32(n)?;
    return string.concat(tag, num);
}

fn format_tag_i64(tag: string, n: i64) -> Result<string, core_Err> effects { alloc } {
    let num = str_from_i64(n)?;
    return string.concat(tag, num);
}
