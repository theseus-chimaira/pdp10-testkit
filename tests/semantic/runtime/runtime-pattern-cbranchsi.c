#include "insns.h"

/* runtime-pattern-cbranchsi.c - SI conditional branch sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static int
check_int(got, exp, id)
int got;
int exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint) id;
      semantic_sink = (uSint) got;
      return 0;
    }
  return 1;
}

NOINLINE static int
branch_signed(a, b)
Sint a;
Sint b;
{
  if (a < b)
    return 1;
  if (a == b)
    return 2;
  if (a > b)
    return 3;
  return 4;
}

NOINLINE static int
branch_unsigned(a, b)
uSint a;
uSint b;
{
  if (a < b)
    return 5;
  if (a == b)
    return 6;
  if (a > b)
    return 7;
  return 8;
}

int
runtime_pattern_cbranchsi_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!check_int(branch_signed((Sint)-1, (Sint)0), 1, 0100)) return 0;
  if (!check_int(branch_signed((Sint)0123, (Sint)0123), 2, 0101)) return 0;
  if (!check_int(branch_signed((Sint)0124, (Sint)0123), 3, 0102)) return 0;

  if (!check_int(branch_unsigned((uSint)0123, (uSint)0124), 5, 0200))
    return 0;
  if (!check_int(branch_unsigned((uSint)0777, (uSint)0777), 6, 0201))
    return 0;
  if (!check_int(branch_unsigned((uSint)01000, (uSint)0777), 7, 0202))
    return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_pattern_cbranchsi_all(02))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
