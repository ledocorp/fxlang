# Regions and effects

Heap policy, mutation, and I/O stay readable in the program text.
This is structured lifetimes, not a garbage collector, and not async/tasks.

Canonical web copy: https://www.ledocorp.org/fx/docs/regions/

## Effects

```fx
fn work() -> i32 effects { alloc, mut, io } {
    // may allocate, mutate, and perform I/O
}
```

| Effect | Meaning |
|--------|---------|
| `alloc` | May allocate through heap / arena paths |
| `mut` | May mutate (including exclusive borrows / heap state) |
| `io` | May perform host I/O (stdout, files, …) |

Omit effects you do not need. Absence of `alloc` is a feature callers can rely on.

## Region kinds

| Syntax | Role |
|--------|------|
| `region r = arena(n);` | Everyday heap arena (default scaffold) |
| `region r = temp(n);` | Short-lived heap batch for a tighter scope |
| `region r = scope;` | Stack borrow region · no heap allocation |
| `region r = fx(n);` | Hierarchical fx region (advanced nesting) |

### Everyday arena

```fx
fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    // heap work associated with r
    return 0;
} // r ends: storage released together
```

### With std/vec

```fx
import std/vec;

fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    let v: Vec<i32> = vec.new(0);
    let v2: Vec<i32> = vec.push(v, 40);
    let v3: Vec<i32> = vec.push(v2, 2);
    return vec.get(v3, 0) + vec.get(v3, 1);
}
```

This is the default **simple** scaffold from `fx new`.

### Scope borrows (no heap)

```fx
fn main() -> i32 {
    let x: i32 = 42;
    region r = scope;
    let p: &region r i32 = &region r x;
    return *p;
}
```

## Ownership and borrows

| Form | Meaning |
|------|---------|
| `own T` | Owning value (move semantics) |
| `&T` | Shared / read borrow |
| `&mut T` | Exclusive mutable borrow |
| `&region r T` | Borrow tied to region `r` |

Inline `&mut` arguments are released at the statement boundary, which makes recursive “thread a cursor / parser state” patterns practical. Two live exclusive borrows of one owner are rejected.

```fx
fn bump(a: &mut Acc, v: i32) -> i32 {
    a.total = a.total + v;
    return a.total;
}
```

## Effects paired with std

- Growing `vec` / `map` / `strbuf` typically needs `alloc` (and often `mut`) plus an active region.
- `std/io` file and line helpers declare `io` (and `alloc` when reading into strings).
- Pure numeric helpers (many `std/math` functions) need no effects clause.

## Manual mode

The **minimal** scaffold has no region. Add one when you need heap:

```fx
fn main() -> i32 {
    return 42;
}
```

## Why this shape?

- **Local reasoning**: open a function and see what it may do
- **Batch free**: regions free as a unit when they end
- **C-friendly**: honesty shows up in emitted C via zspec allocators and errors
- **Not async**: “structured” here means lifetimes, not spawn/join

More: [LANGUAGE.md](LANGUAGE.md) · [REFERENCE.md](REFERENCE.md) · [STD.md](STD.md)
