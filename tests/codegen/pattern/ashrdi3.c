#include "insns.h"

/*
 * ashrdi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is C coverage for signed DImode arithmetic-right-shift shapes.
 * Keep unsigned logical-right-shift coverage in lshrdi3.c; this file is
 * meant to stress sign propagation, negative inputs, shift counts around
 * the 36-bit word boundary, and the power-of-two signed division forms
 * that commonly lower through arithmetic-right-shift plus bias logic.
 * Do not add inline assembly here.
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
 *   negative values and signed division by powers of two
 *   volatile/global/array/struct/call-argument forms
 */

extern void sink_dint(Dint);

static Dint ashrdi3_ga;
static Dint ashrdi3_gb = (Dint)-12345;
static Dint ashrdi3_gc;

static volatile Dint ashrdi3_vga;
static volatile Dint ashrdi3_vgb;
static volatile Sint ashrdi3_vcount;

static Dint ashrdi3_buf[8];
static Sint ashrdi3_counts[8];

struct ashrdi3_pair {
  Dint a;
  Dint b;
};

struct ashrdi3_nested {
  struct ashrdi3_pair p;
  Sint count;
  Dint tail;
};

static struct ashrdi3_pair ashrdi3_gp;
static struct ashrdi3_nested ashrdi3_gn;

Dint
ashrdi3(a, n)
Dint a;
Sint n;
{
  return a >> n;
}

static Dint
ashrdi_reg_reg(a, n)
Dint a;
Sint n;
{
  return a >> n;
}

static Dint
ashrdi_mem_reg(p, n)
Dint *p;
Sint n;
{
  return *p >> n;
}

static Dint
ashrdi_reg_mem(a, np)
Dint a;
Sint *np;
{
  return a >> *np;
}

static Dint
ashrdi_mem_mem(p, np)
Dint *p;
Sint *np;
{
  Dint a;
  Sint n;

  a = *p;
  n = *np;
  return a >> n;
}

static Dint
ashrdi_neg_reg(a, n)
Dint a;
Sint n;
{
  return -a >> n;
}

static Dint
ashrdi_allones(n)
Sint n;
{
  return (Dint)-1 >> n;
}

static Dint
ashrdi_volatile_value(n)
Sint n;
{
  Dint a;

  a = ashrdi3_vga;
  return a >> n;
}

static Dint
ashrdi_volatile_count(a)
Dint a;
{
  Sint n;

  n = ashrdi3_vcount;
  return a >> n;
}

static Dint
ashrdi_global_count(a)
Dint a;
{
  return a >> ashrdi3_counts[3];
}

static Dint
ashrdi_array_value(i, n)
int i;
Sint n;
{
  return ashrdi3_buf[i & 7] >> n;
}

static Dint
ashrdi_array_count(a, i)
Dint a;
int i;
{
  return a >> ashrdi3_counts[i & 7];
}

static Dint
ashrdi_struct_value(p, n)
struct ashrdi3_pair *p;
Sint n;
{
  return p->a >> n;
}

static Dint
ashrdi_struct_count(p)
struct ashrdi3_nested *p;
{
  return p->p.a >> p->count;
}

static Dint
ashrdi_struct_mix(p, n)
struct ashrdi3_nested *p;
Sint n;
{
  return (p->p.a >> n) + (p->tail >> 1);
}

static Dint
ashrdi_const_0(a)
Dint a;
{
  return a >> 0;
}

static Dint
ashrdi_const_1(a)
Dint a;
{
  return a >> 1;
}

static Dint
ashrdi_const_2(a)
Dint a;
{
  return a >> 2;
}

static Dint
ashrdi_const_3(a)
Dint a;
{
  return a >> 3;
}

static Dint
ashrdi_const_4(a)
Dint a;
{
  return a >> 4;
}

static Dint
ashrdi_const_8(a)
Dint a;
{
  return a >> 8;
}

static Dint
ashrdi_const_17(a)
Dint a;
{
  return a >> 17;
}

static Dint
ashrdi_const_18(a)
Dint a;
{
  return a >> 18;
}

static Dint
ashrdi_const_19(a)
Dint a;
{
  return a >> 19;
}

static Dint
ashrdi_const_35(a)
Dint a;
{
  return a >> 35;
}

static Dint
ashrdi_const_36(a)
Dint a;
{
  return a >> 36;
}

static Dint
ashrdi_const_37(a)
Dint a;
{
  return a >> 37;
}

static Dint
ashrdi_const_63(a)
Dint a;
{
  return a >> 63;
}

static Dint
ashrdi_const_70(a)
Dint a;
{
  return a >> 70;
}

static Dint
ashrdi_div2(a)
Dint a;
{
  return a / (Dint)2;
}

static Dint
ashrdi_div4(a)
Dint a;
{
  return a / (Dint)4;
}

