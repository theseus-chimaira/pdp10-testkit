#include "insns.h"

/*
 * SKIP instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SKIP   AC,E      move/no-skip form, hard to isolate from MOVE
 *   SKIPL  AC,E      skip if E < 0
 *   SKIPE  AC,E      skip if E == 0
 *   SKIPLE AC,E      skip if E <= 0
 *   SKIPA  AC,E      move and always skip
 *   SKIPGE AC,E      skip if E >= 0
 *   SKIPN  AC,E      skip if E != 0
 *   SKIPG  AC,E      skip if E > 0
 *
 * Most C forms below compare a memory operand against zero.  That is
 * the direct cbranchsi/cbranchsf-style route to skip%cond memory forms.
 * Some tests also keep the loaded value, which gives the backend a
 * chance to use the move-and-skip form.
 */

static Sint skip_ga;
static Sint skip_gb;
static Sint skip_buf[16];

struct skip_pair {
  Sint a;
  Sint b;
};

static struct skip_pair skip_gp;

#define TEST_LIKELY(N, OP)                    \
static Sint                                   \
skip_likely_##N(ac, x)                        \
Sint ac;                                      \
Sint *x;                                      \
{                                             \
  if (likely(*x OP 0))                        \
    ac = 0;                                   \
  return ac;                                  \
}

#define TEST_UNLIKELY(N, OP)                  \
static Sint                                   \
skip_unlikely_##N(ac, x)                      \
Sint ac;                                      \
Sint *x;                                      \
{                                             \
  if (unlikely(*x OP 0))                      \
    ac = 0;                                   \
  return ac;                                  \
}

#define TEST_BRANCH(N, OP)                    \
static Sint                                   \
skip_branch_##N(x, a, b)                      \
Sint *x;                                      \
Sint a;                                       \
Sint b;                                       \
{                                             \
  if (*x OP 0)                                \
    return a;                                 \
  return b;                                  \
}

#define TEST_BOOL(N, OP)                      \
static Sint                                   \
skip_bool_##N(x)                              \
Sint *x;                                      \
{                                             \
  return *x OP 0;                             \
}

#define TEST_LOAD_BOOL(N, OP)                 \
static Sint                                   \
skip_load_bool_##N(x)                         \
Sint *x;                                      \
{                                             \
  Sint y;                                     \
                                              \
  y = *x;                                     \
  return y OP 0;                              \
}

#define TEST_MOVE_AND_SKIP(N, OP)             \
static Sint                                   \
skip_move_##N(x, ac)                          \
Sint *x;                                      \
Sint ac;                                      \
{                                             \
  Sint y;                                     \
                                              \
  y = *x;                                     \
  if (y OP 0)                                 \
    ac = y;                                   \
  return ac;                                  \
}

#define TEST_MOVE_AND_CLEAR(N, OP)            \
static Sint                                   \
skip_move_clear_##N(x, ac)                    \
Sint *x;                                      \
Sint ac;                                      \
{                                             \
  Sint y;                                     \
                                              \
  y = *x;                                     \
  if (y OP 0)                                 \
    ac = 0;                                   \
  return ac + y;                              \
}

TEST_LIKELY(l, <)
TEST_LIKELY(e, ==)
TEST_LIKELY(le, <=)
TEST_LIKELY(ge, >=)
TEST_LIKELY(n, !=)
TEST_LIKELY(g, >)

TEST_UNLIKELY(l, <)
TEST_UNLIKELY(e, ==)
TEST_UNLIKELY(le, <=)
TEST_UNLIKELY(ge, >=)
TEST_UNLIKELY(n, !=)
TEST_UNLIKELY(g, >)

TEST_BRANCH(l, <)
TEST_BRANCH(e, ==)
TEST_BRANCH(le, <=)
TEST_BRANCH(ge, >=)
TEST_BRANCH(n, !=)
TEST_BRANCH(g, >)

TEST_BOOL(l, <)
TEST_BOOL(e, ==)
TEST_BOOL(le, <=)
TEST_BOOL(ge, >=)
TEST_BOOL(n, !=)
TEST_BOOL(g, >)

TEST_LOAD_BOOL(l, <)
TEST_LOAD_BOOL(e, ==)
TEST_LOAD_BOOL(le, <=)
TEST_LOAD_BOOL(ge, >=)
TEST_LOAD_BOOL(n, !=)
TEST_LOAD_BOOL(g, >)

