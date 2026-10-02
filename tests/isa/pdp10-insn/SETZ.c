#include "insns.h"

/*
 * SETZ instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms here:
 *   SETZ   AC,       AC <- 0
 *   SETZI  AC,E      AC <- 0, effective address ignored
 *
 * This is a normal C-to-insn pressure test, unlike JFCL/XCT/JSR/JSP.
 * Plain C can express register zero values naturally:
 *
 *   return 0;
 *   x = 0;
 *   if (cond) return 0;
 *
 * Keep memory-zeroing out of this file:
 *   SETZM.c covers memory <- 0
 *   SETZB.c covers AC and memory both <- 0
 *
 * Some zero results may lower as MOVEI AC,0 or TDZA AC,AC depending on
 * backend choices.  That is acceptable for review: this file records
 * the C shapes that should put pressure on the register-zero family.
 */

extern Sint f(void);

static Sint setz_ga;
static uSint setz_uga;
static volatile Sint setz_vga;

struct setz_pair {
  Sint a;
  Sint b;
};

static struct setz_pair setz_gp;

/*
 * Simple register zero values.
 */

static Sint
setz_return(void)
{
  return 0;
}

static Sint
setz_arg(a)
Sint a;
{
  a = 0;
  return a;
}

static Sint
setz_local(void)
{
  Sint a;

  a = 0;
  return a;
}

static Sint
setz_local_after_use(a)
Sint a;
{
  a += 1;
  a = 0;
  return a;
}

static Sint
setz_after_call(void)
{
  f();
  return 0;
}

static Sint
setz_call_value_killed(void)
{
  Sint a;

  a = f();
  a = 0;
  return a;
}

static Sint
setz_global_value_killed(void)
{
  Sint a;

  a = setz_ga;
  a = 0;
  return a;
}

static Sint
setz_volatile_value_killed(void)
{
  Sint a;

  a = setz_vga;
  a = 0;
  return a;
}

static Sint
setz_struct_value_killed(void)
{
  Sint a;

  a = setz_gp.a;
  a = 0;
  return a;
}

/*
 * Zero used as an expression value.
 */

static Sint
setz_and_zero(a)
Sint a;
{
  return a & 0;
}

static Sint
setz_mul_zero(a)
Sint a;
{
  return a * 0;
}

static Sint
setz_sub_self(a)
Sint a;
{
  return a - a;
}

static Sint
setz_xor_self(a)
Sint a;
{
  return a ^ a;
}

static Sint
setz_compare_self_lt(a)
Sint a;
{
  if (a < a)
    return 1;
  return 0;
}

static Sint
setz_compare_self_gt(a)
Sint a;
{
  if (a > a)
    return 1;
  return 0;
}

/*
 * Branch-selected zero results.
 */

static Sint
setz_if_true(a, b)
Sint a;
Sint b;
{
  if (a)
    return 0;
  return b;
}

static Sint
setz_if_false(a, b)
Sint a;
Sint b;
{
  if (!a)
    return 0;
  return b;
}

static Sint
setz_if_eq(a, b)
Sint a;
Sint b;
{
  if (a == b)
    return 0;
  return a;
}

static Sint
setz_if_ne(a, b)
Sint a;
Sint b;
{
  if (a != b)
    return 0;
  return a;
}

static Sint
setz_if_lt(a, b)
Sint a;
Sint b;
{
  if (a < b)
    return 0;
  return a;
}

static Sint
setz_if_le(a, b)
Sint a;
Sint b;
{
  if (a <= b)
    return 0;
  return a;
}

static Sint
setz_if_ge(a, b)
Sint a;
Sint b;
{
  if (a >= b)
    return 0;
  return a;
}

static Sint
setz_if_gt(a, b)
Sint a;
Sint b;
{
  if (a > b)
    return 0;
  return a;
}

static Sint
setz_if_global(a)
Sint a;
{
  if (setz_ga)
    return 0;
  return a;
}

static Sint
setz_if_volatile(a)
Sint a;
{
  if (setz_vga)
    return 0;
  return a;
}

static Sint
setz_if_call(a)
Sint a;
{
  if (f())
    return 0;
  return a;
}

static Sint
setz_if_struct(a)
Sint a;
{
  if (setz_gp.a)
    return 0;
  return a;
}

static Sint
setz_likely(a)
Sint a;
{
  if (likely(a != 0))
    return 0;
  return a;
}

static Sint
setz_unlikely(a)
Sint a;
{
  if (unlikely(a != 0))
    return 0;
  return a;
}

/*
 * Conditional boolean-style values.  These often put pressure on
 * skip-and-zero forms such as TDZA, but they are still useful SETZ
 * family pressure because one arm is a register zero result.
 */

static Sint
setz_bool_eq(a, b)
Sint a;
Sint b;
{
  return (a == b) ? 0 : 1;
}

static Sint
setz_bool_ne(a, b)
Sint a;
Sint b;
{
  return (a != b) ? 0 : 1;
}

static Sint
setz_bool_lt(a, b)
Sint a;
Sint b;
{
  return (a < b) ? 0 : 1;
}

