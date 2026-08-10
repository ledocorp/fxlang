// Dual-path smoke: score only (no host / AllocCap externs).
import score_lib;

fn main() -> i32 {
    return score_lib.score("ok");
}
