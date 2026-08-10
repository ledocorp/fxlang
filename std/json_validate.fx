// std/json_validate - RFC8259-subset validator.
// Extracted from programs/p2_json.fx; corpus in validation/reference/json_corpus.tsv.
module json_validate;

using core;

struct Node {
    kind: i32,
    ival: i32,
}

struct P {
    nodes: Vec<Node>,
    pos: i32,
    valid: i32,
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

fn is_hex(b: i32) -> i32 {
    if (is_digit(b) == 1) {
        return 1;
    }
    if (b >= 'a') {
        if (b <= 'f') {
            return 1;
        }
    }
    if (b >= 'A') {
        if (b <= 'F') {
            return 1;
        }
    }
    return 0;
}

fn skip_ws(src: string, n: i32, pos: i32) -> i32 {
    let i: i32 = pos;
    while (i < n) {
        if (is_space(str_byte_at(src, i)) == 0) {
            break;
        }
        i = i + 1;
    }
    return i;
}

fn fail(p: P, at: i32) -> P {
    return P { nodes: p.nodes, pos: at, valid: 0 };
}

// Match a literal keyword (`true`/`false`/`null`) at p.pos and push its node.
fn parse_lit(src: string, n: i32, p: P, word: string, kind: i32, ival: i32) -> P effects { alloc, mut } {
    let wl: i32 = str_len(word);
    if (p.pos + wl > n) {
        return fail(p, p.pos);
    }
    let i: i32 = 0;
    while (i < wl) {
        if (str_byte_at(src, p.pos + i) != str_byte_at(word, i)) {
            return fail(p, p.pos);
        }
        i = i + 1;
    }
    let nodes2: Vec<Node> = vec_push(p.nodes, Node { kind: kind, ival: ival });
    return P { nodes: nodes2, pos: p.pos + wl, valid: 1 };
}

// Parse a JSON string starting at the opening quote (p.pos).
fn parse_string(src: string, n: i32, p: P) -> P effects { alloc, mut } {
    let i: i32 = p.pos + 1;
    let done: i32 = 0;
    let bad: i32 = 0;
    while (i < n) {
        let c: i32 = str_byte_at(src, i);
        if (c == '"') {
            done = 1;
            i = i + 1;
            break;
        }
        if (c == '\\') {
            i = i + 1;
            if (i >= n) {
                bad = 1;
                break;
            }
            let e: i32 = str_byte_at(src, i);
            let okesc: i32 = 0;
            if (e == '"') {
                okesc = 1;
            }
            if (e == '\\') {
                okesc = 1;
            }
            if (e == '/') {
                okesc = 1;
            }
            if (e == 'b') {
                okesc = 1;
            }
            if (e == 'f') {
                okesc = 1;
            }
            if (e == 'n') {
                okesc = 1;
            }
            if (e == 'r') {
                okesc = 1;
            }
            if (e == 't') {
                okesc = 1;
            }
            if (e == 'u') {
                if (i + 4 >= n) {
                    bad = 1;
                    break;
                }
                let h: i32 = 1;
                while (h <= 4) {
                    if (is_hex(str_byte_at(src, i + h)) == 0) {
                        bad = 1;
                    }
                    h = h + 1;
                }
                if (bad == 1) {
                    break;
                }
                i = i + 4;
                okesc = 1;
            }
            if (okesc == 0) {
                bad = 1;
                break;
            }
            i = i + 1;
        } else {
            if (c < 32) {
                bad = 1;
                break;
            }
            i = i + 1;
        }
    }
    if (done == 0) {
        bad = 1;
    }
    if (bad == 1) {
        return fail(p, i);
    }
    let nodes2: Vec<Node> = vec_push(p.nodes, Node { kind: 4, ival: 0 });
    return P { nodes: nodes2, pos: i, valid: 1 };
}

// Parse a JSON number at p.pos: -?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?
fn parse_number(src: string, n: i32, p: P) -> P effects { alloc, mut } {
    let i: i32 = p.pos;
    let sign: i32 = 1;
    if (i < n) {
        if (str_byte_at(src, i) == '-') {
            sign = 0 - 1;
            i = i + 1;
        }
    }
    if (i >= n) {
        return fail(p, i);
    }
    let acc: i32 = 0;
    let c0: i32 = str_byte_at(src, i);
    if (c0 == '0') {
        i = i + 1;
    } else {
        if (is_digit(c0) == 0) {
            return fail(p, i);
        }
        while (i < n) {
            let d: i32 = str_byte_at(src, i);
            if (is_digit(d) == 0) {
                break;
            }
            acc = acc * 10 + (d - '0');
            i = i + 1;
        }
    }
    // fraction
    if (i < n) {
        if (str_byte_at(src, i) == '.') {
            i = i + 1;
            let fd: i32 = 0;
            while (i < n) {
                if (is_digit(str_byte_at(src, i)) == 0) {
                    break;
                }
                fd = fd + 1;
                i = i + 1;
            }
            if (fd == 0) {
                return fail(p, i);
            }
        }
    }
    // exponent
    if (i < n) {
        let ec: i32 = str_byte_at(src, i);
        if (ec == 'e') {
            i = i + 1;
        }
        if (ec == 'E') {
            i = i + 1;
        }
        if (ec == 'e') {
            if (i < n) {
                let s2: i32 = str_byte_at(src, i);
                if (s2 == '+') {
                    i = i + 1;
                }
                if (s2 == '-') {
                    i = i + 1;
                }
            }
            let xd: i32 = 0;
            while (i < n) {
                if (is_digit(str_byte_at(src, i)) == 0) {
                    break;
                }
                xd = xd + 1;
                i = i + 1;
            }
            if (xd == 0) {
                return fail(p, i);
            }
        }
        if (ec == 'E') {
            if (i < n) {
                let s3: i32 = str_byte_at(src, i);
                if (s3 == '+') {
                    i = i + 1;
                }
                if (s3 == '-') {
                    i = i + 1;
                }
            }
            let yd: i32 = 0;
            while (i < n) {
                if (is_digit(str_byte_at(src, i)) == 0) {
                    break;
                }
                yd = yd + 1;
                i = i + 1;
            }
            if (yd == 0) {
                return fail(p, i);
            }
        }
    }
    let nodes2: Vec<Node> = vec_push(p.nodes, Node { kind: 3, ival: acc * sign });
    return P { nodes: nodes2, pos: i, valid: 1 };
}

fn parse_array(src: string, n: i32, p: P, depth: i32) -> P effects { alloc, mut } {
    // p.pos points at '['
    let nodes0: Vec<Node> = vec_push(p.nodes, Node { kind: 5, ival: 0 });
    let cur: P = P { nodes: nodes0, pos: p.pos + 1, valid: 1 };
    let after: i32 = skip_ws(src, n, cur.pos);
    if (after < n) {
        if (str_byte_at(src, after) == ']') {
            return P { nodes: cur.nodes, pos: after + 1, valid: 1 };
        }
    }
    let more: i32 = 1;
    while (more == 1) {
        cur = parse_value(src, n, cur, depth + 1);
        if (cur.valid == 0) {
            return cur;
        }
        let q: i32 = skip_ws(src, n, cur.pos);
        if (q >= n) {
            return fail(cur, q);
        }
        let sep: i32 = str_byte_at(src, q);
        if (sep == ',') {
            cur = P { nodes: cur.nodes, pos: q + 1, valid: 1 };
        } else {
            if (sep == ']') {
                return P { nodes: cur.nodes, pos: q + 1, valid: 1 };
            } else {
                return fail(cur, q);
            }
        }
    }
    return fail(cur, cur.pos);
}

fn parse_object(src: string, n: i32, p: P, depth: i32) -> P effects { alloc, mut } {
    // p.pos points at '{'
    let nodes0: Vec<Node> = vec_push(p.nodes, Node { kind: 6, ival: 0 });
    let cur: P = P { nodes: nodes0, pos: p.pos + 1, valid: 1 };
    let after: i32 = skip_ws(src, n, cur.pos);
    if (after < n) {
        if (str_byte_at(src, after) == '}') {
            return P { nodes: cur.nodes, pos: after + 1, valid: 1 };
        }
    }
    let more: i32 = 1;
    while (more == 1) {
        let ks: i32 = skip_ws(src, n, cur.pos);
        if (ks >= n) {
            return fail(cur, ks);
        }
        if (str_byte_at(src, ks) != '"') {
            return fail(cur, ks);
        }
        cur = parse_string(src, n, P { nodes: cur.nodes, pos: ks, valid: 1 });
        if (cur.valid == 0) {
            return cur;
        }
        let cs: i32 = skip_ws(src, n, cur.pos);
        if (cs >= n) {
            return fail(cur, cs);
        }
        if (str_byte_at(src, cs) != ':') {
            return fail(cur, cs);
        }
        cur = parse_value(src, n, P { nodes: cur.nodes, pos: cs + 1, valid: 1 }, depth + 1);
        if (cur.valid == 0) {
            return cur;
        }
        let q: i32 = skip_ws(src, n, cur.pos);
        if (q >= n) {
            return fail(cur, q);
        }
        let sep: i32 = str_byte_at(src, q);
        if (sep == ',') {
            cur = P { nodes: cur.nodes, pos: q + 1, valid: 1 };
        } else {
            if (sep == '}') {
                return P { nodes: cur.nodes, pos: q + 1, valid: 1 };
            } else {
                return fail(cur, q);
            }
        }
    }
    return fail(cur, cur.pos);
}

fn parse_value(src: string, n: i32, p: P, depth: i32) -> P effects { alloc, mut } {
    if (p.valid == 0) {
        return p;
    }
    if (depth > 400) {
        return fail(p, p.pos);
    }
    let pos: i32 = skip_ws(src, n, p.pos);
    if (pos >= n) {
        return fail(p, pos);
    }
    let c: i32 = str_byte_at(src, pos);
    let at: P = P { nodes: p.nodes, pos: pos, valid: 1 };
    if (c == '{') {
        return parse_object(src, n, at, depth);
    }
    if (c == '[') {
        return parse_array(src, n, at, depth);
    }
    if (c == '"') {
        return parse_string(src, n, at);
    }
    if (c == 't') {
        return parse_lit(src, n, at, "true", 2, 1);
    }
    if (c == 'f') {
        return parse_lit(src, n, at, "false", 2, 0);
    }
    if (c == 'n') {
        return parse_lit(src, n, at, "null", 1, 0);
    }
    if (c == '-') {
        return parse_number(src, n, at);
    }
    if (is_digit(c) == 1) {
        return parse_number(src, n, at);
    }
    return fail(at, pos);
}

// Validate a whole JSON document: one value, optional trailing whitespace, EOF.
// Returns 1 if the text is valid JSON, else 0.
fn validate(src: string) -> i32 effects { alloc, mut } {
    let n: i32 = str_len(src);
    let start: Vec<Node> = vec_new(0);
    let p0: P = P { nodes: start, pos: 0, valid: 1 };
    let p: P = parse_value(src, n, p0, 0);
    if (p.valid == 0) {
        return 0;
    }
    let end: i32 = skip_ws(src, n, p.pos);
    if (end != n) {
        return 0;
    }
    return 1;
}

