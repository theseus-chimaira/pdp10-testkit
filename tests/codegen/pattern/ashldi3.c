#include "insns.h"

/*
 * ashldi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is C coverage for DImode arithmetic-left-shift shapes.  In C,
 * left shift is used for both signed and unsigned operands; signed cases
 * are included to exercise ashldi3, unsigned cases to catch identical
 * expansion pressure for uDint.  Do not add inline assembly here.
 *
 * Covered source shapes:
 *   reg  = reg << reg
 *   reg  = reg << constant
 *   reg  = mem << reg
 *   reg  = reg << mem
 *   mem  = reg << reg/constant
 *   mem  = mem << constant
 *   update forms: *p = *p << n, *p <<= n
 *   shifts across and around the 36-bit word boundary
 *   volatile/global/array/struct/call-argument forms
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint ashldi3_ga;
static Dint ashldi3_gb = (Dint)12345;
static Dint ashldi3_gc;
static uDint ashldi3_uga;
static uDint ashldi3_ugb = (uDint)54321U;

static volatile Dint ashldi3_vga;
static volatile Dint ashldi3_vgb;
static volatile uDint ashldi3_vuga;
static volatile Sint ashldi3_vcount;

static Dint ashldi3_buf[8];
static uDint ashldi3_ubuf[8];
static Sint ashldi3_counts[8];

struct ashldi3_pair {
  Dint a;
  Dint b;
};

struct ashldi3_upair {
  uDint a;
  uDint b;
};

struct ashldi3_nested {
  struct ashldi3_pair p;
  Sint count;
  Dint tail;
};

static struct ashldi3_pair ashldi3_gp;
static struct ashldi3_upair ashldi3_ugp;
static struct ashldi3_nested ashldi3_gn;

Dint
ashldi3(a, n)
Dint a;
Sint n;
{
  return a << n;
}

static uDint
uashldi3(a, n)
uDint a;
uSint n;
{
  return a << n;
}

static Dint
ashldi_reg_reg(a, n)
Dint a;
Sint n;
{
  return a << n;
}

static uDint
ashldi_ureg_ureg(a, n)
uDint a;
uSint n;
{
  return a << n;
}

static Dint
ashldi_mem_reg(p, n)
Dint *p;
Sint n;
{
  return *p << n;
}

static Dint
ashldi_reg_mem(a, np)
Dint a;
Sint *np;
{
  return a << *np;
}

static Dint
ashldi_mem_mem(p, np)
Dint *p;
Sint *np;
{
  Dint a;
  Sint n;

  a = *p;
  n = *np;
  return a << n;
}

static Dint
ashldi_volatile_value(n)
Sint n;
{
  Dint a;

  a = ashldi3_vga;
  return a << n;
}

static Dint
ashldi_volatile_count(a)
Dint a;
{
  Sint n;

  n = ashldi3_vcount;
  return a << n;
}

static uDint
ashldi_uvolatile_value(n)
uSint n;
{
  uDint a;

  a = ashldi3_vuga;
  return a << n;
}

static Dint
ashldi_global_count(a)
Dint a;
{
  return a << ashldi3_counts[3];
}

static Dint
ashldi_array_value(i, n)
int i;
Sint n;
{
  return ashldi3_buf[i & 7] << n;
}

static Dint
ashldi_array_count(a, i)
Dint a;
int i;
{
  return a << ashldi3_counts[i & 7];
}

static uDint
ashldi_uarray_value(i, n)
int i;
uSint n;
{
  return ashldi3_ubuf[i & 7] << n;
}

static Dint
ashldi_struct_value(p, n)
struct ashldi3_pair *p;
Sint n;
{
  return p->a << n;
}

static Dint
ashldi_struct_count(p)
struct ashldi3_nested *p;
{
  return p->p.a << p->count;
}

static Dint
ashldi_struct_mix(p, n)
struct ashldi3_nested *p;
Sint n;
{
  return (p->p.a << n) + (p->tail << 1);
}

static uDint
ashldi_ustruct_value(p, n)
struct ashldi3_upair *p;
uSint n;
{
  return p->a << n;
}

static Dint
ashldi_const_0(a)
Dint a;
{
  return a << 0;
}

static Dint
ashldi_const_1(a)
Dint a;
{
  return a << 1;
}

static Dint
ashldi_const_2(a)
Dint a;
{
  return a << 2;
}

static Dint
ashldi_const_3(a)
Dint a;
{
  return a << 3;
}

static Dint
ashldi_const_4(a)
Dint a;
{
  return a << 4;
}

static Dint
ashldi_const_8(a)
Dint a;
{
  return a << 8;
}

static Dint
ashldi_const_17(a)
Dint a;
{
  return a << 17;
}

static Dint
ashldi_const_18(a)
Dint a;
{
  return a << 18;
}

static Dint
ashldi_const_19(a)
Dint a;
{
  return a << 19;
}

static Dint
ashldi_const_35(a)
Dint a;
{
  return a << 35;
}

static Dint
ashldi_const_36(a)
Dint a;
{
  return a << 36;
}

static Dint
ashldi_const_37(a)
Dint a;
{
  return a << 37;
}

static Dint
ashldi_const_63(a)
Dint a;
{
  return a << 63;
}

static Dint
ashldi_const_70(a)
Dint a;
{
  return a << 70;
}

static uDint
ashldi_uconst_1(a)
uDint a;
{
  return a << 1;
}

static uDint
ashldi_uconst_18(a)
uDint a;
{
  return a << 18;
}

static uDint
ashldi_uconst_36(a)
uDint a;
{
  return a << 36;
}

static uDint
ashldi_uconst_70(a)
uDint a;
{
  return a << 70;
}

static Dint
ashldi_mul2(a)
Dint a;
{
  return a * (Dint)2;
}

static Dint
ashldi_mul4(a)
Dint a;
{
  return a * (Dint)4;
}

static uDint
ashldi_umul8(a)
uDint a;
{
  return a * (uDint)8;
}

static Dint
ashldi_store(out, a, n)
Dint *out;
Dint a;
Sint n;
{
  Dint r;

  r = a << n;
  *out = r;
  return r;
}

static uDint
ashldi_ustore(out, a, n)
uDint *out;
uDint a;
uSint n;
{
  uDint r;

  r = a << n;
  *out = r;
  return r;
}

static void
ashldi_update(p, n)
Dint *p;
Sint n;
{
  *p = *p << n;
}

static void
ashldi_update_const(p)
Dint *p;
{
  *p = *p << 36;
}

static void
ashldi_update_assign(p, n)
Dint *p;
Sint n;
{
  *p <<= n;
}

static void
ashldi_uupdate_assign(p, n)
uDint *p;
uSint n;
{
  *p <<= n;
}

static int
ashldi_branch(a, n)
Dint a;
Sint n;
{
  Dint r;

  r = a << n;
  if (r < (Dint)0)
    return -1;
  if (r == (Dint)0)
    return 0;
  return 1;
}

static int
ashldi_ubranch(a, n)
uDint a;
uSint n;
{
  uDint r;

  r = a << n;
  if (r == (uDint)0)
    return 0;
  if (r > a)
    return 1;
  return -1;
}

static Dint
ashldi_call_arg(a, n)
Dint a;
Sint n;
{
  Dint r;

  r = a << n;
  sink_dint(r);
  return r;
}

static uDint
ashldi_ucall_arg(a, n)
uDint a;
uSint n;
{
  uDint r;

  r = a << n;
  sink_udint(r);
  return r;
}

Dint
use_ashldi3(a, b, n, i)
Dint a;
Dint b;
Sint n;
int i;
{
  Dint r;
  Dint arr[3];
  Sint counts[3];

  arr[0] = a;
  arr[1] = b;
  arr[2] = (Dint)7;
  counts[0] = n;
  counts[1] = 18;
  counts[2] = 36;

  ashldi3_ga = a;
  ashldi3_gb = b;
  ashldi3_gp.a = a;
  ashldi3_gp.b = b;
  ashldi3_gn.p.a = a;
  ashldi3_gn.p.b = b;
  ashldi3_gn.count = n;
  ashldi3_gn.tail = b;

  r = ashldi3(a, n);
  r = r + uashldi3((uDint)a, (uSint)n);
  r = r + ashldi_reg_reg(a, n);
  r = r + ashldi_mem_reg(&arr[0], n);
  r = r + ashldi_reg_mem(a, &counts[0]);
  r = r + ashldi_mem_mem(&arr[1], &counts[1]);
  r = r + ashldi_volatile_value(n);
  r = r + ashldi_volatile_count(a);
  r = r + ashldi_global_count(a);
  r = r + ashldi_array_value(i, n);
  r = r + ashldi_array_count(a, i);
  r = r + ashldi_struct_value(&ashldi3_gp, n);
  r = r + ashldi_struct_count(&ashldi3_gn);
  r = r + ashldi_struct_mix(&ashldi3_gn, n);
  r = r + ashldi_const_0(a);
  r = r + ashldi_const_1(a);
  r = r + ashldi_const_2(a);
  r = r + ashldi_const_3(a);
  r = r + ashldi_const_4(a);
  r = r + ashldi_const_8(a);
  r = r + ashldi_const_17(a);
  r = r + ashldi_const_18(a);
  r = r + ashldi_const_19(a);
  r = r + ashldi_const_35(a);
  r = r + ashldi_const_36(a);
  r = r + ashldi_const_37(a);
  r = r + ashldi_const_63(a);
  r = r + ashldi_const_70(a);
  r = r + ashldi_uconst_1((uDint)a);
  r = r + ashldi_uconst_18((uDint)a);
  r = r + ashldi_uconst_36((uDint)a);
  r = r + ashldi_uconst_70((uDint)a);
  r = r + ashldi_mul2(a);
  r = r + ashldi_mul4(a);
  r = r + ashldi_umul8((uDint)a);
  r = r + ashldi_store(&ashldi3_gc, a, n);
  r = r + ashldi_ustore(&ashldi3_uga, (uDint)a, (uSint)n);
  ashldi_update(&arr[0], n);
  ashldi_update_const(&arr[1]);
  ashldi_update_assign(&arr[2], counts[i & 1]);
  ashldi_uupdate_assign(&ashldi3_uga, (uSint)n);
  r = r + arr[0] + arr[1] + arr[2];
  r = r + (Dint)ashldi_branch(a, n);
  r = r + (Dint)ashldi_ubranch((uDint)a, (uSint)n);
  r = r + ashldi_call_arg(a, n);
  r = r + ashldi_ucall_arg((uDint)a, (uSint)n);
  r = r + ashldi_uvolatile_value((uSint)n);
  r = r + ashldi_uarray_value(i, (uSint)n);
  r = r + ashldi_ustruct_value(&ashldi3_ugp, (uSint)n);
  r = r + ashldi_ureg_ureg((uDint)a, (uSint)n);

  return r;
}
