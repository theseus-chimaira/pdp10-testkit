#include "insns.h"

/*
 * XOR instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   XOR   AC <- AC ^ E
 *   XORI  AC <- AC ^ immediate
 *   XORM  memory <- AC ^ memory
 *   XORB  AC and memory both receive AC ^ memory
 *
 * TLC.c covers the special left-half immediate XOR form.  This file
 * keeps ordinary register/memory/full-word XOR pressure here.
 */

static Sint xor_ga;
static Sint xor_gb;
static uSint xor_uga;
static Sint xor_buf[16];
static uSint xor_ubuf[16];

struct xor_pair {
  Sint a;
  Sint b;
};

struct xor_upair {
  uSint a;
  uSint b;
};

static struct xor_pair xor_gp;
static struct xor_upair xor_ugp;

static Sint
xor_reg_reg(a, e)
Sint a;
Sint e;
{
  return a ^ e;
}

static Sint
xor_reg_mem(a, e)
Sint a;
Sint *e;
{
  return a ^ *e;
}

static Sint
xor_mem_reg(e, a)
Sint *e;
Sint a;
{
  return *e ^ a;
}

static Sint
xor_mem_mem(a, e)
Sint *a;
Sint *e;
{
  return *a ^ *e;
}

static Sint
xor_global_a(a)
Sint a;
{
  return a ^ xor_ga;
}

static Sint
xor_global_b(void)
{
  return xor_ga ^ xor_gb;
}

static Sint
xor_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return a ^ v[i & 017];
}

static Sint
xor_global_array(i, a)
Sint i;
Sint a;
{
  return a ^ xor_buf[i & 017];
}

static Sint
xor_struct_a(p, a)
struct xor_pair *p;
Sint a;
{
  return a ^ p->a;
}

static Sint
xor_struct_b(p, a)
struct xor_pair *p;
Sint a;
{
  return a ^ p->b;
}

static Sint
xor_global_struct_a(a)
Sint a;
{
  return a ^ xor_gp.a;
}

static Sint
xor_global_struct_b(a)
Sint a;
{
  return a ^ xor_gp.b;
}

static Sint
xor_indirect(pp, a)
Sint **pp;
Sint a;
{
  return a ^ **pp;
}

static Sint
xor_volatile(a, e)
Sint a;
volatile Sint *e;
{
  return a ^ *e;
}

static Sint
xori_one(a)
Sint a;
{
  return a ^ 1;
}

static Sint
xori_small(a)
Sint a;
{
  return a ^ 0123456;
}

static Sint
xori_low9(a)
Sint a;
{
  return a ^ 0777;
}

static Sint
xori_low18(a)
Sint a;
{
  return a ^ 0777777;
}

static Sint
xor_literal(a)
Sint a;
{
  return a ^ 0123456123456;
}

static Sint
xor_literal_alt(a)
Sint a;
{
  return a ^ 0525252252525;
}

static Sint
xor_literal_sparse(a)
Sint a;
{
  return a ^ 0707070070707;
}

static Sint
xor_literal_sign(a)
Sint a;
{
  return a ^ 0400000000000;
}

static Sint
xor_literal_all(a)
Sint a;
{
  return a ^ 0777777777777;
}

static Sint
xor_commuted_small(a)
Sint a;
{
  return 0123456 ^ a;
}

static Sint
xor_commuted_literal(a)
Sint a;
{
  return 0123456123456 ^ a;
}

static void
xorm_reg_mem(a, e)
Sint a;
Sint *e;
{
  *e ^= a;
}

static void
xorm_reg_mem_explicit(a, e)
Sint a;
Sint *e;
{
  *e = a ^ *e;
}

static void
xorm_global_a(a)
Sint a;
{
  xor_ga ^= a;
}

static void
xorm_global_b(a)
Sint a;
{
  xor_gb = a ^ xor_gb;
}

static void
xorm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] ^= a;
}

static void
xorm_global_array(i, a)
Sint i;
Sint a;
{
  xor_buf[i & 017] ^= a;
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
  p->b = a ^ p->b;
}

static void
xorm_global_struct_a(a)
Sint a;
{
  xor_gp.a ^= a;
}

static void
xorm_global_struct_b(a)
Sint a;
{
  xor_gp.b = a ^ xor_gp.b;
}

static void
xorm_indirect(pp, a)
Sint **pp;
Sint a;
{
  **pp ^= a;
}

static void
xorm_volatile(a, e)
Sint a;
volatile Sint *e;
{
  *e ^= a;
}

static void
xorm_const_small(e)
Sint *e;
{
  *e ^= 0123456;
}

static void
xorm_const_literal(e)
Sint *e;
{
  *e ^= 0123456123456;
}

