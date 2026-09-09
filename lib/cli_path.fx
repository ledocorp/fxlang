// lib/cli_path.fx - shared path helpers for FsCap-style CLIs.
// Path-imported as `import lib/cli_path`. Not a product brand.
module cli_path;

using core;
import std/string;
import std/strutil;

fn eq(a: string, b: string) -> bool {
    return string.compare(a, b);
}

fn path_has_dotdot(s: string) -> bool {
    return strutil.contains(s, "..");
}

/// Join allow root + relative path, or keep abs path when already under allow.
fn resolve_under(allow: string, rel: string) -> Result<string, core_Err> effects { alloc } {
    let al = string.len(allow);
    let dl = string.len(rel);
    if (dl > al) {
        if (strutil.starts_with(rel, allow) == true) {
            let c = string.byte_at(rel, al);
            if (c == 47) {
                return Ok(rel);
            }
            if (c == 92) {
                return Ok(rel);
            }
        }
    }
    let mid = string.concat(allow, "/")?;
    return string.concat(mid, rel);
}
