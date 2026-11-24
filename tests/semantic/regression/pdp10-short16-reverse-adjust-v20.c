/* PDP-10 short16 reverse pointer adjustment, version 20.
 *
 * A native S=16 byte pointer and a logical S=1 bit pointer share one
 * C short16 pointer type.  Before v20, the logical-pointer branch's
 * opaque reverse-IBP loop could be speculated before the S selector
 * check.  Applying that loop to a native pointer could never reach
 * its saved target, resulting in a simulator step-limit timeout.
 *
 * Exercise the constant negative offset -9 (144 logical bits), both
 * signed and unsigned 16-bit arrays, and dynamic forward/reverse
 * adjustments.  Keep the input index volatile to prevent complete
 * constant folding.  This is C89 and requires no runtime library.
 */
#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static short16 signed_values_v20[20];
static ushort16 unsigned_values_v20[20];
static volatile int step_v20;

int
main(void)
{
  short16 *sp;
  short16 *sq;
  ushort16 *up;
  ushort16 *uq;

  semantic_fail_id = 0;
  step_v20 = 4;
  signed_values_v20[2] = (short16) -123;
  signed_values_v20[11] = (short16) -32767;
  unsigned_values_v20[2] = (ushort16) 54321;
  unsigned_values_v20[11] = (ushort16) 65535;

  sp = &signed_values_v20[5];
  sq = sp + 6;
  if (sq - &signed_values_v20[0] != 11)
    {
      semantic_fail_id = 0100;
      return (int) semantic_fail_id;
    }
  sp = sq - 9;
  if (sp - &signed_values_v20[0] != 2)
    {
      semantic_fail_id = 0101;
      return (int) semantic_fail_id;
    }
  if ((int) *sp != -123 || (int) *sq != -32767)
    {
      semantic_fail_id = 0102;
      semantic_sink = (uSint) (int) *sp;
      return (int) semantic_fail_id;
    }

  up = &unsigned_values_v20[5];
  uq = up + 6;
  up = uq - 9;
  if (up - &unsigned_values_v20[0] != 2)
    {
      semantic_fail_id = 0200;
      return (int) semantic_fail_id;
    }
  if ((unsigned int) *up != 54321U ||
      (unsigned int) *uq != 65535U)
    {
      semantic_fail_id = 0201;
      semantic_sink = (uSint) (unsigned int) *up;
      return (int) semantic_fail_id;
    }

  sp = &signed_values_v20[3];
  sq = sp + step_v20;
  sp = sq - step_v20;
  if (sp != &signed_values_v20[3])
    {
      semantic_fail_id = 0300;
      return (int) semantic_fail_id;
    }
  up = &unsigned_values_v20[3];
  uq = up + step_v20;
  up = uq - step_v20;
  if (up != &unsigned_values_v20[3])
    {
      semantic_fail_id = 0301;
      return (int) semantic_fail_id;
    }

  semantic_sink = 1;
  return 0;
}
