#include "insns.h"

/*
 * TRNE instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TRNE AC,imm18    test AC & imm18, no modification,
 *                    skip when the tested right-half bits are nonzero
 *
 * Keep masks strictly in the right half:
 *   000000,,xxxxxx
 *
 * Full-word tests belong to TDNE.c; left-half immediate tests belong
 * to TLNE.c.
 */

extern Sint f(void);

static Sint trne_ga;
static uSint trne_uga;

#define TRNE_CLEAR(N, MASK)             \
static Sint                             \
trne_clear_##N(ac)                      \
Sint ac;                                \
{                                       \
  if (ac & (MASK))                      \
    ac = 0;                             \
  return ac;                            \
}

#define TRNE_CLEAR_LIKELY(N, MASK)      \
static Sint                             \
trne_clear_likely_##N(ac)               \
Sint ac;                                \
{                                       \
  if (likely(ac & (MASK)))              \
    ac = 0;                             \
  return ac;                            \
}

#define TRNE_CLEAR_UNLIKELY(N, MASK)    \
static Sint                             \
trne_clear_unlikely_##N(ac)             \
Sint ac;                                \
{                                       \
  if (unlikely(ac & (MASK)))            \
    ac = 0;                             \
  return ac;                            \
}

#define TRNE_BOOL(N, MASK)              \
static Sint                             \
trne_bool_##N(ac)                       \
Sint ac;                                \
{                                       \
  return (ac & (MASK)) != 0;            \
}

#define TRNE_SELECT(N, MASK)            \
static Sint                             \
trne_select_##N(ac, yes, no)            \
Sint ac;                                \
Sint yes;                               \
Sint no;                                \
{                                       \
  if (ac & (MASK))                      \
    return yes;                         \
  return no;                            \
}

#define TRNE_CALL(N, MASK)              \
static Sint                             \
trne_call_##N(ac)                       \
Sint ac;                                \
{                                       \
  if (ac & (MASK))                      \
    ac = f();                           \
  return ac;                            \
}

TRNE_CLEAR(small, 0123456)
TRNE_CLEAR(one, 0000001)
TRNE_CLEAR(lowbit, 0000001)
TRNE_CLEAR(highbit, 0400000)
TRNE_CLEAR(all, 0777777)
TRNE_CLEAR(alt1, 0525252)
TRNE_CLEAR(alt2, 0252525)
TRNE_CLEAR(sparse, 0707070)
TRNE_CLEAR(sign_low, 0400001)
TRNE_CLEAR(maxpos, 0377777)

TRNE_CLEAR_LIKELY(small, 0123456)
TRNE_CLEAR_LIKELY(all, 0777777)
TRNE_CLEAR_LIKELY(highbit, 0400000)

TRNE_CLEAR_UNLIKELY(small, 0123456)
TRNE_CLEAR_UNLIKELY(all, 0777777)
TRNE_CLEAR_UNLIKELY(highbit, 0400000)

TRNE_BOOL(small, 0123456)
TRNE_BOOL(one, 0000001)
TRNE_BOOL(highbit, 0400000)
TRNE_BOOL(all, 0777777)
TRNE_BOOL(alt1, 0525252)

TRNE_SELECT(small, 0123456)
TRNE_SELECT(highbit, 0400000)
TRNE_SELECT(all, 0777777)

TRNE_CALL(small, 0123456)
TRNE_CALL(highbit, 0400000)
TRNE_CALL(all, 0777777)

static Sint
trne_explicit_ne(ac)
Sint ac;
{
  if ((ac & 0123456) != 0)
    ac = 0;
  return ac;
}

static Sint
trne_explicit_ne_highbit(ac)
Sint ac;
{
  if ((ac & 0400000) != 0)
    ac = 0;
  return ac;
}

static Sint
trne_explicit_ne_all(ac)
Sint ac;
{
  if ((ac & 0777777) != 0)
    ac = 0;
  return ac;
}

