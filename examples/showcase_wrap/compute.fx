// fx library for a thin C host: host owns main; fx owns score / clamp01.

fn score(x: i32, y: i32) -> i32 {
    return (x * 2) + y;
}

fn clamp01(n: i32) -> i32 {
    if (n < 0) {
        return 0;
    }
    if (n > 100) {
        return 100;
    }
    return n;
}
