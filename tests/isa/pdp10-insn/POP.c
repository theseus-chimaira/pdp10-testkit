/* flag: -Os */
#include "insns.h"

/*
 * POP instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   POP P,AC      pop into register
 *   POP P,MEM     pop into memory
 *
 * The machine description has direct POP and combine forms for SI and
 * SF values.  Keep the source pointer decrement visible, otherwise GCC
 * is free to drop the post-decrement and the POP opportunity disappears.
 */

extern void clobber (void);
extern Sint ext_sint (Sint);
extern Sfloat ext_sfloat (Sfloat);

static Sint pop_ga;
static Sint pop_gb;
static Sfloat pop_fa;
static Sfloat pop_fb;

static Sint pop_buf[16];
static Sfloat pop_fbuf[16];

struct pop_pair {
  Sint a;
  Sint b;
};

struct pop_fpair {
  Sfloat a;
  Sfloat b;
};

static struct pop_pair pop_gp;
static struct pop_fpair pop_fgp;

static Sint
pop_prologue(x)
Sint x;
{
  clobber();
  return x;
}

static Sint
pop_prologue_2(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint t;

  t = a + b;
  clobber();
  return t + c + d;
}

static Sint
pop_prologue_call(a, b)
Sint a;
Sint b;
{
  Sint t;

  t = ext_sint(a);
  clobber();
  return t + b;
}

static Sfloat
pop_prologue_sf(x)
Sfloat x;
{
  clobber();
  return x;
}

static Sfloat
pop_prologue_sf_call(a, b)
Sfloat a;
Sfloat b;
{
  Sfloat t;

  t = ext_sfloat(a);
  clobber();
  return t + b;
}

static Sint *
popsi_mem(p, x)
Sint *p;
Sint *x;
{
  *x = *p--;
  return p;
}

static Sfloat *
popsf_mem(p, x)
Sfloat *p;
Sfloat *x;
{
  *x = *p--;
  return p;
}

static Sint *
popsi_combine(p, x)
Sint *p;
Sint *x;
{
  *x = (--p)[1];
  return p;
}

static Sfloat *
popsf_combine(p, x)
Sfloat *p;
Sfloat *x;
{
  *x = (--p)[1];
  return p;
}

static Sint
popsi_reg(pp)
Sint **pp;
{
  Sint *p;
  Sint v;

  p = *pp;
  v = *p--;
  *pp = p;
  return v;
}

static Sfloat
popsf_reg(pp)
Sfloat **pp;
{
  Sfloat *p;
  Sfloat v;

  p = *pp;
  v = *p--;
  *pp = p;
  return v;
}

static Sint
popsi_reg_combine(pp)
Sint **pp;
{
  Sint *p;
  Sint v;

  p = *pp;
  v = (--p)[1];
  *pp = p;
  return v;
}

static Sfloat
popsf_reg_combine(pp)
Sfloat **pp;
{
  Sfloat *p;
  Sfloat v;

  p = *pp;
  v = (--p)[1];
  *pp = p;
  return v;
}

static Sint *
popsi_global(p)
Sint *p;
{
  pop_ga = *p--;
  return p;
}

static Sfloat *
popsf_global(p)
Sfloat *p;
{
  pop_fa = *p--;
  return p;
}

static Sint *
popsi_global_b(p)
Sint *p;
{
  pop_gb = *p--;
  return p;
}

static Sfloat *
popsf_global_b(p)
Sfloat *p;
{
  pop_fb = *p--;
  return p;
}

static Sint *
popsi_array(p, i)
Sint *p;
Sint i;
{
  pop_buf[i & 017] = *p--;
  return p;
}

static Sfloat *
popsf_array(p, i)
Sfloat *p;
Sint i;
{
  pop_fbuf[i & 017] = *p--;
  return p;
}

static Sint *
popsi_struct_a(p, q)
Sint *p;
struct pop_pair *q;
{
  q->a = *p--;
  return p;
}