static Sint
setz_bool_le(a, b)
Sint a;
Sint b;
{
  return (a <= b) ? 0 : 1;
}

static Sint
setz_bool_ge(a, b)
Sint a;
Sint b;
{
  return (a >= b) ? 0 : 1;
}

static Sint
setz_bool_gt(a, b)
Sint a;
Sint b;
{
  return (a > b) ? 0 : 1;
}

/*
 * Zero values through loops and switches.
 */

static Sint
setz_loop_sum(n)
Sint n;
{
  Sint s;

  s = 0;
  while (n-- > 0)
    s += n;

  return s;
}

static Sint
setz_loop_clear(n)
Sint n;
{
  Sint s;

  s = n;
  while (n-- > 0)
    s = 0;

  return s;
}

static Sint
setz_loop_break(n)
Sint n;
{
  Sint s;

  s = n;
  while (s > 0) {
    if (s == 3)
      return 0;
    --s;
  }

  return s;
}

static Sint
setz_switch(a)
Sint a;
{
  switch (a) {
  case 1:
    return 0;
  case 2:
    return a;
  default:
    return 0;
  }
}

static Sint
setz_switch_mixed(a)
Sint a;
{
  switch (a & 3) {
  case 0:
    return 0;
  case 1:
    return a;
  case 2:
    return -a;
  default:
    return 0;
  }
}

/*
 * Unsigned forms.  Same machine-level zero value.
 */

static uSint
usetz_return(void)
{
  return 0;
}

static uSint
usetz_arg(a)
uSint a;
{
  a = 0;
  return a;
}

static uSint
usetz_local(void)
{
  uSint a;

  a = 0;
  return a;
}

static uSint
usetz_global_value_killed(void)
{
  uSint a;

  a = setz_uga;
  a = 0;
  return a;
}

static uSint
usetz_if_lt(a, b)
uSint a;
uSint b;
{
  if (a < b)
    return 0;
  return a;
}

static uSint
usetz_if_ne(a, b)
uSint a;
uSint b;
{
  if (a != b)
    return 0;
  return a;
}

static uSint
usetz_and_zero(a)
uSint a;
{
  return a & 0;
}

static uSint
usetz_mul_zero(a)
uSint a;
{
  return a * 0;
}

static uSint
usetz_sub_self(a)
uSint a;
{
  return a - a;
}

static uSint
usetz_xor_self(a)
uSint a;
{
  return a ^ a;
}

/*
 * Promoted small integer forms.
 */

static Sint
setz_sqi_return(void)
{
  sQint a;

  a = 0;
  return a;
}

static Sint
setz_uqi_return(void)
{
  uQint a;

  a = 0;
  return a;
}

static Sint
setz_hi_return(void)
{
  Hint a;

  a = 0;
  return a;
}

static Sint
setz_uhi_return(void)
{
  uHint a;

  a = 0;
  return a;
}

static Sint
setz_sqi_arg(a)
sQint a;
{
  a = 0;
  return a;
}

static Sint
setz_uqi_arg(a)
uQint a;
{
  a = 0;
  return a;
}

static Sint
setz_hi_arg(a)
Hint a;
{
  a = 0;
  return a;
}

static Sint
setz_uhi_arg(a)
uHint a;
{
  a = 0;
  return a;
}

/*
 * Null pointer pressure.  On this target a null pointer is still a
 * zero register value.  Do not store it through memory here.
 */

static Sint *
setz_null_ptr(void)
{
  return 0;
}

static Sint *
setz_null_ptr_if(a, p)
Sint a;
Sint *p;
{
  if (a)
    return 0;
  return p;
}

static Sint *
setz_null_ptr_after_use(p)
Sint *p;
{
  p = p + 1;
  p = 0;
  return p;
}

static Sint
setz_ptr_is_null(p)
Sint *p;
{
  return p == 0;
}

static Sint
setz_ptr_is_not_null(p)
Sint *p;
{
  return p != 0;
}

/*
 * SETZI-like pressure.  Plain C cannot require the ignored effective
 * address operand, but these forms keep memory/address expressions live
 * near a register-zero result.
 */

static Sint
setzi_mem_operand(p)
Sint *p;
{
  Sint a;

  a = *p;
  a = 0;
  return a;
}

static Sint
setzi_index_operand(v, i)
Sint *v;
Sint i;
{
  Sint a;

  a = v[i & 017];
  a = 0;
  return a;
}

static Sint
setzi_struct_operand(p)
struct setz_pair *p;
{
  Sint a;

  a = p->a + p->b;
  a = 0;
  return a;
}

static Sint
setzi_call_operand(a)
Sint a;
{
  Sint x;

  x = f() + a;
  x = 0;
  return x;
}

/*
 * Keep a zero local live across ordinary control flow without storing
 * zero to memory.
 */

static Sint
setz_live_across_call(a)
Sint a;
{
  Sint x;

  x = 0;
  if (a)
    f();

  return x;
}

static Sint
setz_live_across_branch(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = 0;
  if (a < b)
    return x;
  return b;
}

static Sint
setz_two_zero_values(a)
Sint a;
{
  Sint x;
  Sint y;

  x = 0;
  y = 0;
  return x + y + (a & 0);
}
