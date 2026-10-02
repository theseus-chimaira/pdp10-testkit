#include "insns.h"

/*
 * ORCB instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ORCB   AC <- ~AC | ~E
 *   ORCBI  AC <- ~AC | ~immediate
 *   ORCBM  memory <- ~AC | ~memory
 *   ORCBB  AC and memory both receive ~AC | ~memory
 *
 * Keep the source expression centered on "~a | ~x".  This is also
 * ~(a & x), but spelling it as complement-both OR keeps the test aimed
 * at ORCB lowering instead of hiding everything behind generic NAND.
 */

static Sint orcb_ga;
static Sint orcb_gb;
static Sint orcb_buf[16];

struct orcb_pair {
  Sint a;
  Sint b;
};

static struct orcb_pair orcb_gp;

static Sint
orcb_reg_reg(a, y)
Sint a;
Sint y;
{
  return ~a | ~y;
}

static Sint
orcb_reg_mem(a, y)
Sint a;
Sint *y;
{
  return ~a | ~*y;
}

static Sint
orcb_mem_reg(y, a)
Sint *y;
Sint a;
{
  return ~a | ~*y;
}

static Sint
orcb_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return ~*a | ~*y;
}

static Sint
orcb_global_a(a)
Sint a;
{
  return ~a | ~orcb_ga;
}

static Sint
orcb_global_b(void)
{
  return ~orcb_ga | ~orcb_gb;
}

static Sint
orcb_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return ~a | ~v[i & 017];
}

static Sint
orcb_global_array(i, a)
Sint i;
Sint a;
{
  return ~a | ~orcb_buf[i & 017];
}

static Sint
orcb_struct_a(p, a)
struct orcb_pair *p;
Sint a;
{
  return ~a | ~p->a;
}

static Sint
orcb_struct_b(p, a)
struct orcb_pair *p;
Sint a;
{
  return ~a | ~p->b;
}

static Sint
orcb_global_struct_a(a)
Sint a;
{
  return ~a | ~orcb_gp.a;
}

static Sint
orcb_global_struct_b(a)
Sint a;
{
  return ~a | ~orcb_gp.b;
}

static Sint
orcbi_small(a)
Sint a;
{
  return ~a | ~0123456;
}

static Sint
orcbi_zero(a)
Sint a;
{
  return ~a | ~0;
}

static Sint
orcbi_one(a)
Sint a;
{
  return ~a | ~1;
}

static Sint
orcbi_low9(a)
Sint a;
{
  return ~a | ~0777;
}

static Sint
orcbi_low18(a)
Sint a;
{
  return ~a | ~0777777;
}

static Sint
orcb_literal(a)
Sint a;
{
  return ~a | ~0123456123456;
}

static Sint
orcb_literal_left(a)
Sint a;
{
  return ~0123456123456 | ~a;
}

static Sint
orcb_sparse(a)
Sint a;
{
  return ~a | ~0525252252525;
}

static Sint
orcb_left_half(a)
Sint a;
{
  return ~a | ~0777777000000;
}

static Sint
orcb_right_half(a)
Sint a;
{
  return ~a | ~0000000777777;
}

static Sint
orcb_high_ones_low_const(a)
Sint a;
{
  return ~a | ~0777777012345;
}

static Sint
orcb_low_ones_high_const(a)
Sint a;
{
  return ~a | ~0123456777777;
}

static Sint
orcb_sign_bit(a)
Sint a;
{
  return ~a | ~0400000000000;
}

static Sint
orcb_clear_sign_mask(a)
Sint a;
{
  return ~a | ~0377777777777;
}

static Sint
orcb_all_ones(a)
Sint a;
{
  return ~a | ~0777777777777;
}

static void
orcbm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = ~a | ~*y;
}

static void
orcbm_assign(a, y)
Sint a;
Sint *y;
{
  *y = ~a | ~*y;
}

