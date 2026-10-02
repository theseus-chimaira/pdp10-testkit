#include "insns.h"

/*
 * TLNE instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TLNE AC,imm18    test AC & (imm18 << 18), no modification,
 *                    skip when the tested left-half bits are nonzero
 *
 * Keep masks strictly in the left half with a zero right half.
 * Full-word tests belong to TDNE.c; right-half immediate tests belong
 * to TRNE.c.
 */

extern Sint f(void);

static Sint tlne_ga;
static uSint tlne_uga;

#define TLNE_CLEAR(N, MASK)             \
static Sint                             \
tlne_clear_##N(ac)                      \
Sint ac;                                \
{                                       \
  if (ac & (MASK))                      \
    ac = 0;                             \
  return ac;                            \
}

#define TLNE_CLEAR_LIKELY(N, MASK)      \
static Sint                             \
tlne_clear_likely_##N(ac)               \
Sint ac;                                \
{                                       \
  if (likely(ac & (MASK)))              \
    ac = 0;                             \
  return ac;                            \
}

#define TLNE_CLEAR_UNLIKELY(N, MASK)    \
static Sint                             \
tlne_clear_unlikely_##N(ac)             \
Sint ac;                                \
{                                       \
  if (unlikely(ac & (MASK)))            \
    ac = 0;                             \
  return ac;                            \
}

#define TLNE_BOOL(N, MASK)              \
static Sint                             \
tlne_bool_##N(ac)                       \
Sint ac;                                \
{                                       \
  return (ac & (MASK)) != 0;            \
}

#define TLNE_SELECT(N, MASK)            \
static Sint                             \
tlne_select_##N(ac, yes, no)            \
Sint ac;                                \
Sint yes;                               \
Sint no;                                \
{                                       \
  if (ac & (MASK))                      \
    return yes;                         \
  return no;                            \
}

#define TLNE_CALL(N, MASK)              \
static Sint                             \
tlne_call_##N(ac)                       \
Sint ac;                                \
{                                       \
  if (ac & (MASK))                      \
    ac = f();                           \
  return ac;                            \
}

TLNE_CLEAR(small, 0123456000000)
TLNE_CLEAR(one, 0000001000000)
TLNE_CLEAR(highbit, 0400000000000)
TLNE_CLEAR(all, 0777777000000)
TLNE_CLEAR(alt1, 0525252000000)
TLNE_CLEAR(alt2, 0252525000000)
TLNE_CLEAR(sparse, 0707070000000)
TLNE_CLEAR(sign_low, 0400001000000)
TLNE_CLEAR(maxpos, 0377777000000)

TLNE_CLEAR_LIKELY(small, 0123456000000)
TLNE_CLEAR_LIKELY(all, 0777777000000)
TLNE_CLEAR_LIKELY(highbit, 0400000000000)

TLNE_CLEAR_UNLIKELY(small, 0123456000000)
TLNE_CLEAR_UNLIKELY(all, 0777777000000)
TLNE_CLEAR_UNLIKELY(highbit, 0400000000000)

TLNE_BOOL(small, 0123456000000)
TLNE_BOOL(one, 0000001000000)
TLNE_BOOL(highbit, 0400000000000)
TLNE_BOOL(all, 0777777000000)
TLNE_BOOL(alt1, 0525252000000)

TLNE_SELECT(small, 0123456000000)
TLNE_SELECT(highbit, 0400000000000)
TLNE_SELECT(all, 0777777000000)

TLNE_CALL(small, 0123456000000)
TLNE_CALL(highbit, 0400000000000)
TLNE_CALL(all, 0777777000000)

static Sint
tlne_explicit_ne(ac)
Sint ac;
{
  if ((ac & 0123456000000) != 0)
    ac = 0;
  return ac;
}

static Sint
tlne_explicit_ne_highbit(ac)
Sint ac;
{
  if ((ac & 0400000000000) != 0)
    ac = 0;
  return ac;
}