static Dint
ashrdi_div8(a)
Dint a;
{
  return a / (Dint)8;
}

static Dint
ashrdi_neg_div2(a)
Dint a;
{
  return -a / (Dint)2;
}

static Dint
ashrdi_neg_div8(a)
Dint a;
{
  return -a / (Dint)8;
}

static Dint
ashrdi_store(out, a, n)
Dint *out;
Dint a;
Sint n;
{
  Dint r;

  r = a >> n;
  *out = r;
  return r;
}

static void
ashrdi_update(p, n)
Dint *p;
Sint n;
{
  *p = *p >> n;
}

static void
ashrdi_update_const(p)
Dint *p;
{
  *p = *p >> 36;
}

static void
ashrdi_update_assign(p, n)
Dint *p;
Sint n;
{
  *p >>= n;
}

static void
ashrdi_div_update(p)
Dint *p;
{
  *p = *p / (Dint)4;
}

static int
ashrdi_branch(a, n)
Dint a;
Sint n;
{
  Dint r;

  r = a >> n;
  if (r < (Dint)0)
    return -1;
  if (r == (Dint)0)
    return 0;
  return 1;
}

static int
ashrdi_div_branch(a)
Dint a;
{
  Dint r;

  r = a / (Dint)8;
  if (r < (Dint)0)
    return -1;
  if (r == (Dint)0)
    return 0;
  return 1;
}

static Dint
ashrdi_call_arg(a, n)
Dint a;
Sint n;
{
  Dint r;

  r = a >> n;
  sink_dint(r);
  return r;
}

static Dint
ashrdi_div_call_arg(a)
Dint a;
{
  Dint r;

  r = a / (Dint)16;
  sink_dint(r);
  return r;
}

Dint
use_ashrdi3(a, b, n, i)
Dint a;
Dint b;
Sint n;
int i;
{
  Dint r;
  Dint arr[4];
  Sint counts[4];

  arr[0] = a;
  arr[1] = b;
  arr[2] = (Dint)-7;
  arr[3] = (Dint)-1;
  counts[0] = n;
  counts[1] = 18;
  counts[2] = 36;
  counts[3] = 70;

  ashrdi3_ga = a;
  ashrdi3_gb = b;
  ashrdi3_gp.a = a;
  ashrdi3_gp.b = b;
  ashrdi3_gn.p.a = a;
  ashrdi3_gn.p.b = b;
  ashrdi3_gn.count = n;
  ashrdi3_gn.tail = b;

  r = ashrdi3(a, n);
  r = r + ashrdi_reg_reg(a, n);
  r = r + ashrdi_mem_reg(&arr[0], n);
  r = r + ashrdi_reg_mem(a, &counts[0]);
  r = r + ashrdi_mem_mem(&arr[1], &counts[1]);
  r = r + ashrdi_neg_reg(a, n);
  r = r + ashrdi_allones(n);
  r = r + ashrdi_volatile_value(n);
  r = r + ashrdi_volatile_count(a);
  r = r + ashrdi_global_count(a);
  r = r + ashrdi_array_value(i, n);
  r = r + ashrdi_array_count(a, i);
  r = r + ashrdi_struct_value(&ashrdi3_gp, n);
  r = r + ashrdi_struct_count(&ashrdi3_gn);
  r = r + ashrdi_struct_mix(&ashrdi3_gn, n);
  r = r + ashrdi_const_0(a);
  r = r + ashrdi_const_1(a);
  r = r + ashrdi_const_2(a);
  r = r + ashrdi_const_3(a);
  r = r + ashrdi_const_4(a);
  r = r + ashrdi_const_8(a);
  r = r + ashrdi_const_17(a);
  r = r + ashrdi_const_18(a);
  r = r + ashrdi_const_19(a);
  r = r + ashrdi_const_35(a);
  r = r + ashrdi_const_36(a);
  r = r + ashrdi_const_37(a);
  r = r + ashrdi_const_63(a);
  r = r + ashrdi_const_70(a);
  r = r + ashrdi_div2(a);
  r = r + ashrdi_div4(a);
  r = r + ashrdi_div8(a);
  r = r + ashrdi_neg_div2(a);
  r = r + ashrdi_neg_div8(a);
  r = r + ashrdi_store(&ashrdi3_gc, a, n);
  ashrdi_update(&arr[0], n);
  ashrdi_update_const(&arr[1]);
  ashrdi_update_assign(&arr[2], counts[i & 3]);
  ashrdi_div_update(&arr[3]);
  r = r + arr[0] + arr[1] + arr[2] + arr[3];
  r = r + (Dint)ashrdi_branch(a, n);
  r = r + (Dint)ashrdi_div_branch(a);
  r = r + ashrdi_call_arg(a, n);
  r = r + ashrdi_div_call_arg(a);

  return r;
}
