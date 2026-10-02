#include "insns.h"

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

NOINLINE static int
test_s16_scalarptr(seed)
int seed;
{
  short16 a;
  short16 *p;
  int got;

  a = (short16)-32767;
  p = &a;
  got = (int)*p;

  semantic_sink = (uSint)got + (uSint)seed - (uSint)seed;

  if (got != -32767)
    {
      semantic_fail_id = 0301;
      return 0301;
    }

  semantic_fail_id = 0;
  return 0;
}

int
main()
{
  return test_s16_scalarptr(0123);
}
