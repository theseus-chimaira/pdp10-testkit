#include "insns.h"


/*
 * SImode XOR pattern pressure for PDP-6/166 and KA10.
 *
 * Intended forms include:
 *   XOR    AC <- AC ^ E
 *   XORI   AC <- AC ^ immediate
 *   XORM   E  <- AC ^ E
 *   XORB   AC <- AC ^ E, E <- AC ^ E
 *
 * Also pressure immediate shapes that may select related PDP-10
 * logical forms:
 *   XORI   right-half immediate
 *   TLC    left-half immediate complement
 *   EQVI   xor with complemented immediate shape
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern void clobber(void);

static Sint xor_ga;
static Sint xor_gb;
static Sint xor_gc;
static volatile Sint xor_vga;
static Sint xor_buf[16];

static uSint uxor_ga;
static uSint uxor_gb;
static volatile uSint uxor_vga;
static uSint uxor_buf[16];

struct xor_pair {
  Sint a;
  Sint b;
};

struct xor_three {
  Sint a;
  Sint b;
  Sint c;
};

struct uxor_pair {
  uSint a;
  uSint b;
};

static struct xor_pair xor_gp;
static struct xor_three xor_gt;
static struct uxor_pair uxor_gp;

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
xor1(a, e)
Sint a;
Sint e;
{
  return a ^ e;
}

static Sint
xor2(a, e)
Sint a;
Sint *e;
{
  return a ^ *e;
}

static Sint
xori(a)
Sint a;
{
  return a ^ 0123456;
}

static Sint
tlc(a)
Sint a;
{
  return a ^ 0123456000000;
}

static Sint
eqvi(a)
Sint a;
{
  return a ^ ~0123456;
}

static Sint
xor3(a)
Sint a;
{
  return a ^ 0123456123456;
}

static void
xorm(a, e)
Sint a;
Sint *e;
{
  *e ^= a;
}

/*
 * Basic register/register and expression forms.
 */

static Sint
xor_reg(a, e)
Sint a;
Sint e;
{
  return a ^ e;
}

static Sint
xor_reg_commuted(a, e)
Sint a;
Sint e;
{
  return e ^ a;
}

static Sint
xor_self(a)
Sint a;
{
  return a ^ a;
}

static Sint
xor_zero(a)
Sint a;
{
  return a ^ 0;
}

static Sint
xor_ones(a)
Sint a;
{
  return a ^ 0777777777777;
}

static Sint
xor_not_shape(a)
Sint a;
{
  return a ^ ~0;
}

static Sint
xor_local(a, e)
Sint a;
Sint e;
{
  Sint t;

  t = a ^ e;
  return t;
}

static Sint
xor_reuse_left(a, e)
Sint a;
Sint e;
{
  a = a ^ e;
  return a;
}

static Sint
xor_reuse_right(a, e)
Sint a;
Sint e;
{
  e = a ^ e;
  return e;
}

static Sint
xor_from_add(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint x;

  x = a + b;
  return x ^ e;
}

static Sint
xor_from_sub(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint x;

  x = a - b;
  return x ^ e;
}

static Sint
xor_from_and(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint x;

  x = a & b;
  return x ^ e;
}

static Sint
xor_from_or(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint x;

  x = a | b;
  return x ^ e;
}

static Sint
xor_from_call(e)
Sint e;
{
  Sint a;

  a = f();
  return a ^ e;
}

/*
 * Immediate and literal forms.
 */

static Sint
xor_right_imm(a)
Sint a;
{
  return a ^ 0123456;
}

static Sint
xor_right_imm_small(a)
Sint a;
{
  return a ^ 0123;
}

static Sint
xor_right_imm_highbit(a)
Sint a;
{
  return a ^ 0400000;
}

static Sint
xor_right_imm_all(a)
Sint a;
{
  return a ^ 0777777;
}

static Sint
xor_left_imm(a)
Sint a;
{
  return a ^ 0123456000000;
}

static Sint
xor_left_imm_small(a)
Sint a;
{
  return a ^ 0001230000000;
}

static Sint
xor_left_imm_sign(a)
Sint a;
{
  return a ^ 0400000000000;
}

static Sint
xor_left_imm_all(a)
Sint a;
{
  return a ^ 0777777000000;
}

