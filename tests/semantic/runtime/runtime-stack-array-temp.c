/* runtime-stack-array-temp.c - stack array temporary/subword slot sentry. */
/* flag: -std=gnu89 */

#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_sink;
volatile uSint semantic_fail_id;

static int
pick_temp(i)
     int i;
{
  char p[4];

  p[0] = 011;
  p[1] = 022;
  p[2] = 033;
  p[3] = 044;
  return p[i & 3];
}

static int
sum_temp(seed)
     int seed;
{
  char p[4];

  p[0] = 05;
  p[1] = 06;
  p[2] = 07;
  p[3] = 010;
  return p[0] + p[1] + p[2] + p[3] + seed;
}

int
main()
{
  if (pick_temp(0) != 011) { semantic_fail_id = 1; return 1; }
  if (pick_temp(1) != 022) { semantic_fail_id = 2; return 2; }
  if (pick_temp(2) != 033) { semantic_fail_id = 3; return 3; }
  if (pick_temp(3) != 044) { semantic_fail_id = 4; return 4; }
  if (sum_temp(3) != (05 + 06 + 07 + 010 + 3)) { semantic_fail_id = 5; return 5; }
  semantic_fail_id = 0;
  semantic_sink = 1;
  __test_exit = 0;
  return 0;
}
