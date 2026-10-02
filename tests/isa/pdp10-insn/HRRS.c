#include "insns.h"

/*
 * HRRS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRRS  AC,E    AC <- AC-left,,E-right
 *                E  <- AC-left,,E-right
 *
 * HRRS is the self form of HRR.  It is not just a memory store and not
 * just a register result: the computed full word is written back to E
 * and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (ac & LEFT_HALF) | (*p & RIGHT_HALF);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRRS:
 *   - source left half comes from AC
 *   - source right half comes from E
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Store-only forms belong to HRRM/related halfword-memory tests.
 * Register-only forms belong to HRR.c.
 */

extern Sint f(void);

#define HRRS_LEFT   0777777000000
#define HRRS_RIGHT  0000000777777

static Sint hrrs_ga;
static Sint hrrs_gb;
static uSint hrrs_uga;
static volatile Sint hrrs_vga;
static Sint hrrs_buf[16];
static uSint hrrs_ubuf[16];

struct hrrs_pair {
  Sint a;
  Sint b;
};

struct hrrs_upair {
  uSint a;
  uSint b;
};

static struct hrrs_pair hrrs_gp;
static struct hrrs_upair hrrs_ugp;

/*
 * Basic HRRS pressure: update E and return the same resulting word.
 */

static Sint
hrrs_mem(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t;
}

static Sint
hrrs_mem_alt(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (ac & HRRS_LEFT) | (e & HRRS_RIGHT);
  *p = t;
  return t;
}

static Sint
hrrs_mem_return_ac(p, ac)
Sint *p;
Sint ac;
{
  ac = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = ac;
  return ac;
}

static Sint
hrrs_global(ac)
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (hrrs_ga & HRRS_RIGHT);
  hrrs_ga = t;
  return t;
}

static Sint
hrrs_global_b(ac)
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (hrrs_gb & HRRS_RIGHT);
  hrrs_gb = t;
  return t;
}

static Sint
hrrs_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (v[i & 017] & HRRS_RIGHT);
  v[i & 017] = t;
  return t;
}

static Sint
hrrs_global_array(i, ac)
Sint i;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (hrrs_buf[i & 017] & HRRS_RIGHT);
  hrrs_buf[i & 017] = t;
  return t;
}

static Sint
hrrs_struct_a(p, ac)
struct hrrs_pair *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (p->a & HRRS_RIGHT);
  p->a = t;
  return t;
}

static Sint
hrrs_struct_b(p, ac)
struct hrrs_pair *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (p->b & HRRS_RIGHT);
  p->b = t;
  return t;
}

static Sint
hrrs_global_struct_a(ac)
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (hrrs_gp.a & HRRS_RIGHT);
  hrrs_gp.a = t;
  return t;
}

static Sint
hrrs_global_struct_b(ac)
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (hrrs_gp.b & HRRS_RIGHT);
  hrrs_gp.b = t;
  return t;
}

static Sint
hrrs_indirect(pp, ac)
Sint **pp;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (**pp & HRRS_RIGHT);
  **pp = t;
  return t;
}

static Sint
hrrs_volatile(p, ac)
volatile Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (ac & HRRS_LEFT) | (e & HRRS_RIGHT);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrrs_add(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t + y;
}

static Sint
hrrs_sub(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t - y;
}

static Sint
hrrs_xor(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t ^ y;
}

static Sint
hrrs_or(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t | y;
}

static Sint
hrrs_and(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t & y;
}

static Sint
hrrs_call_add(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t + f();
}

static Sint
hrrs_call_before(p, ac)
Sint *p;
Sint ac;
{
  Sint x;
  Sint t;

  x = f();
  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRRS result.
 */

static Sint
hrrs_if_result_zero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrrs_if_result_nonzero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrrs_if_result_negative(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrrs_likely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrrs_unlikely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrrs_sources_live(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (ac & HRRS_LEFT) | (e & HRRS_RIGHT);
  *p = t;
  return t + e + ac + y;
}

static Sint
hrrs_left_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t + (ac & HRRS_LEFT);
}

static Sint
hrrs_right_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (ac & HRRS_LEFT) | (e & HRRS_RIGHT);
  *p = t;
  return t + (e & HRRS_RIGHT);
}

static Sint
hrrs_two_updates(p, q, ac)
Sint *p;
Sint *q;
Sint ac;
{
  Sint t;
  Sint u;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  u = (t & HRRS_LEFT) | (*q & HRRS_RIGHT);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrrs_loop(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  t = ac;
  while (n-- > 0) {
    t = (t & HRRS_LEFT) | (*p & HRRS_RIGHT);
    *p = t;
  }

  return t;
}

static Sint
hrrs_loop_sum(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  t = ac;
  while (n-- > 0) {
    t = (t & HRRS_LEFT) | (*p & HRRS_RIGHT);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrrs_loop_break(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
    *p = t;
    if (t == 0)
      return n;
    ++ac;
  }

  return ac;
}

/*
 * Store-only-looking variants, but still return/use the computed value.
 */

static Sint
hrrs_store_then_load(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return *p;
}

static Sint
hrrs_store_then_bool(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return *p != 0;
}

static Sint
hrrs_store_then_add(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return *p + y;
}

/*
 * Make both preserved/copied halves visible after the update.
 */

static Sint
hrrs_left_after_update(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t & HRRS_LEFT;
}

static Sint
hrrs_right_after_update(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t & HRRS_RIGHT;
}

static Sint
hrrs_mix_after_update(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return (t & HRRS_LEFT) + (t & HRRS_RIGHT) + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrrs_mem(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t;
}

static uSint
uhrrs_global(ac)
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (hrrs_uga & HRRS_RIGHT);
  hrrs_uga = t;
  return t;
}

static uSint
uhrrs_array(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (v[i & 017] & HRRS_RIGHT);
  v[i & 017] = t;
  return t;
}

static uSint
uhrrs_global_array(i, ac)
Sint i;
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (hrrs_ubuf[i & 017] & HRRS_RIGHT);
  hrrs_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrrs_struct_a(p, ac)
struct hrrs_upair *p;
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (p->a & HRRS_RIGHT);
  p->a = t;
  return t;
}

static uSint
uhrrs_global_struct_a(ac)
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (hrrs_ugp.a & HRRS_RIGHT);
  hrrs_ugp.a = t;
  return t;
}

static uSint
uhrrs_add(p, ac, y)
uSint *p;
uSint ac;
uSint y;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t + y;
}

static Sint
uhrrs_bool(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t != 0;
}

static uSint
uhrrs_right_after_update(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t & HRRS_RIGHT;
}

/*
 * Promoted small-type AC-left sources are not a natural HRRS match,
 * because HRRS is a full-word halfword operation.  Keep the promoted
 * cases as source-through-temporary pressure only.
 */

static Sint
hrrs_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t;
}

static Sint
hrrs_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t;
}

static Sint
hrrs_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t;
}

static Sint
hrrs_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (ac & HRRS_LEFT) | (*p & HRRS_RIGHT);
  *p = t;
  return t;
}
