#include "insns.h"

/*
 * HRLS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRLS  AC,E    AC <- E-right,,AC-right
 *                E  <- E-right,,AC-right
 *
 * HRLS is the self form of HRL.  It is not just a memory store and not
 * just a register result: the computed full word is written back to E
 * and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = ((E & RIGHT_HALF) << 18) | (AC & RIGHT_HALF);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRLS:
 *   - source left half comes from E right half
 *   - source right half comes from AC right half
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRL.c.
 */

extern Sint f(void);

#define HRLS_RIGHT       0000000777777
#define HRLS_TO_LEFT(x)  ((((uSint)(x)) & HRLS_RIGHT) << 18)
#define HRLS_MAKE(e, a)  (HRLS_TO_LEFT(e) | (((uSint)(a)) & HRLS_RIGHT))

static Sint hrls_ga;
static Sint hrls_gb;
static uSint hrls_uga;
static volatile Sint hrls_vga;
static Sint hrls_buf[16];
static uSint hrls_ubuf[16];

struct hrls_pair {
  Sint a;
  Sint b;
};

struct hrls_upair {
  uSint a;
  uSint b;
};

static struct hrls_pair hrls_gp;
static struct hrls_upair hrls_ugp;

/*
 * Basic HRLS pressure: update E and return the same resulting word.
 */

static Sint
hrls_mem(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t;
}

static Sint
hrls_mem_alt(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLS_MAKE(e, ac);
  *p = t;
  return t;
}

static Sint
hrls_mem_return_ac(p, ac)
Sint *p;
Sint ac;
{
  ac = (Sint)HRLS_MAKE(*p, ac);
  *p = ac;
  return ac;
}

static Sint
hrls_global(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(hrls_ga, ac);
  hrls_ga = t;
  return t;
}

static Sint
hrls_global_b(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(hrls_gb, ac);
  hrls_gb = t;
  return t;
}

static Sint
hrls_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(v[i & 017], ac);
  v[i & 017] = t;
  return t;
}

static Sint
hrls_global_array(i, ac)
Sint i;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(hrls_buf[i & 017], ac);
  hrls_buf[i & 017] = t;
  return t;
}

static Sint
hrls_struct_a(p, ac)
struct hrls_pair *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(p->a, ac);
  p->a = t;
  return t;
}

static Sint
hrls_struct_b(p, ac)
struct hrls_pair *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(p->b, ac);
  p->b = t;
  return t;
}

static Sint
hrls_global_struct_a(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(hrls_gp.a, ac);
  hrls_gp.a = t;
  return t;
}

static Sint
hrls_global_struct_b(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(hrls_gp.b, ac);
  hrls_gp.b = t;
  return t;
}

static Sint
hrls_indirect(pp, ac)
Sint **pp;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(**pp, ac);
  **pp = t;
  return t;
}

static Sint
hrls_volatile(p, ac)
volatile Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLS_MAKE(e, ac);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrls_add(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t + y;
}

static Sint
hrls_sub(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t - y;
}

static Sint
hrls_xor(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t ^ y;
}

static Sint
hrls_or(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t | y;
}

static Sint
hrls_and(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t & y;
}

static Sint
hrls_call_add(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t + f();
}

static Sint
hrls_call_before(p, ac)
Sint *p;
Sint ac;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRLS result.
 */

static Sint
hrls_if_result_zero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrls_if_result_nonzero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrls_if_result_negative(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrls_likely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrls_unlikely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrls_sources_live(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLS_MAKE(e, ac);
  *p = t;
  return t + e + ac + y;
}

static Sint
hrls_right_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLS_MAKE(e, ac);
  *p = t;
  return t + (e & HRLS_RIGHT);
}

static Sint
hrls_ac_right_live(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  return t + (ac & HRLS_RIGHT);
}

static Sint
hrls_two_updates(p, q, ac)
Sint *p;
Sint *q;
Sint ac;
{
  Sint t;
  Sint u;

  t = (Sint)HRLS_MAKE(*p, ac);
  *p = t;
  u = (Sint)HRLS_MAKE(*q, t);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrls_loop(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  t = ac;
  while (n-- > 0) {
    t = (Sint)HRLS_MAKE(*p, t);
    *p = t;
  }

  return t;
}

static Sint
hrls_loop_sum(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  t = ac;
  while (n-- > 0) {
    t = (Sint)HRLS_MAKE(*p, t);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrls_loop_break(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HRLS_MAKE(*p, ac);
    *p = t;
    if (t == 0)
      return n;
    ++ac;
  }

  return ac;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrls_mem(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(*p, ac);
  *p = t;
  return t;
}

static uSint
uhrls_global(ac)
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(hrls_uga, ac);
  hrls_uga = t;
  return t;
}

static uSint
uhrls_array(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(v[i & 017], ac);
  v[i & 017] = t;
  return t;
}

static uSint
uhrls_global_array(i, ac)
Sint i;
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(hrls_ubuf[i & 017], ac);
  hrls_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrls_struct_a(p, ac)
struct hrls_upair *p;
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(p->a, ac);
  p->a = t;
  return t;
}

static uSint
uhrls_global_struct_a(ac)
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(hrls_ugp.a, ac);
  hrls_ugp.a = t;
  return t;
}

static uSint
uhrls_add(p, ac, y)
uSint *p;
uSint ac;
uSint y;
{
  uSint t;

  t = HRLS_MAKE(*p, ac);
  *p = t;
  return t + y;
}

static Sint
uhrls_bool(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = HRLS_MAKE(*p, ac);
  *p = t;
  return t != 0;
}

/*
 * Promoted small-type right-half sources.  These are secondary
 * pressure only; the main HRLS shape is full-word AC/E.
 */

static Sint
hrls_sqi_right(p, ac)
Sint *p;
sQint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, (Sint)ac);
  *p = t;
  return t;
}

static Sint
hrls_uqi_right(p, ac)
Sint *p;
uQint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, (Sint)ac);
  *p = t;
  return t;
}

static Sint
hrls_hi_right(p, ac)
Sint *p;
Hint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, (Sint)ac);
  *p = t;
  return t;
}

static Sint
hrls_uhi_right(p, ac)
Sint *p;
uHint ac;
{
  Sint t;

  t = (Sint)HRLS_MAKE(*p, (Sint)ac);
  *p = t;
  return t;
}
