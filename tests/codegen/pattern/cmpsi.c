#include "insns.h"

/*
 * SImode compare pattern pressure.
 *
 * Intended pattern:
 *   cmpsi
 *
 * cmpsi itself only records the comparison operands for the later
 * conditional branch/value expansion.  Therefore this test makes the
 * comparisons observable through if/return forms.
 *
 * Intended comparison pressure:
 *   - register against zero
 *   - memory/global against zero
 *   - register against small immediate
 *   - register against large literal constant
 *   - register against register
 *   - register against memory/global
 *   - signed and unsigned conditions
 *
 * Branch-lowering details are covered more directly by cbranchsi.c.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint cmp_ga;
static Sint cmp_gb;
static volatile Sint cmp_vga;
static Sint cmp_buf[16];

static uSint ucmp_ga;
static uSint ucmp_gb;
static volatile uSint ucmp_vga;
static uSint ucmp_buf[16];

struct cmp_pair {
  Sint a;
  Sint b;
};

struct ucmp_pair {
  uSint a;
  uSint b;
};

static struct cmp_pair cmp_gp;
static struct ucmp_pair ucmp_gp;

/*
 * Original expected basename shape.
 */

Sint
cmpsi(a, b)
Sint a;
Sint b;
{
  if (a == b)
    return 1;
  return 0;
}

/*
 * Signed register/register comparisons.
 */

static Sint
cmp_eq(a, b)
Sint a;
Sint b;
{
  return a == b;
}

static Sint
cmp_ne(a, b)
Sint a;
Sint b;
{
  return a != b;
}

static Sint
cmp_lt(a, b)
Sint a;
Sint b;
{
  return a < b;
}

static Sint
cmp_le(a, b)
Sint a;
Sint b;
{
  return a <= b;
}

static Sint
cmp_gt(a, b)
Sint a;
Sint b;
{
  return a > b;
}

static Sint
cmp_ge(a, b)
Sint a;
Sint b;
{
  return a >= b;
}

/*
 * Unsigned register/register comparisons.
 */

static Sint
ucmp_eq(a, b)
uSint a;
uSint b;
{
  return a == b;
}

static Sint
ucmp_ne(a, b)
uSint a;
uSint b;
{
  return a != b;
}

static Sint
ucmp_lt(a, b)
uSint a;
uSint b;
{
  return a < b;
}

static Sint
ucmp_le(a, b)
uSint a;
uSint b;
{
  return a <= b;
}

static Sint
ucmp_gt(a, b)
uSint a;
uSint b;
{
  return a > b;
}

static Sint
ucmp_ge(a, b)
uSint a;
uSint b;
{
  return a >= b;
}

/*
 * Register against zero.  These should pressure JUMP-like cases.
 */

static Sint
cmp_eq_zero(a)
Sint a;
{
  return a == 0;
}

static Sint
cmp_ne_zero(a)
Sint a;
{
  return a != 0;
}

static Sint
cmp_lt_zero(a)
Sint a;
{
  return a < 0;
}

static Sint
cmp_le_zero(a)
Sint a;
{
  return a <= 0;
}

static Sint
cmp_gt_zero(a)
Sint a;
{
  return a > 0;
}

static Sint
cmp_ge_zero(a)
Sint a;
{
  return a >= 0;
}

static Sint
ucmp_eq_zero(a)
uSint a;
{
  return a == 0;
}

static Sint
ucmp_ne_zero(a)
uSint a;
{
  return a != 0;
}

/*
 * Memory/global against zero.  These should pressure SKIP-like cases.
 */

static Sint
cmp_mem_eq_zero(p)
Sint *p;
{
  return *p == 0;
}

static Sint
cmp_mem_ne_zero(p)
Sint *p;
{
  return *p != 0;
}

static Sint
cmp_mem_lt_zero(p)
Sint *p;
{
  return *p < 0;
}

static Sint
cmp_mem_ge_zero(p)
Sint *p;
{
  return *p >= 0;
}

static Sint
cmp_global_eq_zero()
{
  return cmp_ga == 0;
}

static Sint
cmp_global_ne_zero()
{
  return cmp_ga != 0;
}

static Sint
cmp_global_lt_zero()
{
  return cmp_ga < 0;
}

static Sint
cmp_global_ge_zero()
{
  return cmp_ga >= 0;
}

static Sint
cmp_volatile_global_eq_zero()
{
  return cmp_vga == 0;
}

static Sint
cmp_volatile_global_lt_zero()
{
  return cmp_vga < 0;
}

/*
 * Register against small immediate.  These should pressure CAI.
 */

static Sint
cmp_eq_1(a)
Sint a;
{
  return a == 1;
}

static Sint
cmp_ne_1(a)
Sint a;
{
  return a != 1;
}

