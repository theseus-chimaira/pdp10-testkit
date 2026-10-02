#include "insns.h"

/*
 * AOBJ instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   AOBJP AC,E    AC <- AC + 1,,1; jump if AC is positive/nonnegative
 *   AOBJN AC,E    AC <- AC + 1,,1; jump if AC is negative
 *
 * AOBJ is not a normal arithmetic family.  It is a counted-loop idiom:
 * the left half holds a signed count, usually negative, and the right
 * half holds an address/index.  The instruction increments both halves
 * with the packed constant 1,,1.
 *
 * Natural pointer/count loops are covered in pattern/aobj_loop.c.  This
 * file keeps insn-level pressure on the packed AOBJ representation:
 *
 *   ac = ac + 1,,1;
 *   if (ac < 0) ...        -> AOBJN pressure
 *   if (ac >= 0) ...       -> AOBJP pressure
 */

extern Sint f(void);

#define AOBJ_STEP       000001000001
#define AOBJ_ADDR_MASK  0000000777777
#define AOBJ_COUNT_MASK 0777777000000

static Sint aobj_ga;
static Sint aobj_gb;
static uSint aobj_uga;
static Sint aobj_buf[16];

struct aobj_pair {
  Sint a;
  Sint b;
};

static struct aobj_pair aobj_gp;

/*
 * Basic packed increment.
 */

static Sint
aobj_step(ac)
Sint ac;
{
  return ac + AOBJ_STEP;
}

static Sint
aobj_step_twice(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  return ac + AOBJ_STEP;
}

static Sint
aobj_step_unsigned(ac)
Sint ac;
{
  return (Sint)((uSint)ac + (uSint)AOBJ_STEP);
}

static uSint
uaobj_step(ac)
uSint ac;
{
  return ac + AOBJ_STEP;
}

static Sint
aobj_get_addr(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  return ac & AOBJ_ADDR_MASK;
}

static Sint
aobj_get_count_bits(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  return ac & AOBJ_COUNT_MASK;
}

static Sint
aobj_from_mem(p)
Sint *p;
{
  return *p + AOBJ_STEP;
}

static Sint
aobj_from_global(void)
{
  return aobj_ga + AOBJ_STEP;
}

static Sint
aobj_from_array(i)
Sint i;
{
  return aobj_buf[i & 017] + AOBJ_STEP;
}

static Sint
aobj_from_struct_a(p)
struct aobj_pair *p;
{
  return p->a + AOBJ_STEP;
}

static Sint
aobj_from_struct_b(p)
struct aobj_pair *p;
{
  return p->b + AOBJ_STEP;
}

static void
aobj_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac + AOBJ_STEP;
}

static void
aobj_store_global(ac)
Sint ac;
{
  aobj_ga = ac + AOBJ_STEP;
}

static void
aobj_store_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  v[i & 017] = ac + AOBJ_STEP;
}

static void
aobj_store_struct_a(p, ac)
struct aobj_pair *p;
Sint ac;
{
  p->a = ac + AOBJ_STEP;
}

static Sint
aobj_update_mem(p)
Sint *p;
{
  *p = *p + AOBJ_STEP;
  return *p;
}

static Sint
aobj_update_global(void)
{
  aobj_ga = aobj_ga + AOBJ_STEP;
  return aobj_ga;
}

static Sint
aobj_update_array(i)
Sint i;
{
  aobj_buf[i & 017] = aobj_buf[i & 017] + AOBJ_STEP;
  return aobj_buf[i & 017];
}

static Sint
aobj_update_struct_a(p)
struct aobj_pair *p;
{
  p->a = p->a + AOBJ_STEP;
  return p->a;
}

/*
 * AOBJN pressure: increment both halves, branch while negative.
 */

static Sint
aobjn_clear(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac < 0)
    ac = 0;
  return ac;
}

static Sint
aobjn_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  ac += AOBJ_STEP;
  if (ac < 0)
    return yes + ac;
  return no + ac;
}

static Sint
aobjn_call(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac < 0)
    ac += f();
  return ac;
}

static Sint
aobjn_likely(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (likely(ac < 0))
    ac = 0;
  return ac;
}

static Sint
aobjn_unlikely(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (unlikely(ac < 0))
    ac = 0;
  return ac;
}

static Sint
aobjn_unsigned_step(ac)
Sint ac;
{
  ac = (Sint)((uSint)ac + (uSint)AOBJ_STEP);
  if (ac < 0)
    ac = 0;
  return ac;
}

static Sint
aobjn_mem(p)
Sint *p;
{
  Sint ac;

  ac = *p + AOBJ_STEP;
  if (ac < 0)
    ac = 0;
  return ac;
}

