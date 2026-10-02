#include "insns.h"

/*
 * addsi3 pattern coverage for PDP-6/166 and KA10.
 *
 * This is a pattern-level test, not a duplicate of insn/ADD.c.
 * Keep it centered on RTL plus:SI shapes:
 *
 *   reg  = reg + reg
 *   reg  = reg + mem
 *   reg  = mem + reg
 *   reg  = reg + small positive const      ADDI
 *   reg  = reg + small negative const      SUBI form
 *   reg  = reg + large const               literal ADD
 *   mem  = mem + reg                       ADDM-style
 *   mem  = mem + 1                         AOS-style
 *   mem  = mem - 1                         SOS-style
 *
 * subsi3 has its own file.  Only negative constants are kept here
 * because the addsi3 pattern itself maps them to the SUBI alternative.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint addsi3_ga;
static Sint addsi3_gb;
static Sint addsi3_buf[16];

struct addsi3_pair {
  Sint a;
  Sint b;
};

struct addsi3_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct addsi3_pair addsi3_gp;
static struct addsi3_three addsi3_gt;

static Sint
add_reg_reg(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a + b;
}

static uSint
add_ureg_ureg(a, b)
uSint a;
uSint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a + b;
}

static Sint
add_reg_mem(a, p)
Sint a;
Sint *p;
{
  OPAQUE_REG(a);
  return a + *p;
}

static Sint
add_mem_reg(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  return *p + a;
}

static Sint
add_mem_mem(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint b;

  a = *p;
  b = *q;
  return a + b;
}

static Sint
add_volatile_mem(a, p)
Sint a;
volatile Sint *p;
{
  OPAQUE_REG(a);
  return a + *p;
}

static Sint
add_global_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  return addsi3_ga + a;
}

static Sint
add_reg_global(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + addsi3_gb;
}

static Sint
add_array_reg(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  return v[i & 017] + a;
}

static Sint
add_reg_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  OPAQUE_REG(a);
  return a + v[i & 017];
}

static Sint
add_global_array(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  return addsi3_buf[i & 017] + a;
}

static Sint
add_struct_a(p, x)
struct addsi3_pair *p;
Sint x;
{
  OPAQUE_REG(x);
  return p->a + x;
}

static Sint
add_struct_b(p, x)
struct addsi3_pair *p;
Sint x;
{
  OPAQUE_REG(x);
  return x + p->b;
}

static Sint
add_global_struct(x)
Sint x;
{
  OPAQUE_REG(x);
  return addsi3_gp.a + x;
}

static Sint
addi_zero(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0;
}

static Sint
addi_one(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 1;
}

static Sint
addi_two(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 2;
}

static Sint
addi_small(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0123456;
}

static Sint
addi_low9(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0777;
}

static Sint
addi_low18(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0777777;
}

static uSint
uaddi_low18(a)
uSint a;
{
  OPAQUE_REG(a);
  return a + 0777777;
}

static Sint
subi_one_as_add(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + -1;
}

static Sint
subi_two_as_add(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + -2;
}

static Sint
subi_small_as_add(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + -0123456;
}

static Sint
subi_low18_as_add(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + -0777777;
}

static Sint
add_large_const(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0123456123456;
}

static Sint
add_large_const_left(a)
Sint a;
{
  OPAQUE_REG(a);
  return 0123456123456 + a;
}

static Sint
add_large_ones(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0777777777777;
}

static Sint
add_left_half_const(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0777777000000;
}

static Sint
add_right_half_const(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0000000777777;
}

static Sint
add_sign_bit_const(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0400000000000;
}

static Sint
add_const_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return x + 0123456;
}

static Sint
add_negative_const_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return x + -0123456;
}

static Sint
add_large_const_after_expr(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  OPAQUE_REG(x);
  return x + 0123456123456;
}

static Sint
add_qi_promote(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x + y;
}

static uSint
add_uqi_promote(a, b)
uQint a;
uQint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x + y;
}

static Sint
add_hi_promote(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = a;
  y = b;
  return x + y;
}

static uSint
add_uhi_promote(a, b)
uHint a;
uHint b;
{
  uSint x;
  uSint y;

  x = a;
  y = b;
  return x + y;
}

static Sint
add_qi_mem(p, x)
sQint *p;
Sint x;
{
  return *p + x;
}

static uSint
add_uqi_mem(p, x)
uQint *p;
uSint x;
{
  return *p + x;
}

static Sint
add_hi_mem(p, x)
Hint *p;
Sint x;
{
  return *p + x;
}

static uSint
add_uhi_mem(p, x)
uHint *p;
uSint x;
{
  return *p + x;
}

/*
 * Memory destination forms.  The addsi3 expander has special handling:
 * MEM + reg is allowed directly, but MEM + arbitrary constant is
 * forced through a register except for +1 and -1.
 */

static void
addm_reg(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p += a;
}

static Sint
addm_reg_ret(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p += a;
  return *p;
}

static void
addm_mem(p, q)
Sint *p;
Sint *q;
{
  *p += *q;
}

static Sint
addm_mem_ret(p, q)
Sint *p;
Sint *q;
{
  *p += *q;
  return *p;
}

static void
addm_global(a)
Sint a;
{
  OPAQUE_REG(a);
  addsi3_ga += a;
}

static Sint
addm_global_ret(a)
Sint a;
{
  OPAQUE_REG(a);
  addsi3_ga += a;
  return addsi3_ga;
}

static void
addm_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  v[i & 017] += a;
}

