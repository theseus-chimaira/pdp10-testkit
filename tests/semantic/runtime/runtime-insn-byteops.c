#include "insns.h"

/* runtime-insn-byteops.c - byte load/store/increment behavior sentry. */

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
test_bytes(seed)
int seed;
{
  char6 c6[12];
  char9 c9[8];
  char6 *p6;
  char9 *p9;
  int i;

  for (i = 0; i < 12; i = i + 1)
    c6[i] = (char6)(seed + i);
  for (i = 0; i < 8; i = i + 1)
    c9[i] = (char9)(seed + 020 + i);

  p6 = &c6[5];
  if (!check_int((int)*p6, seed + 5, 0100)) return 0;
  *p6 = (char6)-7;
  if (!check_int((int)c6[5], -7, 0101)) return 0;
  p6 = p6 + 2;
  *p6 = (char6)-9;
  if (!check_int((int)c6[7], -9, 0102)) return 0;

  p9 = &c9[3];
  if (!check_int((int)*p9++, seed + 023, 0200)) return 0;
  if (!check_int((int)*p9, seed + 024, 0201)) return 0;
  *++p9 = (char9)-11;
  if (!check_int((int)c9[5], -11, 0202)) return 0;

  return 1;
}

int
runtime_insn_byteops_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_bytes(seed)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_insn_byteops_all(06))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
