// Result CLI library (C host owns argv).
// Build: fx build tool_lib.fx -o out --emit-c --host host_cli.c
module tool_lib;

using core;
import std/string;

/// Product logic. Host unwraps Result → process exit.
fn run(arg: string) -> Result<i32, core_Err> effects { alloc } {
    if (string.len(arg) == 0) {
        return Err(1);
    }
    return Ok(42);
}