static Sint
aobjn_global(void)
{
  Sint ac;

  ac = aobj_ga + AOBJ_STEP;
  if (ac < 0)
    ac = 0;
  return ac;
}

static Sint
aobjn_array(i)
Sint i;
{
  Sint ac;

  ac = aobj_buf[i & 017] + AOBJ_STEP;
  if (ac < 0)
    ac = 0;
  return ac;
}

static Sint
aobjn_struct_a(p)
struct aobj_pair *p;
{
  Sint ac;

  ac = p->a + AOBJ_STEP;
  if (ac < 0)
    ac = 0;
  return ac;
}

static Sint
aobjn_update_mem(p)
Sint *p;
{
  *p = *p + AOBJ_STEP;
  if (*p < 0)
    f();
  return *p;
}

static Sint
aobjn_update_global(void)
{
  aobj_ga = aobj_ga + AOBJ_STEP;
  if (aobj_ga < 0)
    f();
  return aobj_ga;
}

static Sint
aobjn_update_array(i)
Sint i;
{
  aobj_buf[i & 017] = aobj_buf[i & 017] + AOBJ_STEP;
  if (aobj_buf[i & 017] < 0)
    f();
  return aobj_buf[i & 017];
}

static Sint
aobjn_update_struct_a(p)
struct aobj_pair *p;
{
  p->a = p->a + AOBJ_STEP;
  if (p->a < 0)
    f();
  return p->a;
}

/*
 * AOBJP pressure: increment both halves, branch when the packed word has
 * become nonnegative.  This is the complement side of AOBJN pressure.
 */

static Sint
aobjp_clear(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac >= 0)
    ac = 0;
  return ac;
}

static Sint
aobjp_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  ac += AOBJ_STEP;
  if (ac >= 0)
    return yes + ac;
  return no + ac;
}

static Sint
aobjp_call(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac >= 0)
    ac += f();
  return ac;
}

static Sint
aobjp_likely(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (likely(ac >= 0))
    ac = 0;
  return ac;
}

static Sint
aobjp_unlikely(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (unlikely(ac >= 0))
    ac = 0;
  return ac;
}

static Sint
aobjp_unsigned_step(ac)
Sint ac;
{
  ac = (Sint)((uSint)ac + (uSint)AOBJ_STEP);
  if (ac >= 0)
    ac = 0;
  return ac;
}

static Sint
aobjp_mem(p)
Sint *p;
{
  Sint ac;

  ac = *p + AOBJ_STEP;
  if (ac >= 0)
    ac = 0;
  return ac;
}

static Sint
aobjp_global(void)
{
  Sint ac;

  ac = aobj_ga + AOBJ_STEP;
  if (ac >= 0)
    ac = 0;
  return ac;
}

static Sint
aobjp_array(i)
Sint i;
{
  Sint ac;

  ac = aobj_buf[i & 017] + AOBJ_STEP;
  if (ac >= 0)
    ac = 0;
  return ac;
}

static Sint
aobjp_struct_a(p)
struct aobj_pair *p;
{
  Sint ac;

  ac = p->a + AOBJ_STEP;
  if (ac >= 0)
    ac = 0;
  return ac;
}

static Sint
aobjp_update_mem(p)
Sint *p;
{
  *p = *p + AOBJ_STEP;
  if (*p >= 0)
    f();
  return *p;
}

static Sint
aobjp_update_global(void)
{
  aobj_ga = aobj_ga + AOBJ_STEP;
  if (aobj_ga >= 0)
    f();
  return aobj_ga;
}

static Sint
aobjp_update_array(i)
Sint i;
{
  aobj_buf[i & 017] = aobj_buf[i & 017] + AOBJ_STEP;
  if (aobj_buf[i & 017] >= 0)
    f();
  return aobj_buf[i & 017];
}

static Sint
aobjp_update_struct_a(p)
struct aobj_pair *p;
{
  p->a = p->a + AOBJ_STEP;
  if (p->a >= 0)
    f();
  return p->a;
}

/*
 * Loop forms using the packed AOBJ value directly.
 */

static Sint
aobjn_loop_sum(ac, p)
Sint ac;
Sint *p;
{
  Sint s;

  s = 0;
  do {
    s += *p++;
    ac += AOBJ_STEP;
  } while (ac < 0);

  return s + ac;
}

static Sint
aobjn_loop_sum_guarded(ac, p)
Sint ac;
Sint *p;
{
  Sint s;

  if (ac >= 0)
    return ac;

  s = 0;
  do {
    s += *p++;
    ac += AOBJ_STEP;
  } while (ac < 0);

  return s + ac;
}

