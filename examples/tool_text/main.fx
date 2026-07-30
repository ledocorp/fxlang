// FX-0.7.3-M3a: one taught path — StrBuilder → string → file → byte walk → Buf.
// No Result/? (general emit). Exit 42.
import std/string;
import std/buf;
import std/io;

fn main() -> i32 effects { alloc, mut, io } {
    region r = arena(16384);
    let path = "fx_m3a_text.tmp";

    let sb = string.builder();
    sb = string.append(sb, "fx");
    sb = string.append(sb, "-m3");
    let s = string.build(sb);
    if (string.len(s) != 5) {
        return 1;
    }

    if (io.write_file(path, s) != 0) {
        return 2;
    }
    if (io.file_exists(path) == false) {
        return 3;
    }

    // string → bytes via taught walk (no silent conversion builtin).
    let b: Buf = buf.new();
    let i: i32 = 0;
    while (i < string.len(s)) {
        let byte: i32 = string.byte_at(s, i);
        b = buf.push(b, byte as u8);
        i = i + 1;
    }
    if (buf.len(b) != 5) {
        return 4;
    }
    let view = buf.finish(b);
    if (buf.view_len(view) != 5) {
        return 5;
    }
    // 'f'+'x'+'-'+'m'+'3' = 102+120+45+109+51 = 427
    let sum: i32 = 0;
    let j: i32 = 0;
    while (j < buf.view_len(view)) {
        sum = sum + (buf.view_get(view, j) as i32);
        j = j + 1;
    }
    if (sum != 427) {
        return 6;
    }

    if (io.delete_file(path) != 0) {
        return 7;
    }
    io.write_line("tool_text: ok");
    return 42;
}
