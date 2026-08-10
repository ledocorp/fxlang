// Opaque capability handles - minted only by host/C.
// Teaching names: FsCap / OutCap · AllocCap.
// ABI: `handle` is the bit-pattern of a host `void*` / `Fx*Cap*` (copyable; teardown invalidates).
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

/// Budgeted guest arena allocation capability (copyable opaque handle).
/// Host mints with a byte budget; alloc through guest.alloc; teardown invalidates.
struct AllocCap {
    handle: i64,
}

/// Unit/step budget capability (copyable opaque handle).
/// Host mints with a unit count; burn through guest.burn; teardown invalidates.
struct FuelCap {
    handle: i64,
}

/// Network capability (copyable opaque handle).
/// Host mints host+port range; `guest.net_allows` / `guest.net_dial` (TCP; no TLS).
struct NetCap {
    handle: i64,
}

fn fs_from_handle(h: i64) -> FsCap {
    return FsCap { handle: h };
}

fn out_from_handle(h: i64) -> OutCap {
    return OutCap { handle: h };
}

fn alloc_from_handle(h: i64) -> AllocCap {
    return AllocCap { handle: h };
}

fn fuel_from_handle(h: i64) -> FuelCap {
    return FuelCap { handle: h };
}

fn net_from_handle(h: i64) -> NetCap {
    return NetCap { handle: h };
}

fn fs_handle(c: FsCap) -> i64 {
    return c.handle;
}

fn out_handle(c: OutCap) -> i64 {
    return c.handle;
}

fn alloc_handle(c: AllocCap) -> i64 {
    return c.handle;
}

fn fuel_handle(c: FuelCap) -> i64 {
    return c.handle;
}

fn net_handle(c: NetCap) -> i64 {
    return c.handle;
}
