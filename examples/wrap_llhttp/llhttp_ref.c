/* Thin C facade over llhttp (parse-only; no dial/sockets). */
#include "llhttp.h"

#include <stdint.h>
#include <string.h>

#define FX_LLHTTP_ERR (-1)

/* Fixture for fx dual-path (fx string literals may not preserve CR). */
static const char kSampleReq42[] =
    "GET /x HTTP/1.1\r\nHost: example.com\r\nContent-Length: 42\r\n\r\n";

const char *fx_llhttp_sample_req42(void) {
    return kSampleReq42;
}

typedef struct {
    int32_t content_length;
    int saw_complete;
} FxLlhttpCapture;

static int on_headers_complete(llhttp_t *parser) {
    FxLlhttpCapture *cap = (FxLlhttpCapture *)parser->data;
    if (cap != NULL) {
        /* llhttp fills content_length when Content-Length is present. */
        if (parser->content_length > 0x7fffffffULL) {
            cap->content_length = FX_LLHTTP_ERR;
        } else {
            cap->content_length = (int32_t)parser->content_length;
        }
        cap->saw_complete = 1;
    }
    return 0;
}

/*
 * Parse an HTTP/1.x request buffer; return Content-Length as i32.
 * Missing/invalid → negative. Empty Content-Length (0) returns 0.
 */
int32_t fx_llhttp_req_content_length(const char *req) {
    llhttp_t parser;
    llhttp_settings_t settings;
    FxLlhttpCapture cap;
    size_t n;
    enum llhttp_errno err;

    if (req == NULL) {
        return FX_LLHTTP_ERR;
    }
    n = strlen(req);
    if (n == 0) {
        return FX_LLHTTP_ERR;
    }

    cap.content_length = FX_LLHTTP_ERR;
    cap.saw_complete = 0;

    llhttp_settings_init(&settings);
    settings.on_headers_complete = on_headers_complete;

    llhttp_init(&parser, HTTP_REQUEST, &settings);
    parser.data = &cap;

    err = llhttp_execute(&parser, req, n);
    if (err != HPE_OK) {
        return FX_LLHTTP_ERR;
    }
    if (!cap.saw_complete) {
        return FX_LLHTTP_ERR;
    }
    return cap.content_length;
}

/* 1 if buffer parses as a complete HTTP request; 0 otherwise. */
int32_t fx_llhttp_req_ok(const char *req) {
    llhttp_t parser;
    llhttp_settings_t settings;
    FxLlhttpCapture cap;
    size_t n;
    enum llhttp_errno err;

    if (req == NULL) {
        return 0;
    }
    n = strlen(req);
    if (n == 0) {
        return 0;
    }
    cap.content_length = 0;
    cap.saw_complete = 0;
    llhttp_settings_init(&settings);
    settings.on_headers_complete = on_headers_complete;
    llhttp_init(&parser, HTTP_REQUEST, &settings);
    parser.data = &cap;
    err = llhttp_execute(&parser, req, n);
    return (err == HPE_OK && cap.saw_complete) ? 1 : 0;
}