static Sint
xorm_return_mem(a, e)
Sint a;
Sint *e;
{
  *e ^= a;
  return *e;
}

static Sint
xorm_return_global(a)
Sint a;
{
  xor_ga ^= a;
  return xor_ga;
}

static Sint
xorm_return_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] ^= a;
  return v[i & 017];
}

static Sint
xorm_return_struct_a(p, a)
struct xor_pair *p;
Sint a;
{
  p->a ^= a;
  return p->a;
}

static Sint
xorm_return_struct_b(p, a)
struct xor_pair *p;
Sint a;
{
  p->b ^= a;
  return p->b;
}

static Sint
xorb_mem_return(a, e)
Sint a;
Sint *e;
{
  *e = a ^ *e;
  return *e;
}

static Sint
xorb_global_return(a)
Sint a;
{
  xor_ga = a ^ xor_ga;
  return xor_ga;
}

static Sint
xorb_array_return(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] = a ^ v[i & 017];
  return v[i & 017];
}

static Sint
xorb_struct_a_return(p, a)
struct xor_pair *p;
Sint a;
{
  p->a = a ^ p->a;
  return p->a;
}

static Sint
xorb_struct_b_return(p, a)
struct xor_pair *p;
Sint a;
{
  p->b = a ^ p->b;
  return p->b;
}

static uSint
uxor_reg_reg(a, e)
uSint a;
uSint e;
{
  return a ^ e;
}

static uSint
uxor_reg_mem(a, e)
uSint a;
uSint *e;
{
  return a ^ *e;
}

static uSint
uxor_global(a)
uSint a;
{
  return a ^ xor_uga;
}

static uSint
uxor_array(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  return a ^ v[i & 017];
}

static uSint
uxori_small(a)
uSint a;
{
  return a ^ 0123456;
}

static uSint
uxori_low18(a)
uSint a;
{
  return a ^ 0777777;
}

static uSint
uxor_literal(a)
uSint a;
{
  return a ^ 0123456123456;
}

static uSint
uxor_literal_all(a)
uSint a;
{
  return a ^ 0777777777777;
}

static void
uxorm_mem(a, e)
uSint a;
uSint *e;
{
  *e ^= a;
}

static void
uxorm_global(a)
uSint a;
{
  xor_uga ^= a;
}

static void
uxorm_array(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  v[i & 017] ^= a;
}

static uSint
uxorb_mem_return(a, e)
uSint a;
uSint *e;
{
  *e = a ^ *e;
  return *e;
}

static uSint
uxorb_global_return(a)
uSint a;
{
  xor_uga = a ^ xor_uga;
  return xor_uga;
}

static Sint
xor_qi(a, b)
sQint a;
sQint b;
{
  return a ^ b;
}

static Sint
xor_uqi(a, b)
uQint a;
uQint b;
{
  return a ^ b;
}

static Sint
xor_hi(a, b)
Hint a;
Hint b;
{
  return a ^ b;
}

static Sint
xor_uhi(a, b)
uHint a;
uHint b;
{
  return a ^ b;
}

static Sint
xor_qi_mem(a, b)
sQint a;
sQint *b;
{
  return a ^ *b;
}

static Sint
xor_uqi_mem(a, b)
uQint a;
uQint *b;
{
  return a ^ *b;
}

static Sint
xor_hi_mem(a, b)
Hint a;
Hint *b;
{
  return a ^ *b;
}

static Sint
xor_uhi_mem(a, b)
uHint a;
uHint *b;
{
  return a ^ *b;
}

static void
xorm_qi(a, b)
sQint a;
sQint *b;
{
  *b ^= a;
}

static void
xorm_uqi(a, b)
uQint a;
uQint *b;
{
  *b ^= a;
}

static void
xorm_hi(a, b)
Hint a;
Hint *b;
{
  *b ^= a;
}

static void
xorm_uhi(a, b)
uHint a;
uHint *b;
{
  *b ^= a;
}

static Sint
xor_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a ^ b) ^ c;
}

static Sint
xor_chain_mem(a, b, c)
Sint a;
Sint *b;
Sint *c;
{
  return (a ^ *b) ^ *c;
}

static Sint
xor_self(a)
Sint a;
{
  return a ^ a;
}

static Sint
xor_store_then_use(a, b, p)
Sint a;
Sint b;
Sint *p;
{
  Sint t;

  t = a ^ b;
  *p = t;
  return t ^ a;
}

BOTH (xorb_reg_mem, a ^ *b)
BOTH (xorb_mem_reg, *b ^ a)
BOTH1 (uSint, uxorb_reg_mem, a ^ *b)
