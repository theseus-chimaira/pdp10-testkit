#include "insns.h"

/*
 * SImode signed modulo pattern pressure for PDP-6/166 and KA10.
 *
 * Intended pattern:
 *   modsi3
 *
 * Backend shape:
 *   - move dividend into a DImode temporary
 *   - emit IDIV
 *   - return the remainder half
 *
 * Intended instruction pressure:
 *   IDIV   AC,E
 *   IDIVI  AC,imm
 *   IDIV   AC,[literal]
 *
 * Notes:
 *   - This is signed modulo only.
 *   - Unsigned modulo is not covered here; unsigned SImode modulo is
 *     handled by the misc/libgcc-umodsi3 fallback test.
 *   - IDIVM is quotient-oriented and belongs mostly to divsi3 coverage.
 *   - Do not expect IDIVB here; the backend notes it as missing.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern void clobber(void);

static Sint modsi3_ga;
static Sint modsi3_gb;
static volatile Sint modsi3_vga;
static Sint modsi3_buf[16];

struct modsi3_pair {
  Sint a;
  Sint b;
};

struct modsi3_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct modsi3_pair modsi3_gp;
static struct modsi3_three modsi3_gt;

/*
 * Basic register/register forms.
 */

static Sint
modsi3(a, b)
Sint a;
Sint b;
{
  return a % b;
}

static Sint
mod_reg_reg(a, b)
Sint a;
Sint b;
{
  return a % b;
}

static Sint
mod_local(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a % b;
  return x;
}

static Sint
mod_reuse_left(a, b)
Sint a;
Sint b;
{
  a = a % b;
  return a;
}

static Sint
mod_reuse_right(a, b)
Sint a;
Sint b;
{
  b = a % b;
  return b;
}

static Sint
mod_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a % b;
  return x % c;
}

static Sint
mod_add_use(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a % b;
  return x + c;
}

static Sint
mod_sub_use(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a % b;
  return x - c;
}

static Sint
mod_xor_use(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a % b;
  return x ^ c;
}

static Sint
mod_from_call(b)
Sint b;
{
  return f() % b;
}

static Sint
mod_call_rhs(a)
Sint a;
{
  return a % f();
}

/*
 * Register/memory and memory/register forms.
 */

static Sint
mod_reg_mem(a, p)
Sint a;
Sint *p;
{
  return a % *p;
}

static Sint
mod_mem_reg(p, b)
Sint *p;
Sint b;
{
  return *p % b;
}

static Sint
mod_mem_mem(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint b;

  a = *p;
  b = *q;
  return a % b;
}

static Sint
mod_volatile_mem(a, p)
Sint a;
volatile Sint *p;
{
  return a % *p;
}

static Sint
mod_mem_volatile(p, b)
volatile Sint *p;
Sint b;
{
  return *p % b;
}

static Sint
mod_global_reg(b)
Sint b;
{
  return modsi3_ga % b;
}

static Sint
mod_reg_global(a)
Sint a;
{
  return a % modsi3_gb;
}

static Sint
mod_volatile_global(a)
Sint a;
{
  return a % modsi3_vga;
}

/*
 * Array and struct addressing pressure.
 */

static Sint
mod_array_reg(v, i, b)
Sint *v;
Sint i;
Sint b;
{
  return v[i & 017] % b;
}

static Sint
mod_reg_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a % v[i & 017];
}

static Sint
mod_global_array(i, b)
Sint i;
Sint b;
{
  return modsi3_buf[i & 017] % b;
}

static Sint
mod_reg_global_array(a, i)
Sint a;
Sint i;
{
  return a % modsi3_buf[i & 017];
}

static Sint
mod_struct_a(p, b)
struct modsi3_pair *p;
Sint b;
{
  return p->a % b;
}

static Sint
mod_struct_b(a, p)
Sint a;
struct modsi3_pair *p;
{
  return a % p->b;
}

static Sint
mod_struct_two(p)
struct modsi3_pair *p;
{
  return p->a % p->b;
}

static Sint
mod_struct_three(p)
struct modsi3_three *p;
{
  Sint x;

  x = p->a % p->b;
  return x % p->c;
}

static Sint
mod_global_struct_a(b)
Sint b;
{
  return modsi3_gp.a % b;
}

static Sint
mod_global_struct_b(a)
Sint a;
{
  return a % modsi3_gp.b;
}

static Sint
mod_global_struct_three()
{
  return modsi3_gt.a % modsi3_gt.c;
}

/*
 * Constant divisor forms.
 * Small constants should pressure IDIVI-like output.
 * Larger constants should pressure literal/general constant output.
 */

static Sint
modi_one(a)
Sint a;
{
  return a % 1;
}

static Sint
modi_two(a)
Sint a;
{
  return a % 2;
}

static Sint
modi_three(a)
Sint a;
{
  return a % 3;
}

static Sint
modi_seven(a)
Sint a;
{
  return a % 7;
}

static Sint
modi_small(a)
Sint a;
{
  return a % 012345;
}

static Sint
modi_right_max(a)
Sint a;
{
  return a % 0777777;
}

static Sint
modi_left_const(a)
Sint a;
{
  return a % 0123456000000;
}

static Sint
modi_full_const(a)
Sint a;
{
  return a % 0123456123456;
}

