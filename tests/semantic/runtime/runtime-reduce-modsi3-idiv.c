#include "insns.h"

/* runtime-reduce-modsi3-idiv.c - signed SI modulo reducer.

   Purpose:
     Verify the signed remainder half of divsi3/modsi3.  On PDP-10 IDIV
     produces quotient and remainder in adjacent ACs; this catches wrong
     remainder-register selection and sign convention mistakes.
 */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static volatile Sint runtime_modsi3_seven = (Sint)7;
static volatile Sint runtime_modsi3_nseven = (Sint)-7;

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
mod_rr(a, b)
Sint a;
Sint b;
{
  return a % b;
}

NOINLINE static Sint
mod_const7(a)
Sint a;
{
  return a % (Sint)7;
}

NOINLINE static Sint
mod_volatile7(a)
Sint a;
{
  return a % runtime_modsi3_seven;
}

NOINLINE static Sint
mod_volatile_n7(a)
Sint a;
{
  return a % runtime_modsi3_nseven;
}

int
runtime_reduce_modsi3_idiv_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)seed;

  if (!check_sint(mod_rr((Sint)100, (Sint)7), (Sint)2, 0200)) return 0;
  if (!check_sint(mod_rr((Sint)12345, (Sint)97), (Sint)26, 0201)) return 0;
  if (!check_sint(mod_rr((Sint)-12345, (Sint)97), (Sint)-26, 0202)) return 0;
  if (!check_sint(mod_rr((Sint)12345, (Sint)-97), (Sint)26, 0203)) return 0;
  if (!check_sint(mod_rr((Sint)-12345, (Sint)-97), (Sint)-26, 0204)) return 0;

  if (!check_sint(mod_const7((Sint)100), (Sint)2, 0210)) return 0;
  if (!check_sint(mod_const7((Sint)-100), (Sint)-2, 0211)) return 0;
  if (!check_sint(mod_volatile7((Sint)100), (Sint)2, 0212)) return 0;
  if (!check_sint(mod_volatile7((Sint)-100), (Sint)-2, 0213)) return 0;
  if (!check_sint(mod_volatile_n7((Sint)100), (Sint)2, 0214)) return 0;
  if (!check_sint(mod_volatile_n7((Sint)-100), (Sint)-2, 0215)) return 0;

  if (!check_sint(mod_rr((Sint)0, (Sint)7), (Sint)0, 0220)) return 0;
  if (!check_sint(mod_rr((Sint)-1, (Sint)1), (Sint)0, 0221)) return 0;

  semantic_fail_id = 0;
  semantic_sink = (uSint)023456;
  return 1;
}

int
main()
{
  if (runtime_reduce_modsi3_idiv_all(06))
    return 0;
  if (semantic_fail_id != 0)
    return (int)semantic_fail_id;
  return 0777777;
}
