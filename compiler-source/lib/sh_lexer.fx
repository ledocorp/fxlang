// fx lexer (inspectable compiler source).
// Token streams use parallel kind/val/len vectors.
// Read-only snapshot for humans. Run the binary in bin/, do not rebuild from here.

module sh_lexer;

import std/fx_defaults;
import std/vec;

struct TokBuf {
    kinds: Vec<i32>,
    vals: Vec<i32>,
    lens: Vec<i32>,
}

fn push_tok(buf: TokBuf, kind: i32, val: i32, len: i32) -> TokBuf effects { alloc, mut } {
    buf.kinds = vec.push(buf.kinds, kind);
    buf.vals = vec.push(buf.vals, val);
    buf.lens = vec.push(buf.lens, len);
    return buf;
}

fn is_space(b: i32) -> i32 {
    if (b == ' ') {
        return 1;
    }
    if (b == '\t') {
        return 1;
    }
    if (b == '\n') {
        return 1;
    }
    if (b == '\r') {
        return 1;
    }
    return 0;
}

fn is_digit(b: i32) -> i32 {
    if (b < '0') {
        return 0;
    }
    if (b > '9') {
        return 0;
    }
    return 1;
}

fn is_ident_start(b: i32) -> i32 {
    if (b >= 'a') {
        if (b <= 'z') {
            return 1;
        }
    }
    if (b >= 'A') {
        if (b <= 'Z') {
            return 1;
        }
    }
    if (b == '_') {
        return 1;
    }
    return 0;
}

fn is_ident_part(b: i32) -> i32 {
    if (is_ident_start(b) == 1) {
        return 1;
    }
    return is_digit(b);
}

fn slice_eq(src: string, start: i32, len: i32, lit: string) -> i32 {
    if (str_len(lit) != len) {
        return 0;
    }
    let i: i32 = 0;
    while (i < len) {
        if (str_byte_at(src, start + i) != str_byte_at(lit, i)) {
            return 0;
        }
        i = i + 1;
    }
    return 1;
}

fn ident_char_str(b: i32) -> string {
    if (b == 32) { return " "; }
    // SH-C-45 - StrLit re-emit via slice_str needs punctuation beyond ident/path chars.
    if (b == 34) { return "\""; }
    if (b == 35) { return "#"; }
    if (b == 38) { return "&"; }
    if (b == 40) { return "("; }
    if (b == 41) { return ")"; }
    if (b == 42) { return "*"; }
    if (b == 44) { return ","; }
    if (b == 58) { return ":"; }
    if (b == 59) { return ";"; }
    if (b == 64) { return "@"; }
    // SH-C-46 - StrLit re-emit for emit-radius tokens (=+<>{}).
    if (b == 43) { return "+"; }
    // SH-C-73 - StrLit re-emit for '-' (ASCII 45); required for smoke `->` / mut sigs.
    if (b == 45) { return "-"; }
    if (b == 61) { return "="; }
    if (b == 60) { return "<"; }
    if (b == 62) { return ">"; }
    if (b == 123) { return "{"; }
    if (b == 125) { return "}"; }
    if (b == 92) { return "\\"; }
    if (b == 124) { return "|"; }
    if (b == 77) { return "M"; }
    if (b == 95) { return "_"; }
    if (b == 46) { return "."; }
    if (b == 47) { return "/"; }
    if (b == 48) { return "0"; }
    if (b == 49) { return "1"; }
    if (b == 50) { return "2"; }
    if (b == 51) { return "3"; }
    if (b == 52) { return "4"; }
    if (b == 53) { return "5"; }
    if (b == 54) { return "6"; }
    if (b == 55) { return "7"; }
    if (b == 56) { return "8"; }
    if (b == 57) { return "9"; }
    if (b == 65) { return "A"; }
    if (b == 66) { return "B"; }
    if (b == 67) { return "C"; }
    if (b == 68) { return "D"; }
    if (b == 69) { return "E"; }
    if (b == 70) { return "F"; }
    if (b == 71) { return "G"; }
    if (b == 72) { return "H"; }
    if (b == 73) { return "I"; }
    if (b == 74) { return "J"; }
    if (b == 75) { return "K"; }
    if (b == 76) { return "L"; }
    if (b == 77) { return "M"; }
    if (b == 78) { return "N"; }
    if (b == 79) { return "O"; }
    if (b == 80) { return "P"; }
    if (b == 81) { return "Q"; }
    if (b == 82) { return "R"; }
    if (b == 83) { return "S"; }
    if (b == 84) { return "T"; }
    if (b == 85) { return "U"; }
    if (b == 86) { return "V"; }
    if (b == 87) { return "W"; }
    if (b == 88) { return "X"; }
    if (b == 89) { return "Y"; }
    if (b == 90) { return "Z"; }
    if (b == 97) { return "a"; }
    if (b == 98) { return "b"; }
    if (b == 99) { return "c"; }
    if (b == 100) { return "d"; }
    if (b == 101) { return "e"; }
    if (b == 102) { return "f"; }
    if (b == 103) { return "g"; }
    if (b == 104) { return "h"; }
    if (b == 105) { return "i"; }
    if (b == 106) { return "j"; }
    if (b == 107) { return "k"; }
    if (b == 108) { return "l"; }
    if (b == 109) { return "m"; }
    if (b == 110) { return "n"; }
    if (b == 111) { return "o"; }
    if (b == 112) { return "p"; }
    if (b == 113) { return "q"; }
    if (b == 114) { return "r"; }
    if (b == 115) { return "s"; }
    if (b == 116) { return "t"; }
    if (b == 117) { return "u"; }
    if (b == 118) { return "v"; }
    if (b == 119) { return "w"; }
    if (b == 120) { return "x"; }
    if (b == 121) { return "y"; }
    if (b == 122) { return "z"; }
    return "";
}

