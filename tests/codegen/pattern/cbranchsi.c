#include "insns.h"

/*
 * SImode conditional branch pattern pressure.
 *
 * Intended pattern:
 *   cbranchsi
 *
 * PDP-6/KA10-relevant backend alternatives:
 *   JUMP cond,R,label       register compared with zero
 *   SKIP cond,MEM           memory compared with zero
 *   CAI  cond,R,imm         register compared with small immediate
 *   CAM  cond,R,[literal]   register compared with large literal
 *   CAM  cond,R,E           register compared with register/memory
 *
 * Unsigned branch expanders flip the sign bit before using the same
 * signed comparison machinery.
 *
 * cmpsi.c covers compare expression variety.  This file is more
 * branch-shape oriented: if/else control flow, fall-through cases,
 * non-adjacent branch targets, memory skip cases, CAI/CAM alternatives,
 * and unsigned conditional branches.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint cb_ga;
static Sint cb_gb;
static volatile Sint cb_vga;
static Sint cb_buf[16];

static uSint ucb_ga;
static uSint ucb_gb;
static volatile uSint ucb_vga;
static uSint ucb_buf[16];

struct cb_pair {
  Sint a;
  Sint b;
};

struct ucb_pair {
  uSint a;
  uSint b;
};

static struct cb_pair cb_gp;
static struct ucb_pair ucb_gp;

/*
 * Original expected basename shape.
 */

Sint
cbranchsi(a, b)
Sint a;
Sint b;
{
  if (a == b)
    return a + 1;
  return b - 1;
}

/*
 * Register against zero: JUMP-like alternatives.
 */

static Sint
cb_reg_eq_zero(a)
Sint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
cb_reg_ne_zero(a)
Sint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
cb_reg_lt_zero(a)
Sint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
cb_reg_le_zero(a)
Sint a;
{
  if (a <= 0)
    return -1;
  return 1;
}

static Sint
cb_reg_gt_zero(a)
Sint a;
{
  if (a > 0)
    return 1;
  return -1;
}

static Sint
cb_reg_ge_zero(a)
Sint a;
{
  if (a >= 0)
    return 1;
  return -1;
}

static Sint
cb_reg_eq_zero_far(a)
Sint a;
{
  if (a == 0) {
    clobber();
    return f();
  }
  clobber();
  return -f();
}

static Sint
cb_reg_lt_zero_far(a)
Sint a;
{
  if (a < 0) {
    clobber();
    return a - f();
  }
  clobber();
  return a + f();
}

/*
 * Memory against zero: SKIP-like alternatives.
 */

static Sint
cb_mem_eq_zero(p)
Sint *p;
{
  if (*p == 0)
    return 1;
  return -1;
}

static Sint
cb_mem_ne_zero(p)
Sint *p;
{
  if (*p != 0)
    return 1;
  return -1;
}

static Sint
cb_mem_lt_zero(p)
Sint *p;
{
  if (*p < 0)
    return -1;
  return 1;
}

static Sint
cb_mem_le_zero(p)
Sint *p;
{
  if (*p <= 0)
    return -1;
  return 1;
}

static Sint
cb_mem_gt_zero(p)
Sint *p;
{
  if (*p > 0)
    return 1;
  return -1;
}

static Sint
cb_mem_ge_zero(p)
Sint *p;
{
  if (*p >= 0)
    return 1;
  return -1;
}

static Sint
cb_global_eq_zero()
{
  if (cb_ga == 0)
    return 1;
  return -1;
}

static Sint
cb_global_ne_zero()
{
  if (cb_ga != 0)
    return 1;
  return -1;
}

static Sint
cb_global_lt_zero()
{
  if (cb_ga < 0)
    return -1;
  return 1;
}

static Sint
cb_global_ge_zero()
{
  if (cb_ga >= 0)
    return 1;
  return -1;
}

static Sint
cb_volatile_global_eq_zero()
{
  if (cb_vga == 0)
    return 1;
  return -1;
}

static Sint
cb_volatile_global_lt_zero()
{
  if (cb_vga < 0)
    return -1;
  return 1;
}

static Sint
cb_mem_eq_zero_far(p)
Sint *p;
{
  if (*p == 0) {
    clobber();
    return f();
  }
  clobber();
  return -f();
}

static Sint
cb_mem_gt_zero_far(p)
Sint *p;
{
  if (*p > 0) {
    clobber();
    return *p + f();
  }
  clobber();
  return *p - f();
}

/*
 * Register against small immediate: CAI-like alternatives.
 */

static Sint
cb_eq_1(a)
Sint a;
{
  if (a == 1)
    return 1;
  return -1;
}