static Sint
cmp_lt_1(a)
Sint a;
{
  return a < 1;
}

static Sint
cmp_le_1(a)
Sint a;
{
  return a <= 1;
}

static Sint
cmp_gt_1(a)
Sint a;
{
  return a > 1;
}

static Sint
cmp_ge_1(a)
Sint a;
{
  return a >= 1;
}

static Sint
cmp_eq_small(a)
Sint a;
{
  return a == 012345;
}

static Sint
cmp_lt_small(a)
Sint a;
{
  return a < 012345;
}

static Sint
cmp_gt_small(a)
Sint a;
{
  return a > 012345;
}

static Sint
cmp_eq_right_max(a)
Sint a;
{
  return a == 0777777;
}

static Sint
cmp_lt_right_max(a)
Sint a;
{
  return a < 0777777;
}

static Sint
cmp_gt_right_max(a)
Sint a;
{
  return a > 0777777;
}

static Sint
cmp_eq_minus_1(a)
Sint a;
{
  return a == -1;
}

static Sint
cmp_lt_minus_1(a)
Sint a;
{
  return a < -1;
}

static Sint
cmp_gt_minus_1(a)
Sint a;
{
  return a > -1;
}

static Sint
cmp_eq_minus_small(a)
Sint a;
{
  return a == -012345;
}

static Sint
cmp_lt_minus_small(a)
Sint a;
{
  return a < -012345;
}

static Sint
cmp_gt_minus_small(a)
Sint a;
{
  return a > -012345;
}

/*
 * Unsigned register against immediate.
 */

static Sint
ucmp_lt_1(a)
uSint a;
{
  return a < 1;
}

static Sint
ucmp_gt_1(a)
uSint a;
{
  return a > 1;
}

static Sint
ucmp_eq_small(a)
uSint a;
{
  return a == 012345;
}

static Sint
ucmp_lt_small(a)
uSint a;
{
  return a < 012345;
}

static Sint
ucmp_gt_small(a)
uSint a;
{
  return a > 012345;
}

static Sint
ucmp_eq_highbit(a)
uSint a;
{
  return a == 0400000000000;
}

static Sint
ucmp_lt_highbit(a)
uSint a;
{
  return a < 0400000000000;
}

static Sint
ucmp_gt_highbit(a)
uSint a;
{
  return a > 0400000000000;
}

/*
 * Register against large constants.  These should pressure CAM literal
 * forms rather than plain CAI.
 */

static Sint
cmp_eq_left_const(a)
Sint a;
{
  return a == 0123456000000;
}

static Sint
cmp_ne_left_const(a)
Sint a;
{
  return a != 0123456000000;
}

static Sint
cmp_lt_left_const(a)
Sint a;
{
  return a < 0123456000000;
}

static Sint
cmp_gt_left_const(a)
Sint a;
{
  return a > 0123456000000;
}

static Sint
cmp_eq_full_const(a)
Sint a;
{
  return a == 0123456123456;
}

static Sint
cmp_ne_full_const(a)
Sint a;
{
  return a != 0123456123456;
}

static Sint
cmp_lt_full_const(a)
Sint a;
{
  return a < 0123456123456;
}

static Sint
cmp_gt_full_const(a)
Sint a;
{
  return a > 0123456123456;
}

static Sint
cmp_eq_signbit(a)
Sint a;
{
  return a == 0400000000000;
}

static Sint
cmp_lt_signbit(a)
Sint a;
{
  return a < 0400000000000;
}

static Sint
cmp_gt_signbit(a)
Sint a;
{
  return a > 0400000000000;
}

/*
 * Memory/global operands compared with registers.
 */

static Sint
cmp_mem_eq_reg(p, a)
Sint *p;
Sint a;
{
  return *p == a;
}

static Sint
cmp_mem_ne_reg(p, a)
Sint *p;
Sint a;
{
  return *p != a;
}

static Sint
cmp_mem_lt_reg(p, a)
Sint *p;
Sint a;
{
  return *p < a;
}

static Sint
cmp_mem_le_reg(p, a)
Sint *p;
Sint a;
{
  return *p <= a;
}

static Sint
cmp_mem_gt_reg(p, a)
Sint *p;
Sint a;
{
  return *p > a;
}

static Sint
cmp_mem_ge_reg(p, a)
Sint *p;
Sint a;
{
  return *p >= a;
}

static Sint
cmp_reg_eq_mem(a, p)
Sint a;
Sint *p;
{
  return a == *p;
}

static Sint
cmp_reg_ne_mem(a, p)
Sint a;
Sint *p;
{
  return a != *p;
}

static Sint
cmp_reg_lt_mem(a, p)
Sint a;
Sint *p;
{
  return a < *p;
}