static Sint
xor_full_literal(a)
Sint a;
{
  return a ^ 0123456123456;
}

static Sint
xor_full_literal_alt(a)
Sint a;
{
  return a ^ 0525252252525;
}

static Sint
xor_eqvi_right(a)
Sint a;
{
  return a ^ ~0123456;
}

static Sint
xor_eqvi_left(a)
Sint a;
{
  return a ^ ~0123456000000;
}

static Sint
xor_eqvi_full(a)
Sint a;
{
  return a ^ ~0123456123456;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
xor_mem_right(a, p)
Sint a;
Sint *p;
{
  return a ^ *p;
}

static Sint
xor_mem_left(p, e)
Sint *p;
Sint e;
{
  return *p ^ e;
}

static Sint
xor_mem_mem(p, q)
Sint *p;
Sint *q;
{
  return *p ^ *q;
}

static Sint
xor_mem_loaded(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint e;

  a = *p;
  e = *q;
  return a ^ e;
}

static Sint
xor_global_right(a)
Sint a;
{
  return a ^ xor_ga;
}

static Sint
xor_global_left(e)
Sint e;
{
  return xor_ga ^ e;
}

static Sint
xor_global_global()
{
  return xor_ga ^ xor_gb;
}

static Sint
xor_volatile_right(a)
Sint a;
{
  Sint e;

  e = xor_vga;
  return a ^ e;
}

static Sint
xor_volatile_left(e)
Sint e;
{
  Sint a;

  a = xor_vga;
  return a ^ e;
}

static Sint
xor_volatile_mem(p, q)
volatile Sint *p;
volatile Sint *q;
{
  Sint a;
  Sint e;

  a = *p;
  e = *q;
  return a ^ e;
}

static Sint
xor_array_right(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a ^ v[i & 017];
}

static Sint
xor_array_left(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  return v[i & 017] ^ e;
}

static Sint
xor_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  return v[i & 017] ^ v[j & 017];
}

static Sint
xor_global_array_right(a, i)
Sint a;
Sint i;
{
  return a ^ xor_buf[i & 017];
}

static Sint
xor_global_array_left(i, e)
Sint i;
Sint e;
{
  return xor_buf[i & 017] ^ e;
}

static Sint
xor_struct_a(p, e)
struct xor_pair *p;
Sint e;
{
  return p->a ^ e;
}

static Sint
xor_struct_b(a, p)
Sint a;
struct xor_pair *p;
{
  return a ^ p->b;
}

static Sint
xor_struct_ab(p)
struct xor_pair *p;
{
  return p->a ^ p->b;
}

static Sint
xor_three_ab(p)
struct xor_three *p;
{
  return p->a ^ p->b;
}

static Sint
xor_three_abc(p)
struct xor_three *p;
{
  return p->a ^ p->b ^ p->c;
}

static Sint
xor_global_struct_a(e)
Sint e;
{
  return xor_gp.a ^ e;
}

static Sint
xor_global_struct_b(a)
Sint a;
{
  return a ^ xor_gp.b;
}

static Sint
xor_global_three()
{
  return xor_gt.a ^ xor_gt.b ^ xor_gt.c;
}

static Sint
xor_indirect_right(a, pp)
Sint a;
Sint **pp;
{
  Sint *p;

  p = *pp;
  return a ^ *p;
}

static Sint
xor_indirect_left(pp, e)
Sint **pp;
Sint e;
{
  Sint *p;

  p = *pp;
  return *p ^ e;
}

static Sint
xor_indexed_indirect(pp, i, e)
Sint **pp;
Sint i;
Sint e;
{
  Sint *p;

  p = *pp;
  return p[i & 017] ^ e;
}

/*
 * XORM-style store forms.
 */

static void
xorm_reg_mem(a, p)
Sint a;
Sint *p;
{
  *p = *p ^ a;
}

static void
xorm_reg_mem_op(a, p)
Sint a;
Sint *p;
{
  *p ^= a;
}

static Sint
xorm_reg_mem_ret_mem(a, p)
Sint a;
Sint *p;
{
  *p = *p ^ a;
  return *p;
}

static Sint
xorm_reg_mem_ret_result(a, p)
Sint a;
Sint *p;
{
  Sint t;

  t = *p ^ a;
  *p = t;
  return t;
}

