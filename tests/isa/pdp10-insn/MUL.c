/* flag: -mlong-long-71bit */
#include "insns.h"

/*
 * MUL instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   MUL   AC,reg/mem/literal -> double-word product in AC,AC+1
 *   MULI  AC,small-immediate
 *   MULM  memory <- high/native part of product
 *   MULB  AC and memory <- high/native part of product
 *
 * The MULM/MULB cases are intentionally present even if the current
 * backend still lowers them through longer sequences.  They are target
 * instruction-family coverage and should drive backend improvement.
 */

#define UMUL(X, Y) ((uDint)(X) * (uDint)(Y))
#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint mul_ga;
static Sint mul_gb;
static Sint mul_gc;
static Sint mul_buf[16];

struct mul_pair {
  Sint a;
  Sint b;
};

static struct mul_pair mul_gp;

static Dint
mul_reg_reg(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return MUL(a, b);
}

static Dint
mul_reg_mem(a, p)
Sint a;
Sint *p;
{
  return MUL(a, *p);
}

static Dint
mul_mem_reg(p, b)
Sint *p;
Sint b;
{
  return MUL(*p, b);
}

static Dint
mul_mem_mem(a, b)
Sint *a;
Sint *b;
{
  return MUL(*a, *b);
}

static Dint
mul_global_a(a)
Sint a;
{
  return MUL(a, mul_ga);
}

static Dint
mul_global_b(void)
{
  return MUL(mul_ga, mul_gb);
}

static Dint
mul_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return MUL(a, v[i & 017]);
}

static Dint
mul_global_array(i, a)
Sint i;
Sint a;
{
  return MUL(a, mul_buf[i & 017]);
}

static Dint
mul_struct_a(p, a)
struct mul_pair *p;
Sint a;
{
  return MUL(a, p->a);
}

static Dint
mul_struct_b(p, a)
struct mul_pair *p;
Sint a;
{
  return MUL(a, p->b);
}

static Dint
mul_global_struct_a(a)
Sint a;
{
  return MUL(a, mul_gp.a);
}

static Dint
mul_global_struct_b(a)
Sint a;
{
  return MUL(a, mul_gp.b);
}

static Dint
muli_one(a)
Sint a;
{
  return MUL(a, 1);
}

static Dint
muli_two(a)
Sint a;
{
  return MUL(a, 2);
}

static Dint
muli_small(a)
Sint a;
{
  return MUL(a, 0123456);
}

static Dint
muli_max18(a)
Sint a;
{
  return MUL(a, 0777777);
}

static Dint
mul_literal(a)
Sint a;
{
  return MUL(a, 0123456123456);
}

static Dint
mul_literal_2(a)
Sint a;
{
  return MUL(a, 0377777000000);
}

static Dint
mul_literal_neg(a)
Sint a;
{
  return MUL(a, -0123456);
}

static Dint
mul_commuted_literal(a)
Sint a;
{
  return MUL(0123456123456, a);
}

static Dint
mul_commuted_small(a)
Sint a;
{
  return MUL(0123456, a);
}

static void
mul_store_reg(out, a, b)
Dint *out;
Sint a;
Sint b;
{
  *out = MUL(a, b);
}

static void
mul_store_mem(out, a, p)
Dint *out;
Sint a;
Sint *p;
{
  *out = MUL(a, *p);
}

static Dint
mul_store_return(out, a, b)
Dint *out;
Sint a;
Sint b;
{
  *out = MUL(a, b);
  return *out;
}

static Sint
mul_low_reg(a, b)
Sint a;
Sint b;
{
  return (Sint)MUL(a, b);
}

static Sint
mul_low_mem(a, p)
Sint a;
Sint *p;
{
  return (Sint)MUL(a, *p);
}

static Sint
mul_high_reg(a, b)
Sint a;
Sint b;
{
  return smul_highpart(a, b);
}

static Sint
mul_high_mem(a, p)
Sint a;
Sint *p;
{
  return smul_highpart(a, *p);
}

static Sint
mul_high_literal(a)
Sint a;
{
  return smul_highpart(a, 0123456123456);
}

static void
mulm_reg_mem(ac, x)
Sint ac;
Sint *x;
{
  *x = smul_highpart(ac, *x);
}

static void
mulm_mem_reg(x, ac)
Sint *x;
Sint ac;
{
  *x = smul_highpart(*x, ac);
}

static void
mulm_global(ac)
Sint ac;
{
  mul_ga = smul_highpart(ac, mul_ga);
}

static void
mulm_global_2(ac)
Sint ac;
{
  mul_gb = smul_highpart(mul_gb, ac);
}

static void
mulm_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  v[i & 017] = smul_highpart(ac, v[i & 017]);
}

static void
mulm_global_array(i, ac)
Sint i;
Sint ac;
{
  mul_buf[i & 017] = smul_highpart(ac, mul_buf[i & 017]);
}

static void
mulm_struct_a(p, ac)
struct mul_pair *p;
Sint ac;
{
  p->a = smul_highpart(ac, p->a);
}

static void
mulm_struct_b(p, ac)
struct mul_pair *p;
Sint ac;
{
  p->b = smul_highpart(p->b, ac);
}

static void
mulm_const_small(x)
Sint *x;
{
  *x = smul_highpart(0123456, *x);
}

static void
mulm_const_literal(x)
Sint *x;
{
  *x = smul_highpart(0123456123456, *x);
}

static Sint
mulb_reg_mem(ac, x)
Sint ac;
Sint *x;
{
  *x = smul_highpart(ac, *x);
  return *x;
}

static Sint
mulb_mem_reg(x, ac)
Sint *x;
Sint ac;
{
  *x = smul_highpart(*x, ac);
  return *x;
}

static Sint
mulb_global(ac)
Sint ac;
{
  mul_ga = smul_highpart(ac, mul_ga);
  return mul_ga;
}

static Sint
mulb_global_2(ac)
Sint ac;
{
  mul_gb = smul_highpart(mul_gb, ac);
  return mul_gb;
}

static Sint
mulb_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  v[i & 017] = smul_highpart(ac, v[i & 017]);
  return v[i & 017];
}

static Sint
mulb_global_array(i, ac)
Sint i;
Sint ac;
{
  mul_buf[i & 017] = smul_highpart(ac, mul_buf[i & 017]);
  return mul_buf[i & 017];
}

static Sint
mulb_struct_a(p, ac)
struct mul_pair *p;
Sint ac;
{
  p->a = smul_highpart(ac, p->a);
  return p->a;
}

static Sint
mulb_struct_b(p, ac)
struct mul_pair *p;
Sint ac;
{
  p->b = smul_highpart(p->b, ac);
  return p->b;
}

static Sint
mulb_self(x)
Sint *x;
{
  *x = smul_highpart(*x, *x);
  return *x;
}

static uDint
umul_reg_reg(a, b)
uSint a;
uSint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return UMUL(a, b);
}

static uDint
umul_reg_mem(a, p)
uSint a;
uSint *p;
{
  return UMUL(a, *p);
}

static uDint
umuli_small(a)
uSint a;
{
  return UMUL(a, 0123456);
}

static uDint
umul_literal(a)
uSint a;
{
  return UMUL(a, 0123456123456);
}

static uSint
umul_low(a, b)
uSint a;
uSint b;
{
  return (uSint)UMUL(a, b);
}
