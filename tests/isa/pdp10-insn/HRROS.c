#include "insns.h"

/*
 * HRROS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRROS AC,E    AC <- ones,,E-right
 *                E  <- ones,,E-right
 *
 * HRROS is the self form of HRRO.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (*p & RIGHT_HALF) | LEFT_HALF;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRROS:
 *   - source right half comes from E
 *   - result left half is all ones
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRRO.c.
 */

extern Sint f(void);

#define HRROS_LEFT   0777777000000
#define HRROS_RIGHT  0000000777777
#define HRROS_MAKE(x) (((x) & HRROS_RIGHT) | HRROS_LEFT)

static Sint hrros_ga;
static Sint hrros_gb;
static uSint hrros_uga;
static volatile Sint hrros_vga;
static Sint hrros_buf[16];
static uSint hrros_ubuf[16];

struct hrros_pair {
  Sint a;
  Sint b;
};

struct hrros_upair {
  uSint a;
  uSint b;
};

static struct hrros_pair hrros_gp;
static struct hrros_upair hrros_ugp;

/*
 * Basic HRROS pressure: update E and return the same resulting word.
 */

static Sint
hrros_mem(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrros_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HRROS_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrros_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = HRROS_MAKE(*p);
  *p = ac;
  return ac;
}

static Sint
hrros_global(void)
{
  Sint t;

  t = HRROS_MAKE(hrros_ga);
  hrros_ga = t;
  return t;
}

static Sint
hrros_global_b(void)
{
  Sint t;

  t = HRROS_MAKE(hrros_gb);
  hrros_gb = t;
  return t;
}

static Sint
hrros_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = HRROS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hrros_global_array(i)
Sint i;
{
  Sint t;

  t = HRROS_MAKE(hrros_buf[i & 017]);
  hrros_buf[i & 017] = t;
  return t;
}

static Sint
hrros_struct_a(p)
struct hrros_pair *p;
{
  Sint t;

  t = HRROS_MAKE(p->a);
  p->a = t;
  return t;
}

static Sint
hrros_struct_b(p)
struct hrros_pair *p;
{
  Sint t;

  t = HRROS_MAKE(p->b);
  p->b = t;
  return t;
}

static Sint
hrros_global_struct_a(void)
{
  Sint t;

  t = HRROS_MAKE(hrros_gp.a);
  hrros_gp.a = t;
  return t;
}

static Sint
hrros_global_struct_b(void)
{
  Sint t;

  t = HRROS_MAKE(hrros_gp.b);
  hrros_gp.b = t;
  return t;
}

static Sint
hrros_indirect(pp)
Sint **pp;
{
  Sint t;

  t = HRROS_MAKE(**pp);
  **pp = t;
  return t;
}

static Sint
hrros_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HRROS_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrros_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hrros_vga;
  t = HRROS_MAKE(e);
  hrros_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrros_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
hrros_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t - y;
}

static Sint
hrros_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t ^ y;
}

static Sint
hrros_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t | y;
}

static Sint
hrros_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t & y;
}

static Sint
hrros_call_add(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t + f();
}

static Sint
hrros_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = HRROS_MAKE(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRROS result.
 */

static Sint
hrros_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrros_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrros_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrros_likely(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrros_unlikely(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the ones-filled left half and preserved right half visible.
 */

static Sint
hrros_left_is_ones(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t & HRROS_LEFT;
}

static Sint
hrros_right_bits(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t & HRROS_RIGHT;
}

static Sint
hrros_right_nonzero(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return (t & HRROS_RIGHT) != 0;
}

static Sint
hrros_left_ones_bool(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return (t & HRROS_LEFT) == HRROS_LEFT;
}

static Sint
hrros_mix_after_ones(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return (t & HRROS_LEFT) + (t & HRROS_RIGHT) + y;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrros_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HRROS_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hrros_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HRROS_MAKE(e);
  *p = t;
  return t + (e & HRROS_RIGHT);
}

static Sint
hrros_left_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HRROS_MAKE(e);
  *p = t;
  return t + (e & HRROS_LEFT);
}

static Sint
hrros_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = HRROS_MAKE(*p);
  *p = t;
  u = HRROS_MAKE(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrros_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = HRROS_MAKE(*p);
    *p = t;
  }

  return t;
}

static Sint
hrros_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = HRROS_MAKE(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrros_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = HRROS_MAKE(*p);
    *p = t;
    if (t == 0)
      return n;
  }

  return *p;
}

/*
 * Store-only-looking variants, but still return/use the computed value.
 */

static Sint
hrros_store_then_load(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return *p;
}

static Sint
hrros_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return *p != 0;
}

static Sint
hrros_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrros_mem(p)
uSint *p;
{
  uSint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t;
}

static uSint
uhrros_global(void)
{
  uSint t;

  t = HRROS_MAKE(hrros_uga);
  hrros_uga = t;
  return t;
}

static uSint
uhrros_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HRROS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhrros_global_array(i)
Sint i;
{
  uSint t;

  t = HRROS_MAKE(hrros_ubuf[i & 017]);
  hrros_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrros_struct_a(p)
struct hrros_upair *p;
{
  uSint t;

  t = HRROS_MAKE(p->a);
  p->a = t;
  return t;
}

static uSint
uhrros_global_struct_a(void)
{
  uSint t;

  t = HRROS_MAKE(hrros_ugp.a);
  hrros_ugp.a = t;
  return t;
}

static uSint
uhrros_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
uhrros_bool(p)
uSint *p;
{
  uSint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t != 0;
}

static uSint
uhrros_right_bits(p)
uSint *p;
{
  uSint t;

  t = HRROS_MAKE(*p);
  *p = t;
  return t & HRROS_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HRROS
 * match, because HRROS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hrros_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = (Sint)a;
  t = HRROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrros_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = (Sint)a;
  t = HRROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrros_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = (Sint)a;
  t = HRROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrros_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = (Sint)a;
  t = HRROS_MAKE(*p);
  *p = t;
  return t;
}
