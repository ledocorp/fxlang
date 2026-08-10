// std/supervise - policy tags + apply.
module supervise;

using core;

extern "c" {
    effects { concur } fn fx_async_supervise_normalize(policy: i32) -> i32;
    effects { concur } fn fx_async_supervise_apply(n: i64, policy: i32, child_ok: i32) -> i32;
}

fn one_for_one() -> i32 { return 1; }
fn one_for_all() -> i32 { return 2; }
fn rest_for_one() -> i32 { return 3; }
fn escalate() -> i32 { return 4; }

fn normalize(policy: i32) -> Result<i32, core_Err> effects { concur } {
    let p: i32 = fx_async_supervise_normalize(policy);
    if (p < 1) {
        return Err(1);
    }
    return Ok(p);
}

fn apply(n_handle: i64, policy: i32, child_ok: i32) -> Result<i32, core_Err> effects { concur } {
    let st: i32 = fx_async_supervise_apply(n_handle, policy, child_ok);
    if (st == 4) {
        return Err(4);
    }
    if (st != 0) {
        return Err(st);
    }
    return Ok(0);
}

fn apply_status(n_handle: i64, policy: i32, child_ok: i32) -> i32 effects { concur } {
    return fx_async_supervise_apply(n_handle, policy, child_ok);
}
