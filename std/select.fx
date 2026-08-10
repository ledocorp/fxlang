// std/select - wait-any on two channels.
module select;

using core;
import std/nursery;

extern "c" {
    effects { concur } fn fx_async_select_recv2_slots(
        a: i64,
        b: i64,
        value_slot: i64,
        which_slot: i64,
        timeout_ms: i32
    ) -> i32;
}

struct Recv2 {
    value: i32,
    which: i32,
}

fn recv2(a: i64, b: i64, timeout_ms: i32) -> Result<Recv2, core_Err> effects { concur, alloc } {
    let vs = nursery.slot_new()?;
    let ws = nursery.slot_new()?;
    let st: i32 = fx_async_select_recv2_slots(a, b, nursery.slot_raw(vs), nursery.slot_raw(ws), timeout_ms);
    if (st != 0) {
        return Err(st);
    }
    return Ok(Recv2 { value: nursery.slot_get(vs), which: nursery.slot_get(ws) });
}

fn recv2_status(a: i64, b: i64, timeout_ms: i32) -> Result<i32, core_Err> effects { concur, alloc } {
    let vs = nursery.slot_new()?;
    let ws = nursery.slot_new()?;
    let st: i32 = fx_async_select_recv2_slots(a, b, nursery.slot_raw(vs), nursery.slot_raw(ws), timeout_ms);
    return Ok(st);
}

fn value_of(r: Recv2) -> i32 { return r.value; }
fn which_of(r: Recv2) -> i32 { return r.which; }
