#include "insns.h"


/*
 * EXCH instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   EXCH AC,E
 *
 * The natural C source shape is a register temporary swapped with a
 * word-sized memory object.  Memory-to-memory swaps cannot be a single
 * EXCH, but they are included as pressure/fallback coverage.
 */

Sint exga;
Sint exgb;
uSint exua;
uSint exub;

struct exch_struct {
  Sint a;
  Sint b;
  Sint c;
};

struct exch_struct exgs;

static Sint
exch_reg_mem(a, e)
Sint a;
Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  return a;
}

static Sint
exch_reg_mem_alt(a, e)
Sint a;
Sint *e;
{
  Sint tmp;

  tmp = *e;
  *e = a;
  a = tmp;
  return a;
}

static Sint
exch_reg_mem_return_new_mem(a, e)
Sint a;
Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  return *e;
}

static Sint
exch_reg_mem_sum(a, e)
Sint a;
Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  return a + *e;
}

static void
exch_reg_mem_void(a, e)
Sint a;
Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
}

static Sint
exch_global(a)
Sint a;
{
  Sint tmp;

  tmp = a;
  a = exga;
  exga = tmp;
  return a;
}

static Sint
exch_global_alt(a)
Sint a;
{
  Sint tmp;

  tmp = exgb;
  exgb = a;
  a = tmp;
  return a;
}

static Sint
exch_global_sum(a)
Sint a;
{
  Sint tmp;

  tmp = a;
  a = exga;
  exga = tmp;
  return a + exga;
}

static uSint
uexch_reg_mem(a, e)
uSint a;
uSint *e;
{
  uSint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  return a;
}

static uSint
uexch_global(a)
uSint a;
{
  uSint tmp;

  tmp = a;
  a = exua;
  exua = tmp;
  return a;
}

static Sint
exch_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  Sint tmp;
  Sint *p;

  p = &v[i & 7];
  tmp = a;
  a = *p;
  *p = tmp;
  return a;
}

static Sint
exch_array_alt(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  Sint tmp;
  Sint *p;

  p = &v[i & 7];
  tmp = *p;
  *p = a;
  a = tmp;
  return a;
}

static Sint
exch_array_sum(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  Sint tmp;
  Sint *p;

  p = &v[i & 7];
  tmp = a;
  a = *p;
  *p = tmp;
  return a + *p;
}

static Sint
exch_struct_member(a, p)
Sint a;
struct exch_struct *p;
{
  Sint tmp;

  tmp = a;
  a = p->b;
  p->b = tmp;
  return a;
}

static Sint
exch_struct_member_alt(a, p)
Sint a;
struct exch_struct *p;
{
  Sint tmp;

  tmp = p->c;
  p->c = a;
  a = tmp;
  return a;
}

static Sint
exch_global_struct(a)
Sint a;
{
  Sint tmp;

  tmp = a;
  a = exgs.b;
  exgs.b = tmp;
  return a;
}

static Sint
exch_volatile(a, e)
Sint a;
volatile Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  return a;
}

static Sint
exch_volatile_sum(a, e)
Sint a;
volatile Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  return a + *e;
}

static void
exch_volatile_void(a, e)
Sint a;
volatile Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
}

static Sint
exch_call_pressure(a, e)
Sint a;
Sint *e;
{
  extern void clobber(void);
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;
  clobber();
  return a + *e;
}

static Sint
exch_two_swaps(a, b, e)
Sint a;
Sint b;
Sint *e;
{
  Sint tmp;

  tmp = a;
  a = *e;
  *e = tmp;

  tmp = b;
  b = *e;
  *e = tmp;

  return a + b + *e;
}

static Sint
exch_two_memory(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  Sint tmp;

  tmp = *p;
  *p = *q;
  *q = tmp;

  tmp = a;
  a = *p;
  *p = tmp;

  return a + *p + *q;
}

static Sint
exch_local_spill(a, b, e)
Sint a;
Sint b;
Sint *e;
{
  Sint l0;
  Sint l1;
  Sint tmp;

  l0 = a + 1;
  l1 = b + 2;

  tmp = l0;
  l0 = *e;
  *e = tmp;

  return l0 + l1 + *e;
}

static Sint
exch_ptr_chain(a, pp)
Sint a;
Sint **pp;
{
  Sint tmp;
  Sint *p;

  p = *pp;
  tmp = a;
  a = *p;
  *p = tmp;
  return a;
}

static Sint
exch_indexed_ptr_chain(a, pp, i)
Sint a;
Sint **pp;
Sint i;
{
  Sint tmp;
  Sint *p;

  p = *pp + (i & 7);
  tmp = a;
  a = *p;
  *p = tmp;
  return a + *p;
}
