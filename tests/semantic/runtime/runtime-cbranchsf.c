#include "insns.h"

/* runtime-cbranchsf.c - SF conditional branch sentry. */

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
branch_sfloat(a, b)
Sfloat a;
Sfloat b;
{
  if (a < b)
    return 1;
  if (a == b)
    return 2;
  if (a > b)
    return 3;
  return 4;
}

int
runtime_cbranchsf_all(seed)
int seed;
{
  Sfloat m1;
  Sfloat z;
  Sfloat p1;
  Sfloat p2;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  m1 = (Sfloat) -1.0;
  z = (Sfloat) 0.0;
  p1 = (Sfloat) 1.0;
  p2 = (Sfloat) 2.0;

  if (!check_int(branch_sfloat(m1, z), 1, 0100)) return 0;
  if (!check_int(branch_sfloat(p1, p1), 2, 0101)) return 0;
  if (!check_int(branch_sfloat(p2, p1), 3, 0102)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_cbranchsf_all(03))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
