// Dual-path smoke of guest logic (no host argv).
import guest_lib;

fn main() -> i32 {
    return guest_lib.score("ok");
}
