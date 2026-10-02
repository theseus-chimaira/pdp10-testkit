#include "insns.h"

/* runtime-global-init-subword.c - initialized subword data sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct init_rec {
  char6 c6;
  uchar6 u6;
  char9 c9[3];
  short16 s16;
  ushort16 u16;
  short18 s18;
  ushort18 u18;
};

static char6 gc6[4] = { (char6)-31, (char6)0, (char6)30, (char6)-1 };
static uchar8 gu8[4] = { (uchar8)0, (uchar8)0377, (uchar8)0123, (uchar8)0252 };
static short18 gh18[3] = { (short18)-012345, (short18)0, (short18)012345 };
static struct init_rec grec = {
  (char6)-7, (uchar6)077,
  { (char9)-1, (char9)0377, (char9)-0400 },
  (short16)-1234, (ushort16)65535,
  (short18)-0200000, (ushort18)0377777
};

static int
check_int(got, exp, id)
int got;
int exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint) id;
      semantic_sink = (uSint) got;
      return 0;
    }
  return 1;
}

int
runtime_global_init_subword_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!check_int((int)gc6[0], -31, 0100)) return 0;
  if (!check_int((int)gc6[2], 30, 0101)) return 0;
  if (!check_int((int)gu8[1], 0377, 0102)) return 0;
  if (!check_int((int)gu8[3], 0252, 0103)) return 0;
  if (!check_int((int)gh18[0], -012345, 0104)) return 0;
  if (!check_int((int)gh18[2], 012345, 0105)) return 0;

  if (!check_int((int)grec.c6, -7, 0200)) return 0;
  if (!check_int((int)grec.u6, 077, 0201)) return 0;
  if (!check_int((int)grec.c9[0], -1, 0202)) return 0;
  if (!check_int((int)grec.c9[1], 0377, 0203)) return 0;
  if (!check_int((int)grec.c9[2], -0400, 0204)) return 0;
  if (!check_int((int)grec.s16, -1234, 0205)) return 0;
  if (!check_int((int)grec.u16, 65535, 0206)) return 0;
  if (!check_int((int)grec.s18, -0200000, 0207)) return 0;
  if (!check_int((int)grec.u18, 0377777, 0210)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_global_init_subword_all(03))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
