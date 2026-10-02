#include "insns.h"

/* runtime-compare-subword-branches.c - subword comparison sentry. */

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
cmp_signed(a, b)
int a;
int b;
{
  if (a < b)
    return -1;
  if (a > b)
    return 1;
  return 0;
}

NOINLINE static int
cmp_unsigned(a, b)
unsigned int a;
unsigned int b;
{
  if (a < b)
    return -1;
  if (a > b)
    return 1;
  return 0;
}

int
runtime_compare_subword_branches_all(seed)
int seed;
{
  char9 c9a;
  char9 c9b;
  uchar9 u9a;
  uchar9 u9b;
  short18 h18a;
  short18 h18b;
  ushort18 uh18a;
  ushort18 uh18b;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  c9a = (char9)0377;
  c9b = (char9)0400;
  if (!check_int(cmp_signed((int)c9a, (int)c9b), 1, 0100)) return 0;
  if (!check_int(cmp_signed((int)c9b, 0), -1, 0101)) return 0;

  u9a = (uchar9)0377;
  u9b = (uchar9)0400;
  if (!check_int(cmp_unsigned((unsigned int)u9a, (unsigned int)u9b), -1, 0200))
    return 0;

  h18a = (short18)0377777;
  h18b = (short18)0400000;
  if (!check_int(cmp_signed((int)h18a, (int)h18b), 1, 0300)) return 0;
  if (!check_int(cmp_signed((int)h18b, 0), -1, 0301)) return 0;

  uh18a = (ushort18)0377777;
  uh18b = (ushort18)0400000;
  if (!check_int(cmp_unsigned((unsigned int)uh18a, (unsigned int)uh18b), -1,
                 0400)) return 0;

  if (seed != 0)
    semantic_sink = semantic_sink + (uSint)1;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_compare_subword_branches_all(05))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
