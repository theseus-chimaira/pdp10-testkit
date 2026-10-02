#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

int
main()
{
  uchar6 pad0;
  uchar6 pad1;
  uchar6 pad2;
  uchar6 pad3;
  uchar6 a;
  uchar6 *p;
  int got;

  pad0 = (uchar6)1;
  pad1 = (uchar6)2;
  pad2 = (uchar6)3;
  pad3 = (uchar6)4;

  a = (uchar6)63;
  p = &a;
  got = (int)*p;

  semantic_sink = (uSint) got + (uSint) pad0 + (uSint) pad1
    + (uSint) pad2 + (uSint) pad3;

  if (got != 63)
    {
      semantic_fail_id = 0121;
      return 0121;
    }

  semantic_fail_id = 0;
  return 0;
}
