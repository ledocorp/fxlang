// user-facing string helpers (L2)
module string;

fn compare(a: string, b: string) -> bool {
    return str_compare(a, b);
}

fn concat(a: string, b: string) -> Result<string, core_Err> effects { alloc } {
    return str_concat(a, b);
}

// SH-READINESS G1 - string→bytes bridge (pure). Lets fx walk source text.
fn len(s: string) -> i32 {
    return str_len(s);
}

fn byte_at(s: string, i: i32) -> i32 {
    return str_byte_at(s, i);
}

// LV4 - amortized string builder facade. `builder()` allocates a grow buffer on
// the caller's region; `append` grows it (capacity-doubling, O(n) amortized);
// `build` finishes into a NUL-terminated string; `builder_len` reports the length.
fn builder() -> StrBuilder effects { alloc } {
    return strbuf_new();
}

fn append(b: StrBuilder, s: string) -> StrBuilder effects { alloc, mut } {
    return strbuf_push(b, s);
}

fn build(b: StrBuilder) -> string {
    return strbuf_finish(b);
}

fn builder_len(b: StrBuilder) -> i32 {
    return strbuf_len(b);
}
