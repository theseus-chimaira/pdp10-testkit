#include "insns.h"

/* runtime-pattern-mulsi3-unsigned.c - unsigned SImode multiply pattern sentry.

   This covers the high-bit product that was deliberately removed from the
   unsigned div/mod pattern v2.  It tests register/register, constant factor,
   volatile operands, and q*b+r reconstruction above the sign bit.
 */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;
volatile uSint runtime_umuls_a;
volatile uSint runtime_umuls_b;

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

NOINLINE static uSint
umul_const_141(a)
uSint a;
{
  return a * (uSint)0141U;
}

NOINLINE static uSint
umul_volatile()
{
  return runtime_umuls_a * runtime_umuls_b;
}

NOINLINE static uSint
umul_plus(a, b, c)
uSint a;
uSint b;
uSint c;
{
  return a * b + c;
}

NOINLINE static uSint
reconstruct_qr(q, b, r)
uSint q;
uSint b;
uSint r;
{
  return q * b + r;
}

int
main()
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) 016;

  if (!check_uint(umul_rr((uSint)012345U, (uSint)0141U),
                  (uSint)01765305U, 0600)) return (int) semantic_fail_id;

  if (!check_uint(umul_rr((uSint)02507204042U, (uSint)0141U),
                  U36_SIGN + (uSint)012342U, 0601)) return (int) semantic_fail_id;

  if (!check_uint(umul_const_141((uSint)02507204042U),
                  U36_SIGN + (uSint)012342U, 0602)) return (int) semantic_fail_id;

  runtime_umuls_a = (uSint)02507204042U;
  runtime_umuls_b = (uSint)0141U;
  if (!check_uint(umul_volatile(),
                  U36_SIGN + (uSint)012342U, 0603)) return (int) semantic_fail_id;

  if (!check_uint(umul_plus((uSint)02507204042U, (uSint)0141U, (uSint)3U),
                  U36_SIGN + (uSint)012345U, 0604)) return (int) semantic_fail_id;

  /* Original high-bit q*b+r shape from the old unsigned div/mod pattern. */
  if (!check_uint(reconstruct_qr((uSint)02507204042U, (uSint)0141U, (uSint)3U),
                  U36_SIGN + (uSint)012345U, 0605)) return (int) semantic_fail_id;

  if (!check_uint(umul_rr(U36_SIGN, (uSint)1U),
                  U36_SIGN, 0606)) return (int) semantic_fail_id;
  if (!check_uint(umul_rr(U36_SIGN, (uSint)2U),
                  (uSint)0U, 0607)) return (int) semantic_fail_id;
  if (!check_uint(umul_rr(U36_MAX, (uSint)0100U),
                  (uSint)0777777777700U, 0610)) return (int) semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