static Sint
cmp_reg_le_mem(a, p)
Sint a;
Sint *p;
{
  return a <= *p;
}

static Sint
cmp_reg_gt_mem(a, p)
Sint a;
Sint *p;
{
  return a > *p;
}

static Sint
cmp_reg_ge_mem(a, p)
Sint a;
Sint *p;
{
  return a >= *p;
}

static Sint
cmp_global_eq_reg(a)
Sint a;
{
  return cmp_ga == a;
}

static Sint
cmp_global_lt_reg(a)
Sint a;
{
  return cmp_ga < a;
}

static Sint
cmp_reg_lt_global(a)
Sint a;
{
  return a < cmp_gb;
}

static Sint
cmp_volatile_global_reg(a)
Sint a;
{
  return cmp_vga != a;
}

/*
 * Unsigned memory/global comparisons.
 */

static Sint
ucmp_mem_lt_reg(p, a)
uSint *p;
uSint a;
{
  return *p < a;
}

static Sint
ucmp_mem_gt_reg(p, a)
uSint *p;
uSint a;
{
  return *p > a;
}

static Sint
ucmp_reg_lt_mem(a, p)
uSint a;
uSint *p;
{
  return a < *p;
}

static Sint
ucmp_reg_gt_mem(a, p)
uSint a;
uSint *p;
{
  return a > *p;
}

static Sint
ucmp_global_lt_reg(a)
uSint a;
{
  return ucmp_ga < a;
}

static Sint
ucmp_reg_lt_global(a)
uSint a;
{
  return a < ucmp_gb;
}

static Sint
ucmp_volatile_global_reg(a)
uSint a;
{
  return ucmp_vga != a;
}

/*
 * Array and struct addressing pressure.
 */

static Sint
cmp_array_eq_reg(i, a)
Sint i;
Sint a;
{
  return cmp_buf[i & 017] == a;
}

static Sint
cmp_array_lt_reg(i, a)
Sint i;
Sint a;
{
  return cmp_buf[i & 017] < a;
}

static Sint
cmp_reg_lt_array(a, i)
Sint a;
Sint i;
{
  return a < cmp_buf[i & 017];
}

static Sint
cmp_ptr_array_gt_reg(p, i, a)
Sint *p;
Sint i;
Sint a;
{
  return p[i & 017] > a;
}

static Sint
ucmp_array_lt_reg(i, a)
Sint i;
uSint a;
{
  return ucmp_buf[i & 017] < a;
}

static Sint
ucmp_reg_lt_array(a, i)
uSint a;
Sint i;
{
  return a < ucmp_buf[i & 017];
}

static Sint
cmp_struct_eq_a(p, x)
struct cmp_pair *p;
Sint x;
{
  return p->a == x;
}

static Sint
cmp_struct_lt_a(p, x)
struct cmp_pair *p;
Sint x;
{
  return p->a < x;
}

static Sint
cmp_struct_gt_b(p, x)
struct cmp_pair *p;
Sint x;
{
  return p->b > x;
}

static Sint
cmp_struct_members(p)
struct cmp_pair *p;
{
  return p->a < p->b;
}

static Sint
cmp_global_struct_a(x)
Sint x;
{
  return cmp_gp.a == x;
}

static Sint
cmp_global_struct_b(x)
Sint x;
{
  return cmp_gp.b >= x;
}

static Sint
ucmp_struct_members(p)
struct ucmp_pair *p;
{
  return p->a < p->b;
}

static Sint
ucmp_global_struct_a(x)
uSint x;
{
  return ucmp_gp.a > x;
}

/*
 * Compare results of arithmetic/logical expressions.
 */

static Sint
cmp_add_eq(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a + b) == c;
}

static Sint
cmp_add_lt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a + b) < c;
}

static Sint
cmp_sub_eq(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a - b) == c;
}

static Sint
cmp_sub_lt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a - b) < c;
}

static Sint
cmp_mul_eq(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a * b) == c;
}

static Sint
cmp_and_eq(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a & b) == c;
}

static Sint
cmp_xor_ne(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a ^ b) != c;
}

static Sint
cmp_or_gt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a | b) > c;
}

static Sint
ucmp_add_lt(a, b, c)
uSint a;
uSint b;
uSint c;
{
  return (a + b) < c;
}

static Sint
ucmp_sub_gt(a, b, c)
uSint a;
uSint b;
uSint c;
{
  return (a - b) > c;
}

/*
 * Right-half and plus-address-shaped cases.  These overlap with
 * cbranchsi special CAI forms but are useful compare operand pressure.
 */

static Sint
cmp_right_half_eq(a, b)
Sint a;
Sint b;
{
  return (a & 0777777) == b;
}