TEST_MOVE_AND_SKIP(l, <)
TEST_MOVE_AND_SKIP(e, ==)
TEST_MOVE_AND_SKIP(le, <=)
TEST_MOVE_AND_SKIP(ge, >=)
TEST_MOVE_AND_SKIP(n, !=)
TEST_MOVE_AND_SKIP(g, >)

TEST_MOVE_AND_CLEAR(l, <)
TEST_MOVE_AND_CLEAR(e, ==)
TEST_MOVE_AND_CLEAR(le, <=)
TEST_MOVE_AND_CLEAR(ge, >=)
TEST_MOVE_AND_CLEAR(n, !=)
TEST_MOVE_AND_CLEAR(g, >)

static Sint
skip_orig_l(ac, x)
Sint ac;
Sint *x;
{
  if (likely(*x >= 0))
    ac = 0;
  return ac;
}

static Sint
skip_orig_e(ac, x)
Sint ac;
Sint *x;
{
  if (likely(*x != 0))
    ac = 0;
  return ac;
}

static Sint
skip_orig_le(ac, x)
Sint ac;
Sint *x;
{
  if (likely(*x > 0))
    ac = 0;
  return ac;
}

static Sint
skip_orig_ge(ac, x)
Sint ac;
Sint *x;
{
  if (likely(*x < 0))
    ac = 0;
  return ac;
}

static Sint
skip_orig_n(ac, x)
Sint ac;
Sint *x;
{
  if (likely(*x == 0))
    ac = 0;
  return ac;
}

static Sint
skip_orig_g(ac, x)
Sint ac;
Sint *x;
{
  if (likely(*x <= 0))
    ac = 0;
  return ac;
}

