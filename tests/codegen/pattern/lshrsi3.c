#include "insns.h"

/*
 * SImode logical-right-shift pattern pressure.
 *
 * Intended pattern:
 *   lshrsi3
 *
 * PDP-6/KA10-relevant backend forms:
 *   LSH AC,(R)       variable count in register, negated by expander
 *   LSH AC,K         constant negative count
 *   LSH AC,@MEM      count from memory operand, if reload keeps it there
 *   LSH AC,K(R)      plus-form count from register plus small constant
 *
 * This file is unsigned-value focused.  Signed arithmetic right shift
 * belongs to ashrsi3.c.
 *
 * Do not use inline assembly here.
 */

extern uSint uf(void);
extern Sint f(void);
extern void clobber(void);

static uSint lshr_ga;
static uSint lshr_gb;
static volatile uSint lshr_vga;
static uSint lshr_buf[16];

static Sint lshr_count;
static volatile Sint lshr_vcount;
static Sint lshr_counts[16];

static uSint lshr_ucount;
static volatile uSint lshr_vucount;
static uSint lshr_ucounts[16];

struct lshr_pair {
  uSint a;
  uSint b;
};

struct lshr_three {
  uSint a;
  uSint b;
  uSint c;
};

struct lshr_count_pair {
  Sint a;
  Sint b;
};

static struct lshr_pair lshr_gp;
static struct lshr_three lshr_gt;
static struct lshr_count_pair lshr_cgp;

/*
 * Original expected basename shape.
 */

uSint
lshrsi3(a, b)
uSint a;
Sint b;
{
  return a >> b;
}

/*
 * Basic variable-count forms.
 */

static uSint
lshr_reg_reg(a, b)
uSint a;
Sint b;
{
  return a >> b;
}

static uSint
lshr_reg_ureg(a, b)
uSint a;
uSint b;
{
  return a >> b;
}

static uSint
lshr_second_arg(a, b, c)
uSint a;
uSint b;
Sint c;
{
  return b >> c;
}

static uSint
lshr_local(a, b)
uSint a;
Sint b;
{
  uSint x;

  x = a >> b;
  return x;
}

static uSint
lshr_reuse_left(a, b)
uSint a;
Sint b;
{
  a = a >> b;
  return a;
}

static uSint
lshr_reuse_count(a, b)
uSint a;
Sint b;
{
  b = (Sint)(a >> b);
  return (uSint)b;
}

static uSint
lshr_after_add(a, b, c)
uSint a;
uSint b;
Sint c;
{
  uSint x;

  x = a + b;
  return x >> c;
}

static uSint
lshr_after_sub(a, b, c)
uSint a;
uSint b;
Sint c;
{
  uSint x;

  x = a - b;
  return x >> c;
}

static uSint
lshr_after_and(a, b, c)
uSint a;
uSint b;
Sint c;
{
  uSint x;

  x = a & b;
  return x >> c;
}

static uSint
lshr_after_xor(a, b, c)
uSint a;
uSint b;
Sint c;
{
  uSint x;

  x = a ^ b;
  return x >> c;
}

static uSint
lshr_after_or(a, b, c)
uSint a;
uSint b;
Sint c;
{
  uSint x;

  x = a | b;
  return x >> c;
}

static uSint
lshr_call_count(a)
uSint a;
{
  return a >> f();
}

static uSint
lshr_ucall_count(a)
uSint a;
{
  return a >> uf();
}

static uSint
lshr_call_value(b)
Sint b;
{
  return uf() >> b;
}

/*
 * Constant-count forms.
 */

static uSint
lshri_0(a)
uSint a;
{
  return a >> 0;
}

static uSint
lshri_1(a)
uSint a;
{
  return a >> 1;
}

static uSint
lshri_2(a)
uSint a;
{
  return a >> 2;
}

static uSint
lshri_3(a)
uSint a;
{
  return a >> 3;
}

static uSint
lshri_4(a)
uSint a;
{
  return a >> 4;
}

static uSint
lshri_5(a)
uSint a;
{
  return a >> 5;
}

static uSint
lshri_8(a)
uSint a;
{
  return a >> 8;
}

