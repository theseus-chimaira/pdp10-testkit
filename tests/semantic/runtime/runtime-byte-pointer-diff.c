#include "insns.h"

/* runtime-byte-pointer-diff.c - focused byte pointer arithmetic sentry.

   Slow semantic test for local PDP-10 byte pointers.  It checks pointer
   differences, increment/decrement across word boundaries, and loads/stores
   through byte/halfword pointers for 6/7/8/9/18-bit scalar types.
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

#define DECL_PTR_DIFF_TEST(TAG, TYPE, V0, E0, V1, E1, V2, E2, BASE)      \
static TYPE arr_ ## TAG[20];                                             \
NOINLINE static int                                                       \
test_ptr_diff_ ## TAG(seed)                                               \
int seed;                                                                 \
{                                                                         \
  TYPE *base;                                                             \
  TYPE *p;                                                                \
  TYPE *q;                                                                \
  int i;                                                                  \
                                                                          \
  for (i = 0; i < 20; i = i + 1)                                           \
    arr_ ## TAG[i] = (TYPE) (i + 1);                                      \
                                                                          \
  arr_ ## TAG[0] = (TYPE)(V0);                                            \
  arr_ ## TAG[5] = (TYPE)(V1);                                            \
  arr_ ## TAG[11] = (TYPE)(V2);                                           \
                                                                          \
  base = &arr_ ## TAG[0];                                                 \
  p = base + 5;                                                           \
  q = p + 6;                                                              \
                                                                          \
  if (!check_int((int)(p - base), 5, (BASE) + 0)) return 0;               \
  if (!check_int((int)(q - p), 6, (BASE) + 1)) return 0;                  \
  if (!check_int((int)(q - base), 11, (BASE) + 2)) return 0;              \
  if (!check_int((int)*base, (E0), (BASE) + 3)) return 0;                 \
  if (!check_int((int)*p, (E1), (BASE) + 4)) return 0;                    \
  if (!check_int((int)*q, (E2), (BASE) + 5)) return 0;                    \
                                                                          \
  p = q - 9;                                                              \
  if (!check_int((int)(p - base), 2, (BASE) + 6)) return 0;               \
  *p = (TYPE)(V2);                                                        \
  if (!check_int((int)arr_ ## TAG[2], (E2), (BASE) + 7)) return 0;        \
                                                                          \
  p = &arr_ ## TAG[3];                                                    \
  p = p + seed;                                                           \
  if (!check_int((int)(p - &arr_ ## TAG[3]), seed, (BASE) + 8)) return 0; \
  p = p - seed;                                                           \
  if (!check_int((int)(p - &arr_ ## TAG[0]), 3, (BASE) + 9)) return 0;    \
                                                                          \
  semantic_sink = semantic_sink + (uSint)(int)arr_ ## TAG[2];             \
  return 1;                                                               \
}

DECL_PTR_DIFF_TEST(c6,    char6,    -31,     -31,     30,      30,      -7,      -7,      0100)
DECL_PTR_DIFF_TEST(uc6,   uchar6,   63,      63,      17,      17,      42,      42,      0120)
DECL_PTR_DIFF_TEST(c7,    char7,    -63,     -63,     62,      62,      -9,      -9,      0140)
DECL_PTR_DIFF_TEST(uc7,   uchar7,   127,     127,     33,      33,      77,      77,      0160)
DECL_PTR_DIFF_TEST(c8,    char8,    -127,    -127,    126,     126,     -11,     -11,     0200)
DECL_PTR_DIFF_TEST(uc8,   uchar8,   255,     255,     44,      44,      155,     155,     0220)
DECL_PTR_DIFF_TEST(c9,    char9,    -255,    -255,    254,     254,     -13,     -13,     0240)
DECL_PTR_DIFF_TEST(uc9,   uchar9,   511,     511,     0123,    0123,    0456,    0456,    0260)
DECL_PTR_DIFF_TEST(s16,   short16,  -32767,  -32767,  32766,   32766,   -123,    -123,    0300)
DECL_PTR_DIFF_TEST(us16,  ushort16, 65535,   65535,   12345,   12345,   54321,   54321,   0320)
DECL_PTR_DIFF_TEST(s18,   short18,  -012345, -012345, 012345,  012345,  -07654,  -07654,  0340)
DECL_PTR_DIFF_TEST(us18,  ushort18, 0377777, 0377777, 0123456, 0123456, 034567,  034567,  0360)
DECL_PTR_DIFF_TEST(qi,    Qint,     -255,    -255,    254,     254,     -15,     -15,     0400)
DECL_PTR_DIFF_TEST(uqi,   uQint,    511,     511,     0123,    0123,    0456,    0456,    0420)
DECL_PTR_DIFF_TEST(hi,    Hint,     -012345, -012345, 012345,  012345,  -07654,  -07654,  0440)
DECL_PTR_DIFF_TEST(uhi,   uHint,    0377777, 0377777, 0123456, 0123456, 034567,  034567,  0460)
DECL_PTR_DIFF_TEST(si,    Sint,     -123456, -123456, 123456,  123456,  -07654,  -07654,  0500)
DECL_PTR_DIFF_TEST(usi,   uSint,    0123456, 0123456, 0234567, 0234567, 034567,  034567,  0520)

int
runtime_byte_pointer_diff_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_ptr_diff_c6(seed)) return 0;
  if (!test_ptr_diff_uc6(seed)) return 0;
  if (!test_ptr_diff_c7(seed)) return 0;
  if (!test_ptr_diff_uc7(seed)) return 0;
  if (!test_ptr_diff_c8(seed)) return 0;
  if (!test_ptr_diff_uc8(seed)) return 0;
  if (!test_ptr_diff_c9(seed)) return 0;
  if (!test_ptr_diff_uc9(seed)) return 0;
  if (!test_ptr_diff_s16(seed)) return 0;
  if (!test_ptr_diff_us16(seed)) return 0;
  if (!test_ptr_diff_s18(seed)) return 0;
  if (!test_ptr_diff_us18(seed)) return 0;
  if (!test_ptr_diff_qi(seed)) return 0;
  if (!test_ptr_diff_uqi(seed)) return 0;
  if (!test_ptr_diff_hi(seed)) return 0;
  if (!test_ptr_diff_uhi(seed)) return 0;
  if (!test_ptr_diff_si(seed)) return 0;
  if (!test_ptr_diff_usi(seed)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_byte_pointer_diff_all(4))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
