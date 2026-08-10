/* getenv only (argv stays host/cli). */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

static const char kEmpty[] = "";

/* Non-NULL pointer to value, or "" when unset. */
const char *fx_env_get(const char *name) {
    const char *v;
    if (name == NULL || name[0] == '\0') {
        return kEmpty;
    }
    v = getenv(name);
    return v != NULL ? v : kEmpty;
}

int32_t fx_env_has(const char *name) {
    if (name == NULL || name[0] == '\0') {
        return 0;
    }
    return getenv(name) != NULL ? 1 : 0;
}
