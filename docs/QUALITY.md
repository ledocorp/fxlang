# Quality habits (public)

**Last updated:** 6 August 2026

fx aims for tools you can audit: dual native paths (IR and readable C), explicit
effects/regions, and dogfood CLIs with clear exit codes on stderr.

## What we emphasize

| Habit | Meaning |
|-------|---------|
| Dual paths | Prefer programs that stay green on both `fx run` and `fx run --emit-c` |
| Honest exits | Tool CLIs document process codes (usage / IO / parse / …) separately from language errors |
| Thin C hosts | Product argv CLIs may use a small C `main`; fx owns the logic — see [WRAP.md](WRAP.md) |
| Language package | What you clone is the installable tree (binary, `std/`, docs, examples) |

## What this is not

- A certification claim (DO-178 or otherwise)  
- A promise that every OOM path is already surfaced as `Result` Err in every lowering  
- A package registry or Soft-fx sandbox story  

Dogfood evidence: [DOGFOOD.md](DOGFOOD.md). What’s next: [NEXT.md](NEXT.md).
