/*
 * Execute only the unchanged original GNU 71-bit floating-to-integer
 * assertions, using the real compiler/runtime with no substitutes.
 * The companion stage separately executes integer-to-floating casts.
 */

extern void abort(void);
volatile unsigned int fail_id;
volatile unsigned int stage_v1;

static void
stage_abort_v1(void)
{
    abort();
}

#define abort() (fail_id = __LINE__, stage_abort_v1())
#define main conversion_original_main_v1
#include "../upstream/pdp10/pdp10/conversion.c"
#undef main
#undef abort

int
main(void)
{
    stage_v1 = 1;
    tst_longlong_integer();
    stage_v1 = 2;
    return 0;
}
