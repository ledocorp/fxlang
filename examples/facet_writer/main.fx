// examples/facet_writer - static facet contract (Season F).
// Run: fx run examples/facet_writer/main.fx
// Expect exit 42. Live: --driver sh.
facet Writer {
    fn write(self: &mut Self, n: i32) -> i32
        effects { mut };
}

struct File {
    _pad: i32,
}

attach Writer for File {
    fn write(self: &mut File, n: i32) -> i32
        effects { mut }
    {
        return n + 40;
    }
}

fn dump<T>(w: &mut T, n: i32) -> i32
    where T: Writer
    effects { mut }
{
    return w.write(n);
}

fn main() -> i32 effects { mut } {
    let f: own File = File { _pad: 0 };
    return dump(&mut f, 2);
}