static Sint
addm_array_ret(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  v[i & 017] += a;
  return v[i & 017];
}

static void
addm_global_array(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  addsi3_buf[i & 017] += a;
}

static Sint
addm_struct_a(p, a)
struct addsi3_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->a += a;
  return p->a;
}

static Sint
addm_struct_b(p, a)
struct addsi3_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->b += a;
  return p->b;
}

static Sint
addm_global_struct(a)
Sint a;
{
  OPAQUE_REG(a);
  addsi3_gp.b += a;
  return addsi3_gp.b;
}

static void
addm_volatile(p, a)
volatile Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p += a;
}

static Sint
addm_volatile_ret(p, a)
volatile Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p += a;
  return *p;
}

/*
 * +1/-1 memory destination forms.  These should be where AOS/SOS
 * alternatives appear from the addsi3 pattern.
 */

static void
aos_mem(p)
Sint *p;
{
  *p += 1;
}

static Sint
aos_mem_ret(p)
Sint *p;
{
  *p += 1;
  return *p;
}

static void
sos_mem(p)
Sint *p;
{
  *p += -1;
}

static Sint
sos_mem_ret(p)
Sint *p;
{
  *p += -1;
  return *p;
}

static Sint
aos_global(void)
{
  addsi3_ga += 1;
  return addsi3_ga;
}

static Sint
sos_global(void)
{
  addsi3_gb += -1;
  return addsi3_gb;
}

static Sint
aos_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] += 1;
  return v[i & 017];
}

static Sint
sos_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] += -1;
  return v[i & 017];
}

static Sint
aos_struct(p)
struct addsi3_pair *p;
{
  p->a += 1;
  return p->a;
}

static Sint
sos_struct(p)
struct addsi3_pair *p;
{
  p->b += -1;
  return p->b;
}

static Sint
aos_volatile(p)
volatile Sint *p;
{
  *p += 1;
  return *p;
}

static Sint
sos_volatile(p)
volatile Sint *p;
{
  *p += -1;
  return *p;
}

/*
 * Memory plus non-small constant.  The expander should not try to form
 * MEM + big-constant directly; it should force the constant to a reg
 * first, then use the valid addsi3 alternatives.
 */

static void
addm_const_small(p)
Sint *p;
{
  *p += 0123456;
}

static Sint
addm_const_small_ret(p)
Sint *p;
{
  *p += 0123456;
  return *p;
}

static void
addm_const_large(p)
Sint *p;
{
  *p += 0123456123456;
}

static Sint
addm_const_large_ret(p)
Sint *p;
{
  *p += 0123456123456;
  return *p;
}

static void
addm_const_negative(p)
Sint *p;
{
  *p += -0123456;
}

static Sint
addm_const_negative_ret(p)
Sint *p;
{
  *p += -0123456;
  return *p;
}

/*
 * Address-ish right-half add patterns.  These are meant to give combine
 * chances for the backend's ADDI_reg and ADDI_const_plus_reg patterns.
 */

static Sint
addi_reg_right_half(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = b & 0777777;
  OPAQUE_REG(x);
  OPAQUE_REG(a);
  return a + x;
}

static Sint
addi_const_plus_reg_right_half(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = (b + 01234) & 0777777;
  OPAQUE_REG(x);
  OPAQUE_REG(a);
  return a + x;
}

static Sint
addi_reg_right_half_mem(a, p)
Sint a;
Sint *p;
{
  Sint x;

  x = *p & 0777777;
  OPAQUE_REG(x);
  OPAQUE_REG(a);
  return a + x;
}

static Sint
addi_const_plus_reg_right_half_mem(a, p)
Sint a;
Sint *p;
{
  Sint x;

  x = (*p + 01234) & 0777777;
  OPAQUE_REG(x);
  OPAQUE_REG(a);
  return a + x;
}

static Sint
add_nested1(a, b, c)
Sint a;
Sint b;
Sint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  return (a + b) + c;
}

static Sint
add_nested_const(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return (a + b) + 0123456;
}

static Sint
add_nested_large_const(a, b)
Sint a;
Sint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return (a + b) + 0123456123456;
}

static Sint
add_store_then_use(p, a)
Sint *p;
Sint a;
{
  Sint r;

  OPAQUE_REG(a);
  r = *p + a;
  *p = r;
  return r + a;
}

static Sint
add_call_pressure(a, b)
Sint a;
Sint b;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  r = a + b;
  clobber();
  return r + a;
}

static Sint
add_mem_call_pressure(p, a)
Sint *p;
Sint a;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(a);
  r = *p + a;
  clobber();
  return r + *p;
}

static Sint
add_loop_sum(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017];

  return r;
}

static void
add_loop_update(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint i;

  OPAQUE_REG(a);
  for (i = 0; i < n; ++i)
    v[i & 017] += a;
}

static Sint
add_loop_update_sum(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint i;
  Sint r;

  OPAQUE_REG(a);
  r = 0;
  for (i = 0; i < n; ++i) {
    v[i & 017] += a;
    r += v[i & 017];
  }

  return r;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
add1(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return a + e;
}

static Sint
add2(a, e)
Sint a;
Sint *e;
{
  OPAQUE_REG(a);
  return a + *e;
}

static Sint
addi(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0123456;
}

static Sint
subi(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + -0123456;
}

static Sint
add3(a)
Sint a;
{
  OPAQUE_REG(a);
  return a + 0123456123456;
}

static Sint
addm(a, e)
Sint a;
Sint *e;
{
  OPAQUE_REG(a);
  *e += a;
  return *e;
}