static Sint
modi_minus_one(a)
Sint a;
{
  return a % -1;
}

static Sint
modi_minus_two(a)
Sint a;
{
  return a % -2;
}

static Sint
modi_minus_small(a)
Sint a;
{
  return a % -012345;
}

/*
 * Constant dividend forms.
 */

static Sint
mod_const_by_reg(b)
Sint b;
{
  return 0123456 % b;
}

static Sint
mod_neg_const_by_reg(b)
Sint b;
{
  return -0123456 % b;
}

static Sint
mod_full_const_by_reg(b)
Sint b;
{
  return 0123456123456 % b;
}

static Sint
mod_left_const_by_reg(b)
Sint b;
{
  return 0123456000000 % b;
}

/*
 * Store result forms.  These should still be modsi3 followed by store;
 * do not confuse them with IDIVM/IDIVB coverage.
 */

static void
mod_store_ptr(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  *dst = a % b;
}

static Sint
mod_store_ptr_return(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  return *dst = a % b;
}

static void
mod_store_global(a, b)
Sint a;
Sint b;
{
  modsi3_ga = a % b;
}

static Sint
mod_store_global_return(a, b)
Sint a;
Sint b;
{
  return modsi3_ga = a % b;
}

static void
mod_store_array(i, a, b)
Sint i;
Sint a;
Sint b;
{
  modsi3_buf[i & 017] = a % b;
}

static Sint
mod_store_array_return(i, a, b)
Sint i;
Sint a;
Sint b;
{
  return modsi3_buf[i & 017] = a % b;
}

static void
mod_store_struct_a(p, a, b)
struct modsi3_pair *p;
Sint a;
Sint b;
{
  p->a = a % b;
}

static Sint
mod_store_struct_a_return(p, a, b)
struct modsi3_pair *p;
Sint a;
Sint b;
{
  return p->a = a % b;
}

/*
 * In-place modulo forms.
 */

static void
mod_inplace_ptr(p, b)
Sint *p;
Sint b;
{
  *p = *p % b;
}

static Sint
mod_inplace_ptr_return(p, b)
Sint *p;
Sint b;
{
  return *p = *p % b;
}

static void
mod_inplace_global(b)
Sint b;
{
  modsi3_ga = modsi3_ga % b;
}

static Sint
mod_inplace_global_return(b)
Sint b;
{
  return modsi3_ga = modsi3_ga % b;
}

static void
mod_inplace_array(i, b)
Sint i;
Sint b;
{
  modsi3_buf[i & 017] = modsi3_buf[i & 017] % b;
}

static Sint
mod_inplace_array_return(i, b)
Sint i;
Sint b;
{
  return modsi3_buf[i & 017] = modsi3_buf[i & 017] % b;
}

/*
 * Signedness-sensitive cases.
 */

static Sint
mod_negative_lhs(a, b)
Sint a;
Sint b;
{
  return -a % b;
}

static Sint
mod_negative_rhs(a, b)
Sint a;
Sint b;
{
  return a % -b;
}

static Sint
mod_both_negative(a, b)
Sint a;
Sint b;
{
  return -a % -b;
}

static Sint
mod_abs_like(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a % b;
  if (x < 0)
    x = -x;
  return x;
}

/*
 * Branch and compare uses after modulo.
 */

static Sint
mod_eq_zero(a, b)
Sint a;
Sint b;
{
  return (a % b) == 0;
}

static Sint
mod_ne_zero(a, b)
Sint a;
Sint b;
{
  return (a % b) != 0;
}

static Sint
mod_lt_zero(a, b)
Sint a;
Sint b;
{
  return (a % b) < 0;
}

static Sint
mod_ge_zero(a, b)
Sint a;
Sint b;
{
  return (a % b) >= 0;
}

static Sint
mod_gt_const(a, b)
Sint a;
Sint b;
{
  return (a % b) > 0123;
}

static Sint
mod_range(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a % b;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

/*
 * Div/mod sharing pressure.  The backend currently has _divmodsi4
 * disabled, so these should normally compile as separate divsi3/modsi3
 * work unless later backend work changes that.
 */

static Sint
mod_with_div_sum(a, b)
Sint a;
Sint b;
{
  return (a / b) + (a % b);
}

static Sint
mod_with_div_store(qp, rp, a, b)
Sint *qp;
Sint *rp;
Sint a;
Sint b;
{
  *qp = a / b;
  *rp = a % b;
  return *rp;
}

static Sint
mod_recompose(a, b)
Sint a;
Sint b;
{
  Sint q;
  Sint r;

  q = a / b;
  r = a % b;
  return q * b + r;
}

/*
 * Volatile/call barriers to keep selected memory forms alive.
 */

static Sint
mod_after_call(p, b)
Sint *p;
Sint b;
{
  Sint x;

  x = *p;
  clobber();
  return x % b;
}

static Sint
mod_call_after_load(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  return x % f();
}

static Sint
mod_store_after_call(p)
Sint *p;
{
  Sint x;

  x = f();
  clobber();
  return *p = x % *p;
}

static Sint
mod_global_after_call(b)
Sint b;
{
  Sint x;

  x = f();
  clobber();
  return x % modsi3_ga + b;
}
