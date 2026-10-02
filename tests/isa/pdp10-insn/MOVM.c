#include "insns.h"

/*
 * MOVM instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended integer forms:
 *   MOVM   AC <- abs(E)
 *   MOVMM  memory <- abs(AC)
 *   MOVMS  E <- abs(E), result also available in AC
 *
 * This version also keeps floating magnitude coverage in this file.
 * MOVM-style magnitude is one of the instruction families whose
 * meaning crosses the integer/FP boundary, so SF/DF cases belong here
 * even if most ordinary FP tests are attic/excluded in the first pass.
 */

extern void clobber(void);

static Sint movm_ga;
static Sint movm_gb;
static Sint movm_gc;
static volatile Sint movm_vga;
static volatile Sint movm_opaque_si;
static Sint movm_buf[16];

static Sfloat movm_sfa;
static Sfloat movm_sfb;
static Sfloat movm_sfc;
static volatile Sfloat movm_vsfa;
static volatile Sfloat movm_opaque_sf;
static Sfloat movm_sfbuf[16];

static Dfloat movm_dfa;
static Dfloat movm_dfb;
static Dfloat movm_dfc;
static volatile Dfloat movm_vdfa;
static volatile Dfloat movm_opaque_df;
static Dfloat movm_dfbuf[16];

struct movm_pair {
  Sint a;
  Sint b;
};

struct movm_three {
  Sint a;
  Sint b;
  Sint c;
};

struct movm_fpair {
  Sfloat a;
  Sfloat b;
};

struct movm_fthree {
  Sfloat a;
  Sfloat b;
  Sfloat c;
};

struct movm_dpair {
  Dfloat a;
  Dfloat b;
};

struct movm_dthree {
  Dfloat a;
  Dfloat b;
  Dfloat c;
};

static struct movm_pair movm_gp;
static struct movm_three movm_gt;

static struct movm_fpair movm_gfp;
static struct movm_fthree movm_gft;

static struct movm_dpair movm_gdp;
static struct movm_dthree movm_gdt;

/*
 * Ordinary-C opacity helpers.
 * OPAQUE_REG macro.
 */

static Sint
opaque_si(x)
Sint x;
{
  movm_opaque_si = x;
  return movm_opaque_si;
}

static Sfloat
opaque_sf(x)
Sfloat x;
{
  movm_opaque_sf = x;
  return movm_opaque_sf;
}

static Dfloat
opaque_df(x)
Dfloat x;
{
  movm_opaque_df = x;
  return movm_opaque_df;
}

/*
 * Integer MOVM-style register-result forms.
 */

static Sint
movm_reg(a)
Sint a;
{
  a = opaque_si(a);
  return __builtin_abs(a);
}

static Sint
movm_if(a)
Sint a;
{
  a = opaque_si(a);
  if (a < 0)
    return -a;
  return a;
}

static Sint
movm_if_positive(a)
Sint a;
{
  a = opaque_si(a);
  if (a >= 0)
    return a;
  return -a;
}

static Sint
movm_local(a)
Sint a;
{
  Sint r;

  a = opaque_si(a);
  r = __builtin_abs(a);
  return r;
}

static Sint
movm_reuse(a)
Sint a;
{
  a = opaque_si(a);
  a = __builtin_abs(a);
  return a;
}

static Sint
movm_mem(p)
Sint *p;
{
  return __builtin_abs(*p);
}

static Sint
movm_mem_plus(p, x)
Sint *p;
Sint x;
{
  return __builtin_abs(*p) + x;
}

static Sint
movm_mem_minus(p, x)
Sint *p;
Sint x;
{
  return __builtin_abs(*p) - x;
}

static Sint
movm_volatile_mem(p)
volatile Sint *p;
{
  Sint x;

  x = *p;
  return __builtin_abs(x);
}

static Sint
movm_global_a()
{
  return __builtin_abs(movm_ga);
}

static Sint
movm_global_b()
{
  return __builtin_abs(movm_gb);
}

