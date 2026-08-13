/* Shared OS process edge - FX-PROCESS-EDGE-1.
 * Win + Linux. Not part of libzspec.a.
 */
#include "fx_process.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "zspec/core_allocator.h"
#include "zspec/core_error.h"
#include "zspec/core_string.h"

#ifdef _WIN32
#include <windows.h>
#include <direct.h>
#define FX_PROC_GETCWD _getcwd
#define FX_PROC_CHDIR _chdir
#else
#include <errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#define FX_PROC_GETCWD getcwd
#define FX_PROC_CHDIR chdir
#endif

int fx_proc_file_exists(const char *path) {
#ifdef _WIN32
    DWORD a;
    if (path == NULL || path[0] == '\0') {
        return 0;
    }
    a = GetFileAttributesA(path);
    return (a != INVALID_FILE_ATTRIBUTES) && ((a & FILE_ATTRIBUTE_DIRECTORY) == 0);
#else
    struct stat st;
    if (path == NULL || path[0] == '\0') {
        return 0;
    }
    if (stat(path, &st) != 0) {
        return 0;
    }
    return S_ISREG(st.st_mode) ? 1 : 0;
#endif
}

char *fx_proc_getcwd(char *buf, size_t buflen) {
    if (buf == NULL || buflen == 0) {
        return NULL;
    }
    return FX_PROC_GETCWD(buf, (int)buflen);
}

int fx_proc_chdir(const char *path) {
    if (path == NULL || path[0] == '\0') {
        return 1;
    }
    return (FX_PROC_CHDIR(path) == 0) ? 0 : 1;
}

int fx_proc_run_cmd(const char *cmd) {
    int st;
    if (cmd == NULL || cmd[0] == '\0') {
        return 1;
    }
#ifdef _WIN32
    st = system(cmd);
    if (st == -1) {
        return 127;
    }
    return st;
#else
    st = system(cmd);
    if (st == -1) {
        return 127;
    }
    if (WIFEXITED(st)) {
        return WEXITSTATUS(st);
    }
    return 1;
#endif
}

int fx_proc_ensure_dir(const char *path) {
    if (path == NULL || path[0] == '\0') {
        return 1;
    }
#ifdef _WIN32
    if (CreateDirectoryA(path, NULL) || GetLastError() == ERROR_ALREADY_EXISTS) {
        return 0;
    }
    return 1;
#else
    if (mkdir(path, 0755) == 0 || errno == EEXIST) {
        return 0;
    }
    return 1;
#endif
}

const char *fx_proc_slice(const char *s, int32_t lo, int32_t hi) {
    size_t slen;
    char *out = NULL;
    core_str_view v;
    if (s == NULL || lo < 0 || hi < lo) {
        return "";
    }
    slen = strlen(s);
    if ((size_t)hi > slen) {
        hi = (int32_t)slen;
    }
    if ((size_t)lo > slen || lo == hi) {
        return "";
    }
    v = core_str_view_from_parts(s + (size_t)lo, (size_t)(hi - lo));
    if (core_str_dup(core_default_allocator(), v, &out) != CORE_OK || out == NULL) {
        return "";
    }
    return out;
}

const char *fx_proc_i32_dec(int32_t n) {
    char buf[16];
    char *out = NULL;
    int m;
    m = snprintf(buf, sizeof(buf), "%d", (int)n);
    if (m < 0) {
        return "0";
    }
    if (core_str_dup_cstr(core_default_allocator(), buf, &out) != CORE_OK || out == NULL) {
        return "0";
    }
    return out;
}

const char *fx_proc_getcwd_alloc(void) {
    char buf[4096];
    char *out = NULL;
    if (fx_proc_getcwd(buf, sizeof(buf)) == NULL) {
        return "";
    }
    if (core_str_dup_cstr(core_default_allocator(), buf, &out) != CORE_OK || out == NULL) {
        return "";
    }
    return out;
}
