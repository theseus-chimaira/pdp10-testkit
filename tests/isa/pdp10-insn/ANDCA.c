#include "insns.h"

/*
 * ANDCA instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ANDCA   AC <- ~AC & E
 *   ANDCAI  AC <- ~AC & immediate
 *   ANDCAM  memory <- ~AC & memory
 *   ANDCAB  AC and memory both receive ~AC & memory
 *
 * The backend shares some RTL with ANDCM/ANDCBI cases.  This file keeps
 * the source expression centered on "~a & x", i.e. complement of the
 * accumulator-like operand, so the ANDCA forms are the main target.
 */

static Sint
andca_reg_reg(a, y)
Sint a;
Sint y;
{
  return ~a & y;
}

static Sint
andca_reg_mem(a, y)
Sint a;
Sint *y;
{
  return ~a & *y;
}

static Sint
andca_mem_reg(y, a)
Sint *y;
Sint a;
{
  return ~a & *y;
}

static Sint
andca_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return ~*a & *y;
}

static Sint
andcai_small(a)
Sint a;
{
  return ~a & 0123456;
}

static Sint
andcai_zero(a)
Sint a;
{
  return ~a & 0;
}

static Sint
andcai_one(a)
Sint a;
{
  return ~a & 1;
}

static Sint
andcai_low9(a)
Sint a;
{
  return ~a & 0777;
}

static Sint
andcai_low18(a)
Sint a;
{
  return ~a & 0777777;
}

static Sint
andca_literal(a)
Sint a;
{
  return ~a & 0123456123456;
}

static Sint
andca_literal_left(a)
Sint a;
{
  return 0123456123456 & ~a;
}

static Sint
andca_sparse(a)
Sint a;
{
  return ~a & 0525252252525;
}

static Sint
andca_left_half(a)
Sint a;
{
  return ~a & 0777777000000;
}

static Sint
andca_right_half(a)
Sint a;
{
  return ~a & 0000000777777;
}

static Sint
andca_high_ones_low_const(a)
Sint a;
{
  return ~a & 0777777012345;
}

static Sint
andca_low_ones_high_const(a)
Sint a;
{
  return ~a & 0123456777777;
}

static Sint
andca_sign_bit(a)
Sint a;
{
  return ~a & 0400000000000;
}

static Sint
andca_clear_sign_mask(a)
Sint a;
{
  return ~a & 0377777777777;
}

static void
andcam_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = ~a & *y;
}

static void
andcam_assign(a, y)
Sint a;
Sint *y;
{
  *y &= ~a;
}

static void
andcam_const(y)
Sint *y;
{
  *y = ~0123456 & *y;
}

static Sint
andcam_then_load(a, y)
Sint a;
Sint *y;
{
  *y &= ~a;
  return *y;
}

static Sint
andca_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  b &= ~a;
  c &= ~b;
  return c;
}

static uSint
uandca_reg_reg(a, y)
uSint a;
uSint y;
{
  return ~a & y;
}

static uSint
uandca_reg_mem(a, y)
uSint a;
uSint *y;
{
  return ~a & *y;
}

static uSint
uandcai_small(a)
uSint a;
{
  return ~a & 0123456;
}

static uSint
uandcai_low18(a)
uSint a;
{
  return ~a & 0777777;
}

static uSint
uandca_literal(a)
uSint a;
{
  return ~a & 0123456123456;
}

static uSint
uandca_left_half(a)
uSint a;
{
  return ~a & 0777777000000;
}

static uSint
uandca_right_half(a)
uSint a;
{
  return ~a & 0000000777777;
}

static uSint
uandca_high_ones_low_const(a)
uSint a;
{
  return ~a & 0777777012345;
}

static Sint
andca_qi_promote(a, b)
sQint a;
sQint b;
{
  return ~a & b;
}

static Sint
uandca_qi_promote(a, b)
uQint a;
uQint b;
{
  return ~a & b;
}

static Sint
andca_hi_promote(a, b)
Hint a;
Hint b;
{
  return ~a & b;
}

static Sint
uandca_hi_promote(a, b)
uHint a;
uHint b;
{
  return ~a & b;
}

static Sint
andca_qi_mask(a)
uQint a;
{
  return ~a & 0777;
}

static Sint
andca_hi_mask(a)
uHint a;
{
  return ~a & 0777777;
}

static Sint
andca_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return ~a & *y;
}

static void
andcam_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y &= ~a;
}

/*
 * Index/register-derived masks.  These exercise cases where the mask is
 * still an ordinary C expression, but can become an immediate/indexed
 * logical form after combine.
 */

static uSint
andcai_reg_form(a, b)
uSint a;
uSint b;
{
  return ~b & (a & 0777777);
}

static uSint
andcai_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b & ((a + 01234) & 0777777);
}

static uSint
andca_left_shift_form(a, b)
uSint a;
uSint b;
{
  return ~b & ((a & 0777777) << 18);
}

static uSint
andca_left_shift_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b & (((a + 01234) & 0777777) << 18);
}

BOTH (andcab_reg_mem, ~a & *b)
BOTH (andcab_mem_reg, *b & ~a)
BOTH1 (uSint, uandcab_reg_mem, ~a & *b)
