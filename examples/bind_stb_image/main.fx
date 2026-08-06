// FX-0.8-STD-2 — stb_image bind smoke (exit 42).
using core;
import stbi_safe;

fn main() -> Result<i32, core_Err> {
    return stbi_safe.decode1();
}
