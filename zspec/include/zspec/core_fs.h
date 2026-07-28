#ifndef ZSPEC_CORE_FS_H
#define ZSPEC_CORE_FS_H

#include <stdint.h>

#include "zspec/core_allocator.h"
#include "zspec/core_error.h"

/* Z3 — minimal text file read/write (stdio-backed). */

core_Err core_fs_write_text(const char* path, const char* text);
core_Err core_fs_append_text(const char* path, const char* text);
core_Err core_fs_read_text(core_Allocator* allocator, const char* path, char** out);
core_Err core_fs_exists(const char* path, int32_t* out);
core_Err core_fs_remove(const char* path);
core_Err core_fs_rename(const char* old_path, const char* new_path);

#endif /* ZSPEC_CORE_FS_H */