static void
xorm_mem_mem(src, dst)
Sint *src;
Sint *dst;
{
  *dst = *dst ^ *src;
}

static Sint
xorm_mem_mem_ret(src, dst)
Sint *src;
Sint *dst;
{
  *dst = *dst ^ *src;
  return *dst;
}

static void
xorm_global(a)
Sint a;
{
  xor_ga ^= a;
}

static Sint
xorm_global_ret(a)
Sint a;
{
  xor_ga ^= a;
  return xor_ga;
}

static void
xorm_global_from_mem(p)
Sint *p;
{
  xor_gb ^= *p;
}

static Sint
xorm_global_from_mem_ret(p)
Sint *p;
{
  xor_gb ^= *p;
  return xor_gb;
}

static void
xorm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] ^= a;
}

static Sint
xorm_array_ret(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] ^= a;
  return v[i & 017];
}

static void
xorm_global_array(i, a)
Sint i;
Sint a;
{
  xor_buf[i & 017] ^= a;
}

static Sint
xorm_global_array_ret(i, a)
Sint i;
Sint a;
{
  xor_buf[i & 017] ^= a;
  return xor_buf[i & 017];
}

static void
xorm_struct_a(p, a)
struct xor_pair *p;
Sint a;
{
  p->a ^= a;
}

static void
xorm_struct_b(p, a)
struct xor_pair *p;
Sint a;
{
  p->b ^= a;
}

static Sint
xorm_struct_ret(p, a)
struct xor_pair *p;
Sint a;
{
  p->b ^= a;
  return p->b;
}

static void
xorm_global_struct(a)
Sint a;
{
  xor_gp.b ^= a;
}

static Sint
xorm_global_struct_ret(a)
Sint a;
{
  xor_gp.b ^= a;
  return xor_gp.b;
}

static void
xorm_indirect(pp, a)
Sint **pp;
Sint a;
{
  Sint *p;

  p = *pp;
  *p ^= a;
}

static Sint
xorm_indirect_ret(pp, a)
Sint **pp;
Sint a;
{
  Sint *p;

  p = *pp;
  *p ^= a;
  return *p;
}

static void
xorm_indexed_indirect(pp, i, a)
Sint **pp;
Sint i;
Sint a;
{
  Sint *p;

  p = *pp;
  p[i & 017] ^= a;
}

static Sint
xorm_indexed_indirect_ret(pp, i, a)
Sint **pp;
Sint i;
Sint a;
{
  Sint *p;

  p = *pp;
  p[i & 017] ^= a;
  return p[i & 017];
}

static void
xorm_volatile(dst, a)
volatile Sint *dst;
Sint a;
{
  Sint t;

  t = *dst ^ a;
  *dst = t;
}

static Sint
xorm_volatile_ret(dst, a)
volatile Sint *dst;
Sint a;
{
  Sint t;

  t = *dst ^ a;
  *dst = t;
  return *dst;
}

/*
 * XORB-style both-result pressure: store result and keep it live.
 */

static Sint
xorb_mem(a, p)
Sint a;
Sint *p;
{
  Sint t;

  t = a ^ *p;
  *p = t;
  return t;
}

static Sint
xorb_mem_add(a, p, q)
Sint a;
Sint *p;
Sint q;
{
  Sint t;

  t = a ^ *p;
  *p = t;
  return t + q;
}

static Sint
xorb_mem_xor(a, p, q)
Sint a;
Sint *p;
Sint q;
{
  Sint t;

  t = a ^ *p;
  *p = t;
  return t ^ q;
}

static Sint
xorb_global(a)
Sint a;
{
  Sint t;

  t = a ^ xor_ga;
  xor_ga = t;
  return t;
}

static Sint
xorb_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  Sint t;

  t = a ^ v[i & 017];
  v[i & 017] = t;
  return t;
}

static Sint
xorb_struct_a(p, a)
struct xor_pair *p;
Sint a;
{
  Sint t;

  t = a ^ p->a;
  p->a = t;
  return t;
}

static Sint
xorb_volatile(p, a)
volatile Sint *p;
Sint a;
{
  Sint e;
  Sint t;

  e = *p;
  t = a ^ e;
  *p = t;
  return t;
}

