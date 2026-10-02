#include "insns.h"

/*
 * HRLOS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRLOS AC,E    AC <- E-right,,ones
 *                E  <- E-right,,ones
 *
 * HRLOS is the self form of HRLO.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = ((E & RIGHT_HALF) << 18) | RIGHT_HALF;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRLOS:
 *   - source half comes from E right half
 *   - result left half is E right half
 *   - result right half is all ones
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRLO.c.
 */

extern Sint f(void);

#define HRLOS_RIGHT       0000000777777
#define HRLOS_LEFT        0777777000000
#define HRLOS_TO_LEFT(x)  ((((uSint)(x)) & HRLOS_RIGHT) << 18)
#define HRLOS_MAKE(x)     (HRLOS_TO_LEFT(x) | HRLOS_RIGHT)

static Sint hrlos_ga;
static Sint hrlos_gb;
static uSint hrlos_uga;
static volatile Sint hrlos_vga;
static Sint hrlos_buf[16];
static uSint hrlos_ubuf[16];

struct hrlos_pair {
  Sint a;
  Sint b;
};

struct hrlos_upair {
  uSint a;
  uSint b;
};

static struct hrlos_pair hrlos_gp;
static struct hrlos_upair hrlos_ugp;

/*
 * Basic HRLOS pressure: update E and return the same resulting word.
 */

static Sint
hrlos_mem(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrlos_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLOS_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrlos_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = (Sint)HRLOS_MAKE(*p);
  *p = ac;
  return ac;
}

static Sint
hrlos_global(void)
{
  Sint t;

  t = (Sint)HRLOS_MAKE(hrlos_ga);
  hrlos_ga = t;
  return t;
}

static Sint
hrlos_global_b(void)
{
  Sint t;

  t = (Sint)HRLOS_MAKE(hrlos_gb);
  hrlos_gb = t;
  return t;
}

static Sint
hrlos_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hrlos_global_array(i)
Sint i;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(hrlos_buf[i & 017]);
  hrlos_buf[i & 017] = t;
  return t;
}

static Sint
hrlos_struct_a(p)
struct hrlos_pair *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(p->a);
  p->a = t;
  return t;
}

static Sint
hrlos_struct_b(p)
struct hrlos_pair *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(p->b);
  p->b = t;
  return t;
}

static Sint
hrlos_global_struct_a(void)
{
  Sint t;

  t = (Sint)HRLOS_MAKE(hrlos_gp.a);
  hrlos_gp.a = t;
  return t;
}

static Sint
hrlos_global_struct_b(void)
{
  Sint t;

  t = (Sint)HRLOS_MAKE(hrlos_gp.b);
  hrlos_gp.b = t;
  return t;
}

static Sint
hrlos_indirect(pp)
Sint **pp;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(**pp);
  **pp = t;
  return t;
}

static Sint
hrlos_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLOS_MAKE(e);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrlos_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
hrlos_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t - y;
}

static Sint
hrlos_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t ^ y;
}

static Sint
hrlos_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t | y;
}

static Sint
hrlos_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t & y;
}

static Sint
hrlos_call_add(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t + f();
}

static Sint
hrlos_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRLOS result.
 */

static Sint
hrlos_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrlos_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrlos_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrlos_likely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrlos_unlikely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrlos_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLOS_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hrlos_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLOS_MAKE(e);
  *p = t;
  return t + (e & HRLOS_RIGHT);
}

static Sint
hrlos_left_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLOS_MAKE(e);
  *p = t;
  return t + (e & HRLOS_LEFT);
}

static Sint
hrlos_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  u = (Sint)HRLOS_MAKE(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrlos_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = (Sint)HRLOS_MAKE(*p);
    *p = t;
  }

  return t;
}

static Sint
hrlos_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = (Sint)HRLOS_MAKE(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrlos_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HRLOS_MAKE(*p);
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
hrlos_store_then_load(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return *p;
}

static Sint
hrlos_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return *p != 0;
}

static Sint
hrlos_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return *p + y;
}

/*
 * Make the all-ones right half and copied left half visible after the
 * update.
 */

static Sint
hrlos_right_is_ones(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t & HRLOS_RIGHT;
}

static Sint
hrlos_left_from_right(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t & HRLOS_LEFT;
}

static Sint
hrlos_mix_after_ones(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return (t & HRLOS_LEFT) + (t & HRLOS_RIGHT) + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrlos_mem(p)
uSint *p;
{
  uSint t;

  t = HRLOS_MAKE(*p);
  *p = t;
  return t;
}

static uSint
uhrlos_global(void)
{
  uSint t;

  t = HRLOS_MAKE(hrlos_uga);
  hrlos_uga = t;
  return t;
}

static uSint
uhrlos_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HRLOS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhrlos_global_array(i)
Sint i;
{
  uSint t;

  t = HRLOS_MAKE(hrlos_ubuf[i & 017]);
  hrlos_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrlos_struct_a(p)
struct hrlos_upair *p;
{
  uSint t;

  t = HRLOS_MAKE(p->a);
  p->a = t;
  return t;
}

static uSint
uhrlos_global_struct_a(void)
{
  uSint t;

  t = HRLOS_MAKE(hrlos_ugp.a);
  hrlos_ugp.a = t;
  return t;
}

static uSint
uhrlos_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HRLOS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
uhrlos_bool(p)
uSint *p;
{
  uSint t;

  t = HRLOS_MAKE(*p);
  *p = t;
  return t != 0;
}

static uSint
uhrlos_right_is_ones(p)
uSint *p;
{
  uSint t;

  t = HRLOS_MAKE(*p);
  *p = t;
  return t & HRLOS_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HRLOS
 * match, because HRLOS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hrlos_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrlos_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrlos_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrlos_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLOS_MAKE(*p);
  *p = t;
  return t;
}
