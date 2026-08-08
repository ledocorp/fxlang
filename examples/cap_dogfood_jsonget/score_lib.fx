// Pure score — keeps IR dual-path free of host/cJSON externs.
fn score(src: string) -> i32 {
    if (str_len(src) < 2) {
        return 3;
    }
    if (str_byte_at(src, 0) != 111) {
        return 3;
    }
    if (str_byte_at(src, 1) != 107) {
        return 3;
    }
    return 42;
}
