# zspec (C substrate)

**zspec** is the small C library fx links against for everyday programs: allocators, `core_Err`, strings, regions, and related headers.

| Path | Role |
|------|------|
| [`include/zspec/`](include/zspec/) | Public C headers |
| [`../build/gcc/libzspec.a`](../build/gcc/libzspec.a) | Prebuilt library (Windows) |
| [`../build/gcc-linux/libzspec.a`](../build/gcc-linux/libzspec.a) | Prebuilt library (Linux) |

`fx run` / `fx build` use these automatically when linking with zspec enabled (the default).
