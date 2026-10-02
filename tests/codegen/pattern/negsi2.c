#include "insns.h"

/*
 * SImode negation pattern pressure for PDP-6/166 and KA10.
 *
 * Intended forms include:
 *   MOVN    AC <- -E
 *   MOVNM   E  <- -AC
 *   MOVNI   AC <- -immediate / address-shaped right-half value
 *   MOVNS   AC or E <- -same-place operand
 *
 * Extra backend shapes:
 *   MOVNI from -(x & RIGHT_HALF)
 *   MOVNI from -((x + const) & RIGHT_HALF)
 *   MOVNS with memory update and result value
 *
 * This is a pattern-level test, not a duplicate of insn/MOVN.c.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint negsi2_ga;
static Sint negsi2_gb;
static Sint negsi2_gc;
static volatile Sint negsi2_vga;
static Sint negsi2_buf[16];

static uSint unegsi2_ga;
static volatile uSint unegsi2_vga;
static uSint unegsi2_buf[16];

struct negsi2_pair {
  Sint a;
  Sint b;
};

struct negsi2_three {
  Sint a;
  Sint b;
  Sint c;
};

struct unegsi2_pair {
  uSint a;
  uSint b;
};

static struct negsi2_pair negsi2_gp;
static struct negsi2_three negsi2_gt;
static struct unegsi2_pair unegsi2_gp;

/*
 * Basic register and expression forms.
 */

static Sint
negsi2(a)
Sint a;
{
  return -a;
}

static Sint
neg_arg(a)
Sint a;
{
  return -a;
}

static uSint
uneg_arg(a)
uSint a;
{
  return -a;
}

static Sint
neg_second_arg(a, b)
Sint a;
Sint b;
{
  return -b;
}

static Sint
neg_local(a)
Sint a;
{
  Sint x;

  x = -a;
  return x;
}

static Sint
neg_reuse(a)
Sint a;
{
  a = -a;
  return a;
}

static Sint
neg_after_add(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  return -x;
}

static Sint
neg_after_sub(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  return -x;
}

static Sint
neg_after_mul(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a * b;
  return -x;
}

static Sint
neg_after_xor(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  return -x;
}

static Sint
neg_call()
{
  return -f();
}

static Sint
neg_call_plus(a)
Sint a;
{
  return -f() + a;
}

static uSint
uneg_call()
{
  return -uf();
}

/*
 * Memory, globals, volatile, arrays, and structs.
 */

static Sint
neg_mem(p)
Sint *p;
{
  return -*p;
}

static Sint
neg_mem_local(p)
Sint *p;
{
  Sint x;

  x = -*p;
  return x;
}

static Sint
neg_volatile_mem(p)
volatile Sint *p;
{
  return -*p;
}

static Sint
neg_global()
{
  return -negsi2_ga;
}

static Sint
neg_global_b()
{
  return -negsi2_gb;
}

static Sint
neg_volatile_global()
{
  return -negsi2_vga;
}

static uSint
uneg_global()
{
  return -unegsi2_ga;
}

static uSint
uneg_volatile_global()
{
  return -unegsi2_vga;
}

static Sint
neg_array(i)
Sint i;
{
  return -negsi2_buf[i & 017];
}

static Sint
neg_ptr_array(p, i)
Sint *p;
Sint i;
{
  return -p[i & 017];
}

static uSint
uneg_array(i)
Sint i;
{
  return -unegsi2_buf[i & 017];
}

static Sint
neg_struct_a(p)
struct negsi2_pair *p;
{
  return -p->a;
}

static Sint
neg_struct_b(p)
struct negsi2_pair *p;
{
  return -p->b;
}

static Sint
neg_struct_sum(p)
struct negsi2_pair *p;
{
  return -(p->a + p->b);
}

static Sint
neg_struct_three(p)
struct negsi2_three *p;
{
  return -(p->a - p->b + p->c);
}

static Sint
neg_global_struct_a()
{
  return -negsi2_gp.a;
}

static Sint
neg_global_struct_b()
{
  return -negsi2_gp.b;
}

static Sint
neg_global_struct_c()
{
  return -negsi2_gt.c;
}

static uSint
uneg_global_struct_a()
{
  return -unegsi2_gp.a;
}

/*
 * Constant forms.  These should pressure MOVNI-like materialization
 * when the compiler does not fold to an equally cheap move sequence.
 */

static Sint
neg_const_zero()
{
  return -0;
}

static Sint
neg_const_one()
{
  return -1;
}

static Sint
neg_const_two()
{
  return -2;
}

static Sint
neg_const_small()
{
  return -012345;
}

static Sint
neg_const_right_max()
{
  return -0777777;
}

static Sint
neg_const_left()
{
  return -0123456000000;
}

static Sint
neg_const_full()
{
  return -0123456123456;
}

static uSint
uneg_const_one()
{
  return -1;
}

static uSint
uneg_const_right_max()
{
  return -0777777;
}

/*
 * MOVNI special shapes:
 *
 *   -(x & 0777777)
 *   -((x + const) & 0777777)
 *
 * These correspond to the backend's address-shaped MOVNI helpers.
 */

static Sint
neg_right_half(a)
Sint a;
{
  return -(a & 0777777);
}

static Sint
neg_right_half_mem(p)
Sint *p;
{
  return -(*p & 0777777);
}

static Sint
neg_right_half_global()
{
  return -(negsi2_ga & 0777777);
}

static Sint
neg_right_half_plus(a)
Sint a;
{
  return -((a + 0123) & 0777777);
}

