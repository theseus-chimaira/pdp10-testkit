#include "insns.h"

/*
 * SImode multiplication pattern pressure for PDP-6/166 and KA10.
 *
 * Intended forms include:
 *   IMUL    AC <- AC * E
 *   IMULI   AC <- AC * immediate / address-shaped right-half value
 *   IMUL    AC <- AC * [literal]
 *   IMULM   E  <- AC * E
 *   IMULB   AC <- AC * E, E <- AC * E
 *
 * This is a pattern-level test, not a duplicate of insn/IMUL.c.
 * Keep it centered on RTL mult:SI shapes.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint mulsi3_ga;
static Sint mulsi3_gb;
static Sint mulsi3_gc;
static volatile Sint mulsi3_vga;
static Sint mulsi3_buf[16];

static uSint umulsi3_ga;
static uSint umulsi3_gb;
static volatile uSint umulsi3_vga;
static uSint umulsi3_buf[16];

struct mulsi3_pair {
  Sint a;
  Sint b;
};

struct mulsi3_three {
  Sint a;
  Sint b;
  Sint c;
};

struct umulsi3_pair {
  uSint a;
  uSint b;
};

static struct mulsi3_pair mulsi3_gp;
static struct mulsi3_three mulsi3_gt;
static struct umulsi3_pair umulsi3_gp;

/*
 * Basic register/register and expression forms.
 */

static Sint
mulsi3(a, b)
Sint a;
Sint b;
{
  return a * b;
}

static Sint
mul_reg_reg(a, b)
Sint a;
Sint b;
{
  return a * b;
}

static uSint
umul_reg_reg(a, b)
uSint a;
uSint b;
{
  return a * b;
}

static Sint
mul_local(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a * b;
  return x;
}

static Sint
mul_reuse_left(a, b)
Sint a;
Sint b;
{
  a = a * b;
  return a;
}

static Sint
mul_reuse_right(a, b)
Sint a;
Sint b;
{
  b = a * b;
  return b;
}

static Sint
mul_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a * b;
  return x * c;
}

static Sint
mul_add_use(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a * b;
  return x + c;
}

static Sint
mul_sub_use(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a * b;
  return x - c;
}

static Sint
mul_xor_use(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a * b;
  return x ^ c;
}

static Sint
mul_from_call(a)
Sint a;
{
  return f() * a;
}

static Sint
mul_call_rhs(a)
Sint a;
{
  return a * f();
}

static uSint
umul_from_call(a)
uSint a;
{
  return uf() * a;
}

/*
 * Register/memory and memory/register forms.
 */

static Sint
mul_reg_mem(a, p)
Sint a;
Sint *p;
{
  return a * *p;
}

static Sint
mul_mem_reg(p, a)
Sint *p;
Sint a;
{
  return *p * a;
}

static Sint
mul_mem_mem(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint b;

  a = *p;
  b = *q;
  return a * b;
}

static Sint
mul_volatile_mem(a, p)
Sint a;
volatile Sint *p;
{
  return a * *p;
}

static Sint
mul_mem_volatile(p, a)
volatile Sint *p;
Sint a;
{
  return *p * a;
}

static Sint
mul_global_reg(a)
Sint a;
{
  return mulsi3_ga * a;
}

static Sint
mul_reg_global(a)
Sint a;
{
  return a * mulsi3_gb;
}

static Sint
mul_volatile_global(a)
Sint a;
{
  return a * mulsi3_vga;
}

static uSint
umul_global_reg(a)
uSint a;
{
  return umulsi3_ga * a;
}

static uSint
umul_reg_global(a)
uSint a;
{
  return a * umulsi3_gb;
}

static uSint
umul_volatile_global(a)
uSint a;
{
  return a * umulsi3_vga;
}

/*
 * Array and struct addressing pressure.
 */

static Sint
mul_array_reg(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return v[i & 017] * a;
}

static Sint
mul_reg_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a * v[i & 017];
}

