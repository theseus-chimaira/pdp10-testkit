/*
 * Diagnose the two GNU-only original 71-bit conversion phases (C89).
 * Include the unchanged upstream source and invoke each original
 * function independently.  This does not supply any test-local libc
 * function or alter the original assertions.
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
    test_longlong_integer_to_float();
    stage_v1 = 2;
    return 0;
}
