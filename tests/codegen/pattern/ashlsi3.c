#include "insns.h"

/*
 * SImode arithmetic-left-shift pattern pressure.
 *
 * Intended pattern:
 *   ashlsi3
 *
 * PDP-6/KA10-relevant backend forms:
 *   LSH AC,(R)       variable count in register
 *   LSH AC,K         constant count
 *   LSH AC,@MEM      count from memory operand, if reload keeps it there
 *   LSH AC,K(R)      plus-form count from register plus small constant
 *
 * In GCC RTL, left shift is ashift:SI for both signed and unsigned C
 * integer shifts.  This test therefore includes both Sint and uSint
 * entry points.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint ashl_ga;
static Sint ashl_gb;
static volatile Sint ashl_vga;
static Sint ashl_buf[16];

static uSint uashl_ga;
static uSint uashl_gb;
static volatile uSint uashl_vga;
static uSint uashl_buf[16];

static Sint ashl_count;
static volatile Sint ashl_vcount;
static Sint ashl_counts[16];

struct ashl_pair {
  Sint a;
  Sint b;
};

struct uashl_pair {
  uSint a;
  uSint b;
};

struct ashl_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct ashl_pair ashl_gp;
static struct uashl_pair uashl_gp;
static struct ashl_three ashl_gt;

/*
 * Original expected basename shape.
 */

Sint
ashlsi3(a, b)
Sint a;
Sint b;
{
  return a << b;
}

/*
 * Basic variable-count forms.
 */

static Sint
ashl_reg_reg(a, b)
Sint a;
Sint b;
{
  return a << b;
}

static uSint
uashl_reg_reg(a, b)
uSint a;
uSint b;
{
  return a << b;
}

static Sint
ashl_second_arg(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return b << c;
}

static Sint
ashl_local(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a << b;
  return x;
}

static uSint
uashl_local(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a << b;
  return x;
}

static Sint
ashl_reuse_left(a, b)
Sint a;
Sint b;
{
  a = a << b;
  return a;
}

static Sint
ashl_reuse_count(a, b)
Sint a;
Sint b;
{
  b = a << b;
  return b;
}

static Sint
ashl_after_add(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a + b;
  return x << c;
}

static Sint
ashl_after_sub(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a - b;
  return x << c;
}

static Sint
ashl_after_and(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a & b;
  return x << c;
}

static Sint
ashl_after_xor(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a ^ b;
  return x << c;
}

static Sint
ashl_call_count(a)
Sint a;
{
  return a << f();
}

static Sint
ashl_call_value(b)
Sint b;
{
  return f() << b;
}

static uSint
uashl_call_count(a)
uSint a;
{
  return a << uf();
}

/*
 * Constant-count forms.
 */

static Sint
ashli_0(a)
Sint a;
{
  return a << 0;
}

static Sint
ashli_1(a)
Sint a;
{
  return a << 1;
}

static Sint
ashli_2(a)
Sint a;
{
  return a << 2;
}

static Sint
ashli_3(a)
Sint a;
{
  return a << 3;
}

static Sint
ashli_4(a)
Sint a;
{
  return a << 4;
}

static Sint
ashli_5(a)
Sint a;
{
  return a << 5;
}

static Sint
ashli_8(a)
Sint a;
{
  return a << 8;
}

static Sint
ashli_9(a)
Sint a;
{
  return a << 9;
}

static Sint
ashli_17(a)
Sint a;
{
  return a << 17;
}

static Sint
ashli_18(a)
Sint a;
{
  return a << 18;
}

static Sint
ashli_19(a)
Sint a;
{
  return a << 19;
}

static Sint
ashli_27(a)
Sint a;
{
  return a << 27;
}

static Sint
ashli_35(a)
Sint a;
{
  return a << 35;
}

static uSint
uashli_1(a)
uSint a;
{
  return a << 1;
}

static uSint
uashli_8(a)
uSint a;
{
  return a << 8;
}

static uSint
uashli_18(a)
uSint a;
{
  return a << 18;
}

static uSint
uashli_35(a)
uSint a;
{
  return a << 35;
}

/*
 * Memory/global value forms.
 */

static Sint
ashl_mem_value(p, b)
Sint *p;
Sint b;
{
  return *p << b;
}

static uSint
uashl_mem_value(p, b)
uSint *p;
uSint b;
{
  return *p << b;
}

static Sint
ashl_volatile_mem_value(p, b)
volatile Sint *p;
Sint b;
{
  return *p << b;
}

static Sint
ashl_global_value(b)
Sint b;
{
  return ashl_ga << b;
}

static Sint
ashl_global_b_value(b)
Sint b;
{
  return ashl_gb << b;
}

