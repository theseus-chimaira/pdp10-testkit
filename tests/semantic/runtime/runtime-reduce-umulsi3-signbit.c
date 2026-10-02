#include "insns.h"

/* runtime-reduce-umulsi3-signbit.c - unsigned SImode multiply reducer.

   This is split out from runtime-pattern-divmod-si-unsigned.c v1, where a
   q*b+r identity accidentally dragged unsigned multiplication above the sign
   bit into the unsigned div/mod test.

   Scope:
     PDP-6 / KA10 baseline.  Unsigned SImode multiplication must produce the
     low 36 bits of the product, even when the product crosses the sign bit or
     wraps modulo 2^36.
 */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

#define U36_MAX  ((uSint)0777777777777U)
#define U36_SIGN ((uSint)0400000000000U)

static int
check_uint(got, exp, id)
uSint got;
uSint exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint) id;
      semantic_sink = got;
      return 0;
    }
  return 1;
}

NOINLINE static uSint
umul_rr(a, b)
uSint a;
uSint b;
{
  return a * b;
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) 015;

  /* Ordinary positive product below the sign bit. */
  if (!check_uint(umul_rr((uSint)012345U, (uSint)0141U),
                  (uSint)01765305U, 0500))
    return (int) semantic_fail_id;

  /* The exact product that made the old div/mod identity test fail:
     02507204042 * 0141 == 0400000012342. */
  if (!check_uint(umul_rr((uSint)02507204042U, (uSint)0141U),
                  U36_SIGN + (uSint)012342U, 0501))
    return (int) semantic_fail_id;

  /* Sign bit times one must preserve the sign bit as an unsigned bit. */
  if (!check_uint(umul_rr(U36_SIGN, (uSint)1U),
                  U36_SIGN, 0502))
    return (int) semantic_fail_id;

  /* Sign bit times two wraps to zero modulo 2^36. */
  if (!check_uint(umul_rr(U36_SIGN, (uSint)2U),
                  (uSint)0U, 0503))
    return (int) semantic_fail_id;

  /* (sign bit + 1) * 2 wraps, leaving the low two bits. */
  if (!check_uint(umul_rr(U36_SIGN + (uSint)1U, (uSint)2U),
                  (uSint)2U, 0504))
    return (int) semantic_fail_id;

  /* -1 unsigned times 0100 is 2^36 - 0100. */
  if (!check_uint(umul_rr(U36_MAX, (uSint)0100U),
                  (uSint)0777777777700U, 0505))
    return (int) semantic_fail_id;

  /* Max signed-positive value times two becomes all ones except bit 0. */
  if (!check_uint(umul_rr(U36_SIGN - (uSint)1U, (uSint)2U),
                  U36_MAX - (uSint)1U, 0506))
    return (int) semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
