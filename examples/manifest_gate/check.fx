// FX-0.8-UX-4 — Result helpers for manifest validation (multi-module).
using core;
import std/string;

fn require_tag(body: string, tag: string) -> Result<i32, core_Err> {
    let n = string.len(body);
    let tlen = string.len(tag);
    if (n < tlen + 1) {
        return Err(1);
    }
    let i: i32 = 0;
    while (i < tlen) {
        if (string.byte_at(body, i) != string.byte_at(tag, i)) {
            return Err(2);
        }
        i = i + 1;
    }
    if (string.byte_at(body, tlen) != 61) {
        return Err(3);
    }
    return Ok(0);
}

fn score_line(body: string) -> Result<i32, core_Err> {
    let n = string.len(body);
    if (n < 5) {
        return Err(4);
    }
    if (string.byte_at(body, 0) != 111) {
        return Err(5);
    }
    if (string.byte_at(body, 1) != 107) {
        return Err(6);
    }
    if (string.byte_at(body, 2) != 61) {
        return Err(7);
    }
    let d0 = string.byte_at(body, 3) - 48;
    if (d0 < 0) {
        return Err(8);
    }
    if (d0 > 9) {
        return Err(9);
    }
    let d1 = string.byte_at(body, 4);
    if (d1 >= 48) {
        if (d1 <= 57) {
            return Ok(d0 * 10 + (d1 - 48));
        }
    }
    return Ok(d0);
}
