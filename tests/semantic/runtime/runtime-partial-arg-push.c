#include "insns.h"

/* runtime-partial-arg-push.c - PDP-10 partial register/stack argument sentry.
   With the default four argument registers, the fourth uDint argument here
   straddles the register window: one word in an argument register and one
   word in the outgoing stack area. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static uDint
mkdi(hi, lo)
uSint hi;
uSint lo;
{
  return (((uDint) hi) << 36) | (uDint) lo;
}

static int
check_udint(got, exp, id)
uDint got;
uDint exp;
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

NOINLINE static uDint
partial_fourth(a, b, c, d)
Sint a;
Sint b;
Sint c;
uDint d;
{
  if (a != 1 || b != 2 || c != 3)
    return mkdi(0777, (uSint) (a + b + c));
  return d;
}

NOINLINE static uDint
partial_fourth_plus(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
uDint d;
Sint e;
{
  if (a != 4 || b != 5 || c != 6 || e != 7)
    return mkdi(0776, (uSint) (a + b + c + e));
  return d;
}

NOINLINE static uDint
all_stack_after_window(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
uDint e;
{
  if (a != 8 || b != 9 || c != 10 || d != 11)
    return mkdi(0775, (uSint) (a + b + c + d));
  return e;
}

int
runtime_partial_arg_push_all(seed)
int seed;
{
  uDint x;
  uDint y;
  uDint z;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  x = mkdi(012345, 0670123456701);
  y = mkdi(023456, 0123456701234);
  z = mkdi(034567, 0765432101234);

  if (!check_udint(partial_fourth(1, 2, 3, x), x, 0100)) return 0;
  if (!check_udint(partial_fourth_plus(4, 5, 6, y, 7), y, 0101)) return 0;
  if (!check_udint(all_stack_after_window(8, 9, 10, 11, z), z, 0102)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  int ok;

  ok = runtime_partial_arg_push_all(5);
  if (!ok)
    return (int) semantic_fail_id;
  if (semantic_fail_id != 0)
    return 0777777;
  return 0;
}
