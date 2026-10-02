#include "insns.h"

/*
 * HRLES instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRLES AC,E    AC <- E-right,,sign-extension-of-E-right
 *                E  <- E-right,,sign-extension-of-E-right
 *
 * HRLES is the self form of HRLE.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   e = *p;
 *   r = e & RIGHT_HALF;
 *   t = (r << 18) | ((r & RIGHT_SIGN) ? RIGHT_HALF : 0);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRLES:
 *   - source half comes from E right half
 *   - result left half is E right half
 *   - result right half is sign extension of old E right half
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRLE.c.
 */

extern Sint f(void);

#define HRLES_RIGHT       0000000777777
#define HRLES_LEFT        0777777000000
#define HRLES_RSIGN       0000000400000
#define HRLES_TO_LEFT(x)  ((((uSint)(x)) & HRLES_RIGHT) << 18)
#define HRLES_EXT(x)      ((((uSint)(x)) & HRLES_RSIGN) ? HRLES_RIGHT : 0)
#define HRLES_MAKE(x)     (HRLES_TO_LEFT(x) | HRLES_EXT(x))

static Sint hrles_ga;
static Sint hrles_gb;
static uSint hrles_uga;
static volatile Sint hrles_vga;
static Sint hrles_buf[16];
static uSint hrles_ubuf[16];

struct hrles_pair {
  Sint a;
  Sint b;
};

struct hrles_upair {
  uSint a;
  uSint b;
};

static struct hrles_pair hrles_gp;
static struct hrles_upair hrles_ugp;

/*
 * Basic HRLES pressure: update E and return the same resulting word.
 */

static Sint
hrles_mem(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrles_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint r;
  Sint t;

  e = *p;
  r = e & HRLES_RIGHT;
  t = (Sint)((((uSint)r) << 18)
      | ((r & HRLES_RSIGN) ? HRLES_RIGHT : 0));
  *p = t;
  return t;
}

static Sint
hrles_mem_return_ac(p)
Sint *p;
{
  Sint ac;
  Sint e;

  e = *p;
  ac = (Sint)HRLES_MAKE(e);
  *p = ac;
  return ac;
}

static Sint
hrles_global(void)
{
  Sint e;
  Sint t;

  e = hrles_ga;
  t = (Sint)HRLES_MAKE(e);
  hrles_ga = t;
  return t;
}

static Sint
hrles_global_b(void)
{
  Sint e;
  Sint t;

  e = hrles_gb;
  t = (Sint)HRLES_MAKE(e);
  hrles_gb = t;
  return t;
}

static Sint
hrles_array(v, i)
Sint *v;
Sint i;
{
  Sint e;
  Sint t;

  e = v[i & 017];
  t = (Sint)HRLES_MAKE(e);
  v[i & 017] = t;
  return t;
}

static Sint
hrles_global_array(i)
Sint i;
{
  Sint e;
  Sint t;

  e = hrles_buf[i & 017];
  t = (Sint)HRLES_MAKE(e);
  hrles_buf[i & 017] = t;
  return t;
}

static Sint
hrles_struct_a(p)
struct hrles_pair *p;
{
  Sint e;
  Sint t;

  e = p->a;
  t = (Sint)HRLES_MAKE(e);
  p->a = t;
  return t;
}

static Sint
hrles_struct_b(p)
struct hrles_pair *p;
{
  Sint e;
  Sint t;

  e = p->b;
  t = (Sint)HRLES_MAKE(e);
  p->b = t;
  return t;
}

static Sint
hrles_global_struct_a(void)
{
  Sint e;
  Sint t;

  e = hrles_gp.a;
  t = (Sint)HRLES_MAKE(e);
  hrles_gp.a = t;
  return t;
}

static Sint
hrles_global_struct_b(void)
{
  Sint e;
  Sint t;

  e = hrles_gp.b;
  t = (Sint)HRLES_MAKE(e);
  hrles_gp.b = t;
  return t;
}

static Sint
hrles_indirect(pp)
Sint **pp;
{
  Sint e;
  Sint t;

  e = **pp;
  t = (Sint)HRLES_MAKE(e);
  **pp = t;
  return t;
}

