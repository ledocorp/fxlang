/* list immediate directory entry names (newline-joined). */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <dirent.h>
#include <sys/stat.h>
#endif

static char *g_list_buf = NULL;
static size_t g_list_cap = 0;

static int ensure_cap(size_t need) {
    char *nbuf;
    size_t ncap;
    if (need <= g_list_cap) {
        return 1;
    }
    ncap = g_list_cap == 0 ? 4096 : g_list_cap;
    while (ncap < need) {
        ncap *= 2;
    }
    nbuf = (char *)realloc(g_list_buf, ncap);
    if (nbuf == NULL) {
        return 0;
    }
    g_list_buf = nbuf;
    g_list_cap = ncap;
    return 1;
}

static int append_name(const char *name, size_t *len) {
    size_t n;
    if (name == NULL || name[0] == '\0') {
        return 1;
    }
    if (strcmp(name, ".") == 0 || strcmp(name, "..") == 0) {
        return 1;
    }
    n = strlen(name);
    if (!ensure_cap(*len + n + 2)) {
        return 0;
    }
    memcpy(g_list_buf + *len, name, n);
    *len += n;
    g_list_buf[*len] = '\n';
    *len += 1;
    g_list_buf[*len] = '\0';
    return 1;
}

/* Returns "" on failure / empty. Lifetime: until next call. */
const char *fx_fs_list_names(const char *path) {
    size_t len = 0;
    if (!ensure_cap(1)) {
        return "";
    }
    g_list_buf[0] = '\0';
    if (path == NULL || path[0] == '\0') {
        return g_list_buf;
    }
#if defined(_WIN32)
    {
        char pattern[MAX_PATH];
        WIN32_FIND_DATAA fd;
        HANDLE h;
        size_t plen = strlen(path);
        if (plen + 3 >= sizeof(pattern)) {
            return g_list_buf;
        }
        memcpy(pattern, path, plen);
        if (plen > 0 && path[plen - 1] != '\\' && path[plen - 1] != '/') {
            pattern[plen++] = '\\';
        }
        pattern[plen++] = '*';
        pattern[plen] = '\0';
        h = FindFirstFileA(pattern, &fd);
        if (h == INVALID_HANDLE_VALUE) {
            return g_list_buf;
        }
        do {
            if (!append_name(fd.cFileName, &len)) {
                FindClose(h);
                g_list_buf[0] = '\0';
                return g_list_buf;
            }
        } while (FindNextFileA(h, &fd));
        FindClose(h);
    }
#else
    {
        DIR *d = opendir(path);
        struct dirent *ent;
        if (d == NULL) {
            return g_list_buf;
        }
        while ((ent = readdir(d)) != NULL) {
            if (!append_name(ent->d_name, &len)) {
                closedir(d);
                g_list_buf[0] = '\0';
                return g_list_buf;
            }
        }
        closedir(d);
    }
#endif
    return g_list_buf;
}

int32_t fx_fs_list_ok(const char *path) {
#if defined(_WIN32)
    char pattern[MAX_PATH];
    WIN32_FIND_DATAA fd;
    HANDLE h;
    size_t plen;
    if (path == NULL || path[0] == '\0') {
        return 0;
    }
    plen = strlen(path);
    if (plen + 3 >= sizeof(pattern)) {
        return 0;
    }
    memcpy(pattern, path, plen);
    if (path[plen - 1] != '\\' && path[plen - 1] != '/') {
        pattern[plen++] = '\\';
    }
    pattern[plen++] = '*';
    pattern[plen] = '\0';
    h = FindFirstFileA(pattern, &fd);
    if (h == INVALID_HANDLE_VALUE) {
        return 0;
    }
    FindClose(h);
    return 1;
#else
    DIR *d;
    if (path == NULL || path[0] == '\0') {
        return 0;
    }
    d = opendir(path);
    if (d == NULL) {
        return 0;
    }
    closedir(d);
    return 1;
#endif
}
