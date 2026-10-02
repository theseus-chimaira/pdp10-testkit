#include "insns.h"

/*
 * HRLZS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRLZS AC,E    AC <- E-right,,0
 *                E  <- E-right,,0
 *
 * HRLZS is the self form of HRLZ.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (E & RIGHT_HALF) << 18;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRLZS:
 *   - source half comes from E right half
 *   - result left half is E right half
 *   - result right half is zero
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRLZ.c.
 */

extern Sint f(void);

#define HRLZS_RIGHT       0000000777777
#define HRLZS_TO_LEFT(x)  ((((uSint)(x)) & HRLZS_RIGHT) << 18)

static Sint hrlzs_ga;
static Sint hrlzs_gb;
static uSint hrlzs_uga;
static volatile Sint hrlzs_vga;
static Sint hrlzs_buf[16];
static uSint hrlzs_ubuf[16];

struct hrlzs_pair {
  Sint a;
  Sint b;
};

struct hrlzs_upair {
  uSint a;
  uSint b;
};

static struct hrlzs_pair hrlzs_gp;
static struct hrlzs_upair hrlzs_ugp;

/*
 * Basic HRLZS pressure: update E and return the same resulting word.
 */

static Sint
hrlzs_mem(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t;
}

static Sint
hrlzs_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLZS_TO_LEFT(e);
  *p = t;
  return t;
}

static Sint
hrlzs_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = (Sint)HRLZS_TO_LEFT(*p);
  *p = ac;
  return ac;
}

static Sint
hrlzs_global(void)
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(hrlzs_ga);
  hrlzs_ga = t;
  return t;
}

static Sint
hrlzs_global_b(void)
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(hrlzs_gb);
  hrlzs_gb = t;
  return t;
}

static Sint
hrlzs_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hrlzs_global_array(i)
Sint i;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(hrlzs_buf[i & 017]);
  hrlzs_buf[i & 017] = t;
  return t;
}

static Sint
hrlzs_struct_a(p)
struct hrlzs_pair *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(p->a);
  p->a = t;
  return t;
}

static Sint
hrlzs_struct_b(p)
struct hrlzs_pair *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(p->b);
  p->b = t;
  return t;
}

static Sint
hrlzs_global_struct_a(void)
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(hrlzs_gp.a);
  hrlzs_gp.a = t;
  return t;
}

static Sint
hrlzs_global_struct_b(void)
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(hrlzs_gp.b);
  hrlzs_gp.b = t;
  return t;
}

static Sint
hrlzs_indirect(pp)
Sint **pp;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(**pp);
  **pp = t;
  return t;
}

static Sint
hrlzs_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLZS_TO_LEFT(e);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrlzs_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t + y;
}

static Sint
hrlzs_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t - y;
}

static Sint
hrlzs_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t ^ y;
}

static Sint
hrlzs_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t | y;
}

static Sint
hrlzs_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t & y;
}

static Sint
hrlzs_call_add(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t + f();
}

static Sint
hrlzs_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRLZS result.
 */

static Sint
hrlzs_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrlzs_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrlzs_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrlzs_likely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrlzs_unlikely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrlzs_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLZS_TO_LEFT(e);
  *p = t;
  return t + e + y;
}

static Sint
hrlzs_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLZS_TO_LEFT(e);
  *p = t;
  return t + (e & HRLZS_RIGHT);
}

static Sint
hrlzs_left_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLZS_TO_LEFT(e);
  *p = t;
  return t + (e & 0777777000000);
}

static Sint
hrlzs_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  u = (Sint)HRLZS_TO_LEFT(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrlzs_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = (Sint)HRLZS_TO_LEFT(*p);
    *p = t;
  }

  return t;
}

static Sint
hrlzs_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = (Sint)HRLZS_TO_LEFT(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrlzs_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HRLZS_TO_LEFT(*p);
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
hrlzs_store_then_load(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return *p;
}

static Sint
hrlzs_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return *p != 0;
}

static Sint
hrlzs_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrlzs_mem(p)
uSint *p;
{
  uSint t;

  t = HRLZS_TO_LEFT(*p);
  *p = t;
  return t;
}

static uSint
uhrlzs_global(void)
{
  uSint t;

  t = HRLZS_TO_LEFT(hrlzs_uga);
  hrlzs_uga = t;
  return t;
}

static uSint
uhrlzs_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HRLZS_TO_LEFT(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhrlzs_global_array(i)
Sint i;
{
  uSint t;

  t = HRLZS_TO_LEFT(hrlzs_ubuf[i & 017]);
  hrlzs_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrlzs_struct_a(p)
struct hrlzs_upair *p;
{
  uSint t;

  t = HRLZS_TO_LEFT(p->a);
  p->a = t;
  return t;
}

static uSint
uhrlzs_global_struct_a(void)
{
  uSint t;

  t = HRLZS_TO_LEFT(hrlzs_ugp.a);
  hrlzs_ugp.a = t;
  return t;
}

static uSint
uhrlzs_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HRLZS_TO_LEFT(*p);
  *p = t;
  return t + y;
}

static Sint
uhrlzs_bool(p)
uSint *p;
{
  uSint t;

  t = HRLZS_TO_LEFT(*p);
  *p = t;
  return t != 0;
}

/*
 * Promoted small-type memory destinations are not a natural HRLZS
 * match, because HRLZS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hrlzs_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t;
}

static Sint
hrlzs_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t;
}

static Sint
hrlzs_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t;
}

static Sint
hrlzs_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRLZS_TO_LEFT(*p);
  *p = t;
  return t;
}
