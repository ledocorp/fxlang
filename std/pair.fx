// user-facing Pair<A, B> facade
module pair;

struct Pair<A, B> {
    first: A,
    second: B,
}

fn new<A, B>(a: A, b: B) -> Pair<A, B> {
    return Pair { first: a, second: b };
}

fn first<A, B>(p: Pair<A, B>) -> A {
    return p.first;
}

fn second<A, B>(p: Pair<A, B>) -> B {
    return p.second;
}
