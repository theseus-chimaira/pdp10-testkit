#include "insns.h"

/* runtime-subword-stack.c - semantic stack/local subword sentry.

   This is a self-checking GCC/PDP-10 runtime test.  It exercises stack
   arrays, stack scalar addresses, pointer walks, stores through pointers,
   and pointer differences for PDP-10 subword scalar types.

   runtime_subword_stack_all(seed) returns 1 on pass, 0 on failure.
   main() returns 0 on pass, or the failing case number on failure.
*/

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

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

static int
check_ptrdiff(got, exp, id)
int got;
int exp;
int id;
{
  return check_int(got, exp, id);
}

NOINLINE static int
test_stack_arrays(seed)
int seed;
{
  char6 c6[8];
  uchar6 u6[8];
  char7 c7[8];
  uchar7 u7[8];
  char8 c8[8];
  uchar8 u8[8];
  char9 c9[8];
  uchar9 u9[8];
  short16 s16[4];
  ushort16 u16[4];
  short18 s18[4];
  ushort18 u18[4];
  Qint q[4];
  uQint uq[4];
  Hint h[4];
  uHint uh[4];
  char9 *p9;
  short18 *p18;
  Qint *pq;
  Hint *ph;

  c6[0] = (char6)-1;
  c6[1] = (char6)31;
  c6[2] = (char6)-32;
  u6[0] = (uchar6)0;
  u6[1] = (uchar6)63;
  u6[2] = (uchar6)17;

  c7[0] = (char7)-1;
  c7[1] = (char7)63;
  c7[2] = (char7)-64;
  u7[0] = (uchar7)0;
  u7[1] = (uchar7)127;
  u7[2] = (uchar7)33;

  c8[0] = (char8)-1;
  c8[1] = (char8)127;
  c8[2] = (char8)-128;
  u8[0] = (uchar8)0;
  u8[1] = (uchar8)255;
  u8[2] = (uchar8)44;

  c9[0] = (char9)-1;
  c9[1] = (char9)255;
  c9[2] = (char9)-256;
  c9[3] = (char9)(seed + 7);
  u9[0] = (uchar9)0;
  u9[1] = (uchar9)511;
  u9[2] = (uchar9)123;

  s16[0] = (short16)-1;
  s16[1] = (short16)32767;
  s16[2] = (short16)-32768;
  u16[0] = (ushort16)0;
  u16[1] = (ushort16)65535;
  u16[2] = (ushort16)12345;

  s18[0] = (short18)-1;
  s18[1] = (short18)0177777;
  s18[2] = (short18)-0200000;
  u18[0] = (ushort18)0;
  u18[1] = (ushort18)0377777;
  u18[2] = (ushort18)0123456;

  q[0] = (Qint)-1;
  q[1] = (Qint)255;
  q[2] = (Qint)-256;
  uq[0] = (uQint)0;
  uq[1] = (uQint)511;
  uq[2] = (uQint)077;

  h[0] = (Hint)-1;
  h[1] = (Hint)0177777;
  h[2] = (Hint)-0200000;
  uh[0] = (uHint)0;
  uh[1] = (uHint)0377777;
  uh[2] = (uHint)0123456;

  if (!check_int((int)c6[0], -1, 1)) return 0;
  if (!check_int((int)c6[1], 31, 2)) return 0;
  if (!check_int((int)c6[2], -32, 3)) return 0;
  if (!check_int((int)u6[1], 63, 4)) return 0;

  if (!check_int((int)c7[0], -1, 5)) return 0;
  if (!check_int((int)c7[1], 63, 6)) return 0;
  if (!check_int((int)c7[2], -64, 7)) return 0;
  if (!check_int((int)u7[1], 127, 8)) return 0;

  if (!check_int((int)c8[0], -1, 9)) return 0;
  if (!check_int((int)c8[1], 127, 10)) return 0;
  if (!check_int((int)c8[2], -128, 11)) return 0;
  if (!check_int((int)u8[1], 255, 12)) return 0;

  if (!check_int((int)c9[0], -1, 13)) return 0;
  if (!check_int((int)c9[1], 255, 14)) return 0;
  if (!check_int((int)c9[2], -256, 15)) return 0;
  if (!check_int((int)u9[1], 511, 16)) return 0;

  if (!check_int((int)s16[0], -1, 17)) return 0;
  if (!check_int((int)s16[1], 32767, 18)) return 0;
  if (!check_int((int)s16[2], -32768, 19)) return 0;
  if (!check_int((int)u16[1], 65535, 20)) return 0;

  if (!check_int((int)s18[0], -1, 21)) return 0;
  if (!check_int((int)s18[1], 0177777, 22)) return 0;
  if (!check_int((int)s18[2], -0200000, 23)) return 0;
  if (!check_int((int)u18[1], 0377777, 24)) return 0;

  if (!check_int((int)q[0], -1, 25)) return 0;
  if (!check_int((int)q[1], 255, 26)) return 0;
  if (!check_int((int)q[2], -256, 27)) return 0;
  if (!check_int((int)uq[1], 511, 28)) return 0;

  if (!check_int((int)h[0], -1, 29)) return 0;
  if (!check_int((int)h[1], 0177777, 30)) return 0;
  if (!check_int((int)h[2], -0200000, 31)) return 0;
  if (!check_int((int)uh[1], 0377777, 32)) return 0;

  p9 = &c9[0];
  p9 = p9 + 3;
  if (!check_int((int)*p9, seed + 7, 33)) return 0;
  *p9 = (char9)-7;
  if (!check_int((int)c9[3], -7, 34)) return 0;
  if (!check_ptrdiff((int)(p9 - &c9[0]), 3, 35)) return 0;

  p18 = &s18[0];
  p18 = p18 + 2;
  if (!check_int((int)*p18, -0200000, 36)) return 0;
  *p18 = (short18)0123;
  if (!check_int((int)s18[2], 0123, 37)) return 0;
  if (!check_ptrdiff((int)(p18 - &s18[0]), 2, 38)) return 0;

  pq = &q[0];
  pq = pq + 2;
  if (!check_int((int)*pq, -256, 39)) return 0;
  *pq = (Qint)-11;
  if (!check_int((int)q[2], -11, 40)) return 0;
  if (!check_ptrdiff((int)(pq - &q[0]), 2, 41)) return 0;

  ph = &h[0];
  ph = ph + 2;
  if (!check_int((int)*ph, -0200000, 42)) return 0;
  *ph = (Hint)077;
  if (!check_int((int)h[2], 077, 43)) return 0;
  if (!check_ptrdiff((int)(ph - &h[0]), 2, 44)) return 0;

  semantic_sink = (uSint)c9[3] + (uSint)s18[2] + (uSint)q[2] + (uSint)h[2];
  return 1;
}

