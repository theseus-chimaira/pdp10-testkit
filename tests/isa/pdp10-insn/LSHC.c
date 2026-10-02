#include "insns.h"

/*
 * LSHC instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   LSHC AC,n       doubleword logical left/right shift
 *   LSHC AC,(E)     doubleword logical shift with variable count
 *
 * Signed arithmetic doubleword right shift belongs in ASHC.c.
 * Single-word logical shifts belong in LSH.c.
 *
 * Keep constant counts below 71.  That fits the native PDP-10-ish
 * 71-bit long-long direction while still exercising cross-word motion.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static uDint lshc_sink;
static uDint lshc_buf[16];

struct lshc_struct {
  uDint a;
  uDint b;
  uDint c;
};

static struct lshc_struct lshc_gs;

static Dint
lshcl_dint_0(a)
Dint a;
{
  return a << 0;
}

static Dint
lshcl_dint_1(a)
Dint a;
{
  return a << 1;
}

static Dint
lshcl_dint_2(a)
Dint a;
{
  return a << 2;
}

static Dint
lshcl_dint_3(a)
Dint a;
{
  return a << 3;
}

static Dint
lshcl_dint_9(a)
Dint a;
{
  return a << 9;
}

static Dint
lshcl_dint_18(a)
Dint a;
{
  return a << 18;
}

static Dint
lshcl_dint_35(a)
Dint a;
{
  return a << 35;
}

static Dint
lshcl_dint_36(a)
Dint a;
{
  return a << 36;
}

static Dint
lshcl_dint_54(a)
Dint a;
{
  return a << 54;
}

static Dint
lshcl_dint_70(a)
Dint a;
{
  return a << 70;
}

static uDint
lshcl_udint_0(a)
uDint a;
{
  return a << 0;
}

static uDint
lshcl_udint_1(a)
uDint a;
{
  return a << 1;
}

static uDint
lshcl_udint_2(a)
uDint a;
{
  return a << 2;
}

static uDint
lshcl_udint_3(a)
uDint a;
{
  return a << 3;
}

static uDint
lshcl_udint_9(a)
uDint a;
{
  return a << 9;
}

static uDint
lshcl_udint_18(a)
uDint a;
{
  return a << 18;
}

static uDint
lshcl_udint_35(a)
uDint a;
{
  return a << 35;
}

static uDint
lshcl_udint_36(a)
uDint a;
{
  return a << 36;
}

static uDint
lshcl_udint_54(a)
uDint a;
{
  return a << 54;
}

static uDint
lshcl_udint_70(a)
uDint a;
{
  return a << 70;
}

static uDint
lshcr_udint_0(a)
uDint a;
{
  return a >> 0;
}

static uDint
lshcr_udint_1(a)
uDint a;
{
  return a >> 1;
}

static uDint
lshcr_udint_2(a)
uDint a;
{
  return a >> 2;
}

static uDint
lshcr_udint_3(a)
uDint a;
{
  return a >> 3;
}

static uDint
lshcr_udint_9(a)
uDint a;
{
  return a >> 9;
}

static uDint
lshcr_udint_18(a)
uDint a;
{
  return a >> 18;
}

static uDint
lshcr_udint_35(a)
uDint a;
{
  return a >> 35;
}

static uDint
lshcr_udint_36(a)
uDint a;
{
  return a >> 36;
}

static uDint
lshcr_udint_54(a)
uDint a;
{
  return a >> 54;
}

static uDint
lshcr_udint_70(a)
uDint a;
{
  return a >> 70;
}

static Dint
lshcl_dint_var(a, e)
Dint a;
Sint e;
{
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcl_udint_var(a, e)
uDint a;
Sint e;
{
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcr_udint_var(a, e)
uDint a;
Sint e;
{
  OPAQUE_REG(e);
  return a >> e;
}

static Dint
lshcl_dint_plus_1(a, x)
Dint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a << x;
}

static uDint
lshcl_udint_plus_1(a, x)
uDint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a << x;
}

static uDint
lshcr_udint_plus_1(a, x)
uDint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a >> x;
}

static Dint
lshcl_dint_minus_count(a, e)
Dint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcl_udint_minus_count(a, e)
uDint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcr_udint_minus_count(a, e)
uDint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a >> e;
}

static uDint
lshcl_udint_one_minus(a, x)
uDint a;
Sint x;
{
  x = 1 - x;
  OPAQUE_REG(x);
  return a << x;
}

static uDint
lshcr_udint_one_minus(a, x)
uDint a;
Sint x;
{
  x = 1 - x;
  OPAQUE_REG(x);
  return a >> x;
}

static Dint
lshcl_dint_mem_count(a, p)
Dint a;
Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcl_udint_mem_count(a, p)
uDint a;
Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcr_udint_mem_count(a, p)
uDint a;
Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a >> e;
}

static uDint
lshcl_udint_volatile_count(a, p)
uDint a;
volatile Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcr_udint_volatile_count(a, p)
uDint a;
volatile Sint *p;
{
  Sint e;

  e = *p;
  OPAQUE_REG(e);
  return a >> e;
}

static Dint
lshcl_dint_masked_count(a, e)
Dint a;
Sint e;
{
  e &= 0177;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcl_udint_masked_count(a, e)
uDint a;
Sint e;
{
  e &= 0177;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcr_udint_masked_count(a, e)
uDint a;
Sint e;
{
  e &= 0177;
  OPAQUE_REG(e);
  return a >> e;
}

static uDint
lshcl_udint_low6_count(a, e)
uDint a;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return a << e;
}

static uDint
lshcr_udint_low6_count(a, e)
uDint a;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return a >> e;
}

static uDint
lshcl_from_sint(a)
Sint a;
{
  return ((uDint)a) << 18;
}

static uDint
lshcr_from_sint(a)
Sint a;
{
  return ((uDint)a) >> 18;
}

static uDint
lshcl_from_usint(a)
uSint a;
{
  return ((uDint)a) << 36;
}

static uDint
lshcr_from_usint(a)
uSint a;
{
  return ((uDint)a) >> 18;
}

static Dint
lshcl_from_qi(a)
sQint a;
{
  return ((Dint)a) << 9;
}

static uDint
lshcl_from_uqi(a)
uQint a;
{
  return ((uDint)a) << 9;
}

static Dint
lshcl_from_hi(a)
Hint a;
{
  return ((Dint)a) << 18;
}

static uDint
lshcl_from_uhi(a)
uHint a;
{
  return ((uDint)a) << 18;
}

static uDint
lshcr_array(v, i)
uDint *v;
Sint i;
{
  return v[i & 017] >> 9;
}

static uDint
lshcl_array(v, i)
uDint *v;
Sint i;
{
  return v[i & 017] << 9;
}

static uDint
lshcr_array_var(v, i, e)
uDint *v;
Sint i;
Sint e;
{
  OPAQUE_REG(e);
  return v[i & 017] >> e;
}

static uDint
lshcl_array_var(v, i, e)
uDint *v;
Sint i;
Sint e;
{
  OPAQUE_REG(e);
  return v[i & 017] << e;
}

static uDint
lshcr_global(i)
Sint i;
{
  return lshc_buf[i & 017] >> 18;
}

static uDint
lshcl_global(i)
Sint i;
{
  return lshc_buf[i & 017] << 18;
}

static uDint
lshcr_struct(p)
struct lshc_struct *p;
{
  return p->b >> 36;
}

static uDint
lshcl_struct(p)
struct lshc_struct *p;
{
  return p->b << 36;
}

static uDint
lshcr_global_struct(void)
{
  return lshc_gs.b >> 36;
}

static uDint
lshcl_global_struct(void)
{
  return lshc_gs.b << 36;
}

static void
lshcl_store(dst, a)
uDint *dst;
uDint a;
{
  *dst = a << 9;
}

static void
lshcr_store(dst, a)
uDint *dst;
uDint a;
{
  *dst = a >> 9;
}

static uDint
lshcl_store_ret(dst, a)
uDint *dst;
uDint a;
{
  *dst = a << 18;
  return *dst;
}

static uDint
lshcr_store_ret(dst, a)
uDint *dst;
uDint a;
{
  *dst = a >> 18;
  return *dst;
}

static void
lshcl_store_var(dst, a, e)
uDint *dst;
uDint a;
Sint e;
{
  OPAQUE_REG(e);
  *dst = a << e;
}

static void
lshcr_store_var(dst, a, e)
uDint *dst;
uDint a;
Sint e;
{
  OPAQUE_REG(e);
  *dst = a >> e;
}

static void
lshcl_compound(p)
uDint *p;
{
  *p <<= 1;
}

static void
lshcr_compound(p)
uDint *p;
{
  *p >>= 1;
}

static void
lshcl_compound_18(p)
uDint *p;
{
  *p <<= 18;
}

static void
lshcr_compound_18(p)
uDint *p;
{
  *p >>= 18;
}

static void
lshcl_compound_36(p)
uDint *p;
{
  *p <<= 36;
}

static void
lshcr_compound_36(p)
uDint *p;
{
  *p >>= 36;
}

static void
lshcl_compound_var(p, e)
uDint *p;
Sint e;
{
  OPAQUE_REG(e);
  *p <<= e;
}

static void
lshcr_compound_var(p, e)
uDint *p;
Sint e;
{
  OPAQUE_REG(e);
  *p >>= e;
}

static void
lshcl_compound_global(void)
{
  lshc_sink <<= 1;
}

static void
lshcr_compound_global(void)
{
  lshc_sink >>= 1;
}

static uDint
lshcl_compound_ret(p)
uDint *p;
{
  *p <<= 9;
  return *p;
}

static uDint
lshcr_compound_ret(p)
uDint *p;
{
  *p >>= 9;
  return *p;
}

static uDint
lshcl_or_low(a, b)
uDint a;
uSint b;
{
  return (a << 36) | (uDint)b;
}

static uDint
lshcr_or_high(a, b)
uDint a;
uSint b;
{
  return (a >> 36) | (((uDint)b) << 18);
}

static uDint
lshcl_xor(a, b)
uDint a;
uDint b;
{
  return (a << 9) ^ b;
}

static uDint
lshcr_xor(a, b)
uDint a;
uDint b;
{
  return (a >> 9) ^ b;
}

static uDint
lshcl_add(a, b)
uDint a;
uDint b;
{
  return (a << 9) + b;
}

static uDint
lshcr_add(a, b)
uDint a;
uDint b;
{
  return (a >> 9) + b;
}

static uDint
lshcl_and_mask(a)
uDint a;
{
  return (a & (uDint)0777777) << 36;
}

static uDint
lshcr_and_mask(a)
uDint a;
{
  return (a >> 36) & (uDint)0777777;
}

static uDint
lshcl_then_lshcr(a)
uDint a;
{
  return (a << 36) >> 36;
}

static uDint
lshcr_then_lshcl(a)
uDint a;
{
  return (a >> 36) << 36;
}

static uDint
lshcl_two_counts(a, e, f)
uDint a;
Sint e;
Sint f;
{
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  return (a << e) << f;
}

static uDint
lshcr_two_counts(a, e, f)
uDint a;
Sint e;
Sint f;
{
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  return (a >> e) >> f;
}

static uDint
lshcl_nested(a, b, e)
uDint a;
uDint b;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return ((a ^ b) << e) + (b >> 18);
}

static uDint
lshcr_nested(a, b, e)
uDint a;
uDint b;
Sint e;
{
  e &= 077;
  OPAQUE_REG(e);
  return ((a ^ b) >> e) + (b << 18);
}

static uDint
lshcl_call_pressure(a, e)
uDint a;
Sint e;
{
  extern void clobber(void);
  uDint r;

  OPAQUE_REG(e);
  r = a << e;
  clobber();
  return r + a;
}

static uDint
lshcr_call_pressure(a, e)
uDint a;
Sint e;
{
  extern void clobber(void);
  uDint r;

  OPAQUE_REG(e);
  r = a >> e;
  clobber();
  return r + a;
}

static uDint
lshcl_loop(v, n)
uDint *v;
Sint n;
{
  Sint i;
  uDint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] << 1;

  return r;
}

static uDint
lshcr_loop(v, n)
uDint *v;
Sint n;
{
  Sint i;
  uDint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] >> 1;

  return r;
}

static uDint
lshcl_loop_var(v, n, e)
uDint *v;
Sint n;
Sint e;
{
  Sint i;
  uDint r;

  OPAQUE_REG(e);
  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] << e;

  return r;
}

static uDint
lshcr_loop_var(v, n, e)
uDint *v;
Sint n;
Sint e;
{
  Sint i;
  uDint r;

  OPAQUE_REG(e);
  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] >> e;

  return r;
}

static uDint
lshcl_compare_nonzero(a)
uDint a;
{
  a <<= 36;
  if (a != 0)
    return a;
  return 1;
}

static uDint
lshcr_compare_nonzero(a)
uDint a;
{
  a >>= 36;
  if (a != 0)
    return a;
  return 1;
}

static uDint
lshcl_select(a, b, c)
uDint a;
uDint b;
Sint c;
{
  if (c != 0)
    return a << 18;
  return b << 36;
}

static uDint
lshcr_select(a, b, c)
uDint a;
uDint b;
Sint c;
{
  if (c != 0)
    return a >> 18;
  return b >> 36;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Dint
lshcl1(a)
Dint a;
{
  return a << 1;
}

static Dint
lshcl2(a, e)
Dint a;
Sint e;
{
  OPAQUE_REG(e);
  return a << e;
}

static Dint
lshcl3(a, x)
Dint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a << x;
}

static uDint
lshcr1(a)
uDint a;
{
  return a >> 1;
}

static uDint
lshcr2(a, e)
uDint a;
Sint e;
{
  OPAQUE_REG(e);
  return a >> e;
}

static uDint
lshcr3(a, e)
uDint a;
Sint e;
{
  e = -e;
  OPAQUE_REG(e);
  return a >> e;
}

static uDint
lshcr4(a, x)
uDint a;
Sint x;
{
  x = 1 + x;
  OPAQUE_REG(x);
  return a >> x;
}

static uDint
lshcr5(a, x)
uDint a;
Sint x;
{
  x = 1 - x;
  OPAQUE_REG(x);
  return a >> x;
}
