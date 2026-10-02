#include "insns.h"

/*
 * TDNE instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TDNE AC,E     test AC & E, no modification, skip on the tested case
 *
 * Keep this file focused on full-word direct tests:
 *   - AC & memory
 *   - AC & full-word literal/pool constant
 *   - AC & global/array/struct memory
 *
 * Halfword immediate tests such as TRNE/TLNE and swapped tests such as
 * TSNE belong in their own files.
 */

extern Sint f(void);

static Sint tdne_ga;
static Sint tdne_gb;
static Sint tdne_mask_a = 0123456123456;
static Sint tdne_mask_b = 0525252252525;
static Sint tdne_buf[16];

struct tdne_pair {
  Sint a;
  Sint b;
};

static struct tdne_pair tdne_gp;

#define TDNE_CLEAR(N, EXPR)             \
static Sint                             \
tdne_clear_##N(ac)                      \
Sint ac;                                \
{                                       \
  if (EXPR)                             \
    ac = 0;                             \
  return ac;                            \
}

#define TDNE_CLEAR_LIKELY(N, EXPR)      \
static Sint                             \
tdne_clear_likely_##N(ac)               \
Sint ac;                                \
{                                       \
  if (likely(EXPR))                     \
    ac = 0;                             \
  return ac;                            \
}

#define TDNE_CLEAR_UNLIKELY(N, EXPR)    \
static Sint                             \
tdne_clear_unlikely_##N(ac)             \
Sint ac;                                \
{                                       \
  if (unlikely(EXPR))                   \
    ac = 0;                             \
  return ac;                            \
}

#define TDNE_BOOL(N, EXPR)              \
static Sint                             \
tdne_bool_##N(ac)                       \
Sint ac;                                \
{                                       \
  return (EXPR) != 0;                   \
}

#define TDNE_SELECT(N, EXPR)            \
static Sint                             \
tdne_select_##N(ac, yes, no)            \
Sint ac;                                \
Sint yes;                               \
Sint no;                                \
{                                       \
  if (EXPR)                             \
    return yes;                         \
  return no;                            \
}

TDNE_CLEAR(lit_a, ac & 0123456123456)
TDNE_CLEAR(lit_b, ac & 0525252252525)
TDNE_CLEAR(lit_c, ac & 0707070070707)
TDNE_CLEAR(lit_d, ac & 0400000000777)

TDNE_CLEAR_LIKELY(lit_a, ac & 0123456123456)
TDNE_CLEAR_LIKELY(lit_b, ac & 0525252252525)
TDNE_CLEAR_UNLIKELY(lit_a, ac & 0123456123456)
TDNE_CLEAR_UNLIKELY(lit_b, ac & 0525252252525)

TDNE_BOOL(lit_a, ac & 0123456123456)
TDNE_BOOL(lit_b, ac & 0525252252525)
TDNE_SELECT(lit_a, ac & 0123456123456)
TDNE_SELECT(lit_b, ac & 0525252252525)

static Sint
tdne_mem(ac, x)
Sint ac;
Sint *x;
{
  if (ac & *x)
    ac = 0;
  return ac;
}

static Sint
tdne_mem_likely(ac, x)
Sint ac;
Sint *x;
{
  if (likely(ac & *x))
    ac = 0;
  return ac;
}

static Sint
tdne_mem_unlikely(ac, x)
Sint ac;
Sint *x;
{
  if (unlikely(ac & *x))
    ac = 0;
  return ac;
}

static Sint
tdne_mem_bool(ac, x)
Sint ac;
Sint *x;
{
  return (ac & *x) != 0;
}

static Sint
tdne_mem_select(ac, x, yes, no)
Sint ac;
Sint *x;
Sint yes;
Sint no;
{
  if (ac & *x)
    return yes;
  return no;
}

static Sint
tdne_mem_call(ac, x)
Sint ac;
Sint *x;
{
  if (ac & *x)
    ac = f();
  return ac;
}

static Sint
tdne_mem_call_likely(ac, x)
Sint ac;
Sint *x;
{
  if (likely(ac & *x))
    ac = f();
  return ac;
}

static Sint
tdne_mem_call_unlikely(ac, x)
Sint ac;
Sint *x;
{
  if (unlikely(ac & *x))
    ac = f();
  return ac;
}

static Sint
tdne_global_a(ac)
Sint ac;
{
  if (ac & tdne_ga)
    ac = 0;
  return ac;
}

static Sint
tdne_global_b(ac)
Sint ac;
{
  if (ac & tdne_gb)
    ac = 0;
  return ac;
}

static Sint
tdne_static_mask_a(ac)
Sint ac;
{
  if (ac & tdne_mask_a)
    ac = 0;
  return ac;
}

