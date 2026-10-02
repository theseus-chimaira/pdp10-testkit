#include "insns.h"

/*
 * LSH instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   LSH AC,n       logical left/right shift with constant count
 *   LSH AC,(E)     logical shift with variable count
 *
 * Signed arithmetic right shift belongs in ASH.c.
 * Doubleword/combined shifts belong in LSHC.c.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static uSint lsh_sink;
static uSint lsh_buf[16];

struct lsh_struct {
  uSint a;
  uSint b;
  uSint c;
};

static struct lsh_struct lsh_gs;

static Sint
lshl_sint_0(a)
Sint a;
{
  return a << 0;
}

static Sint
lshl_sint_1(a)
Sint a;
{
  return a << 1;
}

static Sint
lshl_sint_2(a)
Sint a;
{
  return a << 2;
}

static Sint
lshl_sint_3(a)
Sint a;
{
  return a << 3;
}

static Sint
lshl_sint_9(a)
Sint a;
{
  return a << 9;
}

static Sint
lshl_sint_18(a)
Sint a;
{
  return a << 18;
}

static Sint
lshl_sint_27(a)
Sint a;
{
  return a << 27;
}

static Sint
lshl_sint_35(a)
Sint a;
{
  return a << 35;
}

static uSint
lshl_usint_0(a)
uSint a;
{
  return a << 0;
}

static uSint
lshl_usint_1(a)
uSint a;
{
  return a << 1;
}

static uSint
lshl_usint_2(a)
uSint a;
{
  return a << 2;
}

static uSint
lshl_usint_3(a)
uSint a;
{
  return a << 3;
}

static uSint
lshl_usint_9(a)
uSint a;
{
  return a << 9;
}

static uSint
lshl_usint_18(a)
uSint a;
{
  return a << 18;
}

static uSint
lshl_usint_27(a)
uSint a;
{
  return a << 27;
}

static uSint
lshl_usint_35(a)
uSint a;
{
  return a << 35;
}

static uSint
lshr_usint_0(a)
uSint a;
{
  return a >> 0;
}

static uSint
lshr_usint_1(a)
uSint a;
{
  return a >> 1;
}

static uSint
lshr_usint_2(a)
uSint a;
{
  return a >> 2;
}

static uSint
lshr_usint_3(a)
uSint a;
{
  return a >> 3;
}

static uSint
lshr_usint_9(a)
uSint a;
{
  return a >> 9;
}

static uSint
lshr_usint_18(a)
uSint a;
{
  return a >> 18;
}

static uSint
lshr_usint_27(a)
uSint a;
{
  return a >> 27;
}

static uSint
lshr_usint_35(a)
uSint a;
{
  return a >> 35;
}

static Sint
lshl_sint_var(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshl_usint_var(a, e)
uSint a;
Sint e;
{
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshr_usint_var(a, e)
uSint a;
Sint e;
{
  OPAQUE_REG(e);
  return a >> e;
}

static Sint
lshl_sint_plus_1(a, x)
Sint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a << x;
}

static uSint
lshl_usint_plus_1(a, x)
uSint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a << x;
}

static uSint
lshr_usint_plus_1(a, x)
uSint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a >> x;
}

static Sint
lshl_sint_minus_count(a, e)
Sint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshl_usint_minus_count(a, e)
uSint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshr_usint_minus_count(a, e)
uSint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a >> e;
}

static uSint
lshr_usint_one_minus(a, x)
uSint a;
Sint x;
{
  x = 1 - x;
  OPAQUE_REG(x);
  return a >> x;
}

static uSint
lshl_usint_one_minus(a, x)
uSint a;
Sint x;
{
  x = 1 - x;
  OPAQUE_REG(x);
  return a << x;
}

static Sint
lshl_sint_mem_count(a, p)
Sint a;
Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshl_usint_mem_count(a, p)
uSint a;
Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshr_usint_mem_count(a, p)
uSint a;
Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a >> e;
}

static uSint
lshl_usint_volatile_count(a, p)
uSint a;
volatile Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshr_usint_volatile_count(a, p)
uSint a;
volatile Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a >> e;
}

static Sint
lshl_sint_masked_count(a, e)
Sint a;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshl_usint_masked_count(a, e)
uSint a;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshr_usint_masked_count(a, e)
uSint a;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return a >> e;
}

static uSint
lshl_usint_low5_count(a, e)
uSint a;
Sint e;
{
  e &= 037;
  OPAQUE_REG(e);
  return a << e;
}

static uSint
lshr_usint_low5_count(a, e)
uSint a;
Sint e;
{
  e &= 037;
  OPAQUE_REG(e);
  return a >> e;
}

static uSint
lshl_from_qi(a)
uQint a;
{
  return ((uSint)a) << 3;
}

static uSint
lshr_from_qi(a)
uQint a;
{
  return ((uSint)a) >> 3;
}

static Sint
lshl_from_sqi(a)
sQint a;
{
  return ((Sint)a) << 3;
}

static uSint
lshl_from_hi(a)
uHint a;
{
  return ((uSint)a) << 9;
}

static uSint
lshr_from_hi(a)
uHint a;
{
  return ((uSint)a) >> 9;
}

static Sint
lshl_from_shi(a)
Hint a;
{
  return ((Sint)a) << 9;
}

static uSint
lshl_array(v, i)
uSint *v;
Sint i;
{
  return v[i & 017] << 3;
}

static uSint
lshr_array(v, i)
uSint *v;
Sint i;
{
  return v[i & 017] >> 3;
}

static uSint
lshl_array_var(v, i, e)
uSint *v;
Sint i;
Sint e;
{
  OPAQUE_REG(e);
  return v[i & 017] << e;
}

static uSint
lshr_array_var(v, i, e)
uSint *v;
Sint i;
Sint e;
{
  OPAQUE_REG(e);
  return v[i & 017] >> e;
}

static uSint
lshl_global(i)
Sint i;
{
  return lsh_buf[i & 017] << 9;
}

static uSint
lshr_global(i)
Sint i;
{
  return lsh_buf[i & 017] >> 9;
}

static uSint
lshl_struct(p)
struct lsh_struct *p;
{
  return p->b << 18;
}

static uSint
lshr_struct(p)
struct lsh_struct *p;
{
  return p->b >> 18;
}

static uSint
lshl_global_struct(void)
{
  return lsh_gs.b << 18;
}

static uSint
lshr_global_struct(void)
{
  return lsh_gs.b >> 18;
}

static void
lshl_store(dst, a)
uSint *dst;
uSint a;
{
  *dst = a << 3;
}

static void
lshr_store(dst, a)
uSint *dst;
uSint a;
{
  *dst = a >> 3;
}

static uSint
lshl_store_ret(dst, a)
uSint *dst;
uSint a;
{
  *dst = a << 9;
  return *dst;
}

static uSint
lshr_store_ret(dst, a)
uSint *dst;
uSint a;
{
  *dst = a >> 9;
  return *dst;
}

static void
lshl_store_var(dst, a, e)
uSint *dst;
uSint a;
Sint e;
{
  OPAQUE_REG(e);
  *dst = a << e;
}

static void
lshr_store_var(dst, a, e)
uSint *dst;
uSint a;
Sint e;
{
  OPAQUE_REG(e);
  *dst = a >> e;
}

static void
lshl_compound(p)
uSint *p;
{
  *p <<= 1;
}

static void
lshr_compound(p)
uSint *p;
{
  *p >>= 1;
}

static void
lshl_compound_9(p)
uSint *p;
{
  *p <<= 9;
}

static void
lshr_compound_9(p)
uSint *p;
{
  *p >>= 9;
}

static void
lshl_compound_var(p, e)
uSint *p;
Sint e;
{
  OPAQUE_REG(e);
  *p <<= e;
}

static void
lshr_compound_var(p, e)
uSint *p;
Sint e;
{
  OPAQUE_REG(e);
  *p >>= e;
}

static void
lshl_compound_global(void)
{
  lsh_sink <<= 1;
}

static void
lshr_compound_global(void)
{
  lsh_sink >>= 1;
}

static uSint
lshl_compound_ret(p)
uSint *p;
{
  *p <<= 3;
  return *p;
}

static uSint
lshr_compound_ret(p)
uSint *p;
{
  *p >>= 3;
  return *p;
}

static uSint
lshl_and_mask(a)
uSint a;
{
  return (a & 0777777) << 18;
}

static uSint
lshr_and_mask(a)
uSint a;
{
  return (a & 0777777000000) >> 18;
}

static uSint
lshl_or_mask(a, b)
uSint a;
uSint b;
{
  return (a << 9) | (b & 0777);
}

static uSint
lshr_or_mask(a, b)
uSint a;
uSint b;
{
  return (a >> 9) | (b & 0777777000000);
}

static uSint
lshl_xor(a, b)
uSint a;
uSint b;
{
  return (a << 3) ^ b;
}

static uSint
lshr_xor(a, b)
uSint a;
uSint b;
{
  return (a >> 3) ^ b;
}

static uSint
lshl_add(a, b)
uSint a;
uSint b;
{
  return (a << 3) + b;
}

static uSint
lshr_add(a, b)
uSint a;
uSint b;
{
  return (a >> 3) + b;
}

static uSint
lshl_nested(a, b, e)
uSint a;
uSint b;
Sint e;
{
  e &= 017;
  OPAQUE_REG(e);
  return ((a ^ b) << e) + (b >> 3);
}

static uSint
lshr_nested(a, b, e)
uSint a;
uSint b;
Sint e;
{
  e &= 017;
  OPAQUE_REG(e);
  return ((a ^ b) >> e) + (b << 3);
}

static uSint
lshl_two_counts(a, e, f)
uSint a;
Sint e;
Sint f;
{
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  return (a << e) << f;
}

static uSint
lshr_two_counts(a, e, f)
uSint a;
Sint e;
Sint f;
{
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  return (a >> e) >> f;
}

static uSint
lshl_then_lshr(a)
uSint a;
{
  return (a << 18) >> 18;
}

static uSint
lshr_then_lshl(a)
uSint a;
{
  return (a >> 18) << 18;
}

static uSint
lshl_call_pressure(a, e)
uSint a;
Sint e;
{
  extern void clobber(void);
  uSint r;

  OPAQUE_REG(e);
  r = a << e;
  clobber();
  return r + a;
}

static uSint
lshr_call_pressure(a, e)
uSint a;
Sint e;
{
  extern void clobber(void);
  uSint r;

  OPAQUE_REG(e);
  r = a >> e;
  clobber();
  return r + a;
}

static uSint
lshl_loop(v, n)
uSint *v;
Sint n;
{
  Sint i;
  uSint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] << 1;

  return r;
}

static uSint
lshr_loop(v, n)
uSint *v;
Sint n;
{
  Sint i;
  uSint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] >> 1;

  return r;
}

static uSint
lshl_loop_var(v, n, e)
uSint *v;
Sint n;
Sint e;
{
  Sint i;
  uSint r;

  OPAQUE_REG(e);
  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] << e;

  return r;
}

static uSint
lshr_loop_var(v, n, e)
uSint *v;
Sint n;
Sint e;
{
  Sint i;
  uSint r;

  OPAQUE_REG(e);
  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] >> e;

  return r;
}

/*
 * Original skeleton shapes, kept with short names.
 */

Sint
lshl1(a)
Sint a;
{
  return a << 1;
}

Sint
lshl2(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(e);
  return a << e;
}

Sint
lshl3(a, x)
Sint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a << x;
}

uSint
lshr1(a)
uSint a;
{
  return a >> 1;
}

uSint
lshr2(a, e)
uSint a;
Sint e;
{
  OPAQUE_REG(e);
  return a >> e;
}

uSint
lshr3(a, e)
uSint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a >> e;
}

uSint
lshr4(a, x)
uSint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a >> x;
}

uSint
lshr5(a, x)
uSint a;
Sint x;
{
  x = 1 - x;
  OPAQUE_REG(x);
  return a >> x;
}
