#include "insns.h"

/* runtime-stack-byte-halfword-stores.c - stack subword store/reload sentry. */

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

#define DECL_STACK_STORE_TEST(TAG, TYPE, A, EA, B, EB, C, EC, BASE)       \
NOINLINE static int                                                       \
test_stack_store_ ## TAG(seed)                                            \
int seed;                                                                 \
{                                                                         \
  TYPE x;                                                                 \
  TYPE a[7];                                                              \
  TYPE *p;                                                                \
  TYPE * volatile vp;                                                     \
  int i;                                                                  \
                                                                          \
  x = (TYPE)(A);                                                          \
  p = &x;                                                                 \
  if (!check_int((int)*p, (EA), (BASE) + 0)) return 0;                    \
                                                                          \
  *p = (TYPE)(B);                                                         \
  if (!check_int((int)x, (EB), (BASE) + 1)) return 0;                     \
                                                                          \
  vp = p;                                                                 \
  *vp = (TYPE)(C);                                                        \
  if (!check_int((int)x, (EC), (BASE) + 2)) return 0;                     \
  if (!check_int((int)*p, (EC), (BASE) + 3)) return 0;                    \
                                                                          \
  for (i = 0; i < 7; i = i + 1)                                           \
    a[i] = (TYPE)(seed + i);                                              \
                                                                          \
  a[1] = (TYPE)(A);                                                       \
  a[3] = (TYPE)(B);                                                       \
  a[5] = (TYPE)(C);                                                       \
  p = &a[1];                                                              \
  if (!check_int((int)*p, (EA), (BASE) + 4)) return 0;                    \
  p = p + 2;                                                              \
  if (!check_int((int)*p, (EB), (BASE) + 5)) return 0;                    \
  *p = (TYPE)(A);                                                         \
  if (!check_int((int)a[3], (EA), (BASE) + 6)) return 0;                  \
  vp = &a[5];                                                             \
  if (!check_int((int)*vp, (EC), (BASE) + 7)) return 0;                   \
  *vp = (TYPE)(B);                                                        \
  if (!check_int((int)a[5], (EB), (BASE) + 8)) return 0;                  \
  if (!check_int((int)(vp - &a[0]), 5, (BASE) + 9)) return 0;             \
                                                                          \
  semantic_sink = semantic_sink + (uSint)(int)x + (uSint)(int)a[5];       \
  return 1;                                                               \
}

DECL_STACK_STORE_TEST(c6,   char6,    -31,     -31,     30,      30,      -7,      -7,      0100)
DECL_STACK_STORE_TEST(uc6,  uchar6,   63,      63,      17,      17,      42,      42,      0120)
DECL_STACK_STORE_TEST(c7,   char7,    -63,     -63,     62,      62,      -9,      -9,      0140)
DECL_STACK_STORE_TEST(uc7,  uchar7,   127,     127,     33,      33,      77,      77,      0160)
DECL_STACK_STORE_TEST(c8,   char8,    -127,    -127,    126,     126,     -11,     -11,     0200)
DECL_STACK_STORE_TEST(uc8,  uchar8,   255,     255,     44,      44,      155,     155,     0220)
DECL_STACK_STORE_TEST(c9,   char9,    -255,    -255,    254,     254,     -13,     -13,     0240)
DECL_STACK_STORE_TEST(uc9,  uchar9,   511,     511,     0123,    0123,    0456,    0456,    0260)
DECL_STACK_STORE_TEST(s16,  short16,  -32767,  -32767,  32766,   32766,   -123,    -123,    0300)
DECL_STACK_STORE_TEST(us16, ushort16, 65535,   65535,   12345,   12345,   54321,   54321,   0320)
DECL_STACK_STORE_TEST(s18,  short18,  -012345, -012345, 012345,  012345,  -07654,  -07654,  0340)
DECL_STACK_STORE_TEST(us18, ushort18, 0377777, 0377777, 0123456, 0123456, 034567,  034567,  0360)

int
runtime_stack_byte_halfword_stores_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_stack_store_c6(seed)) return 0;
  if (!test_stack_store_uc6(seed)) return 0;
  if (!test_stack_store_c7(seed)) return 0;
  if (!test_stack_store_uc7(seed)) return 0;
  if (!test_stack_store_c8(seed)) return 0;
  if (!test_stack_store_uc8(seed)) return 0;
  if (!test_stack_store_c9(seed)) return 0;
  if (!test_stack_store_uc9(seed)) return 0;
  if (!test_stack_store_s16(seed)) return 0;
  if (!test_stack_store_us16(seed)) return 0;
  if (!test_stack_store_s18(seed)) return 0;
  if (!test_stack_store_us18(seed)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_stack_byte_halfword_stores_all(012))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
