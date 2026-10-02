#include "insns.h"

/*
 * HLRES instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLRES AC,E    AC <- sign-extension-of-E-left,,E-left
 *                E  <- sign-extension-of-E-left,,E-left
 *
 * HLRES is the self form of HLRE.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   l = E & LEFT_HALF;
 *   t = (l >> 18) | ((l & LEFT_SIGN) ? LEFT_HALF : 0);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLRES:
 *   - source half comes from E left half
 *   - result right half is old E left half shifted right
 *   - result left half is sign extension of old E left half
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HLRE.c.
 */

extern Sint f(void);

#define HLRES_LEFT         0777777000000
#define HLRES_RIGHT        0000000777777
#define HLRES_LSIGN        0400000000000
#define HLRES_TO_RIGHT(x)  ((((uSint)(x)) & HLRES_LEFT) >> 18)
#define HLRES_EXT(x)       ((((uSint)(x)) & HLRES_LSIGN) ? HLRES_LEFT : 0)
#define HLRES_MAKE(x)      (HLRES_TO_RIGHT(x) | HLRES_EXT(x))

static Sint hlres_ga;
static Sint hlres_gb;
static uSint hlres_uga;
static volatile Sint hlres_vga;
static Sint hlres_buf[16];
static uSint hlres_ubuf[16];

struct hlres_pair {
  Sint a;
  Sint b;
};

struct hlres_upair {
  uSint a;
  uSint b;
};

static struct hlres_pair hlres_gp;
static struct hlres_upair hlres_ugp;

/*
 * Basic HLRES pressure: update E and return the same resulting word.
 */

static Sint
hlres_mem(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlres_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint l;
  Sint t;

  e = *p;
  l = e & HLRES_LEFT;
  t = (Sint)((((uSint)l) >> 18)
      | ((l & HLRES_LSIGN) ? HLRES_LEFT : 0));
  *p = t;
  return t;
}

static Sint
hlres_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = (Sint)HLRES_MAKE(*p);
  *p = ac;
  return ac;
}

static Sint
hlres_global(void)
{
  Sint t;

  t = (Sint)HLRES_MAKE(hlres_ga);
  hlres_ga = t;
  return t;
}

static Sint
hlres_global_b(void)
{
  Sint t;

  t = (Sint)HLRES_MAKE(hlres_gb);
  hlres_gb = t;
  return t;
}

static Sint
hlres_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = (Sint)HLRES_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hlres_global_array(i)
Sint i;
{
  Sint t;

  t = (Sint)HLRES_MAKE(hlres_buf[i & 017]);
  hlres_buf[i & 017] = t;
  return t;
}

static Sint
hlres_struct_a(p)
struct hlres_pair *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(p->a);
  p->a = t;
  return t;
}

static Sint
hlres_struct_b(p)
struct hlres_pair *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(p->b);
  p->b = t;
  return t;
}

static Sint
hlres_global_struct_a(void)
{
  Sint t;

  t = (Sint)HLRES_MAKE(hlres_gp.a);
  hlres_gp.a = t;
  return t;
}

static Sint
hlres_global_struct_b(void)
{
  Sint t;

  t = (Sint)HLRES_MAKE(hlres_gp.b);
  hlres_gp.b = t;
  return t;
}

static Sint
hlres_indirect(pp)
Sint **pp;
{
  Sint t;

  t = (Sint)HLRES_MAKE(**pp);
  **pp = t;
  return t;
}

static Sint
hlres_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlres_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hlres_vga;
  t = (Sint)HLRES_MAKE(e);
  hlres_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hlres_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
hlres_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t - y;
}

static Sint
hlres_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t ^ y;
}

static Sint
hlres_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t | y;
}

static Sint
hlres_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t & y;
}

static Sint
hlres_call_add(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t + f();
}

static Sint
hlres_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLRES result.
 */

static Sint
hlres_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hlres_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hlres_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hlres_likely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hlres_unlikely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the sign-extension behavior visible.
 */

static Sint
hlres_ext_bits(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t & HLRES_LEFT;
}

static Sint
hlres_right_bits(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t & HLRES_RIGHT;
}

static Sint
hlres_source_left_sign(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRES_MAKE(e);
  *p = t;
  return e & HLRES_LSIGN;
}

static Sint
hlres_source_left_bits(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRES_MAKE(e);
  *p = t;
  return e & HLRES_LEFT;
}

static Sint
hlres_ext_is_ones(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return (t & HLRES_LEFT) == HLRES_LEFT;
}

static Sint
hlres_ext_is_zero(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return (t & HLRES_LEFT) == 0;
}

static Sint
hlres_mix_after_extend(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return (t & HLRES_LEFT) + (t & HLRES_RIGHT) + y;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hlres_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRES_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hlres_left_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRES_MAKE(e);
  *p = t;
  return t + (e & HLRES_LEFT);
}

static Sint
hlres_right_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HLRES_MAKE(e);
  *p = t;
  return t + (e & HLRES_RIGHT);
}

static Sint
hlres_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  u = (Sint)HLRES_MAKE(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hlres_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = (Sint)HLRES_MAKE(*p);
    *p = t;
  }

  return t;
}

static Sint
hlres_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = (Sint)HLRES_MAKE(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hlres_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HLRES_MAKE(*p);
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
hlres_store_then_load(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return *p;
}

static Sint
hlres_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return *p != 0;
}

static Sint
hlres_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhlres_mem(p)
uSint *p;
{
  uSint t;

  t = HLRES_MAKE(*p);
  *p = t;
  return t;
}

static uSint
uhlres_global(void)
{
  uSint t;

  t = HLRES_MAKE(hlres_uga);
  hlres_uga = t;
  return t;
}

static uSint
uhlres_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HLRES_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhlres_global_array(i)
Sint i;
{
  uSint t;

  t = HLRES_MAKE(hlres_ubuf[i & 017]);
  hlres_ubuf[i & 017] = t;
  return t;
}

static uSint
uhlres_struct_a(p)
struct hlres_upair *p;
{
  uSint t;

  t = HLRES_MAKE(p->a);
  p->a = t;
  return t;
}

static uSint
uhlres_global_struct_a(void)
{
  uSint t;

  t = HLRES_MAKE(hlres_ugp.a);
  hlres_ugp.a = t;
  return t;
}

static uSint
uhlres_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HLRES_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
uhlres_bool(p)
uSint *p;
{
  uSint t;

  t = HLRES_MAKE(*p);
  *p = t;
  return t != 0;
}

static uSint
uhlres_right_bits(p)
uSint *p;
{
  uSint t;

  t = HLRES_MAKE(*p);
  *p = t;
  return t & HLRES_RIGHT;
}

static uSint
uhlres_ext_bits(p)
uSint *p;
{
  uSint t;

  t = HLRES_MAKE(*p);
  *p = t;
  return t & HLRES_LEFT;
}

/*
 * Promoted small-type memory destinations are not a natural HLRES
 * match, because HLRES is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hlres_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlres_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlres_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hlres_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = ((Sint)a) << 18;
  t = (Sint)HLRES_MAKE(*p);
  *p = t;
  return t;
}
