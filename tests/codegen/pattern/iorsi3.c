#include "insns.h"

/*
 * iorsi3 pattern coverage for PDP-6/166 and KA10.
 *
 * Pattern-level coverage for IOR:SI, not a duplicate of the full OR
 * instruction-family test.
 *
 * Intended source shapes:
 *
 *   reg = reg | reg
 *   reg = reg | mem
 *   reg = reg | small right-half constant       ORI
 *   reg = reg | left-half constant              TLO-style
 *   reg = reg | ~small constant                 ORCMI-style
 *   reg = reg | large literal                   OR literal
 *   mem = mem | reg                             IORM-style
 *   mem = mem | constant                        expander/reload path
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint iorsi3_ga;
static Sint iorsi3_gb;
static uSint iorsi3_uga;
static Sint iorsi3_buf[16];
static uSint iorsi3_ubuf[16];

struct iorsi3_pair {
  Sint a;
  Sint b;
};

struct iorsi3_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct iorsi3_pair iorsi3_gp;
static struct iorsi3_three iorsi3_gt;

static Sint
ior_reg_reg(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return a | e;
}

static uSint
uior_reg_reg(a, e)
uSint a;
uSint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return a | e;
}

static Sint
ior_reg_mem(a, e)
Sint a;
Sint *e;
{
  OPAQUE_REG(a);
  return a | *e;
}

static Sint
ior_mem_reg(e, a)
Sint *e;
Sint a;
{
  OPAQUE_REG(a);
  return *e | a;
}

static Sint
ior_mem_mem(a, e)
Sint *a;
Sint *e;
{
  Sint x;
  Sint y;

  x = *a;
  y = *e;
  return x | y;
}

static uSint
uior_reg_mem(a, e)
uSint a;
uSint *e;
{
  OPAQUE_REG(a);
  return a | *e;
}

static Sint
ior_volatile_mem(a, e)
Sint a;
volatile Sint *e;
{
  OPAQUE_REG(a);
  return a | *e;
}

static Sint
ior_global_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  return iorsi3_ga | a;
}

static Sint
ior_reg_global(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | iorsi3_gb;
}

static uSint
uior_global_reg(a)
uSint a;
{
  OPAQUE_REG(a);
  return iorsi3_uga | a;
}

static Sint
ior_array_reg(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  return v[i & 017] | a;
}

static Sint
ior_reg_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  OPAQUE_REG(a);
  return a | v[i & 017];
}

static uSint
uior_array_reg(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  OPAQUE_REG(a);
  return v[i & 017] | a;
}

static Sint
ior_global_array(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  return iorsi3_buf[i & 017] | a;
}

static Sint
ior_struct_a(p, a)
struct iorsi3_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  return p->a | a;
}

static Sint
ior_struct_b(p, a)
struct iorsi3_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  return a | p->b;
}

static Sint
ior_global_struct(a)
Sint a;
{
  OPAQUE_REG(a);
  return iorsi3_gp.a | a;
}

static Sint
iori_zero(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0;
}

static Sint
iori_one(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 1;
}

static Sint
iori_small(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0123456;
}

static Sint
iori_low9(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0777;
}

static Sint
iori_low18(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0777777;
}

static uSint
uiori_low18(a)
uSint a;
{
  OPAQUE_REG(a);
  return a | 0777777;
}

/*
 * Left-half set forms.  These should give the backend a chance to use
 * TLO-style patterns.
 */

static Sint
tlo_small(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0123456000000;
}

static Sint
tlo_one_left_bit(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0400000000000;
}

static Sint
tlo_many_left_bits(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0525252000000;
}

static Sint
tlo_all_left(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0777777000000;
}

static Sint
tlo_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return x | 0123456000000;
}

/*
 * Complement-immediate forms.  These are ORs with complement constants,
 * giving the backend a chance to use ORCMI-style patterns.
 */

static Sint
orcmi_small(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | ~0123456;
}

static Sint
orcmi_one(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | ~1;
}

static Sint
orcmi_low9(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | ~0777;
}

static Sint
orcmi_low18(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | ~0777777;
}

static uSint
uorcmi_low18(a)
uSint a;
{
  OPAQUE_REG(a);
  return a | ~0777777;
}

static Sint
orcmi_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  OPAQUE_REG(x);
  return x | ~0123456;
}

/*
 * Literal constants not reducible to the simple right-half immediate,
 * TLO, or ORCMI shapes.
 */

