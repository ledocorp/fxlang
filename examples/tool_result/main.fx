// unbridged Result/`?` proof (general emit). Exit 42.
using core;

fn answer() -> Result<i32, core_Err> {
    return Ok(21);
}

fn main() -> Result<i32, core_Err> {
    let a = answer()?;
    return Ok(a + a);
}
