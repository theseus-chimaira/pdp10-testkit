#include "insns.h"

/*
 * SImode find-first-set pattern pressure.
 *
 * Intended pattern:
 *   ffssi2
 *
 * PDP-6/KA10 note:
 *   ffssi2 is TARGET_KA10up.  It is not a PDP-6 pattern.
 *
 * PDP-10 KA10-relevant backend shape:
 *   - negate input
 *   - and input with negative input to isolate the low bit
 *   - JFFO on the isolated bit
 *   - adjust the JFFO result to C ffs semantics
 *
 * C ffs semantics:
 *   ffs(0) == 0
 *   otherwise result is one plus the index of the least significant
 *   set bit.
 *
 * Ordinary C has no ffs operator, so this file uses GCC's
 * __builtin_ffs.  Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint ffs_ga;
static Sint ffs_gb;
static volatile Sint ffs_vga;
static Sint ffs_buf[16];

static uSint uffs_ga;
static uSint uffs_gb;
static volatile uSint uffs_vga;
static uSint uffs_buf[16];

struct ffs_pair {
  Sint a;
  Sint b;
};

struct uffs_pair {
  uSint a;
  uSint b;
};

struct ffs_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct ffs_pair ffs_gp;
static struct uffs_pair uffs_gp;
static struct ffs_three ffs_gt;

/*
 * Original expected basename shape.
 */

Sint
ffssi2(a)
Sint a;
{
  return __builtin_ffs(a);
}

/*
 * Basic register forms.
 */

static Sint
ffs_arg(a)
Sint a;
{
  return __builtin_ffs(a);
}

static Sint
ffs_second_arg(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(b);
}

static Sint
uffs_arg(a)
uSint a;
{
  return __builtin_ffs((Sint)a);
}

static Sint
ffs_local(a)
Sint a;
{
  Sint x;

  x = __builtin_ffs(a);
  return x;
}

static Sint
uffs_local(a)
uSint a;
{
  Sint x;

  x = __builtin_ffs((Sint)a);
  return x;
}

static Sint
ffs_reuse(a)
Sint a;
{
  a = __builtin_ffs(a);
  return a;
}

static Sint
ffs_after_add(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  return __builtin_ffs(x);
}

static Sint
ffs_after_sub(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  return __builtin_ffs(x);
}

static Sint
ffs_after_neg(a)
Sint a;
{
  Sint x;

  x = -a;
  return __builtin_ffs(x);
}

static Sint
ffs_after_and(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  return __builtin_ffs(x);
}

static Sint
ffs_after_or(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a | b;
  return __builtin_ffs(x);
}

static Sint
ffs_after_xor(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  return __builtin_ffs(x);
}

static Sint
ffs_after_shift_left(a, n)
Sint a;
Sint n;
{
  Sint x;

  x = a << n;
  return __builtin_ffs(x);
}

static Sint
ffs_after_shift_right(a, n)
uSint a;
Sint n;
{
  uSint x;

  x = a >> n;
  return __builtin_ffs((Sint)x);
}

static Sint
ffs_call_value()
{
  return __builtin_ffs(f());
}