NOINLINE static int
test_stack_scalars(seed)
int seed;
{
  char6 c6;
  char7 c7;
  char8 c8;
  char9 c9;
  short18 h18;
  Qint q;
  Hint h;
  char6 *pc6;
  char7 *pc7;
  char8 *pc8;
  char9 *pc9;
  short18 *ph18;
  Qint *pq;
  Hint *ph;

  pc6 = &c6;
  pc7 = &c7;
  pc8 = &c8;
  pc9 = &c9;
  ph18 = &h18;
  pq = &q;
  ph = &h;

  *pc6 = (char6)-3;
  *pc7 = (char7)-4;
  *pc8 = (char8)-5;
  *pc9 = (char9)-6;
  *ph18 = (short18)-7;
  *pq = (Qint)-8;
  *ph = (Hint)-9;

  if (!check_int((int)c6, -3, 101)) return 0;
  if (!check_int((int)c7, -4, 102)) return 0;
  if (!check_int((int)c8, -5, 103)) return 0;
  if (!check_int((int)c9, -6, 104)) return 0;
  if (!check_int((int)h18, -7, 105)) return 0;
  if (!check_int((int)q, -8, 106)) return 0;
  if (!check_int((int)h, -9, 107)) return 0;

  *pc9 = (char9)(seed + 10);
  if (!check_int((int)*pc9, seed + 10, 108)) return 0;

  return 1;
}

int
runtime_subword_stack_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)seed;
  if (!test_stack_arrays(seed)) return 0;
  if (!test_stack_scalars(seed)) return 0;
  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_subword_stack_all(0123))
    return 0;
  if (semantic_fail_id != 0)
    return (int)semantic_fail_id;
  return 0777777;
}