static Sint
ior_large_literal(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0123456123456;
}

static Sint
ior_large_literal_left(a)
Sint a;
{
  OPAQUE_REG(a);
  return 0123456123456 | a;
}

static Sint
ior_sparse_literal(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0525252252525;
}

static Sint
ior_left_half_only(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0777777000000;
}

static Sint
ior_right_half_only(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0000000777777;
}

static Sint
ior_sign_bit(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0400000000000;
}

static uSint
uior_large_literal(a)
uSint a;
{
  OPAQUE_REG(a);
  return a | 0123456123456;
}

static Sint
ior_const_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  OPAQUE_REG(x);
  return x | 0123456123456;
}

static Sint
ior_qi_promote(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x | y;
}

static uSint
ior_uqi_promote(a, b)
uQint a;
uQint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x | y;
}

static Sint
ior_hi_promote(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x | y;
}

static uSint
ior_uhi_promote(a, b)
uHint a;
uHint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x | y;
}

static Sint
ior_qi_mem(p, a)
sQint *p;
Sint a;
{
  OPAQUE_REG(a);
  return *p | a;
}

static uSint
ior_uqi_mem(p, a)
uQint *p;
uSint a;
{
  OPAQUE_REG(a);
  return *p | a;
}

static Sint
ior_hi_mem(p, a)
Hint *p;
Sint a;
{
  OPAQUE_REG(a);
  return *p | a;
}

static uSint
ior_uhi_mem(p, a)
uHint *p;
uSint a;
{
  OPAQUE_REG(a);
  return *p | a;
}

/*
 * Memory destination forms.
 */

static void
iorm_reg(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = *p | a;
}

static void
iorm_reg_alt(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = a | *p;
}

static Sint
iorm_reg_ret(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = *p | a;
  return *p;
}

static Sint
iorm_reg_ret_alt(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = a | *p;
  return *p;
}

static void
iorm_mem(p, q)
Sint *p;
Sint *q;
{
  *p = *p | *q;
}

static Sint
iorm_mem_ret(p, q)
Sint *p;
Sint *q;
{
  *p = *p | *q;
  return *p;
}

static void
iorm_global(a)
Sint a;
{
  OPAQUE_REG(a);
  iorsi3_ga = iorsi3_ga | a;
}

static Sint
iorm_global_ret(a)
Sint a;
{
  OPAQUE_REG(a);
  iorsi3_ga = iorsi3_ga | a;
  return iorsi3_ga;
}

static void
iorm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  v[i & 017] = v[i & 017] | a;
}

static Sint
iorm_array_ret(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  v[i & 017] = v[i & 017] | a;
  return v[i & 017];
}

static void
iorm_global_array(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  iorsi3_buf[i & 017] = iorsi3_buf[i & 017] | a;
}

static Sint
iorm_struct_a(p, a)
struct iorsi3_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->a = p->a | a;
  return p->a;
}

static Sint
iorm_struct_b(p, a)
struct iorsi3_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->b = a | p->b;
  return p->b;
}

static Sint
iorm_global_struct(a)
Sint a;
{
  OPAQUE_REG(a);
  iorsi3_gp.b = iorsi3_gp.b | a;
  return iorsi3_gp.b;
}

static void
iorm_volatile(p, a)
volatile Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = *p | a;
}

static Sint
iorm_volatile_ret(p, a)
volatile Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = *p | a;
  return *p;
}

/*
 * Memory destination with constants.  These stress expander/reload
 * handling for memory/immediate shapes.
 */

static void
iorm_const_small(p)
Sint *p;
{
  *p = *p | 0123456;
}

static Sint
iorm_const_small_ret(p)
Sint *p;
{
  *p = *p | 0123456;
  return *p;
}

static void
iorm_const_low18(p)
Sint *p;
{
  *p = *p | 0777777;
}

static Sint
iorm_const_low18_ret(p)
Sint *p;
{
  *p = *p | 0777777;
  return *p;
}

static void
iorm_const_tlo(p)
Sint *p;
{
  *p = *p | 0123456000000;
}

static Sint
iorm_const_tlo_ret(p)
Sint *p;
{
  *p = *p | 0123456000000;
  return *p;
}

static void
iorm_const_orcmi(p)
Sint *p;
{
  *p = *p | ~0123456;
}

