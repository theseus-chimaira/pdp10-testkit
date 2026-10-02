#include "insns.h"

/*
 * SImode rotate-right pattern pressure.
 *
 * Intended pattern:
 *   rotrsi3
 *
 * PDP-6/KA10-relevant backend forms:
 *   ROT AC,(R)       variable count in register, negated by expander
 *   ROT AC,K         constant count after negation
 *   ROT AC,@MEM      count from memory operand, if reload keeps it there
 *   ROT AC,K(R)      plus-form count from register plus small constant
 *
 * This is a backend rotate pattern test.  Ordinary C has no rotate
 * operator, so the tests use canonical rotate-right idioms:
 *
 *   (x >> n) | (x << (36 - n))
 *
 * and constant-count variants.
 *
 * Do not use inline assembly here.
 */

extern uSint uf(void);
extern Sint f(void);
extern void clobber(void);

static uSint rotr_ga;
static uSint rotr_gb;
static volatile uSint rotr_vga;
static uSint rotr_buf[16];

static Sint rotr_count;
static volatile Sint rotr_vcount;
static Sint rotr_counts[16];

static uSint rotr_ucount;
static volatile uSint rotr_vucount;
static uSint rotr_ucounts[16];

struct rotr_pair {
  uSint a;
  uSint b;
};

struct rotr_three {
  uSint a;
  uSint b;
  uSint c;
};

struct rotr_count_pair {
  Sint a;
  Sint b;
};

static struct rotr_pair rotr_gp;
static struct rotr_three rotr_gt;
static struct rotr_count_pair rotr_cgp;

/*
 * Original expected basename shape.
 */

uSint
rotrsi3(a, n)
uSint a;
Sint n;
{
  return (a >> n) | (a << (36 - n));
}

/*
 * Basic variable-count rotate-right idioms.
 */

