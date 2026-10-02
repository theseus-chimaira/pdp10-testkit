#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;
static volatile char9 sink_c9;

int
main()
{
  char9 a;
  int got;

  a = (char9)-255;
  sink_c9 = *&a;
  got = (int)sink_c9;

  semantic_sink = (uSint) got;

  if (got != -255)
    {
      semantic_fail_id = 0240;
      return 0240;
    }

  semantic_fail_id = 0;
  return 0;
}
