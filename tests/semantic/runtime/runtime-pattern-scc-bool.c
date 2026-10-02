#include "insns.h"

/* runtime-pattern-scc-bool.c - set-on-condition boolean sentry. */

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
bool_pack(a, b)
Sint a;
Sint b;
{
  int r;

  r = 0;
  r = r + ((a == b) ? 1 : 0);
  r = r + ((a != b) ? 2 : 0);
  r = r + ((a < b) ? 4 : 0);
  r = r + ((a <= b) ? 010 : 0);
  r = r + ((a > b) ? 020 : 0);
  r = r + ((a >= b) ? 040 : 0);
  return r;
}

NOINLINE static int
logic_pack(a, b, c)
int a;
int b;
int c;
{
  return ((a && b) ? 1 : 0) + ((a || c) ? 2 : 0) + ((!c) ? 4 : 0);
}

int
runtime_pattern_scc_bool_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!check_int(bool_pack((Sint)5, (Sint)5), 1 + 010 + 040, 0100))
    return 0;
  if (!check_int(bool_pack((Sint)-1, (Sint)5), 2 + 4 + 010, 0101))
    return 0;
  if (!check_int(bool_pack((Sint)7, (Sint)5), 2 + 020 + 040, 0102))
    return 0;

  if (!check_int(logic_pack(1, 1, 0), 1 + 2 + 4, 0200)) return 0;
  if (!check_int(logic_pack(1, 0, 0), 2 + 4, 0201)) return 0;
  if (!check_int(logic_pack(0, 1, 1), 2, 0202)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_pattern_scc_bool_all(05))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
