#include "insns.h"

/*
 * one_cmplsi2 pattern coverage for PDP-6/166 and KA10.
 *
 * Pattern-level coverage for SImode one's-complement:
 *
 *   reg = ~reg              SETCA-style
 *   reg = ~mem              SETCM-style
 *   mem = ~reg              SETCAM-style
 *   mem = ~mem              SETCMM-style
 *   globals, arrays, structs, volatile
 *   complement used in branches and expressions
 *
 * This is not the full SETC/ORC/ANDC logical-family test.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint onecmpl_g0;
static Sint onecmpl_g1;
static uSint onecmpl_ug0;

static Sint onecmpl_buf[16];
static uSint onecmpl_ubuf[16];

struct onecmpl_pair {
  Sint a;
  Sint b;
};

struct onecmpl_upair {
  uSint a;
  uSint b;
};

static struct onecmpl_pair onecmpl_gp;
static struct onecmpl_upair onecmpl_ugp;

static Sint
not_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  return ~a;
}

static uSint
unot_reg(a)
uSint a;
{
  OPAQUE_REG(a);
  return ~a;
}

static Sint
not_mem(p)
Sint *p;
{
  return ~*p;
}

static uSint
unot_mem(p)
uSint *p;
{
  return ~*p;
}

static Sint
not_volatile_mem(p)
volatile Sint *p;
{
  return ~*p;
}

static Sint
not_global(void)
{
  return ~onecmpl_g0;
}

static uSint
unot_global(void)
{
  return ~onecmpl_ug0;
}

static Sint
not_array(i)
Sint i;
{
  return ~onecmpl_buf[i & 017];
}

static uSint
unot_uarray(i)
Sint i;
{
  return ~onecmpl_ubuf[i & 017];
}

static Sint
not_struct_a(p)
struct onecmpl_pair *p;
{
  return ~p->a;
}

static Sint
not_struct_b(p)
struct onecmpl_pair *p;
{
  return ~p->b;
}

static uSint
unot_struct_a(p)
struct onecmpl_upair *p;
{
  return ~p->a;
}

static Sint
not_global_struct_a(void)
{
  return ~onecmpl_gp.a;
}

static Sint
not_global_struct_b(void)
{
  return ~onecmpl_gp.b;
}

static uSint
unot_global_struct_a(void)
{
  return ~onecmpl_ugp.a;
}

static void
not_store_reg(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = ~a;
}

static void
unot_store_reg(p, a)
uSint *p;
uSint a;
{
  OPAQUE_REG(a);
  *p = ~a;
}

static Sint
not_store_reg_ret(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = ~a;
  return *p;
}

static void
not_store_mem(p)
Sint *p;
{
  *p = ~*p;
}

static Sint
not_store_mem_ret(p)
Sint *p;
{
  *p = ~*p;
  return *p;
}

static void
unot_store_mem(p)
uSint *p;
{
  *p = ~*p;
}

static uSint
unot_store_mem_ret(p)
uSint *p;
{
  *p = ~*p;
  return *p;
}

static void
not_store_volatile_mem(p)
volatile Sint *p;
{
  *p = ~*p;
}

static Sint
not_store_volatile_mem_ret(p)
volatile Sint *p;
{
  *p = ~*p;
  return *p;
}

static void
not_store_global_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  onecmpl_g0 = ~a;
}

static Sint
not_store_global_reg_ret(a)
Sint a;
{
  OPAQUE_REG(a);
  onecmpl_g0 = ~a;
  return onecmpl_g0;
}

static void
not_store_global_mem(void)
{
  onecmpl_g0 = ~onecmpl_g0;
}

static Sint
not_store_global_mem_ret(void)
{
  onecmpl_g0 = ~onecmpl_g0;
  return onecmpl_g0;
}

static void
not_store_array_reg(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  onecmpl_buf[i & 017] = ~a;
}

static Sint
not_store_array_reg_ret(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  i &= 017;
  onecmpl_buf[i] = ~a;
  return onecmpl_buf[i];
}

static void
not_store_array_mem(i)
Sint i;
{
  i &= 017;
  onecmpl_buf[i] = ~onecmpl_buf[i];
}

static Sint
not_store_array_mem_ret(i)
Sint i;
{
  i &= 017;
  onecmpl_buf[i] = ~onecmpl_buf[i];
  return onecmpl_buf[i];
}

static void
not_store_struct_reg(p, a)
struct onecmpl_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->a = ~a;
}

static Sint
not_store_struct_reg_ret(p, a)
struct onecmpl_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->a = ~a;
  return p->a;
}

static void
not_store_struct_mem(p)
struct onecmpl_pair *p;
{
  p->a = ~p->a;
}

static Sint
not_store_struct_mem_ret(p)
struct onecmpl_pair *p;
{
  p->a = ~p->a;
  return p->a;
}

static void
not_store_global_struct_mem(void)
{
  onecmpl_gp.a = ~onecmpl_gp.a;
}

static Sint
not_store_global_struct_mem_ret(void)
{
  onecmpl_gp.a = ~onecmpl_gp.a;
  return onecmpl_gp.a;
}

static Sint
not_expr_add(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  OPAQUE_REG(x);
  return ~x;
}

static Sint
not_expr_sub(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  OPAQUE_REG(x);
  return ~x;
}

static Sint
not_expr_and(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  OPAQUE_REG(x);
  return ~x;
}

static Sint
not_expr_ior(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a | b;
  OPAQUE_REG(x);
  return ~x;
}

static Sint
not_expr_xor(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return ~x;
}

static Sint
not_expr_shift(a, n)
Sint a;
Sint n;
{
  Sint x;

  n &= 017;
  x = a << n;
  OPAQUE_REG(x);
  return ~x;
}

static Sint
not_then_add(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return ~a + b;
}

static Sint
not_then_sub(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return b - ~a;
}

static Sint
not_then_and(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return ~a & b;
}

static Sint
not_then_ior(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return ~a | b;
}

static Sint
not_then_xor(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return ~a ^ b;
}

static Sint
double_not(a)
Sint a;
{
  OPAQUE_REG(a);
  return ~~a;
}

static uSint
udouble_not(a)
uSint a;
{
  OPAQUE_REG(a);
  return ~~a;
}

static Sint
not_const_zero(void)
{
  return ~0;
}

static Sint
not_const_one(void)
{
  return ~1;
}

static Sint
not_const_small(void)
{
  return ~0123456;
}

static Sint
not_const_low9(void)
{
  return ~0777;
}

static Sint
not_const_low18(void)
{
  return ~0777777;
}

static Sint
not_const_large(void)
{
  return ~0123456123456;
}

static void
not_store_const_zero(p)
Sint *p;
{
  *p = ~0;
}

static void
not_store_const_one(p)
Sint *p;
{
  *p = ~1;
}

static void
not_store_const_small(p)
Sint *p;
{
  *p = ~0123456;
}

static void
not_store_const_large(p)
Sint *p;
{
  *p = ~0123456123456;
}

static Sint
not_qi(a)
Qint a;
{
  Sint x;

  x = a;
  return ~x;
}

static uSint
not_uqi(a)
uQint a;
{
  uSint x;

  x = a;
  return ~x;
}

static Sint
not_hi(a)
Hint a;
{
  Sint x;

  x = a;
  return ~x;
}

static uSint
not_uhi(a)
uHint a;
{
  uSint x;

  x = a;
  return ~x;
}

static Sint
not_qi_mem(p)
Qint *p;
{
  Sint x;

  x = *p;
  return ~x;
}

static uSint
not_uqi_mem(p)
uQint *p;
{
  uSint x;

  x = *p;
  return ~x;
}

static Sint
not_hi_mem(p)
Hint *p;
{
  Sint x;

  x = *p;
  return ~x;
}

static uSint
not_uhi_mem(p)
uHint *p;
{
  uSint x;

  x = *p;
  return ~x;
}

static void
not_store_qi(p, a)
Qint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = ~a;
}

static void
not_store_hi(p, a)
Hint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = ~a;
}

static Sint
not_branch_zero(a)
Sint a;
{
  Sint x;

  OPAQUE_REG(a);
  x = ~a;

  if (x == 0)
    return 1;
  return x;
}

static Sint
not_branch_nonzero(a)
Sint a;
{
  Sint x;

  OPAQUE_REG(a);
  x = ~a;

  if (x != 0)
    return x;
  return 1;
}

static Sint
not_branch_negative(a)
Sint a;
{
  Sint x;

  OPAQUE_REG(a);
  x = ~a;

  if (x < 0)
    return -1;
  return x;
}

static Sint
not_branch_positive(a)
Sint a;
{
  Sint x;

  OPAQUE_REG(a);
  x = ~a;

  if (x > 0)
    return x;
  return 0;
}

static Sint
not_mem_branch_zero(p)
Sint *p;
{
  Sint x;

  x = ~*p;

  if (x == 0)
    return 1;
  return x;
}

static Sint
not_mem_branch_negative(p)
Sint *p;
{
  Sint x;

  x = ~*p;

  if (x < 0)
    return -1;
  return x;
}

static Sint
not_select(flag, a, b)
int flag;
Sint a;
Sint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    return ~a;
  return ~b;
}

static Sint
not_select_mem(flag, p, q)
int flag;
Sint *p;
Sint *q;
{
  OPAQUE_REG(flag);

  if (flag)
    return ~*p;
  return ~*q;
}

static Sint
not_store_select(flag, p, a, b)
int flag;
Sint *p;
Sint a;
Sint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    *p = ~a;
  else
    *p = ~b;

  return *p;
}

static Sint
not_call_pressure(a)
Sint a;
{
  extern void clobber(void);
  Sint x;

  OPAQUE_REG(a);

  x = ~a;
  clobber();

  return x;
}

static Sint
not_mem_call_pressure(p)
Sint *p;
{
  extern void clobber(void);
  Sint x;

  x = ~*p;
  clobber();

  return x + ~*p;
}

static Sint
not_store_call_pressure(p, a)
Sint *p;
Sint a;
{
  extern void clobber(void);
  Sint x;

  OPAQUE_REG(a);

  x = ~a;
  *p = x;
  clobber();

  return *p;
}

static Sint
not_loop_sum(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;

  for (i = 0; i < n; ++i)
    r += ~v[i & 017];

  return r;
}

static void
not_loop_update(v, n)
Sint *v;
Sint n;
{
  Sint i;

  for (i = 0; i < n; ++i)
    v[i & 017] = ~v[i & 017];
}

static Sint
not_loop_update_sum(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;

  for (i = 0; i < n; ++i) {
    v[i & 017] = ~v[i & 017];
    r += v[i & 017];
  }

  return r;
}

static Sint
not_loop_store(dst, src, n)
Sint *dst;
Sint *src;
Sint n;
{
  Sint i;
  Sint last;

  last = 0;

  for (i = 0; i < n; ++i) {
    last = ~src[i & 017];
    dst[i & 017] = last;
  }

  return last;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
setca(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ~ac;
}

static Sint
setcm1(ac, y)
Sint ac;
Sint y;
{
  OPAQUE_REG(ac);
  OPAQUE_REG(y);
  return ~y;
}

static Sint
setcm2(ac, x)
Sint ac;
Sint *x;
{
  OPAQUE_REG(ac);
  return ~*x;
}

static Sint
setcam(ac, x)
Sint ac;
Sint *x;
{
  OPAQUE_REG(ac);
  *x = ~ac;
  return *x;
}

static Sint
setcmm(ac, x)
Sint ac;
Sint *x;
{
  OPAQUE_REG(ac);
  *x = ~*x;
  return *x;
}
