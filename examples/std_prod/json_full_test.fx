// FX-PROD-STD-JSON-FULL — fx-native validate via std/json_full.
using core;
import std/testing;
import std/json_full;

fn test_accept() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(65536);
    if (json_full.validate("null") != 1) {
        return Err(1);
    }
    if (json_full.validate("{\"a\": [1, true]}") != 1) {
        return Err(2);
    }
    return Ok(0);
}

fn test_reject() -> Result<i32, core_Err> effects { alloc, mut, io } {
    region r = arena(65536);
    if (json_full.validate("") != 0) {
        return Err(3);
    }
    if (json_full.validate("[1,]") != 0) {
        return Err(4);
    }
    return Ok(0);
}

fn main() -> Result<i32, core_Err> effects { alloc, mut, io } {
    let _a = test_accept()?;
    let _b = test_reject()?;
    return Ok(0);
}
