#include "insns.h"

/*
 * SImode subtraction pattern pressure for PDP-6/166 and KA10.
 *
 * Intended forms include:
 *   SUB    AC <- AC - E
 *   SUBI   AC <- AC - immediate / right-half address-shaped value
 *   SUBM   E  <- AC - E
 *   SUBB   AC <- AC - E, E <- AC - E
 *
 * This is a pattern-level test, not a duplicate of insn/SUB.c.
 * Keep it centered on RTL minus:SI shapes.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint subsi3_ga;
static Sint subsi3_gb;
static Sint subsi3_gc;
static volatile Sint subsi3_vga;
static Sint subsi3_buf[16];

static uSint usubsi3_ga;
static uSint usubsi3_gb;
static volatile uSint usubsi3_vga;
static uSint usubsi3_buf[16];

struct subsi3_pair {
  Sint a;
  Sint b;
};

struct subsi3_three {
  Sint a;
  Sint b;
  Sint c;
};

struct usubsi3_pair {
  uSint a;
  uSint b;
};

static struct subsi3_pair subsi3_gp;
static struct subsi3_three subsi3_gt;
static struct usubsi3_pair usubsi3_gp;

/*
 * Basic register/register and expression forms.
 */

static Sint
subsi3(a, b)
Sint a;
Sint b;
{
  return a - b;
}

static Sint
sub_reg_reg(a, b)
Sint a;
Sint b;
{
  return a - b;
}

static uSint
usub_reg_reg(a, b)
uSint a;
uSint b;
{
  return a - b;
}

static Sint
sub_local(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  return x;
}

static Sint
sub_reuse_left(a, b)
Sint a;
Sint b;
{
  a = a - b;
  return a;
}

static Sint
sub_reuse_right(a, b)
Sint a;
Sint b;
{
  b = a - b;
  return b;
}

static Sint
sub_chain(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a - b;
  return x - c;
}

static Sint
sub_from_add(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = a + b;
  return x - c;
}

static Sint
sub_from_call(a)
Sint a;
{
  return f() - a;
}

static Sint
sub_call_rhs(a)
Sint a;
{
  return a - f();
}

static uSint
usub_from_call(a)
uSint a;
{
  return uf() - a;
}

/*
 * Register minus memory forms.
 */

static Sint
sub_reg_mem(a, p)
Sint a;
Sint *p;
{
  return a - *p;
}

static Sint
sub_mem_reg(p, a)
Sint *p;
Sint a;
{
  return *p - a;
}

static Sint
sub_mem_mem(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint b;

  a = *p;
  b = *q;
  return a - b;
}

static Sint
sub_volatile_mem(a, p)
Sint a;
volatile Sint *p;
{
  return a - *p;
}

static Sint
sub_mem_volatile(p, a)
volatile Sint *p;
Sint a;
{
  return *p - a;
}

static Sint
sub_global_reg(a)
Sint a;
{
  return subsi3_ga - a;
}

static Sint
sub_reg_global(a)
Sint a;
{
  return a - subsi3_gb;
}

static Sint
sub_volatile_global(a)
Sint a;
{
  return a - subsi3_vga;
}

static uSint
usub_global_reg(a)
uSint a;
{
  return usubsi3_ga - a;
}

static uSint
usub_reg_global(a)
uSint a;
{
  return a - usubsi3_gb;
}

static uSint
usub_volatile_global(a)
uSint a;
{
  return a - usubsi3_vga;
}

/*
 * Array and struct addressing pressure.
 */

static Sint
sub_array_reg(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  return v[i & 017] - a;
}

static Sint
sub_reg_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a - v[i & 017];
}

static Sint
sub_global_array(i, a)
Sint i;
Sint a;
{
  return subsi3_buf[i & 017] - a;
}

static Sint
sub_reg_global_array(a, i)
Sint a;
Sint i;
{
  return a - subsi3_buf[i & 017];
}

static uSint
usub_array_reg(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  return v[i & 017] - a;
}

static uSint
usub_reg_array(a, v, i)
uSint a;
uSint *v;
Sint i;
{
  return a - v[i & 017];
}

static uSint
usub_global_array(i, a)
Sint i;
uSint a;
{
  return usubsi3_buf[i & 017] - a;
}

static Sint
sub_struct_a(p, x)
struct subsi3_pair *p;
Sint x;
{
  return p->a - x;
}

static Sint
sub_struct_b(p, x)
struct subsi3_pair *p;
Sint x;
{
  return x - p->b;
}

static Sint
sub_struct_two(p)
struct subsi3_pair *p;
{
  return p->a - p->b;
}

static Sint
sub_struct_three(p)
struct subsi3_three *p;
{
  return p->a - p->b - p->c;
}

static Sint
sub_global_struct_a(x)
Sint x;
{
  return subsi3_gp.a - x;
}

static Sint
sub_global_struct_b(x)
Sint x;
{
  return x - subsi3_gp.b;
}

static Sint
sub_global_struct_three()
{
  return subsi3_gt.a - subsi3_gt.c;
}

static uSint
usub_global_struct_a(x)
uSint x;
{
  return usubsi3_gp.a - x;
}

/*
 * Constant RHS forms.  Small right-half constants should be SUBI-like.
 * Large constants should force the ordinary literal/general path.
 */

static Sint
subi_zero(a)
Sint a;
{
  return a - 0;
}

static Sint
subi_one(a)
Sint a;
{
  return a - 1;
}