static void
orcbm_const(y)
Sint *y;
{
  *y = ~0123456 | ~*y;
}

static void
orcbm_global(a)
Sint a;
{
  orcb_ga = ~a | ~orcb_ga;
}

static void
orcbm_global_2(a)
Sint a;
{
  orcb_gb = ~orcb_gb | ~a;
}

static void
orcbm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] = ~a | ~v[i & 017];
}

static void
orcbm_global_array(i, a)
Sint i;
Sint a;
{
  orcb_buf[i & 017] = ~a | ~orcb_buf[i & 017];
}

static void
orcbm_struct_a(p, a)
struct orcb_pair *p;
Sint a;
{
  p->a = ~a | ~p->a;
}

static void
orcbm_struct_b(p, a)
struct orcb_pair *p;
Sint a;
{
  p->b = ~p->b | ~a;
}

static Sint
orcbm_then_load(a, y)
Sint a;
Sint *y;
{
  *y = ~a | ~*y;
  return *y;
}

static Sint
orcb_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  b = ~a | ~b;
  c = ~b | ~c;
  return c;
}

static uSint
uorcb_reg_reg(a, y)
uSint a;
uSint y;
{
  return ~a | ~y;
}

static uSint
uorcb_reg_mem(a, y)
uSint a;
uSint *y;
{
  return ~a | ~*y;
}

static uSint
uorcbi_small(a)
uSint a;
{
  return ~a | ~0123456;
}

static uSint
uorcbi_low18(a)
uSint a;
{
  return ~a | ~0777777;
}

static uSint
uorcb_literal(a)
uSint a;
{
  return ~a | ~0123456123456;
}

static uSint
uorcb_left_half(a)
uSint a;
{
  return ~a | ~0777777000000;
}

static uSint
uorcb_right_half(a)
uSint a;
{
  return ~a | ~0000000777777;
}

static uSint
uorcb_high_ones_low_const(a)
uSint a;
{
  return ~a | ~0777777012345;
}

static uSint
uorcb_low_ones_high_const(a)
uSint a;
{
  return ~a | ~0123456777777;
}

static Sint
orcb_qi_promote(a, b)
sQint a;
sQint b;
{
  return ~a | ~b;
}

static Sint
uorcb_qi_promote(a, b)
uQint a;
uQint b;
{
  return ~a | ~b;
}

static Sint
orcb_hi_promote(a, b)
Hint a;
Hint b;
{
  return ~a | ~b;
}

static Sint
uorcb_hi_promote(a, b)
uHint a;
uHint b;
{
  return ~a | ~b;
}

static Sint
orcb_qi_mask(a)
uQint a;
{
  return ~a | ~0777;
}

static Sint
orcb_hi_mask(a)
uHint a;
{
  return ~a | ~0777777;
}

static Sint
orcb_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return ~a | ~*y;
}

static void
orcbm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y = ~a | ~*y;
}

/*
 * Register-derived masks.  These keep nontrivial expressions in play
 * so combine can still discover ORCB/ORCBI-like forms after masking or
 * halfword placement.
 */

static uSint
orcbi_reg_form(a, b)
uSint a;
uSint b;
{
  return ~b | ~(a & 0777777);
}

static uSint
orcbi_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b | ~((a + 01234) & 0777777);
}

static uSint
orcb_left_shift_form(a, b)
uSint a;
uSint b;
{
  return ~b | ~((a & 0777777) << 18);
}

static uSint
orcb_left_shift_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b | ~(((a + 01234) & 0777777) << 18);
}

static Sint
orcb_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (~a | ~b) ^ (~b | ~c);
}

static Sint
orcb_nested(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return ~(~a | ~b) | ~c;
}

BOTH (orcbb_reg_mem, ~a | ~*b)
BOTH (orcbb_mem_reg, ~*b | ~a)
BOTH1 (uSint, uorcbb_reg_mem, ~a | ~*b)
