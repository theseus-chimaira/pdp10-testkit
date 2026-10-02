#include "insns.h"

/*
 * SUB instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SUB   AC <- AC - E
 *   SUBI  AC <- AC - immediate
 *   SUBM  memory <- AC - memory
 *   SUBB  AC and memory both receive AC - memory
 *
 * Keep SUBM/SUBB centered on "a - *p".  The tempting C spelling
 * "*p -= a" is memory - AC and does not describe PDP-10 SUBM/SUBB.
 */

static Sint sub_ga;
static Sint sub_gb;
static uSint sub_uga;
static Sint sub_buf[16];
static uSint sub_ubuf[16];

struct sub_pair {
  Sint a;
  Sint b;
};

struct sub_upair {
  uSint a;
  uSint b;
};

static struct sub_pair sub_gp;
static struct sub_upair sub_ugp;

static Sint
sub_reg_reg(ac, y)
Sint ac;
Sint y;
{
  return ac - y;
}

static Sint
sub_reg_mem(ac, x)
Sint ac;
Sint *x;
{
  return ac - *x;
}

static Sint
sub_mem_reg(x, y)
Sint *x;
Sint y;
{
  return *x - y;
}

static Sint
sub_mem_mem(x, y)
Sint *x;
Sint *y;
{
  return *x - *y;
}

static Sint
sub_global_a(ac)
Sint ac;
{
  return ac - sub_ga;
}

static Sint
sub_global_b(void)
{
  return sub_ga - sub_gb;
}

static Sint
sub_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  return ac - v[i & 017];
}

static Sint
sub_global_array(i, ac)
Sint i;
Sint ac;
{
  return ac - sub_buf[i & 017];
}

static Sint
sub_struct_a(p, ac)
struct sub_pair *p;
Sint ac;
{
  return ac - p->a;
}

static Sint
sub_struct_b(p, ac)
struct sub_pair *p;
Sint ac;
{
  return ac - p->b;
}

static Sint
sub_global_struct_a(ac)
Sint ac;
{
  return ac - sub_gp.a;
}

static Sint
sub_global_struct_b(ac)
Sint ac;
{
  return ac - sub_gp.b;
}

static Sint
sub_indirect(pp, ac)
Sint **pp;
Sint ac;
{
  return ac - **pp;
}

static Sint
sub_volatile(ac, x)
Sint ac;
volatile Sint *x;
{
  return ac - *x;
}

static Sint
subi_zero(ac)
Sint ac;
{
  return ac - 0;
}

static Sint
subi_one(ac)
Sint ac;
{
  return ac - 1;
}

static Sint
subi_two(ac)
Sint ac;
{
  return ac - 2;
}

static Sint
subi_small(ac)
Sint ac;
{
  return ac - 0123456;
}

static Sint
subi_max18(ac)
Sint ac;
{
  return ac - 0777777;
}

static Sint
subi_neg_small(ac)
Sint ac;
{
  return ac - -0123456;
}

static Sint
sub_literal(ac)
Sint ac;
{
  return ac - 0123456123456;
}

static Sint
sub_literal_left(ac)
Sint ac;
{
  return ac - 0777777000000;
}

static Sint
sub_literal_right(ac)
Sint ac;
{
  return ac - 0000000777777;
}

static Sint
sub_literal_sign(ac)
Sint ac;
{
  return ac - 0400000000000;
}

static Sint
sub_literal_sparse(ac)
Sint ac;
{
  return ac - 0525252252525;
}

static void
subm_reg_mem(ac, x)
Sint ac;
Sint *x;
{
  *x = ac - *x;
}

static void
subm_global_a(ac)
Sint ac;
{
  sub_ga = ac - sub_ga;
}

static void
subm_global_b(ac)
Sint ac;
{
  sub_gb = ac - sub_gb;
}

static void
subm_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  v[i & 017] = ac - v[i & 017];
}

static void
subm_global_array(i, ac)
Sint i;
Sint ac;
{
  sub_buf[i & 017] = ac - sub_buf[i & 017];
}

static void
subm_struct_a(p, ac)
struct sub_pair *p;
Sint ac;
{
  p->a = ac - p->a;
}

static void
subm_struct_b(p, ac)
struct sub_pair *p;
Sint ac;
{
  p->b = ac - p->b;
}

static void
subm_global_struct_a(ac)
Sint ac;
{
  sub_gp.a = ac - sub_gp.a;
}

static void
subm_global_struct_b(ac)
Sint ac;
{
  sub_gp.b = ac - sub_gp.b;
}

static void
subm_indirect(pp, ac)
Sint **pp;
Sint ac;
{
  **pp = ac - **pp;
}

static void
subm_volatile(ac, x)
Sint ac;
volatile Sint *x;
{
  *x = ac - *x;
}

static void
subm_const_small(x)
Sint *x;
{
  *x = 0123456 - *x;
}

static void
subm_const_literal(x)
Sint *x;
{
  *x = 0123456123456 - *x;
}

static Sint
subm_return_mem(ac, x)
Sint ac;
Sint *x;
{
  *x = ac - *x;
  return *x;
}

static Sint
subm_return_global(ac)
Sint ac;
{
  sub_ga = ac - sub_ga;
  return sub_ga;
}

static Sint
subm_return_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  v[i & 017] = ac - v[i & 017];
  return v[i & 017];
}

