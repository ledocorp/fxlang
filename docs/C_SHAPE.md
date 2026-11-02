# C shape guide — what fx emits

**Last updated:** 2 November 2026 · Package **0.9.75**

fx promises **readable C** a competent C programmer can maintain. This page
predicts the shape — not every line of every program.

Full tracking tools: [TRACKING.md](TRACKING.md). Speed policy: [DRIVERS.md](DRIVERS.md).

---

## Mental model

```text
fx source
  → typed program (effects + regions visible)
  → either:
       emit-C  →  .c / .h you can read  →  gcc/clang
       IR/QBE  →  native (when QBE is packaged)
```

**Rule:** IR and emit-C must agree on **exit code** for claimed dual-path programs.
Prefer `--emit-c` for hot loops, host-heavy structs, and anything you will audit.

---

## Regions → allocators

| fx | Typical C shape |
|----|-----------------|
| `region r = arena(N)` | Arena / bump allocator tied to `r`; frees when the region ends |
| Nested `region` | Nested arena; inner ends first |
| `temp` / scratch habits | Short-lived buffers; do not escape the scope |

There is **no** hidden GC. Absence of `alloc` in a signature means the function
does not allocate (product habit — see [REGIONS.md](REGIONS.md)).

---

## Effects → visible costs

| Effect (examples) | Meaning in C terms |
|-------------------|--------------------|
| `alloc` | May allocate through a region / allocator |
| `mut` | May write through `&mut` / slot writes |
| `io` / `fs` / `net` / … | May perform that class of side effect |
| `concur` | May spawn / join structured tasks |

Call sites see the cost in the type. Agents should not invent silent I/O.

---

## Ownership → pointers and moves

| fx | C intuition |
|----|-------------|
| `own T` / moves | Exclusive value; do not use after move |
| `&T` | Shared borrow; no mutation through it |
| `&mut T` | Exclusive borrow for the loan span |
| Lexical loans | End at call / arm / `using` — **not** full NLL |

Emitted C keeps borrows as ordinary pointers with **fx-enforced** rules at
compile time. Do not reintroduce Soft-fx / Cell-style sharing in the C layer.

---

## Result → tagged unions

`Result<T, E>` and `?` lower to an explicit ok/err tag (or equivalent) in C —
not exceptions. Failure is data. Policy: [TRAP.md](TRAP.md).

---

## Collections → structs + helpers

| fx | C intuition |
|----|-------------|
| `Vec<T>` | `{ data, len, cap }` (+ region) with `push` / index helpers |
| no-grow `v[i]=x` | Slot write; **no** hidden realloc |
| Grow | `push` / reassign — visible |
| `Map` footholds | Explicit insert/get helpers; not a kitchen-sink hashmap API |

Prefer **SoA + typed ids** for graphs ([COMPOSITION.md](COMPOSITION.md)).

---

## Facets / where → monomorphized helpers

Closed facets (`Eq`, `Hash`, `Plain`, `Copy`) become concrete specialized
functions in emit-C — not open trait vtables. Keep attach sets small.

---

## How to inspect

```text
fx emit-c main.fx -o out_c
# read out_c/*.c — look for /* fx: … */ traces

fx emit-c main.fx -o out_dbg --debug-source
fx locate --c-file out_dbg/main.c --line 40
```

---

## Related

[DRIVERS.md](DRIVERS.md) · [TRACKING.md](TRACKING.md) · [REGIONS.md](REGIONS.md) · [LANGUAGE.md](LANGUAGE.md) · [QUALITY.md](QUALITY.md)
