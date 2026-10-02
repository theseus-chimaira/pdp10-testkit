#include "insns.h"

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
test_c6(seed)
int seed;
{
  char6 a;
  char6 b[4];
  char6 *p;
  char6 * volatile pv;

  a = (char6)-31;
  if (!check_int((int)*&a, -31, 0100)) return 0;

  p = &a;
  if (!check_int((int)*p, -31, 0101)) return 0;

  *p = (char6)30;
  if (!check_int((int)a, 30, 0102)) return 0;

  pv = &a;
  *pv = (char6)-7;
  if (!check_int((int)a, -7, 0104)) return 0;

  b[0] = (char6)-31;
  b[1] = (char6)30;
  b[2] = (char6)-7;
  b[3] = (char6)seed;

  p = &b[1];
  if (!check_int((int)*p, 30, 0106)) return 0;
  p = p + 1;
  if (!check_int((int)*p, -7, 0107)) return 0;

  semantic_sink = semantic_sink + (uSint)(int)a + (uSint)(int)b[2];
  return 1;
}

NOINLINE static int
test_uc6(seed)
int seed;
{
  uchar6 a;
  uchar6 b[4];
  uchar6 *p;
  uchar6 * volatile pv;

  a = (uchar6)63;
  if (!check_int((int)*&a, 63, 0120)) return 0;

  p = &a;
  if (!check_int((int)*p, 63, 0121)) return 0;

  *p = (uchar6)17;
  if (!check_int((int)a, 17, 0122)) return 0;

  pv = &a;
  *pv = (uchar6)42;
  if (!check_int((int)a, 42, 0124)) return 0;

  b[0] = (uchar6)63;
  b[1] = (uchar6)17;
  b[2] = (uchar6)42;
  b[3] = (uchar6)seed;

  p = &b[1];
  if (!check_int((int)*p, 17, 0126)) return 0;
  p = p + 1;
  if (!check_int((int)*p, 42, 0127)) return 0;

  semantic_sink = semantic_sink + (uSint)(int)a + (uSint)(int)b[2];
  return 1;
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = 0123;

  if (!test_c6(0123))
    return (int) semantic_fail_id;
  if (!test_uc6(0123))
    return (int) semantic_fail_id;

  semantic_fail_id = 0;
  return 0;
}
