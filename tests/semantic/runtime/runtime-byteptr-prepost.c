#include "insns.h"

/* runtime-byteptr-prepost.c - byte pointer pre/post update sentry. */

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
test_c9(seed)
int seed;
{
  char9 a[10];
  char9 *p;
  char9 x;
  int i;

  for (i = 0; i < 10; i = i + 1)
    a[i] = (char9)(seed + i);

  p = &a[3];
  x = *p++;
  if (!check_int((int)x, seed + 3, 0100)) return 0;
  if (!check_int((int)(p - &a[0]), 4, 0101)) return 0;
  x = *++p;
  if (!check_int((int)x, seed + 5, 0102)) return 0;
  *p++ = (char9)-7;
  if (!check_int((int)a[5], -7, 0103)) return 0;
  *--p = (char9)-9;
  if (!check_int((int)a[5], -9, 0104)) return 0;
  return 1;
}

NOINLINE static int
test_h18(seed)
int seed;
{
  short18 a[8];
  short18 *p;
  int i;

  for (i = 0; i < 8; i = i + 1)
    a[i] = (short18)(seed + i);

  p = &a[2];
  if (!check_int((int)*p++, seed + 2, 0200)) return 0;
  if (!check_int((int)*p, seed + 3, 0201)) return 0;
  *++p = (short18)-0123;
  if (!check_int((int)a[4], -0123, 0202)) return 0;
  p--;
  if (!check_int((int)(p - &a[0]), 3, 0203)) return 0;
  return 1;
}

int
runtime_byteptr_prepost_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_c9(seed)) return 0;
  if (!test_h18(seed + 010)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_byteptr_prepost_all(011))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
