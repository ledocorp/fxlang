// std/json_full - fx-native JSON validate.
// Thin WRAP path stays in std/json; dial/TLS unrelated.
module json_full;

using core;
import std/json_validate;

fn validate(src: string) -> i32 effects { alloc, mut } {
    return json_validate.validate(src);
}

fn is_valid(src: string) -> bool effects { alloc, mut } {
    return json_validate.validate(src) != 0;
}