static Sint
aobjn_loop_count(ac)
Sint ac;
{
  Sint n;

  n = 0;
  do {
    ++n;
    ac += AOBJ_STEP;
  } while (ac < 0);

  return n + ac;
}

static Sint
aobjn_loop_store(ac, p, v)
Sint ac;
Sint *p;
Sint v;
{
  do {
    *p++ = v;
    ac += AOBJ_STEP;
  } while (ac < 0);

  return ac;
}

static Sint
aobjn_loop_copy(ac, d, s)
Sint ac;
Sint *d;
Sint *s;
{
  do {
    *d++ = *s++;
    ac += AOBJ_STEP;
  } while (ac < 0);

  return ac;
}

static Sint
aobjn_loop_find_zero(ac, p)
Sint ac;
Sint *p;
{
  do {
    if (*p++ == 0)
      return ac;
    ac += AOBJ_STEP;
  } while (ac < 0);

  return ac;
}

static Sint
aobjp_loop_sum(ac, p)
Sint ac;
Sint *p;
{
  Sint s;

  s = 0;
  do {
    s += *p++;
    ac += AOBJ_STEP;
  } while (ac >= 0);

  return s + ac;
}

static Sint
aobjp_loop_count(ac)
Sint ac;
{
  Sint n;

  n = 0;
  do {
    ++n;
    ac += AOBJ_STEP;
  } while (ac >= 0);

  return n + ac;
}

/*
 * Forms that use the right half after stepping.  These make the address
 * half live, which is important for AOBJ-style addressing pressure.
 */

static Sint
aobjn_addr_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint addr;

  ac += AOBJ_STEP;
  addr = ac & AOBJ_ADDR_MASK;
  if (ac < 0)
    return yes + addr;
  return no + addr;
}

static Sint
aobjp_addr_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint addr;

  ac += AOBJ_STEP;
  addr = ac & AOBJ_ADDR_MASK;
  if (ac >= 0)
    return yes + addr;
  return no + addr;
}

static Sint
aobjn_addr_load(ac, base)
Sint ac;
Sint *base;
{
  Sint addr;

  ac += AOBJ_STEP;
  addr = ac & AOBJ_ADDR_MASK;
  if (ac < 0)
    return base[addr & 017];
  return ac;
}

static Sint
aobjp_addr_load(ac, base)
Sint ac;
Sint *base;
{
  Sint addr;

  ac += AOBJ_STEP;
  addr = ac & AOBJ_ADDR_MASK;
  if (ac >= 0)
    return base[addr & 017];
  return ac;
}

/*
 * Unsigned packed-word variants.  The branch still tests the signed
 * interpretation after the packed increment.
 */

static uSint
uaobjn_step(ac)
uSint ac;
{
  ac += AOBJ_STEP;
  if ((Sint)ac < 0)
    ac = 0;
  return ac;
}

static uSint
uaobjp_step(ac)
uSint ac;
{
  ac += AOBJ_STEP;
  if ((Sint)ac >= 0)
    ac = 0;
  return ac;
}

static uSint
uaobj_update_global(void)
{
  aobj_uga = aobj_uga + AOBJ_STEP;
  return aobj_uga;
}

static Sint
uaobjn_loop_count(ac)
uSint ac;
{
  Sint n;

  n = 0;
  do {
    ++n;
    ac += AOBJ_STEP;
  } while ((Sint)ac < 0);

  return n + (Sint)ac;
}

static Sint
uaobjp_loop_count(ac)
uSint ac;
{
  Sint n;

  n = 0;
  do {
    ++n;
    ac += AOBJ_STEP;
  } while ((Sint)ac >= 0);

  return n + (Sint)ac;
}

/*
 * Extra compare spellings.  These should still be recognizable as the
 * same sign-test after adding 1,,1.
 */

static Sint
aobjn_explicit_lt(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac < 0)
    return 1;
  return 0;
}

static Sint
aobjp_explicit_ge(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac >= 0)
    return 1;
  return 0;
}

static Sint
aobjn_explicit_not_ge(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (!(ac >= 0))
    return 1;
  return 0;
}

static Sint
aobjp_explicit_not_lt(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (!(ac < 0))
    return 1;
  return 0;
}

static Sint
aobjn_two_steps(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac < 0)
    ac += AOBJ_STEP;
  return ac;
}

static Sint
aobjp_two_steps(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac >= 0)
    ac += AOBJ_STEP;
  return ac;
}

static Sint
aobj_mixed_global(ac)
Sint ac;
{
  ac += AOBJ_STEP;
  if (ac < 0)
    aobj_ga = ac;
  else
    aobj_gb = ac;
  return ac;
}