fn slice_str(src: string, start: i32, len: i32) -> Result<string, core_Err> effects { alloc, mut } {
    if (len == 0) {
        return Ok("");
    }
    let ch: string = ident_char_str(str_byte_at(src, start));
    if (str_len(ch) == 0) {
        return Err(1);
    }
    if (len == 1) {
        return Ok(ch);
    }
    let tail: string = slice_str(src, start + 1, len - 1)?;
    return str_concat(ch, tail);
}

fn upper_byte(b: i32) -> i32 {
    if (b >= 97) {
        if (b <= 122) {
            return b - 32;
        }
    }
    return b;
}

fn lower_byte(b: i32) -> i32 {
    if (b >= 65) {
        if (b <= 90) {
            return b + 32;
        }
    }
    return b;
}

fn mangle_upper_slice(src: string, start: i32, len: i32) -> Result<string, core_Err> effects { alloc, mut } {
    if (len == 0) {
        return Ok("");
    }
    let ch: string = ident_char_str(upper_byte(str_byte_at(src, start)));
    if (str_len(ch) == 0) {
        return Err(1);
    }
    if (len == 1) {
        return Ok(ch);
    }
    let tail: string = mangle_upper_slice(src, start + 1, len - 1)?;
    return str_concat(ch, tail);
}

fn keyword_at(src: string, start: i32, len: i32) -> i32 {
    if (slice_eq(src, start, len, "let") == 1) {
        return 20;
    }
    if (slice_eq(src, start, len, "fn") == 1) {
        return 21;
    }
    if (slice_eq(src, start, len, "return") == 1) {
        return 22;
    }
    if (slice_eq(src, start, len, "if") == 1) {
        return 23;
    }
    if (slice_eq(src, start, len, "else") == 1) {
        return 24;
    }
    if (slice_eq(src, start, len, "while") == 1) {
        return 25;
    }
    if (slice_eq(src, start, len, "break") == 1) {
        return 31;
    }
    if (slice_eq(src, start, len, "region") == 1) {
        return 26;
    }
    if (slice_eq(src, start, len, "arena") == 1) {
        return 27;
    }
    if (slice_eq(src, start, len, "effects") == 1) {
        return 28;
    }
    if (slice_eq(src, start, len, "module") == 1) {
        return 29;
    }
    if (slice_eq(src, start, len, "import") == 1) {
        return 32;
    }
    if (slice_eq(src, start, len, "enum") == 1) {
        return 33;
    }
    if (slice_eq(src, start, len, "struct") == 1) {
        return 34;
    }
    if (slice_eq(src, start, len, "match") == 1) {
        return 35;
    }
    if (slice_eq(src, start, len, "for") == 1) {
        return 41;
    }
    if (slice_eq(src, start, len, "continue") == 1) {
        return 42;
    }
    return 30;
}