static Sint
ashl_volatile_global_value(b)
Sint b;
{
  return ashl_vga << b;
}

static uSint
uashl_global_value(b)
uSint b;
{
  return uashl_ga << b;
}

static uSint
uashl_volatile_global_value(b)
uSint b;
{
  return uashl_vga << b;
}

static Sint
ashl_array_value(i, b)
Sint i;
Sint b;
{
  return ashl_buf[i & 017] << b;
}

static uSint
uashl_array_value(i, b)
Sint i;
uSint b;
{
  return uashl_buf[i & 017] << b;
}

static Sint
ashl_ptr_array_value(p, i, b)
Sint *p;
Sint i;
Sint b;
{
  return p[i & 017] << b;
}

/*
 * Memory/global count forms.  These are meant to pressure the m-count
 * alternative where possible, although reload may still choose a
 * register.
 */

static Sint
ashl_mem_count(a, p)
Sint a;
Sint *p;
{
  return a << *p;
}

static uSint
uashl_mem_count(a, p)
uSint a;
uSint *p;
{
  return a << *p;
}

static Sint
ashl_volatile_mem_count(a, p)
Sint a;
volatile Sint *p;
{
  return a << *p;
}

static Sint
ashl_global_count(a)
Sint a;
{
  return a << ashl_count;
}

static Sint
ashl_volatile_global_count(a)
Sint a;
{
  return a << ashl_vcount;
}

static Sint
ashl_array_count(a, i)
Sint a;
Sint i;
{
  return a << ashl_counts[i & 017];
}

static Sint
ashl_mem_value_mem_count(p, q)
Sint *p;
Sint *q;
{
  return *p << *q;
}

static Sint
ashl_global_value_global_count()
{
  return ashl_ga << ashl_count;
}

/*
 * Struct addressing forms.
 */

static Sint
ashl_struct_value_a(p, b)
struct ashl_pair *p;
Sint b;
{
  return p->a << b;
}

static Sint
ashl_struct_value_b(p, b)
struct ashl_pair *p;
Sint b;
{
  return p->b << b;
}

static Sint
ashl_struct_count_a(a, p)
Sint a;
struct ashl_pair *p;
{
  return a << p->a;
}

static Sint
ashl_struct_count_b(a, p)
Sint a;
struct ashl_pair *p;
{
  return a << p->b;
}

static Sint
ashl_struct_both(p)
struct ashl_pair *p;
{
  return p->a << p->b;
}

static uSint
uashl_struct_both(p)
struct uashl_pair *p;
{
  return p->a << p->b;
}

static Sint
ashl_global_struct_value(b)
Sint b;
{
  return ashl_gp.a << b;
}

static Sint
ashl_global_struct_count(a)
Sint a;
{
  return a << ashl_gp.b;
}

static Sint
ashl_global_struct_three()
{
  return ashl_gt.a << ashl_gt.c;
}

/*
 * Count plus constant forms.  These are intended to hit *LSH_left_plus:
 *
 *   x << (n + K)
 */

static Sint
ashl_count_plus_1(a, n)
Sint a;
Sint n;
{
  return a << (n + 1);
}

static Sint
ashl_count_plus_2(a, n)
Sint a;
Sint n;
{
  return a << (n + 2);
}

static Sint
ashl_count_plus_7(a, n)
Sint a;
Sint n;
{
  return a << (n + 7);
}

static Sint
ashl_count_plus_18(a, n)
Sint a;
Sint n;
{
  return a << (n + 18);
}

static Sint
ashl_count_minus_1(a, n)
Sint a;
Sint n;
{
  return a << (n - 1);
}

static Sint
ashl_count_minus_2(a, n)
Sint a;
Sint n;
{
  return a << (n - 2);
}

static uSint
uashl_count_plus_1(a, n)
uSint a;
uSint n;
{
  return a << (n + 1);
}

static uSint
uashl_count_plus_8(a, n)
uSint a;
uSint n;
{
  return a << (n + 8);
}

static Sint
ashl_mem_count_plus(a, p)
Sint a;
Sint *p;
{
  return a << (*p + 1);
}

static Sint
ashl_array_count_plus(a, i)
Sint a;
Sint i;
{
  return a << (ashl_counts[i & 017] + 1);
}

static Sint
ashl_struct_count_plus(a, p)
Sint a;
struct ashl_pair *p;
{
  return a << (p->b + 1);
}

/*
 * QI/HI promoted operands.  These should still become SImode shifts
 * after promotion.
 */

static Sint
ashl_qi_value(a, b)
Qint a;
Sint b;
{
  return a << b;
}

static Sint
ashl_uqi_value(a, b)
uQint a;
Sint b;
{
  return a << b;
}

