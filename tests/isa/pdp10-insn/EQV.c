#include "insns.h"

/*
 * EQV instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   EQV   AC <- ~(AC ^ E)
 *   EQVI  AC <- ~(AC ^ immediate), often written as AC ^ ~constant
 *   EQVM  memory <- ~(AC ^ memory)
 *   EQVB  AC and memory both receive ~(AC ^ memory)
 *
 * C has no direct EQV operator, so the stable source spellings are:
 *
 *   ~(a ^ x)
 *   a ^ ~constant
 *
 * Both forms are used below.
 */
struct eqv_struct {
  Sint a;
  Sint b;
  Sint c;
} *p;

static Sint
eqv_reg_reg(a, y)
Sint a;
Sint y;
{
  return ~(a ^ y);
}

static Sint
eqv_reg_mem(a, y)
Sint a;
Sint *y;
{
  return ~(a ^ *y);
}

static Sint
eqv_mem_reg(y, a)
Sint *y;
Sint a;
{
  return ~(*y ^ a);
}

static Sint
eqv_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return ~(*a ^ *y);
}

static Sint
eqvi_small(a)
Sint a;
{
  return a ^ ~0123456;
}

static Sint
eqvi_zero(a)
Sint a;
{
  return a ^ ~0;
}

static Sint
eqvi_one(a)
Sint a;
{
  return a ^ ~1;
}

static Sint
eqvi_low9(a)
Sint a;
{
  return a ^ ~0777;
}

static Sint
eqvi_low18(a)
Sint a;
{
  return a ^ ~0777777;
}

static Sint
eqv_const_small(a)
Sint a;
{
  return ~(a ^ 0123456);
}

static Sint
eqv_const_zero(a)
Sint a;
{
  return ~(a ^ 0);
}

static Sint
eqv_const_one(a)
Sint a;
{
  return ~(a ^ 1);
}

static Sint
eqv_const_low18(a)
Sint a;
{
  return ~(a ^ 0777777);
}

static Sint
eqv_literal(a)
Sint a;
{
  return ~(a ^ 0123456123456);
}

static Sint
eqv_literal_left(a)
Sint a;
{
  return ~(0123456123456 ^ a);
}

static Sint
eqvi_literal(a)
Sint a;
{
  return a ^ ~0123456123456;
}

static Sint
eqv_sparse(a)
Sint a;
{
  return ~(a ^ 0525252252525);
}

static Sint
eqvi_sparse(a)
Sint a;
{
  return a ^ ~0525252252525;
}

static Sint
eqv_left_half(a)
Sint a;
{
  return ~(a ^ 0777777000000);
}

static Sint
eqv_right_half(a)
Sint a;
{
  return ~(a ^ 0000000777777);
}

static Sint
eqv_sign_bit(a)
Sint a;
{
  return ~(a ^ 0400000000000);
}

static Sint
eqv_clear_sign_mask(a)
Sint a;
{
  return ~(a ^ 0377777777777);
}

static Sint
eqv_high_ones_low_const(a)
Sint a;
{
  return ~(a ^ 0777777012345);
}

static Sint
eqv_low_ones_high_const(a)
Sint a;
{
  return ~(a ^ 0123456777777);
}

static void
eqvm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = ~(a ^ *y);
}

static void
eqvm_mem_reg(a, y)
Sint a;
Sint *y;
{
  *y = ~(*y ^ a);
}

static void
eqvm_const(y)
Sint *y;
{
  *y = ~(*y ^ 0123456);
}

static void
eqvm_literal(y)
Sint *y;
{
  *y = ~(*y ^ 0123456123456);
}

static Sint
eqvm_then_load(a, y)
Sint a;
Sint *y;
{
  *y = ~(a ^ *y);
  return *y;
}

static Sint
eqv_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  a = ~(a ^ b);
  a = ~(a ^ c);
  return a;
}

static Sint
eqv_assign_mixed(a, b, c)
Sint a;
Sint b;
Sint c;
{
  b = ~(a ^ b);
  c = ~(b ^ c);
  return c;
}

static uSint
ueqv_reg_reg(a, y)
uSint a;
uSint y;
{
  return ~(a ^ y);
}

static uSint
ueqv_reg_mem(a, y)
uSint a;
uSint *y;
{
  return ~(a ^ *y);
}

static uSint
ueqvi_small(a)
uSint a;
{
  return a ^ ~0123456;
}

static uSint
ueqvi_low18(a)
uSint a;
{
  return a ^ ~0777777;
}

static uSint
ueqv_literal(a)
uSint a;
{
  return ~(a ^ 0123456123456);
}

static uSint
ueqvi_literal(a)
uSint a;
{
  return a ^ ~0123456123456;
}

static uSint
ueqv_left_half(a)
uSint a;
{
  return ~(a ^ 0777777000000);
}

static uSint
ueqv_right_half(a)
uSint a;
{
  return ~(a ^ 0000000777777);
}

static uSint
ueqv_high_ones_low_const(a)
uSint a;
{
  return ~(a ^ 0777777012345);
}

static Sint
eqv_qi_promote(a, b)
sQint a;
sQint b;
{
  return ~(a ^ b);
}

static Sint
ueqv_qi_promote(a, b)
uQint a;
uQint b;
{
  return ~(a ^ b);
}

static Sint
eqv_hi_promote(a, b)
Hint a;
Hint b;
{
  return ~(a ^ b);
}

static Sint
ueqv_hi_promote(a, b)
uHint a;
uHint b;
{
  return ~(a ^ b);
}

static Sint
eqvi_qi_mask(a)
uQint a;
{
  return a ^ ~0777;
}

static Sint
eqvi_hi_mask(a)
uHint a;
{
  return a ^ ~0777777;
}

static Sint
eqv_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return ~(a ^ *y);
}

static void
eqvm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y = ~(a ^ *y);
}

static Sint
eqv_array_value(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return ~(a ^ v[i & 7]);
}

static void
eqvm_array_value(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  v[i & 7] = ~(a ^ v[i & 7]);
}

static Sint
eqv_struct_value(a, p)
Sint a;
struct eqv_struct *p;
{
  return ~(a ^ p->b);
}

static void
eqvm_struct_value(a, p)
Sint a;
struct eqv_struct *p;
{
  p->c = ~(a ^ p->c);
}

/*
 * Register-derived masks.  These give combine/reload chances to form
 * immediate-like EQVI variants from ordinary C expressions.
 */

static uSint
eqvi_reg_mask(a, b)
uSint a;
uSint b;
{
  return b ^ ~(a & 0777777);
}

static uSint
eqvi_reg_mask_plus(a, b)
uSint a;
uSint b;
{
  return b ^ ~((a + 01234) & 0777777);
}

static uSint
eqv_left_shift_mask(a, b)
uSint a;
uSint b;
{
  return b ^ ~((a & 0777777) << 18);
}

static uSint
eqv_left_shift_mask_plus(a, b)
uSint a;
uSint b;
{
  return b ^ ~(((a + 01234) & 0777777) << 18);
}

static Sint
eqv_call_pressure(a, y)
Sint a;
Sint *y;
{
  extern void clobber(void);
  Sint r;

  r = ~(a ^ *y);
  clobber();
  return r + *y;
}

static Sint
eqv_two_results(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;
  Sint y;

  x = ~(a ^ b);
  y = ~(a ^ c);
  return x + y;
}

BOTH (eqvb_reg_mem, ~(a ^ *b))
BOTH (eqvb_mem_reg, ~(*b ^ a))
BOTH1 (uSint, ueqvb_reg_mem, ~(a ^ *b))
