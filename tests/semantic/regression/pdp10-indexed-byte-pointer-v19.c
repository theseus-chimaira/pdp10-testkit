/* Indexed constant PDP-10 byte pointer construction, version 19.
 *
 * MOVEI can form a word address from a symbol plus an index register,
 * but cannot construct the nonzero P/S selector of a 36-bit byte
 * pointer.  Cover the register-indexed literal address path at O1,
 * O2 and Os, including a byte pointer built with the index in the
 * same AC as the destination.  Keep a volatile index so the compiler
 * cannot replace the operation with a folded constant POINT word.
 *
 * C89, native 6/9-bit scalar widths.  The expectations are element
 * counts, not raw PDP-10 word-address differences.
 */
#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static char9 array9[20];
static int6 array6[20];
static volatile int delta_v19;

int
main(void)
{
  char9 *p9;
  char9 *q9;
  int6 *p6;
  int6 *q6;

  semantic_fail_id = 0;
  delta_v19 = 4;
  array9[7] = (char9) -13;
  array6[7] = (int6) -7;

  p9 = &array9[3];
  q9 = p9 + delta_v19;
  if (q9 != &array9[7])
    {
      semantic_fail_id = 0100;
      return (int) semantic_fail_id;
    }
  if ((int) (q9 - p9) != delta_v19)
    {
      semantic_fail_id = 0101;
      return (int) semantic_fail_id;
    }
  if ((int) *q9 != -13)
    {
      semantic_fail_id = 0102;
      semantic_sink = (uSint) (int) *q9;
      return (int) semantic_fail_id;
    }

  p6 = &array6[3];
  q6 = p6 + delta_v19;
  if (q6 != &array6[7])
    {
      semantic_fail_id = 0200;
      return (int) semantic_fail_id;
    }
  if ((int) (q6 - p6) != delta_v19)
    {
      semantic_fail_id = 0201;
      return (int) semantic_fail_id;
    }
  if ((int) *q6 != -7)
    {
      semantic_fail_id = 0202;
      semantic_sink = (uSint) (int) *q6;
      return (int) semantic_fail_id;
    }

  semantic_sink = 1;
  return 0;
}
