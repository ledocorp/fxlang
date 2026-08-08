# Capability regions — extension smoke (FX-DYN-1)

Guest **extension** code takes `FsCap` / `OutCap` and calls `io_cap.read_file_cap` /
`io_cap.write_file_cap`. Paths outside the minted root return **`Err(5)`** / process exit **5**.

On a successful read+score, the guest writes `fixtures/_cap_status.txt` and reads it back.

```text
fx run examples/cap_regions_ext/main.fx            # exit 42
fx run examples/cap_regions_ext/main.fx --emit-c   # exit 42

fx build examples/cap_regions_ext/guest_lib.fx -o build/cap_regions_ext --emit-c `
  --host examples/cap_regions_ext/host.c `
  --link examples/cap_runtime/fx_cap_runtime.c `
  --link-include examples/cap_runtime
# from examples/cap_regions_ext:
../../build/cap_regions_ext/prog.exe fixtures/ok.txt     # exit 0 (+ status write)
../../build/cap_regions_ext/prog.exe fixtures/nope.txt   # exit 3
../../build/cap_regions_ext/prog.exe ../secret.txt       # exit 5 denied (read)
../../build/cap_regions_ext/prog.exe --write-deny        # exit 5 denied (write)
```

Parallel to ambient `std/io` — see `docs/specs/CAPABILITY_REGIONS_LITE.md`.
