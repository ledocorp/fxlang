// Negative fixture for FX-DYN-2 enforcement - MUST NOT build with --guest / --host.
// Harness + `fx check --guest` expect FX0031.
import std/io;
using core;

fn run(path: string) -> Result<i32, core_Err> effects { io, alloc } {
    let src = io.read_file(path)?;
    return Ok(str_len(src));
}
