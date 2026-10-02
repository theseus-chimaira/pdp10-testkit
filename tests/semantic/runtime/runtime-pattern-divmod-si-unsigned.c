#include "insns.h"

/* runtime-pattern-divmod-si-unsigned.c - combined unsigned SI div/mod sentry.

   Run this after the isolated udivsi3/umodsi3 reducers.  If the reducers pass
   but this fails, the remaining bug is likely common-subexpression/register
   handling around q/r pairs rather than the helper arithmetic itself.

   v2 note: the v1 high-bit identity check used q * b + r to reconstruct a
   36-bit unsigned value above the sign bit.  That accidentally tested unsigned
   multiplication/codegen as well as division.  Keep high-bit division here as
   direct quotient/remainder checks; put unsigned multiply overflow semantics in
   a later mulsi3/umulsi3 test.
 */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

#define U36_MAX  ((uSint)0777777777777U)
#define U36_SIGN ((uSint)0400000000000U)

static int
check_uint(got, exp, id)
uSint got;
uSint exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint) id;
      semantic_sink = got;
      return 0;
    }
  return 1;
}

NOINLINE static uSint
udiv1(a, b)
uSint a;
uSint b;
{
  return a / b;
}

NOINLINE static uSint
umod1(a, b)
uSint a;
uSint b;
{
  return a % b;
}

NOINLINE static uSint
divmod_identity(a, b)
uSint a;
uSint b;
{
  uSint q;
  uSint r;
  q = a / b;
  r = a % b;
  return q * b + r;
}

NOINLINE static uSint
divmod_rem_after_store(a, b)
uSint a;
uSint b;
{
  uSint q;
  uSint r;
  q = a / b;
  r = a % b;
  semantic_sink = q;
  return r;
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) 013;

  if (!check_uint(udiv1((uSint)12345U, (uSint)10U),
                  (uSint)1234U, 0400)) return (int) semantic_fail_id;
  if (!check_uint(umod1((uSint)12345U, (uSint)10U),
                  (uSint)5U, 0401)) return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_MAX, (uSint)0100U),
                  (uSint)0007777777777U, 0402)) return (int) semantic_fail_id;
  if (!check_uint(umod1(U36_MAX, (uSint)0100U),
                  (uSint)077U, 0403)) return (int) semantic_fail_id;

  /* This identity is intentionally kept below the sign bit so q*b does not
     drag unsigned multiplication overflow semantics into the div/mod test. */
  if (!check_uint(divmod_identity((uSint)12345U, (uSint)97U),
                  (uSint)12345U, 0404)) return (int) semantic_fail_id;
  if (!check_uint(divmod_rem_after_store((uSint)12345U, (uSint)97U),
                  (uSint)26U, 0405)) return (int) semantic_fail_id;

  /* High-bit dividend with a non-power-of-two divisor.  Check quotient and
     remainder directly; do not reconstruct with q*b+r here. */
  if (!check_uint(udiv1(U36_SIGN + (uSint)012345U, (uSint)97U),
                  (uSint)02507204042U, 0406)) return (int) semantic_fail_id;
  if (!check_uint(umod1(U36_SIGN + (uSint)012345U, (uSint)97U),
                  (uSint)03U, 0407)) return (int) semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
