#include "insns.h"

/*
 * HRRES instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRRES AC,E    AC <- sign-extension-of-E-right,,E-right
 *                E  <- sign-extension-of-E-right,,E-right
 *
 * HRRES is the self form of HRRE.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   r = E & RIGHT_HALF;
 *   t = r | ((r & RIGHT_SIGN) ? LEFT_HALF : 0);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRRES:
 *   - source half comes from E right half
 *   - result right half is old E right half
 *   - result left half is sign extension of old E right half
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRRE.c.
 */

extern Sint f(void);

#define HRRES_LEFT   0777777000000
#define HRRES_RIGHT  0000000777777
#define HRRES_RSIGN  0000000400000
#define HRRES_EXT(x) ((((uSint)(x)) & HRRES_RSIGN) ? HRRES_LEFT : 0)
#define HRRES_MAKE(x) ((((uSint)(x)) & HRRES_RIGHT) | HRRES_EXT(x))

static Sint hrres_ga;
static Sint hrres_gb;
static uSint hrres_uga;
static volatile Sint hrres_vga;
static Sint hrres_buf[16];
static uSint hrres_ubuf[16];

struct hrres_pair {
  Sint a;
  Sint b;
};

struct hrres_upair {
  uSint a;
  uSint b;
};

static struct hrres_pair hrres_gp;
static struct hrres_upair hrres_ugp;

/*
 * Basic HRRES pressure: update E and return the same resulting word.
 */

static Sint
hrres_mem(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrres_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint r;
  Sint t;

  e = *p;
  r = e & HRRES_RIGHT;
  t = r | ((r & HRRES_RSIGN) ? HRRES_LEFT : 0);
  *p = t;
  return t;
}

static Sint
hrres_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = (Sint)HRRES_MAKE(*p);
  *p = ac;
  return ac;
}

static Sint
hrres_global(void)
{
  Sint t;

  t = (Sint)HRRES_MAKE(hrres_ga);
  hrres_ga = t;
  return t;
}

static Sint
hrres_global_b(void)
{
  Sint t;

  t = (Sint)HRRES_MAKE(hrres_gb);
  hrres_gb = t;
  return t;
}

static Sint
hrres_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = (Sint)HRRES_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static Sint
hrres_global_array(i)
Sint i;
{
  Sint t;

  t = (Sint)HRRES_MAKE(hrres_buf[i & 017]);
  hrres_buf[i & 017] = t;
  return t;
}

static Sint
hrres_struct_a(p)
struct hrres_pair *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(p->a);
  p->a = t;
  return t;
}

static Sint
hrres_struct_b(p)
struct hrres_pair *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(p->b);
  p->b = t;
  return t;
}

static Sint
hrres_global_struct_a(void)
{
  Sint t;

  t = (Sint)HRRES_MAKE(hrres_gp.a);
  hrres_gp.a = t;
  return t;
}

static Sint
hrres_global_struct_b(void)
{
  Sint t;

  t = (Sint)HRRES_MAKE(hrres_gp.b);
  hrres_gp.b = t;
  return t;
}

static Sint
hrres_indirect(pp)
Sint **pp;
{
  Sint t;

  t = (Sint)HRRES_MAKE(**pp);
  **pp = t;
  return t;
}

static Sint
hrres_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRRES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrres_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hrres_vga;
  t = (Sint)HRRES_MAKE(e);
  hrres_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrres_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
hrres_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t - y;
}

static Sint
hrres_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t ^ y;
}

static Sint
hrres_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t | y;
}

static Sint
hrres_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t & y;
}

static Sint
hrres_call_add(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t + f();
}

static Sint
hrres_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRRES result.
 */

static Sint
hrres_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrres_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrres_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrres_likely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrres_unlikely(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the sign-extension behavior visible.
 */

static Sint
hrres_ext_bits(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t & HRRES_LEFT;
}

static Sint
hrres_right_bits(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t & HRRES_RIGHT;
}

static Sint
hrres_source_right_sign(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRRES_MAKE(e);
  *p = t;
  return e & HRRES_RSIGN;
}

static Sint
hrres_ext_is_ones(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return (t & HRRES_LEFT) == HRRES_LEFT;
}

static Sint
hrres_ext_is_zero(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return (t & HRRES_LEFT) == 0;
}

static Sint
hrres_mix_after_extend(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return (t & HRRES_LEFT) + (t & HRRES_RIGHT) + y;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrres_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRRES_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hrres_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRRES_MAKE(e);
  *p = t;
  return t + (e & HRRES_RIGHT);
}

static Sint
hrres_left_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRRES_MAKE(e);
  *p = t;
  return t + (e & HRRES_LEFT);
}

static Sint
hrres_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  u = (Sint)HRRES_MAKE(*q);
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrres_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = (Sint)HRRES_MAKE(*p);
    *p = t;
  }

  return t;
}

static Sint
hrres_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = (Sint)HRRES_MAKE(*p);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrres_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = (Sint)HRRES_MAKE(*p);
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
hrres_store_then_load(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return *p;
}

static Sint
hrres_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return *p != 0;
}

static Sint
hrres_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrres_mem(p)
uSint *p;
{
  uSint t;

  t = HRRES_MAKE(*p);
  *p = t;
  return t;
}

static uSint
uhrres_global(void)
{
  uSint t;

  t = HRRES_MAKE(hrres_uga);
  hrres_uga = t;
  return t;
}

static uSint
uhrres_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = HRRES_MAKE(v[i & 017]);
  v[i & 017] = t;
  return t;
}

static uSint
uhrres_global_array(i)
Sint i;
{
  uSint t;

  t = HRRES_MAKE(hrres_ubuf[i & 017]);
  hrres_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrres_struct_a(p)
struct hrres_upair *p;
{
  uSint t;

  t = HRRES_MAKE(p->a);
  p->a = t;
  return t;
}

static uSint
uhrres_global_struct_a(void)
{
  uSint t;

  t = HRRES_MAKE(hrres_ugp.a);
  hrres_ugp.a = t;
  return t;
}

static uSint
uhrres_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = HRRES_MAKE(*p);
  *p = t;
  return t + y;
}

static Sint
uhrres_bool(p)
uSint *p;
{
  uSint t;

  t = HRRES_MAKE(*p);
  *p = t;
  return t != 0;
}

static uSint
uhrres_right_bits(p)
uSint *p;
{
  uSint t;

  t = HRRES_MAKE(*p);
  *p = t;
  return t & HRRES_RIGHT;
}

static uSint
uhrres_ext_bits(p)
uSint *p;
{
  uSint t;

  t = HRRES_MAKE(*p);
  *p = t;
  return t & HRRES_LEFT;
}

/*
 * Promoted small-type memory destinations are not a natural HRRES
 * match, because HRRES is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hrres_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrres_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrres_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t;
}

static Sint
hrres_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = (Sint)a;
  t = (Sint)HRRES_MAKE(*p);
  *p = t;
  return t;
}

