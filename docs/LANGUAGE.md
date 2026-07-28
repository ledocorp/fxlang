# The fx language

fx is a **systems language** designed so important decisions stay visible in source: allocation, mutation, and lifetimes are written down, not inferred by a garbage collector or buried in runtime magic.

## Design pillars

### 1. Explicit effects

Functions declare what they may do:

```fx
fn main() -> i32 effects { alloc, mut } {
    // may allocate and mutate
}
```

A function without `alloc` is not allowed to perform heap allocation through the normal language paths. That keeps call sites honest.

### 2. Named regions (structured lifetimes)

Heap work is usually scoped to a **region**: an arena with a clear end:

```fx
region r = arena(4096);
// allocations associated with r
// when r ends, that storage is released together
```

This is closer to “Go-style” explicit lifetimes than to a tracing GC: you see the pool, you see when it dies.

→ Deeper notes: [REGIONS.md](REGIONS.md)

### 3. Dual emission

fx can:

- **Run** a program (`fx run`): emit C, link, execute.  
- **Emit only** (`fx emit-c`): produce `.c` / `.h` for inspection or your own build.  
- **Embed**: keep C as `main` and link fx as a library (`--host`).

Emitted C is meant to be **readable** by a competent C programmer and to use the **zspec** contracts (explicit allocators, `core_Err`, …).

### 4. Small standard library of fx modules

`std/` is ordinary fx source you `import`. It is not a hidden runtime and not the C headers. Facades wrap common patterns (`vec`, `map`, `string`, …).

→ [STD.md](STD.md)

---

## Your first programs

### Minimal

```fx
fn main() -> i32 {
    return 42;
}
```

Create with: `fx new tiny --scaffold minimal`

### Recommended (visible heap)

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

Create with: `fx new hello` (default **simple** scaffold)

### Working with C

fx can own library functions while C owns `main`:

```text
fx run examples/showcase_wrap/compute.fx --host examples/showcase_wrap/host.c
```

→ [WRAP.md](WRAP.md)

---

## Types and surface (this release)

This release emphasizes:

- Integer types used in everyday code (`i32`, and wider/narrower as supported)  
- `Vec` and other collection footholds via `std/` or builtins  
- Structs, enums, and `bool` where the compiler supports them  
- Modules via `import` paths (`std/vec`, project-local modules)

The language will keep growing; this package documents **what you can use today** from this tree.

---

## Next reading

| Doc | Contents |
|-----|----------|
| [START_HERE.md](START_HERE.md) | Install and hello |
| [SCAFFOLDS.md](SCAFFOLDS.md) | Project templates |
| [CLI.md](CLI.md) | Commands and flags |
| [REGIONS.md](REGIONS.md) | Memory model |
| [STD.md](STD.md) | Standard library map |
| [WRAP.md](WRAP.md) | C host embed |
