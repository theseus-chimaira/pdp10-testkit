#include "insns.h"

/*
 * iordi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is C coverage for DImode bitwise OR shapes.  A PDP-10 DImode
 * value is represented as two machine words, so this test should expose
 * whether the backend expands a double-word OR as a correct pair of
 * word operations, a libcall, or still needs backend work.  Do not add
 * inline assembly here.
 *
 * Covered source shapes:
 *   reg  = reg | reg
 *   reg  = reg | mem
 *   reg  = mem | reg
 *   reg  = mem | mem through temporaries
 *   reg  = reg | zero/all-ones/low-word/high-word masks
 *   reg  = reg | cross-word DImode masks
 *   mem  = mem | reg
 *   mem  = mem | constants
 *   volatile/global/array/struct/call-argument forms
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint iordi3_ga;
static Dint iordi3_gb = (Dint)1;
static Dint iordi3_gc;
static uDint iordi3_uga;
static uDint iordi3_ugb = (uDint)1;

static volatile Dint iordi3_vga;
static volatile Dint iordi3_vgb;
static volatile uDint iordi3_vuga;

static Dint iordi3_buf[8];
static uDint iordi3_ubuf[8];

struct iordi3_pair {
  Dint a;
  Dint b;
};

struct iordi3_upair {
  uDint a;
  uDint b;
};

struct iordi3_nested {
  struct iordi3_pair p;
  Dint mask;
};

static struct iordi3_pair iordi3_gp;
static struct iordi3_upair iordi3_ugp;
static struct iordi3_nested iordi3_gn;

static Dint
make_iordi3_dint(hi, lo)
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
make_iordi3_udint(hi, lo)
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
iordi_reg_reg(a, b)
Dint a;
Dint b;
{
  return a | b;
}

static uDint
iordi_ureg_ureg(a, b)
uDint a;
uDint b;
{
  return a | b;
}

static Dint
iordi_reg_mem(a, p)
Dint a;
Dint *p;
{
  return a | *p;
}

static Dint
iordi_mem_reg(p, a)
Dint *p;
Dint a;
{
  return *p | a;
}

static Dint
iordi_mem_mem(p, q)
Dint *p;
Dint *q;
{
  Dint a;
  Dint b;

  a = *p;
  b = *q;
  return a | b;
}

static uDint
iordi_umem_umem(p, q)
uDint *p;
uDint *q;
{
  uDint a;
  uDint b;

  a = *p;
  b = *q;
  return a | b;
}

static Dint
iordi_or_zero(a)
Dint a;
{
  return a | (Dint)0;
}

static Dint
iordi_or_allones(a)
Dint a;
{
  return a | (Dint)-1;
}

static Dint
iordi_or_one(a)
Dint a;
{
  return a | (Dint)1;
}

static Dint
iordi_or_low18(a)
Dint a;
{
  return a | (Dint)0777777;
}

static Dint
iordi_or_low_word(a)
Dint a;
{
  return a | make_iordi3_dint((Sint)0, (uSint)-1);
}

static Dint
iordi_or_high_word(a)
Dint a;
{
  return a | make_iordi3_dint((Sint)-1, (uSint)0);
}

static Dint
iordi_or_cross_mask(a)
Dint a;
{
  return a | make_iordi3_dint((Sint)0123456, (uSint)0654321);
}

static uDint
iordi_uor_zero(a)
uDint a;
{
  return a | (uDint)0;
}

static uDint
iordi_uor_allones(a)
uDint a;
{
  return a | (uDint)-1;
}

static uDint
iordi_uor_cross_mask(a)
uDint a;
{
  return a | make_iordi3_udint((uSint)0707070, (uSint)0070707);
}

static Dint
iordi_global(void)
{
  return iordi3_ga | iordi3_gb;
}

static uDint
iordi_uglobal(void)
{
  return iordi3_uga | iordi3_ugb;
}

static Dint
iordi_volatile(void)
{
  Dint a;
  Dint b;

  a = iordi3_vga;
  b = iordi3_vgb;
  return a | b;
}

static uDint
iordi_uvolatile(void)
{
  uDint a;

  a = iordi3_vuga;
  return a | (uDint)0777777;
}

static Dint
iordi_array(i, j)
int i;
int j;
{
  return iordi3_buf[i] | iordi3_buf[j];
}

static uDint
iordi_uarray(i, j)
int i;
int j;
{
  return iordi3_ubuf[i] | iordi3_ubuf[j];
}

static Dint
iordi_struct(p)
struct iordi3_pair *p;
{
  return p->a | p->b;
}

static uDint
iordi_ustruct(p)
struct iordi3_upair *p;
{
  return p->a | p->b;
}

static Dint
iordi_nested(p)
struct iordi3_nested *p;
{
  return (p->p.a | p->p.b) | p->mask;
}

static Dint
iordi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
  Dint r;

  r = a | b;
  *out = r;
  return r;
}

static uDint
iordi_ustore(out, a, b)
uDint *out;
uDint a;
uDint b;
{
  uDint r;

  r = a | b;
  *out = r;
  return r;
}

static void
iordi_update_reg(p, a)
Dint *p;
Dint a;
{
  *p = *p | a;
}

static void
iordi_update_low18(p)
Dint *p;
{
  *p = *p | (Dint)0777777;
}

static void
iordi_update_allones(p)
Dint *p;
{
  *p = *p | (Dint)-1;
}

static void
iordi_update_cross(p)
Dint *p;
{
  *p = *p | make_iordi3_dint((Sint)0700000, (uSint)0007777);
}

static int
iordi_branch(a, b)
Dint a;
Dint b;
{
  Dint r;

  r = a | b;
  if (r == (Dint)0)
    return 0;
  if (r < (Dint)0)
    return -1;
  return 1;
}

static void
iordi_call(a, b)
Dint a;
Dint b;
{
  sink_dint(a | b);
}

static void
iordi_ucall(a, b)
uDint a;
uDint b;
{
  sink_udint(a | b);
}

Dint
use_iordi3(a, b, i)
Dint a;
Dint b;
int i;
{
  Dint r;
  uDint ur;

  iordi3_buf[0] = a;
  iordi3_buf[1] = b;
  iordi3_buf[2] = make_iordi3_dint((Sint)0123456, (uSint)0654321);
  iordi3_ubuf[0] = (uDint)a;
  iordi3_ubuf[1] = (uDint)b;
  iordi3_gp.a = a;
  iordi3_gp.b = b;
  iordi3_ugp.a = (uDint)a;
  iordi3_ugp.b = (uDint)b;
  iordi3_gn.p = iordi3_gp;
  iordi3_gn.mask = iordi3_buf[2];

  r = iordi_reg_reg(a, b);
  r = r | iordi_reg_mem(a, &iordi3_buf[1]);
  r = r | iordi_mem_reg(&iordi3_buf[0], b);
  r = r | iordi_mem_mem(&iordi3_buf[0], &iordi3_buf[1]);
  r = r | iordi_or_zero(a);
  r = r | iordi_or_allones(b);
  r = r | iordi_or_one(a);
  r = r | iordi_or_low18(a);
  r = r | iordi_or_low_word(a);
  r = r | iordi_or_high_word(b);
  r = r | iordi_or_cross_mask(a);
  r = r | iordi_global();
  r = r | iordi_volatile();
  r = r | iordi_array(i & 1, (i + 1) & 1);
  r = r | iordi_struct(&iordi3_gp);
  r = r | iordi_nested(&iordi3_gn);
  r = r | iordi_store(&iordi3_gc, a, b);

  iordi_update_reg(&iordi3_gc, r);
  iordi_update_low18(&iordi3_gc);
  iordi_update_allones(&iordi3_gc);
  iordi_update_cross(&iordi3_gc);

  ur = iordi_ureg_ureg((uDint)a, (uDint)b);
  ur = ur | iordi_umem_umem(&iordi3_ubuf[0], &iordi3_ubuf[1]);
  ur = ur | iordi_uor_zero((uDint)a);
  ur = ur | iordi_uor_allones((uDint)b);
  ur = ur | iordi_uor_cross_mask((uDint)a);
  ur = ur | iordi_uglobal();
  ur = ur | iordi_uvolatile();
  ur = ur | iordi_uarray(i & 1, (i + 1) & 1);
  ur = ur | iordi_ustruct(&iordi3_ugp);
  ur = ur | iordi_ustore(&iordi3_uga, (uDint)a, (uDint)b);

  iordi_call(a, b);
  iordi_ucall((uDint)a, (uDint)b);

  return r | (Dint)ur | (Dint)iordi_branch(a, b) | iordi3_gc;
}
