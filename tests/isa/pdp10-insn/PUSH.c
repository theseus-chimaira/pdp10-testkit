/* flag: -Os */
#include "insns.h"

/*
 * PUSH instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   PUSH P,AC      push register value
 *   PUSH P,MEM     push memory value
 *
 * The source expression must keep the pre-increment visible:
 *
 *   *++p = x;
 *
 * This gives the backend a direct PUSH opportunity.  Keep both SI and
 * SF cases because the machine description has separate useful paths
 * for word and floating-like word values.
 */

extern void clobber(void);
extern Sint ext_sint(Sint);
extern Sfloat ext_sfloat(Sfloat);

static Sint push_ga;
static Sint push_gb;
static Sfloat push_fa;
static Sfloat push_fb;

static Sint push_buf[16];
static Sfloat push_fbuf[16];

struct push_pair {
  Sint a;
  Sint b;
};

struct push_fpair {
  Sfloat a;
  Sfloat b;
};

static struct push_pair push_gp;
static struct push_fpair push_fgp;

static Sint
push_prologue(x)
Sint x;
{
  clobber();
  return x;
}

static Sint
push_prologue_2(a, b, c, d)
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
push_prologue_call(a, b)
Sint a;
Sint b;
{
  Sint t;

  t = ext_sint(a);
  clobber();
  return t + b;
}

static Sfloat
push_prologue_sf(x)
Sfloat x;
{
  clobber();
  return x;
}

static Sfloat
push_prologue_sf_call(a, b)
Sfloat a;
Sfloat b;
{
  Sfloat t;

  t = ext_sfloat(a);
  clobber();
  return t + b;
}

static Sint *
pushsi_reg(p, x)
Sint *p;
Sint x;
{
  *++p = x;
  return p;
}

static Sint *
pushsi_mem(p, x)
Sint *p;
Sint *x;
{
  *++p = *x;
  return p;
}

static Sfloat *
pushsf_reg(p, x)
Sfloat *p;
Sfloat x;
{
  *++p = x;
  return p;
}

static Sfloat *
pushsf_mem(p, x)
Sfloat *p;
Sfloat *x;
{
  *++p = *x;
  return p;
}

static Sint *
pushsi_global(p)
Sint *p;
{
  *++p = push_ga;
  return p;
}

static Sint *
pushsi_global_b(p)
Sint *p;
{
  *++p = push_gb;
  return p;
}

static Sfloat *
pushsf_global(p)
Sfloat *p;
{
  *++p = push_fa;
  return p;
}

static Sfloat *
pushsf_global_b(p)
Sfloat *p;
{
  *++p = push_fb;
  return p;
}

static Sint *
pushsi_const_zero(p)
Sint *p;
{
  *++p = 0;
  return p;
}

static Sint *
pushsi_const_one(p)
Sint *p;
{
  *++p = 1;
  return p;
}

static Sint *
pushsi_const_small(p)
Sint *p;
{
  *++p = 0123456;
  return p;
}

static Sint *
pushsi_const_big(p)
Sint *p;
{
  *++p = 0123456123456;
  return p;
}

static Sint *
pushsi_array_src(p, v, i)
Sint *p;
Sint *v;
Sint i;
{
  *++p = v[i & 017];
  return p;
}

static Sfloat *
pushsf_array_src(p, v, i)
Sfloat *p;
Sfloat *v;
Sint i;
{
  *++p = v[i & 017];
  return p;
}

static Sint *
pushsi_global_array_src(p, i)
Sint *p;
Sint i;
{
  *++p = push_buf[i & 017];
  return p;
}

static Sfloat *
pushsf_global_array_src(p, i)
Sfloat *p;
Sint i;
{
  *++p = push_fbuf[i & 017];
  return p;
}

static Sint *
pushsi_struct_a(p, q)
Sint *p;
struct push_pair *q;
{
  *++p = q->a;
  return p;
}

static Sint *
pushsi_struct_b(p, q)
Sint *p;
struct push_pair *q;
{
  *++p = q->b;
  return p;
}

static Sfloat *
pushsf_struct_a(p, q)
Sfloat *p;
struct push_fpair *q;
{
  *++p = q->a;
  return p;
}

static Sfloat *
pushsf_struct_b(p, q)
Sfloat *p;
struct push_fpair *q;
{
  *++p = q->b;
  return p;
}

static Sint *
pushsi_global_struct_a(p)
Sint *p;
{
  *++p = push_gp.a;
  return p;
}

static Sint *
pushsi_global_struct_b(p)
Sint *p;
{
  *++p = push_gp.b;
  return p;
}

static Sfloat *
pushsf_global_struct_a(p)
Sfloat *p;
{
  *++p = push_fgp.a;
  return p;
}

static Sfloat *
pushsf_global_struct_b(p)
Sfloat *p;
{
  *++p = push_fgp.b;
  return p;
}