static Sint
mul_global_array(i, a)
Sint i;
Sint a;
{
  return mulsi3_buf[i & 017] * a;
}

static Sint
mul_reg_global_array(a, i)
Sint a;
Sint i;
{
  return a * mulsi3_buf[i & 017];
}

static uSint
umul_array_reg(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  return v[i & 017] * a;
}

static uSint
umul_reg_array(a, v, i)
uSint a;
uSint *v;
Sint i;
{
  return a * v[i & 017];
}

static uSint
umul_global_array(i, a)
Sint i;
uSint a;
{
  return umulsi3_buf[i & 017] * a;
}

static Sint
mul_struct_a(p, x)
struct mulsi3_pair *p;
Sint x;
{
  return p->a * x;
}

static Sint
mul_struct_b(p, x)
struct mulsi3_pair *p;
Sint x;
{
  return x * p->b;
}

static Sint
mul_struct_two(p)
struct mulsi3_pair *p;
{
  return p->a * p->b;
}

static Sint
mul_struct_three(p)
struct mulsi3_three *p;
{
  return p->a * p->b * p->c;
}

static Sint
mul_global_struct_a(x)
Sint x;
{
  return mulsi3_gp.a * x;
}

static Sint
mul_global_struct_b(x)
Sint x;
{
  return x * mulsi3_gp.b;
}

static Sint
mul_global_struct_three()
{
  return mulsi3_gt.a * mulsi3_gt.c;
}

static uSint
umul_global_struct_a(x)
uSint x;
{
  return umulsi3_gp.a * x;
}

/*
 * Constant RHS forms.  Small constants should pressure IMULI.
 * Larger constants should pressure literal/general constant handling.
 */

static Sint
muli_zero(a)
Sint a;
{
  return a * 0;
}

static Sint
muli_one(a)
Sint a;
{
  return a * 1;
}

static Sint
muli_two(a)
Sint a;
{
  return a * 2;
}

static Sint
muli_three(a)
Sint a;
{
  return a * 3;
}

static Sint
muli_small(a)
Sint a;
{
  return a * 012345;
}

static Sint
muli_right_max(a)
Sint a;
{
  return a * 0777777;
}

static Sint
muli_left_const(a)
Sint a;
{
  return a * 0123456000000;
}

static Sint
muli_full_const(a)
Sint a;
{
  return a * 0123456123456;
}

static Sint
muli_minus_one(a)
Sint a;
{
  return a * -1;
}

static Sint
muli_minus_two(a)
Sint a;
{
  return a * -2;
}

static Sint
muli_minus_small(a)
Sint a;
{
  return a * -012345;
}

static uSint
umuli_one(a)
uSint a;
{
  return a * 1;
}

static uSint
umuli_two(a)
uSint a;
{
  return a * 2;
}

static uSint
umuli_right_max(a)
uSint a;
{
  return a * 0777777;
}

static uSint
umuli_full_const(a)
uSint a;
{
  return a * 0123456123456;
}

/*
 * IMULI address-shaped special cases from right-half extraction.
 */

static Sint
mul_right_half(a, b)
Sint a;
Sint b;
{
  return a * (b & 0777777);
}

static Sint
mul_right_half_commuted(a, b)
Sint a;
Sint b;
{
  return (b & 0777777) * a;
}

static Sint
mul_right_half_plus(a, b)
Sint a;
Sint b;
{
  return a * ((b + 0123) & 0777777);
}

static Sint
mul_right_half_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a * (v[i & 017] & 0777777);
}

static uSint
umul_right_half(a, b)
uSint a;
uSint b;
{
  return a * (b & 0777777);
}

static uSint
umul_right_half_plus(a, b)
uSint a;
uSint b;
{
  return a * ((b + 0123) & 0777777);
}

/*
 * Store forms.  These are meant to pressure IMULM and IMULB-like
 * memory/update cases, especially when the assigned value is also used.
 */