static Sint
cb_ne_1(a)
Sint a;
{
  if (a != 1)
    return 1;
  return -1;
}

static Sint
cb_lt_1(a)
Sint a;
{
  if (a < 1)
    return -1;
  return 1;
}

static Sint
cb_le_1(a)
Sint a;
{
  if (a <= 1)
    return -1;
  return 1;
}

static Sint
cb_gt_1(a)
Sint a;
{
  if (a > 1)
    return 1;
  return -1;
}

static Sint
cb_ge_1(a)
Sint a;
{
  if (a >= 1)
    return 1;
  return -1;
}

static Sint
cb_eq_small(a)
Sint a;
{
  if (a == 012345)
    return 1;
  return -1;
}

static Sint
cb_lt_small(a)
Sint a;
{
  if (a < 012345)
    return -1;
  return 1;
}

static Sint
cb_gt_small(a)
Sint a;
{
  if (a > 012345)
    return 1;
  return -1;
}

static Sint
cb_eq_right_max(a)
Sint a;
{
  if (a == 0777777)
    return 1;
  return -1;
}

static Sint
cb_lt_right_max(a)
Sint a;
{
  if (a < 0777777)
    return -1;
  return 1;
}

static Sint
cb_gt_right_max(a)
Sint a;
{
  if (a > 0777777)
    return 1;
  return -1;
}

static Sint
cb_eq_minus_1(a)
Sint a;
{
  if (a == -1)
    return 1;
  return -1;
}

static Sint
cb_lt_minus_1(a)
Sint a;
{
  if (a < -1)
    return -1;
  return 1;
}

static Sint
cb_gt_minus_1(a)
Sint a;
{
  if (a > -1)
    return 1;
  return -1;
}

static Sint
cb_eq_minus_small(a)
Sint a;
{
  if (a == -012345)
    return 1;
  return -1;
}

static Sint
cb_lt_minus_small(a)
Sint a;
{
  if (a < -012345)
    return -1;
  return 1;
}

static Sint
cb_gt_minus_small(a)
Sint a;
{
  if (a > -012345)
    return 1;
  return -1;
}

static Sint
cb_eq_small_far(a)
Sint a;
{
  if (a == 012345) {
    clobber();
    return a + f();
  }
  clobber();
  return a - f();
}

static Sint
cb_gt_small_far(a)
Sint a;
{
  if (a > 012345) {
    clobber();
    return f();
  }
  clobber();
  return -f();
}

/*
 * Register against large constants: CAM literal alternatives.
 */

static Sint
cb_eq_left_const(a)
Sint a;
{
  if (a == 0123456000000)
    return 1;
  return -1;
}

static Sint
cb_ne_left_const(a)
Sint a;
{
  if (a != 0123456000000)
    return 1;
  return -1;
}

static Sint
cb_lt_left_const(a)
Sint a;
{
  if (a < 0123456000000)
    return -1;
  return 1;
}

static Sint
cb_gt_left_const(a)
Sint a;
{
  if (a > 0123456000000)
    return 1;
  return -1;
}

static Sint
cb_eq_full_const(a)
Sint a;
{
  if (a == 0123456123456)
    return 1;
  return -1;
}

static Sint
cb_ne_full_const(a)
Sint a;
{
  if (a != 0123456123456)
    return 1;
  return -1;
}

static Sint
cb_lt_full_const(a)
Sint a;
{
  if (a < 0123456123456)
    return -1;
  return 1;
}

static Sint
cb_gt_full_const(a)
Sint a;
{
  if (a > 0123456123456)
    return 1;
  return -1;
}

static Sint
cb_eq_signbit_const(a)
Sint a;
{
  if (a == 0400000000000)
    return 1;
  return -1;
}

static Sint
cb_lt_signbit_const(a)
Sint a;
{
  if (a < 0400000000000)
    return -1;
  return 1;
}

static Sint
cb_gt_signbit_const(a)
Sint a;
{
  if (a > 0400000000000)
    return 1;
  return -1;
}

static Sint
cb_eq_full_const_far(a)
Sint a;
{
  if (a == 0123456123456) {
    clobber();
    return f();
  }
  clobber();
  return -f();
}

/*
 * Register/register and register/memory: CAM E alternatives.
 */

static Sint
cb_reg_eq_reg(a, b)
Sint a;
Sint b;
{
  if (a == b)
    return 1;
  return -1;
}

static Sint
cb_reg_ne_reg(a, b)
Sint a;
Sint b;
{
  if (a != b)
    return 1;
  return -1;
}

