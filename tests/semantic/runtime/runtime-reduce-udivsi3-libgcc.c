#include "insns.h"

/* runtime-reduce-udivsi3-libgcc.c - unsigned SImode division reducer.

   Scope:
     PDP-6 / KA10 baseline.  Unsigned SImode division must not depend on
     signed IDIV semantics when the high unsigned bit is set.  This reducer
     deliberately includes high-bit numerators to split the broad divmod-si
     failure away from the already-green signed IDIV path.
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

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) 011;

  if (!check_uint(udiv1((uSint)12345U, (uSint)10U),
                  (uSint)1234U, 0200))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_SIGN, (uSint)2U),
                  (uSint)0200000000000U, 0201))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_MAX, (uSint)0100U),
                  (uSint)0007777777777U, 0202))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1((uSint)0500000000000U, (uSint)010U),
                  (uSint)0050000000000U, 0203))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1((uSint)0400000000001U, (uSint)3U),
                  (uSint)0125252525253U, 0204))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_SIGN - (uSint)1U, U36_SIGN),
                  (uSint)0U, 0205))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_SIGN, U36_SIGN),
                  (uSint)1U, 0206))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_MAX, U36_SIGN),
                  (uSint)1U, 0207))
    return (int) semantic_fail_id;

  if (!check_uint(udiv1(U36_SIGN, U36_MAX),
                  (uSint)0U, 0210))
    return (int) semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
