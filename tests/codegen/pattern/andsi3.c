#include "insns.h"

/*
 * andsi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is pattern-level coverage for AND:SI, not a duplicate of
 * insn/AND.c.  Keep it centered on:
 *
 *   reg = reg & reg
 *   reg = reg & mem
 *   reg = mem & reg
 *   reg = reg & small right-half constant       ANDI
 *   reg = reg & left-half-preserving constant   TLZ-style clear
 *   reg = reg & ~small constant                 ANDCMI-style clear
 *   reg = reg & large literal                   AND literal
 *   mem = reg & mem                             ANDM-style
 *   mem = mem & constant                        expander/reload path
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint andsi3_ga;
static Sint andsi3_gb;
static uSint andsi3_uga;
static Sint andsi3_buf[16];
static uSint andsi3_ubuf[16];

struct andsi3_pair {
  Sint a;
  Sint b;
};

struct andsi3_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct andsi3_pair andsi3_gp;
static struct andsi3_three andsi3_gt;

static Sint
and_reg_reg(ac, y)
Sint ac;
Sint y;
{
  OPAQUE_REG(ac);
  OPAQUE_REG(y);
  return ac & y;
}

static uSint
uand_reg_reg(ac, y)
uSint ac;
uSint y;
{
  OPAQUE_REG(ac);
  OPAQUE_REG(y);
  return ac & y;
}

static Sint
and_reg_mem(ac, x)
Sint ac;
Sint *x;
{
  OPAQUE_REG(ac);
  return ac & *x;
}

static Sint
and_mem_reg(x, ac)
Sint *x;
Sint ac;
{
  OPAQUE_REG(ac);
  return *x & ac;
}

static Sint
and_mem_mem(x, y)
Sint *x;
Sint *y;
{
  Sint a;
  Sint b;

  a = *x;
  b = *y;
  return a & b;
}

static uSint
uand_reg_mem(ac, x)
uSint ac;
uSint *x;
{
  OPAQUE_REG(ac);
  return ac & *x;
}

static Sint
and_volatile_mem(ac, x)
Sint ac;
volatile Sint *x;
{
  OPAQUE_REG(ac);
  return ac & *x;
}

static Sint
and_global_reg(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return andsi3_ga & ac;
}

static Sint
and_reg_global(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & andsi3_gb;
}

static uSint
uand_global_reg(ac)
uSint ac;
{
  OPAQUE_REG(ac);
  return andsi3_uga & ac;
}

static Sint
and_array_reg(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  OPAQUE_REG(ac);
  return v[i & 017] & ac;
}

static Sint
and_reg_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  OPAQUE_REG(ac);
  return ac & v[i & 017];
}

static uSint
uand_array_reg(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  OPAQUE_REG(ac);
  return v[i & 017] & ac;
}

static Sint
and_global_array(i, ac)
Sint i;
Sint ac;
{
  OPAQUE_REG(ac);
  return andsi3_buf[i & 017] & ac;
}

static Sint
and_struct_a(p, ac)
struct andsi3_pair *p;
Sint ac;
{
  OPAQUE_REG(ac);
  return p->a & ac;
}

static Sint
and_struct_b(p, ac)
struct andsi3_pair *p;
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & p->b;
}

static Sint
and_global_struct(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return andsi3_gp.a & ac;
}

static Sint
andi_zero(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0;
}

static Sint
andi_one(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 1;
}

static Sint
andi_small(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456;
}

static Sint
andi_low9(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0777;
}

static Sint
andi_low18(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0777777;
}

static uSint
uandi_low18(ac)
uSint ac;
{
  OPAQUE_REG(ac);
  return ac & 0777777;
}

/*
 * Left-half clear forms.  These are source-level ANDs with constants
 * whose right half is all ones, giving the backend a chance to use
 * TLZ-style patterns.
 */

static Sint
tlz_small(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456777777;
}

static Sint
tlz_zero_left(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0000000777777;
}

static Sint
tlz_clear_one_left_bit(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0377777777777;
}

static Sint
tlz_clear_many_left_bits(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0525252777777;
}

static Sint
tlz_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return x & 0123456777777;
}

/*
 * Right-half clear forms.  These are source-level ANDs with complement
 * constants, giving the backend a chance to use ANDCMI-style patterns.
 */

static Sint
andcmi_small(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & ~0123456;
}

static Sint
andcmi_one(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & ~1;
}

static Sint
andcmi_low9(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & ~0777;
}

static Sint
andcmi_low18(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & ~0777777;
}

static uSint
uandcmi_low18(ac)
uSint ac;
{
  OPAQUE_REG(ac);
  return ac & ~0777777;
}

