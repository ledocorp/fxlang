// Growable region byte buffer (`Buf`) + immutable `Bytes` view.
module buf;

fn new() -> Buf effects { alloc } {
    return buf_new();
}

fn push(b: Buf, x: u8) -> Buf effects { alloc, mut } {
    return buf_push(b, x);
}

fn len(b: Buf) -> i32 {
    return buf_len(b);
}

fn get(b: Buf, i: i32) -> u8 {
    return buf_get(b, i);
}

fn finish(b: Buf) -> Bytes {
    return buf_finish(b);
}

fn view_len(bs: Bytes) -> i32 {
    return bytes_len(bs);
}

fn view_get(bs: Bytes, i: i32) -> u8 {
    return bytes_get(bs, i);
}
