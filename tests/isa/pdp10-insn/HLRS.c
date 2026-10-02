#include "insns.h"

/*
 * HLRS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLRS  AC,E    AC <- AC-left,,E-left
 *                E  <- AC-left,,E-left
 *
 * HLRS is the self form of HLR.  It is not just a memory store and not
 * just a register result: the computed full word is written back to E
 * and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (ac & LEFT_HALF) | ((E & LEFT_HALF) >> 18);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLRS:
 *   - source left half comes from AC
 *   - source right half comes from E left half shifted right
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Store-only forms belong to HLRM/related halfword-memory tests.
 * Register-only forms belong to HLR.c.
 */

extern Sint f(void);

#define HLRS_LEFT         0777777000000
#define HLRS_RIGHT        0000000777777
#define HLRS_TO_RIGHT(x)  ((((uSint)(x)) & HLRS_LEFT) >> 18)
#define HLRS_MAKE(a, e)   ((((uSint)(a)) & HLRS_LEFT) | HLRS_TO_RIGHT(e))

static Sint hlrs_ga;
static Sint hlrs_gb;
static uSint hlrs_uga;
static volatile Sint hlrs_vga;
static Sint hlrs_buf[16];
static uSint hlrs_ubuf[16];

struct hlrs_pair {
  Sint a;
  Sint b;
};

struct hlrs_upair {
  uSint a;
  uSint b;
};

static struct hlrs_pair hlrs_gp;
static struct hlrs_upair hlrs_ugp;

/*
 * Basic HLRS pressure: update E and return the same resulting word.
 */

static Sint
hlrs_mem(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t;
}

static Sint
hlrs_mem_alt(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRS_MAKE(ac, e);
  *p = t;
  return t;
}

static Sint
hlrs_mem_return_ac(p, ac)
Sint *p;
Sint ac;
{
  ac = (Sint)HLRS_MAKE(ac, *p);
  *p = ac;
  return ac;
}

static Sint
hlrs_global(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, hlrs_ga);
  hlrs_ga = t;
  return t;
}

static Sint
hlrs_global_b(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, hlrs_gb);
  hlrs_gb = t;
  return t;
}

static Sint
hlrs_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hlrs_global_array(i, ac)
Sint i;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, hlrs_buf[i & 017]);
  hlrs_buf[i & 017] = t;
  return t;
}

static Sint
hlrs_struct_a(p, ac)
struct hlrs_pair *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, p->a);
  p->a = t;
  return t;
}

static Sint
hlrs_struct_b(p, ac)
struct hlrs_pair *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, p->b);
  p->b = t;
  return t;
}

static Sint
hlrs_global_struct_a(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, hlrs_gp.a);
  hlrs_gp.a = t;
  return t;
}

static Sint
hlrs_global_struct_b(ac)
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, hlrs_gp.b);
  hlrs_gp.b = t;
  return t;
}

static Sint
hlrs_indirect(pp, ac)
Sint **pp;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, **pp);
  **pp = t;
  return t;
}

static Sint
hlrs_volatile(p, ac)
volatile Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRS_MAKE(ac, e);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hlrs_add(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t + y;
}

static Sint
hlrs_sub(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t - y;
}

static Sint
hlrs_xor(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t ^ y;
}

static Sint
hlrs_or(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t | y;
}

static Sint
hlrs_and(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t & y;
}

static Sint
hlrs_call_add(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t + f();
}

static Sint
hlrs_call_before(p, ac)
Sint *p;
Sint ac;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLRS result.
 */

static Sint
hlrs_if_result_zero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hlrs_if_result_nonzero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hlrs_if_result_negative(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hlrs_likely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hlrs_unlikely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hlrs_sources_live(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRS_MAKE(ac, e);
  *p = t;
  return t + e + ac + y;
}

static Sint
hlrs_left_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t + (ac & HLRS_LEFT);
}

static Sint
hlrs_e_left_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRS_MAKE(ac, e);
  *p = t;
  return t + (e & HLRS_LEFT);
}

static Sint
hlrs_right_result_live(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t + (t & HLRS_RIGHT);
}

static Sint
hlrs_two_updates(p, q, ac)
Sint *p;
Sint *q;
Sint ac;
{
  Sint t;
  Sint u;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  u = (Sint)HLRS_MAKE(t, *q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hlrs_loop(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  t = ac;
  while (n-- > 0) {
    t = (Sint)HLRS_MAKE(t, *p);
    *p = t;
  }

  return t;
}

static Sint
hlrs_loop_sum(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  t = ac;
  while (n-- > 0) {
    t = (Sint)HLRS_MAKE(t, *p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hlrs_loop_break(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HLRS_MAKE(ac, *p);
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
hlrs_store_then_load(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return *p;
}

static Sint
hlrs_store_then_bool(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return *p != 0;
}

static Sint
hlrs_store_then_add(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return *p + y;
}

/*
 * Make both preserved/copied halves visible after the update.
 */

static Sint
hlrs_left_after_update(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t & HLRS_LEFT;
}

static Sint
hlrs_right_after_update(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t & HLRS_RIGHT;
}

static Sint
hlrs_mix_after_update(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return (t & HLRS_LEFT) + (t & HLRS_RIGHT) + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhlrs_mem(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, *p);
  *p = t;
  return t;
}

static uSint
uhlrs_global(ac)
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, hlrs_uga);
  hlrs_uga = t;
  return t;
}

static uSint
uhlrs_array(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhlrs_global_array(i, ac)
Sint i;
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, hlrs_ubuf[i & 017]);
  hlrs_ubuf[i & 017] = t;
  return t;
}

static uSint
uhlrs_struct_a(p, ac)
struct hlrs_upair *p;
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, p->a);
  p->a = t;
  return t;
}

static uSint
uhlrs_global_struct_a(ac)
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, hlrs_ugp.a);
  hlrs_ugp.a = t;
  return t;
}

static uSint
uhlrs_add(p, ac, y)
uSint *p;
uSint ac;
uSint y;
{
  uSint t;

  t = HLRS_MAKE(ac, *p);
  *p = t;
  return t + y;
}

static Sint
uhlrs_bool(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, *p);
  *p = t;
  return t != 0;
}

static uSint
uhlrs_right_after_update(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = HLRS_MAKE(ac, *p);
  *p = t;
  return t & HLRS_RIGHT;
}

/*
 * Promoted small-type AC-left sources are not a natural HLRS match,
 * because HLRS is a full-word halfword operation.  Keep the promoted
 * cases as source-through-temporary pressure only.
 */

static Sint
hlrs_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t;
}

static Sint
hlrs_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t;
}

static Sint
hlrs_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t;
}

static Sint
hlrs_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint ac;
  Sint t;

  ac = ((Sint)a) << 18;
  t = (Sint)HLRS_MAKE(ac, *p);
  *p = t;
  return t;
}
