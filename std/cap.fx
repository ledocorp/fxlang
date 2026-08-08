// Opaque capability handles - minted only by host/C.
// Teaching names: FsCap / OutCap (FX-DYN-1).
// ABI: `handle` is the bit-pattern of a host `void*` / `FxFsCap*` (copyable; teardown invalidates).
// Soft-fx refused: same region/slot-mut physics; dynamic = which caps exist at runtime.
module cap;

/// Filesystem capability (copyable opaque handle).
struct FsCap {
    handle: i64,
}

/// Write-rooted filesystem capability (copyable opaque handle).
/// Host mints with an allowlisted root; `io_cap.write_file_cap` enforces it.
struct OutCap {
    handle: i64,
}

fn fs_from_handle(h: i64) -> FsCap {
    return FsCap { handle: h };
}

fn out_from_handle(h: i64) -> OutCap {
    return OutCap { handle: h };
}

fn fs_handle(c: FsCap) -> i64 {
    return c.handle;
}

fn out_handle(c: OutCap) -> i64 {
    return c.handle;
}
