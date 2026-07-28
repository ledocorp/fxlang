module box;

struct Box<T> {
    value: T,
}

fn new<T>(v: T) -> Box<T> {
    return Box { value: v };
}

fn get<T>(b: Box<T>) -> T {
    return b.value;
}

fn take<T>(b: own Box<T>) -> T {
    return b.value;
}

fn set<T>(b: &mut Box<T>, v: T) {
    b.value = v;
}

fn bump<T>(b: &mut Box<T>, v: T) -> T {
    b.value = v;
    return b.value;
}

fn peek<T>(b: &Box<T>) -> T {
    return b.value;
}