static Sint
xorb_source_live(a, p, q)
Sint a;
Sint *p;
Sint q;
{
  Sint e;
  Sint t;

  e = *p;
  t = a ^ e;
  *p = t;
  return t + a + e + q;
}

/*
 * Result consumed by arithmetic/logical expressions.
 */

static Sint
xor_add(a, e, q)
Sint a;
Sint e;
Sint q;
{
  return (a ^ e) + q;
}

static Sint
xor_sub(a, e, q)
Sint a;
Sint e;
Sint q;
{
  return (a ^ e) - q;
}

static Sint
xor_and(a, e, q)
Sint a;
Sint e;
Sint q;
{
  return (a ^ e) & q;
}

static Sint
xor_or(a, e, q)
Sint a;
Sint e;
Sint q;
{
  return (a ^ e) | q;
}

static Sint
xor_xor_again(a, e, q)
Sint a;
Sint e;
Sint q;
{
  return (a ^ e) ^ q;
}

static Sint
xor_mul(a, e, q)
Sint a;
Sint e;
Sint q;
{
  return (a ^ e) * q;
}

static Sint
xor_sources_live(a, e, q)
Sint a;
Sint e;
Sint q;
{
  Sint t;

  t = a ^ e;
  return t + a + e + q;
}

static Sint
xor_memory_sources_live(p, q, add)
Sint *p;
Sint *q;
Sint add;
{
  Sint a;
  Sint e;
  Sint t;

  a = *p;
  e = *q;
  t = a ^ e;
  return t + a + e + add;
}

static Sint
xor_two_values(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint x;
  Sint y;

  x = a ^ b;
  y = c ^ d;
  return x + y;
}

static Sint
xor_two_mems(a, b, c, d)
Sint *a;
Sint *b;
Sint *c;
Sint *d;
{
  Sint x;
  Sint y;

  x = *a ^ *b;
  y = *c ^ *d;
  return x + y;
}

/*
 * Branches based on XOR result.
 */

static Sint
xor_branch_zero(a, e, yes, no)
Sint a;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = a ^ e;
  if (t == 0)
    return yes;
  return no;
}

static Sint
xor_branch_nonzero(a, e, yes, no)
Sint a;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = a ^ e;
  if (t != 0)
    return yes;
  return no;
}

static Sint
xor_branch_negative(a, e, yes, no)
Sint a;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = a ^ e;
  if (t < 0)
    return yes;
  return no;
}

static Sint
xor_branch_positive(a, e, yes, no)
Sint a;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = a ^ e;
  if (t > 0)
    return yes;
  return no;
}

static Sint
xor_likely(a, e)
Sint a;
Sint e;
{
  Sint t;

  t = a ^ e;
  if (likely(t != 0))
    return t;
  return a;
}

static Sint
xor_unlikely(a, e)
Sint a;
Sint e;
{
  Sint t;

  t = a ^ e;
  if (unlikely(t != 0))
    return t;
  return e;
}

/*
 * Call-pressure cases.
 */

static Sint
xor_call_pressure_reg(a, e)
Sint a;
Sint e;
{
  Sint t;

  t = a ^ e;
  clobber();
  return t + a;
}

static Sint
xor_call_pressure_mem(p, q)
Sint *p;
Sint *q;
{
  Sint t;

  t = *p ^ *q;
  clobber();
  return t + *p;
}

static Sint
xorm_call_pressure(dst, a)
Sint *dst;
Sint a;
{
  *dst ^= a;
  clobber();
  return *dst;
}

static Sint
xorb_call_pressure(dst, a)
Sint *dst;
Sint a;
{
  Sint t;

  t = *dst ^ a;
  *dst = t;
  clobber();
  return t;
}

/*
 * Loop pressure.
 */

static Sint
xor_loop_sum(v, n, e)
Sint *v;
Sint n;
Sint e;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017] ^ e;

  return r;
}

static void
xorm_loop(v, n, e)
Sint *v;
Sint n;
Sint e;
{
  Sint i;

  for (i = 0; i < n; ++i)
    v[i & 017] ^= e;
}

static Sint
xorm_loop_sum(v, n, e)
Sint *v;
Sint n;
Sint e;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i) {
    v[i & 017] ^= e;
    r += v[i & 017];
  }

  return r;
}

