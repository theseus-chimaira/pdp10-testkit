#include "insns.h"

/*
 * SETZB instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   SETZB  AC and memory both receive zero
 *
 * SETZ, SETZI, and SETZM belong in the broader SETZ-family tests.
 * This file is focused on the "both" form: store zero to memory and
 * also keep/use the zero result in a register.
 */

static Sint setzb_ga;
static Sint setzb_gb;
static uSint setzb_uga;
static Sint setzb_buf[16];
static uSint setzb_ubuf[16];

struct setzb_pair {
  Sint a;
  Sint b;
};

struct setzb_upair {
  uSint a;
  uSint b;
};

static struct setzb_pair setzb_gp;
static struct setzb_upair setzb_ugp;

static Sint
setzb_mem_return(p)
Sint *p;
{
  *p = 0;
  return *p;
}

static Sint
setzb_mem_return_zero(p)
Sint *p;
{
  *p = 0;
  return 0;
}

static Sint
setzb_global_a(void)
{
  setzb_ga = 0;
  return setzb_ga;
}

static Sint
setzb_global_b(void)
{
  setzb_gb = 0;
  return setzb_gb;
}

static Sint
setzb_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = 0;
  return v[i & 017];
}

static Sint
setzb_global_array(i)
Sint i;
{
  setzb_buf[i & 017] = 0;
  return setzb_buf[i & 017];
}

static Sint
setzb_struct_a(p)
struct setzb_pair *p;
{
  p->a = 0;
  return p->a;
}

static Sint
setzb_struct_b(p)
struct setzb_pair *p;
{
  p->b = 0;
  return p->b;
}

static Sint
setzb_global_struct_a(void)
{
  setzb_gp.a = 0;
  return setzb_gp.a;
}

static Sint
setzb_global_struct_b(void)
{
  setzb_gp.b = 0;
  return setzb_gp.b;
}

static Sint
setzb_indirect(pp)
Sint **pp;
{
  **pp = 0;
  return **pp;
}

static Sint
setzb_volatile(p)
volatile Sint *p;
{
  *p = 0;
  return *p;
}

static Sint
setzb_two_mem(p, q)
Sint *p;
Sint *q;
{
  *p = 0;
  *q = 0;
  return *q;
}

static Sint
setzb_chain(p, q)
Sint *p;
Sint *q;
{
  *p = 0;
  *q = *p;
  return *q;
}

static Sint
setzb_after_expr(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  a += b;
  *p = 0;
  return *p;
}

static Sint
setzb_branch(p, a)
Sint *p;
Sint a;
{
  if (a)
    *p = 0;
  else
    *p = 0;

  return *p;
}

static Sint
setzb_local_store(p)
Sint *p;
{
  Sint z;

  z = 0;
  *p = z;
  return z;
}

static Sint
setzb_local_store_load(p)
Sint *p;
{
  Sint z;

  z = 0;
  *p = z;
  return *p;
}

static uSint
usetzb_mem_return(p)
uSint *p;
{
  *p = 0;
  return *p;
}

static uSint
usetzb_mem_return_zero(p)
uSint *p;
{
  *p = 0;
  return 0;
}

static uSint
usetzb_global(void)
{
  setzb_uga = 0;
  return setzb_uga;
}

static uSint
usetzb_array(v, i)
uSint *v;
Sint i;
{
  v[i & 017] = 0;
  return v[i & 017];
}

static uSint
usetzb_global_array(i)
Sint i;
{
  setzb_ubuf[i & 017] = 0;
  return setzb_ubuf[i & 017];
}

static uSint
usetzb_struct_a(p)
struct setzb_upair *p;
{
  p->a = 0;
  return p->a;
}

static uSint
usetzb_struct_b(p)
struct setzb_upair *p;
{
  p->b = 0;
  return p->b;
}

static uSint
usetzb_global_struct_a(void)
{
  setzb_ugp.a = 0;
  return setzb_ugp.a;
}

static uSint
usetzb_global_struct_b(void)
{
  setzb_ugp.b = 0;
  return setzb_ugp.b;
}

static sQint
setzb_qi_return(p)
sQint *p;
{
  *p = 0;
  return *p;
}

static uQint
setzb_uqi_return(p)
uQint *p;
{
  *p = 0;
  return *p;
}

static Hint
setzb_hi_return(p)
Hint *p;
{
  *p = 0;
  return *p;
}

static uHint
setzb_uhi_return(p)
uHint *p;
{
  *p = 0;
  return *p;
}

static Sint
setzb_qi_promote(p)
sQint *p;
{
  *p = 0;
  return *p;
}

static Sint
setzb_uqi_promote(p)
uQint *p;
{
  *p = 0;
  return *p;
}

static Sint
setzb_hi_promote(p)
Hint *p;
{
  *p = 0;
  return *p;
}

static Sint
setzb_uhi_promote(p)
uHint *p;
{
  *p = 0;
  return *p;
}

BOTH (setzb_mem, 0)
BOTH1 (uSint, usetzb_mem, 0)
