# Trap, abort, and arena failure

**Last updated:** 10 September 2026 · Package **0.9.73+**

One page so agents and humans do not invent a second failure model.

Contract context: [GAPS.md](GAPS.md). Regions: [REGIONS.md](REGIONS.md). Quality habits: [QUALITY.md](QUALITY.md).

---

## Rules of thumb

1. **Prefer values over process death** when the API already returns `Result` / `core_Err`.
2. **Do not call libc `abort()` from fx** as a habit — if something must stop the process, use the documented trap path below (or let the host decide).
3. **Arena / region exhaust is not “maybe fine.”** Treat allocation failure as an error you must handle or a loud stop — not silent UB.

---

## What happens today

| Situation | Behavior (honest) |
|-----------|-------------------|
| Type / loan errors at compile time | Diagnostics (e.g. FX0015 / FX0019) — fix the program |
| `Result` / `?` paths | Propagate the error value; do not invent `Option` |
| Host / wrap failures | Follow the wrap’s `core_Err` / documented exit codes |
| Arena / guest region OOM | Often process-stop or host abort today — **not** a finished `Result`-everywhere story; see GAPS “may add” |
| Loan bugs that only show after emit | Prefer dual-path tests; do not assume runtime loan checks catch everything |

There is **no** dialect keyword that means “panic like Rust.” Keep failure **local and dumpable**.

---

## Documented stop

When a library or host **must** stop the process (invariant broken, corrupt state):

- Prefer a single host helper (e.g. log + exit / trap) shared by the wrap — not scattered `abort()` calls in `.fx`.
- Message should be short and findable in stderr.
- Do not wrap that stop in Soft-fx “recoverable everything.”

Later cuts may add a small `trap(msg)` surface; until then, **host-owned stop** is the honest story.

---

## What not to do

- Invent `unwrap()` that silently aborts without a message.
- Treat QBE vs gcc differences as “undefined is fine.”
- Assume arena growth can never fail because `effects { alloc }` is declared.

---

## Related

[GAPS.md](GAPS.md) · [REGIONS.md](REGIONS.md) · [QUALITY.md](QUALITY.md) · [WRAP.md](WRAP.md) · [SURFACE.md](SURFACE.md)
