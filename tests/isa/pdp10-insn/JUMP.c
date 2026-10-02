#include "insns.h"

/*
 * JUMP instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction family:
 *   JUMP, JUMPL, JUMPE, JUMPLE, JUMPA, JUMPGE, JUMPN, JUMPG
 *
 * Normal C pressure:
 *   - register compared with zero
 *   - signed < 0, <= 0, == 0, != 0, >= 0, > 0
 *   - if/else forms
 *   - fall-through branch shapes
 *   - loop conditions
 *   - compare results from arithmetic/logical expressions
 *   - promoted QI/HI operands
 *
 * Backend note:
 *   cbranchsi emits the JUMP family for register-vs-zero branches:
 *     jump%3 R,label
 *
 * JUMPA is the always-jump member of the ISA family, but ordinary C
 * unconditional branches are likely to lower to JRST rather than JUMPA.
 * This file therefore includes unconditional-goto pressure, but does
 * not require JUMPA as a hard C-visible result.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint jump_ga;
static Sint jump_gb;
static volatile Sint jump_vga;
static Sint jump_buf[16];

static uSint ujump_ga;
static uSint ujump_gb;
static volatile uSint ujump_vga;
static uSint ujump_buf[16];

struct jump_pair {
  Sint a;
  Sint b;
};

struct ujump_pair {
  uSint a;
  uSint b;
};

static struct jump_pair jump_gp;
static struct ujump_pair ujump_gp;

/*
 * JUMPE / JUMPN pressure: register equal/not-equal zero.
 */

static Sint
jumpe_arg(a)
Sint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
jumpn_arg(a)
Sint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
jumpe_second_arg(a, b)
Sint a;
Sint b;
{
  if (b == 0)
    return a;
  return b;
}

static Sint
jumpn_second_arg(a, b)
Sint a;
Sint b;
{
  if (b != 0)
    return a;
  return b;
}

static Sint
jumpe_return_zero(a)
Sint a;
{
  if (a == 0)
    return 0;
  return a;
}

static Sint
jumpn_return_zero(a)
Sint a;
{
  if (a != 0)
    return a;
  return 0;
}

static Sint
jumpe_after_local(a)
Sint a;
{
  Sint x;

  x = a;
  if (x == 0)
    return 1;
  return 0;
}

static Sint
jumpn_after_local(a)
Sint a;
{
  Sint x;

  x = a;
  if (x != 0)
    return 1;
  return 0;
}

/*
 * JUMPL / JUMPGE pressure: signed negative/non-negative.
 */

static Sint
jumpl_arg(a)
Sint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
jumpge_arg(a)
Sint a;
{
  if (a >= 0)
    return 1;
  return -1;
}

static Sint
jumpl_second_arg(a, b)
Sint a;
Sint b;
{
  if (b < 0)
    return a;
  return b;
}

static Sint
jumpge_second_arg(a, b)
Sint a;
Sint b;
{
  if (b >= 0)
    return a;
  return b;
}

static Sint
jumpl_after_local(a)
Sint a;
{
  Sint x;

  x = a;
  if (x < 0)
    return x;
  return -x;
}

static Sint
jumpge_after_local(a)
Sint a;
{
  Sint x;

  x = a;
  if (x >= 0)
    return x;
  return -x;
}

/*
 * JUMPLE / JUMPG pressure: signed <= 0 and > 0.
 */

static Sint
jumple_arg(a)
Sint a;
{
  if (a <= 0)
    return -1;
  return 1;
}

static Sint
jumpg_arg(a)
Sint a;
{
  if (a > 0)
    return 1;
  return -1;
}

static Sint
jumple_second_arg(a, b)
Sint a;
Sint b;
{
  if (b <= 0)
    return a;
  return b;
}

static Sint
jumpg_second_arg(a, b)
Sint a;
Sint b;
{
  if (b > 0)
    return a;
  return b;
}

static Sint
jumple_after_local(a)
Sint a;
{
  Sint x;

  x = a;
  if (x <= 0)
    return x - 1;
  return x + 1;
}

static Sint
jumpg_after_local(a)
Sint a;
{
  Sint x;

  x = a;
  if (x > 0)
    return x + 1;
  return x - 1;
}

/*
 * Plain JUMP/non-skip pressure.  "if (a)" and "if (!a)" should prefer
 * register-vs-zero branch forms when the operand is already in a
 * register.
 */

static Sint
jump_if_truth(a)
Sint a;
{
  if (a)
    return 1;
  return 0;
}

static Sint
jump_if_false(a)
Sint a;
{
  if (!a)
    return 1;
  return 0;
}

