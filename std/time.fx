// std/time - wall clock, sleep, seeded LCG.
module time;

using core;

extern "c" {
    fn fx_time_now_ms() -> i64;
    fn fx_time_sleep_ms(ms: i32);
    fn fx_rand_next(state: i32) -> i32;
}

fn now_ms() -> i64 {
    return fx_time_now_ms();
}

fn sleep_ms(ms: i32) {
    fx_time_sleep_ms(ms);
}

fn rand_next(state: i32) -> i32 {
    return fx_rand_next(state);
}