static Sint
cmp_right_half_lt(a, b)
Sint a;
Sint b;
{
  return (a & 0777777) < b;
}

static Sint
cmp_right_half_plus_eq(a, b)
Sint a;
Sint b;
{
  return ((a + 0123) & 0777777) == b;
}

static Sint
cmp_right_half_plus_lt(a, b)
Sint a;
Sint b;
{
  return ((a + 0123) & 0777777) < b;
}

static Sint
cmp_reg_eq_right_half(a, b)
Sint a;
Sint b;
{
  return a == (b & 0777777);
}

static Sint
cmp_reg_lt_right_half(a, b)
Sint a;
Sint b;
{
  return a < (b & 0777777);
}

/*
 * Promoted QI/HI operands.
 */

static Sint
cmp_qi_eq(a, b)
Qint a;
Qint b;
{
  return a == b;
}

static Sint
cmp_qi_lt(a, b)
Qint a;
Qint b;
{
  return a < b;
}

static Sint
cmp_uqi_lt(a, b)
uQint a;
uQint b;
{
  return a < b;
}

static Sint
cmp_hi_eq(a, b)
Hint a;
Hint b;
{
  return a == b;
}

static Sint
cmp_hi_lt(a, b)
Hint a;
Hint b;
{
  return a < b;
}

static Sint
cmp_uhi_lt(a, b)
uHint a;
uHint b;
{
  return a < b;
}

static Sint
cmp_qi_reg(a, b)
Qint a;
Sint b;
{
  return a < b;
}

static Sint
cmp_hi_reg(a, b)
Hint a;
Sint b;
{
  return a >= b;
}

static Sint
cmp_uqi_reg(a, b)
uQint a;
uSint b;
{
  return a < b;
}

static Sint
cmp_uhi_reg(a, b)
uHint a;
uSint b;
{
  return a > b;
}

/*
 * If/else forms to keep real branches alive.
 */

static Sint
cmp_if_eq(a, b)
Sint a;
Sint b;
{
  if (a == b)
    return a + 1;
  return b - 1;
}

static Sint
cmp_if_ne(a, b)
Sint a;
Sint b;
{
  if (a != b)
    return a - b;
  return b;
}

static Sint
cmp_if_lt(a, b)
Sint a;
Sint b;
{
  if (a < b)
    return -1;
  return 1;
}

static Sint
cmp_if_le(a, b)
Sint a;
Sint b;
{
  if (a <= b)
    return -1;
  return 1;
}

static Sint
cmp_if_gt(a, b)
Sint a;
Sint b;
{
  if (a > b)
    return 1;
  return -1;
}

static Sint
cmp_if_ge(a, b)
Sint a;
Sint b;
{
  if (a >= b)
    return 1;
  return -1;
}

static Sint
ucmp_if_lt(a, b)
uSint a;
uSint b;
{
  if (a < b)
    return -1;
  return 1;
}

static Sint
ucmp_if_ge(a, b)
uSint a;
uSint b;
{
  if (a >= b)
    return 1;
  return -1;
}

/*
 * Multi-branch range forms.
 */

static Sint
cmp_range_signed(a)
Sint a;
{
  if (a < -0100)
    return -1;
  if (a > 0100)
    return 1;
  return 0;
}

static Sint
cmp_range_unsigned(a)
uSint a;
{
  if (a < 0100)
    return -1;
  if (a > 0777777)
    return 1;
  return 0;
}

static Sint
cmp_between(a, lo, hi)
Sint a;
Sint lo;
Sint hi;
{
  if (a < lo)
    return -1;
  if (a > hi)
    return 1;
  return 0;
}

static Sint
ucmp_between(a, lo, hi)
uSint a;
uSint lo;
uSint hi;
{
  if (a < lo)
    return -1;
  if (a > hi)
    return 1;
  return 0;
}

/*
 * Call and volatile barriers.
 */

static Sint
cmp_after_call(p, b)
Sint *p;
Sint b;
{
  Sint a;

  a = *p;
  clobber();
  return a == b;
}

static Sint
cmp_call_result(b)
Sint b;
{
  return f() < b;
}

static Sint
cmp_two_call_results()
{
  Sint a;
  Sint b;

  a = f();
  b = f();
  return a != b;
}

static Sint
ucmp_call_result(b)
uSint b;
{
  return uf() > b;
}

static Sint
cmp_store_after_compare(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (a < b)
    *p = a;
  else
    *p = b;
  return *p;
}

static Sint
cmp_global_after_call(a)
Sint a;
{
  clobber();
  if (cmp_ga == a)
    return cmp_gb;
  return a;
}

static Sint
cmp_volatile_after_call(a)
Sint a;
{
  clobber();
  if (cmp_vga != a)
    return 1;
  return 0;
}