static Sint
skip_global_l(ac)
Sint ac;
{
  if (skip_ga < 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_e(ac)
Sint ac;
{
  if (skip_ga == 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_le(ac)
Sint ac;
{
  if (skip_ga <= 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_ge(ac)
Sint ac;
{
  if (skip_ga >= 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_n(ac)
Sint ac;
{
  if (skip_ga != 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_g(ac)
Sint ac;
{
  if (skip_ga > 0)
    ac = 0;
  return ac;
}

static Sint
skip_array_l(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  if (v[i & 017] < 0)
    ac = 0;
  return ac;
}

static Sint
skip_array_e(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  if (v[i & 017] == 0)
    ac = 0;
  return ac;
}

static Sint
skip_array_le(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  if (v[i & 017] <= 0)
    ac = 0;
  return ac;
}

static Sint
skip_array_ge(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  if (v[i & 017] >= 0)
    ac = 0;
  return ac;
}

static Sint
skip_array_n(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  if (v[i & 017] != 0)
    ac = 0;
  return ac;
}

static Sint
skip_array_g(v, i, ac)
Sint *v;
Sint i;
Sint ac;
{
  if (v[i & 017] > 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_array_l(i, ac)
Sint i;
Sint ac;
{
  if (skip_buf[i & 017] < 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_array_e(i, ac)
Sint i;
Sint ac;
{
  if (skip_buf[i & 017] == 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_array_le(i, ac)
Sint i;
Sint ac;
{
  if (skip_buf[i & 017] <= 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_array_ge(i, ac)
Sint i;
Sint ac;
{
  if (skip_buf[i & 017] >= 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_array_n(i, ac)
Sint i;
Sint ac;
{
  if (skip_buf[i & 017] != 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_array_g(i, ac)
Sint i;
Sint ac;
{
  if (skip_buf[i & 017] > 0)
    ac = 0;
  return ac;
}

static Sint
skip_struct_a_l(p, ac)
struct skip_pair *p;
Sint ac;
{
  if (p->a < 0)
    ac = 0;
  return ac;
}

static Sint
skip_struct_a_e(p, ac)
struct skip_pair *p;
Sint ac;
{
  if (p->a == 0)
    ac = 0;
  return ac;
}

static Sint
skip_struct_a_n(p, ac)
struct skip_pair *p;
Sint ac;
{
  if (p->a != 0)
    ac = 0;
  return ac;
}

static Sint
skip_struct_a_g(p, ac)
struct skip_pair *p;
Sint ac;
{
  if (p->a > 0)
    ac = 0;
  return ac;
}

static Sint
skip_struct_b_le(p, ac)
struct skip_pair *p;
Sint ac;
{
  if (p->b <= 0)
    ac = 0;
  return ac;
}

static Sint
skip_struct_b_ge(p, ac)
struct skip_pair *p;
Sint ac;
{
  if (p->b >= 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_struct_a(ac)
Sint ac;
{
  if (skip_gp.a == 0)
    ac = 0;
  return ac;
}

static Sint
skip_global_struct_b(ac)
Sint ac;
{
  if (skip_gp.b != 0)
    ac = 0;
  return ac;
}

static Sint
skip_volatile_l(x, ac)
volatile Sint *x;
Sint ac;
{
  if (*x < 0)
    ac = 0;
  return ac;
}

static Sint
skip_volatile_e(x, ac)
volatile Sint *x;
Sint ac;
{
  if (*x == 0)
    ac = 0;
  return ac;
}

static Sint
skip_volatile_n(x, ac)
volatile Sint *x;
Sint ac;
{
  if (*x != 0)
    ac = 0;
  return ac;
}

static Sint
skip_volatile_g(x, ac)
volatile Sint *x;
Sint ac;
{
  if (*x > 0)
    ac = 0;
  return ac;
}

/*
 * Unsigned memory comparisons against zero can only naturally exercise
 * equality/non-equality skip forms.  Ordered unsigned zero comparisons
 * collapse too aggressively in C, so do not force them here.
 */

static Sint
skip_unsigned_e(x, ac)
uSint *x;
Sint ac;
{
  if (*x == 0)
    ac = 0;
  return ac;
}

static Sint
skip_unsigned_n(x, ac)
uSint *x;
Sint ac;
{
  if (*x != 0)
    ac = 0;
  return ac;
}

static Sint
skip_unsigned_bool_e(x)
uSint *x;
{
  return *x == 0;
}

static Sint
skip_unsigned_bool_n(x)
uSint *x;
{
  return *x != 0;
}

/*
 * Small scalar loads.  These are partly scalar-extension pressure and
 * partly SKIP pressure after promotion.
 */

static Sint
skip_qi_e(x, ac)
sQint *x;
Sint ac;
{
  if (*x == 0)
    ac = 0;
  return ac;
}

static Sint
skip_qi_l(x, ac)
sQint *x;
Sint ac;
{
  if (*x < 0)
    ac = 0;
  return ac;
}

static Sint
skip_qi_g(x, ac)
sQint *x;
Sint ac;
{
  if (*x > 0)
    ac = 0;
  return ac;
}

static Sint
skip_uqi_e(x, ac)
uQint *x;
Sint ac;
{
  if (*x == 0)
    ac = 0;
  return ac;
}

static Sint
skip_uqi_n(x, ac)
uQint *x;
Sint ac;
{
  if (*x != 0)
    ac = 0;
  return ac;
}

static Sint
skip_hi_e(x, ac)
Hint *x;
Sint ac;
{
  if (*x == 0)
    ac = 0;
  return ac;
}

static Sint
skip_hi_l(x, ac)
Hint *x;
Sint ac;
{
  if (*x < 0)
    ac = 0;
  return ac;
}

static Sint
skip_hi_g(x, ac)
Hint *x;
Sint ac;
{
  if (*x > 0)
    ac = 0;
  return ac;
}

static Sint
skip_uhi_e(x, ac)
uHint *x;
Sint ac;
{
  if (*x == 0)
    ac = 0;
  return ac;
}

static Sint
skip_uhi_n(x, ac)
uHint *x;
Sint ac;
{
  if (*x != 0)
    ac = 0;
  return ac;
}

/*
 * SKIPA pressure.  These are not guaranteed to produce SKIPA today, but
 * they express the classic "conditional skip over an alternate move"
 * shape that the backend can improve later.
 */

static Sint
skipa_select_mem(cond, x, y)
Sint cond;
Sint *x;
Sint y;
{
  if (cond)
    return *x;
  return y;
}

static Sint
skipa_select_global(cond, y)
Sint cond;
Sint y;
{
  if (cond)
    return skip_ga;
  return y;
}

static Sint
skipa_select_array(cond, v, i, y)
Sint cond;
Sint *v;
Sint i;
Sint y;
{
  if (cond)
    return v[i & 017];
  return y;
}

static Sint
skipa_select_struct(cond, p, y)
Sint cond;
struct skip_pair *p;
Sint y;
{
  if (cond)
    return p->a;
  return y;
}

static Sint
skipa_after_compare(x, y)
Sint *x;
Sint y;
{
  if (*x == 0)
    return *x;
  return y;
}

static Sint
skipa_after_compare_n(x, y)
Sint *x;
Sint y;
{
  if (*x != 0)
    return *x;
  return y;
}
