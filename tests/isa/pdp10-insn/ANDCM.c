#include "insns.h"

/*
 * ANDCM instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ANDCM   AC <- AC & ~E
 *   ANDCMI  AC <- AC & ~immediate
 *   ANDCMM  memory <- memory & ~AC, or selected memory form
 *   ANDCMB  AC and memory both receive AC & ~memory
 *
 * The core source expression is "a & ~x".  This is the complement of
 * the effective operand, not the accumulator-like operand, so it is the
 * ANDCM counterpart to ANDCA.
 */

static Sint
andcm_reg_reg(a, y)
Sint a;
Sint y;
{
  return a & ~y;
}

static Sint
andcm_reg_mem(a, y)
Sint a;
Sint *y;
{
  return a & ~*y;
}

static Sint
andcm_mem_reg(y, a)
Sint *y;
Sint a;
{
  return *y & ~a;
}

static Sint
andcm_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return *a & ~*y;
}

static Sint
andcmi_small(a)
Sint a;
{
  return a & ~0123456;
}

static Sint
andcmi_zero(a)
Sint a;
{
  return a & ~0;
}

static Sint
andcmi_one(a)
Sint a;
{
  return a & ~1;
}

static Sint
andcmi_low9(a)
Sint a;
{
  return a & ~0777;
}

static Sint
andcmi_low18(a)
Sint a;
{
  return a & ~0777777;
}

static Sint
andcm_literal(a)
Sint a;
{
  return a & ~0123456123456;
}

static Sint
andcm_literal_left(a)
Sint a;
{
  return ~0123456123456 & a;
}

static Sint
andcm_sparse(a)
Sint a;
{
  return a & ~0525252252525;
}

static Sint
andcm_left_half(a)
Sint a;
{
  return a & ~0777777000000;
}

static Sint
andcm_right_half(a)
Sint a;
{
  return a & ~0000000777777;
}

static Sint
andcm_high_ones_low_const(a)
Sint a;
{
  return a & ~0777777012345;
}

static Sint
andcm_low_ones_high_const(a)
Sint a;
{
  return a & ~0123456777777;
}

static Sint
andcm_sign_bit(a)
Sint a;
{
  return a & ~0400000000000;
}

static Sint
andcm_clear_sign_mask(a)
Sint a;
{
  return a & ~0377777777777;
}

static void
andcmm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = *y & ~a;
}

static void
andcmm_assign(a, y)
Sint a;
Sint *y;
{
  *y &= ~a;
}

static void
andcmm_const(y)
Sint *y;
{
  *y &= ~0123456;
}

static Sint
andcmm_then_load(a, y)
Sint a;
Sint *y;
{
  *y &= ~a;
  return *y;
}

static Sint
andcm_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  a &= ~b;
  a &= ~c;
  return a;
}

static uSint
uandcm_reg_reg(a, y)
uSint a;
uSint y;
{
  return a & ~y;
}

static uSint
uandcm_reg_mem(a, y)
uSint a;
uSint *y;
{
  return a & ~*y;
}

static uSint
uandcmi_small(a)
uSint a;
{
  return a & ~0123456;
}

static uSint
uandcmi_low18(a)
uSint a;
{
  return a & ~0777777;
}

static uSint
uandcm_literal(a)
uSint a;
{
  return a & ~0123456123456;
}

static uSint
uandcm_left_half(a)
uSint a;
{
  return a & ~0777777000000;
}

static uSint
uandcm_right_half(a)
uSint a;
{
  return a & ~0000000777777;
}

static uSint
uandcm_high_ones_low_const(a)
uSint a;
{
  return a & ~0777777012345;
}

static Sint
andcm_qi_promote(a, b)
sQint a;
sQint b;
{
  return a & ~b;
}

static Sint
uandcm_qi_promote(a, b)
uQint a;
uQint b;
{
  return a & ~b;
}

static Sint
andcm_hi_promote(a, b)
Hint a;
Hint b;
{
  return a & ~b;
}

static Sint
uandcm_hi_promote(a, b)
uHint a;
uHint b;
{
  return a & ~b;
}

static Sint
andcm_qi_mask(a)
uQint a;
{
  return a & ~0777;
}

static Sint
andcm_hi_mask(a)
uHint a;
{
  return a & ~0777777;
}

static Sint
andcm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return a & ~*y;
}

static void
andcmm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y &= ~a;
}

/*
 * Register-derived masks.  These are useful for combine/reload cases
 * around ANDCMI-like forms and shifted left-half masks.
 */

static uSint
andcmi_reg_form(a, b)
uSint a;
uSint b;
{
  return b & ~(a & 0777777);
}

static uSint
andcmi_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return b & ~((a + 01234) & 0777777);
}

static uSint
andcm_left_shift_form(a, b)
uSint a;
uSint b;
{
  return b & ~((a & 0777777) << 18);
}

static uSint
andcm_left_shift_plus_form(a, b)
uSint a;
uSint b;
{
  return b & ~(((a + 01234) & 0777777) << 18);
}

BOTH (andcmb_reg_mem, a & ~*b)
BOTH (andcmb_mem_reg, ~*b & a)
BOTH1 (uSint, uandcmb_reg_mem, a & ~*b)
