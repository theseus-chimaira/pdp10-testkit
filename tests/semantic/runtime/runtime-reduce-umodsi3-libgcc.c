#include "insns.h"

/* runtime-reduce-umodsi3-libgcc.c - unsigned SImode modulo reducer. */

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
umod1(a, b)
uSint a;
uSint b;
{
  return a % b;
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) 012;

  if (!check_uint(umod1((uSint)12345U, (uSint)10U),
                  (uSint)5U, 0300))
    return (int) semantic_fail_id;

  if (!check_uint(umod1(U36_SIGN + (uSint)1U, (uSint)2U),
                  (uSint)1U, 0301))
    return (int) semantic_fail_id;

  if (!check_uint(umod1(U36_MAX, (uSint)0100U),
                  (uSint)077U, 0302))
    return (int) semantic_fail_id;

  if (!check_uint(umod1((uSint)0500000000005U, (uSint)010U),
                  (uSint)5U, 0303))
    return (int) semantic_fail_id;

  if (!check_uint(umod1((uSint)0400000000002U, (uSint)3U),
                  (uSint)1U, 0304))
    return (int) semantic_fail_id;

  if (!check_uint(umod1(U36_SIGN - (uSint)1U, U36_SIGN),
                  U36_SIGN - (uSint)1U, 0305))
    return (int) semantic_fail_id;

  if (!check_uint(umod1(U36_SIGN, U36_SIGN),
                  (uSint)0U, 0306))
    return (int) semantic_fail_id;

  if (!check_uint(umod1(U36_MAX, U36_SIGN),
                  U36_SIGN - (uSint)1U, 0307))
    return (int) semantic_fail_id;

  if (!check_uint(umod1(U36_SIGN, U36_MAX),
                  U36_SIGN, 0310))
    return (int) semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
