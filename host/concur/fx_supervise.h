/* Nursery supervision policies. */
#ifndef FX_SUPERVISE_H
#define FX_SUPERVISE_H

#include "fx_task_nursery.h"

#define FX_SUP_ONE_FOR_ONE 1
#define FX_SUP_ONE_FOR_ALL 2
#define FX_SUP_REST_FOR_ONE 3
#define FX_SUP_ESCALATE 4

/* Returns policy unchanged when valid; else ONE_FOR_ONE. */
int fx_supervise_normalize_policy(int policy);

/*
 * Apply policy after a child reports status (0 = ok, nonzero = fail).
 * Returns:
 *   0  - continue (one_for_one / rest_for_one / success)
 *   4  - escalate to parent (FX_SUP_ESCALATE on fail)
 *   other - host err
 * On ONE_FOR_ALL fail: request_cancel on nursery.
 */
int fx_supervise_apply(FxNursery *n, int policy, int child_ok);

#endif
