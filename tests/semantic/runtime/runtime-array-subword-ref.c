#include "insns.h"

/* runtime-array-subword-ref.c - char6/7/8/9 and short16/18 array refs. */

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

#define DECL_ARRAY_REF_TEST(TAG, TYPE, A, EA, B, EB, C, EC, BASE)         \
static TYPE global_ ## TAG[13];                                          \
NOINLINE static int                                                       \
test_array_ref_ ## TAG(seed)                                              \
int seed;                                                                 \
{                                                                         \
  TYPE local[13];                                                         \
  TYPE *p;                                                                \
  int i;                                                                  \
  int j;                                                                  \
                                                                          \
  for (i = 0; i < 13; i = i + 1)                                          \
    {                                                                     \
      local[i] = (TYPE)(seed + i);                                        \
      global_ ## TAG[i] = (TYPE)(seed + i + 010);                         \
    }                                                                     \
                                                                          \
  local[0] = (TYPE)(A);                                                   \
  local[6] = (TYPE)(B);                                                   \
  local[12] = (TYPE)(C);                                                  \
  global_ ## TAG[1] = (TYPE)(A);                                          \
  global_ ## TAG[7] = (TYPE)(B);                                          \
  global_ ## TAG[11] = (TYPE)(C);                                         \
                                                                          \
  if (!check_int((int)local[0], (EA), (BASE) + 0)) return 0;              \
  if (!check_int((int)local[6], (EB), (BASE) + 1)) return 0;              \
  if (!check_int((int)local[12], (EC), (BASE) + 2)) return 0;             \
  if (!check_int((int)global_ ## TAG[1], (EA), (BASE) + 3)) return 0;     \
  if (!check_int((int)global_ ## TAG[7], (EB), (BASE) + 4)) return 0;     \
  if (!check_int((int)global_ ## TAG[11], (EC), (BASE) + 5)) return 0;    \
                                                                          \
  i = 2;                                                                  \
  j = 4;                                                                  \
  local[i + j] = (TYPE)(A);                                               \
  if (!check_int((int)local[6], (EA), (BASE) + 6)) return 0;              \
                                                                          \
  p = &local[3];                                                          \
  p[j] = (TYPE)(B);                                                       \
  if (!check_int((int)local[7], (EB), (BASE) + 7)) return 0;              \
  if (!check_int((int)*(p + j), (EB), (BASE) + 8)) return 0;              \
                                                                          \
  p = &global_ ## TAG[0];                                                 \
  *(p + 11) = (TYPE)(A);                                                  \
  if (!check_int((int)global_ ## TAG[11], (EA), (BASE) + 9)) return 0;    \
  if (!check_int((int)(p + 11 - &global_ ## TAG[0]), 11, (BASE) + 10))    \
    return 0;                                                             \
                                                                          \
  semantic_sink = semantic_sink + (uSint)(int)local[7];                   \
  return 1;                                                               \
}

DECL_ARRAY_REF_TEST(c6,   char6,    -31,     -31,     30,      30,      -7,      -7,      0100)
DECL_ARRAY_REF_TEST(uc6,  uchar6,   63,      63,      17,      17,      42,      42,      0120)
DECL_ARRAY_REF_TEST(c7,   char7,    -63,     -63,     62,      62,      -9,      -9,      0140)
DECL_ARRAY_REF_TEST(uc7,  uchar7,   127,     127,     33,      33,      77,      77,      0160)
DECL_ARRAY_REF_TEST(c8,   char8,    -127,    -127,    126,     126,     -11,     -11,     0200)
DECL_ARRAY_REF_TEST(uc8,  uchar8,   255,     255,     44,      44,      155,     155,     0220)
DECL_ARRAY_REF_TEST(c9,   char9,    -255,    -255,    254,     254,     -13,     -13,     0240)
DECL_ARRAY_REF_TEST(uc9,  uchar9,   511,     511,     0123,    0123,    0456,    0456,    0260)
DECL_ARRAY_REF_TEST(s16,  short16,  -32767,  -32767,  32766,   32766,   -123,    -123,    0300)
DECL_ARRAY_REF_TEST(us16, ushort16, 65535,   65535,   12345,   12345,   54321,   54321,   0320)
DECL_ARRAY_REF_TEST(s18,  short18,  -012345, -012345, 012345,  012345,  -07654,  -07654,  0340)
DECL_ARRAY_REF_TEST(us18, ushort18, 0377777, 0377777, 0123456, 0123456, 034567,  034567,  0360)

int
runtime_array_subword_ref_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_array_ref_c6(seed)) return 0;
  if (!test_array_ref_uc6(seed)) return 0;
  if (!test_array_ref_c7(seed)) return 0;
  if (!test_array_ref_uc7(seed)) return 0;
  if (!test_array_ref_c8(seed)) return 0;
  if (!test_array_ref_uc8(seed)) return 0;
  if (!test_array_ref_c9(seed)) return 0;
  if (!test_array_ref_uc9(seed)) return 0;
  if (!test_array_ref_s16(seed)) return 0;
  if (!test_array_ref_us16(seed)) return 0;
  if (!test_array_ref_s18(seed)) return 0;
  if (!test_array_ref_us18(seed)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_array_subword_ref_all(03))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
