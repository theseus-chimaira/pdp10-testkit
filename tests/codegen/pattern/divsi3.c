#include "insns.h"

/*
 * divsi3 pattern coverage for PDP-6/166 and KA10.
 *
 * Signed single-word division only.
 *
 * Intended backend shapes:
 *
 *   reg = reg / immediate       IDIV / IDIVI path via temp DImode pair
 *   reg = reg / reg-or-memory   IDIVM-style path
 *   mem = reg / mem             direct memory destination shape
 *
 * modsi3 and unsigned division have their own pattern tests.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint divsi3_ga;
static Sint divsi3_gb;
static Sint divsi3_buf[16];

struct divsi3_pair {
  Sint a;
  Sint b;
};

static struct divsi3_pair divsi3_gp;

static Sint
safe_divisor(x)
Sint x;
{
  x |= 1;
  OPAQUE_REG(x);
  return x;
}

static Sint
divsi3_const_1(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 1;
}

static Sint
divsi3_const_m1(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / -1;
}

static Sint
divsi3_const_2(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 2;
}

static Sint
divsi3_const_3(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 3;
}

static Sint
divsi3_const_10(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 10;
}

static Sint
divsi3_const_octal(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 0123456;
}

static Sint
divsi3_const_neg_octal(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / -0123456;
}

static Sint
divsi3_const_low9(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 0777;
}

static Sint
divsi3_const_low18(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 0777777;
}

static Sint
divsi3_const_large(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / 0123456123456;
}

static Sint
divsi3_const_large_neg(a)
Sint a;
{
  OPAQUE_REG(a);
  return a / -0123456123;
}

static Sint
divsi3_reg_reg(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  b = safe_divisor(b);
  return a / b;
}

static Sint
divsi3_reg_reg_neg_divisor(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  b = -safe_divisor(b);
  OPAQUE_REG(b);
  return a / b;
}

static Sint
divsi3_reg_mem(a, p)
Sint a;
Sint *p;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(*p);
  return a / b;
}

static Sint
divsi3_mem_reg(p, b)
Sint *p;
Sint b;
{
  Sint a;

  a = *p;
  b = safe_divisor(b);
  return a / b;
}

static Sint
divsi3_mem_mem(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint b;

  a = *p;
  b = safe_divisor(*q);
  return a / b;
}

static Sint
divsi3_volatile_divisor(a, p)
Sint a;
volatile Sint *p;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(*p);
  return a / b;
}

static Sint
divsi3_volatile_dividend(p, b)
volatile Sint *p;
Sint b;
{
  Sint a;

  a = *p;
  b = safe_divisor(b);
  return a / b;
}

static Sint
divsi3_global_dividend(b)
Sint b;
{
  b = safe_divisor(b);
  return divsi3_ga / b;
}

static Sint
divsi3_global_divisor(a)
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(divsi3_gb);
  return a / b;
}

static Sint
divsi3_array_dividend(v, i, b)
Sint *v;
Sint i;
Sint b;
{
  Sint a;

  a = v[i & 017];
  b = safe_divisor(b);
  return a / b;
}

static Sint
divsi3_array_divisor(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(v[i & 017]);
  return a / b;
}

static Sint
divsi3_global_array_dividend(i, b)
Sint i;
Sint b;
{
  Sint a;

  a = divsi3_buf[i & 017];
  b = safe_divisor(b);
  return a / b;
}

static Sint
divsi3_global_array_divisor(a, i)
Sint a;
Sint i;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(divsi3_buf[i & 017]);
  return a / b;
}

static Sint
divsi3_struct_dividend(p, b)
struct divsi3_pair *p;
Sint b;
{
  b = safe_divisor(b);
  return p->a / b;
}

static Sint
divsi3_struct_divisor(a, p)
Sint a;
struct divsi3_pair *p;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(p->b);
  return a / b;
}

static Sint
divsi3_global_struct_dividend(b)
Sint b;
{
  b = safe_divisor(b);
  return divsi3_gp.a / b;
}

static Sint
divsi3_global_struct_divisor(a)
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(divsi3_gp.b);
  return a / b;
}

static Sint
divsi3_qi_dividend(a, b)
sQint a;
Sint b;
{
  Sint x;

  x = a;
  b = safe_divisor(b);
  return x / b;
}

static Sint
divsi3_qi_divisor(a, b)
Sint a;
sQint b;
{
  Sint x;

  OPAQUE_REG(a);
  x = b;
  x = safe_divisor(x);
  return a / x;
}

static Sint
divsi3_hi_dividend(a, b)
Hint a;
Sint b;
{
  Sint x;

  x = a;
  b = safe_divisor(b);
  return x / b;
}

static Sint
divsi3_hi_divisor(a, b)
Sint a;
Hint b;
{
  Sint x;

  OPAQUE_REG(a);
  x = b;
  x = safe_divisor(x);
  return a / x;
}

static Sint
divsi3_expr_dividend(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a + b;
  OPAQUE_REG(x);
  c = safe_divisor(c);
  return x / c;
}

static Sint
divsi3_expr_divisor(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  OPAQUE_REG(a);
  x = b + c;
  x = safe_divisor(x);
  return a / x;
}

static Sint
divsi3_shifted_dividend(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a << 3;
  OPAQUE_REG(x);
  b = safe_divisor(b);
  return x / b;
}

static Sint
divsi3_shifted_divisor(a, b)
Sint a;
Sint b;
{
  Sint x;

  OPAQUE_REG(a);
  x = b >> 3;
  x = safe_divisor(x);
  return a / x;
}

static Sint
divsi3_neg_dividend(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = -a;
  OPAQUE_REG(x);
  b = safe_divisor(b);
  return x / b;
}

static Sint
divsi3_neg_result(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  b = safe_divisor(b);
  return -(a / b);
}

static void
divsi3_store_reg(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  b = safe_divisor(b);
  *dst = a / b;
}

static Sint
divsi3_store_reg_ret(dst, a, b)
Sint *dst;
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  b = safe_divisor(b);
  *dst = a / b;
  return *dst;
}

static void
divsi3_store_mem(dst, src, divp)
Sint *dst;
Sint *src;
Sint *divp;
{
  Sint b;

  b = safe_divisor(*divp);
  *dst = *src / b;
}

static Sint
divsi3_store_mem_ret(dst, src, divp)
Sint *dst;
Sint *src;
Sint *divp;
{
  Sint b;

  b = safe_divisor(*divp);
  *dst = *src / b;
  return *dst;
}

/*
 * IDIVM-style memory destination: destination also supplies divisor.
 */