static Sint
hrles_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrles_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hrles_vga;
  t = (Sint)HRLES_MAKE(e);
  hrles_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrles_add(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t + y;
}

static Sint
hrles_sub(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t - y;
}

static Sint
hrles_xor(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t ^ y;
}

static Sint
hrles_or(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t | y;
}

static Sint
hrles_and(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t & y;
}

static Sint
hrles_call_add(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t + f();
}

static Sint
hrles_call_before(p)
Sint *p;
{
  Sint x;
  Sint e;
  Sint t;

  x = f();
  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t + x;
}

/*
 * Branches using the HRLES result.
 */

static Sint
hrles_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrles_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrles_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrles_likely(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrles_unlikely(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the sign-extension behavior visible.
 */

static Sint
hrles_ext_bits(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t & HRLES_RIGHT;
}

static Sint
hrles_left_bits(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t & HRLES_LEFT;
}

static Sint
hrles_source_right_bits(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return e & HRLES_RIGHT;
}

static Sint
hrles_source_right_sign(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return e & HRLES_RSIGN;
}

static Sint
hrles_ext_is_ones(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return (t & HRLES_RIGHT) == HRLES_RIGHT;
}

static Sint
hrles_ext_is_zero(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return (t & HRLES_RIGHT) == 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrles_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hrles_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t + (e & HRLES_RIGHT);
}

static Sint
hrles_left_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t + (e & HRLES_LEFT);
}

static Sint
hrles_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint e;
  Sint t;
  Sint u;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;

  e = *q;
  u = (Sint)HRLES_MAKE(e);
  *q = u;

  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrles_loop(p, n)
Sint *p;
Sint n;
{
  Sint e;
  Sint t;

  t = 0;
  while (n-- > 0) {
    e = *p;
    t = (Sint)HRLES_MAKE(e);
    *p = t;
  }

  return t;
}

static Sint
hrles_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint e;
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    e = *p;
    t = (Sint)HRLES_MAKE(e);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrles_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint e;
  Sint t;

  while (n-- > 0) {
    e = *p;
    t = (Sint)HRLES_MAKE(e);
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
hrles_store_then_load(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return *p;
}

static Sint
hrles_store_then_bool(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return *p != 0;
}

static Sint
hrles_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrles_mem(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HRLES_MAKE(e);
  *p = t;
  return t;
}

static uSint
uhrles_global(void)
{
  uSint e;
  uSint t;

  e = hrles_uga;
  t = HRLES_MAKE(e);
  hrles_uga = t;
  return t;
}

static uSint
uhrles_array(v, i)
uSint *v;
Sint i;
{
  uSint e;
  uSint t;

  e = v[i & 017];
  t = HRLES_MAKE(e);
  v[i & 017] = t;
  return t;
}

static uSint
uhrles_global_array(i)
Sint i;
{
  uSint e;
  uSint t;

  e = hrles_ubuf[i & 017];
  t = HRLES_MAKE(e);
  hrles_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrles_struct_a(p)
struct hrles_upair *p;
{
  uSint e;
  uSint t;

  e = p->a;
  t = HRLES_MAKE(e);
  p->a = t;
  return t;
}

static uSint
uhrles_global_struct_a(void)
{
  uSint e;
  uSint t;

  e = hrles_ugp.a;
  t = HRLES_MAKE(e);
  hrles_ugp.a = t;
  return t;
}

static uSint
uhrles_add(p, y)
uSint *p;
uSint y;
{
  uSint e;
  uSint t;

  e = *p;
  t = HRLES_MAKE(e);
  *p = t;
  return t + y;
}

static Sint
uhrles_bool(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HRLES_MAKE(e);
  *p = t;
  return t != 0;
}

static uSint
uhrles_ext_bits(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HRLES_MAKE(e);
  *p = t;
  return t & HRLES_RIGHT;
}

static uSint
uhrles_source_right_bits(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HRLES_MAKE(e);
  *p = t;
  return e & HRLES_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HRLES
 * match, because HRLES is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hrles_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrles_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrles_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hrles_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = (Sint)HRLES_MAKE(e);
  *p = t;
  return t;
}