static Sint
cb_reg_lt_reg(a, b)
Sint a;
Sint b;
{
  if (a < b)
    return -1;
  return 1;
}

static Sint
cb_reg_le_reg(a, b)
Sint a;
Sint b;
{
  if (a <= b)
    return -1;
  return 1;
}

static Sint
cb_reg_gt_reg(a, b)
Sint a;
Sint b;
{
  if (a > b)
    return 1;
  return -1;
}

static Sint
cb_reg_ge_reg(a, b)
Sint a;
Sint b;
{
  if (a >= b)
    return 1;
  return -1;
}

static Sint
cb_reg_eq_mem(a, p)
Sint a;
Sint *p;
{
  if (a == *p)
    return 1;
  return -1;
}

static Sint
cb_reg_ne_mem(a, p)
Sint a;
Sint *p;
{
  if (a != *p)
    return 1;
  return -1;
}

static Sint
cb_reg_lt_mem(a, p)
Sint a;
Sint *p;
{
  if (a < *p)
    return -1;
  return 1;
}

static Sint
cb_reg_gt_mem(a, p)
Sint a;
Sint *p;
{
  if (a > *p)
    return 1;
  return -1;
}

static Sint
cb_mem_lt_reg(p, a)
Sint *p;
Sint a;
{
  if (*p < a)
    return -1;
  return 1;
}

static Sint
cb_mem_gt_reg(p, a)
Sint *p;
Sint a;
{
  if (*p > a)
    return 1;
  return -1;
}

static Sint
cb_global_eq_reg(a)
Sint a;
{
  if (cb_ga == a)
    return 1;
  return -1;
}

static Sint
cb_reg_eq_global(a)
Sint a;
{
  if (a == cb_gb)
    return 1;
  return -1;
}

static Sint
cb_global_lt_reg(a)
Sint a;
{
  if (cb_ga < a)
    return -1;
  return 1;
}

static Sint
cb_reg_lt_global(a)
Sint a;
{
  if (a < cb_gb)
    return -1;
  return 1;
}

static Sint
cb_volatile_global_ne_reg(a)
Sint a;
{
  if (cb_vga != a)
    return 1;
  return -1;
}

static Sint
cb_reg_reg_far(a, b)
Sint a;
Sint b;
{
  if (a < b) {
    clobber();
    return a + f();
  }
  clobber();
  return b - f();
}

/*
 * Unsigned branch expanders.
 */

static Sint
ucb_eq(a, b)
uSint a;
uSint b;
{
  if (a == b)
    return 1;
  return -1;
}

static Sint
ucb_ne(a, b)
uSint a;
uSint b;
{
  if (a != b)
    return 1;
  return -1;
}

static Sint
ucb_lt(a, b)
uSint a;
uSint b;
{
  if (a < b)
    return -1;
  return 1;
}

static Sint
ucb_le(a, b)
uSint a;
uSint b;
{
  if (a <= b)
    return -1;
  return 1;
}

static Sint
ucb_gt(a, b)
uSint a;
uSint b;
{
  if (a > b)
    return 1;
  return -1;
}

static Sint
ucb_ge(a, b)
uSint a;
uSint b;
{
  if (a >= b)
    return 1;
  return -1;
}

static Sint
ucb_lt_zero(a)
uSint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
ucb_eq_zero(a)
uSint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
ucb_ne_zero(a)
uSint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
ucb_lt_small(a)
uSint a;
{
  if (a < 012345)
    return -1;
  return 1;
}

static Sint
ucb_gt_small(a)
uSint a;
{
  if (a > 012345)
    return 1;
  return -1;
}

static Sint
ucb_lt_highbit(a)
uSint a;
{
  if (a < 0400000000000)
    return -1;
  return 1;
}

static Sint
ucb_ge_highbit(a)
uSint a;
{
  if (a >= 0400000000000)
    return 1;
  return -1;
}

static Sint
ucb_lt_full_const(a)
uSint a;
{
  if (a < 0777777777777)
    return -1;
  return 1;
}

static Sint
ucb_gt_full_const(a)
uSint a;
{
  if (a > 0123456123456)
    return 1;
  return -1;
}

static Sint
ucb_mem_lt_reg(p, a)
uSint *p;
uSint a;
{
  if (*p < a)
    return -1;
  return 1;
}

static Sint
ucb_reg_lt_mem(a, p)
uSint a;
uSint *p;
{
  if (a < *p)
    return -1;
  return 1;
}

static Sint
ucb_global_lt_reg(a)
uSint a;
{
  if (ucb_ga < a)
    return -1;
  return 1;
}

