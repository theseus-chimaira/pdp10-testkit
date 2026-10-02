#include "insns.h"

/*
 * HLLZS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLLZS AC,E    AC <- E-left,,0
 *                E  <- E-left,,0
 *
 * HLLZS is the self form of HLLZ.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = *p & LEFT_HALF;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLLZS:
 *   - source left half comes from E
 *   - source right half is zero
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HLLZ.c.
 */

extern Sint f(void);

#define HLLZS_LEFT   0777777000000
#define HLLZS_RIGHT  0000000777777

static Sint hllzs_ga;
static Sint hllzs_gb;
static uSint hllzs_uga;
static volatile Sint hllzs_vga;
static Sint hllzs_buf[16];
static uSint hllzs_ubuf[16];

struct hllzs_pair {
  Sint a;
  Sint b;
};

struct hllzs_upair {
  uSint a;
  uSint b;
};

static struct hllzs_pair hllzs_gp;
static struct hllzs_upair hllzs_ugp;

/*
 * Basic HLLZS pressure: update E and return the same resulting word.
 */

static Sint
hllzs_mem(p)
Sint *p;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t;
}

static Sint
hllzs_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HLLZS_LEFT;
  *p = t;
  return t;
}

static Sint
hllzs_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = *p & HLLZS_LEFT;
  *p = ac;
  return ac;
}

static Sint
hllzs_global(void)
{
  Sint t;

  t = hllzs_ga & HLLZS_LEFT;
  hllzs_ga = t;
  return t;
}

static Sint
hllzs_global_b(void)
{
  Sint t;

  t = hllzs_gb & HLLZS_LEFT;
  hllzs_gb = t;
  return t;
}

static Sint
hllzs_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = v[i & 017] & HLLZS_LEFT;
  v[i & 017] = t;
  return t;
}

static Sint
hllzs_global_array(i)
Sint i;
{
  Sint t;

  t = hllzs_buf[i & 017] & HLLZS_LEFT;
  hllzs_buf[i & 017] = t;
  return t;
}

static Sint
hllzs_struct_a(p)
struct hllzs_pair *p;
{
  Sint t;

  t = p->a & HLLZS_LEFT;
  p->a = t;
  return t;
}

static Sint
hllzs_struct_b(p)
struct hllzs_pair *p;
{
  Sint t;

  t = p->b & HLLZS_LEFT;
  p->b = t;
  return t;
}

static Sint
hllzs_global_struct_a(void)
{
  Sint t;

  t = hllzs_gp.a & HLLZS_LEFT;
  hllzs_gp.a = t;
  return t;
}

static Sint
hllzs_global_struct_b(void)
{
  Sint t;

  t = hllzs_gp.b & HLLZS_LEFT;
  hllzs_gp.b = t;
  return t;
}

static Sint
hllzs_indirect(pp)
Sint **pp;
{
  Sint t;

  t = **pp & HLLZS_LEFT;
  **pp = t;
  return t;
}

static Sint
hllzs_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HLLZS_LEFT;
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hllzs_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t + y;
}

static Sint
hllzs_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t - y;
}

static Sint
hllzs_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t ^ y;
}

static Sint
hllzs_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t | y;
}

static Sint
hllzs_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t & y;
}

static Sint
hllzs_call_add(p)
Sint *p;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t + f();
}

static Sint
hllzs_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = *p & HLLZS_LEFT;
  *p = t;
  return t + x;
}

/*
 * Branches using the HLLZS result.
 */

static Sint
hllzs_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hllzs_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hllzs_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hllzs_likely(p)
Sint *p;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hllzs_unlikely(p)
Sint *p;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hllzs_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HLLZS_LEFT;
  *p = t;
  return t + e + y;
}

static Sint
hllzs_left_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HLLZS_LEFT;
  *p = t;
  return t + (e & HLLZS_LEFT);
}

static Sint
hllzs_right_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HLLZS_LEFT;
  *p = t;
  return t + (e & HLLZS_RIGHT);
}

static Sint
hllzs_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = *p & HLLZS_LEFT;
  *p = t;
  u = *q & HLLZS_LEFT;
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hllzs_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = *p & HLLZS_LEFT;
    *p = t;
  }

  return t;
}

static Sint
hllzs_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = *p & HLLZS_LEFT;
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hllzs_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = *p & HLLZS_LEFT;
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
hllzs_store_then_load(p)
Sint *p;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return *p;
}

static Sint
hllzs_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return *p != 0;
}

static Sint
hllzs_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhllzs_mem(p)
uSint *p;
{
  uSint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t;
}

static uSint
uhllzs_global(void)
{
  uSint t;

  t = hllzs_uga & HLLZS_LEFT;
  hllzs_uga = t;
  return t;
}

static uSint
uhllzs_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = v[i & 017] & HLLZS_LEFT;
  v[i & 017] = t;
  return t;
}

static uSint
uhllzs_global_array(i)
Sint i;
{
  uSint t;

  t = hllzs_ubuf[i & 017] & HLLZS_LEFT;
  hllzs_ubuf[i & 017] = t;
  return t;
}

static uSint
uhllzs_struct_a(p)
struct hllzs_upair *p;
{
  uSint t;

  t = p->a & HLLZS_LEFT;
  p->a = t;
  return t;
}

static uSint
uhllzs_global_struct_a(void)
{
  uSint t;

  t = hllzs_ugp.a & HLLZS_LEFT;
  hllzs_ugp.a = t;
  return t;
}

static uSint
uhllzs_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t + y;
}

static Sint
uhllzs_bool(p)
uSint *p;
{
  uSint t;

  t = *p & HLLZS_LEFT;
  *p = t;
  return t != 0;
}

/*
 * Promoted small-type memory destinations are not a natural HLLZS
 * match, because HLLZS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hllzs_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = ((Sint)a) | HLLZS_RIGHT;
  t = *p & HLLZS_LEFT;
  *p = t;
  return t;
}

static Sint
hllzs_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = ((Sint)a) | HLLZS_RIGHT;
  t = *p & HLLZS_LEFT;
  *p = t;
  return t;
}

static Sint
hllzs_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = ((Sint)a) | HLLZS_RIGHT;
  t = *p & HLLZS_LEFT;
  *p = t;
  return t;
}

static Sint
hllzs_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = ((Sint)a) | HLLZS_RIGHT;
  t = *p & HLLZS_LEFT;
  *p = t;
  return t;
}
