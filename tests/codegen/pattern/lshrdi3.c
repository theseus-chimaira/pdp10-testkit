#include "insns.h"

/*
 * lshrdi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is C coverage for unsigned DImode logical-right-shift shapes.
 * Keep signed arithmetic-right-shift coverage in ashrdi3.c; this file
 * should stress zero-fill shifts, shift counts around the 36-bit word
 * boundary, and unsigned power-of-two division forms that may lower to
 * logical right shifts.  Do not add inline assembly here.
 *
 * Covered source shapes:
 *   reg  = reg >> reg
 *   reg  = reg >> constant
 *   reg  = mem >> reg
 *   reg  = reg >> mem
 *   mem  = reg >> reg/constant
 *   mem  = mem >> constant
 *   update forms: *p = *p >> n, *p >>= n
 *   shifts across and around the 36-bit word boundary
 *   unsigned high-bit values and power-of-two division forms
 *   volatile/global/array/struct/call-argument forms
 */

extern void sink_udint(uDint);

static uDint lshrdi3_ga;
static uDint lshrdi3_gb = (uDint)1;
static uDint lshrdi3_gc;

static volatile uDint lshrdi3_vga;
static volatile uDint lshrdi3_vgb;
static volatile Sint lshrdi3_vcount;

static uDint lshrdi3_buf[8];
static Sint lshrdi3_counts[8];

struct lshrdi3_pair {
  uDint a;
  uDint b;
};

struct lshrdi3_nested {
  struct lshrdi3_pair p;
  Sint count;
  uDint tail;
};

static struct lshrdi3_pair lshrdi3_gp;
static struct lshrdi3_nested lshrdi3_gn;

uDint
lshrdi3(a, n)
uDint a;
Sint n;
{
  return a >> n;
}

static uDint
lshrdi_reg_reg(a, n)
uDint a;
Sint n;
{
  return a >> n;
}

static uDint
lshrdi_mem_reg(p, n)
uDint *p;
Sint n;
{
  return *p >> n;
}

static uDint
lshrdi_reg_mem(a, np)
uDint a;
Sint *np;
{
  return a >> *np;
}

static uDint
lshrdi_mem_mem(p, np)
uDint *p;
Sint *np;
{
  uDint a;
  Sint n;

  a = *p;
  n = *np;
  return a >> n;
}

static uDint
lshrdi_cast_signed(a, n)
Dint a;
Sint n;
{
  return (uDint)a >> n;
}

static uDint
lshrdi_allones(n)
Sint n;
{
  return (uDint)-1 >> n;
}

static uDint
lshrdi_highbit(n)
Sint n;
{
  return ((uDint)1 << 70) >> n;
}

static uDint
lshrdi_volatile_value(n)
Sint n;
{
  uDint a;

  a = lshrdi3_vga;
  return a >> n;
}

static uDint
lshrdi_volatile_count(a)
uDint a;
{
  Sint n;

  n = lshrdi3_vcount;
  return a >> n;
}

static uDint
lshrdi_global_count(a)
uDint a;
{
  return a >> lshrdi3_counts[3];
}

static uDint
lshrdi_array_value(i, n)
int i;
Sint n;
{
  return lshrdi3_buf[i & 7] >> n;
}

static uDint
lshrdi_array_count(a, i)
uDint a;
int i;
{
  return a >> lshrdi3_counts[i & 7];
}

static uDint
lshrdi_struct_value(p, n)
struct lshrdi3_pair *p;
Sint n;
{
  return p->a >> n;
}

static uDint
lshrdi_struct_count(p)
struct lshrdi3_nested *p;
{
  return p->p.a >> p->count;
}

static uDint
lshrdi_struct_mix(p, n)
struct lshrdi3_nested *p;
Sint n;
{
  return (p->p.a >> n) + (p->tail >> 1);
}

static uDint
lshrdi_const_0(a)
uDint a;
{
  return a >> 0;
}

static uDint
lshrdi_const_1(a)
uDint a;
{
  return a >> 1;
}

static uDint
lshrdi_const_2(a)
uDint a;
{
  return a >> 2;
}

static uDint
lshrdi_const_3(a)
uDint a;
{
  return a >> 3;
}

static uDint
lshrdi_const_4(a)
uDint a;
{
  return a >> 4;
}

static uDint
lshrdi_const_8(a)
uDint a;
{
  return a >> 8;
}

static uDint
lshrdi_const_17(a)
uDint a;
{
  return a >> 17;
}

static uDint
lshrdi_const_18(a)
uDint a;
{
  return a >> 18;
}

static uDint
lshrdi_const_19(a)
uDint a;
{
  return a >> 19;
}

static uDint
lshrdi_const_35(a)
uDint a;
{
  return a >> 35;
}

static uDint
lshrdi_const_36(a)
uDint a;
{
  return a >> 36;
}

static uDint
lshrdi_const_37(a)
uDint a;
{
  return a >> 37;
}

static uDint
lshrdi_const_63(a)
uDint a;
{
  return a >> 63;
}

