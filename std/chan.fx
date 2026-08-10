// std/chan - i32 + i64 channel facade. Handles are i64.
module chan;

using core;
import std/nursery;

extern "c" {
    effects { concur, alloc } fn fx_async_chan_create(capacity: i32) -> i64;
    effects { concur } fn fx_async_chan_destroy(h: i64) -> i32;
    effects { concur } fn fx_async_chan_send(h: i64, v: i32) -> i32;
    effects { concur } fn fx_async_chan_send_i64(h: i64, v: i64) -> i32;
    effects { concur } fn fx_async_chan_recv_slot(h: i64, slot: i64) -> i32;
    effects { concur } fn fx_async_chan_recv_i64_slot(h: i64, slot: i64) -> i32;
    effects { concur } fn fx_async_chan_close(h: i64) -> i32;
}

struct Chan {
    handle: i64,
}

fn create(capacity: i32) -> Result<Chan, core_Err> effects { concur, alloc } {
    let h: i64 = fx_async_chan_create(capacity);
    if (h == 0) {
        return Err(1);
    }
    return Ok(Chan { handle: h });
}

fn send(c: Chan, v: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_chan_send(c.handle, v);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn send_status(c: Chan, v: i32) -> i32 effects { concur } {
    return fx_async_chan_send(c.handle, v);
}

fn send_i64(c: Chan, v: i64) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_chan_send_i64(c.handle, v);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn recv(c: Chan) -> Result<i32, core_Err> effects { concur, alloc } {
    let slot = nursery.slot_new()?;
    let st: i32 = fx_async_chan_recv_slot(c.handle, nursery.slot_raw(slot));
    if (st != 0) {
        return Err(st);
    }
    return Ok(nursery.slot_get(slot));
}

fn recv_i64(c: Chan) -> Result<i64, core_Err> effects { concur, alloc } {
    let slot = nursery.slot_new()?;
    let st: i32 = fx_async_chan_recv_i64_slot(c.handle, nursery.slot_raw(slot));
    if (st != 0) {
        return Err(st);
    }
    return Ok(nursery.slot_get_i64(slot));
}

fn close(c: Chan) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_chan_close(c.handle);
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn destroy(c: Chan) -> Result<i32, core_Err> effects { concur } {
    let _st: i32 = fx_async_chan_destroy(c.handle);
    return Ok(0);
}

fn raw(c: Chan) -> i64 {
    return c.handle;
}
