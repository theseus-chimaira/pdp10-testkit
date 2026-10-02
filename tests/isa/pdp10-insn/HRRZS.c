#include "insns.h"

/*
 * HRRZS instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended form:
 *   HRRZS AC,E    AC <- 0,,E-right
 *                E  <- 0,,E-right
 *
 * HRRZS is the self form of HRRZ.  It is not just a memory store and
 * not just a register result: the computed full word is written back
 * to E and also remains visible as the AC result.
 *
 * Ordinary C shape:
 *
 *   t = *p & RIGHT_HALF;
 *   *p = t;
 *   return t;
 *
 * Keep this file focused on HRRZS:
 *   - source right half comes from E
 *   - result left half is zero
 *   - result is stored back through E
 *   - result is also returned or otherwise used
 *
 * Register-only forms belong to HRRZ.c.
 */

extern Sint f(void);

#define HRRZS_LEFT   0777777000000
#define HRRZS_RIGHT  0000000777777

static Sint hrrzs_ga;
static Sint hrrzs_gb;
static uSint hrrzs_uga;
static volatile Sint hrrzs_vga;
static Sint hrrzs_buf[16];
static uSint hrrzs_ubuf[16];

struct hrrzs_pair {
  Sint a;
  Sint b;
};

struct hrrzs_upair {
  uSint a;
  uSint b;
};

static struct hrrzs_pair hrrzs_gp;
static struct hrrzs_upair hrrzs_ugp;

/*
 * Basic HRRZS pressure: update E and return the same resulting word.
 */

static Sint
hrrzs_mem(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t;
}

static Sint
hrrzs_mem_alt(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HRRZS_RIGHT;
  *p = t;
  return t;
}

static Sint
hrrzs_mem_return_ac(p)
Sint *p;
{
  Sint ac;

  ac = *p & HRRZS_RIGHT;
  *p = ac;
  return ac;
}

static Sint
hrrzs_global(void)
{
  Sint t;

  t = hrrzs_ga & HRRZS_RIGHT;
  hrrzs_ga = t;
  return t;
}

static Sint
hrrzs_global_b(void)
{
  Sint t;

  t = hrrzs_gb & HRRZS_RIGHT;
  hrrzs_gb = t;
  return t;
}

static Sint
hrrzs_array(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = v[i & 017] & HRRZS_RIGHT;
  v[i & 017] = t;
  return t;
}

static Sint
hrrzs_global_array(i)
Sint i;
{
  Sint t;

  t = hrrzs_buf[i & 017] & HRRZS_RIGHT;
  hrrzs_buf[i & 017] = t;
  return t;
}

static Sint
hrrzs_struct_a(p)
struct hrrzs_pair *p;
{
  Sint t;

  t = p->a & HRRZS_RIGHT;
  p->a = t;
  return t;
}

static Sint
hrrzs_struct_b(p)
struct hrrzs_pair *p;
{
  Sint t;

  t = p->b & HRRZS_RIGHT;
  p->b = t;
  return t;
}

static Sint
hrrzs_global_struct_a(void)
{
  Sint t;

  t = hrrzs_gp.a & HRRZS_RIGHT;
  hrrzs_gp.a = t;
  return t;
}

static Sint
hrrzs_global_struct_b(void)
{
  Sint t;

  t = hrrzs_gp.b & HRRZS_RIGHT;
  hrrzs_gp.b = t;
  return t;
}

static Sint
hrrzs_indirect(pp)
Sint **pp;
{
  Sint t;

  t = **pp & HRRZS_RIGHT;
  **pp = t;
  return t;
}

static Sint
hrrzs_volatile(p)
volatile Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HRRZS_RIGHT;
  *p = t;
  return t;
}

static Sint
hrrzs_volatile_global(void)
{
  Sint e;
  Sint t;

  e = hrrzs_vga;
  t = e & HRRZS_RIGHT;
  hrrzs_vga = t;
  return t;
}

/*
 * Result consumed after the self update.  These forms prevent the
 * store-only halfword patterns from looking sufficient.
 */

static Sint
hrrzs_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t + y;
}

static Sint
hrrzs_sub(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t - y;
}

static Sint
hrrzs_xor(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t ^ y;
}

static Sint
hrrzs_or(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t | y;
}

static Sint
hrrzs_and(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t & y;
}

static Sint
hrrzs_call_add(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t + f();
}

static Sint
hrrzs_call_before(p)
Sint *p;
{
  Sint x;
  Sint t;

  x = f();
  t = *p & HRRZS_RIGHT;
  *p = t;
  return t + x;
}

/*
 * Branches using the HRRZS result.
 */

static Sint
hrrzs_if_result_zero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  if (t == 0)
    return yes;
  return no;
}

static Sint
hrrzs_if_result_nonzero(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  if (t != 0)
    return yes;
  return no;
}

static Sint
hrrzs_if_result_negative(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  if (t < 0)
    return yes;
  return no;
}

static Sint
hrrzs_likely(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  if (likely(t != 0))
    return t;
  return 0;
}

static Sint
hrrzs_unlikely(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  if (unlikely(t != 0))
    return t;
  return 0;
}

/*
 * Make the zeroed left half and preserved right half visible.
 */

