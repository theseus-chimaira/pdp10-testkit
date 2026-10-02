#include "insns.h"


/*
 * Signed SImode multiply-highpart pattern pressure.
 *
 * Intended pattern:
 *   smulsi3_highpart
 *
 * Ordinary C shape used by the existing test set:
 *
 *   MUL(x, y) >> 35
 *
 * Keep this file signed-only.  Unsigned multiply-highpart belongs to
 * umulsi3_highpart.c.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern void clobber(void);

static Sint smulhp_ga;
static Sint smulhp_gb;
static Sint smulhp_gc;
static volatile Sint smulhp_vga;
static volatile Sint smulhp_opaque;
static Sint smulhp_buf[16];

struct smulhp_pair {
  Sint a;
  Sint b;
};

struct smulhp_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct smulhp_pair smulhp_gp;
static struct smulhp_three smulhp_gt;

/*
 * Ordinary-C opacity helper.  This replaces the old inline-asm
 * hard-register hiding trick where needed.
 */

static Sint
opaque_si(x)
Sint x;
{
  smulhp_opaque = x;
  return smulhp_opaque;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
mulm1(x, y, q)
Sint x;
Sint y;
Sint q;
{
  x = MUL(x, y) >> 35;

  /*
   * Addition needed to make the highpart value remain visible after
   * combine/reload decisions.
   */
  return x + q;
}

static void
mulm2(x, y)
Sint x;
Sint *y;
{
  *y = MUL(x, *y) >> 35;
}

/*
 * Basic register/register forms.
 */

static Sint
smulhp_reg(x, y)
Sint x;
Sint y;
{
  return MUL(x, y) >> 35;
}

static Sint
smulhp_reg_commuted(x, y)
Sint x;
Sint y;
{
  return MUL(y, x) >> 35;
}

static Sint
smulhp_reg_opaque(x, y)
Sint x;
Sint y;
{
  x = opaque_si(x);
  y = opaque_si(y);
  return MUL(x, y) >> 35;
}

static Sint
smulhp_local(x, y)
Sint x;
Sint y;
{
  Sint t;

  t = MUL(x, y) >> 35;
  return t;
}

static Sint
smulhp_reuse_left(x, y)
Sint x;
Sint y;
{
  x = MUL(x, y) >> 35;
  return x;
}

static Sint
smulhp_reuse_right(x, y)
Sint x;
Sint y;
{
  y = MUL(x, y) >> 35;
  return y;
}

/*
 * Constants and immediate-like operands.
 */

static Sint
smulhp_zero(x)
Sint x;
{
  return MUL(x, 0) >> 35;
}

static Sint
smulhp_one(x)
Sint x;
{
  return MUL(x, 1) >> 35;
}

static Sint
smulhp_minus_one(x)
Sint x;
{
  return MUL(x, -1) >> 35;
}

static Sint
smulhp_small_positive(x)
Sint x;
{
  return MUL(x, 0123) >> 35;
}

static Sint
smulhp_small_negative(x)
Sint x;
{
  return MUL(x, -0123) >> 35;
}

static Sint
smulhp_large_positive(x)
Sint x;
{
  return MUL(x, 0123456) >> 35;
}

static Sint
smulhp_large_negative(x)
Sint x;
{
  return MUL(x, -0123456) >> 35;
}

static Sint
smulhp_const_left(x)
Sint x;
{
  return MUL(0123456, x) >> 35;
}

static Sint
smulhp_const_negative_left(x)
Sint x;
{
  return MUL(-0123456, x) >> 35;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
smulhp_mem_left(p, y)
Sint *p;
Sint y;
{
  return MUL(*p, y) >> 35;
}

static Sint
smulhp_mem_right(x, p)
Sint x;
Sint *p;
{
  return MUL(x, *p) >> 35;
}

static Sint
smulhp_mem_mem(p, q)
Sint *p;
Sint *q;
{
  return MUL(*p, *q) >> 35;
}

static Sint
smulhp_mem_loaded(p, q)
Sint *p;
Sint *q;
{
  Sint x;
  Sint y;

  x = *p;
  y = *q;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_global_left(y)
Sint y;
{
  return MUL(smulhp_ga, y) >> 35;
}

static Sint
smulhp_global_right(x)
Sint x;
{
  return MUL(x, smulhp_ga) >> 35;
}

static Sint
smulhp_global_global()
{
  return MUL(smulhp_ga, smulhp_gb) >> 35;
}

static Sint
smulhp_volatile_left(y)
Sint y;
{
  Sint x;

  x = smulhp_vga;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_volatile_right(x)
Sint x;
{
  Sint y;

  y = smulhp_vga;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_volatile_mem(p, q)
volatile Sint *p;
volatile Sint *q;
{
  Sint x;
  Sint y;

  x = *p;
  y = *q;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_array_left(v, i, y)
Sint *v;
Sint i;
Sint y;
{
  return MUL(v[i & 017], y) >> 35;
}

static Sint
smulhp_array_right(x, v, i)
Sint x;
Sint *v;
Sint i;
{
  return MUL(x, v[i & 017]) >> 35;
}

static Sint
smulhp_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  return MUL(v[i & 017], v[j & 017]) >> 35;
}

static Sint
smulhp_global_array_left(i, y)
Sint i;
Sint y;
{
  return MUL(smulhp_buf[i & 017], y) >> 35;
}

static Sint
smulhp_global_array_right(x, i)
Sint x;
Sint i;
{
  return MUL(x, smulhp_buf[i & 017]) >> 35;
}

static Sint
smulhp_global_array_array(i, j)
Sint i;
Sint j;
{
  return MUL(smulhp_buf[i & 017], smulhp_buf[j & 017]) >> 35;
}

static Sint
smulhp_struct_a(p, y)
struct smulhp_pair *p;
Sint y;
{
  return MUL(p->a, y) >> 35;
}

static Sint
smulhp_struct_b(p, x)
struct smulhp_pair *p;
Sint x;
{
  return MUL(x, p->b) >> 35;
}

static Sint
smulhp_struct_ab(p)
struct smulhp_pair *p;
{
  return MUL(p->a, p->b) >> 35;
}

static Sint
smulhp_global_struct_a(y)
Sint y;
{
  return MUL(smulhp_gp.a, y) >> 35;
}

static Sint
smulhp_global_struct_b(x)
Sint x;
{
  return MUL(x, smulhp_gp.b) >> 35;
}

static Sint
smulhp_global_struct_ab()
{
  return MUL(smulhp_gp.a, smulhp_gp.b) >> 35;
}

static Sint
smulhp_three_ab(p)
struct smulhp_three *p;
{
  return MUL(p->a, p->b) >> 35;
}

static Sint
smulhp_three_bc(p)
struct smulhp_three *p;
{
  return MUL(p->b, p->c) >> 35;
}

static Sint
smulhp_indirect_left(pp, y)
Sint **pp;
Sint y;
{
  Sint *p;

  p = *pp;
  return MUL(*p, y) >> 35;
}

static Sint
smulhp_indirect_right(x, pp)
Sint x;
Sint **pp;
{
  Sint *p;

  p = *pp;
  return MUL(x, *p) >> 35;
}

static Sint
smulhp_indexed_indirect(pp, i, y)
Sint **pp;
Sint i;
Sint y;
{
  Sint *p;

  p = *pp;
  return MUL(p[i & 017], y) >> 35;
}

/*
 * Expression sources.
 */

static Sint
smulhp_expr_add(a, b, y)
Sint a;
Sint b;
Sint y;
{
  Sint x;

  x = a + b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_expr_sub(a, b, y)
Sint a;
Sint b;
Sint y;
{
  Sint x;

  x = a - b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_expr_xor(a, b, y)
Sint a;
Sint b;
Sint y;
{
  Sint x;

  x = a ^ b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_expr_and(a, b, y)
Sint a;
Sint b;
Sint y;
{
  Sint x;

  x = a & b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_expr_or(a, b, y)
Sint a;
Sint b;
Sint y;
{
  Sint x;

  x = a | b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_expr_neg(a, y)
Sint a;
Sint y;
{
  Sint x;

  x = -a;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_expr_shift(a, y)
Sint a;
Sint y;
{
  Sint x;

  x = a >> 3;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_two_exprs(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint x;
  Sint y;

  x = a + b;
  y = c - d;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_call_expr(y)
Sint y;
{
  Sint x;

  x = f();
  return MUL(x, y) >> 35;
}

/*
 * Store highpart result.
 */

static void
smulhp_store(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  *out = MUL(x, y) >> 35;
}

static Sint
smulhp_store_return(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  Sint t;

  t = MUL(x, y) >> 35;
  *out = t;
  return t;
}

static Sint
smulhp_store_return_mem(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  *out = MUL(x, y) >> 35;
  return *out;
}

static void
smulhp_store_global(x, y)
Sint x;
Sint y;
{
  smulhp_ga = MUL(x, y) >> 35;
}

static Sint
smulhp_store_global_return(x, y)
Sint x;
Sint y;
{
  smulhp_ga = MUL(x, y) >> 35;
  return smulhp_ga;
}

static void
smulhp_store_array(v, i, x, y)
Sint *v;
Sint i;
Sint x;
Sint y;
{
  v[i & 017] = MUL(x, y) >> 35;
}

static Sint
smulhp_store_array_return(v, i, x, y)
Sint *v;
Sint i;
Sint x;
Sint y;
{
  v[i & 017] = MUL(x, y) >> 35;
  return v[i & 017];
}

static void
smulhp_store_struct_a(p, x, y)
struct smulhp_pair *p;
Sint x;
Sint y;
{
  p->a = MUL(x, y) >> 35;
}

static Sint
smulhp_store_struct_b_return(p, x, y)
struct smulhp_pair *p;
Sint x;
Sint y;
{
  p->b = MUL(x, y) >> 35;
  return p->b;
}

static void
smulhp_store_indirect(pp, x, y)
Sint **pp;
Sint x;
Sint y;
{
  Sint *p;

  p = *pp;
  *p = MUL(x, y) >> 35;
}

static void
smulhp_volatile_store(out, x, y)
volatile Sint *out;
Sint x;
Sint y;
{
  *out = MUL(x, y) >> 35;
}

/*
 * Result consumed by arithmetic/logical expressions.
 */

static Sint
smulhp_add(x, y, q)
Sint x;
Sint y;
Sint q;
{
  return (MUL(x, y) >> 35) + q;
}

static Sint
smulhp_sub(x, y, q)
Sint x;
Sint y;
Sint q;
{
  return (MUL(x, y) >> 35) - q;
}

static Sint
smulhp_xor(x, y, q)
Sint x;
Sint y;
Sint q;
{
  return (MUL(x, y) >> 35) ^ q;
}

static Sint
smulhp_or(x, y, q)
Sint x;
Sint y;
Sint q;
{
  return (MUL(x, y) >> 35) | q;
}

static Sint
smulhp_and(x, y, q)
Sint x;
Sint y;
Sint q;
{
  return (MUL(x, y) >> 35) & q;
}

static Sint
smulhp_mul_again(x, y, q)
Sint x;
Sint y;
Sint q;
{
  return (MUL(x, y) >> 35) * q;
}

static Sint
smulhp_sources_live(x, y, q)
Sint x;
Sint y;
Sint q;
{
  Sint t;

  t = MUL(x, y) >> 35;
  return t + x + y + q;
}

static Sint
smulhp_memory_sources_live(p, q, add)
Sint *p;
Sint *q;
Sint add;
{
  Sint x;
  Sint y;
  Sint t;

  x = *p;
  y = *q;
  t = MUL(x, y) >> 35;
  return t + x + y + add;
}

static Sint
smulhp_two_values(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint x;
  Sint y;

  x = MUL(a, b) >> 35;
  y = MUL(c, d) >> 35;
  return x + y;
}

static Sint
smulhp_two_mems(a, b, c, d)
Sint *a;
Sint *b;
Sint *c;
Sint *d;
{
  Sint x;
  Sint y;

  x = MUL(*a, *b) >> 35;
  y = MUL(*c, *d) >> 35;
  return x + y;
}

/*
 * Branches based on the highpart result.
 */

static Sint
smulhp_branch_zero(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = MUL(x, y) >> 35;
  if (t == 0)
    return yes;
  return no;
}

static Sint
smulhp_branch_nonzero(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = MUL(x, y) >> 35;
  if (t != 0)
    return yes;
  return no;
}

static Sint
smulhp_branch_negative(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = MUL(x, y) >> 35;
  if (t < 0)
    return yes;
  return no;
}

static Sint
smulhp_branch_positive(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = MUL(x, y) >> 35;
  if (t > 0)
    return yes;
  return no;
}

static Sint
smulhp_likely(x, y)
Sint x;
Sint y;
{
  Sint t;

  t = MUL(x, y) >> 35;
  if (likely(t != 0))
    return t;
  return x + y;
}

static Sint
smulhp_unlikely(x, y)
Sint x;
Sint y;
{
  Sint t;

  t = MUL(x, y) >> 35;
  if (unlikely(t != 0))
    return t;
  return x + y;
}

/*
 * Call-pressure cases.
 */

static Sint
smulhp_call_pressure_reg(x, y)
Sint x;
Sint y;
{
  Sint t;

  t = MUL(x, y) >> 35;
  clobber();
  return t + x;
}

static Sint
smulhp_call_pressure_mem(p, q)
Sint *p;
Sint *q;
{
  Sint t;

  t = MUL(*p, *q) >> 35;
  clobber();
  return t + *p;
}

static Sint
smulhp_store_call_pressure(dst, x, y)
Sint *dst;
Sint x;
Sint y;
{
  *dst = MUL(x, y) >> 35;
  clobber();
  return *dst;
}

/*
 * Loop pressure.
 */

static Sint
smulhp_loop_sum(v, n, y)
Sint *v;
Sint n;
Sint y;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += MUL(v[i & 017], y) >> 35;

  return r;
}

static void
smulhp_loop_store(v, n, y)
Sint *v;
Sint n;
Sint y;
{
  Sint i;

  for (i = 0; i < n; ++i)
    v[i & 017] = MUL(v[i & 017], y) >> 35;
}

static Sint
smulhp_loop_store_sum(v, n, y)
Sint *v;
Sint n;
Sint y;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i) {
    v[i & 017] = MUL(v[i & 017], y) >> 35;
    r += v[i & 017];
  }

  return r;
}

/*
 * Promoted small signed inputs.  Secondary pressure only; the main
 * pattern is signed SImode highpart multiplication.
 */

static Sint
smulhp_qi(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_hi(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_qi_si(a, y)
sQint a;
Sint y;
{
  Sint x;

  x = a;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_hi_si(a, y)
Hint a;
Sint y;
{
  Sint x;

  x = a;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_qi_mem(p, y)
sQint *p;
Sint y;
{
  Sint x;

  x = *p;
  return MUL(x, y) >> 35;
}

static Sint
smulhp_hi_mem(p, y)
Hint *p;
Sint y;
{
  Sint x;

  x = *p;
  return MUL(x, y) >> 35;
}

/*
 * Existing harness macro hooks.
 */

BOTH (smulhp_both_reg, MUL(a, *b) >> 35)
BOTH (smulhp_both_mem, MUL(*b, a) >> 35)

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

Sint
smulsi3_highpart_smoke(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint r;

  r = smulhp_reg(a, b);
  r += smulhp_add(b, c, a);
  r += smulhp_expr_sub(a, c, b);
  return r;
}

Sint
shpmem(p, q, a)
Sint *p;
Sint *q;
Sint a;
{
  Sint r;

  r = smulhp_mem_mem(p, q);
  r += smulhp_store_return(p, r, a);
  r += smulhp_memory_sources_live(p, q, a);
  return r;
}

Sint
shpctl(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint r;

  r = smulhp_loop_sum(v, n, a);
  r += smulhp_branch_nonzero(r, a, n, a);
  return r;
}
