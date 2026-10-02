#include "insns.h"

/*
 * HLROS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLROS AC,E    AC <- ones,,E-left
 *                E  <- ones,,E-left
 *
 * HLROS is the self form of HLRO.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = LEFT_HALF | ((E & LEFT_HALF) >> 18);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLROS:
 *   - source half comes from E left half
 *   - result right half is E left half shifted right
 *   - result left half is all ones
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HLRO.c.
 */

extern Sint f(void);

#define HLROS_LEFT         0777777000000
#define HLROS_RIGHT        0000000777777
#define HLROS_TO_RIGHT(x)  ((((uSint)(x)) & HLROS_LEFT) >> 18)
#define HLROS_MAKE(x)      (HLROS_LEFT | HLROS_TO_RIGHT(x))

static Sint hlros_ga;
static Sint hlros_gb;
static uSint hlros_uga;
static volatile Sint hlros_vga;
static Sint hlros_buf[16];
static uSint hlros_ubuf[16];

struct hlros_pair {
  Sint a;
  Sint b;
};

struct hlros_upair {
  uSint a;
  uSint b;
};

static struct hlros_pair hlros_gp;
static struct hlros_upair hlros_ugp;

/*
 * Basic HLROS pressure: update E and return the same resulting word.
 */

static Sint
hlros_mem(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlros_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLROS_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlros_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = (Sint)HLROS_MAKE(*p);
  *p = ac;
  return ac;
}

static Sint
hlros_global(void)
{
  Sint t;

  t = (Sint)HLROS_MAKE(hlros_ga);
  hlros_ga = t;
  return t;
}

static Sint
hlros_global_b(void)
{
  Sint t;

  t = (Sint)HLROS_MAKE(hlros_gb);
  hlros_gb = t;
  return t;
}

static Sint
hlros_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = (Sint)HLROS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hlros_global_array(i)
Sint i;
{
  Sint t;

  t = (Sint)HLROS_MAKE(hlros_buf[i & 017]);
  hlros_buf[i & 017] = t;
  return t;
}

static Sint
hlros_struct_a(p)
struct hlros_pair *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(p->a);
  p->a = t;
  return t;
}

static Sint
hlros_struct_b(p)
struct hlros_pair *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(p->b);
  p->b = t;
  return t;
}

static Sint
hlros_global_struct_a(void)
{
  Sint t;

  t = (Sint)HLROS_MAKE(hlros_gp.a);
  hlros_gp.a = t;
  return t;
}

static Sint
hlros_global_struct_b(void)
{
  Sint t;

  t = (Sint)HLROS_MAKE(hlros_gp.b);
  hlros_gp.b = t;
  return t;
}

static Sint
hlros_indirect(pp)
Sint **pp;
{
  Sint t;

  t = (Sint)HLROS_MAKE(**pp);
  **pp = t;
  return t;
}

static Sint
hlros_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLROS_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlros_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hlros_vga;
  t = (Sint)HLROS_MAKE(e);
  hlros_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hlros_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
hlros_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t - y;
}

static Sint
hlros_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t ^ y;
}

static Sint
hlros_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t | y;
}

static Sint
hlros_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t & y;
}

static Sint
hlros_call_add(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t + f();
}

static Sint
hlros_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLROS result.
 */

static Sint
hlros_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hlros_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hlros_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hlros_likely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hlros_unlikely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the ones-filled left half and copied right half visible.
 */

static Sint
hlros_left_is_ones(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t & HLROS_LEFT;
}

static Sint
hlros_right_bits(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t & HLROS_RIGHT;
}

static Sint
hlros_right_nonzero(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return (t & HLROS_RIGHT) != 0;
}

static Sint
hlros_left_ones_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return (t & HLROS_LEFT) == HLROS_LEFT;
}

static Sint
hlros_mix_after_ones(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return (t & HLROS_LEFT) + (t & HLROS_RIGHT) + y;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hlros_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLROS_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hlros_left_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLROS_MAKE(e);
  *p = t;
  return t + (e & HLROS_LEFT);
}

static Sint
hlros_right_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLROS_MAKE(e);
  *p = t;
  return t + (e & HLROS_RIGHT);
}

static Sint
hlros_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  u = (Sint)HLROS_MAKE(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hlros_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = (Sint)HLROS_MAKE(*p);
    *p = t;
  }

  return t;
}

static Sint
hlros_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = (Sint)HLROS_MAKE(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hlros_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HLROS_MAKE(*p);
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
hlros_store_then_load(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return *p;
}

static Sint
hlros_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return *p != 0;
}

static Sint
hlros_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhlros_mem(p)
uSint *p;
{
  uSint t;

  t = HLROS_MAKE(*p);
  *p = t;
  return t;
}

static uSint
uhlros_global(void)
{
  uSint t;

  t = HLROS_MAKE(hlros_uga);
  hlros_uga = t;
  return t;
}

static uSint
uhlros_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HLROS_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhlros_global_array(i)
Sint i;
{
  uSint t;

  t = HLROS_MAKE(hlros_ubuf[i & 017]);
  hlros_ubuf[i & 017] = t;
  return t;
}

static uSint
uhlros_struct_a(p)
struct hlros_upair *p;
{
  uSint t;

  t = HLROS_MAKE(p->a);
  p->a = t;
  return t;
}

static uSint
uhlros_global_struct_a(void)
{
  uSint t;

  t = HLROS_MAKE(hlros_ugp.a);
  hlros_ugp.a = t;
  return t;
}

static uSint
uhlros_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HLROS_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
uhlros_bool(p)
uSint *p;
{
  uSint t;

  t = HLROS_MAKE(*p);
  *p = t;
  return t != 0;
}

static uSint
uhlros_right_bits(p)
uSint *p;
{
  uSint t;

  t = HLROS_MAKE(*p);
  *p = t;
  return t & HLROS_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HLROS
 * match, because HLROS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hlros_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlros_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlros_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlros_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLROS_MAKE(*p);
  *p = t;
  return t;
}
