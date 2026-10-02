#include "insns.h"


/*
 * PUSHJ instruction coverage for PDP-6/166 and KA10.
 *
 * Intended ordinary forms:
 *   PUSHJ 17,symbol
 *   PUSHJ 17,(reg)
 *   PUSHJ 17,@memory
 *   PUSHJ 17,memory-indirect/addressed form
 *
 * Also keep GNU computed-goto cases.  pdp10.md explicitly notes that
 *   *++p = &&label; goto *f;
 * could be optimized into a PUSHJ with a non-17 stack register.
 */

extern void scalar_memory_forms(void);

extern void exv0(void);
extern void exv1(Sint);
extern void exv2(Sint, Sint);
extern void exvp(Sint *);

extern Sint exs0(void);
extern Sint exs1(Sint);
extern Sint exs2(Sint, Sint);
extern uSint ext_usint1(uSint);
extern Sfloat ext_sfloat1(Sfloat);
extern Sint *ext_ptr1(Sint *);

static void (*pushj_vfp)(void);
static Sint (*pushj_sfp)(Sint);
static Sint (*pushj_sfp2)(Sint, Sint);
static Sfloat (*pushj_ffp)(Sfloat);

static void (*pushj_vtab[8])(void);
static Sint (*pushj_stab[8])(Sint);

static Sint pushj_ga;
static Sint pushj_gb;
static uSint pushj_uga;
static Sfloat pushj_fa;
static Sint pushj_buf[8];

struct pushj_calls {
  void (*vf)(void);
  void (*v1)(Sint);
  Sint (*sf)(Sint);
  Sint (*sf2)(Sint, Sint);
  Sfloat (*ff)(Sfloat);
};

static struct pushj_calls pushj_gp;

static void
pushj_direct_void(void)
{
  scalar_memory_forms();
}

static void
pushj_direct_void_ext(void)
{
  exv0();
}

static void
pushj_direct_void_arg(x)
Sint x;
{
  exv1(x);
}

static void
pushj_direct_void_two(a, b)
Sint a;
Sint b;
{
  exv2(a, b);
}

static void
pushj_direct_void_ptr(p)
Sint *p;
{
  exvp(p);
}

static Sint
pushj_direct_return0(void)
{
  return exs0();
}

static Sint
pushj_direct_return1(x)
Sint x;
{
  return exs1(x);
}

static Sint
pushj_direct_return2(a, b)
Sint a;
Sint b;
{
  return exs2(a, b);
}

static uSint
pushj_direct_ureturn(x)
uSint x;
{
  return ext_usint1(x);
}

static Sfloat
pushj_direct_freturn(x)
Sfloat x;
{
  return ext_sfloat1(x);
}

static Sint *
pushj_direct_ptr_return(p)
Sint *p;
{
  return ext_ptr1(p);
}

static Sint
pushj_direct_no_tail(x)
Sint x;
{
  Sint y;

  y = exs1(x);
  pushj_ga = y;
  return y + 1;
}

static Sint
pushj_direct_no_tail2(a, b)
Sint a;
Sint b;
{
  Sint y;

  y = exs2(a, b);
  pushj_gb = y ^ a;
  return y + b;
}

static Sfloat
pushj_direct_float_no_tail(x)
Sfloat x;
{
  Sfloat y;

  y = ext_sfloat1(x);
  pushj_fa = y;
  return y + x;
}

static void
pushj_funcptr_void(f)
void (*f)(void);
{
  f();
}

static void
pushj_funcptr_void_no_tail(f)
void (*f)(void);
{
  f();
  pushj_ga++;
}

static void
pushj_funcptr_arg(f, x)
void (*f)(Sint);
Sint x;
{
  f(x);
}

static void
pushj_funcptr_arg_no_tail(f, x)
void (*f)(Sint);
Sint x;
{
  f(x);
  pushj_ga = x;
}

static Sint
pushj_funcptr_return(f, x)
Sint (*f)(Sint);
Sint x;
{
  return f(x);
}

static Sint
pushj_funcptr_return_no_tail(f, x)
Sint (*f)(Sint);
Sint x;
{
  Sint y;

  y = f(x);
  pushj_ga = y;
  return y + 1;
}

static Sint
pushj_funcptr_return2(f, a, b)
Sint (*f)(Sint, Sint);
Sint a;
Sint b;
{
  return f(a, b);
}

static Sint
pushj_funcptr_return2_no_tail(f, a, b)
Sint (*f)(Sint, Sint);
Sint a;
Sint b;
{
  Sint y;

  y = f(a, b);
  pushj_gb = y;
  return y ^ a;
}

