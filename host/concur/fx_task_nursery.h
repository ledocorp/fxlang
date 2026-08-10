/* Structured task nursery (host TCB) - substrate under concurrency synthesis.
 *
 * create → spawn* → join_all / join_timeout → shutdown/destroy.
 * Cooperative cancel: request_cancel; tasks poll cancel_requested.
 * Not language spawn/channels (see docs/specs/CONCURRENCY_SYNTHESIS.md).
 */
#ifndef FX_TASK_NURSERY_H
#define FX_TASK_NURSERY_H

#include <stddef.h>
#include <stdint.h>

#define FX_NURSERY_OK 0
#define FX_NURSERY_ERR 1
#define FX_NURSERY_FULL 2
#define FX_NURSERY_DEAD 3
#define FX_NURSERY_TIMEOUT 5

/* Default capacity (CONCUR-1); raise via fx_nursery_create_sized (CONCUR-1b). */
#define FX_NURSERY_DEFAULT_MAX 16
#define FX_NURSERY_HARD_MAX 64

/* Back-compat alias */
#define FX_NURSERY_MAX_TASKS FX_NURSERY_DEFAULT_MAX

typedef void (*FxTaskFn)(void *arg);

typedef struct FxNursery FxNursery;

/* Default capacity = FX_NURSERY_DEFAULT_MAX. */
FxNursery *fx_nursery_create(void);

/* 1..HARD_MAX slots; invalid → NULL. */
FxNursery *fx_nursery_create_sized(int max_tasks);

int fx_nursery_capacity(const FxNursery *n);

/* Start an OS thread running fn(arg). */
int fx_nursery_spawn(FxNursery *n, FxTaskFn fn, void *arg);

/* Block until every spawned task has finished. Idempotent while live. */
int fx_nursery_join_all(FxNursery *n);

/* Join with deadline (ms). TIMEOUT if any task still pending after wait. */
int fx_nursery_join_all_timeout(FxNursery *n, uint32_t timeout_ms);

/* Ask tasks to stop; tasks should poll fx_nursery_cancel_requested. */
int fx_nursery_request_cancel(FxNursery *n);

/* Nonzero if cancel was requested (for task bodies). */
int fx_nursery_cancel_requested(const FxNursery *n);

/* Join all, mark dead (tombstone). Handle remains for DEAD checks until destroy. */
int fx_nursery_shutdown(FxNursery *n);

/* Shutdown if still live, then free. NULL-safe. */
void fx_nursery_destroy(FxNursery *n);

int fx_nursery_is_live(const FxNursery *n);
int fx_nursery_pending(const FxNursery *n);

#endif /* FX_TASK_NURSERY_H */
