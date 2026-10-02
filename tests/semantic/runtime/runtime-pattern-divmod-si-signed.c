#include "insns.h"

/* runtime-pattern-divmod-si-signed.c - combined signed SI div/mod sentry.

   Purpose:
     Exercise functions that compute both quotient and remainder from the
     same operands, because PDP-10 IDIV naturally returns both.  This test
     stays signed-only; unsigned SI division/modulo remains separate because
     PDP-6/KA10 should not accidentally grow an XKL-only dependency.
 */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static int
check_sint(got, exp, id)
Sint got;
Sint exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint)id;
      semantic_sink = (uSint)got;
      return 0;
    }
  return 1;
}

NOINLINE static Sint
divmod_identity(a, b)
Sint a;
Sint b;
{
  Sint q;
  Sint r;

  q = a / b;
  r = a % b;
  return q * b + r;
}

NOINLINE static Sint
divmod_return_r_sink_q(a, b)
Sint a;
Sint b;
{
  Sint q;
  Sint r;

  q = a / b;
  r = a % b;
  semantic_sink = (uSint)q;
  return r;
}

NOINLINE static Sint
divmod_return_q_sink_r(a, b)
Sint a;
Sint b;
{
  Sint q;
  Sint r;

  q = a / b;
  r = a % b;
  semantic_sink = (uSint)r;
  return q;
}

int
runtime_pattern_divmod_si_signed_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)seed;

  if (!check_sint(divmod_identity((Sint)12345, (Sint)97), (Sint)12345, 0300)) return 0;
  if (!check_sint(divmod_identity((Sint)-12345, (Sint)97), (Sint)-12345, 0301)) return 0;
  if (!check_sint(divmod_identity((Sint)12345, (Sint)-97), (Sint)12345, 0302)) return 0;
  if (!check_sint(divmod_identity((Sint)-12345, (Sint)-97), (Sint)-12345, 0303)) return 0;

  if (!check_sint(divmod_return_r_sink_q((Sint)12345, (Sint)97), (Sint)26, 0310)) return 0;
  if (!check_sint((Sint)semantic_sink, (Sint)127, 0311)) return 0;
  if (!check_sint(divmod_return_r_sink_q((Sint)-12345, (Sint)97), (Sint)-26, 0312)) return 0;
  if (!check_sint((Sint)semantic_sink, (Sint)-127, 0313)) return 0;

  if (!check_sint(divmod_return_q_sink_r((Sint)12345, (Sint)97), (Sint)127, 0320)) return 0;
  if (!check_sint((Sint)semantic_sink, (Sint)26, 0321)) return 0;
  if (!check_sint(divmod_return_q_sink_r((Sint)-12345, (Sint)97), (Sint)-127, 0322)) return 0;
  if (!check_sint((Sint)semantic_sink, (Sint)-26, 0323)) return 0;

  semantic_fail_id = 0;
  semantic_sink = (uSint)034567;
  return 1;
}

int
main()
{
  if (runtime_pattern_divmod_si_signed_all(07))
    return 0;
  if (semantic_fail_id != 0)
    return (int)semantic_fail_id;
  return 0777777;
}
