// user-facing math helpers
module math;

fn add(a: i32, b: i32) -> i32 {
    return a + b;
}

fn sub(a: i32, b: i32) -> i32 {
    return a - b;
}

fn neg(n: i32) -> i32 {
    return -n;
}

fn abs(n: i32) -> i32 {
    if (n < 0) {
        return -n;
    }
    return n;
}

fn min(a: i32, b: i32) -> i32 {
    if (a < b) {
        return a;
    }
    return b;
}

fn max(a: i32, b: i32) -> i32 {
    if (a > b) {
        return a;
    }
    return b;
}

fn clamp(x: i32, lo: i32, hi: i32) -> i32 {
    if (x < lo) {
        return lo;
    }
    if (x > hi) {
        return hi;
    }
    return x;
}

fn is_even(n: i32) -> bool {
    return n % 2 == 0;
}

fn abs64(n: i64) -> i64 {
    if (n < 0) {
        return -n;
    }
    return n;
}

fn min64(a: i64, b: i64) -> i64 {
    if (a < b) {
        return a;
    }
    return b;
}

fn max64(a: i64, b: i64) -> i64 {
    if (a > b) {
        return a;
    }
    return b;
}

fn clamp64(x: i64, lo: i64, hi: i64) -> i64 {
    if (x < lo) {
        return lo;
    }
    if (x > hi) {
        return hi;
    }
    return x;
}
