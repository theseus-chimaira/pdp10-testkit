#include "insns.h"


/*
 * Zero-extension HImode to SImode pattern pressure.
 *
 * Intended pattern:
 *   zero_extendhisi2
 *
 * Ordinary C shape:
 *
 *   uHint h;
 *   uSint s;
 *
 *   s = h;
 *   return s;
 *
 * Keep this file unsigned-HI only.  Signed HImode extension belongs to
 * extendhisi2.c.  QImode zero-extension belongs to zero_extendqisi2.c.
 *
 * Do not use inline assembly here.
 */

extern uHint uhfunc(void);
extern void clobber(void);

static uHint zxhisi_ga;
static uHint zxhisi_gb;
static volatile uHint zxhisi_vga;
static uHint zxhisi_buf[16];

static uSint zxhisi_sga;
static volatile uSint zxhisi_vsga;
static uSint zxhisi_sbuf[16];

struct zxhisi_pair {
  uHint a;
  uHint b;
};

struct zxhisi_three {
  uHint a;
  uHint b;
  uHint c;
};

static struct zxhisi_pair zxhisi_gp;
static struct zxhisi_three zxhisi_gt;

/*
 * Original skeleton shapes, kept with short names.
 */

uSint
zero_extendhisi2_1(a)
uHint a;
{
  return a;
}

uSint
zxhi2(a, e)
uHint a;
uHint e;
{
  return e;
}

/*
 * Basic register-result forms.
 */

static uSint
zxhisi_reg(a)
uHint a;
{
  return a;
}

static uSint
zxhisi_reg_local(a)
uHint a;
{
  uSint x;

  x = a;
  return x;
}

static uSint
zxhisi_reg_reuse(a)
uHint a;
{
  uSint x;

  x = a;
  x += 0;
  return x;
}

static uSint
zxhisi_reg_plus(a, b)
uHint a;
uSint b;
{
  uSint x;

  x = a;
  return x + b;
}

static uSint
zxhisi_reg_minus(a, b)
uHint a;
uSint b;
{
  uSint x;

  x = a;
  return x - b;
}

static uSint
zxhisi_reg_xor(a, b)
uHint a;
uSint b;
{
  uSint x;

  x = a;
  return x ^ b;
}

static uSint
zxhisi_reg_or(a, b)
uHint a;
uSint b;
{
  uSint x;

  x = a;
  return x | b;
}

static uSint
zxhisi_reg_and(a, b)
uHint a;
uSint b;
{
  uSint x;

  x = a;
  return x & b;
}

static uSint
zxhisi_reg_shift_left(a)
uHint a;
{
  uSint x;

  x = a;
  return x << 1;
}