fn lex(src: string) -> TokBuf effects { alloc, mut } {
    let n: i32 = str_len(src);
    let kinds: Vec<i32> = vec.new(0);
    let vals: Vec<i32> = vec.new(0);
    let lens: Vec<i32> = vec.new(0);
    let buf: TokBuf = TokBuf {
        kinds: kinds,
        vals: vals,
        lens: lens,
    };
    let pos: i32 = 0;
    while (pos < n) {
        let b: i32 = str_byte_at(src, pos);
        if (is_space(b) == 1) {
            pos = pos + 1;
        } else {
            if (is_digit(b) == 1) {
                let num: i32 = 0;
                while (pos < n) {
                    let d: i32 = str_byte_at(src, pos);
                    if (is_digit(d) == 0) {
                        break;
                    }
                    num = num * 10 + (d - '0');
                    pos = pos + 1;
                }
                buf = push_tok(buf, 1, num, 0);
            } else {
                if (is_ident_start(b) == 1) {
                    let start: i32 = pos;
                    pos = pos + 1;
                    while (pos < n) {
                        let c: i32 = str_byte_at(src, pos);
                        if (is_ident_part(c) == 0) {
                            break;
                        }
                        pos = pos + 1;
                    }
                    let end: i32 = pos;
                    while (pos < n) {
                        if (str_byte_at(src, pos) != '.') {
                            break;
                        }
                        if (pos + 1 >= n) {
                            break;
                        }
                        if (is_ident_start(str_byte_at(src, pos + 1)) != 1) {
                            break;
                        }
                        pos = pos + 1;
                        while (pos < n) {
                            let c: i32 = str_byte_at(src, pos);
                            if (is_ident_part(c) == 0) {
                                break;
                            }
                            pos = pos + 1;
                        }
                        end = pos;
                    }
                    let qlen: i32 = end - start;
                    let kind: i32 = keyword_at(src, start, qlen);
                    buf = push_tok(buf, kind, start, qlen);
                } else {
                    if (b == '"') {
                        let start: i32 = pos + 1;
                        pos = pos + 1;
                        while (pos < n) {
                            let c: i32 = str_byte_at(src, pos);
                            // SH-C-45 - allow \" inside string lits (bootstrap string escape).
                            if (c == 92) {
                                if (pos + 1 < n) {
                                    pos = pos + 2;
                                    continue;
                                }
                            }
                            if (c == '"') {
                                break;
                            }
                            pos = pos + 1;
                        }
                        if (pos < n) {
                            let slen: i32 = pos - start;
                            buf = push_tok(buf, 37, start, slen);
                            pos = pos + 1;
                        } else {
                            pos = pos + 1;
                        }
                    } else {
                    // CONV-3-r.23 - char lit `'A'` / `'\n'` -> kind 41, val = byte.
                    if (b == '\'') {
                        pos = pos + 1;
                        let value: i32 = 0;
                        if (pos < n) {
                            let c: i32 = str_byte_at(src, pos);
                            if (c == '\\') {
                                pos = pos + 1;
                                if (pos < n) {
                                    let e: i32 = str_byte_at(src, pos);
                                    if (e == 'n') {
                                        value = 10;
                                    } else {
                                        if (e == 't') {
                                            value = 9;
                                        } else {
                                            if (e == 'r') {
                                                value = 13;
                                            } else {
                                                if (e == '0') {
                                                    value = 0;
                                                } else {
                                                    if (e == '\\') {
                                                        value = 92;
                                                    } else {
                                                        if (e == '\'') {
                                                            value = 39;
                                                        } else {
                                                            if (e == '"') {
                                                                value = 34;
                                                            } else {
                                                                value = e;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    pos = pos + 1;
                                }
                            } else {
                                value = c;
                                pos = pos + 1;
                            }
                        }
                        if (pos < n) {
                            if (str_byte_at(src, pos) == '\'') {
                                pos = pos + 1;
                            }
                        }
                        buf = push_tok(buf, 41, value, 0);
                    } else {
                    if (b == '+') {
                        buf = push_tok(buf, 2, b, 0);
                        pos = pos + 1;
                    } else {
                        if (b == '-') {
                            buf = push_tok(buf, 3, b, 0);
                            pos = pos + 1;
                        } else {
                            if (b == '*') {
                                buf = push_tok(buf, 4, b, 0);
                                pos = pos + 1;
                            } else {
                                if (b == '/') {
                                    buf = push_tok(buf, 5, b, 0);
                                    pos = pos + 1;
                                } else {
                                    if (b == '(') {
                                        buf = push_tok(buf, 6, b, 0);
                                        pos = pos + 1;
                                    } else {
                                        if (b == ')') {
                                            buf = push_tok(buf, 7, b, 0);
                                            pos = pos + 1;
                                        } else {
                                            if (b == '{') {
                                                buf = push_tok(buf, 8, b, 0);
                                                pos = pos + 1;
                                            } else {
                                                if (b == '}') {
                                                    buf = push_tok(buf, 9, b, 0);
                                                    pos = pos + 1;
                                                } else {
                                                    if (b == '=') {
                                                        if (pos + 1 < n) {
                                                            if (str_byte_at(src, pos + 1) == '=') {
                                                                buf = push_tok(buf, 40, b, 0);
                                                                pos = pos + 2;
                                                            } else {
                                                                if (str_byte_at(src, pos + 1) == '>') {
                                                                    buf = push_tok(buf, 36, b, 0);
                                                                    pos = pos + 2;
                                                                } else {
                                                                    buf = push_tok(buf, 10, b, 0);
                                                                    pos = pos + 1;
                                                                }
                                                            }
                                                        } else {
                                                            buf = push_tok(buf, 10, b, 0);
                                                            pos = pos + 1;
                                                        }
                                                    } else {
                                                        if (b == ':') {
                                                            buf = push_tok(buf, 11, b, 0);
                                                            pos = pos + 1;
                                                        } else {
                                                            if (b == ',') {
                                                                buf = push_tok(buf, 12, b, 0);
                                                                pos = pos + 1;
                                                            } else {
                                                                if (b == ';') {
                                                                    buf = push_tok(buf, 13, b, 0);
                                                                    pos = pos + 1;
                                                                } else {
                                                                    if (b == '&') {
                                                                        buf = push_tok(buf, 14, b, 0);
                                                                        pos = pos + 1;
                                                                    } else {
                                                                        if (b == '<') {
                                                                            if (pos + 1 < n) {
                                                                                if (str_byte_at(src, pos + 1) == '=') {
                                                                                    // CONV-3-r.25 - `<=` (kind 43; 42 is `continue`).
                                                                                    buf = push_tok(buf, 43, b, 0);
                                                                                    pos = pos + 2;
                                                                                } else {
                                                                                    buf = push_tok(buf, 15, b, 0);
                                                                                    pos = pos + 1;
                                                                                }
                                                                            } else {
                                                                                buf = push_tok(buf, 15, b, 0);
                                                                                pos = pos + 1;
                                                                            }
                                                                        } else {
                                                                            if (b == '>') {
                                                                                if (pos + 1 < n) {
                                                                                    if (str_byte_at(src, pos + 1) == '=') {
                                                                                        buf = push_tok(buf, 39, b, 0);
                                                                                        pos = pos + 2;
                                                                                    } else {
                                                                                        buf = push_tok(buf, 16, b, 0);
                                                                                        pos = pos + 1;
                                                                                    }
                                                                                } else {
                                                                                    buf = push_tok(buf, 16, b, 0);
                                                                                    pos = pos + 1;
                                                                                }
                                                                            } else {
                                                                                if (b == '!') {
                                                                                    if (pos + 1 < n) {
                                                                                        if (str_byte_at(src, pos + 1) == '=') {
                                                                                            buf = push_tok(buf, 38, b, 0);
                                                                                            pos = pos + 2;
                                                                                        } else {
                                                                                            pos = pos + 1;
                                                                                        }
                                                                                    } else {
                                                                                        pos = pos + 1;
                                                                                    }
                                                                                } else {
                                                                                    if (b == '?') {
                                                                                        buf = push_tok(buf, 17, b, 0);
                                                                                        pos = pos + 1;
                                                                                    } else {
                                                                                        pos = pos + 1;
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    }
                    }
                }
            }
        }
    }
    return buf;
}

// Helpers keep builtin `vec_get` (FX0028 requires region in the *same* fn as `vec.get`).
fn expect_kind(buf: TokBuf, idx: i32, want: i32) -> i32 {
    if (vec_get(buf.kinds, idx) != want) {
        return 1;
    }
    return 0;
}

fn expect_num(buf: TokBuf, idx: i32, want: i32) -> i32 {
    if (expect_kind(buf, idx, 1) != 0) {
        return 1;
    }
    if (vec_get(buf.vals, idx) != want) {
        return 2;
    }
    return 0;
}

fn expect_ident(buf: TokBuf, idx: i32, src: string, name: string) -> i32 {
    if (expect_kind(buf, idx, 30) != 0) {
        return 1;
    }
    let start: i32 = vec_get(buf.vals, idx);
    let len: i32 = vec_get(buf.lens, idx);
    if (slice_eq(src, start, len, name) != 1) {
        return 2;
    }
    return 0;
}

fn expect_kw(buf: TokBuf, idx: i32, want: i32) -> i32 {
    if (vec_get(buf.kinds, idx) != want) {
        return 1;
    }
    return 0;
}

fn check_let_add() -> i32 effects { alloc, mut } {
    region r = arena(fx_defaults.arena_boot());
    let src: string = "let x = 1 + 2";
    let buf: TokBuf = lex(src);
    if (buf.kinds.len != 6) {
        return 1;
    }
    // SH-ERG-4.2 - `std/vec.get` on arena-backed token stream (same region as lex).
    if (vec.get(buf.kinds, 0) != 20) {
        return 2;
    }
    if (expect_kw(buf, 0, 20) != 0) {
        return 2;
    }
    if (expect_ident(buf, 1, src, "x") != 0) {
        return 3;
    }
    if (expect_kind(buf, 2, 10) != 0) {
        return 4;
    }
    if (expect_num(buf, 3, 1) != 0) {
        return 5;
    }
    if (expect_kind(buf, 4, 2) != 0) {
        return 6;
    }
    if (expect_num(buf, 5, 2) != 0) {
        return 7;
    }
    return 0;
}

fn check_fn_return() -> i32 effects { alloc, mut } {
    region r = arena(fx_defaults.arena_boot());
    let src: string = "fn f() -> i32 { return 1; }";
    let buf: TokBuf = lex(src);
    if (buf.kinds.len != 12) {
        return 1;
    }
    if (expect_kw(buf, 0, 21) != 0) {
        return 2;
    }
    if (expect_ident(buf, 1, src, "f") != 0) {
        return 3;
    }
    if (expect_kind(buf, 2, 6) != 0) {
        return 4;
    }
    if (expect_kind(buf, 3, 7) != 0) {
        return 5;
    }
    if (expect_kind(buf, 4, 3) != 0) {
        return 6;
    }
    if (expect_kind(buf, 5, 16) != 0) {
        return 7;
    }
    if (expect_ident(buf, 6, src, "i32") != 0) {
        return 8;
    }
    if (expect_kind(buf, 7, 8) != 0) {
        return 9;
    }
    if (expect_kw(buf, 8, 22) != 0) {
        return 10;
    }
    if (expect_num(buf, 9, 1) != 0) {
        return 11;
    }
    if (expect_kind(buf, 10, 13) != 0) {
        return 12;
    }
    if (expect_kind(buf, 11, 9) != 0) {
        return 13;
    }
    return 0;
}

fn check_while_loop() -> i32 effects { alloc, mut } {
    region r = arena(fx_defaults.arena_boot());
    let src: string = "  while i < 10 { i = i + 1; }";
    let buf: TokBuf = lex(src);
    if (buf.kinds.len != 12) {
        return 1;
    }
    if (expect_kw(buf, 0, 25) != 0) {
        return 2;
    }
    if (expect_ident(buf, 1, src, "i") != 0) {
        return 3;
    }
    if (expect_kind(buf, 2, 15) != 0) {
        return 4;
    }
    if (expect_num(buf, 3, 10) != 0) {
        return 5;
    }
    if (expect_kind(buf, 4, 8) != 0) {
        return 6;
    }
    if (expect_ident(buf, 5, src, "i") != 0) {
        return 7;
    }
    if (expect_kind(buf, 6, 10) != 0) {
        return 8;
    }
    if (expect_ident(buf, 7, src, "i") != 0) {
        return 9;
    }
    if (expect_kind(buf, 8, 2) != 0) {
        return 10;
    }
    if (expect_num(buf, 9, 1) != 0) {
        return 11;
    }
    if (expect_kind(buf, 10, 13) != 0) {
        return 12;
    }
    if (expect_kind(buf, 11, 9) != 0) {
        return 13;
    }
    return 0;
}

fn smoke_tests() -> i32 effects { alloc, mut } {
    region r = arena(fx_defaults.arena_parse());
    if (check_let_add() != 0) {
        return 1;
    }
    if (check_fn_return() != 0) {
        return 2;
    }
    if (check_while_loop() != 0) {
        return 3;
    }
    return 42;
}
