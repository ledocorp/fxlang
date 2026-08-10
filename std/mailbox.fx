// std/mailbox - Erlang-shaped i32 mailbox facade.
module mailbox;

using core;
import std/nursery;

extern "c" {
    effects { concur, alloc } fn fx_async_mb_create(capacity: i32) -> i64;
    effects { concur } fn fx_async_mb_destroy(h: i64) -> i32;
    effects { concur } fn fx_async_mb_send(h: i64, v: i32) -> i32;
    effects { concur } fn fx_async_mb_recv_slot(h: i64, slot: i64) -> i32;
    effects { concur } fn fx_async_mb_close(h: i64) -> i32;
}

struct Mailbox {
    handle: i64,
}

fn create(capacity: i32) -> Result<Mailbox, core_Err> effects { concur, alloc } {
    let h: i64 = fx_async_mb_create(capacity);
    if (h == 0) {
        return Err(1);
    }
    return Ok(Mailbox { handle: h });
}

fn send(m: Mailbox, v: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_mb_send(m.handle, v);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn recv(m: Mailbox) -> Result<i32, core_Err> effects { concur, alloc } {
    let slot = nursery.slot_new()?;
    let st: i32 = fx_async_mb_recv_slot(m.handle, nursery.slot_raw(slot));
    if (st != 0) {
        return Err(st);
    }
    return Ok(nursery.slot_get(slot));
}

fn close(m: Mailbox) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_mb_close(m.handle);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn destroy(m: Mailbox) -> Result<i32, core_Err> effects { concur } {
    let _st: i32 = fx_async_mb_destroy(m.handle);
    return Ok(0);
}

fn raw(m: Mailbox) -> i64 {
    return m.handle;
}