static void
mul_store_plain(p, a)
Sint *p;
Sint a;
{
  *p = *p * a;
}

static void
mul_store_commuted(p, a)
Sint *p;
Sint a;
{
  *p = a * *p;
}

static Sint
mul_store_return(p, a)
Sint *p;
Sint a;
{
  return *p = *p * a;
}

static Sint
mul_store_commuted_return(p, a)
Sint *p;
Sint a;
{
  return *p = a * *p;
}

static void
mul_store_global(a)
Sint a;
{
  mulsi3_ga = mulsi3_ga * a;
}

static void
mul_store_global_commuted(a)
Sint a;
{
  mulsi3_ga = a * mulsi3_ga;
}

static Sint
mul_store_global_return(a)
Sint a;
{
  return mulsi3_ga = mulsi3_ga * a;
}

static Sint
mul_store_global_commuted_return(a)
Sint a;
{
  return mulsi3_ga = a * mulsi3_ga;
}

static void
mul_store_array(i, a)
Sint i;
Sint a;
{
  mulsi3_buf[i & 017] = mulsi3_buf[i & 017] * a;
}

static void
mul_store_array_commuted(i, a)
Sint i;
Sint a;
{
  mulsi3_buf[i & 017] = a * mulsi3_buf[i & 017];
}

static Sint
mul_store_array_return(i, a)
Sint i;
Sint a;
{
  return mulsi3_buf[i & 017] = mulsi3_buf[i & 017] * a;
}

static Sint
mul_store_array_commuted_return(i, a)
Sint i;
Sint a;
{
  return mulsi3_buf[i & 017] = a * mulsi3_buf[i & 017];
}

static void
mul_store_struct_a(p, x)
struct mulsi3_pair *p;
Sint x;
{
  p->a = p->a * x;
}

static Sint
mul_store_struct_a_return(p, x)
struct mulsi3_pair *p;
Sint x;
{
  return p->a = x * p->a;
}

static void
umul_store_plain(p, a)
uSint *p;
uSint a;
{
  *p = *p * a;
}

static uSint
umul_store_return(p, a)
uSint *p;
uSint a;
{
  return *p = a * *p;
}

/*
 * Multiplication by powers of two may be strength-reduced by the
 * compiler.  Keep these here because they are still useful review
 * cases, but do not require them to produce IMULI when blessing.
 */

static Sint
mul_pow2_2(a)
Sint a;
{
  return a * 2;
}

static Sint
mul_pow2_4(a)
Sint a;
{
  return a * 4;
}

static Sint
mul_pow2_8(a)
Sint a;
{
  return a * 8;
}

static Sint
mul_pow2_16(a)
Sint a;
{
  return a * 16;
}

static uSint
umul_pow2_4(a)
uSint a;
{
  return a * 4;
}

/*
 * Branch and compare uses after multiplication.
 */

static Sint
mul_eq_zero(a, b)
Sint a;
Sint b;
{
  return (a * b) == 0;
}

static Sint
mul_ne_zero(a, b)
Sint a;
Sint b;
{
  return (a * b) != 0;
}

static Sint
mul_lt_zero(a, b)
Sint a;
Sint b;
{
  return (a * b) < 0;
}

static Sint
mul_ge_zero(a, b)
Sint a;
Sint b;
{
  return (a * b) >= 0;
}

static Sint
mul_gt_const(a, b)
Sint a;
Sint b;
{
  return (a * b) > 0123;
}

static Sint
mul_range(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a * b;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

/*
 * Volatile/call barriers to keep selected memory forms alive.
 */

static Sint
mul_after_call(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  return f() * x;
}

static Sint
mul_store_after_call(p)
Sint *p;
{
  Sint x;

  x = f();
  clobber();
  return *p = x * *p;
}

static Sint
mul_global_after_call()
{
  Sint x;

  x = f();
  clobber();
  return x * mulsi3_ga;
}
