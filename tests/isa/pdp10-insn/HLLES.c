#include "insns.h"

/*
 * HLLES instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HLLES AC,E    AC <- E-left,,sign-extension-of-E-left
 *                E  <- E-left,,sign-extension-of-E-left
 *
 * HLLES is the self form of HLLE.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   e = *p;
 *   t = (e & LEFT_HALF) | ((e & LEFT_SIGN) ? RIGHT_HALF : 0);
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HLLES:
 *   - source left half comes from E
 *   - result right half is sign extension of E left half
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HLLE.c.
 */

extern Sint f(void);

#define HLLES_LEFT   0777777000000
#define HLLES_RIGHT  0000000777777
#define HLLES_SIGN   0400000000000
#define HLLES_EXT(x) (((x) & HLLES_SIGN) ? HLLES_RIGHT : 0)
#define HLLES_MAKE(x) (((x) & HLLES_LEFT) | HLLES_EXT(x))

static Sint hlles_ga;
static Sint hlles_gb;
static uSint hlles_uga;
static volatile Sint hlles_vga;
static Sint hlles_buf[16];
static uSint hlles_ubuf[16];

struct hlles_pair {
  Sint a;
  Sint b;
};

struct hlles_upair {
  uSint a;
  uSint b;
};

static struct hlles_pair hlles_gp;
static struct hlles_upair hlles_ugp;

/*
 * Basic HLLES pressure: update E and return the same resulting word.
 */

static Sint
hlles_mem(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlles_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = (e & HLLES_LEFT) | HLLES_EXT(e);
  *p = t;
  return t;
}

static Sint
hlles_mem_return_ac(p)
Sint *p;
{
  Sint ac;
  Sint e;

  e = *p;
  ac = HLLES_MAKE(e);
  *p = ac;
  return ac;
}

static Sint
hlles_global(void)
{
  Sint e;
  Sint t;

  e = hlles_ga;
  t = HLLES_MAKE(e);
  hlles_ga = t;
  return t;
}

static Sint
hlles_global_b(void)
{
  Sint e;
  Sint t;

  e = hlles_gb;
  t = HLLES_MAKE(e);
  hlles_gb = t;
  return t;
}

static Sint
hlles_array(v, i)
Sint *v;
Sint i;
{
  Sint e;
  Sint t;

  e = v[i & 017];
  t = HLLES_MAKE(e);
  v[i & 017] = t;
  return t;
}

static Sint
hlles_global_array(i)
Sint i;
{
  Sint e;
  Sint t;

  e = hlles_buf[i & 017];
  t = HLLES_MAKE(e);
  hlles_buf[i & 017] = t;
  return t;
}

static Sint
hlles_struct_a(p)
struct hlles_pair *p;
{
  Sint e;
  Sint t;

  e = p->a;
  t = HLLES_MAKE(e);
  p->a = t;
  return t;
}

static Sint
hlles_struct_b(p)
struct hlles_pair *p;
{
  Sint e;
  Sint t;

  e = p->b;
  t = HLLES_MAKE(e);
  p->b = t;
  return t;
}

static Sint
hlles_global_struct_a(void)
{
  Sint e;
  Sint t;

  e = hlles_gp.a;
  t = HLLES_MAKE(e);
  hlles_gp.a = t;
  return t;
}

static Sint
hlles_global_struct_b(void)
{
  Sint e;
  Sint t;

  e = hlles_gp.b;
  t = HLLES_MAKE(e);
  hlles_gp.b = t;
  return t;
}

static Sint
hlles_indirect(pp)
Sint **pp;
{
  Sint e;
  Sint t;

  e = **pp;
  t = HLLES_MAKE(e);
  **pp = t;
  return t;
}

static Sint
hlles_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlles_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hlles_vga;
  t = HLLES_MAKE(e);
  hlles_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hlles_add(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + y;
}

static Sint
hlles_sub(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t - y;
}

static Sint
hlles_xor(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t ^ y;
}

static Sint
hlles_or(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t | y;
}

static Sint
hlles_and(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t & y;
}

static Sint
hlles_call_add(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + f();
}

static Sint
hlles_call_before(p)
Sint *p;
{
  Sint x;
  Sint e;
  Sint t;

  x = f();
  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + x;
}

/*
 * Branches using the HLLES result.
 */

static Sint
hlles_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hlles_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hlles_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hlles_likely(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hlles_unlikely(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the sign-extension behavior visible.
 */

static Sint
hlles_ext_bits(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t & HLLES_RIGHT;
}

static Sint
hlles_left_bits(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t & HLLES_LEFT;
}

static Sint
hlles_sign_bit(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t & HLLES_SIGN;
}

static Sint
hlles_ext_is_ones(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return (t & HLLES_RIGHT) == HLLES_RIGHT;
}

static Sint
hlles_ext_is_zero(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return (t & HLLES_RIGHT) == 0;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hlles_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + e + y;
}

static Sint
hlles_left_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + (e & HLLES_LEFT);
}

static Sint
hlles_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + (e & HLLES_RIGHT);
}

static Sint
hlles_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint e;
  Sint t;
  Sint u;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;

  e = *q;
  u = HLLES_MAKE(e);
  *q = u;

  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hlles_loop(p, n)
Sint *p;
Sint n;
{
  Sint e;
  Sint t;

  t = 0;
  while (n-- > 0) {
    e = *p;
    t = HLLES_MAKE(e);
    *p = t;
  }

  return t;
}

static Sint
hlles_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint e;
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    e = *p;
    t = HLLES_MAKE(e);
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hlles_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint e;
  Sint t;

  while (n-- > 0) {
    e = *p;
    t = HLLES_MAKE(e);
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
hlles_store_then_load(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return *p;
}

static Sint
hlles_store_then_bool(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return *p != 0;
}

static Sint
hlles_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhlles_mem(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}

static uSint
uhlles_global(void)
{
  uSint e;
  uSint t;

  e = hlles_uga;
  t = HLLES_MAKE(e);
  hlles_uga = t;
  return t;
}

static uSint
uhlles_array(v, i)
uSint *v;
Sint i;
{
  uSint e;
  uSint t;

  e = v[i & 017];
  t = HLLES_MAKE(e);
  v[i & 017] = t;
  return t;
}

static uSint
uhlles_global_array(i)
Sint i;
{
  uSint e;
  uSint t;

  e = hlles_ubuf[i & 017];
  t = HLLES_MAKE(e);
  hlles_ubuf[i & 017] = t;
  return t;
}

static uSint
uhlles_struct_a(p)
struct hlles_upair *p;
{
  uSint e;
  uSint t;

  e = p->a;
  t = HLLES_MAKE(e);
  p->a = t;
  return t;
}

static uSint
uhlles_global_struct_a(void)
{
  uSint e;
  uSint t;

  e = hlles_ugp.a;
  t = HLLES_MAKE(e);
  hlles_ugp.a = t;
  return t;
}

static uSint
uhlles_add(p, y)
uSint *p;
uSint y;
{
  uSint e;
  uSint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t + y;
}

static Sint
uhlles_bool(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t != 0;
}

static uSint
uhlles_ext_bits(p)
uSint *p;
{
  uSint e;
  uSint t;

  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t & HLLES_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HLLES
 * match, because HLLES is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hlles_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlles_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlles_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}

static Sint
hlles_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint e;
  Sint t;

  *p = (Sint)a;
  e = *p;
  t = HLLES_MAKE(e);
  *p = t;
  return t;
}