static Sint
neg_right_half_plus_big(a)
Sint a;
{
  return -((a + 0777) & 0777777);
}

static Sint
neg_right_half_array(i)
Sint i;
{
  return -((negsi2_buf[i & 017] + 0123) & 0777777);
}

static uSint
uneg_right_half(a)
uSint a;
{
  return -(a & 0777777);
}

static uSint
uneg_right_half_plus(a)
uSint a;
{
  return -((a + 0123) & 0777777);
}

/*
 * Store forms: MOVNM-like output.
 */

static void
neg_store_ptr(dst, a)
Sint *dst;
Sint a;
{
  *dst = -a;
}

static Sint
neg_store_ptr_return(dst, a)
Sint *dst;
Sint a;
{
  return *dst = -a;
}

static void
neg_store_global(a)
Sint a;
{
  negsi2_ga = -a;
}

static Sint
neg_store_global_return(a)
Sint a;
{
  return negsi2_ga = -a;
}

static void
neg_store_array(i, a)
Sint i;
Sint a;
{
  negsi2_buf[i & 017] = -a;
}

static Sint
neg_store_array_return(i, a)
Sint i;
Sint a;
{
  return negsi2_buf[i & 017] = -a;
}

static void
neg_store_struct_a(p, a)
struct negsi2_pair *p;
Sint a;
{
  p->a = -a;
}

static Sint
neg_store_struct_a_return(p, a)
struct negsi2_pair *p;
Sint a;
{
  return p->a = -a;
}

static void
uneg_store_ptr(dst, a)
uSint *dst;
uSint a;
{
  *dst = -a;
}

static uSint
uneg_store_ptr_return(dst, a)
uSint *dst;
uSint a;
{
  return *dst = -a;
}

/*
 * In-place negation: MOVNS-like output.
 */

static void
neg_inplace_ptr(p)
Sint *p;
{
  *p = -*p;
}

static Sint
neg_inplace_ptr_return(p)
Sint *p;
{
  return *p = -*p;
}

static void
neg_inplace_global()
{
  negsi2_ga = -negsi2_ga;
}

static Sint
neg_inplace_global_return()
{
  return negsi2_ga = -negsi2_ga;
}

static void
neg_inplace_array(i)
Sint i;
{
  negsi2_buf[i & 017] = -negsi2_buf[i & 017];
}

static Sint
neg_inplace_array_return(i)
Sint i;
{
  return negsi2_buf[i & 017] = -negsi2_buf[i & 017];
}

static void
neg_inplace_struct_a(p)
struct negsi2_pair *p;
{
  p->a = -p->a;
}

static Sint
neg_inplace_struct_a_return(p)
struct negsi2_pair *p;
{
  return p->a = -p->a;
}

static void
uneg_inplace_ptr(p)
uSint *p;
{
  *p = -*p;
}

static uSint
uneg_inplace_ptr_return(p)
uSint *p;
{
  return *p = -*p;
}

static void
uneg_inplace_global()
{
  unegsi2_ga = -unegsi2_ga;
}

static uSint
uneg_inplace_global_return()
{
  return unegsi2_ga = -unegsi2_ga;
}

/*
 * Mixed expressions where negation result stays live.
 */

static Sint
neg_plus(a, b)
Sint a;
Sint b;
{
  return -a + b;
}

static Sint
neg_minus(a, b)
Sint a;
Sint b;
{
  return -a - b;
}

static Sint
neg_xor(a, b)
Sint a;
Sint b;
{
  return -a ^ b;
}

static Sint
neg_and(a, b)
Sint a;
Sint b;
{
  return -a & b;
}

static Sint
neg_or(a, b)
Sint a;
Sint b;
{
  return -a | b;
}

static Sint
neg_shift_left(a)
Sint a;
{
  return -a << 1;
}

static Sint
neg_shift_right(a)
Sint a;
{
  return -a >> 1;
}

static Sint
neg_sum3(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return -a + -b + -c;
}

static Sint
neg_mem_mix(p, a)
Sint *p;
Sint a;
{
  return -*p + -a;
}

static Sint
neg_array_mix(i, a)
Sint i;
Sint a;
{
  return -negsi2_buf[i & 017] ^ -a;
}

/*
 * Branch and compare uses after negation.
 */

static Sint
neg_eq_zero(a)
Sint a;
{
  return -a == 0;
}

static Sint
neg_ne_zero(a)
Sint a;
{
  return -a != 0;
}

static Sint
neg_lt_zero(a)
Sint a;
{
  return -a < 0;
}

static Sint
neg_ge_zero(a)
Sint a;
{
  return -a >= 0;
}

static Sint
neg_gt_const(a)
Sint a;
{
  return -a > 0123;
}

static Sint
neg_range(a)
Sint a;
{
  Sint x;

  x = -a;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

static Sint
neg_mem_eq_zero(p)
Sint *p;
{
  return -*p == 0;
}

static Sint
neg_inplace_branch(p)
Sint *p;
{
  Sint x;

  x = (*p = -*p);
  return x < 0;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static Sint
neg_after_call(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  return -x;
}

static Sint
neg_call_after_load(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  return -f() + x;
}

static Sint
neg_store_after_call(p)
Sint *p;
{
  Sint x;

  x = f();
  clobber();
  return *p = -x;
}

static Sint
neg_global_after_call()
{
  Sint x;

  x = f();
  clobber();
  return -x + negsi2_ga;
}

static Sint
neg_inplace_after_call(p)
Sint *p;
{
  clobber();
  return *p = -*p;
}
