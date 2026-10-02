/* flag: -std=gnu89 */
#include "insns.h"

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

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
computed_goto_table(idx)
int idx;
{
  static void *tbl[] = { &&L0, &&L1, &&L2 };
  int x = 0;

  goto *tbl[idx];
L0:
  x = 10;
  goto done;
L1:
  x = 20;
  goto done;
L2:
  x = 30;
  goto done;
done:
  return x;
}

NOINLINE static int
computed_goto_local(idx)
int idx;
{
  void *p;

  if (idx == 0)
    p = &&A;
  else if (idx == 1)
    p = &&B;
  else
    p = &&C;

  goto *p;
A:
  return 40;
B:
  return 50;
C:
  return 60;
}

int
runtime_computed_goto_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!check_int(computed_goto_table(0), 10, 0100)) return 0;
  if (!check_int(computed_goto_table(1), 20, 0101)) return 0;
  if (!check_int(computed_goto_table(2), 30, 0102)) return 0;

  if (!check_int(computed_goto_local(0), 40, 0200)) return 0;
  if (!check_int(computed_goto_local(1), 50, 0201)) return 0;
  if (!check_int(computed_goto_local(2), 60, 0202)) return 0;

  semantic_fail_id = 0;
  return 1;
}
