#include "insns.h"

/* runtime-reduce-divsi3-idiv.c - signed SI division reducer.

   Purpose:
     First divsi3 semantic sentry after the compare/range-check cluster.
     This intentionally tests signed int/SImode division only.  Unsigned
     division is a separate libgcc/XKL-policy question for PDP-6/KA10.

   Expected GCC/PDP-10 behavior follows GCC's truncation-toward-zero signed
   division semantics.  Avoid INT_MIN / -1 because that is overflow territory.
 */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static volatile Sint runtime_divsi3_seven = (Sint)7;
static volatile Sint runtime_divsi3_nseven = (Sint)-7;

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
div_rr(a, b)
Sint a;
Sint b;
{
  return a / b;
}

NOINLINE static Sint
div_const7(a)
Sint a;
{
  return a / (Sint)7;
}

NOINLINE static Sint
div_volatile7(a)
Sint a;
{
  return a / runtime_divsi3_seven;
}

NOINLINE static Sint
div_volatile_n7(a)
Sint a;
{
  return a / runtime_divsi3_nseven;
}

int
runtime_reduce_divsi3_idiv_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)seed;

  if (!check_sint(div_rr((Sint)100, (Sint)7), (Sint)14, 0100)) return 0;
  if (!check_sint(div_rr((Sint)12345, (Sint)97), (Sint)127, 0101)) return 0;
  if (!check_sint(div_rr((Sint)-12345, (Sint)97), (Sint)-127, 0102)) return 0;
  if (!check_sint(div_rr((Sint)12345, (Sint)-97), (Sint)-127, 0103)) return 0;
  if (!check_sint(div_rr((Sint)-12345, (Sint)-97), (Sint)127, 0104)) return 0;

  if (!check_sint(div_const7((Sint)100), (Sint)14, 0110)) return 0;
  if (!check_sint(div_const7((Sint)-100), (Sint)-14, 0111)) return 0;
  if (!check_sint(div_volatile7((Sint)100), (Sint)14, 0112)) return 0;
  if (!check_sint(div_volatile7((Sint)-100), (Sint)-14, 0113)) return 0;
  if (!check_sint(div_volatile_n7((Sint)100), (Sint)-14, 0114)) return 0;
  if (!check_sint(div_volatile_n7((Sint)-100), (Sint)14, 0115)) return 0;

  if (!check_sint(div_rr((Sint)0, (Sint)7), (Sint)0, 0120)) return 0;
  if (!check_sint(div_rr((Sint)-1, (Sint)1), (Sint)-1, 0121)) return 0;

  semantic_fail_id = 0;
  semantic_sink = (uSint)012345;
  return 1;
}

int
main()
{
  if (runtime_reduce_divsi3_idiv_all(05))
    return 0;
  if (semantic_fail_id != 0)
    return (int)semantic_fail_id;
  return 0777777;
}
