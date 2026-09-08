# Windows QBE

Native QBE binary for IR → PE on Windows (`amd64_win`).

## Build (monorepo)

With MinGW `gcc` on `PATH`:

```powershell
.\scripts\build-qbe-windows.ps1
```

That writes `third_party/qbe/windows/qbe.exe`. Override with `FX_QBE` if needed.

## Package stage

`stage-public-fx.ps1` copies `qbe.exe` into the public tree when this file exists. If it is missing at stage time, Windows falls back to emit-C (or you build QBE first, then re-stage).

## Notes

- Options before input: `qbe -o out.s in.ssa`
- Native link uses `-t amd64_win`
- Linux `third_party/qbe/obj/qbe` stays the IR oracle for CI/goldens
- Emit-C remains available when QBE is absent
