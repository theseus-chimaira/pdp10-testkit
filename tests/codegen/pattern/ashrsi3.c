#include "insns.h"

/*
 * SImode arithmetic-right-shift pattern pressure.
 *
 * Intended pattern:
 *   ashrsi3
 *
 * PDP-6/KA10-relevant backend forms:
 *   ASH AC,(R)       variable count in register, negated by expander
 *   ASH AC,K         constant negative count
 *   ASH AC,@MEM      count from memory operand, if reload keeps it there
 *   ASH AC,K(R)      plus-form count from register plus small constant
 *
 * This file is signed-only for the result value.  Unsigned logical
 * right shift belongs to lshrsi3.c.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern void clobber(void);

static Sint ashr_ga;
static Sint ashr_gb;
static volatile Sint ashr_vga;
static Sint ashr_buf[16];

static Sint ashr_count;
static volatile Sint ashr_vcount;
static Sint ashr_counts[16];

struct ashr_pair {
  Sint a;
  Sint b;
};

struct ashr_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct ashr_pair ashr_gp;
static struct ashr_three ashr_gt;

/*
 * Original expected basename shape.
 */

Sint
ashrsi3(a, b)
Sint a;
Sint b;
{
  return a >> b;
}

/*
 * Basic variable-count forms.
 */

static Sint
ashr_reg_reg(a, b)
Sint a;
Sint b;
{
  return a >> b;
}

static Sint
ashr_second_arg(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return b >> c;
}

static Sint
ashr_local(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a >> b;
  return x;
}

static Sint
ashr_reuse_left(a, b)
Sint a;
Sint b;
{
  a = a >> b;
  return a;
}

static Sint
ashr_reuse_count(a, b)
Sint a;
Sint b;
{
  b = a >> b;
  return b;
}

static Sint
ashr_after_add(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a + b;
  return x >> c;
}

static Sint
ashr_after_sub(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a - b;
  return x >> c;
}

static Sint
ashr_after_and(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a & b;
  return x >> c;
}

static Sint
ashr_after_xor(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a ^ b;
  return x >> c;
}

static Sint
ashr_after_neg(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = -a;
  return x >> b;
}

static Sint
ashr_call_count(a)
Sint a;
{
  return a >> f();
}

static Sint
ashr_call_value(b)
Sint b;
{
  return f() >> b;
}

/*
 * Constant-count forms.
 */

static Sint
ashri_0(a)
Sint a;
{
  return a >> 0;
}

static Sint
ashri_1(a)
Sint a;
{
  return a >> 1;
}

static Sint
ashri_2(a)
Sint a;
{
  return a >> 2;
}

static Sint
ashri_3(a)
Sint a;
{
  return a >> 3;
}

static Sint
ashri_4(a)
Sint a;
{
  return a >> 4;
}

static Sint
ashri_5(a)
Sint a;
{
  return a >> 5;
}

static Sint
ashri_8(a)
Sint a;
{
  return a >> 8;
}

static Sint
ashri_9(a)
Sint a;
{
  return a >> 9;
}

static Sint
ashri_17(a)
Sint a;
{
  return a >> 17;
}

static Sint
ashri_18(a)
Sint a;
{
  return a >> 18;
}

static Sint
ashri_19(a)
Sint a;
{
  return a >> 19;
}

static Sint
ashri_27(a)
Sint a;
{
  return a >> 27;
}

static Sint
ashri_35(a)
Sint a;
{
  return a >> 35;
}

/*
 * Negative-value pressure.  These are important because ASH must
 * preserve the sign while shifting right.
 */

static Sint
ashri_neg_1(a)
Sint a;
{
  return -a >> 1;
}

static Sint
ashri_neg_4(a)
Sint a;
{
  return -a >> 4;
}

static Sint
ashri_neg_18(a)
Sint a;
{
  return -a >> 18;
}

static Sint
ashri_const_neg_one()
{
  return -1 >> 1;
}

static Sint
ashri_const_signbit_like()
{
  return 0400000000000 >> 1;
}

static Sint
ashri_full_const()
{
  return 0123456123456 >> 3;
}

/*
 * Memory/global value forms.
 */

static Sint
ashr_mem_value(p, b)
Sint *p;
Sint b;
{
  return *p >> b;
}

static Sint
ashr_volatile_mem_value(p, b)
volatile Sint *p;
Sint b;
{
  return *p >> b;
}

static Sint
ashr_global_value(b)
Sint b;
{
  return ashr_ga >> b;
}

