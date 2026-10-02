#include "insns.h"

/*
 * SETCM instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SETCM   AC <- ~E
 *   SETCMM  memory <- ~memory
 *   SETCMB  AC and memory both receive ~memory
 *
 * SETCMI is deliberately not treated as a primary target here; the
 * backend notes that SETCMI is done with ORCBI.  Keep constants only
 * as regression/normalization pressure.
 */

static Sint setcm_ga;
static Sint setcm_gb;
static uSint setcm_uga;
static Sint setcm_buf[16];

struct setcm_pair {
  Sint a;
  Sint b;
};

static struct setcm_pair setcm_gp;

static Sint
setcm_reg(y)
Sint y;
{
  return ~y;
}

static Sint
setcm_mem(x)
Sint *x;
{
  return ~*x;
}

static Sint
setcm_mem_plus(x, y)
Sint *x;
Sint y;
{
  return ~*x + y;
}

static Sint
setcm_mem_xor(x, y)
Sint *x;
Sint y;
{
  return ~*x ^ y;
}

static Sint
setcm_global_a(void)
{
  return ~setcm_ga;
}

static Sint
setcm_global_b(void)
{
  return ~setcm_gb;
}

static Sint
setcm_array(v, i)
Sint *v;
Sint i;
{
  return ~v[i & 017];
}

static Sint
setcm_global_array(i)
Sint i;
{
  return ~setcm_buf[i & 017];
}

static Sint
setcm_struct_a(p)
struct setcm_pair *p;
{
  return ~p->a;
}

static Sint
setcm_struct_b(p)
struct setcm_pair *p;
{
  return ~p->b;
}

static Sint
setcm_global_struct_a(void)
{
  return ~setcm_gp.a;
}

static Sint
setcm_global_struct_b(void)
{
  return ~setcm_gp.b;
}

static Sint
setcm_indirect(pp)
Sint **pp;
{
  return ~**pp;
}

static Sint
setcm_volatile_mem(x)
volatile Sint *x;
{
  return ~*x;
}

static Sint
setcm_const_zero(void)
{
  return ~0;
}

static Sint
setcm_const_one(void)
{
  return ~1;
}

static Sint
setcm_const_small(void)
{
  return ~0123456;
}

static Sint
setcm_const_low9(void)
{
  return ~0777;
}

static Sint
setcm_const_low18(void)
{
  return ~0777777;
}

static Sint
setcm_const_literal(void)
{
  return ~0123456123456;
}

static Sint
setcm_const_left_half(void)
{
  return ~0777777000000;
}

static Sint
setcm_const_right_half(void)
{
  return ~0000000777777;
}

static Sint
setcm_const_sign_bit(void)
{
  return ~0400000000000;
}

static void
setcmm_mem(x)
Sint *x;
{
  *x = ~*x;
}

static void
setcmm_global_a(void)
{
  setcm_ga = ~setcm_ga;
}

static void
setcmm_global_b(void)
{
  setcm_gb = ~setcm_gb;
}

static void
setcmm_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = ~v[i & 017];
}

static void
setcmm_global_array(i)
Sint i;
{
  setcm_buf[i & 017] = ~setcm_buf[i & 017];
}

static void
setcmm_struct_a(p)
struct setcm_pair *p;
{
  p->a = ~p->a;
}

static void
setcmm_struct_b(p)
struct setcm_pair *p;
{
  p->b = ~p->b;
}

static void
setcmm_indirect(pp)
Sint **pp;
{
  **pp = ~**pp;
}

static void
setcmm_volatile_mem(x)
volatile Sint *x;
{
  *x = ~*x;
}

static Sint
setcmm_return_mem(x)
Sint *x;
{
  *x = ~*x;
  return *x;
}

static Sint
setcmm_return_global(void)
{
  setcm_ga = ~setcm_ga;
  return setcm_ga;
}

static Sint
setcmm_return_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = ~v[i & 017];
  return v[i & 017];
}

static Sint
setcmm_return_struct_a(p)
struct setcm_pair *p;
{
  p->a = ~p->a;
  return p->a;
}

static Sint
setcmm_return_struct_b(p)
struct setcm_pair *p;
{
  p->b = ~p->b;
  return p->b;
}

static uSint
usetcm_reg(y)
uSint y;
{
  return ~y;
}

static uSint
usetcm_mem(x)
uSint *x;
{
  return ~*x;
}

static uSint
usetcm_global(void)
{
  return ~setcm_uga;
}

static void
usetcmm_mem(x)
uSint *x;
{
  *x = ~*x;
}

static void
usetcmm_global(void)
{
  setcm_uga = ~setcm_uga;
}

static uSint
usetcmb_return(x)
uSint *x;
{
  *x = ~*x;
  return *x;
}

static Sint
setcm_qi(a)
sQint a;
{
  return ~a;
}

static Sint
setcm_uqi(a)
uQint a;
{
  return ~a;
}

static Sint
setcm_hi(a)
Hint a;
{
  return ~a;
}

static Sint
setcm_uhi(a)
uHint a;
{
  return ~a;
}

static Sint
setcm_qi_mem(a)
sQint *a;
{
  return ~*a;
}

static Sint
setcm_uqi_mem(a)
uQint *a;
{
  return ~*a;
}

static Sint
setcm_hi_mem(a)
Hint *a;
{
  return ~*a;
}

static Sint
setcm_uhi_mem(a)
uHint *a;
{
  return ~*a;
}

static void
setcmm_qi_mem(a)
sQint *a;
{
  *a = ~*a;
}

static void
setcmm_uqi_mem(a)
uQint *a;
{
  *a = ~*a;
}

static void
setcmm_hi_mem(a)
Hint *a;
{
  *a = ~*a;
}

static void
setcmm_uhi_mem(a)
uHint *a;
{
  *a = ~*a;
}

static Sint
setcm_chain(a, b)
Sint a;
Sint b;
{
  a = ~a;
  b = ~b;
  return a ^ b;
}

static Sint
setcm_double(a)
Sint a;
{
  return ~~a;
}

static Sint
setcm_mixed_mem_reg(x, a)
Sint *x;
Sint a;
{
  return ~*x + ~a;
}

static void
setcmm_two(x, y)
Sint *x;
Sint *y;
{
  *x = ~*x;
  *y = ~*y;
}

BOTH (setcmb_mem, ~*b)
BOTH1 (uSint, usetcmb_mem, ~*b)