static Sint
jump_if_truth_return_arg(a)
Sint a;
{
  if (a)
    return a;
  return -1;
}

static Sint
jump_if_false_return_arg(a)
Sint a;
{
  if (!a)
    return a;
  return -1;
}

/*
 * Expression result compared with zero.  These should compute into a
 * register, then branch with JUMP-family instructions.
 */

static Sint
jump_add_eq_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_add_ne_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_add_lt_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_add_ge_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  if (x >= 0)
    return 1;
  return -1;
}

static Sint
jump_sub_eq_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_sub_ne_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_sub_le_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  if (x <= 0)
    return -1;
  return 1;
}

static Sint
jump_sub_gt_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  if (x > 0)
    return 1;
  return -1;
}

static Sint
jump_neg_lt_zero(a)
Sint a;
{
  Sint x;

  x = -a;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_neg_ge_zero(a)
Sint a;
{
  Sint x;

  x = -a;
  if (x >= 0)
    return 1;
  return -1;
}

static Sint
jump_and_eq_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_and_ne_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_xor_eq_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_xor_ne_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_or_gt_zero(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a | b;
  if (x > 0)
    return 1;
  return -1;
}

static Sint
jump_shift_lt_zero(a)
Sint a;
{
  Sint x;

  x = a << 1;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_shift_eq_zero(a)
Sint a;
{
  Sint x;

  x = a << 1;
  if (x == 0)
    return 1;
  return -1;
}

/*
 * Memory values loaded into registers before branch.  These are meant
 * to stay in JUMP-family territory rather than SKIP-family territory
 * by forcing local register materialization and/or call barriers.
 */

static Sint
jump_load_eq_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_load_ne_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_load_lt_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_load_ge_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  if (x >= 0)
    return 1;
  return -1;
}

static Sint
jump_load_le_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  if (x <= 0)
    return -1;
  return 1;
}

static Sint
jump_load_gt_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  if (x > 0)
    return 1;
  return -1;
}

static Sint
jump_load_after_call_eq_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_load_after_call_lt_zero(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  if (x < 0)
    return -1;
  return 1;
}

/*
 * Global and volatile sources.
 */

