# Dogfood apps

**Last updated:** 9 September 2026

fx proves itself by porting **real, small open-source-shaped programs**
(under about two thousand lines of *our* logic), with upstream tests or goldens
where possible — not by inventing greenfield toys.

**This language package ships a thin T0 teaching set** under [`examples/`](../examples/)
(showcase, tools, patterns, composition smokes). Season proofs and larger dogfood
trees are **not** mirrored here — see [examples/README.md](../examples/README.md).

Composition method (SoA, pools, host-minted I/O): [COMPOSITION.md](COMPOSITION.md).  
Agent day-one loop: [AGENT.md](AGENT.md).  
Weekend stranger path: [WEEKEND.md](WEEKEND.md).

---

## What to run from this package

```text
fx run examples/showcase_core/main.fx
fx run examples/tool_result/main.fx
fx run examples/composition_tally/main.fx
```

Full table: [examples/README.md](../examples/README.md). Expect exit **42** on success.

---

## Historical product-shaped apps (not T0)

These were developed as living proofs (CHIP‑8, JSON get, textdiff, …). They may
appear in **older release notes**; they are **not** install instructions for the
current zip. Prefer teaching examples + [COMPOSITION.md](COMPOSITION.md)
+ companion tools ([LIBRARIES.md](LIBRARIES.md)).

| Theme | What it proved |
|-------|----------------|
| Interpreter / SoA tables | Slot updates, dual native paths at scale |
| JSON CLI + C wrap | Thin host + wrap discipline |
| Pure-fx JSON path | Language-side DOM without C for semantics |
| Line diff CLI | Edit-script tool shape |

---

## Related

[COMPOSITION.md](COMPOSITION.md) · [WEEKEND.md](WEEKEND.md) · [LIBRARIES.md](LIBRARIES.md) · [QUALITY.md](QUALITY.md) · [NEXT.md](NEXT.md)