static Sint *
popsi_struct_b(p, q)
Sint *p;
struct pop_pair *q;
{
  q->b = *p--;
  return p;
}

static Sfloat *
popsf_struct_a(p, q)
Sfloat *p;
struct pop_fpair *q;
{
  q->a = *p--;
  return p;
}

static Sfloat *
popsf_struct_b(p, q)
Sfloat *p;
struct pop_fpair *q;
{
  q->b = *p--;
  return p;
}

static Sint *
popsi_global_struct_a(p)
Sint *p;
{
  pop_gp.a = *p--;
  return p;
}

static Sint *
popsi_global_struct_b(p)
Sint *p;
{
  pop_gp.b = *p--;
  return p;
}

static Sfloat *
popsf_global_struct_a(p)
Sfloat *p;
{
  pop_fgp.a = *p--;
  return p;
}

static Sfloat *
popsf_global_struct_b(p)
Sfloat *p;
{
  pop_fgp.b = *p--;
  return p;
}

static Sint
popsi_reg_plus(pp, y)
Sint **pp;
Sint y;
{
  Sint *p;
  Sint v;

  p = *pp;
  v = *p--;
  *pp = p;
  return v + y;
}

static Sint
popsi_reg_xor(pp, y)
Sint **pp;
Sint y;
{
  Sint *p;
  Sint v;

  p = *pp;
  v = *p--;
  *pp = p;
  return v ^ y;
}

static Sfloat
popsf_reg_plus(pp, y)
Sfloat **pp;
Sfloat y;
{
  Sfloat *p;
  Sfloat v;

  p = *pp;
  v = *p--;
  *pp = p;
  return v + y;
}

static Sint *
popsi_two(p, x, y)
Sint *p;
Sint *x;
Sint *y;
{
  *x = *p--;
  *y = *p--;
  return p;
}

static Sfloat *
popsf_two(p, x, y)
Sfloat *p;
Sfloat *x;
Sfloat *y;
{
  *x = *p--;
  *y = *p--;
  return p;
}

static Sint
popsi_two_regs(pp)
Sint **pp;
{
  Sint *p;
  Sint a;
  Sint b;

  p = *pp;
  a = *p--;
  b = *p--;
  *pp = p;
  return a + b;
}

static Sfloat
popsf_two_regs(pp)
Sfloat **pp;
{
  Sfloat *p;
  Sfloat a;
  Sfloat b;

  p = *pp;
  a = *p--;
  b = *p--;
  *pp = p;
  return a + b;
}

static Sint *
popsi_mixed(p, x)
Sint *p;
Sint *x;
{
  *x = *p--;
  pop_ga = *p--;
  return p;
}

static Sfloat *
popsf_mixed(p, x)
Sfloat *p;
Sfloat *x;
{
  *x = *p--;
  pop_fa = *p--;
  return p;
}

static Sint *
popsi_to_volatile(p, x)
Sint *p;
volatile Sint *x;
{
  *x = *p--;
  return p;
}

static Sfloat *
popsf_to_volatile(p, x)
Sfloat *p;
volatile Sfloat *x;
{
  *x = *p--;
  return p;
}

static Sint
popsi_from_volatile(pp)
volatile Sint **pp;
{
  volatile Sint *p;
  Sint v;

  p = *pp;
  v = *p--;
  *pp = p;
  return v;
}

static Sint *
popsi_postdec_used_twice(p, x)
Sint *p;
Sint *x;
{
  *x = *p--;
  *x += *p;
  return p;
}

static Sfloat *
popsf_postdec_used_twice(p, x)
Sfloat *p;
Sfloat *x;
{
  *x = *p--;
  *x += *p;
  return p;
}

static Sint
popsi_local_stack_like(p)
Sint *p;
{
  Sint a;

  a = *p--;
  return ext_sint(a) + (Sint)(uSint)p;
}

static Sfloat
popsf_local_stack_like(p)
Sfloat *p;
{
  Sfloat a;

  a = *p--;
  return ext_sfloat(a);
}
