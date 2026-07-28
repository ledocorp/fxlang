# Regions and effects

fx makes heap policy **readable in the program text**.

## Effects

```fx
fn work() -> i32 effects { alloc, mut } {
    // may allocate; may mutate
}
```

- **`alloc`**: this function may perform heap allocation.  
- **`mut`**: this function may mutate state that requires the effect.

If a function does not need the heap, omit `alloc`. That is a feature: callers can see the cost.

## Regions

A **region** is a named arena lifetime:

```fx
fn main() -> i32 effects { alloc, mut } {
    region r = arena(4096);
    // use heap within r
    return 0;
} // r ends → storage associated with the region is released
```

Think of it as a scoped pool: you choose the size, you see the scope, and you are not relying on a tracing GC to figure it out later.

### With `std/vec`

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

### Manual mode

The **minimal** scaffold has no region. Add one when you need heap:

```fx
fn main() -> i32 {
    return 42;
}
```

---

## Why this shape?

- **Local reasoning**: open a function and see what it is allowed to do.  
- **Batch free**: regions free as a unit when they end.  
- **C-friendly**: the same honesty shows up in emitted C via zspec allocators and errors.

More language context: [LANGUAGE.md](LANGUAGE.md)
