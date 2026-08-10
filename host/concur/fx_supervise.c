#include "fx_supervise.h"

int fx_supervise_normalize_policy(int policy) {
    if (policy == FX_SUP_ONE_FOR_ONE || policy == FX_SUP_ONE_FOR_ALL
        || policy == FX_SUP_REST_FOR_ONE || policy == FX_SUP_ESCALATE) {
        return policy;
    }
    return FX_SUP_ONE_FOR_ONE;
}

int fx_supervise_apply(FxNursery *n, int policy, int child_ok) {
    int p = fx_supervise_normalize_policy(policy);
    if (child_ok == 0) {
        return FX_NURSERY_OK;
    }
    if (p == FX_SUP_ONE_FOR_ALL || p == FX_SUP_REST_FOR_ONE) {
        if (!n) {
            return FX_NURSERY_ERR;
        }
        return fx_nursery_request_cancel(n);
    }
    if (p == FX_SUP_ESCALATE) {
        return FX_SUP_ESCALATE;
    }
    /* ONE_FOR_ONE: isolate failure - no nursery-wide cancel. */
    return FX_NURSERY_OK;
}
