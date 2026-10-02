#include "insns.h"

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

NOINLINE static int
test_s16_arrayptr(seed)
int seed;
{
  short16 b[4];
  short16 *p;
  int got;

  b[0] = (short16)-32767;
  b[1] = (short16)32766;
  b[2] = (short16)-123;
  b[3] = (short16)seed;

  p = &b[1];
  got = (int)*p;

  semantic_sink = (uSint)got;

  if (got != 32766)
    {
      semantic_fail_id = 0306;
      return 0306;
    }

  semantic_fail_id = 0;
  return 0;
}

int
main()
{
  return test_s16_arrayptr(0123);
}