static uSint
lshri_9(a)
uSint a;
{
  return a >> 9;
}

static uSint
lshri_17(a)
uSint a;
{
  return a >> 17;
}

static uSint
lshri_18(a)
uSint a;
{
  return a >> 18;
}

static uSint
lshri_19(a)
uSint a;
{
  return a >> 19;
}

static uSint
lshri_27(a)
uSint a;
{
  return a >> 27;
}

static uSint
lshri_35(a)
uSint a;
{
  return a >> 35;
}

/*
 * High-bit pressure.  Logical shift must not sign-fill.
 */

static uSint
lshri_high_1(a)
uSint a;
{
  return (a | 0400000000000) >> 1;
}

static uSint
lshri_high_4(a)
uSint a;
{
  return (a | 0400000000000) >> 4;
}

static uSint
lshri_high_18(a)
uSint a;
{
  return (a | 0400000000000) >> 18;
}

static uSint
lshri_high_35(a)
uSint a;
{
  return (a | 0400000000000) >> 35;
}

static uSint
lshri_const_high()
{
  return 0400000000000 >> 1;
}

static uSint
lshri_const_allones()
{
  return 0777777777777 >> 1;
}

static uSint
lshri_full_const()
{
  return 0123456123456 >> 3;
}

/*
 * Memory/global value forms.
 */

static uSint
lshr_mem_value(p, b)
uSint *p;
Sint b;
{
  return *p >> b;
}

static uSint
lshr_volatile_mem_value(p, b)
volatile uSint *p;
Sint b;
{
  return *p >> b;
}

static uSint
lshr_global_value(b)
Sint b;
{
  return lshr_ga >> b;
}

static uSint
lshr_global_b_value(b)
Sint b;
{
  return lshr_gb >> b;
}

static uSint
lshr_volatile_global_value(b)
Sint b;
{
  return lshr_vga >> b;
}

static uSint
lshr_array_value(i, b)
Sint i;
Sint b;
{
  return lshr_buf[i & 017] >> b;
}

static uSint
lshr_ptr_array_value(p, i, b)
uSint *p;
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

static uSint
lshr_mem_count(a, p)
uSint a;
Sint *p;
{
  return a >> *p;
}

static uSint
lshr_umem_count(a, p)
uSint a;
uSint *p;
{
  return a >> *p;
}

static uSint
lshr_volatile_mem_count(a, p)
uSint a;
volatile Sint *p;
{
  return a >> *p;
}

static uSint
lshr_global_count(a)
uSint a;
{
  return a >> lshr_count;
}

static uSint
lshr_uglobal_count(a)
uSint a;
{
  return a >> lshr_ucount;
}

static uSint
lshr_volatile_global_count(a)
uSint a;
{
  return a >> lshr_vcount;
}

static uSint
lshr_volatile_uglobal_count(a)
uSint a;
{
  return a >> lshr_vucount;
}

static uSint
lshr_array_count(a, i)
uSint a;
Sint i;
{
  return a >> lshr_counts[i & 017];
}

static uSint
lshr_uarray_count(a, i)
uSint a;
Sint i;
{
  return a >> lshr_ucounts[i & 017];
}

static uSint
lshr_mem_value_mem_count(p, q)
uSint *p;
Sint *q;
{
  return *p >> *q;
}

static uSint
lshr_global_value_global_count()
{
  return lshr_ga >> lshr_count;
}

/*
 * Struct addressing forms.
 */

static uSint
lshr_struct_value_a(p, b)
struct lshr_pair *p;
Sint b;
{
  return p->a >> b;
}

static uSint
lshr_struct_value_b(p, b)
struct lshr_pair *p;
Sint b;
{
  return p->b >> b;
}

static uSint
lshr_struct_count_a(a, p)
uSint a;
struct lshr_count_pair *p;
{
  return a >> p->a;
}

static uSint
lshr_struct_count_b(a, p)
uSint a;
struct lshr_count_pair *p;
{
  return a >> p->b;
}

static uSint
lshr_struct_both(p)
struct lshr_pair *p;
{
  return p->a >> p->b;
}

