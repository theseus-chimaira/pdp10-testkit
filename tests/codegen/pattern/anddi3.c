#include "insns.h"

/*
 * anddi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is C coverage for DImode bitwise AND shapes.  The PDP-10
 * instruction set has ordinary single-word AND instructions, but a
 * DImode value is a two-word object.  This test should expose whether
 * the backend expands a 72-bit/71-bit logical AND as a correct pair of
 * word operations, a libcall, or still needs backend work.  Do not add
 * inline assembly here.
 *
 * Covered source shapes:
 *   reg  = reg & reg
 *   reg  = reg & mem
 *   reg  = mem & reg
 *   reg  = mem & mem through temporaries
 *   reg  = reg & zero/all-ones/low-word/high-word masks
 *   reg  = reg & cross-word DImode masks
 *   mem  = mem & reg
 *   mem  = mem & constants
 *   volatile/global/array/struct/call-argument forms
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint anddi3_ga;
static Dint anddi3_gb = (Dint)-1;
static Dint anddi3_gc;
static uDint anddi3_uga;
static uDint anddi3_ugb = (uDint)-1;

static volatile Dint anddi3_vga;
static volatile Dint anddi3_vgb;
static volatile uDint anddi3_vuga;

static Dint anddi3_buf[8];
static uDint anddi3_ubuf[8];

struct anddi3_pair {
  Dint a;
  Dint b;
};

struct anddi3_upair {
  uDint a;
  uDint b;
};

struct anddi3_nested {
  struct anddi3_pair p;
  Dint mask;
};

static struct anddi3_pair anddi3_gp;
static struct anddi3_upair anddi3_ugp;
static struct anddi3_nested anddi3_gn;

static Dint
make_anddi3_dint(hi, lo)
Sint hi;
uSint lo;
{
  Dint r;

  r = (Dint)hi;
  r = r << 36;
  r = r | (Dint)lo;
  return r;
}

static uDint
make_anddi3_udint(hi, lo)
uSint hi;
uSint lo;
{
  uDint r;

  r = (uDint)hi;
  r = r << 36;
  r = r | (uDint)lo;
  return r;
}

static Dint
anddi_reg_reg(a, b)
Dint a;
Dint b;
{
  return a & b;
}

static uDint
anddi_ureg_ureg(a, b)
uDint a;
uDint b;
{
  return a & b;
}

static Dint
anddi_reg_mem(a, p)
Dint a;
Dint *p;
{
  return a & *p;
}

static Dint
anddi_mem_reg(p, a)
Dint *p;
Dint a;
{
  return *p & a;
}

static Dint
anddi_mem_mem(p, q)
Dint *p;
Dint *q;
{
  Dint a;
  Dint b;

  a = *p;
  b = *q;
  return a & b;
}

static Dint
anddi_volatile_mem(a)
Dint a;
{
  Dint b;

  b = anddi3_vga;
  return a & b;
}

static uDint
anddi_uvolatile_mem(a)
uDint a;
{
  uDint b;

  b = anddi3_vuga;
  return a & b;
}

static Dint
anddi_global_reg(a)
Dint a;
{
  return anddi3_ga & a;
}

static Dint
anddi_reg_global(a)
Dint a;
{
  return a & anddi3_gb;
}

static uDint
anddi_uglobal_reg(a)
uDint a;
{
  return anddi3_uga & a;
}

static Dint
anddi_array_reg(i, a)
int i;
Dint a;
{
  return anddi3_buf[i & 7] & a;
}

static Dint
anddi_reg_array(a, i)
Dint a;
int i;
{
  return a & anddi3_buf[i & 7];
}

static uDint
anddi_uarray_reg(i, a)
int i;
uDint a;
{
  return anddi3_ubuf[i & 7] & a;
}

static Dint
anddi_struct_a(p, x)
struct anddi3_pair *p;
Dint x;
{
  return p->a & x;
}

static Dint
anddi_struct_b(p, x)
struct anddi3_pair *p;
Dint x;
{
  return x & p->b;
}

static Dint
anddi_nested(p, x)
struct anddi3_nested *p;
Dint x;
{
  return p->p.a & p->mask & x;
}

static Dint
anddi_const_zero(a)
Dint a;
{
  return a & (Dint)0;
}

static Dint
anddi_const_all_ones(a)
Dint a;
{
  return a & (Dint)-1;
}

static Dint
anddi_const_one(a)
Dint a;
{
  return a & (Dint)1;
}

static Dint
anddi_const_low18(a)
Dint a;
{
  return a & (Dint)0777777;
}

static Dint
anddi_const_low_word(a)
Dint a;
{
  return a & make_anddi3_dint((Sint)0, (uSint)0777777777777U);
}

static Dint
anddi_const_high_word(a)
Dint a;
{
  return a & make_anddi3_dint((Sint)-1, (uSint)0);
}

static Dint
anddi_const_cross(a)
Dint a;
{
  return a & make_anddi3_dint((Sint)0123456, (uSint)0654321);
}

static Dint
anddi_const_signish(a)
Dint a;
{
  return a & make_anddi3_dint((Sint)0400000, (uSint)0400000);
}

static uDint
anddi_uconst_low18(a)
uDint a;
{
  return a & (uDint)0777777U;
}

static uDint
anddi_uconst_cross(a)
uDint a;
{
  return a & make_anddi3_udint((uSint)0765432U, (uSint)0123456U);
}

static uDint
anddi_uconst_all_ones(a)
uDint a;
{
  return a & (uDint)-1;
}

static void
anddi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
  *out = a & b;
}

static void
anddi_store_mem(out, p, b)
Dint *out;
Dint *p;
Dint b;
{
  *out = *p & b;
}

static Dint
anddi_store_return(out, a, b)
Dint *out;
Dint a;
Dint b;
{
  *out = a & b;
  return *out;
}

static void
anddi_update_reg(p, a)
Dint *p;
Dint a;
{
  *p = *p & a;
}

static void
anddi_update_const_zero(p)
Dint *p;
{
  *p = *p & (Dint)0;
}

static void
anddi_update_const_all_ones(p)
Dint *p;
{
  *p = *p & (Dint)-1;
}

static void
anddi_update_const_low18(p)
Dint *p;
{
  *p = *p & (Dint)0777777;
}

static void
anddi_update_const_cross(p)
Dint *p;
{
  *p = *p & make_anddi3_dint((Sint)0770000, (uSint)0007777);
}

static void
anddi_struct_store(p, a, b)
struct anddi3_pair *p;
Dint a;
Dint b;
{
  p->a = a & b;
  p->b = p->a & make_anddi3_dint((Sint)0777777, (uSint)0);
}

static Dint
anddi_branch(a, b)
Dint a;
Dint b;
{
  Dint s;

  s = a & b;
  if (s == (Dint)0)
    return s | (Dint)1;
  if (s < (Dint)0)
    return s & make_anddi3_dint((Sint)-1, (uSint)0777777);
  return s & (Dint)-1;
}

static Dint
anddi_call_arg(a, b)
Dint a;
Dint b;
{
  Dint s;

  s = a & b;
  sink_dint(s);
  return s;
}

static uDint
anddi_ucall_arg(a, b)
uDint a;
uDint b;
{
  uDint s;

  s = a & b;
  sink_udint(s);
  return s;
}

Dint
use_anddi3(a, b, i)
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
  local[2] = make_anddi3_dint((Sint)0123456, (uSint)0654321);
  local[3] = anddi3_gb;
  anddi3_ga = a;
  anddi3_gb = b;
  anddi3_vga = a;
  anddi3_vgb = b;
  anddi_store(&anddi3_gc, a, b);
  anddi_store_mem(&local[0], &anddi3_gb, a);
  anddi_update_reg(&local[1], b);
  anddi_update_const_zero(&local[2]);
  anddi_update_const_all_ones(&local[3]);
  anddi_update_const_low18(&anddi3_gc);
  anddi_update_const_cross(&anddi3_gc);
  anddi_struct_store(&anddi3_gp, a, b);
  cross = anddi_const_cross(a);

  ua = make_anddi3_udint((uSint)0765432U, (uSint)0123456U);
  ub = (uDint)b & anddi3_ugb;
  anddi3_uga = ua;
  anddi3_vuga = ub;
  anddi3_ubuf[i & 7] = ub;

  return anddi_reg_reg(a, b)
      + (Dint)anddi_ureg_ureg((uDint)a, (uDint)b)
      + anddi_reg_mem(a, &local[0])
      + anddi_mem_reg(&local[1], b)
      + anddi_mem_mem(&local[2], &local[3])
      + anddi_volatile_mem(a)
      + (Dint)anddi_uvolatile_mem(ua)
      + anddi_global_reg(a)
      + anddi_reg_global(b)
      + (Dint)anddi_uglobal_reg(ua)
      + anddi_array_reg(i, a)
      + anddi_reg_array(b, i)
      + (Dint)anddi_uarray_reg(i, ub)
      + anddi_struct_a(&anddi3_gp, a)
      + anddi_struct_b(&anddi3_gp, b)
      + anddi_nested(&anddi3_gn, a)
      + anddi_const_zero(a)
      + anddi_const_all_ones(a)
      + anddi_const_one(a)
      + anddi_const_low18(a)
      + anddi_const_low_word(a)
      + anddi_const_high_word(a)
      + cross
      + anddi_const_signish(a)
      + (Dint)anddi_uconst_low18(ua)
      + (Dint)anddi_uconst_cross(ua)
      + (Dint)anddi_uconst_all_ones(ua)
      + anddi_store_return(&local[0], a, b)
      + anddi_branch(a, b)
      + anddi_call_arg(a, b)
      + (Dint)anddi_ucall_arg(ua, ub);
}