static Sint
ashr_global_b_value(b)
Sint b;
{
  return ashr_gb >> b;
}

static Sint
ashr_volatile_global_value(b)
Sint b;
{
  return ashr_vga >> b;
}

static Sint
ashr_array_value(i, b)
Sint i;
Sint b;
{
  return ashr_buf[i & 017] >> b;
}

static Sint
ashr_ptr_array_value(p, i, b)
Sint *p;
Sint i;
Sint b;
{
  return p[i & 017] >> b;
}

/*
 * Memory/global count forms.  These are meant to pressure the m-count
 * alternative where possible, although reload may still choose a
 * register.
 */

static Sint
ashr_mem_count(a, p)
Sint a;
Sint *p;
{
  return a >> *p;
}

static Sint
ashr_volatile_mem_count(a, p)
Sint a;
volatile Sint *p;
{
  return a >> *p;
}

static Sint
ashr_global_count(a)
Sint a;
{
  return a >> ashr_count;
}

static Sint
ashr_volatile_global_count(a)
Sint a;
{
  return a >> ashr_vcount;
}

static Sint
ashr_array_count(a, i)
Sint a;
Sint i;
{
  return a >> ashr_counts[i & 017];
}

static Sint
ashr_mem_value_mem_count(p, q)
Sint *p;
Sint *q;
{
  return *p >> *q;
}

static Sint
ashr_global_value_global_count()
{
  return ashr_ga >> ashr_count;
}

/*
 * Struct addressing forms.
 */

static Sint
ashr_struct_value_a(p, b)
struct ashr_pair *p;
Sint b;
{
  return p->a >> b;
}

static Sint
ashr_struct_value_b(p, b)
struct ashr_pair *p;
Sint b;
{
  return p->b >> b;
}

static Sint
ashr_struct_count_a(a, p)
Sint a;
struct ashr_pair *p;
{
  return a >> p->a;
}

static Sint
ashr_struct_count_b(a, p)
Sint a;
struct ashr_pair *p;
{
  return a >> p->b;
}

static Sint
ashr_struct_both(p)
struct ashr_pair *p;
{
  return p->a >> p->b;
}

static Sint
ashr_global_struct_value(b)
Sint b;
{
  return ashr_gp.a >> b;
}

static Sint
ashr_global_struct_count(a)
Sint a;
{
  return a >> ashr_gp.b;
}

static Sint
ashr_global_struct_three()
{
  return ashr_gt.a >> ashr_gt.c;
}

/*
 * Count plus constant forms.  These are intended to hit
 * *ASH_right_plus:
 *
 *   x >> (n + K)
 */

static Sint
ashr_count_plus_1(a, n)
Sint a;
Sint n;
{
  return a >> (n + 1);
}

static Sint
ashr_count_plus_2(a, n)
Sint a;
Sint n;
{
  return a >> (n + 2);
}

static Sint
ashr_count_plus_7(a, n)
Sint a;
Sint n;
{
  return a >> (n + 7);
}

static Sint
ashr_count_plus_18(a, n)
Sint a;
Sint n;
{
  return a >> (n + 18);
}

static Sint
ashr_count_minus_1(a, n)
Sint a;
Sint n;
{
  return a >> (n - 1);
}

static Sint
ashr_count_minus_2(a, n)
Sint a;
Sint n;
{
  return a >> (n - 2);
}

static Sint
ashr_mem_count_plus(a, p)
Sint a;
Sint *p;
{
  return a >> (*p + 1);
}

static Sint
ashr_array_count_plus(a, i)
Sint a;
Sint i;
{
  return a >> (ashr_counts[i & 017] + 1);
}

static Sint
ashr_struct_count_plus(a, p)
Sint a;
struct ashr_pair *p;
{
  return a >> (p->b + 1);
}

/*
 * QI/HI promoted operands.  These should still become SImode
 * arithmetic right shifts after promotion/sign extension.
 */

static Sint
ashr_qi_value(a, b)
Qint a;
Sint b;
{
  return a >> b;
}

static Sint
ashr_uqi_value(a, b)
uQint a;
Sint b;
{
  return a >> b;
}

static Sint
ashr_hi_value(a, b)
Hint a;
Sint b;
{
  return a >> b;
}

static Sint
ashr_uhi_value(a, b)
uHint a;
Sint b;
{
  return a >> b;
}

static Sint
ashr_qi_count(a, b)
Sint a;
Qint b;
{
  return a >> b;
}

