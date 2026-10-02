#include "insns.h"

/* runtime-comm-size-units.c - .comm / BSS storage-unit contract sentry.

   This catches the failure mode where assembler/linker reserve too few words
   for common arrays because .comm byte/storage-unit sizes are interpreted as
   words, or vice versa.  A 0100-word uSint array should occupy 0400 9-bit C
   storage units and not overlap the following common object. */

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

uSint common_a[0100];
uSint common_b[0100];
uSint common_guard;

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

int
main()
{
  int i;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 024;

  if (!check_uint((uSint)sizeof common_a, (uSint)0400, 05000))
    return (int)semantic_fail_id;
  if (!check_uint((uSint)sizeof common_a[0], (uSint)04, 05001))
    return (int)semantic_fail_id;

  common_guard = (uSint)0123456;
  for (i = 0; i < 0100; i = i + 1)
    {
      common_a[i] = (uSint)(01000 + i);
      common_b[i] = (uSint)(02000 + i);
    }

  if (!check_uint(common_a[0], (uSint)01000, 05010)) return (int)semantic_fail_id;
  if (!check_uint(common_a[077], (uSint)(01000 + 077), 05011)) return (int)semantic_fail_id;
  if (!check_uint(common_b[0], (uSint)02000, 05012)) return (int)semantic_fail_id;
  if (!check_uint(common_b[077], (uSint)(02000 + 077), 05013)) return (int)semantic_fail_id;
  if (!check_uint(common_guard, (uSint)0123456, 05014)) return (int)semantic_fail_id;

  common_a[077] = (uSint)0777777;
  if (!check_uint(common_b[0], (uSint)02000, 05020)) return (int)semantic_fail_id;
  if (!check_uint(common_guard, (uSint)0123456, 05021)) return (int)semantic_fail_id;

  common_b[077] = (uSint)0666666;
  if (!check_uint(common_a[077], (uSint)0777777, 05022)) return (int)semantic_fail_id;
  if (!check_uint(common_guard, (uSint)0123456, 05023)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
