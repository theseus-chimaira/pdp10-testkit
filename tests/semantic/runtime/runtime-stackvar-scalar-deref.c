#include "insns.h"

/* runtime-stackvar-scalar-deref.c - focused stack scalar deref sentry.

   Slow semantic test for PDP-10 stack-local scalar addresses.  It is meant
   to be queued through the semantic matrix, not swept into the fast compile
   reference pass.  The test checks direct *&local, pointer-slot reloads,
   volatile pointer slots, stores through stack scalar addresses, and small
   stack arrays for byte/halfword-sized PDP-10 scalar types.
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

#define DECL_STACK_SCALAR_TEST(TAG, TYPE, V1, E1, V2, E2, V3, E3, BASE) \
static volatile TYPE sink_ ## TAG;                                      \
NOINLINE static int                                                     \
test_stack_scalar_ ## TAG(seed)                                         \
int seed;                                                               \
{                                                                       \
  TYPE a;                                                               \
  TYPE b[4];                                                            \
  TYPE *p;                                                              \
  TYPE * volatile pv;                                                   \
                                                                        \
  a = (TYPE)(V1);                                                       \
  sink_ ## TAG = *&a;                                                   \
  if (!check_int((int)sink_ ## TAG, (E1), (BASE) + 0)) return 0;         \
                                                                        \
  p = &a;                                                               \
  if (!check_int((int)*p, (E1), (BASE) + 1)) return 0;                  \
                                                                        \
  *p = (TYPE)(V2);                                                      \
  if (!check_int((int)a, (E2), (BASE) + 2)) return 0;                   \
  if (!check_int((int)*p, (E2), (BASE) + 3)) return 0;                  \
                                                                        \
  pv = &a;                                                              \
  *pv = (TYPE)(V3);                                                     \
  if (!check_int((int)a, (E3), (BASE) + 4)) return 0;                   \
  if (!check_int((int)*p, (E3), (BASE) + 5)) return 0;                  \
                                                                        \
  b[0] = (TYPE)(V1);                                                    \
  b[1] = (TYPE)(V2);                                                    \
  b[2] = (TYPE)(V3);                                                    \
  b[3] = (TYPE)(seed);                                                  \
  p = &b[1];                                                            \
  if (!check_int((int)*p, (E2), (BASE) + 6)) return 0;                  \
  p = p + 1;                                                            \
  if (!check_int((int)*p, (E3), (BASE) + 7)) return 0;                  \
  *p = (TYPE)(V1);                                                      \
  if (!check_int((int)b[2], (E1), (BASE) + 8)) return 0;                \
  if (!check_int((int)(p - &b[0]), 2, (BASE) + 9)) return 0;            \
                                                                        \
  semantic_sink = semantic_sink + (uSint)(int)a + (uSint)(int)b[2];      \
  return 1;                                                             \
}

DECL_STACK_SCALAR_TEST(c6,    char6,    -31,      -31,      30,       30,      -7,       -7,      0100)
DECL_STACK_SCALAR_TEST(uc6,   uchar6,   63,       63,       17,       17,      42,       42,      0120)
DECL_STACK_SCALAR_TEST(c7,    char7,    -63,      -63,      62,       62,      -9,       -9,      0140)
DECL_STACK_SCALAR_TEST(uc7,   uchar7,   127,      127,      33,       33,      77,       77,      0160)
DECL_STACK_SCALAR_TEST(c8,    char8,    -127,     -127,     126,      126,     -11,      -11,     0200)
DECL_STACK_SCALAR_TEST(uc8,   uchar8,   255,      255,      44,       44,      155,      155,     0220)
DECL_STACK_SCALAR_TEST(c9,    char9,    -255,     -255,     254,      254,     -13,      -13,     0240)
DECL_STACK_SCALAR_TEST(uc9,   uchar9,   511,      511,      0123,     0123,    0456,     0456,    0260)
DECL_STACK_SCALAR_TEST(s16,   short16,  -32767,   -32767,   32766,    32766,   -123,     -123,    0300)
DECL_STACK_SCALAR_TEST(us16,  ushort16, 65535,    65535,    12345,    12345,   54321,    54321,   0320)
DECL_STACK_SCALAR_TEST(s18,   short18,  -012345,  -012345,  012345,   012345,  -07654,   -07654,  0340)
DECL_STACK_SCALAR_TEST(us18,  ushort18, 0377777,  0377777,  0123456,  0123456, 034567,   034567,  0360)
DECL_STACK_SCALAR_TEST(qi,    Qint,     -255,     -255,     254,      254,     -15,      -15,     0400)
DECL_STACK_SCALAR_TEST(uqi,   uQint,    511,      511,      0123,     0123,    0456,     0456,    0420)
DECL_STACK_SCALAR_TEST(hi,    Hint,     -012345,  -012345,  012345,   012345,  -07654,   -07654,  0440)
DECL_STACK_SCALAR_TEST(uhi,   uHint,    0377777,  0377777,  0123456,  0123456, 034567,   034567,  0460)
DECL_STACK_SCALAR_TEST(si,    Sint,     -123456,  -123456,  123456,   123456,  -07654,   -07654,  0500)
DECL_STACK_SCALAR_TEST(usi,   uSint,    0123456,  0123456,  0234567,  0234567, 034567,   034567,  0520)

int
runtime_stackvar_scalar_deref_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_stack_scalar_c6(seed)) return 0;
  if (!test_stack_scalar_uc6(seed)) return 0;
  if (!test_stack_scalar_c7(seed)) return 0;
  if (!test_stack_scalar_uc7(seed)) return 0;
  if (!test_stack_scalar_c8(seed)) return 0;
  if (!test_stack_scalar_uc8(seed)) return 0;
  if (!test_stack_scalar_c9(seed)) return 0;
  if (!test_stack_scalar_uc9(seed)) return 0;
  if (!test_stack_scalar_s16(seed)) return 0;
  if (!test_stack_scalar_us16(seed)) return 0;
  if (!test_stack_scalar_s18(seed)) return 0;
  if (!test_stack_scalar_us18(seed)) return 0;
  if (!test_stack_scalar_qi(seed)) return 0;
  if (!test_stack_scalar_uqi(seed)) return 0;
  if (!test_stack_scalar_hi(seed)) return 0;
  if (!test_stack_scalar_uhi(seed)) return 0;
  if (!test_stack_scalar_si(seed)) return 0;
  if (!test_stack_scalar_usi(seed)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_stackvar_scalar_deref_all(0123))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
