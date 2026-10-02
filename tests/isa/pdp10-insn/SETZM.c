#include "insns.h"

/*
 * SETZM instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   SETZM memory <- 0
 *
 * This file focuses on stores of zero to memory.  If the zero value is
 * also used as a register result, that belongs mostly to SETZB.c.
 */

static Sint setzm_ga;
static Sint setzm_gb;
static uSint setzm_uga;
static Sfloat setzm_fa;
static Sfloat setzm_fb;
static Dfloat setzm_dfa;
static Dfloat setzm_dfb;
static Dint setzm_da;
static uDint setzm_uda;

static Sint setzm_buf[16];
static uSint setzm_ubuf[16];
static Sfloat setzm_fbuf[16];
static Dfloat setzm_dfbuf[8];
static Dint setzm_dbuf[8];

struct setzm_pair {
  Sint a;
  Sint b;
};

struct setzm_mixed {
  Sint a;
  uSint b;
  Sfloat c;
  Dfloat d;
  Dint e;
};

static struct setzm_pair setzm_gp;
static struct setzm_mixed setzm_gm;

static void
setzm_sint(p)
Sint *p;
{
  *p = 0;
}

static void
setzm_usint(p)
uSint *p;
{
  *p = 0;
}

static void
setzm_sfloat(p)
Sfloat *p;
{
  *p = 0;
}

static void
setzm_dfloat(p)
Dfloat *p;
{
  *p = 0;
}

static void
setzm_dint(p)
Dint *p;
{
  *p = 0;
}

static void
setzm_udint(p)
uDint *p;
{
  *p = 0;
}

static void
setzm_global_sint(void)
{
  setzm_ga = 0;
}

static void
setzm_global_sint_b(void)
{
  setzm_gb = 0;
}

static void
setzm_global_usint(void)
{
  setzm_uga = 0;
}

static void
setzm_global_sfloat(void)
{
  setzm_fa = 0;
}

static void
setzm_global_sfloat_b(void)
{
  setzm_fb = 0;
}

static void
setzm_global_dfloat(void)
{
  setzm_dfa = 0;
}

static void
setzm_global_dfloat_b(void)
{
  setzm_dfb = 0;
}

static void
setzm_global_dint(void)
{
  setzm_da = 0;
}

static void
setzm_global_udint(void)
{
  setzm_uda = 0;
}

static void
setzm_array_sint(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = 0;
}

static void
setzm_array_usint(v, i)
uSint *v;
Sint i;
{
  v[i & 017] = 0;
}

static void
setzm_array_sfloat(v, i)
Sfloat *v;
Sint i;
{
  v[i & 017] = 0;
}

static void
setzm_array_dfloat(v, i)
Dfloat *v;
Sint i;
{
  v[i & 07] = 0;
}

static void
setzm_array_dint(v, i)
Dint *v;
Sint i;
{
  v[i & 07] = 0;
}

static void
setzm_global_array_sint(i)
Sint i;
{
  setzm_buf[i & 017] = 0;
}

static void
setzm_global_array_usint(i)
Sint i;
{
  setzm_ubuf[i & 017] = 0;
}

static void
setzm_global_array_sfloat(i)
Sint i;
{
  setzm_fbuf[i & 017] = 0;
}

static void
setzm_global_array_dfloat(i)
Sint i;
{
  setzm_dfbuf[i & 07] = 0;
}

static void
setzm_global_array_dint(i)
Sint i;
{
  setzm_dbuf[i & 07] = 0;
}

static void
setzm_struct_a(p)
struct setzm_pair *p;
{
  p->a = 0;
}

static void
setzm_struct_b(p)
struct setzm_pair *p;
{
  p->b = 0;
}

static void
setzm_global_struct_a(void)
{
  setzm_gp.a = 0;
}

static void
setzm_global_struct_b(void)
{
  setzm_gp.b = 0;
}

static void
setzm_mixed_sint(p)
struct setzm_mixed *p;
{
  p->a = 0;
}

static void
setzm_mixed_usint(p)
struct setzm_mixed *p;
{
  p->b = 0;
}

static void
setzm_mixed_sfloat(p)
struct setzm_mixed *p;
{
  p->c = 0;
}

static void
setzm_mixed_dfloat(p)
struct setzm_mixed *p;
{
  p->d = 0;
}

static void
setzm_mixed_dint(p)
struct setzm_mixed *p;
{
  p->e = 0;
}

static void
setzm_global_mixed_sint(void)
{
  setzm_gm.a = 0;
}

static void
setzm_global_mixed_usint(void)
{
  setzm_gm.b = 0;
}

static void
setzm_global_mixed_sfloat(void)
{
  setzm_gm.c = 0;
}

static void
setzm_global_mixed_dfloat(void)
{
  setzm_gm.d = 0;
}

static void
setzm_global_mixed_dint(void)
{
  setzm_gm.e = 0;
}

static void
setzm_indirect(pp)
Sint **pp;
{
  **pp = 0;
}

static void
setzm_dindirect(pp)
Dint **pp;
{
  **pp = 0;
}

static void
setzm_volatile_sint(p)
volatile Sint *p;
{
  *p = 0;
}

static void
setzm_volatile_usint(p)
volatile uSint *p;
{
  *p = 0;
}

static void
setzm_volatile_sfloat(p)
volatile Sfloat *p;
{
  *p = 0;
}

static void
setzm_two_sint(p, q)
Sint *p;
Sint *q;
{
  *p = 0;
  *q = 0;
}

static void
setzm_two_mixed(p, q)
Sint *p;
Sfloat *q;
{
  *p = 0;
  *q = 0;
}

static void
setzm_three_globals(void)
{
  setzm_ga = 0;
  setzm_gb = 0;
  setzm_uga = 0;
}

static void
setzm_qi(p)
sQint *p;
{
  *p = 0;
}

static void
setzm_uqi(p)
uQint *p;
{
  *p = 0;
}

static void
setzm_hi(p)
Hint *p;
{
  *p = 0;
}

static void
setzm_uhi(p)
uHint *p;
{
  *p = 0;
}

static void
setzm_qi_array(p, i)
sQint *p;
Sint i;
{
  p[i & 017] = 0;
}

static void
setzm_uqi_array(p, i)
uQint *p;
Sint i;
{
  p[i & 017] = 0;
}

static void
setzm_hi_array(p, i)
Hint *p;
Sint i;
{
  p[i & 017] = 0;
}

static void
setzm_uhi_array(p, i)
uHint *p;
Sint i;
{
  p[i & 017] = 0;
}

static void
setzm_from_branch(p, a)
Sint *p;
Sint a;
{
  if (a)
    *p = 0;
  else
    *p = 0;
}

static void
setzm_after_expr(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  a += b;
  *p = 0;
}

static Sint
setzm_store_then_return_old_shape(p, a)
Sint *p;
Sint a;
{
  a += 1;
  *p = 0;
  return a;
}
