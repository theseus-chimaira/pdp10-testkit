#include "insns.h"

/*
 * HLRZS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLRZS AC,E    AC <- 0,,E-left
 *                E  <- 0,,E-left
 *
 * HLRZS is the self form of HLRZ.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = (E & LEFT_HALF) >> 18;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLRZS:
 *   - source half comes from E left half
 *   - result right half is E left half shifted right
 *   - result left half is zero
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HLRZ.c.
 */

extern Sint f(void);

#define HLRZS_LEFT         0777777000000
#define HLRZS_RIGHT        0000000777777
#define HLRZS_TO_RIGHT(x)  ((((uSint)(x)) & HLRZS_LEFT) >> 18)

static Sint hlrzs_ga;
static Sint hlrzs_gb;
static uSint hlrzs_uga;
static volatile Sint hlrzs_vga;
static Sint hlrzs_buf[16];
static uSint hlrzs_ubuf[16];

struct hlrzs_pair {
  Sint a;
  Sint b;
};

struct hlrzs_upair {
  uSint a;
  uSint b;
};

static struct hlrzs_pair hlrzs_gp;
static struct hlrzs_upair hlrzs_ugp;

/*
 * Basic HLRZS pressure: update E and return the same resulting word.
 */

static Sint
hlrzs_mem(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t;
}

static Sint
hlrzs_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRZS_TO_RIGHT(e);
  *p = t;
  return t;
}

static Sint
hlrzs_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = (Sint)HLRZS_TO_RIGHT(*p);
  *p = ac;
  return ac;
}

static Sint
hlrzs_global(void)
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(hlrzs_ga);
  hlrzs_ga = t;
  return t;
}

static Sint
hlrzs_global_b(void)
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(hlrzs_gb);
  hlrzs_gb = t;
  return t;
}

static Sint
hlrzs_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hlrzs_global_array(i)
Sint i;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(hlrzs_buf[i & 017]);
  hlrzs_buf[i & 017] = t;
  return t;
}

static Sint
hlrzs_struct_a(p)
struct hlrzs_pair *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(p->a);
  p->a = t;
  return t;
}

static Sint
hlrzs_struct_b(p)
struct hlrzs_pair *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(p->b);
  p->b = t;
  return t;
}

static Sint
hlrzs_global_struct_a(void)
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(hlrzs_gp.a);
  hlrzs_gp.a = t;
  return t;
}

static Sint
hlrzs_global_struct_b(void)
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(hlrzs_gp.b);
  hlrzs_gp.b = t;
  return t;
}

static Sint
hlrzs_indirect(pp)
Sint **pp;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(**pp);
  **pp = t;
  return t;
}

static Sint
hlrzs_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRZS_TO_RIGHT(e);
  *p = t;
  return t;
}

static Sint
hlrzs_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hlrzs_vga;
  t = (Sint)HLRZS_TO_RIGHT(e);
  hlrzs_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hlrzs_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t + y;
}

static Sint
hlrzs_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t - y;
}

static Sint
hlrzs_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t ^ y;
}

static Sint
hlrzs_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t | y;
}

static Sint
hlrzs_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t & y;
}

static Sint
hlrzs_call_add(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t + f();
}

static Sint
hlrzs_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLRZS result.
 */

static Sint
hlrzs_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hlrzs_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hlrzs_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hlrzs_likely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hlrzs_unlikely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the zeroed left half and copied right half visible.
 */

static Sint
hlrzs_left_is_zero(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t & HLRZS_LEFT;
}

static Sint
hlrzs_right_bits(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t & HLRZS_RIGHT;
}

static Sint
hlrzs_right_nonzero(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return (t & HLRZS_RIGHT) != 0;
}

static Sint
hlrzs_left_zero_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return (t & HLRZS_LEFT) == 0;
}

static Sint
hlrzs_mix_after_zero(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return (t & HLRZS_LEFT) + (t & HLRZS_RIGHT) + y;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hlrzs_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRZS_TO_RIGHT(e);
  *p = t;
  return t + e + y;
}

static Sint
hlrzs_left_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRZS_TO_RIGHT(e);
  *p = t;
  return t + (e & HLRZS_LEFT);
}

static Sint
hlrzs_right_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRZS_TO_RIGHT(e);
  *p = t;
  return t + (e & HLRZS_RIGHT);
}

static Sint
hlrzs_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  u = (Sint)HLRZS_TO_RIGHT(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hlrzs_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = (Sint)HLRZS_TO_RIGHT(*p);
    *p = t;
  }

  return t;
}

static Sint
hlrzs_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = (Sint)HLRZS_TO_RIGHT(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hlrzs_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HLRZS_TO_RIGHT(*p);
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
hlrzs_store_then_load(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return *p;
}

static Sint
hlrzs_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return *p != 0;
}

static Sint
hlrzs_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhlrzs_mem(p)
uSint *p;
{
  uSint t;

  t = HLRZS_TO_RIGHT(*p);
  *p = t;
  return t;
}

static uSint
uhlrzs_global(void)
{
  uSint t;

  t = HLRZS_TO_RIGHT(hlrzs_uga);
  hlrzs_uga = t;
  return t;
}

static uSint
uhlrzs_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HLRZS_TO_RIGHT(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhlrzs_global_array(i)
Sint i;
{
  uSint t;

  t = HLRZS_TO_RIGHT(hlrzs_ubuf[i & 017]);
  hlrzs_ubuf[i & 017] = t;
  return t;
}

static uSint
uhlrzs_struct_a(p)
struct hlrzs_upair *p;
{
  uSint t;

  t = HLRZS_TO_RIGHT(p->a);
  p->a = t;
  return t;
}

static uSint
uhlrzs_global_struct_a(void)
{
  uSint t;

  t = HLRZS_TO_RIGHT(hlrzs_ugp.a);
  hlrzs_ugp.a = t;
  return t;
}

static uSint
uhlrzs_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HLRZS_TO_RIGHT(*p);
  *p = t;
  return t + y;
}

static Sint
uhlrzs_bool(p)
uSint *p;
{
  uSint t;

  t = HLRZS_TO_RIGHT(*p);
  *p = t;
  return t != 0;
}

static uSint
uhlrzs_right_bits(p)
uSint *p;
{
  uSint t;

  t = HLRZS_TO_RIGHT(*p);
  *p = t;
  return t & HLRZS_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HLRZS
 * match, because HLRZS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hlrzs_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t;
}

static Sint
hlrzs_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t;
}

static Sint
hlrzs_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t;
}

static Sint
hlrzs_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRZS_TO_RIGHT(*p);
  *p = t;
  return t;
}