static Sint
hrrzs_left_is_zero(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t & HRRZS_LEFT;
}

static Sint
hrrzs_right_bits(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t & HRRZS_RIGHT;
}

static Sint
hrrzs_right_nonzero(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return (t & HRRZS_RIGHT) != 0;
}

static Sint
hrrzs_left_zero_bool(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return (t & HRRZS_LEFT) == 0;
}

static Sint
hrrzs_mix_after_zero(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return (t & HRRZS_LEFT) + (t & HRRZS_RIGHT) + y;
}

/*
 * Keep source pieces live around the operation.
 */

static Sint
hrrzs_source_live(p, y)
Sint *p;
Sint y;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HRRZS_RIGHT;
  *p = t;
  return t + e + y;
}

static Sint
hrrzs_right_source_live(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HRRZS_RIGHT;
  *p = t;
  return t + (e & HRRZS_RIGHT);
}

static Sint
hrrzs_left_source_dead(p)
Sint *p;
{
  Sint e;
  Sint t;

  e = *p;
  t = e & HRRZS_RIGHT;
  *p = t;
  return t + (e & HRRZS_LEFT);
}

static Sint
hrrzs_two_updates(p, q)
Sint *p;
Sint *q;
{
  Sint t;
  Sint u;

  t = *p & HRRZS_RIGHT;
  *p = t;
  u = *q & HRRZS_RIGHT;
  *q = u;
  return t + u;
}

/*
 * Loop and compound-control pressure.
 */

static Sint
hrrzs_loop(p, n)
Sint *p;
Sint n;
{
  Sint t;

  t = 0;
  while (n-- > 0) {
    t = *p & HRRZS_RIGHT;
    *p = t;
  }

  return t;
}

static Sint
hrrzs_loop_sum(p, n)
Sint *p;
Sint n;
{
  Sint s;
  Sint t;

  s = 0;
  while (n-- > 0) {
    t = *p & HRRZS_RIGHT;
    *p = t;
    s += t;
  }

  return s;
}

static Sint
hrrzs_loop_break(p, n)
Sint *p;
Sint n;
{
  Sint t;

  while (n-- > 0) {
    t = *p & HRRZS_RIGHT;
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
hrrzs_store_then_load(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return *p;
}

static Sint
hrrzs_store_then_bool(p)
Sint *p;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return *p != 0;
}

static Sint
hrrzs_store_then_add(p, y)
Sint *p;
Sint y;
{
  Sint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return *p + y;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
uhrrzs_mem(p)
uSint *p;
{
  uSint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t;
}

static uSint
uhrrzs_global(void)
{
  uSint t;

  t = hrrzs_uga & HRRZS_RIGHT;
  hrrzs_uga = t;
  return t;
}

static uSint
uhrrzs_array(v, i)
uSint *v;
Sint i;
{
  uSint t;

  t = v[i & 017] & HRRZS_RIGHT;
  v[i & 017] = t;
  return t;
}

static uSint
uhrrzs_global_array(i)
Sint i;
{
  uSint t;

  t = hrrzs_ubuf[i & 017] & HRRZS_RIGHT;
  hrrzs_ubuf[i & 017] = t;
  return t;
}

static uSint
uhrrzs_struct_a(p)
struct hrrzs_upair *p;
{
  uSint t;

  t = p->a & HRRZS_RIGHT;
  p->a = t;
  return t;
}

static uSint
uhrrzs_global_struct_a(void)
{
  uSint t;

  t = hrrzs_ugp.a & HRRZS_RIGHT;
  hrrzs_ugp.a = t;
  return t;
}

static uSint
uhrrzs_add(p, y)
uSint *p;
uSint y;
{
  uSint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t + y;
}

static Sint
uhrrzs_bool(p)
uSint *p;
{
  uSint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t != 0;
}

static uSint
uhrrzs_right_bits(p)
uSint *p;
{
  uSint t;

  t = *p & HRRZS_RIGHT;
  *p = t;
  return t & HRRZS_RIGHT;
}

/*
 * Promoted small-type memory destinations are not a natural HRRZS
 * match, because HRRZS is a full-word halfword operation.  Keep the
 * promoted cases as source-through-temporary pressure only.
 */

static Sint
hrrzs_sqi_temp(p, a)
Sint *p;
sQint a;
{
  Sint t;

  *p = ((Sint)a) | HRRZS_LEFT;
  t = *p & HRRZS_RIGHT;
  *p = t;
  return t;
}

static Sint
hrrzs_uqi_temp(p, a)
Sint *p;
uQint a;
{
  Sint t;

  *p = ((Sint)a) | HRRZS_LEFT;
  t = *p & HRRZS_RIGHT;
  *p = t;
  return t;
}

static Sint
hrrzs_hi_temp(p, a)
Sint *p;
Hint a;
{
  Sint t;

  *p = ((Sint)a) | HRRZS_LEFT;
  t = *p & HRRZS_RIGHT;
  *p = t;
  return t;
}

static Sint
hrrzs_uhi_temp(p, a)
Sint *p;
uHint a;
{
  Sint t;

  *p = ((Sint)a) | HRRZS_LEFT;
  t = *p & HRRZS_RIGHT;
  *p = t;
  return t;
}
