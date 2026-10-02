#include "insns.h"

/*
 * ORCA instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ORCA   AC <- ~AC | E
 *   ORCAI  AC <- ~AC | immediate
 *   ORCAM  memory <- ~AC | memory
 *   ORCAB  AC and memory both receive ~AC | memory
 *
 * Keep the core expression centered on "~a | x", i.e. complement of
 * the accumulator-like operand.  The commuted forms are kept too,
 * because combine/reassociation can otherwise hide useful ORCA/ORCAB
 * opportunities.
 */

static Sint orca_ga;
static Sint orca_gb;
static Sint orca_buf[16];

struct orca_pair {
  Sint a;
  Sint b;
};

static struct orca_pair orca_gp;

static Sint
orca_reg_reg(a, y)
Sint a;
Sint y;
{
  return ~a | y;
}

static Sint
orca_reg_mem(a, y)
Sint a;
Sint *y;
{
  return ~a | *y;
}

static Sint
orca_mem_reg(y, a)
Sint *y;
Sint a;
{
  return ~a | *y;
}

static Sint
orca_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return ~*a | *y;
}

static Sint
orca_global_a(a)
Sint a;
{
  return ~a | orca_ga;
}

static Sint
orca_global_b(void)
{
  return ~orca_ga | orca_gb;
}

static Sint
orca_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return ~a | v[i & 017];
}

static Sint
orca_global_array(i, a)
Sint i;
Sint a;
{
  return ~a | orca_buf[i & 017];
}

static Sint
orca_struct_a(p, a)
struct orca_pair *p;
Sint a;
{
  return ~a | p->a;
}

static Sint
orca_struct_b(p, a)
struct orca_pair *p;
Sint a;
{
  return ~a | p->b;
}

static Sint
orca_global_struct_a(a)
Sint a;
{
  return ~a | orca_gp.a;
}

static Sint
orca_global_struct_b(a)
Sint a;
{
  return ~a | orca_gp.b;
}

static Sint
orcai_small(a)
Sint a;
{
  return ~a | 0123456;
}

static Sint
orcai_zero(a)
Sint a;
{
  return ~a | 0;
}

static Sint
orcai_one(a)
Sint a;
{
  return ~a | 1;
}

static Sint
orcai_low9(a)
Sint a;
{
  return ~a | 0777;
}

static Sint
orcai_low18(a)
Sint a;
{
  return ~a | 0777777;
}

static Sint
orca_literal(a)
Sint a;
{
  return ~a | 0123456123456;
}

static Sint
orca_literal_left(a)
Sint a;
{
  return 0123456123456 | ~a;
}

static Sint
orca_sparse(a)
Sint a;
{
  return ~a | 0525252252525;
}

static Sint
orca_left_half(a)
Sint a;
{
  return ~a | 0777777000000;
}

static Sint
orca_right_half(a)
Sint a;
{
  return ~a | 0000000777777;
}

static Sint
orca_high_ones_low_const(a)
Sint a;
{
  return ~a | 0777777012345;
}

static Sint
orca_low_ones_high_const(a)
Sint a;
{
  return ~a | 0123456777777;
}

static Sint
orca_sign_bit(a)
Sint a;
{
  return ~a | 0400000000000;
}

static Sint
orca_clear_sign_mask(a)
Sint a;
{
  return ~a | 0377777777777;
}

static Sint
orca_all_ones(a)
Sint a;
{
  return ~a | 0777777777777;
}

static void
orcam_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = ~a | *y;
}

static void
orcam_assign(a, y)
Sint a;
Sint *y;
{
  *y |= ~a;
}

static void
orcam_const(y)
Sint *y;
{
  *y = ~0123456 | *y;
}

static void
orcam_global(a)
Sint a;
{
  orca_ga = ~a | orca_ga;
}

static void
orcam_global_2(a)
Sint a;
{
  orca_gb |= ~a;
}

static void
orcam_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] = ~a | v[i & 017];
}

static void
orcam_global_array(i, a)
Sint i;
Sint a;
{
  orca_buf[i & 017] = ~a | orca_buf[i & 017];
}

static void
orcam_struct_a(p, a)
struct orca_pair *p;
Sint a;
{
  p->a = ~a | p->a;
}

static void
orcam_struct_b(p, a)
struct orca_pair *p;
Sint a;
{
  p->b |= ~a;
}

static Sint
orcam_then_load(a, y)
Sint a;
Sint *y;
{
  *y |= ~a;
  return *y;
}

static Sint
orca_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  b |= ~a;
  c |= ~b;
  return c;
}

static uSint
uorca_reg_reg(a, y)
uSint a;
uSint y;
{
  return ~a | y;
}

static uSint
uorca_reg_mem(a, y)
uSint a;
uSint *y;
{
  return ~a | *y;
}

static uSint
uorcai_small(a)
uSint a;
{
  return ~a | 0123456;
}

static uSint
uorcai_low18(a)
uSint a;
{
  return ~a | 0777777;
}

static uSint
uorca_literal(a)
uSint a;
{
  return ~a | 0123456123456;
}

static uSint
uorca_left_half(a)
uSint a;
{
  return ~a | 0777777000000;
}

static uSint
uorca_right_half(a)
uSint a;
{
  return ~a | 0000000777777;
}

static uSint
uorca_high_ones_low_const(a)
uSint a;
{
  return ~a | 0777777012345;
}

static uSint
uorca_low_ones_high_const(a)
uSint a;
{
  return ~a | 0123456777777;
}

static Sint
orca_qi_promote(a, b)
sQint a;
sQint b;
{
  return ~a | b;
}

static Sint
uorca_qi_promote(a, b)
uQint a;
uQint b;
{
  return ~a | b;
}

static Sint
orca_hi_promote(a, b)
Hint a;
Hint b;
{
  return ~a | b;
}

static Sint
uorca_hi_promote(a, b)
uHint a;
uHint b;
{
  return ~a | b;
}

static Sint
orca_qi_mask(a)
uQint a;
{
  return ~a | 0777;
}

static Sint
orca_hi_mask(a)
uHint a;
{
  return ~a | 0777777;
}

static Sint
orca_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return ~a | *y;
}

static void
orcam_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y |= ~a;
}

/*
 * Register-derived masks.  These keep nontrivial expressions in play
 * so combine has chances to form ORCA/ORCAI-like code without relying
 * only on simple constants.
 */

static uSint
orcai_reg_form(a, b)
uSint a;
uSint b;
{
  return ~b | (a & 0777777);
}

static uSint
orcai_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b | ((a + 01234) & 0777777);
}

static uSint
orca_left_shift_form(a, b)
uSint a;
uSint b;
{
  return ~b | ((a & 0777777) << 18);
}

static uSint
orca_left_shift_plus_form(a, b)
uSint a;
uSint b;
{
  return ~b | (((a + 01234) & 0777777) << 18);
}

static Sint
orca_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (~a | b) ^ (~b | c);
}

static Sint
orca_nested(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return ~(~a | b) | c;
}

BOTH (orcab_reg_mem, ~a | *b)
BOTH (orcab_mem_reg, *b | ~a)
BOTH1 (uSint, uorcab_reg_mem, ~a | *b)
