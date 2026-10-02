#include "insns.h"
volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;
volatile uSint g0,g1,g2,g3,g4,g5,g6,g7;
struct blt_rec { Sint a; char9 b[3]; short18 c; Sint d; };
int main() {
 struct blt_rec src; struct blt_rec dst;
 src.a=7; src.b[0]=(char9)-1; src.b[1]=(char9)0123; src.b[2]=(char9)-0400; src.c=(short18)-012345; src.d=0107;
 dst=src;
 g0=(uSint)dst.a; g1=(uSint)dst.b[0]; g2=(uSint)dst.b[1]; g3=(uSint)dst.b[2]; g4=(uSint)dst.c; g5=(uSint)dst.d;
 if ((int)dst.b[1] != 0123) { semantic_fail_id=0102; semantic_sink=(uSint)dst.b[1]; return 0102; }
 return 0;
}
