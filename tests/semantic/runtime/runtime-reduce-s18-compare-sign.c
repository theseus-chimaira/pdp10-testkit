#include "insns.h"

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

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

int
main()
{
  short18 a;
  short18 b;
  int ai;
  int bi;
  int r;

  a = (short18)0377777;
  b = (short18)0400000;

  ai = (int)a;
  bi = (int)b;

  semantic_sink = (uSint)bi;

  if (ai != 0377777)
    {
      semantic_fail_id = 0301;
      return 0301;
    }

  if (bi != -0400000)
    {
      semantic_fail_id = 0302;
      return 0302;
    }

  r = cmp_signed(ai, bi);
  semantic_sink = (uSint)r;

  if (r != 1)
    {
      semantic_fail_id = 0300;
      return 0300;
    }

  semantic_fail_id = 0;
  return 0;
}
