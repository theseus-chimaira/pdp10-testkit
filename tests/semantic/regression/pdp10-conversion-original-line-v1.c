/*
 * Diagnostic exact-original assertion locator for P1 conversion.c.
 *
 * Preserve the original source, all conversion operations, and every
 * abort condition without introducing test substitutes.  The macro
 * records the original included source line of the first failing
 * abort, then invokes the real testkit abort/exit path.
 *
 * This diagnostic is not a replacement for successful execution
 * of the unchanged upstream conversion.c itself.
 */

extern void abort(void);

volatile unsigned int fail_id;

static void
conversion_abort_v1(void)
{
    abort();
}

#define abort() (fail_id = __LINE__, conversion_abort_v1())
#include "../upstream/pdp10/pdp10/conversion.c"
#undef abort