static Sint
xorb_loop_sum(v, n, e)
Sint *v;
Sint n;
Sint e;
{
  Sint i;
  Sint r;
  Sint t;

  r = 0;
  for (i = 0; i < n; ++i) {
    t = v[i & 017] ^ e;
    v[i & 017] = t;
    r += t;
  }

  return r;
}

/*
 * Unsigned variants.  XOR is the same machine operation, but these
 * help catch type-mode lowering differences.
 */

static uSint
uxor_reg(a, e)
uSint a;
uSint e;
{
  return a ^ e;
}

static uSint
uxor_mem(a, p)
uSint a;
uSint *p;
{
  return a ^ *p;
}

static uSint
uxor_mem_mem(p, q)
uSint *p;
uSint *q;
{
  return *p ^ *q;
}

static uSint
uxor_right_imm(a)
uSint a;
{
  return a ^ 0123456;
}

static uSint
uxor_left_imm(a)
uSint a;
{
  return a ^ 0123456000000;
}

static uSint
uxor_full_literal(a)
uSint a;
{
  return a ^ 0123456123456;
}

static uSint
uxor_eqvi_right(a)
uSint a;
{
  return a ^ ~0123456;
}

static uSint
uxor_global(a)
uSint a;
{
  return a ^ uxor_ga;
}

static uSint
uxor_volatile(a)
uSint a;
{
  uSint e;

  e = uxor_vga;
  return a ^ e;
}

static uSint
uxor_array(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  return v[i & 017] ^ a;
}

static uSint
uxor_global_array(i, a)
Sint i;
uSint a;
{
  return uxor_buf[i & 017] ^ a;
}

static uSint
uxor_struct_a(p, e)
struct uxor_pair *p;
uSint e;
{
  return p->a ^ e;
}

static uSint
uxor_global_struct()
{
  return uxor_gp.a ^ uxor_gp.b;
}

static void
uxorm_mem(a, p)
uSint a;
uSint *p;
{
  *p ^= a;
}

static uSint
uxorm_mem_ret(a, p)
uSint a;
uSint *p;
{
  *p ^= a;
  return *p;
}

static uSint
uxorb_mem(a, p)
uSint a;
uSint *p;
{
  uSint t;

  t = a ^ *p;
  *p = t;
  return t;
}

static uSint
uxor_add(a, e, q)
uSint a;
uSint e;
uSint q;
{
  return (a ^ e) + q;
}

static uSint
uxor_branch_nonzero(a, e, yes, no)
uSint a;
uSint e;
uSint yes;
uSint no;
{
  uSint t;

  t = a ^ e;
  if (t != 0)
    return yes;
  return no;
}

/*
 * Promoted small integer inputs.
 */

static Sint
xor_sqi(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x ^ y;
}

static Sint
xor_sqi_si(a, e)
sQint a;
Sint e;
{
  Sint x;

  x = a;
  return x ^ e;
}

static Sint
xor_hi(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x ^ y;
}

static Sint
xor_hi_si(a, e)
Hint a;
Sint e;
{
  Sint x;

  x = a;
  return x ^ e;
}

static uSint
xor_uqi(a, b)
uQint a;
uQint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x ^ y;
}

static uSint
xor_uhi(a, b)
uHint a;
uHint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x ^ y;
}

/*
 * Existing harness macro hooks.
 */

BOTH (xor_both_reg_mem, a ^ *b)
BOTH (xorm_both_mem, *b ^ a)

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

Sint
xorsi3_smoke(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint r;

  r = xor1(a, b);
  r += xori(r);
  r += tlc(b);
  r += eqvi(c);
  r += xor_add(a, b, c);
  return r;
}

Sint
xor3mm(p, q, a)
Sint *p;
Sint *q;
Sint a;
{
  Sint r;

  r = xor_mem_mem(p, q);
  r += xorb_mem(a, p);
  r += xorm_reg_mem_ret_mem(a, q);
  r += xor_memory_sources_live(p, q, a);
  return r;
}

Sint
xor3ct(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint r;

  r = xor_loop_sum(v, n, a);
  r += xorm_loop_sum(v, n, r);
  r += xor_branch_nonzero(r, a, n, a);
  return r;
}
