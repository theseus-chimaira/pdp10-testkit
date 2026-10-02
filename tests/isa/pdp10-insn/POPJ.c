#include "insns.h"

/*
 * POPJ instruction coverage for PDP-6/166 and KA10.
 *
 * Main intended form:
 *   POPJ 17,      normal function return through the PDP-10 stack pointer
 *
 * Also keep the computed-goto/register-stack-pointer cases.  They are
 * GNU C extensions and may not currently lower to POPJ n,, but they
 * express the backend opportunity documented in pdp10.md:
 *
 *   goto *p--;
 *
 * This file is therefore both ordinary epilogue coverage and a future
 * backend-improvement test for non-17 POPJ forms.
 */

extern void clobber(void);
extern Sint ext_sint(Sint);
extern uSint ext_usint(uSint);
extern Sint *ext_ptr(Sint *);
extern void *ext_vptr(void *);
extern Sfloat ext_sfloat(Sfloat);

static Sint popj_ga;
static Sint popj_gb;
static uSint popj_uga;
static Sfloat popj_fa;

struct popj_pair {
  Sint a;
  Sint b;
};

static struct popj_pair popj_gp;

static void
popj_void(void)
{
}

static void
popj_void_call(void)
{
  clobber();
}

static Sint
popj_sint_zero(void)
{
  return 0;
}

static Sint
popj_sint_one(void)
{
  return 1;
}

static Sint
popj_sint_arg(x)
Sint x;
{
  return x;
}

static Sint
popj_sint_add(a, b)
Sint a;
Sint b;
{
  return a + b;
}

static Sint
popj_sint_global(void)
{
  return popj_ga;
}

static Sint
popj_sint_store_return(x)
Sint x;
{
  popj_ga = x;
  return x;
}

static Sint
popj_sint_call(x)
Sint x;
{
  return ext_sint(x);
}

static Sint
popj_sint_call_add(a, b)
Sint a;
Sint b;
{
  return ext_sint(a) + b;
}

static Sint
popj_sint_after_call(a, b)
Sint a;
Sint b;
{
  Sint t;

  t = ext_sint(a);
  clobber();
  return t + b;
}

static uSint
popj_usint_arg(x)
uSint x;
{
  return x;
}

static uSint
popj_usint_add(a, b)
uSint a;
uSint b;
{
  return a + b;
}

static uSint
popj_usint_call(x)
uSint x;
{
  return ext_usint(x);
}

static Sfloat
popj_sfloat_arg(x)
Sfloat x;
{
  return x;
}

static Sfloat
popj_sfloat_add(a, b)
Sfloat a;
Sfloat b;
{
  return a + b;
}

static Sfloat
popj_sfloat_call(x)
Sfloat x;
{
  return ext_sfloat(x);
}

static Sint *
popj_ptr_arg(p)
Sint *p;
{
  return p;
}

static Sint *
popj_ptr_inc(p)
Sint *p;
{
  return p + 1;
}

static Sint *
popj_ptr_call(p)
Sint *p;
{
  return ext_ptr(p);
}

static void *
popj_vptr_arg(p)
void *p;
{
  return p;
}

static void *
popj_vptr_call(p)
void *p;
{
  return ext_vptr(p);
}

static struct popj_pair
popj_struct_return(a, b)
Sint a;
Sint b;
{
  struct popj_pair r;

  r.a = a;
  r.b = b;
  return r;
}

static struct popj_pair
popj_struct_global(void)
{
  return popj_gp;
}

static Sint
popj_many_args(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  return a + b + c + d + e + f;
}

static Sint
popj_many_locals(a, b)
Sint a;
Sint b;
{
  Sint c;
  Sint d;
  Sint e;
  Sint f;

  c = a + b;
  d = c + popj_ga;
  e = d + popj_gb;
  f = e ^ 0123456;
  return f;
}

static Sint
popj_branch(a, b)
Sint a;
Sint b;
{
  if (a < b)
    return a;
  return b;
}

static Sint
popj_branch_call(a, b)
Sint a;
Sint b;
{
  if (a < b)
    return ext_sint(a);
  return ext_sint(b);
}

static Sint
popj_loop(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += i;
  return s;
}

static Sint
popj_switch(x)
Sint x;
{
  switch (x & 3) {
  case 0:
    return popj_ga;
  case 1:
    return popj_gb;
  case 2:
    return popj_ga + popj_gb;
  default:
    return x;
  }
}

static void
popj_store_globals(a, b)
Sint a;
Sint b;
{
  popj_ga = a;
  popj_gb = b;
}

static uSint
popj_store_unsigned(a, b)
uSint a;
uSint b;
{
  popj_uga = a ^ b;
  return popj_uga;
}

static Sfloat
popj_store_float(a)
Sfloat a;
{
  popj_fa = a;
  return popj_fa;
}

/*
 * GNU computed-goto cases.  These are intentionally small.  If the
 * backend eventually recognizes them, they are natural candidates for
 * POPJ with a non-17 stack pointer register.
 */


/*
 * The natural non-17 POPJ stress cases would use global register
 * variables pinned to accumulator registers.  GCC 3.2 rejects numeric
 * PDP-10 register names in asm("...") register-variable declarations,
 * even though the backend prints registers as numbers.  Keep this file
 * focused on ordinary POPJ 17, coverage for now.
 */