static Sint
tdne_static_mask_b(ac)
Sint ac;
{
  if (ac & tdne_mask_b)
    ac = 0;
  return ac;
}

static Sint
tdne_global_bool(ac)
Sint ac;
{
  return (ac & tdne_ga) != 0;
}

static Sint
tdne_global_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (ac & tdne_ga)
    return yes;
  return no;
}

static Sint
tdne_global_call(ac)
Sint ac;
{
  if (ac & tdne_ga)
    ac = f();
  return ac;
}

static Sint
tdne_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  if (ac & v[i & 017])
    ac = 0;
  return ac;
}

static Sint
tdne_array_bool(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return (ac & v[i & 017]) != 0;
}

static Sint
tdne_array_call(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  if (ac & v[i & 017])
    ac = f();
  return ac;
}

static Sint
tdne_global_array(ac, i)
Sint ac;
Sint i;
{
  if (ac & tdne_buf[i & 017])
    ac = 0;
  return ac;
}

static Sint
tdne_global_array_bool(ac, i)
Sint ac;
Sint i;
{
  return (ac & tdne_buf[i & 017]) != 0;
}

static Sint
tdne_global_array_call(ac, i)
Sint ac;
Sint i;
{
  if (ac & tdne_buf[i & 017])
    ac = f();
  return ac;
}

static Sint
tdne_struct_a(ac, p)
Sint ac;
struct tdne_pair *p;
{
  if (ac & p->a)
    ac = 0;
  return ac;
}

static Sint
tdne_struct_b(ac, p)
Sint ac;
struct tdne_pair *p;
{
  if (ac & p->b)
    ac = 0;
  return ac;
}

static Sint
tdne_struct_a_bool(ac, p)
Sint ac;
struct tdne_pair *p;
{
  return (ac & p->a) != 0;
}

static Sint
tdne_struct_b_bool(ac, p)
Sint ac;
struct tdne_pair *p;
{
  return (ac & p->b) != 0;
}

static Sint
tdne_global_struct_a(ac)
Sint ac;
{
  if (ac & tdne_gp.a)
    ac = 0;
  return ac;
}

static Sint
tdne_global_struct_b(ac)
Sint ac;
{
  if (ac & tdne_gp.b)
    ac = 0;
  return ac;
}

static Sint
tdne_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  if (ac & **pp)
    ac = 0;
  return ac;
}

static Sint
tdne_volatile(ac, x)
Sint ac;
volatile Sint *x;
{
  if (ac & *x)
    ac = 0;
  return ac;
}

static Sint
tdne_volatile_bool(ac, x)
Sint ac;
volatile Sint *x;
{
  return (ac & *x) != 0;
}

/*
 * Register-computed masks.  These may lower through ordinary AND/CAM
 * today, but keep them as pressure for combine to discover TDNE after
 * simple mask construction.
 */

static Sint
tdne_computed_mask(ac, x)
Sint ac;
Sint x;
{
  x ^= 0123456123456;
  if (ac & x)
    ac = 0;
  return ac;
}

static Sint
tdne_computed_mask_2(ac, x)
Sint ac;
Sint x;
{
  x |= 0525252252525;
  if (ac & x)
    ac = 0;
  return ac;
}

static Sint
tdne_loaded_mask(ac, x)
Sint ac;
Sint *x;
{
  Sint m;

  m = *x;
  if (ac & m)
    ac = 0;
  return ac;
}

static Sint
tdne_loaded_mask_call(ac, x)
Sint ac;
Sint *x;
{
  Sint m;

  m = *x;
  if (ac & m)
    ac = f();
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but useful for making
 * sure signedness does not block recognition.
 */

static uSint
utdne_mem(ac, x)
uSint ac;
uSint *x;
{
  if (ac & *x)
    ac = 0;
  return ac;
}

static uSint
utdne_literal(ac)
uSint ac;
{
  if (ac & 0123456123456)
    ac = 0;
  return ac;
}

static Sint
utdne_bool(ac, x)
uSint ac;
uSint *x;
{
  return (ac & *x) != 0;
}

/*
 * Small promoted values.  These are secondary pressure only; byte and
 * halfword extraction are tested elsewhere, but TDNE should still be
 * reachable after promotion.
 */

static Sint
tdne_qi(ac, x)
Sint ac;
uQint *x;
{
  if (ac & *x)
    ac = 0;
  return ac;
}

static Sint
tdne_hi(ac, x)
Sint ac;
uHint *x;
{
  if (ac & *x)
    ac = 0;
  return ac;
}

static Sint
tdne_qi_bool(ac, x)
Sint ac;
uQint *x;
{
  return (ac & *x) != 0;
}

static Sint
tdne_hi_bool(ac, x)
Sint ac;
uHint *x;
{
  return (ac & *x) != 0;
}
