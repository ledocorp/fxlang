// std/env - getenv. Argv remains host/cli.
module env;

using core;

extern "c" {
    fn fx_env_get(name: string) -> string;
    fn fx_env_has(name: string) -> i32;
}

fn has(name: string) -> bool {
    return fx_env_has(name) != 0;
}

fn get(name: string) -> Result<string, core_Err> {
    if (fx_env_has(name) == 0) {
        return Err(1);
    }
    return Ok(fx_env_get(name));
}

fn get_or(name: string, fallback: string) -> string {
    if (fx_env_has(name) == 0) {
        return fallback;
    }
    return fx_env_get(name);
}
