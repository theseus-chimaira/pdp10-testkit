#include "insns.h"

/* runtime-pattern-extv-insv.c - SI extract/insert behavior sentry. */

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

NOINLINE static uSint
extract_bits(x, pos, width)
uSint x;
int pos;
int width;
{
  uSint mask;

  mask = (((uSint)1 << width) - (uSint)1);
  return (x >> pos) & mask;
}

NOINLINE static uSint
insert_bits(x, pos, width, v)
uSint x;
int pos;
int width;
uSint v;
{
  uSint mask;

  mask = (((uSint)1 << width) - (uSint)1) << pos;
  return (x & ~mask) | ((v << pos) & mask);
}

int
runtime_pattern_extv_insv_all(seed)
int seed;
{
  uSint x;
  uSint y;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  x = (uSint)012345670123;
  if (!check_uint(extract_bits(x, 0, 6), 023, 0100)) return 0;
  if (!check_uint(extract_bits(x, 6, 6), 01, 0101)) return 0;
  if (!check_uint(extract_bits(x, 18, 9), 0345, 0102)) return 0;

  y = insert_bits(x, 0, 6, 077);
  if (!check_uint(extract_bits(y, 0, 6), 077, 0200)) return 0;
  if (!check_uint(extract_bits(y, 6, 6), 01, 0201)) return 0;

  y = insert_bits(x, 18, 9, 0123);
  if (!check_uint(extract_bits(y, 18, 9), 0123, 0202)) return 0;
  if (!check_uint(extract_bits(y, 0, 9), extract_bits(x, 0, 9), 0203))
    return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_pattern_extv_insv_all(01))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
