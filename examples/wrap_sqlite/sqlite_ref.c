/* Thin C facade over SQLite amalgamation for fx extern.
 * Opaque sqlite3* stays in C; fx sees i32 handles + error codes only.
 * File opens under FsCap use host/cap allowlist (deny = -5).
 */
#include "sqlite3.h"
#include "fx_cap_runtime.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#define FX_SQLITE_MAX_DB 8
#define FX_SQLITE_ERR (-1)
#define FX_SQLITE_BAD_H (-2)
#define FX_SQLITE_DENIED (-5)

static sqlite3 *g_dbs[FX_SQLITE_MAX_DB];

static int slot_alloc(void) {
    int i;
    for (i = 0; i < FX_SQLITE_MAX_DB; i++) {
        if (g_dbs[i] == NULL) {
            return i;
        }
    }
    return -1;
}

static sqlite3 *db_from_h(int32_t h) {
    if (h < 1 || h > FX_SQLITE_MAX_DB) {
        return NULL;
    }
    return g_dbs[h - 1];
}

static int32_t open_at_path(const char *path) {
    int slot;
    sqlite3 *db = NULL;
    int rc;

    if (path == NULL || path[0] == '\0') {
        return FX_SQLITE_ERR;
    }
    slot = slot_alloc();
    if (slot < 0) {
        return FX_SQLITE_ERR;
    }
    rc = sqlite3_open(path, &db);
    if (rc != SQLITE_OK || db == NULL) {
        if (db != NULL) {
            (void)sqlite3_close(db);
        }
        return FX_SQLITE_ERR;
    }
    g_dbs[slot] = db;
    return (int32_t)(slot + 1);
}

/* Open :memory: DB. Returns handle >= 1, or negative on error. */
int32_t fx_sqlite_open_memory(void) {
    return open_at_path(":memory:");
}

/* Process-trust file open (no cap). Prefer open_fscap for sandboxed guests. */
int32_t fx_sqlite_open_path(const char *path) {
    return open_at_path(path);
}

/* Open file path only if FsCap allowlists it. -5 = denied. */
int32_t fx_sqlite_open_fscap(int64_t fs_handle, const char *path) {
    FxFsCap *cap = fx_fscap_from_handle(fs_handle);
    if (!fx_fscap_path_allowed(cap, path)) {
        return FX_SQLITE_DENIED;
    }
    return open_at_path(path);
}

/* Exec SQL (no result rows required). 0 = ok; negative = error. */
int32_t fx_sqlite_exec(int32_t h, const char *sql) {
    sqlite3 *db;
    char *errmsg = NULL;
    int rc;

    db = db_from_h(h);
    if (db == NULL || sql == NULL) {
        return FX_SQLITE_BAD_H;
    }
    rc = sqlite3_exec(db, sql, NULL, NULL, &errmsg);
    if (errmsg != NULL) {
        sqlite3_free(errmsg);
    }
    return (rc == SQLITE_OK) ? 0 : FX_SQLITE_ERR;
}

/* Run a single-column integer SELECT; return the value, or negative on error. */
int32_t fx_sqlite_query_i32(int32_t h, const char *sql) {
    sqlite3 *db;
    sqlite3_stmt *stmt = NULL;
    int rc;
    int32_t val;

    db = db_from_h(h);
    if (db == NULL || sql == NULL) {
        return FX_SQLITE_BAD_H;
    }
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
    if (rc != SQLITE_OK || stmt == NULL) {
        if (stmt != NULL) {
            (void)sqlite3_finalize(stmt);
        }
        return FX_SQLITE_ERR;
    }
    rc = sqlite3_step(stmt);
    if (rc != SQLITE_ROW) {
        (void)sqlite3_finalize(stmt);
        return FX_SQLITE_ERR;
    }
    val = (int32_t)sqlite3_column_int(stmt, 0);
    (void)sqlite3_finalize(stmt);
    return val;
}

/* Close handle. 0 = ok; negative = bad handle. */
int32_t fx_sqlite_close(int32_t h) {
    sqlite3 *db;

    if (h < 1 || h > FX_SQLITE_MAX_DB) {
        return FX_SQLITE_BAD_H;
    }
    db = g_dbs[h - 1];
    if (db == NULL) {
        return FX_SQLITE_BAD_H;
    }
    (void)sqlite3_close(db);
    g_dbs[h - 1] = NULL;
    return 0;
}
