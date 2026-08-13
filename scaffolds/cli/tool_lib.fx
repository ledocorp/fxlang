// Result CLI library - product path: `fx build tool_lib.fx -o out --emit-c --cli`
//
module tool_lib;

using core;
import std/string;

extern "c" {
    fn fx_cli_argc() -> i32;
    fn fx_cli_arg(i: i32) -> string;
}

fn eq(a: string, b: string) -> bool {
    return string.compare(a, b);
}

/// Zero-arg entry for --cli. Reads argv[1] as the tool argument.
fn cli_main() -> Result<i32, core_Err> effects { alloc } {
    let argc = fx_cli_argc();
    if (argc < 2) {
        return Err(1);
    }
    let arg = fx_cli_arg(1);
    return run(arg);
}

/// Product logic. Auto-host unwraps Result → process exit.
fn run(arg: string) -> Result<i32, core_Err> effects { alloc } {
    if (string.len(arg) == 0) {
        return Err(1);
    }
    if (eq(arg, "") == true) {
        return Err(1);
    }
    return Ok(42);
}
