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
| `dynamic region g = guest(n);` | Guest session handle (`i64`); function exit → `fx_guest_end` |

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

### Lexical loan checking (landed)

fx checks loans **lexically** on the forms above — no lifetime parameters and no NLL engine.

| Rule | Meaning |
|------|---------|
| Shared XOR mut | While any `&mut` of place `p` is live, no other loan of `p`. While any `&` of `p` is live, no `&mut` of `p`. Multiple shared `&` are OK. |
| Region epoch | A loan must not outlive its owner region / block → **FX0015** (BorrowEscape) |
| Conflict | Overlapping exclusive/shared loans → **FX0019** (BorrowConflict) |
| Hylo call-end | Inline `&mut` arguments end at the statement / call return; the owner is usable again afterward unless a named `let p = &mut x` still holds the loan |

```fx
fn bump(a: &mut Acc, v: i32) -> i32 {
    a.total = a.total + v;
    return a.total;
}

fn use_after_call(n: i32) -> i32 {
    let mut x: i32 = n;
    bump(&mut x, 1);   // exclusive loan ends here
    return x;
}
```

Graphs and tables stay **typed `Id` + SoA** — do not weaken loan rules to allow arbitrary C-style pointer meshes. See [COMPOSITION.md](COMPOSITION.md) · [SURFACE.md](SURFACE.md).

### Guest session (`dynamic region`)

```fx
import std/guest;
import std/cap;

fn host() -> Result<i32, core_Err> effects { alloc } {
    dynamic region g = guest(4096);
    let ctx = guest.from_handle(g);
    let fs = guest.mint_fs(ctx, "")?;
    // … guest work with FsCap …
    return Ok(0);
} // g ends: caps revoked, arena freed
```

Or call `guest.begin` / `guest.end` explicitly (no sugar). Build session paths with
`--emit-c --link host/cap/fx_cap_runtime.c --link-include host/cap`.
Score-only guest algorithms still run under IR. See [COMPOSITION.md](COMPOSITION.md).

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
- **Regions ≠ tasks**: “structured” here means lifetimes and batch free — not concurrency.
  Task nursery / channels live under `std/nursery`, `std/chan`, … (see [STD.md](STD.md)).

More: [LANGUAGE.md](LANGUAGE.md) · [REFERENCE.md](REFERENCE.md) · [STD.md](STD.md)
