// fx diagnostics helpers (inspectable compiler source).
// Read-only snapshot for humans. Run the binary in bin/, do not rebuild from here.

module sh_diag;

using core;

import std/fx_defaults;
import std/string;
import sh_lexer;

struct ShDiag {
    code: i32,
    span_off: i32,
    span_len: i32,
}

fn sh_diag_empty() -> ShDiag {
    return ShDiag { code: 0, span_off: 0, span_len: 0 };
}

fn sh_code_type_mismatch() -> i32 {
    return 6;
}

fn sh_code_return_mismatch() -> i32 {
    return 11;
}

fn sh_diag_return_mismatch(span_off: i32, span_len: i32) -> ShDiag {
    return ShDiag {
        code: sh_code_return_mismatch(),
        span_off: span_off,
        span_len: span_len,
    };
}

fn sh_diag_type_mismatch(span_off: i32, span_len: i32) -> ShDiag {
    return ShDiag {
        code: sh_code_type_mismatch(),
        span_off: span_off,
        span_len: span_len,
    };
}

fn sh_diag_code_tag(code: i32) -> Result<string, core_Err> effects { alloc, mut } {
    if (code == sh_code_return_mismatch()) {
        return Ok("FX0011");
    }
    if (code == sh_code_type_mismatch()) {
        return Ok("FX0006");
    }
    return Ok("FX0000");
}

fn sh_diag_msg_for_code(code: i32) -> Result<string, core_Err> effects { alloc, mut } {
    if (code == sh_code_return_mismatch()) {
        return Ok("return type mismatch");
    }
    if (code == sh_code_type_mismatch()) {
        return Ok("type mismatch");
    }
    return Ok("error");
}

fn format_sh_diag_line(d: ShDiag) -> Result<string, core_Err> effects { alloc, mut } {
    let tag: string = sh_diag_code_tag(d.code)?;
    let msg: string = sh_diag_msg_for_code(d.code)?;
    let p1: string = str_concat("error[", tag)?;
    let p2: string = str_concat(p1, "]: ")?;
    let p3: string = str_concat(p2, msg)?;
    return str_concat(p3, "\n");
}

fn sh_diag_from_parts(code: i32, span_off: i32, span_len: i32) -> ShDiag {
    return ShDiag {
        code: code,
        span_off: span_off,
        span_len: span_len,
    };
}

fn format_sh_diag_parts(code: i32, span_off: i32, span_len: i32) -> Result<string, core_Err> effects { alloc, mut } {
    let d: ShDiag = sh_diag_from_parts(code, span_off, span_len);
    return format_sh_diag_line(d);
}

fn sh_diag_tests() -> Result<i32, core_Err> effects { alloc, mut } {
    region r = arena(fx_defaults.arena_boot());
    let d: ShDiag = sh_diag_return_mismatch(10, 5);
    if (d.code != sh_code_return_mismatch()) {
        return Ok(120);
    }
    if (d.span_off != 10) {
        return Ok(121);
    }
    if (d.span_len != 5) {
        return Ok(122);
    }
    let line: string = format_sh_diag_line(d)?;
    if (sh_lexer.slice_eq(line, 0, 6, "error[") != 1) {
        return Ok(123);
    }
    if (sh_lexer.slice_eq(line, 6, 6, "FX0011") != 1) {
        return Ok(124);
    }
    if (string.len(line) < 20) {
        return Ok(125);
    }
    let d6: ShDiag = sh_diag_type_mismatch(0, 3);
    let tag6: string = sh_diag_code_tag(d6.code)?;
    if (sh_lexer.slice_eq(tag6, 0, 6, "FX0006") != 1) {
        return Ok(126);
    }
    return Ok(42);
}
