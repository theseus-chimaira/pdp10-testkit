#include "insns.h"

/*
 * adddi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is C coverage for DImode addition shapes.  The current machine
 * description only exposes the named adddi3 expander for TARGET_KL10up
 * with TARGET_71BIT, while the old non-71-bit sequence is disabled.
 * For PDP-6/KA10 this file is therefore useful as a no_ref reproducer:
 * later review should show whether the backend emits the intended inline
 * sequence, a libcall, or still needs backend work.  Do not add inline
 * assembly here.
 *
 * Covered source shapes:
 *   reg  = reg + reg
 *   reg  = reg + mem
 *   reg  = mem + reg
 *   reg  = mem + mem through temporaries
 *   reg  = reg + small positive/negative constants
 *   reg  = reg + cross-word DImode constants
 *   mem  = mem + reg
 *   mem  = mem + small constants
 *   volatile/global/array/struct/call-argument forms
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint adddi3_ga;
static Dint adddi3_gb = (Dint)12345;
static Dint adddi3_gc;
static uDint adddi3_uga;
static uDint adddi3_ugb = (uDint)54321U;

static volatile Dint adddi3_vga;
static volatile Dint adddi3_vgb;
static volatile uDint adddi3_vuga;

static Dint adddi3_buf[8];
static uDint adddi3_ubuf[8];

struct adddi3_pair {
  Dint a;
  Dint b;
};

struct adddi3_upair {
  uDint a;
  uDint b;
};

struct adddi3_nested {
  struct adddi3_pair p;
  Dint tail;
};

static struct adddi3_pair adddi3_gp;
static struct adddi3_upair adddi3_ugp;
static struct adddi3_nested adddi3_gn;

static Dint
make_adddi3_dint(hi, lo)
Sint hi;
uSint lo;
{
  Dint r;

  r = (Dint)hi;
  r = r << 36;
  r = r + (Dint)lo;
  return r;
}

static uDint
make_adddi3_udint(hi, lo)
uSint hi;
uSint lo;
{
  uDint r;

  r = (uDint)hi;
  r = r << 36;
  r = r + (uDint)lo;
  return r;
}

static Dint
adddi_reg_reg(a, b)
Dint a;
Dint b;
{
  return a + b;
}

static uDint
adddi_ureg_ureg(a, b)
uDint a;
uDint b;
{
  return a + b;
}

static Dint
adddi_reg_mem(a, p)
Dint a;
Dint *p;
{
  return a + *p;
}

static Dint
adddi_mem_reg(p, a)
Dint *p;
Dint a;
{
  return *p + a;
}

static Dint
adddi_mem_mem(p, q)
Dint *p;
Dint *q;
{
  Dint a;
  Dint b;

  a = *p;
  b = *q;
  return a + b;
}

static Dint
adddi_volatile_mem(a)
Dint a;
{
  Dint b;

  b = adddi3_vga;
  return a + b;
}

static uDint
adddi_uvolatile_mem(a)
uDint a;
{
  uDint b;

  b = adddi3_vuga;
  return a + b;
}

static Dint
adddi_global_reg(a)
Dint a;
{
  return adddi3_ga + a;
}

static Dint
adddi_reg_global(a)
Dint a;
{
  return a + adddi3_gb;
}

static uDint
adddi_uglobal_reg(a)
uDint a;
{
  return adddi3_uga + a;
}

static Dint
adddi_array_reg(i, a)
int i;
Dint a;
{
  return adddi3_buf[i & 7] + a;
}

static Dint
adddi_reg_array(a, i)
Dint a;
int i;
{
  return a + adddi3_buf[i & 7];
}

static uDint
adddi_uarray_reg(i, a)
int i;
uDint a;
{
  return adddi3_ubuf[i & 7] + a;
}

static Dint
adddi_struct_a(p, x)
struct adddi3_pair *p;
Dint x;
{
  return p->a + x;
}

static Dint
adddi_struct_b(p, x)
struct adddi3_pair *p;
Dint x;
{
  return x + p->b;
}

static Dint
adddi_nested(p, x)
struct adddi3_nested *p;
Dint x;
{
  return p->p.a + p->tail + x;
}

static Dint
adddi_const_pos(a)
Dint a;
{
  return a + (Dint)1;
}

static Dint
adddi_const_two(a)
Dint a;
{
  return a + (Dint)2;
}

static Dint
adddi_const_small(a)
Dint a;
{
  return a + (Dint)012345;
}

static Dint
adddi_const_neg_one(a)
Dint a;
{
  return a + (Dint)-1;
}

static Dint
adddi_const_neg_small(a)
Dint a;
{
  return a + (Dint)-012345;
}

static Dint
adddi_const_cross(a)
Dint a;
{
  return a + (((Dint)0123 << 36) + (Dint)04567);
}

static uDint
adddi_uconst_cross(a)
uDint a;
{
  return a + (((uDint)0777U << 36) + (uDint)012345U);
}

static void
adddi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
  *out = a + b;
}

static void
adddi_store_mem(out, p, b)
Dint *out;
Dint *p;
Dint b;
{
  *out = *p + b;
}

static Dint
adddi_store_return(out, a, b)
Dint *out;
Dint a;
Dint b;
{
  *out = a + b;
  return *out;
}

static void
adddi_update_reg(p, a)
Dint *p;
Dint a;
{
  *p = *p + a;
}

static void
adddi_update_const_one(p)
Dint *p;
{
  *p = *p + (Dint)1;
}

static void
adddi_update_const_neg_one(p)
Dint *p;
{
  *p = *p + (Dint)-1;
}

static void
adddi_update_const_large(p)
Dint *p;
{
  *p = *p + (((Dint)01 << 36) + (Dint)0777777);
}

static void
adddi_struct_store(p, a, b)
struct adddi3_pair *p;
Dint a;
Dint b;
{
  p->a = a + b;
  p->b = p->a + (Dint)1;
}

static Dint
adddi_branch(a, b)
Dint a;
Dint b;
{
  Dint s;

  s = a + b;
  if (s < (Dint)0)
    return s + (Dint)1;
  if (s == (Dint)0)
    return s + (Dint)2;
  return s + (Dint)3;
}

static Dint
adddi_call_arg(a, b)
Dint a;
Dint b;
{
  Dint s;

  s = a + b;
  sink_dint(s);
  return s;
}

static uDint
adddi_ucall_arg(a, b)
uDint a;
uDint b;
{
  uDint s;

  s = a + b;
  sink_udint(s);
  return s;
}

Dint
use_adddi3(a, b, i)
Dint a;
Dint b;
int i;
{
  Dint local[4];
  Dint cross;
  uDint ua;
  uDint ub;

  local[0] = a;
  local[1] = b;
  local[2] = make_adddi3_dint((Sint)0123, (uSint)04567);
  local[3] = adddi3_gb;
  adddi3_ga = a;
  adddi3_gb = b;
  adddi3_vga = a;
  adddi3_vgb = b;
  adddi_store(&adddi3_gc, a, b);
  adddi_store_mem(&local[0], &adddi3_gb, a);
  adddi_update_reg(&local[1], b);
  adddi_update_const_one(&local[2]);
  adddi_update_const_neg_one(&local[3]);
  adddi_update_const_large(&adddi3_gc);
  adddi_struct_store(&adddi3_gp, a, b);
  cross = adddi_const_cross(a);

  ua = make_adddi3_udint((uSint)0777U, (uSint)012345U);
  ub = (uDint)b + adddi3_ugb;
  adddi3_uga = ua;
  adddi3_ugp.a = ua;
  adddi3_ugp.b = ub;
  adddi3_vuga = ub;
  adddi3_ubuf[i & 7] = ub;

  return adddi_reg_reg(a, b)
      + (Dint)adddi_ureg_ureg((uDint)a, (uDint)b)
      + adddi_reg_mem(a, &local[0])
      + adddi_mem_reg(&local[1], b)
      + adddi_mem_mem(&local[2], &local[3])
      + adddi_volatile_mem(a)
      + (Dint)adddi_uvolatile_mem(ua)
      + adddi_global_reg(a)
      + adddi_reg_global(b)
      + (Dint)adddi_uglobal_reg(ua)
      + (Dint)adddi3_ugp.a
      + (Dint)adddi3_ugp.b
      + adddi_array_reg(i, a)
      + adddi_reg_array(b, i)
      + (Dint)adddi_uarray_reg(i, ub)
      + adddi_struct_a(&adddi3_gp, a)
      + adddi_struct_b(&adddi3_gp, b)
      + adddi_nested(&adddi3_gn, a)
      + adddi_const_pos(a)
      + adddi_const_two(a)
      + adddi_const_small(a)
      + adddi_const_neg_one(a)
      + adddi_const_neg_small(a)
      + cross
      + (Dint)adddi_uconst_cross(ua)
      + adddi_store_return(&local[0], a, b)
      + adddi_branch(a, b)
      + adddi_call_arg(a, b)
      + (Dint)adddi_ucall_arg(ua, ub);
}
