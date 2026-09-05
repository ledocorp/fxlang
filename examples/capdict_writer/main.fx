// examples/capdict_writer - CapDict mint + invoke (Season F).
// Run: fx run examples/capdict_writer/main.fx --driver sh --emit-c
// Expect exit 42. CapDict IR is out-of-claim (use --emit-c / --fallback-emit-c).
// Live: FX-SH-LIVE-CAPDICT-CONV-1.
capdict WriterDict {
    fn write(_ctx: &mut opaque, n: i32) -> i32
        effects { mut };
}

struct File {
    _pad: i32,
}

fn file_write(_ctx: &mut opaque, n: i32) -> i32 effects { mut } {
    return n + 40;
}

fn mint_file_writer(f: &mut File) -> WriterDict effects { mut } {
    return WriterDict {
        ctx: f,
        write: file_write,
    };
}

fn dump(d: WriterDict, n: i32) -> i32 effects { mut } {
    return d.write(n);
}

fn main() -> i32 effects { mut } {
    let f: own File = File { _pad: 0 };
    let d = mint_file_writer(&mut f);
    return dump(d, 2);
}
