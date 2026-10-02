#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

int
main()
{
  uchar6 a;
  uchar6 *p;
  int got;

  a = (uchar6)63;
  p = &a;
  got = (int)*p;

  semantic_sink = (uSint) got;

  if (got != 63)
    {
      semantic_fail_id = 0121;
      return 0121;
    }

  semantic_fail_id = 0;
  return 0;
}
