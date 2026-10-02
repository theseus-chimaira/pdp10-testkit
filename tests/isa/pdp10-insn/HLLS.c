#include "insns.h"

/*
 * HLLS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLLS  AC,E    AC <- E-left,,AC-right
 *                E  <- E-left,,AC-right
 *
 * HLLS is the self form of HLL.  It is not just a memory store and not
 * just a register result: the computed full word is written back to E
 * and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (*p & LEFT_HALF) | (ac & RIGHT_HALF);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLLS:
 *   - source left half comes from E
 *   - source right half comes from AC
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Store-only forms belong to HRRM/related halfword-memory tests.
 * Register-only forms belong to HLL.c.
 */

extern Sint f(void);

#define HLLS_LEFT   0777777000000
#define HLLS_RIGHT  0000000777777

static Sint hlls_ga;
static Sint hlls_gb;
static uSint hlls_uga;
static volatile Sint hlls_vga;
static Sint hlls_buf[16];
static uSint hlls_ubuf[16];

struct hlls_pair {
  Sint a;
  Sint b;
};

struct hlls_upair {
  uSint a;
  uSint b;
};

static struct hlls_pair hlls_gp;
static struct hlls_upair hlls_ugp;

/*
 * Basic HLLS pressure: update E and return the same resulting word.
 */

static Sint
hlls_mem(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t;
}

static Sint
hlls_mem_alt(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (e & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t;
}

static Sint
hlls_mem_return_ac(p, ac)
Sint *p;
Sint ac;
{
  ac = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = ac;
  return ac;
}

static Sint
hlls_global(ac)
Sint ac;
{
  Sint t;

  t = (hlls_ga & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_ga = t;
  return t;
}

static Sint
hlls_global_b(ac)
Sint ac;
{
  Sint t;

  t = (hlls_gb & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_gb = t;
  return t;
}

static Sint
hlls_array(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  Sint t;

  t = (v[i & 017] & HLLS_LEFT) | (ac & HLLS_RIGHT);
  v[i & 017] = t;
  return t;
}

static Sint
hlls_global_array(i, ac)
Sint i;
Sint ac;
{
  Sint t;

  t = (hlls_buf[i & 017] & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_buf[i & 017] = t;
  return t;
}

static Sint
hlls_struct_a(p, ac)
struct hlls_pair *p;
Sint ac;
{
  Sint t;

  t = (p->a & HLLS_LEFT) | (ac & HLLS_RIGHT);
  p->a = t;
  return t;
}

static Sint
hlls_struct_b(p, ac)
struct hlls_pair *p;
Sint ac;
{
  Sint t;

  t = (p->b & HLLS_LEFT) | (ac & HLLS_RIGHT);
  p->b = t;
  return t;
}

static Sint
hlls_global_struct_a(ac)
Sint ac;
{
  Sint t;

  t = (hlls_gp.a & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_gp.a = t;
  return t;
}

static Sint
hlls_global_struct_b(ac)
Sint ac;
{
  Sint t;

  t = (hlls_gp.b & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_gp.b = t;
  return t;
}

static Sint
hlls_indirect(pp, ac)
Sint **pp;
Sint ac;
{
  Sint t;

  t = (**pp & HLLS_LEFT) | (ac & HLLS_RIGHT);
  **pp = t;
  return t;
}

static Sint
hlls_volatile(p, ac)
volatile Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (e & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hlls_add(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + y;
}

static Sint
hlls_sub(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t - y;
}

static Sint
hlls_xor(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t ^ y;
}

static Sint
hlls_or(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t | y;
}

static Sint
hlls_and(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t & y;
}

static Sint
hlls_call_add(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + f();
}

static Sint
hlls_call_before(p, ac)
Sint *p;
Sint ac;
{
  Sint x;
  Sint t;

  x = f();
  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLLS result.
 */

static Sint
hlls_if_result_zero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hlls_if_result_nonzero(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hlls_if_result_negative(p, ac, yes, no)
Sint *p;
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hlls_likely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hlls_unlikely(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hlls_sources_live(p, ac, y)
Sint *p;
Sint ac;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (e & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + e + ac + y;
}

static Sint
hlls_right_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + (ac & HLLS_RIGHT);
}

static Sint
hlls_left_source_live(p, ac)
Sint *p;
Sint ac;
{
  Sint e;
  Sint t;

  e = *p;
  t = (e & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + (e & HLLS_LEFT);
}

static Sint
hlls_two_updates(p, q, ac)
Sint *p;
Sint *q;
Sint ac;
{
  Sint t;
  Sint u;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  u = (*q & HLLS_LEFT) | (t & HLLS_RIGHT);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hlls_loop(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  t = ac;
  while (n-- > 0) {
    t = (*p & HLLS_LEFT) | (t & HLLS_RIGHT);
    *p = t;
  }

  return t;
}

static Sint
hlls_loop_sum(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  t = ac;
  while (n-- > 0) {
    t = (*p & HLLS_LEFT) | (t & HLLS_RIGHT);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hlls_loop_break(p, ac, n)
Sint *p;
Sint ac;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
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
uhlls_mem(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t;
}

static uSint
uhlls_global(ac)
uSint ac;
{
  uSint t;

  t = (hlls_uga & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_uga = t;
  return t;
}

static uSint
uhlls_array(v, i, ac)
uSint *v;
Sint i;
uSint ac;
{
  uSint t;

  t = (v[i & 017] & HLLS_LEFT) | (ac & HLLS_RIGHT);
  v[i & 017] = t;
  return t;
}

static uSint
uhlls_global_array(i, ac)
Sint i;
uSint ac;
{
  uSint t;

  t = (hlls_ubuf[i & 017] & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_ubuf[i & 017] = t;
  return t;
}

static uSint
uhlls_struct_a(p, ac)
struct hlls_upair *p;
uSint ac;
{
  uSint t;

  t = (p->a & HLLS_LEFT) | (ac & HLLS_RIGHT);
  p->a = t;
  return t;
}

static uSint
uhlls_global_struct_a(ac)
uSint ac;
{
  uSint t;

  t = (hlls_ugp.a & HLLS_LEFT) | (ac & HLLS_RIGHT);
  hlls_ugp.a = t;
  return t;
}

static uSint
uhlls_add(p, ac, y)
uSint *p;
uSint ac;
uSint y;
{
  uSint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t + y;
}

static Sint
uhlls_bool(p, ac)
uSint *p;
uSint ac;
{
  uSint t;

  t = (*p & HLLS_LEFT) | (ac & HLLS_RIGHT);
  *p = t;
  return t != 0;
}

/*
 * Promoted small-type right-half sources.  These are secondary
 * pressure only; the main HLLS shape is full-word AC/E.
 */

static Sint
hlls_sqi_right(p, ac)
Sint *p;
sQint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (((Sint)ac) & HLLS_RIGHT);
  *p = t;
  return t;
}

static Sint
hlls_uqi_right(p, ac)
Sint *p;
uQint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (((Sint)ac) & HLLS_RIGHT);
  *p = t;
  return t;
}

static Sint
hlls_hi_right(p, ac)
Sint *p;
Hint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (((Sint)ac) & HLLS_RIGHT);
  *p = t;
  return t;
}

static Sint
hlls_uhi_right(p, ac)
Sint *p;
uHint ac;
{
  Sint t;

  t = (*p & HLLS_LEFT) | (((Sint)ac) & HLLS_RIGHT);
  *p = t;
  return t;
}