static uSint
lshr_global_struct_value(b)
Sint b;
{
  return lshr_gp.a >> b;
}

static uSint
lshr_global_struct_count(a)
uSint a;
{
  return a >> lshr_cgp.b;
}

static uSint
lshr_global_struct_three()
{
  return lshr_gt.a >> lshr_gt.c;
}

/*
 * Count plus constant forms.  These are intended to hit
 * *LSH_right_plus:
 *
 *   x >> (n + K)
 */

static uSint
lshr_count_plus_1(a, n)
uSint a;
Sint n;
{
  return a >> (n + 1);
}

static uSint
lshr_count_plus_2(a, n)
uSint a;
Sint n;
{
  return a >> (n + 2);
}

static uSint
lshr_count_plus_7(a, n)
uSint a;
Sint n;
{
  return a >> (n + 7);
}

static uSint
lshr_count_plus_18(a, n)
uSint a;
Sint n;
{
  return a >> (n + 18);
}

static uSint
lshr_count_minus_1(a, n)
uSint a;
Sint n;
{
  return a >> (n - 1);
}

static uSint
lshr_count_minus_2(a, n)
uSint a;
Sint n;
{
  return a >> (n - 2);
}

static uSint
lshr_ucount_plus_1(a, n)
uSint a;
uSint n;
{
  return a >> (n + 1);
}

static uSint
lshr_ucount_plus_8(a, n)
uSint a;
uSint n;
{
  return a >> (n + 8);
}

static uSint
lshr_mem_count_plus(a, p)
uSint a;
Sint *p;
{
  return a >> (*p + 1);
}

static uSint
lshr_array_count_plus(a, i)
uSint a;
Sint i;
{
  return a >> (lshr_counts[i & 017] + 1);
}

static uSint
lshr_struct_count_plus(a, p)
uSint a;
struct lshr_count_pair *p;
{
  return a >> (p->b + 1);
}

/*
 * QI/HI promoted operands.  These should become SImode logical right
 * shifts after unsigned promotion/zero extension.
 */

static uSint
lshr_uqi_value(a, b)
uQint a;
Sint b;
{
  return a >> b;
}

static uSint
lshr_uhi_value(a, b)
uHint a;
Sint b;
{
  return a >> b;
}

static uSint
lshr_qi_value_cast(a, b)
Qint a;
Sint b;
{
  return ((uSint)a) >> b;
}

static uSint
lshr_hi_value_cast(a, b)
Hint a;
Sint b;
{
  return ((uSint)a) >> b;
}

static uSint
lshr_uqi_count(a, b)
uSint a;
uQint b;
{
  return a >> b;
}

static uSint
lshr_uhi_count(a, b)
uSint a;
uHint b;
{
  return a >> b;
}

static uSint
lshr_qi_count_cast(a, b)
uSint a;
Qint b;
{
  return a >> b;
}

static uSint
lshr_hi_count_cast(a, b)
uSint a;
Hint b;
{
  return a >> b;
}

/*
 * Store result forms.
 */

static void
lshr_store_ptr(dst, a, b)
uSint *dst;
uSint a;
Sint b;
{
  *dst = a >> b;
}

static uSint
lshr_store_ptr_return(dst, a, b)
uSint *dst;
uSint a;
Sint b;
{
  return *dst = a >> b;
}

static void
lshr_store_global(a, b)
uSint a;
Sint b;
{
  lshr_ga = a >> b;
}

static uSint
lshr_store_global_return(a, b)
uSint a;
Sint b;
{
  return lshr_ga = a >> b;
}

static void
lshr_store_array(i, a, b)
Sint i;
uSint a;
Sint b;
{
  lshr_buf[i & 017] = a >> b;
}

static uSint
lshr_store_array_return(i, a, b)
Sint i;
uSint a;
Sint b;
{
  return lshr_buf[i & 017] = a >> b;
}

/*
 * In-place logical right shifts.
 */

static void
lshr_inplace_ptr(p, b)
uSint *p;
Sint b;
{
  *p = *p >> b;
}

static uSint
lshr_inplace_ptr_return(p, b)
uSint *p;
Sint b;
{
  return *p = *p >> b;
}