static void
divsi3_memdest(p, a)
Sint *p;
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(*p);
  *p = a / b;
}

static Sint
divsi3_memdest_ret(p, a)
Sint *p;
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(*p);
  *p = a / b;
  return *p;
}

static void
divsi3_memdest_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  i &= 017;
  b = safe_divisor(v[i]);
  v[i] = a / b;
}

static Sint
divsi3_memdest_array_ret(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  i &= 017;
  b = safe_divisor(v[i]);
  v[i] = a / b;
  return v[i];
}

static void
divsi3_memdest_global(a)
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(divsi3_ga);
  divsi3_ga = a / b;
}

static Sint
divsi3_memdest_global_ret(a)
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(divsi3_ga);
  divsi3_ga = a / b;
  return divsi3_ga;
}

static void
divsi3_memdest_struct(p, a)
struct divsi3_pair *p;
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(p->b);
  p->b = a / b;
}

static Sint
divsi3_memdest_struct_ret(p, a)
struct divsi3_pair *p;
Sint a;
{
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(p->b);
  p->b = a / b;
  return p->b;
}

static Sint
divsi3_branch_eq_zero(a, b)
Sint a;
Sint b;
{
  Sint q;

  OPAQUE_REG(a);
  b = safe_divisor(b);
  q = a / b;

  if (q == 0)
    return 1;
  return q;
}

static Sint
divsi3_branch_negative(a, b)
Sint a;
Sint b;
{
  Sint q;

  OPAQUE_REG(a);
  b = safe_divisor(b);
  q = a / b;

  if (q < 0)
    return -1;
  return q;
}

static Sint
divsi3_branch_positive(a, b)
Sint a;
Sint b;
{
  Sint q;

  OPAQUE_REG(a);
  b = safe_divisor(b);
  q = a / b;

  if (q > 0)
    return q;
  return 0;
}

static Sint
divsi3_select(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  OPAQUE_REG(a);
  OPAQUE_REG(c);

  b = safe_divisor(b);
  d = safe_divisor(d);

  if (a < c)
    return a / b;
  return c / d;
}

static Sint
divsi3_two_quotients(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint q0;
  Sint q1;

  OPAQUE_REG(a);
  OPAQUE_REG(c);

  b = safe_divisor(b);
  d = safe_divisor(d);

  q0 = a / b;
  q1 = c / d;

  return q0 + q1;
}

static Sint
divsi3_call_pressure(a, b)
Sint a;
Sint b;
{
  extern void clobber(void);
  Sint q;

  OPAQUE_REG(a);
  b = safe_divisor(b);

  q = a / b;
  clobber();

  return q + a;
}

static Sint
divsi3_mem_call_pressure(p, b)
Sint *p;
Sint b;
{
  extern void clobber(void);
  Sint q;

  b = safe_divisor(b);

  q = *p / b;
  clobber();

  return q + *p;
}

static Sint
divsi3_store_call_pressure(p, a)
Sint *p;
Sint a;
{
  extern void clobber(void);
  Sint b;

  OPAQUE_REG(a);
  b = safe_divisor(*p);

  *p = a / b;
  clobber();

  return *p;
}

static Sint
divsi3_loop_sum(v, n, b)
Sint *v;
Sint n;
Sint b;
{
  Sint i;
  Sint r;

  b = safe_divisor(b);
  r = 0;

  for (i = 0; i < n; ++i)
    r += v[i & 017] / b;

  return r;
}

static void
divsi3_loop_update(v, n, b)
Sint *v;
Sint n;
Sint b;
{
  Sint i;

  b = safe_divisor(b);

  for (i = 0; i < n; ++i)
    v[i & 017] = v[i & 017] / b;
}

static Sint
divsi3_loop_memdest(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint i;
  Sint r;
  Sint b;

  OPAQUE_REG(a);
  r = 0;

  for (i = 0; i < n; ++i) {
    b = safe_divisor(v[i & 017]);
    v[i & 017] = a / b;
    r += v[i & 017];
  }

  return r;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
divsi3_1(b, a)
Sint b;
Sint a;
{
  OPAQUE_REG(a);
  return a / 3;
}

static Sint
divsi3_2(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  b = safe_divisor(b);
  return a / b;
}

static void
divsi3_3(a, b)
Sint a;
Sint *b;
{
  Sint d;

  OPAQUE_REG(a);
  d = safe_divisor(*b);
  *b = a / d;
}