static Sint
ashr_uqi_count(a, b)
Sint a;
uQint b;
{
  return a >> b;
}

static Sint
ashr_hi_count(a, b)
Sint a;
Hint b;
{
  return a >> b;
}

static Sint
ashr_uhi_count(a, b)
Sint a;
uHint b;
{
  return a >> b;
}

/*
 * Store result forms.
 */

static void
ashr_store_ptr(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  *dst = a >> b;
}

static Sint
ashr_store_ptr_return(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  return *dst = a >> b;
}

static void
ashr_store_global(a, b)
Sint a;
Sint b;
{
  ashr_ga = a >> b;
}

static Sint
ashr_store_global_return(a, b)
Sint a;
Sint b;
{
  return ashr_ga = a >> b;
}

static void
ashr_store_array(i, a, b)
Sint i;
Sint a;
Sint b;
{
  ashr_buf[i & 017] = a >> b;
}

static Sint
ashr_store_array_return(i, a, b)
Sint i;
Sint a;
Sint b;
{
  return ashr_buf[i & 017] = a >> b;
}

/*
 * In-place arithmetic right shifts.
 */

static void
ashr_inplace_ptr(p, b)
Sint *p;
Sint b;
{
  *p = *p >> b;
}

static Sint
ashr_inplace_ptr_return(p, b)
Sint *p;
Sint b;
{
  return *p = *p >> b;
}

static void
ashr_inplace_global(b)
Sint b;
{
  ashr_ga = ashr_ga >> b;
}

static Sint
ashr_inplace_global_return(b)
Sint b;
{
  return ashr_ga = ashr_ga >> b;
}

static void
ashr_inplace_array(i, b)
Sint i;
Sint b;
{
  ashr_buf[i & 017] = ashr_buf[i & 017] >> b;
}

static Sint
ashr_inplace_array_return(i, b)
Sint i;
Sint b;
{
  return ashr_buf[i & 017] = ashr_buf[i & 017] >> b;
}

/*
 * Result-use forms.
 */

static Sint
ashr_plus(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a >> b) + c;
}

static Sint
ashr_minus(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a >> b) - c;
}

static Sint
ashr_xor(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a >> b) ^ c;
}

static Sint
ashr_or(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a >> b) | c;
}

static Sint
ashr_and(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a >> b) & c;
}

static Sint
ashr_twice(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a >> b;
  return x >> c;
}

static Sint
ashr_mix(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;
  Sint y;

  x = a >> b;
  y = c >> 1;
  return x ^ y;
}

/*
 * Branch and compare uses after arithmetic right shift.
 */

static Sint
ashr_eq_zero(a, b)
Sint a;
Sint b;
{
  return (a >> b) == 0;
}

static Sint
ashr_ne_zero(a, b)
Sint a;
Sint b;
{
  return (a >> b) != 0;
}

static Sint
ashr_lt_zero(a, b)
Sint a;
Sint b;
{
  return (a >> b) < 0;
}

static Sint
ashr_ge_zero(a, b)
Sint a;
Sint b;
{
  return (a >> b) >= 0;
}

static Sint
ashr_gt_const(a, b)
Sint a;
Sint b;
{
  return (a >> b) > 012345;
}

static Sint
ashr_range(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a >> b;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

/*
 * Division by powers of two with signed values.  Keep these here as
 * review pressure for arithmetic-right-shift-like lowering.  Do not
 * require them to become a single ASH when C truncation-toward-zero
 * needs bias code.
 */

static Sint
ashr_div_2(a)
Sint a;
{
  return a / 2;
}

static Sint
ashr_div_4(a)
Sint a;
{
  return a / 4;
}

static Sint
ashr_div_8(a)
Sint a;
{
  return a / 8;
}

static Sint
ashr_mod_2(a)
Sint a;
{
  return a % 2;
}

static Sint
ashr_mod_4(a)
Sint a;
{
  return a % 4;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static Sint
ashr_after_call(p, b)
Sint *p;
Sint b;
{
  Sint x;

  x = *p;
  clobber();
  return x >> b;
}

static Sint
ashr_count_after_call(a, p)
Sint a;
Sint *p;
{
  Sint n;

  n = *p;
  clobber();
  return a >> n;
}

static Sint
ashr_store_after_call(p, a)
Sint *p;
Sint a;
{
  Sint n;

  n = f();
  clobber();
  return *p = a >> n;
}

static Sint
ashr_global_after_call(b)
Sint b;
{
  Sint x;

  x = f();
  clobber();
  return x >> b;
}
