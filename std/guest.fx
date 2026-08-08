// Host-owned guest context (FX-DYN Phase B.1 + AllocCap / FuelCap Phase C).
// Session = bump arena + cap set; end revokes caps and frees arena.
// Soft-fx refused: same region / slot-mut physics inside the guest.
// B.2: `dynamic region g = guest(N);` lowers to fx_guest_begin / end (FX-DYN-8/9).
module guest;

using core;
import std/cap;

/// Opaque guest-session handle (bit-pattern of host FxGuestCtx*).
struct GuestCtx {
    handle: i64,
}

extern "c" {
    effects { alloc } fn fx_guest_begin(root: string, arena_bytes: i64) -> i64;
    effects { alloc } fn fx_guest_end(ctx_handle: i64) -> i32;
    effects { alloc } fn fx_guest_mint_fscap(ctx_handle: i64, root: string) -> i64;
    effects { alloc } fn fx_guest_mint_outcap(ctx_handle: i64, root: string) -> i64;
    effects { alloc } fn fx_guest_mint_alloccap(ctx_handle: i64, budget_bytes: i64) -> i64;
    effects { alloc } fn fx_alloccap_alloc(alloc_handle: i64, nbytes: i64) -> i64;
    effects { alloc } fn fx_guest_mint_fuelcap(ctx_handle: i64, units: i64) -> i64;
    effects { alloc } fn fx_fuelcap_burn(fuel_handle: i64, units: i64) -> i32;
    effects { alloc } fn fx_guest_alloc(ctx_handle: i64, nbytes: i64) -> i64;
    effects { alloc } fn fx_guest_is_live(ctx_handle: i64) -> i32;
}

fn from_handle(h: i64) -> GuestCtx {
    return GuestCtx { handle: h };
}

fn handle_of(g: GuestCtx) -> i64 {
    return g.handle;
}

/// Begin guest session with default mint root. arena_bytes <= 0 → host default.
/// Ok(GuestCtx) or Err(1) if mint/begin failed.
fn begin(root: string, arena_bytes: i64) -> Result<GuestCtx, core_Err> effects { alloc } {
    let h: i64 = fx_guest_begin(root, arena_bytes);
    if (h == 0) {
        return Err(1);
    }
    return Ok(GuestCtx { handle: h });
}

/// End session: revoke caps, free arena. Always Ok(0) today.
fn end(g: GuestCtx) -> Result<i32, core_Err> effects { alloc } {
    let _st: i32 = fx_guest_end(g.handle);
    return Ok(0);
}

/// Mint FsCap into the session (empty root → session default root).
fn mint_fs(g: GuestCtx, root: string) -> Result<FsCap, core_Err> effects { alloc } {
    let h: i64 = fx_guest_mint_fscap(g.handle, root);
    if (h == 0) {
        return Err(1);
    }
    return Ok(cap.fs_from_handle(h));
}

/// Mint OutCap into the session.
fn mint_out(g: GuestCtx, root: string) -> Result<OutCap, core_Err> effects { alloc } {
    let h: i64 = fx_guest_mint_outcap(g.handle, root);
    if (h == 0) {
        return Err(1);
    }
    return Ok(cap.out_from_handle(h));
}

/// Bump-alloc from the guest arena (host scratch). Err(1) if dead / OOM.
fn alloc_bytes(g: GuestCtx, nbytes: i64) -> Result<i64, core_Err> effects { alloc } {
    let p: i64 = fx_guest_alloc(g.handle, nbytes);
    if (p == 0) {
        return Err(1);
    }
    return Ok(p);
}

/// Mint AllocCap with a byte budget (revoked on end).
fn mint_alloc(g: GuestCtx, budget_bytes: i64) -> Result<AllocCap, core_Err> effects { alloc } {
    let h: i64 = fx_guest_mint_alloccap(g.handle, budget_bytes);
    if (h == 0) {
        return Err(1);
    }
    return Ok(cap.alloc_from_handle(h));
}

/// Bump-alloc through AllocCap. Err(5) = denied / over-budget / revoked / OOM.
fn alloc(a: AllocCap, nbytes: i64) -> Result<i64, core_Err> effects { alloc } {
    let p: i64 = fx_alloccap_alloc(a.handle, nbytes);
    if (p == 0) {
        return Err(5);
    }
    return Ok(p);
}

/// Mint FuelCap with a unit/step budget (revoked on end).
fn mint_fuel(g: GuestCtx, units: i64) -> Result<FuelCap, core_Err> effects { alloc } {
    let h: i64 = fx_guest_mint_fuelcap(g.handle, units);
    if (h == 0) {
        return Err(1);
    }
    return Ok(cap.fuel_from_handle(h));
}

/// Burn units through FuelCap. Err(5) = denied / over-fuel / revoked.
fn burn(f: FuelCap, units: i64) -> Result<i32, core_Err> effects { alloc } {
    let st: i32 = fx_fuelcap_burn(f.handle, units);
    if (st == 0) {
        return Err(5);
    }
    return Ok(0);
}

fn is_live(g: GuestCtx) -> i32 effects { alloc } {
    return fx_guest_is_live(g.handle);
}
