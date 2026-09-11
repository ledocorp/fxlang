# Third-party software

The **fx language package** ([ledocorp/fxlang](https://github.com/ledocorp/fxlang)) is licensed under the **GNU General Public License, Version 3** — see [LICENSE](../LICENSE) and [NOTICE](../NOTICE).

This file lists **other open-source components distributed in this package**.
If we ship additional third-party code later, it will be named here with its license file path.

| Component | Role in this package | License | Where |
|-----------|----------------------|---------|--------|
| **QBE** | IR → native backend (`fx run` IR path) | MIT | [`third_party/qbe/LICENSE`](../third_party/qbe/LICENSE) · Linux `third_party/qbe/obj/qbe` · Windows `third_party/qbe/windows/qbe.exe` when staged |
| **zspec** | C substrate headers + `libzspec.a` | GPL-3.0 (same as fx) | `zspec/`, `build/gcc*/` |

## Not in this package

Examples that wrap external C libraries (cJSON, xxHash, stb, raylib, …) may appear as optional demos outside this package. Those libraries are **not** redistributed in the language package unless listed in the table above. When an example links against a system- or vendor-installed library, that library’s own license applies to that dependency — it is not part of this GPL-3.0 tree.

## Summary for redistributors

1. Keep [LICENSE](../LICENSE) and [NOTICE](../NOTICE).
2. Keep [`third_party/qbe/LICENSE`](../third_party/qbe/LICENSE) whenever you ship the QBE binary.
3. Do not remove copyright or license notices from source headers.
4. Combined works that include this package must comply with GPL-3.0.

## Linking emitted C into other programs (steward opinion)

**Not legal advice.** Short product posture so embedding questions have an answer:

| Situation | Opinion |
|-----------|---------|
| You ship **`bin/fx`**, `std/`, zspec, or other package sources with your product | Treat the combined work under **GPL-3.0** (keep LICENSE/NOTICE; offer corresponding source as GPL requires). |
| You run `fx emit-c` / `--emit-c` and **link that generated C with GPL-covered package code** (typical `fx build`) | Same: the linked program is a **combined work** under GPL-3.0. |
| You want emit-C output alone inside a **permissive (e.g. MIT) server** without GPL obligations on that server | **Not offered today.** There is **no** std exception / linking exception for generated C in this package. Either keep the larger work GPL-compatible, keep the wrap as a separate GPL process, or wait for a future dual-license / exception cut (not promised). |
| QBE (MIT) alone | Remains MIT; redistributing the QBE binary still needs its LICENSE file. |

Xorg/XLibre-style “MIT host embeds generated C from this GPL tree” is therefore **blocked by license posture**, not by missing `Map<K,V>`. See also [GAPS.md](GAPS.md).

Questions: see [SECURITY.md](../SECURITY.md) / project site http://www.ledocorp.org