static void
lshr_inplace_global(b)
Sint b;
{
  lshr_ga = lshr_ga >> b;
}

static uSint
lshr_inplace_global_return(b)
Sint b;
{
  return lshr_ga = lshr_ga >> b;
}

static void
lshr_inplace_array(i, b)
Sint i;
Sint b;
{
  lshr_buf[i & 017] = lshr_buf[i & 017] >> b;
}

static uSint
lshr_inplace_array_return(i, b)
Sint i;
Sint b;
{
  return lshr_buf[i & 017] = lshr_buf[i & 017] >> b;
}

/*
 * Result-use forms.
 */

static uSint
lshr_plus(a, b, c)
uSint a;
Sint b;
uSint c;
{
  return (a >> b) + c;
}

static uSint
lshr_minus(a, b, c)
uSint a;
Sint b;
uSint c;
{
  return (a >> b) - c;
}

static uSint
lshr_xor(a, b, c)
uSint a;
Sint b;
uSint c;
{
  return (a >> b) ^ c;
}

static uSint
lshr_or(a, b, c)
uSint a;
Sint b;
uSint c;
{
  return (a >> b) | c;
}

static uSint
lshr_and(a, b, c)
uSint a;
Sint b;
uSint c;
{
  return (a >> b) & c;
}

static uSint
lshr_twice(a, b, c)
uSint a;
Sint b;
Sint c;
{
  uSint x;

  x = a >> b;
  return x >> c;
}

static uSint
lshr_mix(a, b, c)
uSint a;
Sint b;
uSint c;
{
  uSint x;
  uSint y;

  x = a >> b;
  y = c >> 1;
  return x ^ y;
}

/*
 * Branch and compare uses after logical right shift.
 */

static Sint
lshr_eq_zero(a, b)
uSint a;
Sint b;
{
  return (a >> b) == 0;
}

static Sint
lshr_ne_zero(a, b)
uSint a;
Sint b;
{
  return (a >> b) != 0;
}

static Sint
lshr_lt_const(a, b)
uSint a;
Sint b;
{
  return (a >> b) < 012345;
}

static Sint
lshr_gt_const(a, b)
uSint a;
Sint b;
{
  return (a >> b) > 012345;
}

static Sint
lshr_high_after_shift(a, b)
uSint a;
Sint b;
{
  return ((a | 0400000000000) >> b) > 0777777;
}

static Sint
lshr_range(a, b)
uSint a;
Sint b;
{
  uSint x;

  x = a >> b;
  if (x < 0100)
    return -1;
  if (x > 0777777)
    return 1;
  return 0;
}

/*
 * Unsigned division/modulo by powers of two.  Keep these here as
 * review pressure for logical-right-shift-like lowering.  General
 * unsigned division/modulo belongs to the misc/libgcc fallback tests.
 */

static uSint
lshr_udiv_2(a)
uSint a;
{
  return a / 2;
}

static uSint
lshr_udiv_4(a)
uSint a;
{
  return a / 4;
}

static uSint
lshr_udiv_8(a)
uSint a;
{
  return a / 8;
}

static uSint
lshr_udiv_512(a)
uSint a;
{
  return a / 01000;
}

static uSint
lshr_umod_2(a)
uSint a;
{
  return a % 2;
}

static uSint
lshr_umod_4(a)
uSint a;
{
  return a % 4;
}

static uSint
lshr_umod_8(a)
uSint a;
{
  return a % 8;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static uSint
lshr_after_call(p, b)
uSint *p;
Sint b;
{
  uSint x;

  x = *p;
  clobber();
  return x >> b;
}

static uSint
lshr_count_after_call(a, p)
uSint a;
Sint *p;
{
  Sint n;

  n = *p;
  clobber();
  return a >> n;
}

static uSint
lshr_store_after_call(p, a)
uSint *p;
uSint a;
{
  Sint n;

  n = f();
  clobber();
  return *p = a >> n;
}

static uSint
lshr_global_after_call(b)
Sint b;
{
  uSint x;

  x = uf();
  clobber();
  return x >> b;
}
