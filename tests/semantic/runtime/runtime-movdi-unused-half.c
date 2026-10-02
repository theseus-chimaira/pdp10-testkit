#include "insns.h"

/* runtime-movdi-unused-half.c - DImode move with dead high/low word sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static uDint ga = (((uDint)012345) << 36) | (uDint)000077;
static uDint gb = (((uDint)054321) << 36) | (uDint)000123;
static volatile uDint vga = (((uDint)011111) << 36) | (uDint)000222;

#define EXPECT_GA_HIGH 012345
#define EXPECT_GB_HIGH 054321

static int
check(got, exp, id)
uSint got;
uSint exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint)id;
      semantic_sink = got;
      return 0;
    }
  return 1;
}

NOINLINE static uSint
select_low(c)
int c;
{
  uDint x;

  if (c)
    x = ga;
  else
    x = gb;

  return (uSint)x;
}

NOINLINE static uSint
select_high(c)
int c;
{
  uDint x;

  if (c)
    x = ga;
  else
    x = gb;

  return (uSint)(x >> 36);
}

NOINLINE static uSint
volatile_low(void)
{
  uDint x;

  x = vga;
  return (uSint)x;
}

int
main(void)
{
  if (!check(select_low(1), 000077, 0101)) return 1;
  if (!check(select_low(0), 000123, 0102)) return 1;
  if (!check(select_high(1), EXPECT_GA_HIGH, 0201)) return 1;
  if (!check(select_high(0), EXPECT_GB_HIGH, 0202)) return 1;
  if (!check(volatile_low(), 000222, 0301)) return 1;

  __test_exit = 0;
  return 0;
}
