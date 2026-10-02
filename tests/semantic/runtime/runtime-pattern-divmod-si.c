#include "insns.h"

/* runtime-pattern-divmod-si.c - SI divmod behavior sentry. */

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

NOINLINE static Sint
sdiv1(a, b)
Sint a;
Sint b;
{
  return a / b;
}

NOINLINE static Sint
smod1(a, b)
Sint a;
Sint b;
{
  return a % b;
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

int
runtime_pattern_divmod_si_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!check_int((int)sdiv1((Sint)12345, (Sint)10), 1234, 0100)) return 0;
  if (!check_int((int)smod1((Sint)12345, (Sint)10), 5, 0101)) return 0;
  if (!check_int((int)sdiv1((Sint)-12345, (Sint)10), -1234, 0102)) return 0;
  if (!check_int((int)smod1((Sint)-12345, (Sint)10), -5, 0103)) return 0;
  if (!check_int((int)sdiv1((Sint)12345, (Sint)-10), -1234, 0104)) return 0;
  if (!check_int((int)smod1((Sint)12345, (Sint)-10), 5, 0105)) return 0;

  if (!check_uint(udiv1((uSint)12345, (uSint)10), (uSint)1234, 0200))
    return 0;
  if (!check_uint(umod1((uSint)12345, (uSint)10), (uSint)5, 0201))
    return 0;
  if (!check_uint(udiv1((uSint)0777777, (uSint)0100), (uSint)07777, 0202))
    return 0;
  if (!check_uint(umod1((uSint)0777777, (uSint)0100), (uSint)077, 0203))
    return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_pattern_divmod_si_all(04))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
