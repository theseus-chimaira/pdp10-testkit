#include "insns.h"

/*
 * ORCM instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ORCM   AC <- AC | ~E
 *   ORCMI  AC <- AC | ~immediate
 *   ORCMM  memory <- AC | ~memory
 *   ORCMB  AC and memory both receive AC | ~memory
 *
 * Keep the expression centered on "a | ~x".  This is intentionally
 * different from ORCA, where the accumulator-like operand is
 * complemented.
 */

static Sint orcm_ga;
static Sint orcm_gb;
static Sint orcm_buf[16];

struct orcm_pair {
  Sint a;
  Sint b;
};

static struct orcm_pair orcm_gp;

static Sint
orcm_reg_reg(a, y)
Sint a;
Sint y;
{
  return a | ~y;
}

static Sint
orcm_reg_mem(a, y)
Sint a;
Sint *y;
{
  return a | ~*y;
}

static Sint
orcm_mem_reg(y, a)
Sint *y;
Sint a;
{
  return a | ~*y;
}

static Sint
orcm_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return *a | ~*y;
}

static Sint
orcm_commuted_reg_reg(a, y)
Sint a;
Sint y;
{
  return ~y | a;
}

static Sint
orcm_commuted_reg_mem(a, y)
Sint a;
Sint *y;
{
  return ~*y | a;
}

static Sint
orcm_global_a(a)
Sint a;
{
  return a | ~orcm_ga;
}

static Sint
orcm_global_b(void)
{
  return orcm_ga | ~orcm_gb;
}

static Sint
orcm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return a | ~v[i & 017];
}

static Sint
orcm_global_array(i, a)
Sint i;
Sint a;
{
  return a | ~orcm_buf[i & 017];
}

static Sint
orcm_struct_a(p, a)
struct orcm_pair *p;
Sint a;
{
  return a | ~p->a;
}

static Sint
orcm_struct_b(p, a)
struct orcm_pair *p;
Sint a;
{
  return a | ~p->b;
}

static Sint
orcm_global_struct_a(a)
Sint a;
{
  return a | ~orcm_gp.a;
}

static Sint
orcm_global_struct_b(a)
Sint a;
{
  return a | ~orcm_gp.b;
}

static Sint
orcmi_small(a)
Sint a;
{
  return a | ~0123456;
}

static Sint
orcmi_zero(a)
Sint a;
{
  return a | ~0;
}

static Sint
orcmi_one(a)
Sint a;
{
  return a | ~1;
}

static Sint
orcmi_low9(a)
Sint a;
{
  return a | ~0777;
}

static Sint
orcmi_low18(a)
Sint a;
{
  return a | ~0777777;
}

static Sint
orcm_literal(a)
Sint a;
{
  return a | ~0123456123456;
}

static Sint
orcm_literal_commuted(a)
Sint a;
{
  return ~0123456123456 | a;
}

static Sint
orcm_sparse(a)
Sint a;
{
  return a | ~0525252252525;
}

static Sint
orcm_left_half(a)
Sint a;
{
  return a | ~0777777000000;
}

static Sint
orcm_right_half(a)
Sint a;
{
  return a | ~0000000777777;
}

static Sint
orcm_high_ones_low_const(a)
Sint a;
{
  return a | ~0777777012345;
}

static Sint
orcm_low_ones_high_const(a)
Sint a;
{
  return a | ~0123456777777;
}

static Sint
orcm_sign_bit(a)
Sint a;
{
  return a | ~0400000000000;
}

static Sint
orcm_clear_sign_mask(a)
Sint a;
{
  return a | ~0377777777777;
}

static Sint
orcm_all_ones(a)
Sint a;
{
  return a | ~0777777777777;
}

static void
orcmm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = a | ~*y;
}

static void
orcmm_assign(a, y)
Sint a;
Sint *y;
{
  *y = a | ~*y;
}

static void
orcmm_const(y)
Sint *y;
{
  *y = 0123456 | ~*y;
}

static void
orcmm_global(a)
Sint a;
{
  orcm_ga = a | ~orcm_ga;
}

static void
orcmm_global_2(a)
Sint a;
{
  orcm_gb = ~orcm_gb | a;
}

static void
orcmm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] = a | ~v[i & 017];
}

static void
orcmm_global_array(i, a)
Sint i;
Sint a;
{
  orcm_buf[i & 017] = a | ~orcm_buf[i & 017];
}

static void
orcmm_struct_a(p, a)
struct orcm_pair *p;
Sint a;
{
  p->a = a | ~p->a;
}

static void
orcmm_struct_b(p, a)
struct orcm_pair *p;
Sint a;
{
  p->b = ~p->b | a;
}

static Sint
orcmm_then_load(a, y)
Sint a;
Sint *y;
{
  *y = a | ~*y;
  return *y;
}

static Sint
orcm_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  b = a | ~b;
  c = b | ~c;
  return c;
}

static uSint
uorcm_reg_reg(a, y)
uSint a;
uSint y;
{
  return a | ~y;
}

static uSint
uorcm_reg_mem(a, y)
uSint a;
uSint *y;
{
  return a | ~*y;
}

static uSint
uorcmi_small(a)
uSint a;
{
  return a | ~0123456;
}

static uSint
uorcmi_low18(a)
uSint a;
{
  return a | ~0777777;
}

static uSint
uorcm_literal(a)
uSint a;
{
  return a | ~0123456123456;
}

static uSint
uorcm_left_half(a)
uSint a;
{
  return a | ~0777777000000;
}

static uSint
uorcm_right_half(a)
uSint a;
{
  return a | ~0000000777777;
}

static uSint
uorcm_high_ones_low_const(a)
uSint a;
{
  return a | ~0777777012345;
}

static uSint
uorcm_low_ones_high_const(a)
uSint a;
{
  return a | ~0123456777777;
}

static Sint
orcm_qi_promote(a, b)
sQint a;
sQint b;
{
  return a | ~b;
}

static Sint
uorcm_qi_promote(a, b)
uQint a;
uQint b;
{
  return a | ~b;
}

static Sint
orcm_hi_promote(a, b)
Hint a;
Hint b;
{
  return a | ~b;
}

static Sint
uorcm_hi_promote(a, b)
uHint a;
uHint b;
{
  return a | ~b;
}

static Sint
orcm_qi_mask(a)
uQint a;
{
  return a | ~0777;
}

static Sint
orcm_hi_mask(a)
uHint a;
{
  return a | ~0777777;
}

static Sint
orcm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return a | ~*y;
}

static void
orcmm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y = a | ~*y;
}

/*
 * Register-derived masks.  These keep nontrivial expressions in play
 * so combine can still discover ORCM/ORCMI-like forms after masking or
 * halfword placement.
 */

static uSint
orcmi_reg_form(a, b)
uSint a;
uSint b;
{
  return b | ~(a & 0777777);
}

static uSint
orcmi_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return b | ~((a + 01234) & 0777777);
}

static uSint
orcm_left_shift_form(a, b)
uSint a;
uSint b;
{
  return b | ~((a & 0777777) << 18);
}

static uSint
orcm_left_shift_plus_form(a, b)
uSint a;
uSint b;
{
  return b | ~(((a + 01234) & 0777777) << 18);
}

static Sint
orcm_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a | ~b) ^ (b | ~c);
}

static Sint
orcm_nested(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return ~(a | ~b) | c;
}

BOTH (orcmb_reg_mem, a | ~*b)
BOTH (orcmb_mem_reg, ~*b | a)
BOTH1 (uSint, uorcmb_reg_mem, a | ~*b)