static Sint
ashl_hi_value(a, b)
Hint a;
Sint b;
{
  return a << b;
}

static Sint
ashl_uhi_value(a, b)
uHint a;
Sint b;
{
  return a << b;
}

static Sint
ashl_qi_count(a, b)
Sint a;
Qint b;
{
  return a << b;
}

static Sint
ashl_uqi_count(a, b)
Sint a;
uQint b;
{
  return a << b;
}

static Sint
ashl_hi_count(a, b)
Sint a;
Hint b;
{
  return a << b;
}

static Sint
ashl_uhi_count(a, b)
Sint a;
uHint b;
{
  return a << b;
}

/*
 * Store result forms.
 */

static void
ashl_store_ptr(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  *dst = a << b;
}

static Sint
ashl_store_ptr_return(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  return *dst = a << b;
}

static void
ashl_store_global(a, b)
Sint a;
Sint b;
{
  ashl_ga = a << b;
}

static Sint
ashl_store_global_return(a, b)
Sint a;
Sint b;
{
  return ashl_ga = a << b;
}

static void
ashl_store_array(i, a, b)
Sint i;
Sint a;
Sint b;
{
  ashl_buf[i & 017] = a << b;
}

static Sint
ashl_store_array_return(i, a, b)
Sint i;
Sint a;
Sint b;
{
  return ashl_buf[i & 017] = a << b;
}

static void
uashl_store_ptr(dst, a, b)
uSint *dst;
uSint a;
uSint b;
{
  *dst = a << b;
}

static uSint
uashl_store_ptr_return(dst, a, b)
uSint *dst;
uSint a;
uSint b;
{
  return *dst = a << b;
}

/*
 * In-place left shifts.
 */

static void
ashl_inplace_ptr(p, b)
Sint *p;
Sint b;
{
  *p = *p << b;
}

static Sint
ashl_inplace_ptr_return(p, b)
Sint *p;
Sint b;
{
  return *p = *p << b;
}

static void
ashl_inplace_global(b)
Sint b;
{
  ashl_ga = ashl_ga << b;
}

static Sint
ashl_inplace_global_return(b)
Sint b;
{
  return ashl_ga = ashl_ga << b;
}

static void
ashl_inplace_array(i, b)
Sint i;
Sint b;
{
  ashl_buf[i & 017] = ashl_buf[i & 017] << b;
}

static Sint
ashl_inplace_array_return(i, b)
Sint i;
Sint b;
{
  return ashl_buf[i & 017] = ashl_buf[i & 017] << b;
}

static void
uashl_inplace_ptr(p, b)
uSint *p;
uSint b;
{
  *p = *p << b;
}

static uSint
uashl_inplace_ptr_return(p, b)
uSint *p;
uSint b;
{
  return *p = *p << b;
}

/*
 * Result-use forms.
 */

static Sint
ashl_plus(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a << b) + c;
}

static Sint
ashl_minus(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a << b) - c;
}

static Sint
ashl_xor(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a << b) ^ c;
}

static Sint
ashl_or(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a << b) | c;
}

static Sint
ashl_and(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a << b) & c;
}

static Sint
ashl_twice(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a << b;
  return x << c;
}

static Sint
ashl_mix(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;
  Sint y;

  x = a << b;
  y = c << 1;
  return x ^ y;
}

/*
 * Branch and compare uses after left shift.
 */

static Sint
ashl_eq_zero(a, b)
Sint a;
Sint b;
{
  return (a << b) == 0;
}

static Sint
ashl_ne_zero(a, b)
Sint a;
Sint b;
{
  return (a << b) != 0;
}

static Sint
ashl_lt_zero(a, b)
Sint a;
Sint b;
{
  return (a << b) < 0;
}

static Sint
ashl_ge_zero(a, b)
Sint a;
Sint b;
{
  return (a << b) >= 0;
}

static Sint
ashl_gt_const(a, b)
Sint a;
Sint b;
{
  return (a << b) > 012345;
}

static Sint
ashl_range(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a << b;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static Sint
ashl_after_call(p, b)
Sint *p;
Sint b;
{
  Sint x;

  x = *p;
  clobber();
  return x << b;
}

static Sint
ashl_count_after_call(a, p)
Sint a;
Sint *p;
{
  Sint n;

  n = *p;
  clobber();
  return a << n;
}

static Sint
ashl_store_after_call(p, a)
Sint *p;
Sint a;
{
  Sint n;

  n = f();
  clobber();
  return *p = a << n;
}

static Sint
ashl_global_after_call(b)
Sint b;
{
  Sint x;

  x = f();
  clobber();
  return x << b;
}

