#include "insns.h"

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct leaf_c8 {
  char6 pad6;
  uchar7 pad7;
  char8 c8[2];
  char9 tail9;
};

NOINLINE static int
test_struct_c8_arrayptr(seed)
int seed;
{
  struct leaf_c8 x;
  char8 *p;
  int got0;
  int got1;

  x.pad6 = (char6)-31;
  x.pad7 = (uchar7)127;
  x.c8[0] = (char8)-127;
  x.c8[1] = (char8)126;
  x.tail9 = (char9)(seed - 020);

  p = &x.c8[0];
  p = p + 1;
  *p = (char8)-12;

  got0 = (int)x.c8[0];
  got1 = (int)x.c8[1];

  semantic_sink = (uSint)got1;

  if (got0 != -127)
    {
      semantic_fail_id = 1110;
      return 1110;
    }

  if (got1 != -12)
    {
      semantic_fail_id = 1111;
      return 1111;
    }

  semantic_fail_id = 0;
  return 0;
}

int
main()
{
  return test_struct_c8_arrayptr(030);
}
