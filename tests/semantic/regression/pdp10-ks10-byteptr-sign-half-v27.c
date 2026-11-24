#include "insns.h"

/* pdp10-ks10-byteptr-sign-half-v27.c - KS10 byte-pointer load regression.

   Before v27, GCC KS10 O1 loaded a signed 9-bit q byte with a whole
   word MOVE/ASH (octal 0245), and KS10 O2/Os selected the wrong
   18-bit half or lost sign extension (octal 0343/0344).  Preserve
   the exact original char9/short18 pointer arithmetic and scalar
   assertions.  No runtime helpers or system headers are required.
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

/* These two cases retain the original signed scalar expectations and
   pointer offsets, with no change to the original failure oracles. */
DECL_PTR_DIFF_TEST(c9, char9, -255, -255, 254, 254, -13, -13, 0240)
DECL_PTR_DIFF_TEST(s18, short18, -012345, -012345, 012345, 012345,
                   -07654, -07654, 0340)

int
runtime_byteptr_v27_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;
  if (!test_ptr_diff_c9(seed)) return 0;
  if (!test_ptr_diff_s18(seed)) return 0;
  semantic_fail_id = 0;
  return 1;
}

int
main(void)
{
  if (runtime_byteptr_v27_all(4)) return 0;
  if (semantic_fail_id != 0) return (int) semantic_fail_id;
  return 0777777;
}