static Sint
tlne_explicit_ne_all(ac)
Sint ac;
{
  if ((ac & 0777777000000) != 0)
    ac = 0;
  return ac;
}

static Sint
tlne_branch_return(ac, a, b)
Sint ac;
Sint a;
Sint b;
{
  if (ac & 0123456000000)
    return a;
  return b;
}

static Sint
tlne_branch_return_highbit(ac, a, b)
Sint ac;
Sint a;
Sint b;
{
  if (ac & 0400000000000)
    return a;
  return b;
}

static Sint
tlne_branch_return_all(ac, a, b)
Sint ac;
Sint a;
Sint b;
{
  if (ac & 0777777000000)
    return a;
  return b;
}

static Sint
tlne_store_global(ac)
Sint ac;
{
  if (ac & 0123456000000)
    tlne_ga = ac;
  return ac;
}

static Sint
tlne_store_global_zero(ac)
Sint ac;
{
  if (ac & 0123456000000)
    tlne_ga = 0;
  return ac;
}

static Sint
tlne_store_global_highbit(ac)
Sint ac;
{
  if (ac & 0400000000000)
    tlne_ga = ac;
  return ac;
}

static Sint
tlne_use_global(ac)
Sint ac;
{
  if (ac & 0123456000000)
    ac = tlne_ga;
  return ac;
}

static Sint
tlne_use_global_highbit(ac)
Sint ac;
{
  if (ac & 0400000000000)
    ac = tlne_ga;
  return ac;
}

static Sint
tlne_mix_add(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456000000)
    ac += y;
  return ac;
}

static Sint
tlne_mix_xor(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456000000)
    ac ^= y;
  return ac;
}

static Sint
tlne_mix_or(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456000000)
    ac |= y;
  return ac;
}

static Sint
tlne_mix_and(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456000000)
    ac &= y;
  return ac;
}

static Sint
tlne_nested(ac, x)
Sint ac;
Sint x;
{
  if (ac & 0123456000000) {
    if (x & 1)
      ac = 0;
    else
      ac = x;
  }
  return ac;
}

static Sint
tlne_two_tests(ac)
Sint ac;
{
  if (ac & 0123456000000)
    ac = 0;
  if (ac & 0525252000000)
    ac = 1;
  return ac;
}

static Sint
tlne_chain(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456000000)
    ac = y;
  if (ac & 0400000000000)
    ac = 0;
  return ac;
}

static Sint
tlne_from_mem_value(p)
Sint *p;
{
  Sint ac;

  ac = *p;
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}

static Sint
tlne_from_global_value(void)
{
  Sint ac;

  ac = tlne_ga;
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}

static Sint
tlne_from_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a + b;
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}

static Sint
tlne_from_xor_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a ^ b;
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}

static uSint
utlne_clear_small(ac)
uSint ac;
{
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}

static uSint
utlne_clear_highbit(ac)
uSint ac;
{
  if (ac & 0400000000000)
    ac = 0;
  return ac;
}

static uSint
utlne_clear_all(ac)
uSint ac;
{
  if (ac & 0777777000000)
    ac = 0;
  return ac;
}

static Sint
utlne_bool_small(ac)
uSint ac;
{
  return (ac & 0123456000000) != 0;
}

static void
utlne_store_global(ac)
uSint ac;
{
  if (ac & 0123456000000)
    tlne_uga = ac;
}

/*
 * Promoted small-type values.  These mostly verify that promotion does
 * not accidentally block left-half test recognition when the promoted
 * value is combined with a left-half mask.
 */

static Sint
tlne_qi_promote(a)
uQint a;
{
  Sint ac;

  ac = ((Sint)a) << 18;
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}

static Sint
tlne_hi_promote(a)
uHint a;
{
  Sint ac;

  ac = ((Sint)a) << 18;
  if (ac & 0123456000000)
    ac = 0;
  return ac;
}