static Sint
iorm_const_orcmi_ret(p)
Sint *p;
{
  *p = *p | ~0123456;
  return *p;
}

static void
iorm_const_large(p)
Sint *p;
{
  *p = *p | 0123456123456;
}

static Sint
iorm_const_large_ret(p)
Sint *p;
{
  *p = *p | 0123456123456;
  return *p;
}

static void
iorm_const_zero(p)
Sint *p;
{
  *p = *p | 0;
}

static Sint
iorm_const_zero_ret(p)
Sint *p;
{
  *p = *p | 0;
  return *p;
}

static void
iorm_const_ones(p)
Sint *p;
{
  *p = *p | 0777777777777;
}

static Sint
iorm_const_ones_ret(p)
Sint *p;
{
  *p = *p | 0777777777777;
  return *p;
}

/*
 * Register-derived mask forms.
 */

static Sint
ior_reg_mask_right(a, mask)
Sint a;
Sint mask;
{
  Sint x;

  x = mask & 0777777;
  OPAQUE_REG(a);
  OPAQUE_REG(x);
  return a | x;
}

static Sint
ior_reg_mask_left(a, mask)
Sint a;
Sint mask;
{
  Sint x;

  x = (mask & 0777777) << 18;
  OPAQUE_REG(a);
  OPAQUE_REG(x);
  return a | x;
}

static Sint
ior_reg_mask_orcmi(a, mask)
Sint a;
Sint mask;
{
  Sint x;

  x = ~(mask & 0777777);
  OPAQUE_REG(a);
  OPAQUE_REG(x);
  return a | x;
}

static Sint
ior_nested1(a, b, c)
Sint a;
Sint b;
Sint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  return (a | b) | c;
}

static Sint
ior_nested_const(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return (x | 0123456) | b;
}

static Sint
ior_nested_large_const(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  OPAQUE_REG(x);
  return (x | 0123456123456) | a;
}

static Sint
ior_store_then_use(p, a)
Sint *p;
Sint a;
{
  Sint r;

  OPAQUE_REG(a);
  r = *p | a;
  *p = r;
  return r | a;
}

static Sint
ior_call_pressure(a, b)
Sint a;
Sint b;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  r = a | b;
  clobber();
  return r | a;
}

static Sint
ior_mem_call_pressure(p, a)
Sint *p;
Sint a;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(a);
  r = *p | a;
  clobber();
  return r | *p;
}

static Sint
ior_loop_sum(v, n, mask)
Sint *v;
Sint n;
Sint mask;
{
  Sint i;
  Sint r;

  OPAQUE_REG(mask);
  r = 0;

  for (i = 0; i < n; ++i)
    r += v[i & 017] | mask;

  return r;
}

static void
ior_loop_update(v, n, mask)
Sint *v;
Sint n;
Sint mask;
{
  Sint i;

  OPAQUE_REG(mask);

  for (i = 0; i < n; ++i)
    v[i & 017] = v[i & 017] | mask;
}

static Sint
ior_loop_update_sum(v, n, mask)
Sint *v;
Sint n;
Sint mask;
{
  Sint i;
  Sint r;

  OPAQUE_REG(mask);
  r = 0;

  for (i = 0; i < n; ++i) {
    v[i & 017] = v[i & 017] | mask;
    r += v[i & 017];
  }

  return r;
}

static Sint
ior_branch_zero(a)
Sint a;
{
  OPAQUE_REG(a);
  if ((a | 0123456) == 0)
    return 1;
  return 0;
}

static Sint
ior_branch_nonzero(a)
Sint a;
{
  OPAQUE_REG(a);
  if ((a | 0123456) != 0)
    return a;
  return 0;
}

static Sint
ior_branch_sign(a)
Sint a;
{
  OPAQUE_REG(a);
  if ((a | 0400000000000) < 0)
    return -1;
  return 0;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
ior1(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return a | e;
}

static Sint
ior2(a, e)
Sint a;
Sint *e;
{
  OPAQUE_REG(a);
  return a | *e;
}

static Sint
iori(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0123456;
}

static Sint
tlo(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0123456000000;
}

static Sint
orcmi(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | ~0123456;
}

static Sint
ior3(a)
Sint a;
{
  OPAQUE_REG(a);
  return a | 0123456123456;
}

static Sint
iorm(a, e)
Sint a;
Sint *e;
{
  OPAQUE_REG(a);
  *e = *e | a;
  return *e;
}
