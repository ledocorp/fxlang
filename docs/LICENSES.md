# Third-party software

The **fx language package** ([ledocorp/fxlang](https://github.com/ledocorp/fxlang)) is licensed under the **Apache License 2.0** — see [LICENSE](../LICENSE) and [NOTICE](../NOTICE).

This file lists **other open-source components distributed in this package**.
If we ship additional third-party code later, it will be named here with its license file path.

| Component | Role in this package | License | Where |
|-----------|----------------------|---------|--------|
| **QBE** | IR → native backend (`fx run` default path) | MIT | [`third_party/qbe/LICENSE`](../third_party/qbe/LICENSE) · binary `third_party/qbe/obj/qbe` |
| **zspec** | C substrate headers + `libzspec.a` | Apache-2.0 (same as fx) | `zspec/`, `build/gcc*/` |

## Not in this package

Examples that wrap external C libraries (cJSON, xxHash, stb, raylib, …) may appear as optional demos outside this package. Those libraries are **not** redistributed in the language package unless listed in the table above. When an example links against a system- or vendor-installed library, that library’s own license applies to that dependency — it is not part of this Apache-2.0 tree.

## Summary for redistributors

1. Keep [LICENSE](../LICENSE) and [NOTICE](../NOTICE).  
2. Keep [`third_party/qbe/LICENSE`](../third_party/qbe/LICENSE) whenever you ship the QBE binary.  
3. Do not remove copyright or license notices from source headers.

Questions: see [SECURITY.md](../SECURITY.md) / project site http://www.ledocorp.org