static Sint
andcmi_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a | b;
  OPAQUE_REG(x);
  return x & ~0123456;
}

/*
 * Literal constants not encodable as the simple right-half immediate
 * or TLZ/ANDCMI-style special cases.
 */

static Sint
and_large_literal(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456123456;
}

static Sint
and_large_literal_left(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return 0123456123456 & ac;
}

static Sint
and_sparse_literal(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0525252252525;
}

static Sint
and_left_half_only(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0777777000000;
}

static Sint
and_right_half_only(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0000000777777;
}

static Sint
and_sign_bit(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0400000000000;
}

static uSint
uand_large_literal(ac)
uSint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456123456;
}

static Sint
and_const_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  OPAQUE_REG(x);
  return x & 0123456123456;
}

static Sint
and_qi_promote(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x & y;
}

static uSint
and_uqi_promote(a, b)
uQint a;
uQint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x & y;
}

static Sint
and_hi_promote(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x & y;
}

static uSint
and_uhi_promote(a, b)
uHint a;
uHint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x & y;
}

static Sint
and_qi_mem(p, ac)
sQint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  return *p & ac;
}

static uSint
and_uqi_mem(p, ac)
uQint *p;
uSint ac;
{
  OPAQUE_REG(ac);
  return *p & ac;
}

static Sint
and_hi_mem(p, ac)
Hint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  return *p & ac;
}

static uSint
and_uhi_mem(p, ac)
uHint *p;
uSint ac;
{
  OPAQUE_REG(ac);
  return *p & ac;
}

/*
 * Memory destination forms.
 */

static void
andm_reg(p, ac)
Sint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  *p = ac & *p;
}

static void
andm_reg_alt(p, ac)
Sint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  *p = *p & ac;
}

static Sint
andm_reg_ret(p, ac)
Sint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  *p = ac & *p;
  return *p;
}

static Sint
andm_reg_ret_alt(p, ac)
Sint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  *p = *p & ac;
  return *p;
}

static void
andm_mem(p, q)
Sint *p;
Sint *q;
{
  *p = *p & *q;
}

static Sint
andm_mem_ret(p, q)
Sint *p;
Sint *q;
{
  *p = *p & *q;
  return *p;
}

static void
andm_global(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  andsi3_ga = andsi3_ga & ac;
}

static Sint
andm_global_ret(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  andsi3_ga = andsi3_ga & ac;
  return andsi3_ga;
}

static void
andm_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  OPAQUE_REG(ac);
  v[i & 017] = v[i & 017] & ac;
}

static Sint
andm_array_ret(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  OPAQUE_REG(ac);
  v[i & 017] = v[i & 017] & ac;
  return v[i & 017];
}

static void
andm_global_array(i, ac)
Sint i;
Sint ac;
{
  OPAQUE_REG(ac);
  andsi3_buf[i & 017] = andsi3_buf[i & 017] & ac;
}

static Sint
andm_struct_a(p, ac)
struct andsi3_pair *p;
Sint ac;
{
  OPAQUE_REG(ac);
  p->a = p->a & ac;
  return p->a;
}

static Sint
andm_struct_b(p, ac)
struct andsi3_pair *p;
Sint ac;
{
  OPAQUE_REG(ac);
  p->b = ac & p->b;
  return p->b;
}

static Sint
andm_global_struct(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  andsi3_gp.b = andsi3_gp.b & ac;
  return andsi3_gp.b;
}

static void
andm_volatile(p, ac)
volatile Sint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  *p = *p & ac;
}

static Sint
andm_volatile_ret(p, ac)
volatile Sint *p;
Sint ac;
{
  OPAQUE_REG(ac);
  *p = *p & ac;
  return *p;
}

/*
 * Memory destination with constants.  These stress the expander/reload
 * path.  If the destination is memory and the constant is not a simple
 * legal alternative, the backend should force the constant through a
 * register rather than making an invalid memory/immediate operation.
 */

static void
andm_const_small(p)
Sint *p;
{
  *p = *p & 0123456;
}

static Sint
andm_const_small_ret(p)
Sint *p;
{
  *p = *p & 0123456;
  return *p;
}

static void
andm_const_low18(p)
Sint *p;
{
  *p = *p & 0777777;
}

static Sint
andm_const_low18_ret(p)
Sint *p;
{
  *p = *p & 0777777;
  return *p;
}

static void
andm_const_tlz(p)
Sint *p;
{
  *p = *p & 0123456777777;
}

static Sint
andm_const_tlz_ret(p)
Sint *p;
{
  *p = *p & 0123456777777;
  return *p;
}

static void
andm_const_andcmi(p)
Sint *p;
{
  *p = *p & ~0123456;
}