static Sint
jump_global_eq_zero()
{
  Sint x;

  x = jump_ga;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_global_ne_zero()
{
  Sint x;

  x = jump_ga;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_global_lt_zero()
{
  Sint x;

  x = jump_ga;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_global_ge_zero()
{
  Sint x;

  x = jump_ga;
  if (x >= 0)
    return 1;
  return -1;
}

static Sint
jump_volatile_global_eq_zero()
{
  Sint x;

  x = jump_vga;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_volatile_global_lt_zero()
{
  Sint x;

  x = jump_vga;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_array_eq_zero(i)
Sint i;
{
  Sint x;

  x = jump_buf[i & 017];
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_array_gt_zero(i)
Sint i;
{
  Sint x;

  x = jump_buf[i & 017];
  if (x > 0)
    return 1;
  return -1;
}

static Sint
jump_struct_a_lt_zero(p)
struct jump_pair *p;
{
  Sint x;

  x = p->a;
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_struct_b_ne_zero(p)
struct jump_pair *p;
{
  Sint x;

  x = p->b;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_global_struct_a_eq_zero()
{
  Sint x;

  x = jump_gp.a;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_global_struct_b_gt_zero()
{
  Sint x;

  x = jump_gp.b;
  if (x > 0)
    return 1;
  return -1;
}

/*
 * Unsigned values in zero/non-zero tests.  Relational unsigned tests
 * are less JUMP-specific because unsigned ordering uses sign-bit
 * transformation before the signed branch machinery.
 */

static Sint
ujump_eq_zero(a)
uSint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
ujump_ne_zero(a)
uSint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
ujump_truth(a)
uSint a;
{
  if (a)
    return 1;
  return 0;
}

static Sint
ujump_false(a)
uSint a;
{
  if (!a)
    return 1;
  return 0;
}

static Sint
ujump_and_eq_zero(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a & b;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
ujump_xor_ne_zero(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a ^ b;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
ujump_load_eq_zero(p)
uSint *p;
{
  uSint x;

  x = *p;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
ujump_load_ne_zero(p)
uSint *p;
{
  uSint x;

  x = *p;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
ujump_global_eq_zero()
{
  uSint x;

  x = ujump_ga;
  if (x == 0)
    return 1;
  return -1;
}

static Sint
ujump_volatile_global_ne_zero()
{
  uSint x;

  x = ujump_vga;
  if (x != 0)
    return 1;
  return -1;
}

static Sint
ujump_array_eq_zero(i)
Sint i;
{
  uSint x;

  x = ujump_buf[i & 017];
  if (x == 0)
    return 1;
  return -1;
}

static Sint
ujump_struct_a_ne_zero(p)
struct ujump_pair *p;
{
  uSint x;

  x = p->a;
  if (x != 0)
    return 1;
  return -1;
}

/*
 * Promoted QI and HI operands.  These should become SImode register
 * tests after extension/promotion.
 */

static Sint
jump_qi_eq_zero(a)
Qint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
jump_qi_ne_zero(a)
Qint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
jump_qi_lt_zero(a)
Qint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
jump_qi_ge_zero(a)
Qint a;
{
  if (a >= 0)
    return 1;
  return -1;
}

static Sint
jump_qi_le_zero(a)
Qint a;
{
  if (a <= 0)
    return -1;
  return 1;
}

static Sint
jump_qi_gt_zero(a)
Qint a;
{
  if (a > 0)
    return 1;
  return -1;
}

static Sint
jump_uqi_eq_zero(a)
uQint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
jump_uqi_ne_zero(a)
uQint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
jump_hi_eq_zero(a)
Hint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
jump_hi_ne_zero(a)
Hint a;
{
  if (a != 0)
    return 1;
  return -1;
}

static Sint
jump_hi_lt_zero(a)
Hint a;
{
  if (a < 0)
    return -1;
  return 1;
}

static Sint
jump_hi_ge_zero(a)
Hint a;
{
  if (a >= 0)
    return 1;
  return -1;
}

static Sint
jump_hi_le_zero(a)
Hint a;
{
  if (a <= 0)
    return -1;
  return 1;
}

static Sint
jump_hi_gt_zero(a)
Hint a;
{
  if (a > 0)
    return 1;
  return -1;
}

static Sint
jump_uhi_eq_zero(a)
uHint a;
{
  if (a == 0)
    return 1;
  return -1;
}

static Sint
jump_uhi_ne_zero(a)
uHint a;
{
  if (a != 0)
    return 1;
  return -1;
}

/*
 * Explicit control-flow shapes.  These help keep real labels and
 * non-trivial branch distances alive.
 */

static Sint
jump_far_eq_zero(a)
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
jump_far_ne_zero(a)
Sint a;
{
  if (a != 0) {
    clobber();
    return f();
  }
  clobber();
  return -f();
}

static Sint
jump_far_lt_zero(a)
Sint a;
{
  if (a < 0) {
    clobber();
    return a - f();
  }
  clobber();
  return a + f();
}

static Sint
jump_far_ge_zero(a)
Sint a;
{
  if (a >= 0) {
    clobber();
    return a + f();
  }
  clobber();
  return a - f();
}

static Sint
jump_far_le_zero(a)
Sint a;
{
  if (a <= 0) {
    clobber();
    return a - f();
  }
  clobber();
  return a + f();
}

static Sint
jump_far_gt_zero(a)
Sint a;
{
  if (a > 0) {
    clobber();
    return a + f();
  }
  clobber();
  return a - f();
}

/*
 * Fall-through orientation variants.
 */

static Sint
jump_eq_zero_fallthrough(a)
Sint a;
{
  if (a != 0)
    return a;
  return 0;
}

static Sint
jump_ne_zero_fallthrough(a)
Sint a;
{
  if (a == 0)
    return 0;
  return a;
}

static Sint
jump_lt_zero_fallthrough(a)
Sint a;
{
  if (a >= 0)
    return a;
  return -a;
}

static Sint
jump_ge_zero_fallthrough(a)
Sint a;
{
  if (a < 0)
    return -a;
  return a;
}

static Sint
jump_le_zero_fallthrough(a)
Sint a;
{
  if (a > 0)
    return a;
  return -a;
}

static Sint
jump_gt_zero_fallthrough(a)
Sint a;
{
  if (a <= 0)
    return -a;
  return a;
}

/*
 * Multi-branch chains.  These should produce several register-vs-zero
 * tests in one function.
 */

static Sint
jump_classify_signed(a)
Sint a;
{
  if (a < 0)
    return -1;
  if (a == 0)
    return 0;
  return 1;
}

static Sint
jump_classify_signed_reverse(a)
Sint a;
{
  if (a > 0)
    return 1;
  if (a == 0)
    return 0;
  return -1;
}

static Sint
jump_classify_nonzero(a)
Sint a;
{
  if (a != 0) {
    if (a < 0)
      return -1;
    return 1;
  }
  return 0;
}

static Sint
jump_nested(a, b)
Sint a;
Sint b;
{
  if (a != 0) {
    if (b == 0)
      return a;
    if (b < 0)
      return -b;
    return b;
  }
  return 0;
}

static Sint
jump_chain_and(a, b)
Sint a;
Sint b;
{
  if (a != 0) {
    if (b != 0)
      return 1;
  }
  return 0;
}

static Sint
jump_chain_or(a, b)
Sint a;
Sint b;
{
  if (a != 0)
    return 1;
  if (b != 0)
    return 1;
  return 0;
}

/*
 * Loops.  Loop back-edges and exits should use JUMP-family branches
 * where the loop variable is held in a register and compared with zero.
 */

static Sint
jump_loop_countdown(n)
Sint n;
{
  Sint s;

  s = 0;
  while (n != 0) {
    s += n;
    n = n - 1;
  }
  return s;
}

static Sint
jump_loop_positive(n)
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
jump_loop_nonnegative(n)
Sint n;
{
  Sint s;

  s = 0;
  while (n >= 0) {
    s += n;
    n = n - 1;
  }
  return s;
}

static Sint
jump_loop_until_negative(n)
Sint n;
{
  Sint s;

  s = 0;
  while (n >= 0) {
    s += n;
    n = n - f();
  }
  return s;
}

static Sint
jump_do_until_zero(n)
Sint n;
{
  Sint s;

  s = 0;
  do {
    s += n;
    n = n - 1;
  } while (n != 0);
  return s;
}

static Sint
jump_for_countdown(n)
Sint n;
{
  Sint s;

  s = 0;
  for (; n > 0; n = n - 1)
    s += n;
  return s;
}

/*
 * Stores and side effects inside branches.
 */

static void
jump_store_if_zero(p, a)
Sint *p;
Sint a;
{
  if (a == 0)
    *p = 0;
}

static void
jump_store_if_nonzero(p, a)
Sint *p;
Sint a;
{
  if (a != 0)
    *p = a;
}

static void
jump_store_if_negative(p, a)
Sint *p;
Sint a;
{
  if (a < 0)
    *p = a;
}

static void
jump_store_if_positive(p, a)
Sint *p;
Sint a;
{
  if (a > 0)
    *p = a;
}

static Sint
jump_store_select(p, a)
Sint *p;
Sint a;
{
  if (a == 0)
    *p = 1;
  else
    *p = -1;
  return *p;
}

static Sint
jump_store_select_sign(p, a)
Sint *p;
Sint a;
{
  if (a < 0)
    *p = -1;
  else if (a > 0)
    *p = 1;
  else
    *p = 0;
  return *p;
}

/*
 * Calls producing branch operands.
 */

static Sint
jump_call_eq_zero()
{
  Sint x;

  x = f();
  if (x == 0)
    return 1;
  return -1;
}

static Sint
jump_call_ne_zero()
{
  Sint x;

  x = f();
  if (x != 0)
    return 1;
  return -1;
}

static Sint
jump_call_lt_zero()
{
  Sint x;

  x = f();
  if (x < 0)
    return -1;
  return 1;
}

static Sint
jump_call_gt_zero()
{
  Sint x;

  x = f();
  if (x > 0)
    return 1;
  return -1;
}

static Sint
ujump_call_eq_zero()
{
  uSint x;

  x = uf();
  if (x == 0)
    return 1;
  return -1;
}

static Sint
ujump_call_ne_zero()
{
  uSint x;

  x = uf();
  if (x != 0)
    return 1;
  return -1;
}

/*
 * Unconditional control-flow pressure.  This is included only as a
 * JUMPA-family smoke shape; ordinary C will generally lower this to
 * JRST rather than JUMPA.
 */

static Sint
jumpa_candidate_goto(a)
Sint a;
{
  goto out;

dead:
  return a + 1;

out:
  if (a == 012345)
    return a;
  goto dead;
}

static Sint
jumpa_candidate_loop_once(a)
Sint a;
{
  for (;;) {
    a = a + 1;
    break;
  }
  return a;
}

static Sint
jumpa_candidate_switch(flag, a)
Sint flag;
Sint a;
{
  if (flag)
    goto yes;
  goto no;

yes:
  return a + 1;

no:
  return a - 1;
}

/*
 * Combined smoke function.
 */

Sint
JUMP(a, b, p)
Sint a;
Sint b;
Sint *p;
{
  Sint r;

  r = 0;

  if (a == 0)
    r += 1;
  if (a != 0)
    r += 2;
  if (a < 0)
    r -= 3;
  if (a <= 0)
    r -= 4;
  if (a >= 0)
    r += 5;
  if (a > 0)
    r += 6;

  if ((a + b) == 0)
    r += 7;
  if ((a - b) != 0)
    r += 8;
  if ((a ^ b) < 0)
    r -= 9;

  if (p != 0) {
    if (*p != 0)
      r += *p;
  }

  return r;
}
