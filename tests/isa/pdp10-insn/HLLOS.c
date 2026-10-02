#include "insns.h"

/*
 * HLLOS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLLOS AC,E    AC <- E-left,,ones
 *                E  <- E-left,,ones
 *
 * HLLOS is the self form of HLLO.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (E & LEFT_HALF) | RIGHT_HALF;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLLOS:
 *   - source left half comes from E
 *   - result right half is all ones
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HLLO.c.
 */

extern Sint f(void);

#define HLLOS_LEFT   0777777000000
#define HLLOS_RIGHT  0000000777777
#define HLLOS_MAKE(x)  (((x) & HLLOS_LEFT) | HLLOS_RIGHT)

static Sint hllos_ga;
static Sint hllos_gb;
static uSint hllos_uga;
static volatile Sint hllos_vga;
static Sint hllos_buf[16];
static uSint hllos_ubuf[16];

struct hllos_pair {
  Sint a;
  Sint b;
};

struct hllos_upair {
  uSint a;
  uSint b;
};

static struct hllos_pair hllos_gp;
static struct hllos_upair hllos_ugp;

/*
 * Basic HLLOS pressure: update E and return the same resulting word.
 */

static Sint
hllos_mem(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hllos_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLOS_MAKE(e);
  *p = t;
  return t;
}

static Sint
hllos_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = HLLOS_MAKE(*p);
  *p = ac;
  return ac;
}

static Sint
hllos_global(void)
{
  Sint t;

  t = HLLOS_MAKE(hllos_ga);
  hllos_ga = t;
  return t;
}

static Sint
hllos_global_b(void)
{
  Sint t;

  t = HLLOS_MAKE(hllos_gb);
  hllos_gb = t;
  return t;
}

static Sint
hllos_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = HLLOS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hllos_global_array(i)
Sint i;
{
  Sint t;

  t = HLLOS_MAKE(hllos_buf[i & 017]);
  hllos_buf[i & 017] = t;
  return t;
}

static Sint
hllos_struct_a(p)
struct hllos_pair *p;
{
  Sint t;

  t = HLLOS_MAKE(p->a);
  p->a = t;
  return t;
}

static Sint
hllos_struct_b(p)
struct hllos_pair *p;
{
  Sint t;

  t = HLLOS_MAKE(p->b);
  p->b = t;
  return t;
}

static Sint
hllos_global_struct_a(void)
{
  Sint t;

  t = HLLOS_MAKE(hllos_gp.a);
  hllos_gp.a = t;
  return t;
}

static Sint
hllos_global_struct_b(void)
{
  Sint t;

  t = HLLOS_MAKE(hllos_gp.b);
  hllos_gp.b = t;
  return t;
}

static Sint
hllos_indirect(pp)
Sint **pp;
{
  Sint t;

  t = HLLOS_MAKE(**pp);
  **pp = t;
  return t;
}

static Sint
hllos_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLOS_MAKE(e);
  *p = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hllos_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
hllos_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t - y;
}

static Sint
hllos_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t ^ y;
}

static Sint
hllos_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t | y;
}

static Sint
hllos_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t & y;
}

static Sint
hllos_call_add(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t + f();
}

static Sint
hllos_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = HLLOS_MAKE(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLLOS result.
 */

static Sint
hllos_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hllos_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hllos_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hllos_likely(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hllos_unlikely(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hllos_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLOS_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hllos_left_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLOS_MAKE(e);
  *p = t;
  return t + (e & HLLOS_LEFT);
}

static Sint
hllos_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLOS_MAKE(e);
  *p = t;
  return t + (e & HLLOS_RIGHT);
}

static Sint
hllos_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = HLLOS_MAKE(*p);
  *p = t;
  u = HLLOS_MAKE(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hllos_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = HLLOS_MAKE(*p);
    *p = t;
  }

  return t;
}

static Sint
hllos_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = HLLOS_MAKE(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hllos_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = HLLOS_MAKE(*p);
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
hllos_store_then_load(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return *p;
}

static Sint
hllos_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return *p != 0;
}

static Sint
hllos_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return *p + y;
}

/*
 * Make the all-ones right half visible after the update.
 */

static Sint
hllos_right_is_ones(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t & HLLOS_RIGHT;
}

static Sint
hllos_left_after_ones(p)
Sint *p;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t & HLLOS_LEFT;
}

static Sint
hllos_mix_after_ones(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return (t & HLLOS_LEFT) + (t & HLLOS_RIGHT) + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhllos_mem(p)
uSint *p;
{
  uSint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t;
}

static uSint
uhllos_global(void)
{
  uSint t;

  t = HLLOS_MAKE(hllos_uga);
  hllos_uga = t;
  return t;
}

static uSint
uhllos_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HLLOS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhllos_global_array(i)
Sint i;
{
  uSint t;

  t = HLLOS_MAKE(hllos_ubuf[i & 017]);
  hllos_ubuf[i & 017] = t;
  return t;
}

static uSint
uhllos_struct_a(p)
struct hllos_upair *p;
{
  uSint t;

  t = HLLOS_MAKE(p->a);
  p->a = t;
  return t;
}

static uSint
uhllos_global_struct_a(void)
{
  uSint t;

  t = HLLOS_MAKE(hllos_ugp.a);
  hllos_ugp.a = t;
  return t;
}

static uSint
uhllos_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
uhllos_bool(p)
uSint *p;
{
  uSint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t != 0;
}

static uSint
uhllos_right_is_ones(p)
uSint *p;
{
  uSint t;

  t = HLLOS_MAKE(*p);
  *p = t;
  return t & HLLOS_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HLLOS
 * match, because HLLOS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hllos_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = (Sint)a;
  t = HLLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hllos_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = (Sint)a;
  t = HLLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hllos_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = (Sint)a;
  t = HLLOS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hllos_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = (Sint)a;
  t = HLLOS_MAKE(*p);
  *p = t;
  return t;
}
