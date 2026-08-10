// confidence app B: Result/`?` + io (different surface from route_desk).
// Write a tiny manifest, read it back with ?, validate via check helpers, exit Ok(42).
// Dual-path: IR-default `fx run` and `--emit-c` (no silent fallback).
using core;
import std/io;
import std/string;
import check;

fn main() -> Result<i32, core_Err> effects { alloc, io } {
 region r = arena(8192);

 let path = "fx_manifest_gate.tmp";
 let text = "ok=21\n";
 if (io.write_file(path, text) != 0) {
 return Ok(10);
 }
 if (io.file_exists(path) == false) {
 return Ok(11);
 }

 let body = io.read_file(path)?;
 if (string.compare(body, text) == false) {
 return Ok(12);
 }

 // Tag check then score - both Result/`?`.
 let tag_ok = check.require_tag(body, "ok")?;
 if (tag_ok != 0) {
 return Ok(19);
 }
 let n = check.score_line(body)?;
 if (n != 21) {
 return Ok(13);
 }

 // Append a marker line and re-read (io + string).
 if (io.append_file(path, "tag=fx\n") != 0) {
 return Ok(14);
 }
 let again = io.read_file(path)?;
 if (string.len(again) != string.len(text) + 7) {
 return Ok(15);
 }
 // Find "tag=fx" by requiring the tag on a suffix walk - use require on rebuilt tip.
 // Simpler: nlines-style count of newlines == 2.
 let nl: i32 = 0;
 let i: i32 = 0;
 while (i < string.len(again)) {
 if (string.byte_at(again, i) == 10) {
 nl = nl + 1;
 }
 i = i + 1;
 }
 if (nl != 2) {
 return Ok(16);
 }

 if (io.delete_file(path) != 0) {
 return Ok(17);
 }
 if (io.file_exists(path)) {
 return Ok(18);
 }

 // 21 * 2 = 42
 return Ok(n + n);
}
