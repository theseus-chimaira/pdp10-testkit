#include "insns.h"
volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;
struct blt_rec { Sint a; char9 b[3]; short18 c; Sint d; };
int main() {
  struct blt_rec x;
  x.a = 7;
  x.b[0] = (char9)-1;
  x.b[1] = (char9)0123;
  x.b[2] = (char9)-0400;
  x.c = (short18)-012345;
  x.d = 0107;
  if ((int)x.b[0] != -1) { semantic_fail_id=0101; semantic_sink=(uSint)x.b[0]; return 0101; }
  if ((int)x.b[1] != 0123) { semantic_fail_id=0102; semantic_sink=(uSint)x.b[1]; return 0102; }
  if ((int)x.b[2] != -0400) { semantic_fail_id=0103; semantic_sink=(uSint)x.b[2]; return 0103; }
  return 0;
}
