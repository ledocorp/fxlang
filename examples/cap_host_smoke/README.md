# Capability host smoke

Guest fx has **no `io` effect**. The C host mints read authority (allowlisted
`fixtures/…` paths), reads the file, and passes **bytes** into the guest.

```text
fx run examples/cap_host_smoke/main.fx            # exit 42 (embedded "ok")
fx run examples/cap_host_smoke/main.fx --emit-c   # same

fx build examples/cap_host_smoke/guest_lib.fx -o build/cap_host_smoke --emit-c --host examples/cap_host_smoke/host.c
# from examples/cap_host_smoke cwd:
../../build/cap_host_smoke/prog.exe fixtures/ok.txt     # exit 0
../../build/cap_host_smoke/prog.exe fixtures/nope.txt   # exit 3
../../build/cap_host_smoke/prog.exe ../secret.txt       # exit 5 denied
```

Composition: `docs/COMPOSITION.md` in the language package.  
In-language `FsCap` / `io_cap` - **** (the composition / wrap guides, `examples/cap_regions_*`). Same region physics; not a soft dialect.
