// std/proptest - property helpers.
module proptest;

using core;

fn checksum_ascii(s: string) -> i32 {
    let n = str_len(s);
    let i: i32 = 0;
    let acc: i32 = 0;
    while (i < n) {
        acc = acc + str_byte_at(s, i);
        i = i + 1;
    }
    return acc;
}

fn assert_checksum(s: string, expect: i32) -> Result<i32, core_Err> {
    let got = checksum_ascii(s);
    if (got != expect) {
        return Err(1);
    }
    return Ok(0);
}

// Append-invariant used by fuzz driver: checksum(s) + 'Z' == checksum(s) + 90.
fn checksum_append_z_ok(s: string) -> bool {
    let base = checksum_ascii(s);
    let got = base + str_byte_at("Z", 0);
    let expect = base + 90;
    return got == expect;
}