static Sint
subi_two(a)
Sint a;
{
  return a - 2;
}

static Sint
subi_small(a)
Sint a;
{
  return a - 012345;
}

static Sint
subi_right_max(a)
Sint a;
{
  return a - 0777777;
}

static Sint
subi_left_const(a)
Sint a;
{
  return a - 0123456000000;
}

static Sint
subi_full_const(a)
Sint a;
{
  return a - 0123456123456;
}

static Sint
subi_minus_one(a)
Sint a;
{
  return a - -1;
}

static Sint
subi_minus_small(a)
Sint a;
{
  return a - -012345;
}

static uSint
usubi_one(a)
uSint a;
{
  return a - 1;
}

static uSint
usubi_right_max(a)
uSint a;
{
  return a - 0777777;
}

static uSint
usubi_full_const(a)
uSint a;
{
  return a - 0123456123456;
}

/*
 * SUBI special shapes from right-half extraction.
 */

static Sint
sub_right_half(a, b)
Sint a;
Sint b;
{
  return a - (b & 0777777);
}

static Sint
sub_right_half_plus(a, b)
Sint a;
Sint b;
{
  return a - ((b + 0123) & 0777777);
}

static Sint
sub_right_half_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a - (v[i & 017] & 0777777);
}

static uSint
usub_right_half(a, b)
uSint a;
uSint b;
{
  return a - (b & 0777777);
}

static uSint
usub_right_half_plus(a, b)
uSint a;
uSint b;
{
  return a - ((b + 0123) & 0777777);
}

/*
 * Store forms.  The inverse store forms are meant to pressure SUBM
 * and SUBB: memory receives AC - memory, optionally also returning the
 * assigned value.
 */

static void
sub_store_plain(p, a)
Sint *p;
Sint a;
{
  *p = *p - a;
}

static void
sub_store_inverse(p, a)
Sint *p;
Sint a;
{
  *p = a - *p;
}

static Sint
sub_store_inverse_return(p, a)
Sint *p;
Sint a;
{
  return *p = a - *p;
}

static void
sub_store_global(a)
Sint a;
{
  subsi3_ga = subsi3_ga - a;
}

static void
sub_store_global_inverse(a)
Sint a;
{
  subsi3_ga = a - subsi3_ga;
}

static Sint
sub_store_global_inverse_return(a)
Sint a;
{
  return subsi3_ga = a - subsi3_ga;
}

static void
sub_store_array(i, a)
Sint i;
Sint a;
{
  subsi3_buf[i & 017] = subsi3_buf[i & 017] - a;
}

static void
sub_store_array_inverse(i, a)
Sint i;
Sint a;
{
  subsi3_buf[i & 017] = a - subsi3_buf[i & 017];
}

static Sint
sub_store_array_inverse_return(i, a)
Sint i;
Sint a;
{
  return subsi3_buf[i & 017] = a - subsi3_buf[i & 017];
}

static void
sub_store_struct_a(p, x)
struct subsi3_pair *p;
Sint x;
{
  p->a = x - p->a;
}

static Sint
sub_store_struct_a_return(p, x)
struct subsi3_pair *p;
Sint x;
{
  return p->a = x - p->a;
}

static void
usub_store_inverse(p, a)
uSint *p;
uSint a;
{
  *p = a - *p;
}

static uSint
usub_store_inverse_return(p, a)
uSint *p;
uSint a;
{
  return *p = a - *p;
}

/*
 * Decrement-like subtraction forms.  These may combine with SOS-family
 * optimizations, which sit next to the subsi3 patterns in pdp10.md.
 */

static void
sub_dec_mem(p)
Sint *p;
{
  *p = *p - 1;
}

static Sint
sub_dec_mem_return(p)
Sint *p;
{
  return *p = *p - 1;
}

static void
sub_dec_global()
{
  subsi3_gc = subsi3_gc - 1;
}

static Sint
sub_dec_global_return()
{
  return subsi3_gc = subsi3_gc - 1;
}

static void
sub_dec_array(i)
Sint i;
{
  subsi3_buf[i & 017] = subsi3_buf[i & 017] - 1;
}

static Sint
sub_dec_array_return(i)
Sint i;
{
  return subsi3_buf[i & 017] = subsi3_buf[i & 017] - 1;
}

/*
 * Branch and compare uses after subtraction.
 */

static Sint
sub_eq_zero(a, b)
Sint a;
Sint b;
{
  return (a - b) == 0;
}

static Sint
sub_ne_zero(a, b)
Sint a;
Sint b;
{
  return (a - b) != 0;
}

static Sint
sub_lt_zero(a, b)
Sint a;
Sint b;
{
  return (a - b) < 0;
}

static Sint
sub_ge_zero(a, b)
Sint a;
Sint b;
{
  return (a - b) >= 0;
}

static Sint
sub_gt_const(a, b)
Sint a;
Sint b;
{
  return (a - b) > 0123;
}

static Sint
sub_range(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

/*
 * Volatile/call barriers to keep memory forms alive in a few cases.
 */

static Sint
sub_after_call(p)
Sint *p;
{
  Sint x;

  x = *p;
  clobber();
  return f() - x;
}

static Sint
sub_store_after_call(p)
Sint *p;
{
  Sint x;

  x = f();
  clobber();
  return *p = x - *p;
}

static Sint
sub_global_after_call()
{
  Sint x;

  x = f();
  clobber();
  return x - subsi3_ga;
}