static Sint *
pushsi_expr_add(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  *++p = a + b;
  return p;
}

static Sint *
pushsi_expr_xor(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  *++p = a ^ b;
  return p;
}

static Sint *
pushsi_expr_and(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  *++p = a & b;
  return p;
}

static Sint *
pushsi_expr_or(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  *++p = a | b;
  return p;
}

static Sfloat *
pushsf_expr_add(p, a, b)
Sfloat *p;
Sfloat a;
Sfloat b;
{
  *++p = a + b;
  return p;
}

static Sint *
pushsi_call(p, x)
Sint *p;
Sint x;
{
  *++p = ext_sint(x);
  return p;
}

static Sfloat *
pushsf_call(p, x)
Sfloat *p;
Sfloat x;
{
  *++p = ext_sfloat(x);
  return p;
}

static Sint *
pushsi_two_regs(p, x, y)
Sint *p;
Sint x;
Sint y;
{
  *++p = x;
  *++p = y;
  return p;
}

static Sint *
pushsi_two_mem(p, x, y)
Sint *p;
Sint *x;
Sint *y;
{
  *++p = *x;
  *++p = *y;
  return p;
}

static Sfloat *
pushsf_two_regs(p, x, y)
Sfloat *p;
Sfloat x;
Sfloat y;
{
  *++p = x;
  *++p = y;
  return p;
}

static Sfloat *
pushsf_two_mem(p, x, y)
Sfloat *p;
Sfloat *x;
Sfloat *y;
{
  *++p = *x;
  *++p = *y;
  return p;
}

static Sint *
pushsi_mixed(p, x)
Sint *p;
Sint *x;
{
  *++p = *x;
  *++p = push_ga;
  *++p = 0123456;
  return p;
}

static Sfloat *
pushsf_mixed(p, x)
Sfloat *p;
Sfloat *x;
{
  *++p = *x;
  *++p = push_fa;
  return p;
}

static Sint *
pushsi_from_volatile(p, x)
Sint *p;
volatile Sint *x;
{
  *++p = *x;
  return p;
}

static Sfloat *
pushsf_from_volatile(p, x)
Sfloat *p;
volatile Sfloat *x;
{
  *++p = *x;
  return p;
}

static volatile Sint *
pushsi_to_volatile(p, x)
volatile Sint *p;
Sint x;
{
  *++p = x;
  return p;
}

static volatile Sfloat *
pushsf_to_volatile(p, x)
volatile Sfloat *p;
Sfloat x;
{
  *++p = x;
  return p;
}

static Sint *
pushsi_post_value_used(p, x, y)
Sint *p;
Sint x;
Sint y;
{
  *++p = x;
  y += *p;
  push_ga = y;
  return p;
}

static Sfloat *
pushsf_post_value_used(p, x, y)
Sfloat *p;
Sfloat x;
Sfloat y;
{
  *++p = x;
  y += *p;
  push_fa = y;
  return p;
}

static Sint *
pushsi_update_through_pp(pp, x)
Sint **pp;
Sint x;
{
  Sint *p;

  p = *pp;
  *++p = x;
  *pp = p;
  return p;
}

static Sfloat *
pushsf_update_through_pp(pp, x)
Sfloat **pp;
Sfloat x;
{
  Sfloat *p;

  p = *pp;
  *++p = x;
  *pp = p;
  return p;
}

static Sint
pushsi_return_pushed(pp, x)
Sint **pp;
Sint x;
{
  Sint *p;

  p = *pp;
  *++p = x;
  *pp = p;
  return *p;
}

static Sfloat
pushsf_return_pushed(pp, x)
Sfloat **pp;
Sfloat x;
{
  Sfloat *p;

  p = *pp;
  *++p = x;
  *pp = p;
  return *p;
}

static Sint *
pushsi_preinc_combine(p, x)
Sint *p;
Sint x;
{
  (++p)[0] = x;
  return p;
}

static Sfloat *
pushsf_preinc_combine(p, x)
Sfloat *p;
Sfloat x;
{
  (++p)[0] = x;
  return p;
}

static Sint *
pushsi_preinc_mem_combine(p, x)
Sint *p;
Sint *x;
{
  (++p)[0] = *x;
  return p;
}

static Sfloat *
pushsf_preinc_mem_combine(p, x)
Sfloat *p;
Sfloat *x;
{
  (++p)[0] = *x;
  return p;
}

static Sint *
pushsi_local_stack_like(p, x)
Sint *p;
Sint x;
{
  Sint a;

  a = ext_sint(x);
  *++p = a;
  return p;
}

static Sfloat *
pushsf_local_stack_like(p, x)
Sfloat *p;
Sfloat x;
{
  Sfloat a;

  a = ext_sfloat(x);
  *++p = a;
  return p;
}