static Sint
movm_volatile_global()
{
  Sint x;

  x = movm_vga;
  return __builtin_abs(x);
}

static Sint
movm_array(v, i)
Sint *v;
Sint i;
{
  return __builtin_abs(v[i & 017]);
}

static Sint
movm_global_array(i)
Sint i;
{
  return __builtin_abs(movm_buf[i & 017]);
}

static Sint
movm_struct_a(p)
struct movm_pair *p;
{
  return __builtin_abs(p->a);
}

static Sint
movm_struct_b(p)
struct movm_pair *p;
{
  return __builtin_abs(p->b);
}

static Sint
movm_global_struct_a()
{
  return __builtin_abs(movm_gp.a);
}

static Sint
movm_global_struct_b()
{
  return __builtin_abs(movm_gt.b);
}

static Sint
movm_indirect(pp)
Sint **pp;
{
  Sint *p;

  p = *pp;
  return __builtin_abs(*p);
}

static Sint
movm_indexed_indirect(pp, i)
Sint **pp;
Sint i;
{
  Sint *p;

  p = *pp;
  return __builtin_abs(p[i & 017]);
}

/*
 * Promoted small signed integer inputs.
 */

static Sint
movm_qi(a)
sQint a;
{
  Sint x;

  x = a;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_hi(a)
Hint a;
{
  Sint x;

  x = a;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_qi_mem(p)
sQint *p;
{
  Sint x;

  x = *p;
  return __builtin_abs(x);
}

static Sint
movm_hi_mem(p)
Hint *p;
{
  Sint x;

  x = *p;
  return __builtin_abs(x);
}

/*
 * Integer expression sources.
 */

static Sint
movm_expr_add(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_expr_sub(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_expr_xor(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_expr_and(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_negated_expr(a)
Sint a;
{
  Sint x;

  x = -a;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_shift_expr(a)
Sint a;
{
  Sint x;

  x = a >> 3;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_literal_positive()
{
  Sint x;

  x = 0123456;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_literal_negative()
{
  Sint x;

  x = -0123456;
  x = opaque_si(x);
  return __builtin_abs(x);
}

static Sint
movm_literal_large_negative()
{
  Sint x;

  x = -0123456123;
  x = opaque_si(x);
  return __builtin_abs(x);
}

/*
 * Integer MOVMM-style store forms.
 */

static void
movmm_reg_mem(a, p)
Sint a;
Sint *p;
{
  a = opaque_si(a);
  *p = __builtin_abs(a);
}

static Sint
movmm_reg_mem_ret_mem(a, p)
Sint a;
Sint *p;
{
  a = opaque_si(a);
  *p = __builtin_abs(a);
  return *p;
}

static Sint
movmm_reg_mem_ret_abs(a, p)
Sint a;
Sint *p;
{
  Sint r;

  a = opaque_si(a);
  r = __builtin_abs(a);
  *p = r;
  return r;
}

static void
movmm_mem_mem(src, dst)
Sint *src;
Sint *dst;
{
  *dst = __builtin_abs(*src);
}

static Sint
movmm_mem_mem_ret(src, dst)
Sint *src;
Sint *dst;
{
  *dst = __builtin_abs(*src);
  return *dst;
}

static void
movmm_volatile(dst, a)
volatile Sint *dst;
Sint a;
{
  a = opaque_si(a);
  *dst = __builtin_abs(a);
}

static Sint
movmm_global(a)
Sint a;
{
  a = opaque_si(a);
  movm_ga = __builtin_abs(a);
  return movm_ga;
}

static Sint
movmm_global_from_mem(p)
Sint *p;
{
  movm_gb = __builtin_abs(*p);
  return movm_gb;
}

static void
movmm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  a = opaque_si(a);
  v[i & 017] = __builtin_abs(a);
}

static Sint
movmm_array_ret(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  a = opaque_si(a);
  v[i & 017] = __builtin_abs(a);
  return v[i & 017];
}

static void
movmm_global_array(i, a)
Sint i;
Sint a;
{
  a = opaque_si(a);
  movm_buf[i & 017] = __builtin_abs(a);
}

static void
movmm_struct_a(p, a)
struct movm_pair *p;
Sint a;
{
  a = opaque_si(a);
  p->a = __builtin_abs(a);
}

static void
movmm_struct_b(p, a)
struct movm_pair *p;
Sint a;
{
  a = opaque_si(a);
  p->b = __builtin_abs(a);
}

static Sint
movmm_struct_ret(p, a)
struct movm_pair *p;
Sint a;
{
  a = opaque_si(a);
  p->b = __builtin_abs(a);
  return p->b;
}

static void
movmm_global_struct(a)
Sint a;
{
  a = opaque_si(a);
  movm_gp.b = __builtin_abs(a);
}

static void
movmm_indirect(pp, a)
Sint **pp;
Sint a;
{
  Sint *p;

  a = opaque_si(a);
  p = *pp;
  *p = __builtin_abs(a);
}

static void
movmm_indexed_indirect(pp, i, a)
Sint **pp;
Sint i;
Sint a;
{
  Sint *p;

  a = opaque_si(a);
  p = *pp;
  p[i & 017] = __builtin_abs(a);
}

/*
 * Integer MOVMS-style self forms.
 */

static Sint
movms_mem(p)
Sint *p;
{
  *p = __builtin_abs(*p);
  return *p;
}

static Sint
movms_mem_add(p, x)
Sint *p;
Sint x;
{
  *p = __builtin_abs(*p);
  return *p + x;
}

static Sint
movms_mem_twice(p)
Sint *p;
{
  *p = __builtin_abs(*p);
  *p = __builtin_abs(*p);
  return *p;
}

static void
movms_mem_void(p)
Sint *p;
{
  *p = __builtin_abs(*p);
}

static Sint
movms_volatile_mem(p)
volatile Sint *p;
{
  Sint x;

  x = *p;
  x = __builtin_abs(x);
  *p = x;
  return *p;
}

static void
movms_volatile_void(p)
volatile Sint *p;
{
  Sint x;

  x = *p;
  *p = __builtin_abs(x);
}

static Sint
movms_global_a()
{
  movm_ga = __builtin_abs(movm_ga);
  return movm_ga;
}

static Sint
movms_global_b()
{
  movm_gb = __builtin_abs(movm_gb);
  return movm_gb;
}

static void
movms_global_void()
{
  movm_gc = __builtin_abs(movm_gc);
}

static Sint
movms_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = __builtin_abs(v[i & 017]);
  return v[i & 017];
}

static void
movms_array_void(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = __builtin_abs(v[i & 017]);
}

static Sint
movms_global_array(i)
Sint i;
{
  movm_buf[i & 017] = __builtin_abs(movm_buf[i & 017]);
  return movm_buf[i & 017];
}

static Sint
movms_struct_a(p)
struct movm_pair *p;
{
  p->a = __builtin_abs(p->a);
  return p->a;
}

static Sint
movms_struct_b(p)
struct movm_pair *p;
{
  p->b = __builtin_abs(p->b);
  return p->b;
}

static void
movms_struct_void(p)
struct movm_pair *p;
{
  p->b = __builtin_abs(p->b);
}

static Sint
movms_global_struct_a()
{
  movm_gp.a = __builtin_abs(movm_gp.a);
  return movm_gp.a;
}

static Sint
movms_global_struct_b()
{
  movm_gt.b = __builtin_abs(movm_gt.b);
  return movm_gt.b;
}

static Sint
movms_indirect(pp)
Sint **pp;
{
  Sint *p;

  p = *pp;
  *p = __builtin_abs(*p);
  return *p;
}

static Sint
movms_indexed_indirect(pp, i)
Sint **pp;
Sint i;
{
  Sint *p;

  p = *pp;
  p[i & 017] = __builtin_abs(p[i & 017]);
  return p[i & 017];
}

/*
 * Integer result-consumer and control-flow pressure.
 */

static Sint
movm_branch_reg(a)
Sint a;
{
  Sint r;

  a = opaque_si(a);
  r = __builtin_abs(a);
  if (r == 0)
    return 1;
  return r;
}

static Sint
movm_branch_mem(p)
Sint *p;
{
  Sint r;

  r = __builtin_abs(*p);
  if (r < 0)
    return -1;
  return r;
}

static Sint
movms_branch(p)
Sint *p;
{
  *p = __builtin_abs(*p);
  if (*p == 0)
    return 1;
  return *p;
}

static Sint
movm_select(a, b, c)
Sint a;
Sint b;
Sint c;
{
  a = opaque_si(a);
  b = opaque_si(b);
  if (c != 0)
    return __builtin_abs(a);
  return __builtin_abs(b);
}

static Sint
movm_call_pressure_reg(a)
Sint a;
{
  Sint r;

  a = opaque_si(a);
  r = __builtin_abs(a);
  clobber();
  return r + a;
}

static Sint
movm_call_pressure_mem(p)
Sint *p;
{
  Sint r;

  r = __builtin_abs(*p);
  clobber();
  return r + *p;
}

static Sint
movmm_call_pressure(dst, a)
Sint *dst;
Sint a;
{
  a = opaque_si(a);
  *dst = __builtin_abs(a);
  clobber();
  return *dst;
}

static Sint
movms_call_pressure(p)
Sint *p;
{
  *p = __builtin_abs(*p);
  clobber();
  return *p;
}

static Sint
movm_two_values(a, b)
Sint a;
Sint b;
{
  Sint x;
  Sint y;

  a = opaque_si(a);
  b = opaque_si(b);
  x = __builtin_abs(a);
  y = __builtin_abs(b);
  return x + y;
}

static Sint
movm_two_mems(a, b)
Sint *a;
Sint *b;
{
  Sint x;
  Sint y;

  x = __builtin_abs(*a);
  y = __builtin_abs(*b);
  return x + y;
}

static void
movmm_two_stores(p, q, a, b)
Sint *p;
Sint *q;
Sint a;
Sint b;
{
  a = opaque_si(a);
  b = opaque_si(b);
  *p = __builtin_abs(a);
  *q = __builtin_abs(b);
}

static Sint
movms_two_mems(p, q)
Sint *p;
Sint *q;
{
  *p = __builtin_abs(*p);
  *q = __builtin_abs(*q);
  return *p + *q;
}

static Sint
movm_loop_sum(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += __builtin_abs(v[i & 017]);

  return r;
}

static void
movms_loop(v, n)
Sint *v;
Sint n;
{
  Sint i;

  for (i = 0; i < n; ++i)
    v[i & 017] = __builtin_abs(v[i & 017]);
}

static Sint
movms_loop_sum(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i) {
    v[i & 017] = __builtin_abs(v[i & 017]);
    r += v[i & 017];
  }

  return r;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
movm2(a, e)
Sint a;
Sint *e;
{
  return __builtin_abs(*e);
}

static Sint
movmm3(a, e)
Sint a;
Sint *e;
{
  a = opaque_si(a);
  *e = __builtin_abs(a);
  return *e;
}

static Sint
movms4(e)
Sint *e;
{
  *e = __builtin_abs(*e);
  return *e;
}

/*
 * Sfloat MOVM-style register-result forms.
 */

static Sfloat
sfmovm_reg(a)
Sfloat a;
{
  a = opaque_sf(a);
  return a < 0 ? -a : a;
}

static Sfloat
sfmovm_if(a)
Sfloat a;
{
  a = opaque_sf(a);
  if (a < 0)
    return -a;
  return a;
}

static Sfloat
sfmovm_if_positive(a)
Sfloat a;
{
  a = opaque_sf(a);
  if (a >= 0)
    return a;
  return -a;
}

static Sfloat
sfmovm_local(a)
Sfloat a;
{
  Sfloat r;

  a = opaque_sf(a);
  r = a < 0 ? -a : a;
  return r;
}

static Sfloat
sfmovm_reuse(a)
Sfloat a;
{
  a = opaque_sf(a);
  a = a < 0 ? -a : a;
  return a;
}

static Sfloat
sfmovm_mem(p)
Sfloat *p;
{
  return *p < 0 ? -*p : *p;
}

static Sfloat
sfmovm_volatile_mem(p)
volatile Sfloat *p;
{
  Sfloat x;

  x = *p;
  return x < 0 ? -x : x;
}

static Sfloat
sfmovm_global_a()
{
  return movm_sfa < 0 ? -movm_sfa : movm_sfa;
}

static Sfloat
sfmovm_global_b()
{
  return movm_sfb < 0 ? -movm_sfb : movm_sfb;
}

static Sfloat
sfmovm_volatile_global()
{
  Sfloat x;

  x = movm_vsfa;
  return x < 0 ? -x : x;
}

static Sfloat
sfmovm_array(v, i)
Sfloat *v;
Sint i;
{
  return v[i & 017] < 0 ? -v[i & 017] : v[i & 017];
}

static Sfloat
sfmovm_global_array(i)
Sint i;
{
  return movm_sfbuf[i & 017] < 0
       ? -movm_sfbuf[i & 017]
       : movm_sfbuf[i & 017];
}

static Sfloat
sfmovm_struct_a(p)
struct movm_fpair *p;
{
  return p->a < 0 ? -p->a : p->a;
}

static Sfloat
sfmovm_struct_b(p)
struct movm_fpair *p;
{
  return p->b < 0 ? -p->b : p->b;
}

static Sfloat
sfmovm_global_struct_a()
{
  return movm_gfp.a < 0 ? -movm_gfp.a : movm_gfp.a;
}

static Sfloat
sfmovm_global_struct_b()
{
  return movm_gft.b < 0 ? -movm_gft.b : movm_gft.b;
}

static Sfloat
sfmovm_expr_add(a, b)
Sfloat a;
Sfloat b;
{
  Sfloat x;

  x = a + b;
  x = opaque_sf(x);
  return x < 0 ? -x : x;
}

static Sfloat
sfmovm_expr_sub(a, b)
Sfloat a;
Sfloat b;
{
  Sfloat x;

  x = a - b;
  x = opaque_sf(x);
  return x < 0 ? -x : x;
}

static Sfloat
sfmovm_literal_negative()
{
  Sfloat x;

  x = -123.0;
  x = opaque_sf(x);
  return x < 0 ? -x : x;
}

/*
 * Sfloat MOVMM-style store forms.
 */

static void
sfmovmm_reg_mem(a, p)
Sfloat a;
Sfloat *p;
{
  a = opaque_sf(a);
  *p = a < 0 ? -a : a;
}

static Sfloat
sfmovmm_reg_mem_ret(a, p)
Sfloat a;
Sfloat *p;
{
  Sfloat r;

  a = opaque_sf(a);
  r = a < 0 ? -a : a;
  *p = r;
  return r;
}

static void
sfmovmm_mem_mem(src, dst)
Sfloat *src;
Sfloat *dst;
{
  *dst = *src < 0 ? -*src : *src;
}

static Sfloat
sfmovmm_global(a)
Sfloat a;
{
  a = opaque_sf(a);
  movm_sfa = a < 0 ? -a : a;
  return movm_sfa;
}

static void
sfmovmm_array(v, i, a)
Sfloat *v;
Sint i;
Sfloat a;
{
  a = opaque_sf(a);
  v[i & 017] = a < 0 ? -a : a;
}

static void
sfmovmm_struct_a(p, a)
struct movm_fpair *p;
Sfloat a;
{
  a = opaque_sf(a);
  p->a = a < 0 ? -a : a;
}

/*
 * Sfloat MOVMS-style self forms.
 */

static Sfloat
sfmovms_mem(p)
Sfloat *p;
{
  *p = *p < 0 ? -*p : *p;
  return *p;
}

static Sfloat
sfmovms_mem_add(p, x)
Sfloat *p;
Sfloat x;
{
  *p = *p < 0 ? -*p : *p;
  return *p + x;
}

static void
sfmovms_mem_void(p)
Sfloat *p;
{
  *p = *p < 0 ? -*p : *p;
}

static Sfloat
sfmovms_volatile_mem(p)
volatile Sfloat *p;
{
  Sfloat x;

  x = *p;
  x = x < 0 ? -x : x;
  *p = x;
  return *p;
}

static Sfloat
sfmovms_global_a()
{
  movm_sfa = movm_sfa < 0 ? -movm_sfa : movm_sfa;
  return movm_sfa;
}

static Sfloat
sfmovms_global_b()
{
  movm_sfb = movm_sfb < 0 ? -movm_sfb : movm_sfb;
  return movm_sfb;
}

static void
sfmovms_global_void()
{
  movm_sfc = movm_sfc < 0 ? -movm_sfc : movm_sfc;
}

static Sfloat
sfmovms_array(v, i)
Sfloat *v;
Sint i;
{
  v[i & 017] = v[i & 017] < 0 ? -v[i & 017] : v[i & 017];
  return v[i & 017];
}

static Sfloat
sfmovms_global_array(i)
Sint i;
{
  movm_sfbuf[i & 017] = movm_sfbuf[i & 017] < 0
                      ? -movm_sfbuf[i & 017]
                      : movm_sfbuf[i & 017];
  return movm_sfbuf[i & 017];
}

static Sfloat
sfmovms_struct_a(p)
struct movm_fpair *p;
{
  p->a = p->a < 0 ? -p->a : p->a;
  return p->a;
}

static Sfloat
sfmovms_struct_b(p)
struct movm_fpair *p;
{
  p->b = p->b < 0 ? -p->b : p->b;
  return p->b;
}

static Sfloat
sfmovm_branch_reg(a)
Sfloat a;
{
  Sfloat r;

  a = opaque_sf(a);
  r = a < 0 ? -a : a;
  if (r == 0)
    return 1.0;
  return r;
}

static Sfloat
sfmovm_call_pressure_reg(a)
Sfloat a;
{
  Sfloat r;

  a = opaque_sf(a);
  r = a < 0 ? -a : a;
  clobber();
  return r + a;
}

static Sfloat
sfmovm_two_values(a, b)
Sfloat a;
Sfloat b;
{
  Sfloat x;
  Sfloat y;

  a = opaque_sf(a);
  b = opaque_sf(b);
  x = a < 0 ? -a : a;
  y = b < 0 ? -b : b;
  return x + y;
}

static Sfloat
sfmovms_loop_sum(v, n)
Sfloat *v;
Sint n;
{
  Sint i;
  Sfloat r;

  r = 0;
  for (i = 0; i < n; ++i) {
    v[i & 017] = v[i & 017] < 0 ? -v[i & 017] : v[i & 017];
    r += v[i & 017];
  }

  return r;
}

/*
 * Dfloat MOVM-style register-result forms.
 */

static Dfloat
dfmovm_reg(a)
Dfloat a;
{
  a = opaque_df(a);
  return a < 0 ? -a : a;
}

static Dfloat
dfmovm_if(a)
Dfloat a;
{
  a = opaque_df(a);
  if (a < 0)
    return -a;
  return a;
}

static Dfloat
dfmovm_if_positive(a)
Dfloat a;
{
  a = opaque_df(a);
  if (a >= 0)
    return a;
  return -a;
}

static Dfloat
dfmovm_local(a)
Dfloat a;
{
  Dfloat r;

  a = opaque_df(a);
  r = a < 0 ? -a : a;
  return r;
}

static Dfloat
dfmovm_reuse(a)
Dfloat a;
{
  a = opaque_df(a);
  a = a < 0 ? -a : a;
  return a;
}

static Dfloat
dfmovm_mem(p)
Dfloat *p;
{
  return *p < 0 ? -*p : *p;
}

static Dfloat
dfmovm_volatile_mem(p)
volatile Dfloat *p;
{
  Dfloat x;

  x = *p;
  return x < 0 ? -x : x;
}

static Dfloat
dfmovm_global_a()
{
  return movm_dfa < 0 ? -movm_dfa : movm_dfa;
}

static Dfloat
dfmovm_global_b()
{
  return movm_dfb < 0 ? -movm_dfb : movm_dfb;
}

static Dfloat
dfmovm_volatile_global()
{
  Dfloat x;

  x = movm_vdfa;
  return x < 0 ? -x : x;
}

static Dfloat
dfmovm_array(v, i)
Dfloat *v;
Sint i;
{
  return v[i & 017] < 0 ? -v[i & 017] : v[i & 017];
}

static Dfloat
dfmovm_global_array(i)
Sint i;
{
  return movm_dfbuf[i & 017] < 0
       ? -movm_dfbuf[i & 017]
       : movm_dfbuf[i & 017];
}

static Dfloat
dfmovm_struct_a(p)
struct movm_dpair *p;
{
  return p->a < 0 ? -p->a : p->a;
}

static Dfloat
dfmovm_struct_b(p)
struct movm_dpair *p;
{
  return p->b < 0 ? -p->b : p->b;
}

static Dfloat
dfmovm_global_struct_a()
{
  return movm_gdp.a < 0 ? -movm_gdp.a : movm_gdp.a;
}

static Dfloat
dfmovm_global_struct_b()
{
  return movm_gdt.b < 0 ? -movm_gdt.b : movm_gdt.b;
}

static Dfloat
dfmovm_expr_add(a, b)
Dfloat a;
Dfloat b;
{
  Dfloat x;

  x = a + b;
  x = opaque_df(x);
  return x < 0 ? -x : x;
}

static Dfloat
dfmovm_expr_sub(a, b)
Dfloat a;
Dfloat b;
{
  Dfloat x;

  x = a - b;
  x = opaque_df(x);
  return x < 0 ? -x : x;
}

static Dfloat
dfmovm_literal_negative()
{
  Dfloat x;

  x = -123.0;
  x = opaque_df(x);
  return x < 0 ? -x : x;
}

/*
 * Dfloat MOVMM-style store forms.
 */

static void
dfmovmm_reg_mem(a, p)
Dfloat a;
Dfloat *p;
{
  a = opaque_df(a);
  *p = a < 0 ? -a : a;
}

static Dfloat
dfmovmm_reg_mem_ret(a, p)
Dfloat a;
Dfloat *p;
{
  Dfloat r;

  a = opaque_df(a);
  r = a < 0 ? -a : a;
  *p = r;
  return r;
}

static void
dfmovmm_mem_mem(src, dst)
Dfloat *src;
Dfloat *dst;
{
  *dst = *src < 0 ? -*src : *src;
}

static Dfloat
dfmovmm_global(a)
Dfloat a;
{
  a = opaque_df(a);
  movm_dfa = a < 0 ? -a : a;
  return movm_dfa;
}

static void
dfmovmm_array(v, i, a)
Dfloat *v;
Sint i;
Dfloat a;
{
  a = opaque_df(a);
  v[i & 017] = a < 0 ? -a : a;
}

static void
dfmovmm_struct_a(p, a)
struct movm_dpair *p;
Dfloat a;
{
  a = opaque_df(a);
  p->a = a < 0 ? -a : a;
}

/*
 * Dfloat MOVMS-style self forms.
 */

static Dfloat
dfmovms_mem(p)
Dfloat *p;
{
  *p = *p < 0 ? -*p : *p;
  return *p;
}

static Dfloat
dfmovms_mem_add(p, x)
Dfloat *p;
Dfloat x;
{
  *p = *p < 0 ? -*p : *p;
  return *p + x;
}

static void
dfmovms_mem_void(p)
Dfloat *p;
{
  *p = *p < 0 ? -*p : *p;
}

static Dfloat
dfmovms_volatile_mem(p)
volatile Dfloat *p;
{
  Dfloat x;

  x = *p;
  x = x < 0 ? -x : x;
  *p = x;
  return *p;
}

static Dfloat
dfmovms_global_a()
{
  movm_dfa = movm_dfa < 0 ? -movm_dfa : movm_dfa;
  return movm_dfa;
}

static Dfloat
dfmovms_global_b()
{
  movm_dfb = movm_dfb < 0 ? -movm_dfb : movm_dfb;
  return movm_dfb;
}

static void
dfmovms_global_void()
{
  movm_dfc = movm_dfc < 0 ? -movm_dfc : movm_dfc;
}

static Dfloat
dfmovms_array(v, i)
Dfloat *v;
Sint i;
{
  v[i & 017] = v[i & 017] < 0 ? -v[i & 017] : v[i & 017];
  return v[i & 017];
}

static Dfloat
dfmovms_global_array(i)
Sint i;
{
  movm_dfbuf[i & 017] = movm_dfbuf[i & 017] < 0
                      ? -movm_dfbuf[i & 017]
                      : movm_dfbuf[i & 017];
  return movm_dfbuf[i & 017];
}

static Dfloat
dfmovms_struct_a(p)
struct movm_dpair *p;
{
  p->a = p->a < 0 ? -p->a : p->a;
  return p->a;
}

static Dfloat
dfmovms_struct_b(p)
struct movm_dpair *p;
{
  p->b = p->b < 0 ? -p->b : p->b;
  return p->b;
}

static Dfloat
dfmovm_branch_reg(a)
Dfloat a;
{
  Dfloat r;

  a = opaque_df(a);
  r = a < 0 ? -a : a;
  if (r == 0)
    return 1.0;
  return r;
}

static Dfloat
dfmovm_call_pressure_reg(a)
Dfloat a;
{
  Dfloat r;

  a = opaque_df(a);
  r = a < 0 ? -a : a;
  clobber();
  return r + a;
}

static Dfloat
dfmovm_two_values(a, b)
Dfloat a;
Dfloat b;
{
  Dfloat x;
  Dfloat y;

  a = opaque_df(a);
  b = opaque_df(b);
  x = a < 0 ? -a : a;
  y = b < 0 ? -b : b;
  return x + y;
}

static Dfloat
dfmovms_loop_sum(v, n)
Dfloat *v;
Sint n;
{
  Sint i;
  Dfloat r;

  r = 0;
  for (i = 0; i < n; ++i) {
    v[i & 017] = v[i & 017] < 0 ? -v[i & 017] : v[i & 017];
    r += v[i & 017];
  }

  return r;
}

/*
 * Smoke entry points.
 */

Sint
movm_smoke(a, b, p)
Sint a;
Sint b;
Sint *p;
{
  Sint r;

  r = movm_reg(a);
  r += movm_mem(p);
  r += movm_expr_sub(a, b);
  r += movms_mem(p);
  return r;
}

Sfloat
sfmovm_smoke(a, b, p)
Sfloat a;
Sfloat b;
Sfloat *p;
{
  Sfloat r;

  r = sfmovm_reg(a);
  r += sfmovm_expr_sub(a, b);
  r += sfmovms_mem(p);
  return r;
}

Dfloat
dfmovm_smoke(a, b, p)
Dfloat a;
Dfloat b;
Dfloat *p;
{
  Dfloat r;

  r = dfmovm_reg(a);
  r += dfmovm_expr_sub(a, b);
  r += dfmovms_mem(p);
  return r;
}

/*
 * Macro-expanded coverage hooks used by the existing harness.
 */

BOTH (movms_both_mem, __builtin_abs(*b))
BOTH (movmm_both_reg, __builtin_abs(a))
