// composition app: file_text + stb_image wrap; exit 42.
// Dual-path: IR and emit-C. Link stb_image_ref.c + -lm.
using core;
import std/io;
import std/string;
import lib/file_text;
import stbi_safe;

fn main() -> Result<i32, core_Err> effects { alloc, io } {
 region r = arena(8192);
 let path = "fx_std3.tmp";

 let w0 = file_text.write2(path, "img", "ok")?;
 if (w0 != 0) {
 return Ok(10);
 }
 let body = io.read_file(path)?;
 if (file_text.nlines(body) != 2) {
 return Ok(1);
 }
 let again = file_text.roundtrip(path, body)?;
 if (string.compare(again, body) == false) {
 return Ok(2);
 }
 if (io.delete_file(path) != 0) {
 return Ok(3);
 }

 let n = stbi_safe.decode1()?;
 if (n != 42) {
 return Ok(4);
 }
 return Ok(42);
}