static Sint
ucb_reg_gt_global(a)
uSint a;
{
  if (a > ucb_gb)
    return 1;
  return -1;
}

static Sint
ucb_volatile_global_ne_reg(a)
uSint a;
{
  if (ucb_vga != a)
    return 1;
  return -1;
}

static Sint
ucb_far(a, b)
uSint a;
uSint b;
{
  if (a >= b) {
    clobber();
    return (Sint)uf();
  }
  clobber();
  return -(Sint)uf();
}

/*
 * Array and struct addressing pressure.
 */

static Sint
cb_array_eq_zero(i)
Sint i;
{
  if (cb_buf[i & 017] == 0)
    return 1;
  return -1;
}

static Sint
cb_array_lt_zero(i)
Sint i;
{
  if (cb_buf[i & 017] < 0)
    return -1;
  return 1;
}

static Sint
cb_array_eq_reg(i, a)
Sint i;
Sint a;
{
  if (cb_buf[i & 017] == a)
    return 1;
  return -1;
}

static Sint
cb_reg_lt_array(a, i)
Sint a;
Sint i;
{
  if (a < cb_buf[i & 017])
    return -1;
  return 1;
}

static Sint
ucb_array_lt_reg(i, a)
Sint i;
uSint a;
{
  if (ucb_buf[i & 017] < a)
    return -1;
  return 1;
}

static Sint
ucb_reg_gt_array(a, i)
uSint a;
Sint i;
{
  if (a > ucb_buf[i & 017])
    return 1;
  return -1;
}

static Sint
cb_struct_a_eq_zero(p)
struct cb_pair *p;
{
  if (p->a == 0)
    return 1;
  return -1;
}

static Sint
cb_struct_a_lt_b(p)
struct cb_pair *p;
{
  if (p->a < p->b)
    return -1;
  return 1;
}

static Sint
cb_struct_a_eq_reg(p, a)
struct cb_pair *p;
Sint a;
{
  if (p->a == a)
    return 1;
  return -1;
}

static Sint
cb_global_struct_a_eq_zero()
{
  if (cb_gp.a == 0)
    return 1;
  return -1;
}

static Sint
cb_global_struct_a_lt_b()
{
  if (cb_gp.a < cb_gp.b)
    return -1;
  return 1;
}

static Sint
ucb_struct_a_lt_b(p)
struct ucb_pair *p;
{
  if (p->a < p->b)
    return -1;
  return 1;
}

static Sint
ucb_global_struct_a_ge_b()
{
  if (ucb_gp.a >= ucb_gp.b)
    return 1;
  return -1;
}

/*
 * Expression operands before branch.
 */

static Sint
cb_add_eq_zero(a, b)
Sint a;
Sint b;
{
  if ((a + b) == 0)
    return 1;
  return -1;
}

static Sint
cb_add_lt_reg(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if ((a + b) < c)
    return -1;
  return 1;
}

static Sint
cb_sub_eq_zero(a, b)
Sint a;
Sint b;
{
  if ((a - b) == 0)
    return 1;
  return -1;
}

static Sint
cb_sub_lt_reg(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if ((a - b) < c)
    return -1;
  return 1;
}

static Sint
cb_mul_gt_reg(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if ((a * b) > c)
    return 1;
  return -1;
}

static Sint
cb_and_eq_zero(a, b)
Sint a;
Sint b;
{
  if ((a & b) == 0)
    return 1;
  return -1;
}

static Sint
cb_xor_ne_zero(a, b)
Sint a;
Sint b;
{
  if ((a ^ b) != 0)
    return 1;
  return -1;
}

static Sint
cb_or_gt_small(a, b)
Sint a;
Sint b;
{
  if ((a | b) > 012345)
    return 1;
  return -1;
}

static Sint
ucb_add_lt_reg(a, b, c)
uSint a;
uSint b;
uSint c;
{
  if ((a + b) < c)
    return -1;
  return 1;
}

static Sint
ucb_sub_gt_reg(a, b, c)
uSint a;
uSint b;
uSint c;
{
  if ((a - b) > c)
    return 1;
  return -1;
}

/*
 * CAI special right-half and const-plus-register branch shapes.
 */

static Sint
cb_right_half_eq_reg(a, b)
Sint a;
Sint b;
{
  if ((a & 0777777) == b)
    return 1;
  return -1;
}

static Sint
cb_right_half_lt_reg(a, b)
Sint a;
Sint b;
{
  if ((a & 0777777) < b)
    return -1;
  return 1;
}

static Sint
cb_right_half_gt_reg(a, b)
Sint a;
Sint b;
{
  if ((a & 0777777) > b)
    return 1;
  return -1;
}