static uSint
rotr_reg_reg(a, n)
uSint a;
Sint n;
{
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_reg_ureg(a, n)
uSint a;
uSint n;
{
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_second_arg(a, b, n)
uSint a;
uSint b;
Sint n;
{
  return (b >> n) | (b << (36 - n));
}

static uSint
rotr_local(a, n)
uSint a;
Sint n;
{
  uSint x;

  x = (a >> n) | (a << (36 - n));
  return x;
}

static uSint
rotr_reuse_value(a, n)
uSint a;
Sint n;
{
  a = (a >> n) | (a << (36 - n));
  return a;
}

static uSint
rotr_reuse_count(a, n)
uSint a;
Sint n;
{
  n = (Sint)((a >> n) | (a << (36 - n)));
  return (uSint)n;
}

static uSint
rotr_after_add(a, b, n)
uSint a;
uSint b;
Sint n;
{
  uSint x;

  x = a + b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_after_sub(a, b, n)
uSint a;
uSint b;
Sint n;
{
  uSint x;

  x = a - b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_after_and(a, b, n)
uSint a;
uSint b;
Sint n;
{
  uSint x;

  x = a & b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_after_xor(a, b, n)
uSint a;
uSint b;
Sint n;
{
  uSint x;

  x = a ^ b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_after_or(a, b, n)
uSint a;
uSint b;
Sint n;
{
  uSint x;

  x = a | b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_call_count(a)
uSint a;
{
  Sint n;

  n = f();
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_ucall_count(a)
uSint a;
{
  uSint n;

  n = uf();
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_call_value(n)
Sint n;
{
  uSint x;

  x = uf();
  return (x >> n) | (x << (36 - n));
}

/*
 * Constant-count rotate-right idioms.
 */

static uSint
rotri_1(a)
uSint a;
{
  return (a >> 1) | (a << 35);
}

static uSint
rotri_2(a)
uSint a;
{
  return (a >> 2) | (a << 34);
}

static uSint
rotri_3(a)
uSint a;
{
  return (a >> 3) | (a << 33);
}

static uSint
rotri_4(a)
uSint a;
{
  return (a >> 4) | (a << 32);
}

static uSint
rotri_5(a)
uSint a;
{
  return (a >> 5) | (a << 31);
}

static uSint
rotri_8(a)
uSint a;
{
  return (a >> 8) | (a << 28);
}

static uSint
rotri_9(a)
uSint a;
{
  return (a >> 9) | (a << 27);
}

static uSint
rotri_17(a)
uSint a;
{
  return (a >> 17) | (a << 19);
}

static uSint
rotri_18(a)
uSint a;
{
  return (a >> 18) | (a << 18);
}

static uSint
rotri_19(a)
uSint a;
{
  return (a >> 19) | (a << 17);
}

static uSint
rotri_27(a)
uSint a;
{
  return (a >> 27) | (a << 9);
}

static uSint
rotri_35(a)
uSint a;
{
  return (a >> 35) | (a << 1);
}

/*
 * High-bit and all-bit pressure.  ROT must preserve wrapped bits.
 */

static uSint
rotri_high_1(a)
uSint a;
{
  a |= 0400000000000;
  return (a >> 1) | (a << 35);
}

static uSint
rotri_high_4(a)
uSint a;
{
  a |= 0400000000000;
  return (a >> 4) | (a << 32);
}

static uSint
rotri_high_18(a)
uSint a;
{
  a |= 0400000000000;
  return (a >> 18) | (a << 18);
}

static uSint
rotri_high_35(a)
uSint a;
{
  a |= 0400000000000;
  return (a >> 35) | (a << 1);
}

static uSint
rotri_const_high()
{
  return (0400000000000 >> 1) | (0400000000000 << 35);
}

static uSint
rotri_const_allones()
{
  return (0777777777777 >> 1) | (0777777777777 << 35);
}

static uSint
rotri_const_full()
{
  return (0123456123456 >> 7) | (0123456123456 << 29);
}

/*
 * Memory/global value forms.
 */

static uSint
rotr_mem_value(p, n)
uSint *p;
Sint n;
{
  uSint x;

  x = *p;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_volatile_mem_value(p, n)
volatile uSint *p;
Sint n;
{
  uSint x;

  x = *p;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_global_value(n)
Sint n;
{
  uSint x;

  x = rotr_ga;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_global_b_value(n)
Sint n;
{
  uSint x;

  x = rotr_gb;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_volatile_global_value(n)
Sint n;
{
  uSint x;

  x = rotr_vga;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_array_value(i, n)
Sint i;
Sint n;
{
  uSint x;

  x = rotr_buf[i & 017];
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_ptr_array_value(p, i, n)
uSint *p;
Sint i;
Sint n;
{
  uSint x;

  x = p[i & 017];
  return (x >> n) | (x << (36 - n));
}

/*
 * Memory/global count forms.  These are meant to pressure the m-count
 * alternative where possible, although reload may still choose a
 * register.
 */

static uSint
rotr_mem_count(a, p)
uSint a;
Sint *p;
{
  Sint n;

  n = *p;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_umem_count(a, p)
uSint a;
uSint *p;
{
  uSint n;

  n = *p;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_volatile_mem_count(a, p)
uSint a;
volatile Sint *p;
{
  Sint n;

  n = *p;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_global_count(a)
uSint a;
{
  Sint n;

  n = rotr_count;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_uglobal_count(a)
uSint a;
{
  uSint n;

  n = rotr_ucount;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_volatile_global_count(a)
uSint a;
{
  Sint n;

  n = rotr_vcount;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_volatile_uglobal_count(a)
uSint a;
{
  uSint n;

  n = rotr_vucount;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_array_count(a, i)
uSint a;
Sint i;
{
  Sint n;

  n = rotr_counts[i & 017];
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_uarray_count(a, i)
uSint a;
Sint i;
{
  uSint n;

  n = rotr_ucounts[i & 017];
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_mem_value_mem_count(p, q)
uSint *p;
Sint *q;
{
  uSint x;
  Sint n;

  x = *p;
  n = *q;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_global_value_global_count()
{
  uSint x;
  Sint n;

  x = rotr_ga;
  n = rotr_count;
  return (x >> n) | (x << (36 - n));
}

/*
 * Struct addressing forms.
 */

static uSint
rotr_struct_value_a(p, n)
struct rotr_pair *p;
Sint n;
{
  uSint x;

  x = p->a;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_struct_value_b(p, n)
struct rotr_pair *p;
Sint n;
{
  uSint x;

  x = p->b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_struct_count_a(a, p)
uSint a;
struct rotr_count_pair *p;
{
  Sint n;

  n = p->a;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_struct_count_b(a, p)
uSint a;
struct rotr_count_pair *p;
{
  Sint n;

  n = p->b;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_struct_both(p)
struct rotr_pair *p;
{
  uSint x;
  uSint n;

  x = p->a;
  n = p->b;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_global_struct_value(n)
Sint n;
{
  uSint x;

  x = rotr_gp.a;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_global_struct_count(a)
uSint a;
{
  Sint n;

  n = rotr_cgp.b;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_global_struct_three()
{
  uSint x;
  uSint n;

  x = rotr_gt.a;
  n = rotr_gt.c;
  return (x >> n) | (x << (36 - n));
}

/*
 * Count plus constant forms.  These are intended to hit
 * *ROT_right_plus:
 *
 *   rotatert(x, n + K)
 */

static uSint
rotr_count_plus_1(a, n)
uSint a;
Sint n;
{
  return (a >> (n + 1)) | (a << (36 - (n + 1)));
}

static uSint
rotr_count_plus_2(a, n)
uSint a;
Sint n;
{
  return (a >> (n + 2)) | (a << (36 - (n + 2)));
}

static uSint
rotr_count_plus_7(a, n)
uSint a;
Sint n;
{
  return (a >> (n + 7)) | (a << (36 - (n + 7)));
}

static uSint
rotr_count_plus_18(a, n)
uSint a;
Sint n;
{
  return (a >> (n + 18)) | (a << (36 - (n + 18)));
}

static uSint
rotr_count_minus_1(a, n)
uSint a;
Sint n;
{
  return (a >> (n - 1)) | (a << (36 - (n - 1)));
}

static uSint
rotr_count_minus_2(a, n)
uSint a;
Sint n;
{
  return (a >> (n - 2)) | (a << (36 - (n - 2)));
}

static uSint
rotr_ucount_plus_1(a, n)
uSint a;
uSint n;
{
  return (a >> (n + 1)) | (a << (36 - (n + 1)));
}

static uSint
rotr_ucount_plus_8(a, n)
uSint a;
uSint n;
{
  return (a >> (n + 8)) | (a << (36 - (n + 8)));
}

static uSint
rotr_mem_count_plus(a, p)
uSint a;
Sint *p;
{
  Sint n;

  n = *p + 1;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_array_count_plus(a, i)
uSint a;
Sint i;
{
  Sint n;

  n = rotr_counts[i & 017] + 1;
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_struct_count_plus(a, p)
uSint a;
struct rotr_count_pair *p;
{
  Sint n;

  n = p->b + 1;
  return (a >> n) | (a << (36 - n));
}

/*
 * QI/HI promoted operands.  These should become SImode rotate idioms
 * after promotion/extension.
 */

static uSint
rotr_uqi_value(a, n)
uQint a;
Sint n;
{
  return ((uSint)a >> n) | ((uSint)a << (36 - n));
}

static uSint
rotr_uhi_value(a, n)
uHint a;
Sint n;
{
  return ((uSint)a >> n) | ((uSint)a << (36 - n));
}

static uSint
rotr_qi_value_cast(a, n)
Qint a;
Sint n;
{
  uSint x;

  x = (uSint)a;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_hi_value_cast(a, n)
Hint a;
Sint n;
{
  uSint x;

  x = (uSint)a;
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_uqi_count(a, n)
uSint a;
uQint n;
{
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_uhi_count(a, n)
uSint a;
uHint n;
{
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_qi_count_cast(a, n)
uSint a;
Qint n;
{
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_hi_count_cast(a, n)
uSint a;
Hint n;
{
  return (a >> n) | (a << (36 - n));
}

/*
 * Store result forms.
 */

static void
rotr_store_ptr(dst, a, n)
uSint *dst;
uSint a;
Sint n;
{
  *dst = (a >> n) | (a << (36 - n));
}

static uSint
rotr_store_ptr_return(dst, a, n)
uSint *dst;
uSint a;
Sint n;
{
  return *dst = (a >> n) | (a << (36 - n));
}

static void
rotr_store_global(a, n)
uSint a;
Sint n;
{
  rotr_ga = (a >> n) | (a << (36 - n));
}

static uSint
rotr_store_global_return(a, n)
uSint a;
Sint n;
{
  return rotr_ga = (a >> n) | (a << (36 - n));
}

static void
rotr_store_array(i, a, n)
Sint i;
uSint a;
Sint n;
{
  rotr_buf[i & 017] = (a >> n) | (a << (36 - n));
}

static uSint
rotr_store_array_return(i, a, n)
Sint i;
uSint a;
Sint n;
{
  return rotr_buf[i & 017] = (a >> n) | (a << (36 - n));
}

/*
 * In-place rotate-right idioms.
 */

static void
rotr_inplace_ptr(p, n)
uSint *p;
Sint n;
{
  *p = (*p >> n) | (*p << (36 - n));
}

static uSint
rotr_inplace_ptr_return(p, n)
uSint *p;
Sint n;
{
  return *p = (*p >> n) | (*p << (36 - n));
}

static void
rotr_inplace_global(n)
Sint n;
{
  rotr_ga = (rotr_ga >> n) | (rotr_ga << (36 - n));
}

static uSint
rotr_inplace_global_return(n)
Sint n;
{
  return rotr_ga = (rotr_ga >> n) | (rotr_ga << (36 - n));
}

static void
rotr_inplace_array(i, n)
Sint i;
Sint n;
{
  rotr_buf[i & 017] =
      (rotr_buf[i & 017] >> n) | (rotr_buf[i & 017] << (36 - n));
}

static uSint
rotr_inplace_array_return(i, n)
Sint i;
Sint n;
{
  return rotr_buf[i & 017] =
      (rotr_buf[i & 017] >> n) | (rotr_buf[i & 017] << (36 - n));
}

/*
 * Result-use forms.
 */

static uSint
rotr_plus(a, n, c)
uSint a;
Sint n;
uSint c;
{
  return ((a >> n) | (a << (36 - n))) + c;
}

static uSint
rotr_minus(a, n, c)
uSint a;
Sint n;
uSint c;
{
  return ((a >> n) | (a << (36 - n))) - c;
}

static uSint
rotr_xor(a, n, c)
uSint a;
Sint n;
uSint c;
{
  return ((a >> n) | (a << (36 - n))) ^ c;
}

static uSint
rotr_or(a, n, c)
uSint a;
Sint n;
uSint c;
{
  return ((a >> n) | (a << (36 - n))) | c;
}

static uSint
rotr_and(a, n, c)
uSint a;
Sint n;
uSint c;
{
  return ((a >> n) | (a << (36 - n))) & c;
}

static uSint
rotr_twice(a, n, m)
uSint a;
Sint n;
Sint m;
{
  uSint x;

  x = (a >> n) | (a << (36 - n));
  return (x >> m) | (x << (36 - m));
}

static uSint
rotr_mix(a, n, c)
uSint a;
Sint n;
uSint c;
{
  uSint x;
  uSint y;

  x = (a >> n) | (a << (36 - n));
  y = (c >> 1) | (c << 35);
  return x ^ y;
}

/*
 * Branch and compare uses after rotate-right.
 */

static Sint
rotr_eq_zero(a, n)
uSint a;
Sint n;
{
  return ((a >> n) | (a << (36 - n))) == 0;
}

static Sint
rotr_ne_zero(a, n)
uSint a;
Sint n;
{
  return ((a >> n) | (a << (36 - n))) != 0;
}

static Sint
rotr_lt_const(a, n)
uSint a;
Sint n;
{
  return ((a >> n) | (a << (36 - n))) < 012345;
}

static Sint
rotr_gt_const(a, n)
uSint a;
Sint n;
{
  return ((a >> n) | (a << (36 - n))) > 012345;
}

static Sint
rotr_high_after_rotate(a, n)
uSint a;
Sint n;
{
  uSint x;

  x = (a | 0400000000000);
  return ((x >> n) | (x << (36 - n))) > 0777777;
}

static Sint
rotr_range(a, n)
uSint a;
Sint n;
{
  uSint x;

  x = (a >> n) | (a << (36 - n));
  if (x < 0100)
    return -1;
  if (x > 0777777)
    return 1;
  return 0;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static uSint
rotr_after_call(p, n)
uSint *p;
Sint n;
{
  uSint x;

  x = *p;
  clobber();
  return (x >> n) | (x << (36 - n));
}

static uSint
rotr_count_after_call(a, p)
uSint a;
Sint *p;
{
  Sint n;

  n = *p;
  clobber();
  return (a >> n) | (a << (36 - n));
}

static uSint
rotr_store_after_call(p, a)
uSint *p;
uSint a;
{
  Sint n;

  n = f();
  clobber();
  return *p = (a >> n) | (a << (36 - n));
}

static uSint
rotr_global_after_call(n)
Sint n;
{
  uSint x;

  x = uf();
  clobber();
  return (x >> n) | (x << (36 - n));
}
