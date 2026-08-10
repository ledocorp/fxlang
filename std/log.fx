// std/log - thin tagged stderr helpers.
module log;

using core;
import std/io;
import std/fmt;

fn info(msg: string) -> Result<i32, core_Err> effects { io } {
    let _a = io.write_err("info: ");
    let _b = io.write_err(msg);
    return Ok(0);
}

fn warn(msg: string) -> Result<i32, core_Err> effects { io } {
    let _a = io.write_err("warn: ");
    let _b = io.write_err(msg);
    return Ok(0);
}

fn error(msg: string) -> Result<i32, core_Err> effects { io } {
    let _a = io.write_err("error: ");
    let _b = io.write_err(msg);
    return Ok(0);
}

fn info_i32(tag: string, n: i32) -> Result<i32, core_Err> effects { io, alloc } {
    let line = fmt.format_tag_i32(tag, n)?;
    let _w = io.write_err(line);
    return Ok(0);
}
