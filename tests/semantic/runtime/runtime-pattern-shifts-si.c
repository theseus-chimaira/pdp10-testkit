#include "insns.h"

/* runtime-pattern-shifts-si.c - defined SI shift boundary sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

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

static int
check_int(got, exp, id)
Sint got;
Sint exp;
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

NOINLINE static uSint
shl_u(x, n)
uSint x;
int n;
{
  return x << n;
}

NOINLINE static uSint
shr_u(x, n)
uSint x;
int n;
{
  return x >> n;
}

NOINLINE static Sint
shr_s(x, n)
Sint x;
int n;
{
  return x >> n;
}

int
runtime_pattern_shifts_si_all(seed)
int seed;
{
  uSint high;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!check_uint(shl_u((uSint)1, 0), 1, 0100)) return 0;
  if (!check_uint(shl_u((uSint)1, 1), 2, 0101)) return 0;
  if (!check_uint(shl_u((uSint)1, 8), 0400, 0102)) return 0;
  if (!check_uint(shl_u((uSint)1, 9), 01000, 0103)) return 0;
  if (!check_uint(shl_u((uSint)1, 17), 0400000, 0104)) return 0;
  if (!check_uint(shl_u((uSint)1, 18), 01000000, 0105)) return 0;

  high = shl_u((uSint)1, 35);
  if (!check_uint(shr_u(high, 35), 1, 0200)) return 0;
  if (!check_uint(shr_u(shl_u((uSint)1, 34), 34), 1, 0201)) return 0;

  if (!check_int(shr_s((Sint)-1, 1), (Sint)-1, 0300)) return 0;
  if (!check_int(shr_s((Sint)-01000000, 18), (Sint)-1, 0301)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_pattern_shifts_si_all(03))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