static uSint
zxhisi_reg_shift_right(a)
uHint a;
{
  uSint x;

  x = a;
  return x >> 1;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static uSint
zxhisi_mem(p)
uHint *p;
{
  return *p;
}

static uSint
zxhisi_mem_local(p)
uHint *p;
{
  uSint x;

  x = *p;
  return x;
}

static uSint
zxhisi_mem_plus(p, b)
uHint *p;
uSint b;
{
  uSint x;

  x = *p;
  return x + b;
}

static uSint
zxhisi_mem_xor(p, b)
uHint *p;
uSint b;
{
  uSint x;

  x = *p;
  return x ^ b;
}

static uSint
zxhisi_mem_mem(p, q)
uHint *p;
uHint *q;
{
  uSint x;
  uSint y;

  x = *p;
  y = *q;
  return x + y;
}

static uSint
zxhisi_global_a()
{
  return zxhisi_ga;
}

static uSint
zxhisi_global_b()
{
  return zxhisi_gb;
}

static uSint
zxhisi_global_local()
{
  uSint x;

  x = zxhisi_ga;
  return x;
}

static uSint
zxhisi_global_plus(b)
uSint b;
{
  uSint x;

  x = zxhisi_ga;
  return x + b;
}

static uSint
zxhisi_volatile_global()
{
  uHint h;
  uSint x;

  h = zxhisi_vga;
  x = h;
  return x;
}

static uSint
zxhisi_volatile_mem(p)
volatile uHint *p;
{
  uHint h;
  uSint x;

  h = *p;
  x = h;
  return x;
}

static uSint
zxhisi_array(v, i)
uHint *v;
Sint i;
{
  return v[i & 017];
}

static uSint
zxhisi_array_local(v, i)
uHint *v;
Sint i;
{
  uSint x;

  x = v[i & 017];
  return x;
}

static uSint
zxhisi_array_plus(v, i, b)
uHint *v;
Sint i;
uSint b;
{
  uSint x;

  x = v[i & 017];
  return x + b;
}

static uSint
zxhisi_global_array(i)
Sint i;
{
  return zxhisi_buf[i & 017];
}

static uSint
zxhisi_global_array_local(i)
Sint i;
{
  uSint x;

  x = zxhisi_buf[i & 017];
  return x;
}

static uSint
zxhisi_struct_a(p)
struct zxhisi_pair *p;
{
  return p->a;
}

static uSint
zxhisi_struct_b(p)
struct zxhisi_pair *p;
{
  return p->b;
}

static uSint
zxhisi_struct_ab_sum(p)
struct zxhisi_pair *p;
{
  uSint a;
  uSint b;

  a = p->a;
  b = p->b;
  return a + b;
}

static uSint
zxhisi_three_abc_sum(p)
struct zxhisi_three *p;
{
  uSint a;
  uSint b;
  uSint c;

  a = p->a;
  b = p->b;
  c = p->c;
  return a + b + c;
}

static uSint
zxhisi_global_struct_a()
{
  return zxhisi_gp.a;
}

static uSint
zxhisi_global_struct_b()
{
  return zxhisi_gp.b;
}

static uSint
zxhisi_global_three()
{
  uSint a;
  uSint b;
  uSint c;

  a = zxhisi_gt.a;
  b = zxhisi_gt.b;
  c = zxhisi_gt.c;
  return a + b + c;
}

static uSint
zxhisi_indirect(pp)
uHint **pp;
{
  uHint *p;

  p = *pp;
  return *p;
}

static uSint
zxhisi_indexed_indirect(pp, i)
uHint **pp;
Sint i;
{
  uHint *p;

  p = *pp;
  return p[i & 017];
}

/*
 * Function-call source.
 */

static uSint
zxhisi_call()
{
  uHint h;
  uSint x;

  h = uhfunc();
  x = h;
  return x;
}

static uSint
zxhisi_call_plus(a)
uSint a;
{
  uHint h;
  uSint x;

  h = uhfunc();
  x = h;
  return x + a;
}

/*
 * Store zero-extended result into SImode destinations.
 */

static void
zxhisi_store(out, a)
uSint *out;
uHint a;
{
  *out = a;
}

static uSint
zxhisi_store_return(out, a)
uSint *out;
uHint a;
{
  uSint x;

  x = a;
  *out = x;
  return x;
}

static uSint
zxhisi_store_return_mem(out, a)
uSint *out;
uHint a;
{
  *out = a;
  return *out;
}

static void
zxhisi_store_global(a)
uHint a;
{
  zxhisi_sga = a;
}

static uSint
zxhisi_store_global_return(a)
uHint a;
{
  zxhisi_sga = a;
  return zxhisi_sga;
}

static void
zxhisi_store_volatile(out, a)
volatile uSint *out;
uHint a;
{
  *out = a;
}

static uSint
zxhisi_store_volatile_return(a)
uHint a;
{
  zxhisi_vsga = a;
  return zxhisi_vsga;
}

static void
zxhisi_store_array(v, i, a)
uSint *v;
Sint i;
uHint a;
{
  v[i & 017] = a;
}

static uSint
zxhisi_store_array_return(v, i, a)
uSint *v;
Sint i;
uHint a;
{
  v[i & 017] = a;
  return v[i & 017];
}

static void
zxhisi_store_global_array(i, a)
Sint i;
uHint a;
{
  zxhisi_sbuf[i & 017] = a;
}

static uSint
zxhisi_store_global_array_return(i, a)
Sint i;
uHint a;
{
  zxhisi_sbuf[i & 017] = a;
  return zxhisi_sbuf[i & 017];
}

/*
 * Store back to HImode destinations after SImode use.  These should not
 * be confused with the primary SImode zero-extension result, but they
 * catch reload/conversion pressure.
 */

static void
zxhisi_store_hi(dst, a)
uHint *dst;
uHint a;
{
  uSint x;

  x = a;
  *dst = (uHint)x;
}

static uHint
zxhisi_store_hi_return(dst, a)
uHint *dst;
uHint a;
{
  uSint x;

  x = a;
  *dst = (uHint)x;
  return *dst;
}

/*
 * Branches based on zero-extended result.
 */

static uSint
zxhisi_branch_zero(a, yes, no)
uHint a;
uSint yes;
uSint no;
{
  uSint x;

  x = a;
  if (x == 0)
    return yes;
  return no;
}

static uSint
zxhisi_branch_nonzero(a, yes, no)
uHint a;
uSint yes;
uSint no;
{
  uSint x;

  x = a;
  if (x != 0)
    return yes;
  return no;
}

static uSint
zxhisi_branch_right_bit(a, yes, no)
uHint a;
uSint yes;
uSint no;
{
  uSint x;

  x = a;
  if (x & 000001)
    return yes;
  return no;
}

static uSint
zxhisi_branch_hi_signbit(a, yes, no)
uHint a;
uSint yes;
uSint no;
{
  uSint x;

  x = a;
  if (x & 0400000)
    return yes;
  return no;
}

static uSint
zxhisi_likely(a)
uHint a;
{
  uSint x;

  x = a;
  if (likely(x != 0))
    return x;
  return 0;
}

static uSint
zxhisi_unlikely(a)
uHint a;
{
  uSint x;

  x = a;
  if (unlikely(x != 0))
    return x;
  return 0;
}

/*
 * Source-liveness and call-pressure cases.
 */

static uSint
zxhisi_sources_live(a, b)
uHint a;
uSint b;
{
  uSint x;

  x = a;
  return x + a + b;
}

static uSint
zxhisi_mem_sources_live(p, b)
uHint *p;
uSint b;
{
  uHint h;
  uSint x;

  h = *p;
  x = h;
  return x + h + b;
}

static uSint
zxhisi_call_pressure_reg(a)
uHint a;
{
  uSint x;

  x = a;
  clobber();
  return x + a;
}

static uSint
zxhisi_call_pressure_mem(p)
uHint *p;
{
  uHint h;
  uSint x;

  h = *p;
  x = h;
  clobber();
  return x + h;
}

static uSint
zxhisi_store_call_pressure(out, a)
uSint *out;
uHint a;
{
  uSint x;

  x = a;
  *out = x;
  clobber();
  return *out;
}

/*
 * Loop pressure.
 */

static uSint
zxhisi_loop_sum(v, n)
uHint *v;
Sint n;
{
  Sint i;
  uSint r;
  uSint x;

  r = 0;
  for (i = 0; i < n; ++i) {
    x = v[i & 017];
    r += x;
  }

  return r;
}

static void
zxhisi_loop_store(src, dst, n)
uHint *src;
uSint *dst;
Sint n;
{
  Sint i;

  for (i = 0; i < n; ++i)
    dst[i & 017] = src[i & 017];
}

static uSint
zxhisi_loop_store_sum(src, dst, n)
uHint *src;
uSint *dst;
Sint n;
{
  Sint i;
  uSint r;

  r = 0;
  for (i = 0; i < n; ++i) {
    dst[i & 017] = src[i & 017];
    r += dst[i & 017];
  }

  return r;
}

/*
 * Existing-style macro hooks.
 */

BOTH (zero_extendhisi2_both_reg, (uSint)(uHint)a)
BOTH (zero_extendhisi2_both_mem, (uSint)(uHint)*b)

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

uSint
zxhs(a, b)
uHint a;
uHint b;
{
  uSint r;

  r = zero_extendhisi2_1(a);
  r += zxhi2(a, b);
  r += zxhisi_reg_plus(a, b);
  return r;
}

uSint
zxhm(p, q, out)
uHint *p;
uHint *q;
uSint *out;
{
  uSint r;

  r = zxhisi_mem(p);
  r += zxhisi_mem_mem(p, q);
  r += zxhisi_store_return(out, *p);
  return r;
}

uSint
zxhc(v, n, a)
uHint *v;
Sint n;
uHint a;
{
  uSint r;

  r = zxhisi_loop_sum(v, n);
  r += zxhisi_branch_nonzero(a, n, r);
  return r;
}