static Sint
trne_branch_return(ac, a, b)
Sint ac;
Sint a;
Sint b;
{
  if (ac & 0123456)
    return a;
  return b;
}

static Sint
trne_branch_return_highbit(ac, a, b)
Sint ac;
Sint a;
Sint b;
{
  if (ac & 0400000)
    return a;
  return b;
}

static Sint
trne_branch_return_all(ac, a, b)
Sint ac;
Sint a;
Sint b;
{
  if (ac & 0777777)
    return a;
  return b;
}

static Sint
trne_store_global(ac)
Sint ac;
{
  if (ac & 0123456)
    trne_ga = ac;
  return ac;
}

static Sint
trne_store_global_zero(ac)
Sint ac;
{
  if (ac & 0123456)
    trne_ga = 0;
  return ac;
}

static Sint
trne_store_global_highbit(ac)
Sint ac;
{
  if (ac & 0400000)
    trne_ga = ac;
  return ac;
}

static Sint
trne_use_global(ac)
Sint ac;
{
  if (ac & 0123456)
    ac = trne_ga;
  return ac;
}

static Sint
trne_use_global_highbit(ac)
Sint ac;
{
  if (ac & 0400000)
    ac = trne_ga;
  return ac;
}

static Sint
trne_mix_add(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456)
    ac += y;
  return ac;
}

static Sint
trne_mix_xor(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456)
    ac ^= y;
  return ac;
}

static Sint
trne_mix_or(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456)
    ac |= y;
  return ac;
}

static Sint
trne_mix_and(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456)
    ac &= y;
  return ac;
}

static Sint
trne_nested(ac, x)
Sint ac;
Sint x;
{
  if (ac & 0123456) {
    if (x & 1)
      ac = 0;
    else
      ac = x;
  }
  return ac;
}

static Sint
trne_two_tests(ac)
Sint ac;
{
  if (ac & 0123456)
    ac = 0;
  if (ac & 0525252)
    ac = 1;
  return ac;
}

static Sint
trne_chain(ac, y)
Sint ac;
Sint y;
{
  if (ac & 0123456)
    ac = y;
  if (ac & 0400000)
    ac = 0;
  return ac;
}

static Sint
trne_from_mem_value(p)
Sint *p;
{
  Sint ac;

  ac = *p;
  if (ac & 0123456)
    ac = 0;
  return ac;
}

static Sint
trne_from_global_value(void)
{
  Sint ac;

  ac = trne_ga;
  if (ac & 0123456)
    ac = 0;
  return ac;
}

static Sint
trne_from_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a + b;
  if (ac & 0123456)
    ac = 0;
  return ac;
}

static Sint
trne_from_xor_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a ^ b;
  if (ac & 0123456)
    ac = 0;
  return ac;
}

static uSint
utrne_clear_small(ac)
uSint ac;
{
  if (ac & 0123456)
    ac = 0;
  return ac;
}

static uSint
utrne_clear_highbit(ac)
uSint ac;
{
  if (ac & 0400000)
    ac = 0;
  return ac;
}

static uSint
utrne_clear_all(ac)
uSint ac;
{
  if (ac & 0777777)
    ac = 0;
  return ac;
}

static Sint
utrne_bool_small(ac)
uSint ac;
{
  return (ac & 0123456) != 0;
}

static void
utrne_store_global(ac)
uSint ac;
{
  if (ac & 0123456)
    trne_uga = ac;
}

/*
 * Promoted small-type values.  These mostly verify that promotion does
 * not accidentally block right-half test recognition.
 */

static Sint
trne_qi_promote(a)
uQint a;
{
  Sint ac;

  ac = (Sint)a;
  if (ac & 0777)
    ac = 0;
  return ac;
}

static Sint
trne_hi_promote(a)
uHint a;
{
  Sint ac;

  ac = (Sint)a;
  if (ac & 0777777)
    ac = 0;
  return ac;
}
