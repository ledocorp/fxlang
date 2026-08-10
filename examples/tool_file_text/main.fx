// consumer - same as programs/p2_ftxt.fx (local import).
using core;
import std/io;
import std/string;
import file_text;

fn main() -> Result<i32, core_Err> effects { alloc, io } {
 region r = arena(8192);
 let path = "fx_std1_a.tmp";
 let path2 = "fx_std1_b.tmp";

 let w0 = file_text.write2(path, "fx", "std-1")?;
 if (w0 != 0) {
 return Ok(10);
 }
 let body = io.read_file(path)?;
 if (string.compare(body, "fx\nstd-1\n") == false) {
 return Ok(1);
 }
 if (file_text.nlines(body) != 2) {
 return Ok(2);
 }

 let again = file_text.roundtrip(path, body)?;
 if (string.compare(again, body) == false) {
 return Ok(3);
 }

 let c0 = file_text.copy(path, path2)?;
 if (c0 != 0) {
 return Ok(11);
 }
 let copied = io.read_file(path2)?;
 if (string.compare(copied, body) == false) {
 return Ok(4);
 }

 if (io.delete_file(path) != 0) {
 return Ok(5);
 }
 if (io.delete_file(path2) != 0) {
 return Ok(6);
 }
 return Ok(42);
}