static Sint
cb_const_plus_right_half_eq_reg(a, b)
Sint a;
Sint b;
{
  if (((a + 0123) & 0777777) == b)
    return 1;
  return -1;
}

static Sint
cb_const_plus_right_half_lt_reg(a, b)
Sint a;
Sint b;
{
  if (((a + 0123) & 0777777) < b)
    return -1;
  return 1;
}

static Sint
cb_reg_eq_right_half(a, b)
Sint a;
Sint b;
{
  if (a == (b & 0777777))
    return 1;
  return -1;
}

static Sint
cb_reg_lt_right_half(a, b)
Sint a;
Sint b;
{
  if (a < (b & 0777777))
    return -1;
  return 1;
}

static Sint
cb_reg_eq_const_plus_right_half(a, b)
Sint a;
Sint b;
{
  if (a == ((b + 0123) & 0777777))
    return 1;
  return -1;
}

/*
 * Promoted QI/HI conditional branches.
 */

static Sint
cb_qi_eq_zero(a)
Qint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
cb_qi_lt_zero(a)
Qint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
cb_qi_lt_reg(a, b)
Qint a;
Sint b;
{
  if (a < b)
    return -1;
  return 1;
}

static Sint
cb_uqi_lt_reg(a, b)
uQint a;
uSint b;
{
  if (a < b)
    return -1;
  return 1;
}

static Sint
cb_hi_eq_zero(a)
Hint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
cb_hi_lt_zero(a)
Hint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
cb_hi_ge_reg(a, b)
Hint a;
Sint b;
{
  if (a >= b)
    return 1;
  return -1;
}

static Sint
cb_uhi_gt_reg(a, b)
uHint a;
uSint b;
{
  if (a > b)
    return 1;
  return -1;
}

/*
 * Multi-branch and chained control flow.
 */

static Sint
cb_range_signed(a)
Sint a;
{
  if (a < -0100)
    return -1;
  if (a > 0100)
    return 1;
  return 0;
}

static Sint
cb_range_unsigned(a)
uSint a;
{
  if (a < 0100)
    return -1;
  if (a > 0777777)
    return 1;
  return 0;
}

static Sint
cb_between(a, lo, hi)
Sint a;
Sint lo;
Sint hi;
{
  if (a < lo)
    return -1;
  if (a > hi)
    return 1;
  return 0;
}

static Sint
ucb_between(a, lo, hi)
uSint a;
uSint lo;
uSint hi;
{
  if (a < lo)
    return -1;
  if (a > hi)
    return 1;
  return 0;
}

static Sint
cb_chain_and(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (a < b) {
    if (b < c)
      return 1;
  }
  return 0;
}

static Sint
cb_chain_or(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (a == b)
    return 1;
  if (a == c)
    return 1;
  return 0;
}

static Sint
cb_loop_countdown(n)
Sint n;
{
  Sint s;

  s = 0;
  while (n > 0) {
    s += n;
    n = n - 1;
  }
  return s;
}

static Sint
cb_loop_until_zero(p)
Sint *p;
{
  Sint n;
  Sint s;

  n = *p;
  s = 0;
  while (n != 0) {
    s += n;
    n = n - 1;
  }
  return s;
}

/*
 * Calls and volatile barriers around branches.
 */

static Sint
cb_call_eq_zero()
{
  if (f() == 0)
    return 1;
  return -1;
}

static Sint
cb_call_lt_reg(a)
Sint a;
{
  if (f() < a)
    return -1;
  return 1;
}

static Sint
ucb_call_gt_reg(a)
uSint a;
{
  if (uf() > a)
    return 1;
  return -1;
}

static Sint
cb_after_call_mem(p, a)
Sint *p;
Sint a;
{
  Sint x;

  x = *p;
  clobber();
  if (x == a)
    return 1;
  return -1;
}

static Sint
cb_after_call_global(a)
Sint a;
{
  clobber();
  if (cb_ga < a)
    return -1;
  return 1;
}

static Sint
cb_after_call_volatile(a)
Sint a;
{
  clobber();
  if (cb_vga != a)
    return 1;
  return -1;
}

static Sint
cb_store_then_branch(p, a)
Sint *p;
Sint a;
{
  *p = a;
  if (*p == 0)
    return 1;
  return -1;
}

static Sint
cb_branch_then_store(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (a < b)
    *p = a;
  else
    *p = b;
  return *p;
}

static Sint
cb_branch_with_two_calls(a, b)
Sint a;
Sint b;
{
  if (a >= b) {
    clobber();
    return f();
  }
  clobber();
  return -f();
}