static Sint
uffs_call_value()
{
  return __builtin_ffs((Sint)uf());
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
ffs_mem(p)
Sint *p;
{
  return __builtin_ffs(*p);
}

static Sint
uffs_mem(p)
uSint *p;
{
  return __builtin_ffs((Sint)*p);
}

static Sint
ffs_volatile_mem(p)
volatile Sint *p;
{
  return __builtin_ffs(*p);
}

static Sint
uffs_volatile_mem(p)
volatile uSint *p;
{
  return __builtin_ffs((Sint)*p);
}

static Sint
ffs_global()
{
  return __builtin_ffs(ffs_ga);
}

static Sint
ffs_global_b()
{
  return __builtin_ffs(ffs_gb);
}

static Sint
ffs_volatile_global()
{
  return __builtin_ffs(ffs_vga);
}

static Sint
uffs_global()
{
  return __builtin_ffs((Sint)uffs_ga);
}

static Sint
uffs_global_b()
{
  return __builtin_ffs((Sint)uffs_gb);
}

static Sint
uffs_volatile_global()
{
  return __builtin_ffs((Sint)uffs_vga);
}

static Sint
ffs_array(i)
Sint i;
{
  return __builtin_ffs(ffs_buf[i & 017]);
}

static Sint
uffs_array(i)
Sint i;
{
  return __builtin_ffs((Sint)uffs_buf[i & 017]);
}

static Sint
ffs_ptr_array(p, i)
Sint *p;
Sint i;
{
  return __builtin_ffs(p[i & 017]);
}

static Sint
uffs_ptr_array(p, i)
uSint *p;
Sint i;
{
  return __builtin_ffs((Sint)p[i & 017]);
}

static Sint
ffs_struct_a(p)
struct ffs_pair *p;
{
  return __builtin_ffs(p->a);
}

static Sint
ffs_struct_b(p)
struct ffs_pair *p;
{
  return __builtin_ffs(p->b);
}

static Sint
uffs_struct_a(p)
struct uffs_pair *p;
{
  return __builtin_ffs((Sint)p->a);
}

static Sint
uffs_struct_b(p)
struct uffs_pair *p;
{
  return __builtin_ffs((Sint)p->b);
}

static Sint
ffs_global_struct_a()
{
  return __builtin_ffs(ffs_gp.a);
}

static Sint
ffs_global_struct_b()
{
  return __builtin_ffs(ffs_gp.b);
}

static Sint
uffs_global_struct_a()
{
  return __builtin_ffs((Sint)uffs_gp.a);
}

static Sint
uffs_global_struct_b()
{
  return __builtin_ffs((Sint)uffs_gp.b);
}

static Sint
ffs_global_struct_three()
{
  return __builtin_ffs(ffs_gt.c);
}

/*
 * Constants.  These may fold at compile time, but they document the
 * semantic boundary cases.
 */

static Sint
ffs_const_zero()
{
  return __builtin_ffs(0);
}

static Sint
ffs_const_one()
{
  return __builtin_ffs(1);
}

static Sint
ffs_const_two()
{
  return __builtin_ffs(2);
}

static Sint
ffs_const_four()
{
  return __builtin_ffs(4);
}

static Sint
ffs_const_400()
{
  return __builtin_ffs(0400);
}

static Sint
ffs_const_1000()
{
  return __builtin_ffs(01000);
}

static Sint
ffs_const_right_high()
{
  return __builtin_ffs(0400000);
}

static Sint
ffs_const_halfword()
{
  return __builtin_ffs(01000000);
}

static Sint
ffs_const_left_low()
{
  return __builtin_ffs(0100000000000);
}

static Sint
ffs_const_signbit()
{
  return __builtin_ffs(0400000000000);
}

static Sint
ffs_const_allones()
{
  return __builtin_ffs(0777777777777);
}

static Sint
ffs_const_pattern()
{
  return __builtin_ffs(0123456123456);
}

static Sint
ffs_const_minus_one()
{
  return __builtin_ffs(-1);
}

static Sint
ffs_const_minus_two()
{
  return __builtin_ffs(-2);
}

static Sint
ffs_const_minus_power()
{
  return __builtin_ffs(-01000);
}

/*
 * Values with known low-bit positions.
 */

static Sint
ffs_lowbit_0(a)
Sint a;
{
  return __builtin_ffs(a | 1);
}

static Sint
ffs_lowbit_1(a)
Sint a;
{
  return __builtin_ffs((a << 1) | 2);
}

static Sint
ffs_lowbit_2(a)
Sint a;
{
  return __builtin_ffs((a << 2) | 4);
}

static Sint
ffs_lowbit_8(a)
Sint a;
{
  return __builtin_ffs((a << 9) | 0400);
}

static Sint
ffs_lowbit_9(a)
Sint a;
{
  return __builtin_ffs((a << 10) | 01000);
}

static Sint
ffs_lowbit_17(a)
Sint a;
{
  return __builtin_ffs((a << 18) | 0400000);
}

static Sint
ffs_lowbit_18(a)
Sint a;
{
  return __builtin_ffs((a << 19) | 01000000);
}

static Sint
ffs_lowbit_35(a)
Sint a;
{
  return __builtin_ffs((a & 1) << 35);
}

static Sint
uffs_lowbit_35(a)
uSint a;
{
  return __builtin_ffs((Sint)((a & 1) << 35));
}

/*
 * Isolate-lowbit idioms around ffs.  The backend expansion itself also
 * uses x & -x before JFFO, so these forms catch duplicate or missed
 * simplifications.
 */

static Sint
ffs_isolated(a)
Sint a;
{
  Sint x;

  x = a & -a;
  return __builtin_ffs(x);
}

static Sint
uffs_isolated(a)
uSint a;
{
  uSint x;

  x = a & -a;
  return __builtin_ffs((Sint)x);
}

static Sint
ffs_isolated_mem(p)
Sint *p;
{
  Sint x;

  x = *p;
  x = x & -x;
  return __builtin_ffs(x);
}

static Sint
ffs_isolated_global()
{
  Sint x;

  x = ffs_ga;
  x = x & -x;
  return __builtin_ffs(x);
}

static Sint
ffs_masked_low(a)
Sint a;
{
  Sint x;

  x = a & 0777777;
  return __builtin_ffs(x);
}

static Sint
ffs_masked_high(a)
Sint a;
{
  Sint x;

  x = a & 0777777000000;
  return __builtin_ffs(x);
}

static Sint
ffs_masked_sign(a)
Sint a;
{
  Sint x;

  x = a & 0400000000000;
  return __builtin_ffs(x);
}

static Sint
ffs_shifted_mask(a, n)
Sint a;
Sint n;
{
  Sint x;

  x = (a & 0777777) << n;
  return __builtin_ffs(x);
}

/*
 * Store result forms.
 */

static void
ffs_store_ptr(dst, a)
Sint *dst;
Sint a;
{
  *dst = __builtin_ffs(a);
}

static Sint
ffs_store_ptr_return(dst, a)
Sint *dst;
Sint a;
{
  return *dst = __builtin_ffs(a);
}

static void
ffs_store_global(a)
Sint a;
{
  ffs_ga = __builtin_ffs(a);
}

static Sint
ffs_store_global_return(a)
Sint a;
{
  return ffs_ga = __builtin_ffs(a);
}

static void
ffs_store_array(i, a)
Sint i;
Sint a;
{
  ffs_buf[i & 017] = __builtin_ffs(a);
}

static Sint
ffs_store_array_return(i, a)
Sint i;
Sint a;
{
  return ffs_buf[i & 017] = __builtin_ffs(a);
}

static void
uffs_store_ptr(dst, a)
Sint *dst;
uSint a;
{
  *dst = __builtin_ffs((Sint)a);
}

static Sint
uffs_store_ptr_return(dst, a)
Sint *dst;
uSint a;
{
  return *dst = __builtin_ffs((Sint)a);
}

/*
 * Result-use forms.
 */

static Sint
ffs_plus(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(a) + b;
}

static Sint
ffs_minus(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(a) - b;
}

static Sint
ffs_mul(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(a) * b;
}

static Sint
ffs_xor(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(a) ^ b;
}

static Sint
ffs_or(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(a) | b;
}

static Sint
ffs_and(a, b)
Sint a;
Sint b;
{
  return __builtin_ffs(a) & b;
}

static Sint
ffs_twice(a, b)
Sint a;
Sint b;
{
  Sint x;
  Sint y;

  x = __builtin_ffs(a);
  y = __builtin_ffs(b);
  return x + y;
}

static Sint
ffs_nested(a)
Sint a;
{
  Sint x;

  x = __builtin_ffs(a);
  return __builtin_ffs(x);
}

static Sint
ffs_index_array(a)
Sint a;
{
  Sint i;

  i = __builtin_ffs(a);
  return ffs_buf[i & 017];
}

static Sint
ffs_shift_result(a)
Sint a;
{
  Sint n;

  n = __builtin_ffs(a);
  return 1 << n;
}

static Sint
ffs_shift_input(a, n)
Sint a;
Sint n;
{
  Sint x;

  x = a << n;
  return __builtin_ffs(x) + n;
}

/*
 * Branch and compare uses after ffs.
 */

static Sint
ffs_eq_zero(a)
Sint a;
{
  return __builtin_ffs(a) == 0;
}

static Sint
ffs_ne_zero(a)
Sint a;
{
  return __builtin_ffs(a) != 0;
}

static Sint
ffs_eq_one(a)
Sint a;
{
  return __builtin_ffs(a) == 1;
}

static Sint
ffs_gt_one(a)
Sint a;
{
  return __builtin_ffs(a) > 1;
}

static Sint
ffs_lt_18(a)
Sint a;
{
  return __builtin_ffs(a) < 18;
}

static Sint
ffs_ge_18(a)
Sint a;
{
  return __builtin_ffs(a) >= 18;
}

static Sint
ffs_if_zero(a)
Sint a;
{
  if (__builtin_ffs(a) == 0)
    return 0;
  return 1;
}

static Sint
ffs_if_nonzero(a)
Sint a;
{
  if (__builtin_ffs(a) != 0)
    return 1;
  return 0;
}

static Sint
ffs_if_low(a)
Sint a;
{
  if (__builtin_ffs(a) <= 9)
    return -1;
  return 1;
}

static Sint
ffs_if_high(a)
Sint a;
{
  if (__builtin_ffs(a) > 18)
    return 1;
  return -1;
}

static Sint
ffs_range(a)
Sint a;
{
  Sint x;

  x = __builtin_ffs(a);
  if (x == 0)
    return 0;
  if (x < 18)
    return -1;
  if (x > 18)
    return 1;
  return 18;
}

/*
 * Unsigned branch/value pressure.
 */

static Sint
uffs_eq_zero(a)
uSint a;
{
  return __builtin_ffs((Sint)a) == 0;
}

static Sint
uffs_ne_zero(a)
uSint a;
{
  return __builtin_ffs((Sint)a) != 0;
}

static Sint
uffs_gt_18(a)
uSint a;
{
  return __builtin_ffs((Sint)a) > 18;
}

static Sint
uffs_if_highbit(a)
uSint a;
{
  if (__builtin_ffs((Sint)(a | 0400000000000)) > 18)
    return 1;
  return -1;
}

static Sint
uffs_range(a)
uSint a;
{
  Sint x;

  x = __builtin_ffs((Sint)a);
  if (x == 0)
    return 0;
  if (x < 18)
    return -1;
  if (x > 18)
    return 1;
  return 18;
}

/*
 * Promoted QI/HI operands.
 */

static Sint
ffs_qi(a)
Qint a;
{
  return __builtin_ffs((Sint)a);
}

static Sint
ffs_uqi(a)
uQint a;
{
  return __builtin_ffs((Sint)a);
}

static Sint
ffs_hi(a)
Hint a;
{
  return __builtin_ffs((Sint)a);
}

static Sint
ffs_uhi(a)
uHint a;
{
  return __builtin_ffs((Sint)a);
}

static Sint
ffs_qi_plus(a, b)
Qint a;
Sint b;
{
  return __builtin_ffs((Sint)a) + b;
}

static Sint
ffs_uqi_plus(a, b)
uQint a;
Sint b;
{
  return __builtin_ffs((Sint)a) + b;
}

static Sint
ffs_hi_plus(a, b)
Hint a;
Sint b;
{
  return __builtin_ffs((Sint)a) + b;
}

static Sint
ffs_uhi_plus(a, b)
uHint a;
Sint b;
{
  return __builtin_ffs((Sint)a) + b;
}

static Sint
ffs_qi_if(a)
Qint a;
{
  if (__builtin_ffs((Sint)a) == 0)
    return 0;
  return 1;
}

static Sint
ffs_hi_if(a)
Hint a;
{
  if (__builtin_ffs((Sint)a) > 9)
    return 1;
  return -1;
}

/*
 * Multi-branch forms.
 */

static Sint
ffs_switch_like(a)
Sint a;
{
  Sint x;

  x = __builtin_ffs(a);
  if (x == 0)
    return 0;
  if (x == 1)
    return 10;
  if (x == 18)
    return 180;
  if (x == 36)
    return 360;
  return x;
}

static Sint
ffs_select_value(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (__builtin_ffs(a) < __builtin_ffs(b))
    return b;
  return c;
}

static Sint
ffs_loop_mask(a)
Sint a;
{
  Sint n;
  Sint s;

  n = __builtin_ffs(a);
  s = 0;
  while (n > 0) {
    s += n;
    n = n - 1;
  }
  return s;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static Sint
ffs_after_call(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  return __builtin_ffs(x);
}

static Sint
ffs_store_after_call(p)
Sint *p;
{
  Sint x;

  x = f();
  clobber();
  return *p = __builtin_ffs(x);
}

static Sint
ffs_global_after_call()
{
  Sint x;

  clobber();
  x = ffs_ga;
  return __builtin_ffs(x);
}

static Sint
ffs_volatile_after_call()
{
  Sint x;

  clobber();
  x = ffs_vga;
  return __builtin_ffs(x);
}

static Sint
uffs_after_call(p)
uSint *p;
{
  uSint x;

  x = *p;
  clobber();
  return __builtin_ffs((Sint)x);
}

static Sint
ffs_two_calls()
{
  Sint a;
  Sint b;

  a = f();
  b = f();
  return __builtin_ffs(a) + __builtin_ffs(b);
}

static Sint
uffs_two_calls()
{
  uSint a;
  uSint b;

  a = uf();
  b = uf();
  return __builtin_ffs((Sint)a) ^ __builtin_ffs((Sint)b);
}