static Sint
andm_const_andcmi_ret(p)
Sint *p;
{
  *p = *p & ~0123456;
  return *p;
}

static void
andm_const_large(p)
Sint *p;
{
  *p = *p & 0123456123456;
}

static Sint
andm_const_large_ret(p)
Sint *p;
{
  *p = *p & 0123456123456;
  return *p;
}

static void
andm_const_zero(p)
Sint *p;
{
  *p = *p & 0;
}

static Sint
andm_const_zero_ret(p)
Sint *p;
{
  *p = *p & 0;
  return *p;
}

static void
andm_const_ones(p)
Sint *p;
{
  *p = *p & 0777777777777;
}

static Sint
andm_const_ones_ret(p)
Sint *p;
{
  *p = *p & 0777777777777;
  return *p;
}

/*
 * Register-derived mask forms.  These give combine chances for
 * immediate-like special cases without making everything a literal.
 */

static Sint
and_reg_mask_right(ac, mask)
Sint ac;
Sint mask;
{
  Sint x;

  x = mask & 0777777;
  OPAQUE_REG(ac);
  OPAQUE_REG(x);
  return ac & x;
}

static Sint
and_reg_mask_left_clear(ac, mask)
Sint ac;
Sint mask;
{
  Sint x;

  x = (mask & 0777777) | 0000000777777;
  OPAQUE_REG(ac);
  OPAQUE_REG(x);
  return ac & x;
}

static Sint
and_reg_mask_clear_low(ac, mask)
Sint ac;
Sint mask;
{
  Sint x;

  x = ~(mask & 0777777);
  OPAQUE_REG(ac);
  OPAQUE_REG(x);
  return ac & x;
}

static Sint
and_shifted_mask(ac, mask)
Sint ac;
Sint mask;
{
  Sint x;

  x = (mask & 0777777) << 18;
  OPAQUE_REG(ac);
  OPAQUE_REG(x);
  return ac & x;
}

static Sint
and_nested1(a, b, c)
Sint a;
Sint b;
Sint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  return (a & b) & c;
}

static Sint
and_nested_const(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return (x & 0123456) & b;
}

static Sint
and_nested_large_const(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a | b;
  OPAQUE_REG(x);
  return (x & 0123456123456) & a;
}

static Sint
and_store_then_use(p, ac)
Sint *p;
Sint ac;
{
  Sint r;

  OPAQUE_REG(ac);
  r = *p & ac;
  *p = r;
  return r & ac;
}

static Sint
and_call_pressure(a, b)
Sint a;
Sint b;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  r = a & b;
  clobber();
  return r & a;
}

static Sint
and_mem_call_pressure(p, ac)
Sint *p;
Sint ac;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(ac);
  r = *p & ac;
  clobber();
  return r & *p;
}

static Sint
and_loop_sum(v, n, mask)
Sint *v;
Sint n;
Sint mask;
{
  Sint i;
  Sint r;

  OPAQUE_REG(mask);
  r = 0;

  for (i = 0; i < n; ++i)
    r += v[i & 017] & mask;

  return r;
}

static void
and_loop_update(v, n, mask)
Sint *v;
Sint n;
Sint mask;
{
  Sint i;

  OPAQUE_REG(mask);

  for (i = 0; i < n; ++i)
    v[i & 017] = v[i & 017] & mask;
}

static Sint
and_loop_update_sum(v, n, mask)
Sint *v;
Sint n;
Sint mask;
{
  Sint i;
  Sint r;

  OPAQUE_REG(mask);
  r = 0;

  for (i = 0; i < n; ++i) {
    v[i & 017] = v[i & 017] & mask;
    r += v[i & 017];
  }

  return r;
}

static Sint
and_branch_zero(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  if ((ac & 0123456) == 0)
    return 1;
  return 0;
}

static Sint
and_branch_nonzero(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  if ((ac & 0123456) != 0)
    return ac;
  return 0;
}

static Sint
and_branch_sign(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  if ((ac & 0400000000000) != 0)
    return -1;
  return 0;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
and1(ac, y)
Sint ac;
Sint y;
{
  OPAQUE_REG(ac);
  OPAQUE_REG(y);
  return ac & y;
}

static Sint
and2(ac, x)
Sint ac;
Sint *x;
{
  OPAQUE_REG(ac);
  return ac & *x;
}

static Sint
andi(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456;
}

static Sint
tlz(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456777777;
}

static Sint
andcmi(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & ~0123456;
}

static Sint
and3(ac)
Sint ac;
{
  OPAQUE_REG(ac);
  return ac & 0123456123456;
}

static Sint
andm(ac, x)
Sint ac;
Sint *x;
{
  OPAQUE_REG(ac);
  *x = ac & *x;
  return *x;
}
