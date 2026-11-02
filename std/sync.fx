// std/sync - Mutex slot handle (i32) over host substrate.
// Prefer channels/mailboxes for shared work; mutex is the last sync primitive.
module sync;

using core;

extern "c" {
    fn fx_mutex_create() -> i32;
    fn fx_mutex_lock(handle: i32) -> i32;
    fn fx_mutex_unlock(handle: i32) -> i32;
    fn fx_mutex_destroy(handle: i32) -> i32;
}

fn mutex_create() -> Result<i32, core_Err> {
    let h = fx_mutex_create();
    if (h == 0) {
        return Err(1);
    }
    return Ok(h);
}

fn lock(handle: i32) -> Result<i32, core_Err> {
    if (fx_mutex_lock(handle) != 0) {
        return Err(1);
    }
    return Ok(0);
}

fn unlock(handle: i32) -> Result<i32, core_Err> {
    if (fx_mutex_unlock(handle) != 0) {
        return Err(1);
    }
    return Ok(0);
}

fn destroy(handle: i32) -> Result<i32, core_Err> {
    if (fx_mutex_destroy(handle) != 0) {
        return Err(1);
    }
    return Ok(0);
}