static Sint
subm_return_struct_a(p, ac)
struct sub_pair *p;
Sint ac;
{
  p->a = ac - p->a;
  return p->a;
}

static Sint
subm_return_struct_b(p, ac)
struct sub_pair *p;
Sint ac;
{
  p->b = ac - p->b;
  return p->b;
}

static Sint
subb_mem_return(ac, x)
Sint ac;
Sint *x;
{
  *x = ac - *x;
  return *x;
}

static Sint
subb_global_return(ac)
Sint ac;
{
  sub_ga = ac - sub_ga;
  return sub_ga;
}

static Sint
subb_array_return(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  v[i & 017] = ac - v[i & 017];
  return v[i & 017];
}

static Sint
subb_struct_a_return(p, ac)
struct sub_pair *p;
Sint ac;
{
  p->a = ac - p->a;
  return p->a;
}

static Sint
subb_struct_b_return(p, ac)
struct sub_pair *p;
Sint ac;
{
  p->b = ac - p->b;
  return p->b;
}

static uSint
usub_reg_reg(ac, y)
uSint ac;
uSint y;
{
  return ac - y;
}

static uSint
usub_reg_mem(ac, x)
uSint ac;
uSint *x;
{
  return ac - *x;
}

static uSint
usub_global(ac)
uSint ac;
{
  return ac - sub_uga;
}

static uSint
usub_array(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  return ac - v[i & 017];
}

static uSint
usubi_small(ac)
uSint ac;
{
  return ac - 0123456;
}

static uSint
usubi_max18(ac)
uSint ac;
{
  return ac - 0777777;
}

static uSint
usub_literal(ac)
uSint ac;
{
  return ac - 0123456123456;
}

static void
usubm_mem(ac, x)
uSint ac;
uSint *x;
{
  *x = ac - *x;
}

static void
usubm_global(ac)
uSint ac;
{
  sub_uga = ac - sub_uga;
}

static void
usubm_array(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  v[i & 017] = ac - v[i & 017];
}

static uSint
usubb_mem_return(ac, x)
uSint ac;
uSint *x;
{
  *x = ac - *x;
  return *x;
}

static uSint
usubb_global_return(ac)
uSint ac;
{
  sub_uga = ac - sub_uga;
  return sub_uga;
}

static Sint
sub_qi(a, b)
sQint a;
sQint b;
{
  return a - b;
}

static Sint
sub_uqi(a, b)
uQint a;
uQint b;
{
  return a - b;
}

static Sint
sub_hi(a, b)
Hint a;
Hint b;
{
  return a - b;
}

static Sint
sub_uhi(a, b)
uHint a;
uHint b;
{
  return a - b;
}

static Sint
sub_qi_mem(a, b)
sQint a;
sQint *b;
{
  return a - *b;
}

static Sint
sub_uqi_mem(a, b)
uQint a;
uQint *b;
{
  return a - *b;
}

static Sint
sub_hi_mem(a, b)
Hint a;
Hint *b;
{
  return a - *b;
}

static Sint
sub_uhi_mem(a, b)
uHint a;
uHint *b;
{
  return a - *b;
}

static void
subm_qi(a, b)
sQint a;
sQint *b;
{
  *b = a - *b;
}

static void
subm_uqi(a, b)
uQint a;
uQint *b;
{
  *b = a - *b;
}

static void
subm_hi(a, b)
Hint a;
Hint *b;
{
  *b = a - *b;
}

static void
subm_uhi(a, b)
uHint a;
uHint *b;
{
  *b = a - *b;
}

/*
 * Pointer subtraction by an integer.  These keep the existing pointer
 * arithmetic coverage from the old skeleton, but avoid pointer-pointer
 * subtraction here; that is a different semantic family.
 */

static Sint *
sub_ptr_reg(ac, y)
Sint *ac;
Sint y;
{
  return ac - y;
}

static Sint *
sub_ptr_small(ac)
Sint *ac;
{
  return ac - 0123456;
}

static Sint *
sub_ptr_one(ac)
Sint *ac;
{
  return ac - 1;
}

static Sint *
sub_ptr_mem(ac, y)
Sint *ac;
Sint *y;
{
  return ac - *y;
}

static uQint *
sub_byte_ptr_reg(ac, y)
uQint *ac;
Sint y;
{
  return ac - y;
}

static uQint *
sub_byte_ptr_one(ac)
uQint *ac;
{
  return ac - 1;
}

static uQint *
sub_byte_ptr_small(ac)
uQint *ac;
{
  return ac - 0123;
}

static Hint *
sub_half_ptr_reg(ac, y)
Hint *ac;
Sint y;
{
  return ac - y;
}

static Hint *
sub_half_ptr_one(ac)
Hint *ac;
{
  return ac - 1;
}

static Sint
sub_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a - b) - c;
}

static Sint
sub_chain_mem(a, b, c)
Sint a;
Sint *b;
Sint *c;
{
  return (a - *b) - *c;
}

static Sint
sub_neg_relation(a, b)
Sint a;
Sint b;
{
  return a - -b;
}

static Sint
sub_store_then_use(a, b, p)
Sint a;
Sint b;
Sint *p;
{
  Sint t;

  t = a - b;
  *p = t;
  return t - a;
}

BOTH (subb_reg_mem, a - *b)
BOTH1 (uSint, usubb_reg_mem, a - *b)