static uDint
lshrdi_const_70(a)
uDint a;
{
  return a >> 70;
}

static uDint
lshrdi_div2(a)
uDint a;
{
  return a / (uDint)2;
}

static uDint
lshrdi_div4(a)
uDint a;
{
  return a / (uDint)4;
}

static uDint
lshrdi_div8(a)
uDint a;
{
  return a / (uDint)8;
}

static uDint
lshrdi_div16(a)
uDint a;
{
  return a / (uDint)16;
}

static uDint
lshrdi_store(out, a, n)
uDint *out;
uDint a;
Sint n;
{
  uDint r;

  r = a >> n;
  *out = r;
  return r;
}

static void
lshrdi_update(p, n)
uDint *p;
Sint n;
{
  *p = *p >> n;
}

static void
lshrdi_update_const(p)
uDint *p;
{
  *p = *p >> 36;
}

static void
lshrdi_update_assign(p, n)
uDint *p;
Sint n;
{
  *p >>= n;
}

static void
lshrdi_div_update(p)
uDint *p;
{
  *p = *p / (uDint)4;
}

static int
lshrdi_branch(a, n)
uDint a;
Sint n;
{
  uDint r;

  r = a >> n;
  if (r == (uDint)0)
    return 0;
  if (r & (uDint)1)
    return 1;
  return 2;
}

static int
lshrdi_div_branch(a)
uDint a;
{
  uDint r;

  r = a / (uDint)8;
  if (r == (uDint)0)
    return 0;
  if (r > (uDint)0777777)
    return 2;
  return 1;
}

static uDint
lshrdi_call_arg(a, n)
uDint a;
Sint n;
{
  uDint r;

  r = a >> n;
  sink_udint(r);
  return r;
}

static uDint
lshrdi_div_call_arg(a)
uDint a;
{
  uDint r;

  r = a / (uDint)16;
  sink_udint(r);
  return r;
}

uDint
use_lshrdi3(a, b, n, i)
uDint a;
uDint b;
Sint n;
int i;
{
  uDint r;
  uDint arr[4];
  Sint counts[4];

  arr[0] = a;
  arr[1] = b;
  arr[2] = (uDint)-1;
  arr[3] = (uDint)1 << 70;
  counts[0] = n;
  counts[1] = 18;
  counts[2] = 36;
  counts[3] = 70;

  lshrdi3_ga = a;
  lshrdi3_gb = b;
  lshrdi3_gp.a = a;
  lshrdi3_gp.b = b;
  lshrdi3_gn.p.a = a;
  lshrdi3_gn.p.b = b;
  lshrdi3_gn.count = n;
  lshrdi3_gn.tail = b;

  r = lshrdi3(a, n);
  r = r + lshrdi_reg_reg(a, n);
  r = r + lshrdi_mem_reg(&arr[0], n);
  r = r + lshrdi_reg_mem(a, &counts[0]);
  r = r + lshrdi_mem_mem(&arr[1], &counts[1]);
  r = r + lshrdi_cast_signed((Dint)b, n);
  r = r + lshrdi_allones(n);
  r = r + lshrdi_highbit(n);
  r = r + lshrdi_volatile_value(n);
  r = r + lshrdi_volatile_count(a);
  r = r + lshrdi_global_count(a);
  r = r + lshrdi_array_value(i, n);
  r = r + lshrdi_array_count(a, i);
  r = r + lshrdi_struct_value(&lshrdi3_gp, n);
  r = r + lshrdi_struct_count(&lshrdi3_gn);
  r = r + lshrdi_struct_mix(&lshrdi3_gn, n);
  r = r + lshrdi_const_0(a);
  r = r + lshrdi_const_1(a);
  r = r + lshrdi_const_2(a);
  r = r + lshrdi_const_3(a);
  r = r + lshrdi_const_4(a);
  r = r + lshrdi_const_8(a);
  r = r + lshrdi_const_17(a);
  r = r + lshrdi_const_18(a);
  r = r + lshrdi_const_19(a);
  r = r + lshrdi_const_35(a);
  r = r + lshrdi_const_36(a);
  r = r + lshrdi_const_37(a);
  r = r + lshrdi_const_63(a);
  r = r + lshrdi_const_70(a);
  r = r + lshrdi_div2(a);
  r = r + lshrdi_div4(a);
  r = r + lshrdi_div8(a);
  r = r + lshrdi_div16(a);
  r = r + lshrdi_store(&lshrdi3_gc, a, n);
  lshrdi_update(&arr[0], n);
  lshrdi_update_const(&arr[1]);
  lshrdi_update_assign(&arr[2], counts[i & 3]);
  lshrdi_div_update(&arr[3]);
  r = r + arr[0] + arr[1] + arr[2] + arr[3];
  r = r + (uDint)lshrdi_branch(a, n);
  r = r + (uDint)lshrdi_div_branch(a);
  r = r + lshrdi_call_arg(a, n);
  r = r + lshrdi_div_call_arg(a);

  return r;
}
