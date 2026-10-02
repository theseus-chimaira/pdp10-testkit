#include "insns.h"

/*
 * ANDCB instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ANDCB   AC <- ~AC & ~E
 *   ANDCBI  AC <- ~AC & ~immediate
 *   ANDCBM  memory <- ~AC & ~memory
 *   ANDCBB  AC and memory both receive ~AC & ~memory
 *
 * Keep the core expression as "~a & ~x" so this test stays centered on
 * complement-both AND lowering, rather than drifting into ANDCA/ANDCM.
 */

static Sint
andcb_reg_reg(a, y)
Sint a;
Sint y;
{
  return ~a & ~y;
}

static Sint
andcb_reg_mem(a, y)
Sint a;
Sint *y;
{
  return ~a & ~*y;
}

static Sint
andcb_mem_reg(y, a)
Sint *y;
Sint a;
{
  return ~a & ~*y;
}

static Sint
andcb_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return ~*a & ~*y;
}

static Sint
andcbi_small(a)
Sint a;
{
  return ~a & ~0123456;
}

static Sint
andcbi_zero(a)
Sint a;
{
  return ~a & ~0;
}

static Sint
andcbi_one(a)
Sint a;
{
  return ~a & ~1;
}

static Sint
andcbi_low9(a)
Sint a;
{
  return ~a & ~0777;
}

static Sint
andcbi_low18(a)
Sint a;
{
  return ~a & ~0777777;
}

static Sint
andcb_literal(a)
Sint a;
{
  return ~a & ~0123456123456;
}

static Sint
andcb_literal_left(a)
Sint a;
{
  return ~0123456123456 & ~a;
}

static Sint
andcb_sparse(a)
Sint a;
{
  return ~a & ~0525252252525;
}

static Sint
andcb_left_half(a)
Sint a;
{
  return ~a & ~0777777000000;
}

static Sint
andcb_right_half(a)
Sint a;
{
  return ~a & ~0000000777777;
}

static Sint
andcb_high_ones_low_const(a)
Sint a;
{
  return ~a & ~0777777012345;
}

static Sint
andcb_low_ones_high_const(a)
Sint a;
{
  return ~a & ~0123456777777;
}

static Sint
andcb_sign_bit(a)
Sint a;
{
  return ~a & ~0400000000000;
}

static Sint
andcb_clear_sign_mask(a)
Sint a;
{
  return ~a & ~0377777777777;
}

static void
andcbm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = ~a & ~*y;
}

static void
andcbm_assign(a, y)
Sint a;
Sint *y;
{
  *y = ~a & ~*y;
}

static void
andcbm_const(y)
Sint *y;
{
  *y = ~0123456 & ~*y;
}

static Sint
andcbm_then_load(a, y)
Sint a;
Sint *y;
{
  *y = ~a & ~*y;
  return *y;
}

static Sint
andcb_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  b = ~a & ~b;
  c = ~b & ~c;
  return c;
}

static uSint
uandcb_reg_reg(a, y)
uSint a;
uSint y;
{
  return ~a & ~y;
}

static uSint
uandcb_reg_mem(a, y)
uSint a;
uSint *y;
{
  return ~a & ~*y;
}

static uSint
uandcbi_small(a)
uSint a;
{
  return ~a & ~0123456;
}

static uSint
uandcbi_low18(a)
uSint a;
{
  return ~a & ~0777777;
}

static uSint
uandcb_literal(a)
uSint a;
{
  return ~a & ~0123456123456;
}

static uSint
uandcb_left_half(a)
uSint a;
{
  return ~a & ~0777777000000;
}

static uSint
uandcb_right_half(a)
uSint a;
{
  return ~a & ~0000000777777;
}

static uSint
uandcb_high_ones_low_const(a)
uSint a;
{
  return ~a & ~0777777012345;
}

static Sint
andcb_qi_promote(a, b)
sQint a;
sQint b;
{
  return ~a & ~b;
}

static Sint
uandcb_qi_promote(a, b)
uQint a;
uQint b;
{
  return ~a & ~b;
}

static Sint
andcb_hi_promote(a, b)
Hint a;
Hint b;
{
  return ~a & ~b;
}

static Sint
uandcb_hi_promote(a, b)
uHint a;
uHint b;
{
  return ~a & ~b;
}

static Sint
andcb_qi_mask(a)
uQint a;
{
  return ~a & ~0777;
}

static Sint
andcb_hi_mask(a)
uHint a;
{
  return ~a & ~0777777;
}

static Sint
andcb_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return ~a & ~*y;
}

static void
andcbm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y = ~a & ~*y;
}

/*
 * Register-derived masks.  These exercise cases where combine may
 * still form logical immediate/indexed variants from C complement
 * expressions.
 */

static uSint
andcbi_reg_form(a, b)
uSint a;
uSint b;
{
  return ~b & ~(a & 0777777);
}

static uSint
andcbi_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b & ~((a + 01234) & 0777777);
}

static uSint
andcb_left_shift_form(a, b)
uSint a;
uSint b;
{
  return ~b & ~((a & 0777777) << 18);
}

static uSint
andcb_left_shift_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b & ~(((a + 01234) & 0777777) << 18);
}

BOTH (andcbb_reg_mem, ~a & ~*b)
BOTH (andcbb_mem_reg, ~*b & ~a)
BOTH1 (uSint, uandcbb_reg_mem, ~a & ~*b)
