// std/http - llhttp parse-only facade. No dial/TLS.
module http;

using core;

extern "c" {
    fn fx_llhttp_sample_req42() -> string;
    fn fx_llhttp_req_content_length(req: string) -> i32;
    fn fx_llhttp_req_ok(req: string) -> i32;
}

fn sample_req42() -> string {
    return fx_llhttp_sample_req42();
}

fn req_content_length(req: string) -> Result<i32, core_Err> {
    let n = fx_llhttp_req_content_length(req);
    if (n < 0) {
        return Err(1);
    }
    return Ok(n);
}

fn req_ok(req: string) -> Result<i32, core_Err> {
    let n = fx_llhttp_req_ok(req);
    if (n != 1) {
        return Err(2);
    }
    return Ok(1);
}
