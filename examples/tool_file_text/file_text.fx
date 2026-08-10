// file + text helpers over std/io + std/string (no new zspec Core).
module file_text;

using core;
import std/io;
import std/string;

/// Write then read back; Err on I/O failure.
fn roundtrip(path: string, text: string) -> Result<string, core_Err> effects { alloc, io } {
 if (io.write_file(path, text) != 0) {
 return Err(1);
 }
 return io.read_file(path);
}

/// Copy file contents src → dst via read + write (no fs_copy builtin).
fn copy(src: string, dst: string) -> Result<i32, core_Err> effects { alloc, io } {
 let body = io.read_file(src)?;
 if (io.write_file(dst, body) != 0) {
 return Err(2);
 }
 return Ok(0);
}

/// Count `\n` bytes in text (line terminators).
fn nlines(text: string) -> i32 {
 let n = string.len(text);
 let i: i32 = 0;
 let c: i32 = 0;
 while (i < n) {
 if (string.byte_at(text, i) == 10) {
 c = c + 1;
 }
 i = i + 1;
 }
 return c;
}

/// Join two lines with newlines and write.
fn write2(path: string, a: string, b: string) -> Result<i32, core_Err> effects { alloc, io } {
 let mid = string.concat(a, "\n")?;
 let all = string.concat(mid, b)?;
 let with_nl = string.concat(all, "\n")?;
 if (io.write_file(path, with_nl) != 0) {
 return Err(3);
 }
 return Ok(0);
}
