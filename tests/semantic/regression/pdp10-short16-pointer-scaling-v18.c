/* PDP-10 short16 pointer scaling and exact-width signed load, v18.
 *
 * A short16 element occupies two 9-bit C storage units but only one
 * architectural 16-bit byte-pointer position.  Check both dynamic
 * pointer increments and constant address construction; they must
 * agree even when the optimizer folds the latter into a POINT word.
 * A signed short16 load must sign-extend bit 15, not the 18-bit
 * halfword or two padding bits immediately following the field.
 * C89, with volatile inputs to prevent constant folding.
 */
#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static short16 values[20];
static volatile int displacement;

int
main(void)
{
  short16 *base;
  short16 *next;

  semantic_fail_id = 0;
  displacement = 4;
  values[0] = (short16)-32767;
  values[3] = (short16)-123;
  values[7] = (short16)32766;

  base = &values[3];
  next = base + displacement;

  if (next - base != displacement)
    {
      semantic_fail_id = 0100;
      return (int)semantic_fail_id;
    }
  if (next != &values[7])
    {
      semantic_fail_id = 0101;
      return (int)semantic_fail_id;
    }
  if ((int)*next != 32766)
    {
      semantic_fail_id = 0102;
      semantic_sink = (uSint)(int)*next;
      return (int)semantic_fail_id;
    }
  if ((int)*(&values[0]) != -32767)
    {
      semantic_fail_id = 0103;
      semantic_sink = (uSint)(int)*(&values[0]);
      return (int)semantic_fail_id;
    }
  if ((int)*base != -123)
    {
      semantic_fail_id = 0104;
      semantic_sink = (uSint)(int)*base;
      return (int)semantic_fail_id;
    }
  next = next - displacement;
  if (next != base)
    {
      semantic_fail_id = 0105;
      return (int)semantic_fail_id;
    }

  semantic_sink = 1;
  return 0;
}
