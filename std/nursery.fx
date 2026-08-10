// std/nursery - host nursery facade. Handles are i64 (pointer bits).
module nursery;

using core;

extern "c" {
    effects { concur, alloc } fn fx_async_nursery_create() -> i64;
    effects { concur, alloc } fn fx_async_nursery_create_sized(max_tasks: i32) -> i64;
    effects { concur } fn fx_async_nursery_spawn_add(n: i64, slot: i64, value: i32) -> i32;
    effects { concur } fn fx_async_nursery_spawn_send(n: i64, chan: i64, value: i32) -> i32;
    effects { concur } fn fx_async_nursery_spawn_mb_send(n: i64, mb: i64, value: i32) -> i32;
    effects { concur } fn fx_async_nursery_join_all(n: i64) -> i32;
    effects { concur } fn fx_async_nursery_join_all_timeout(n: i64, timeout_ms: i32) -> i32;
    effects { concur } fn fx_async_nursery_request_cancel(n: i64) -> i32;
    effects { concur } fn fx_async_nursery_shutdown(n: i64) -> i32;
    effects { concur } fn fx_async_nursery_destroy(n: i64) -> i32;
    effects { concur } fn fx_async_nursery_pending(n: i64) -> i32;
    effects { concur } fn fx_async_slot_get(slot: i64) -> i32;
    effects { concur } fn fx_async_slot_get_i64(slot: i64) -> i64;
    effects { concur, alloc } fn fx_async_slot_new() -> i64;
}

struct Handle {
    handle: i64,
}

struct Slot {
    handle: i64,
}

fn create() -> Result<Handle, core_Err> effects { concur, alloc } {
    let h: i64 = fx_async_nursery_create();
    if (h == 0) {
        return Err(1);
    }
    return Ok(Handle { handle: h });
}

fn create_sized(max_tasks: i32) -> Result<Handle, core_Err> effects { concur, alloc } {
    let h: i64 = fx_async_nursery_create_sized(max_tasks);
    if (h == 0) {
        return Err(1);
    }
    return Ok(Handle { handle: h });
}

fn slot_new() -> Result<Slot, core_Err> effects { concur, alloc } {
    let h: i64 = fx_async_slot_new();
    if (h == 0) {
        return Err(1);
    }
    return Ok(Slot { handle: h });
}

///  foothold - spawn i32 into a fresh slot (keyword sugar targets this).
fn spawn_i32(n: Handle, value: i32) -> Result<Slot, core_Err> effects { concur, alloc } {
    let s = slot_new()?;
    let _st = spawn_store(n, s, value)?;
    return Ok(s);
}

/// After join_all, read spawned i32 (await keyword targets this).
fn await_i32(s: Slot) -> i32 effects { concur } {
    return slot_get(s);
}

fn spawn_store(n: Handle, slot: Slot, value: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_spawn_add(n.handle, slot.handle, value);
    if (st == 2) {
        return Err(2);
    }
    if (st == 3) {
        return Err(3);
    }
    if (st != 0) {
        return Err(1);
    }
    return Ok(0);
}

fn spawn_send(n: Handle, chan_handle: i64, value: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_spawn_send(n.handle, chan_handle, value);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn spawn_mb_send(n: Handle, mb_handle: i64, value: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_spawn_mb_send(n.handle, mb_handle, value);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn join_all(n: Handle) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_join_all(n.handle);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn join_timeout(n: Handle, timeout_ms: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_join_all_timeout(n.handle, timeout_ms);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn request_cancel(n: Handle) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_request_cancel(n.handle);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn shutdown(n: Handle) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_nursery_shutdown(n.handle);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn pending(n: Handle) -> i32 effects { concur } {
    return fx_async_nursery_pending(n.handle);
}

fn destroy(n: Handle) -> Result<i32, core_Err> effects { concur } {
    let _st: i32 = fx_async_nursery_destroy(n.handle);
    return Ok(0);
}

fn slot_get(slot: Slot) -> i32 effects { concur } {
    return fx_async_slot_get(slot.handle);
}

fn slot_get_i64(slot: Slot) -> i64 effects { concur } {
    return fx_async_slot_get_i64(slot.handle);
}

fn slot_raw(slot: Slot) -> i64 {
    return slot.handle;
}

fn raw(n: Handle) -> i64 {
    return n.handle;
}