static Sfloat
pushj_funcptr_float(f, x)
Sfloat (*f)(Sfloat);
Sfloat x;
{
  return f(x);
}

static Sfloat
pushj_funcptr_float_no_tail(f, x)
Sfloat (*f)(Sfloat);
Sfloat x;
{
  Sfloat y;

  y = f(x);
  pushj_fa = y;
  return y + x;
}

static void
pushj_global_void(void)
{
  pushj_vfp();
}

static void
pushj_global_void_no_tail(void)
{
  pushj_vfp();
  pushj_ga++;
}

static Sint
pushj_global_return(x)
Sint x;
{
  return pushj_sfp(x);
}

static Sint
pushj_global_return_no_tail(x)
Sint x;
{
  Sint y;

  y = pushj_sfp(x);
  pushj_ga = y;
  return y + x;
}

static Sint
pushj_global_return2(a, b)
Sint a;
Sint b;
{
  return pushj_sfp2(a, b);
}

static Sfloat
pushj_global_float(x)
Sfloat x;
{
  return pushj_ffp(x);
}

static void
pushj_array_void(i)
Sint i;
{
  pushj_vtab[i & 7]();
}

static void
pushj_array_void_no_tail(i)
Sint i;
{
  pushj_vtab[i & 7]();
  pushj_ga = i;
}

static Sint
pushj_array_return(i, x)
Sint i;
Sint x;
{
  return pushj_stab[i & 7](x);
}

static Sint
pushj_array_return_no_tail(i, x)
Sint i;
Sint x;
{
  Sint y;

  y = pushj_stab[i & 7](x);
  pushj_buf[i & 7] = y;
  return y + i;
}

static void
pushj_struct_void(p)
struct pushj_calls *p;
{
  p->vf();
}

static void
pushj_struct_void_arg(p, x)
struct pushj_calls *p;
Sint x;
{
  p->v1(x);
}

static Sint
pushj_struct_return(p, x)
struct pushj_calls *p;
Sint x;
{
  return p->sf(x);
}

static Sint
pushj_struct_return2(p, a, b)
struct pushj_calls *p;
Sint a;
Sint b;
{
  return p->sf2(a, b);
}

static Sfloat
pushj_struct_float(p, x)
struct pushj_calls *p;
Sfloat x;
{
  return p->ff(x);
}

static void
pushj_global_struct_void(void)
{
  pushj_gp.vf();
}

static Sint
pushj_global_struct_return(x)
Sint x;
{
  return pushj_gp.sf(x);
}

static Sint
pushj_global_struct_return_no_tail(x)
Sint x;
{
  Sint y;

  y = pushj_gp.sf(x);
  pushj_ga = y;
  return y + 1;
}

static Sint
pushj_nested_direct(x)
Sint x;
{
  Sint a;
  Sint b;

  a = exs1(x);
  b = exs2(a, x);
  return a + b;
}

static Sint
pushj_mixed_direct_indirect(f, x)
Sint (*f)(Sint);
Sint x;
{
  Sint a;
  Sint b;

  a = exs1(x);
  b = f(a);
  return exs2(a, b);
}

static Sint
pushj_call_in_branch(f, x)
Sint (*f)(Sint);
Sint x;
{
  if (x < 0)
    return exs1(x);

  return f(x);
}

static Sint
pushj_call_in_branch_no_tail(f, x)
Sint (*f)(Sint);
Sint x;
{
  Sint y;

  if (x < 0)
    y = exs1(x);
  else
    y = f(x);

  pushj_ga = y;
  return y + 1;
}

static Sint
pushj_call_in_loop(f, n)
Sint (*f)(Sint);
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += f(i);

  return s;
}

static Sint
pushj_call_through_temp(f, x)
Sint (*f)(Sint);
Sint x;
{
  Sint (*g)(Sint);

  g = f;
  return g(x);
}

static void
pushj_call_void_through_temp(f)
void (*f)(void);
{
  void (*g)(void);

  g = f;
  g();
}

static Sint
pushj_return_and_store(f, x)
Sint (*f)(Sint);
Sint x;
{
  Sint y;

  y = f(x);
  pushj_uga = (uSint)y;
  return y;
}

/*
 * GNU labels-as-values / computed-goto future tests.
 * These are intentionally real code, not #if 0: they are tests for
 * eventual backend work, even if today they compile to a longer
 * sequence rather than PUSHJ n,.
 */


/*
 * As in POPJ.c, numeric global-register names such as asm("1") are
 * rejected by this GCC 3.2 backend today.  Leave register-pinned
 * PUSHJ n, stress coverage for a later backend/register-name test.
 */
