#include "insns.h"

/*
 * Pattern test: comparisons used as integer values.
 *
 * This is not an individual instruction-family test.  It checks whether
 * ordinary C relational expressions produce sane 0/1 values.
 *
 * Expected backend pressure:
 *   - compare register with zero
 *   - compare register with register
 *   - compare register with memory
 *   - signed and unsigned comparisons
 *   - result used as value, not only as branch
 *
 * Floating point is deliberately excluded from this first PDP-6/KA10
 * pass.  Add FP comparisons later when FP tests leave the attic.
 */

#define SKIP(N, OP, T) \
  static Sint skip##N##T(T ac) { return ac OP 0; }

#define SKIPK(N, OP, T, KNAME, K) \
  static Sint skip##N##T##KNAME(T ac) { return ac OP K; }

#define CAM(N, OP, T) \
  static Sint cam##N##T##1(T ac1, T ac2) { return ac1 OP ac2; } \
  static Sint cam##N##T##2(T ac1, T *ac2) { return ac1 OP *ac2; } \
  static Sint cam##N##T##3(T *ac1, T ac2) { return *ac1 OP ac2; } \
  static Sint cam##N##T##4(T *ac1, T *ac2) { return *ac1 OP *ac2; }

#define SCC_SIGNED(N, OP) \
  SKIP(N, OP, Sint) \
  SKIPK(N, OP, Sint, m1, -1) \
  SKIPK(N, OP, Sint, p1, 1) \
  CAM(N, OP, Sint)

#define SCC_UNSIGNED(N, OP) \
  SKIP(N, OP, uSint) \
  SKIPK(N, OP, uSint, p1, 1) \
  CAM(N, OP, uSint)

SCC_SIGNED(e, ==)
SCC_SIGNED(n, !=)
SCC_SIGNED(l, <)
SCC_SIGNED(g, >)
SCC_SIGNED(le, <=)
SCC_SIGNED(ge, >=)

SCC_UNSIGNED(ue, ==)
SCC_UNSIGNED(un, !=)
SCC_UNSIGNED(ul, <)
SCC_UNSIGNED(ug, >)
SCC_UNSIGNED(ule, <=)
SCC_UNSIGNED(uge, >=)

/*
 * Result value consumed by arithmetic/logical expressions.
 */

static Sint
scc_add_eq(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a == b) + c;
}

static Sint
scc_add_ne(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a != b) + c;
}

static Sint
scc_add_lt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a < b) + c;
}

static Sint
scc_add_gt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a > b) + c;
}

static Sint
scc_add_le(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a <= b) + c;
}

static Sint
scc_add_ge(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a >= b) + c;
}

static Sint
scc_and_eq(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a == b) & c;
}

static Sint
scc_or_ne(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a != b) | c;
}

static Sint
scc_xor_lt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a < b) ^ c;
}

static Sint
scc_mul_gt(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a > b) * c;
}

/*
 * Boolean results stored through locals before use.
 */

static Sint
scc_local_eq(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a == b;
  return r;
}

static Sint
scc_local_ne(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a != b;
  return r;
}

static Sint
scc_local_lt(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a < b;
  return r;
}

static Sint
scc_local_gt(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a > b;
  return r;
}

static Sint
scc_local_le(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a <= b;
  return r;
}

static Sint
scc_local_ge(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a >= b;
  return r;
}

/*
 * Unsigned value consumers.
 */

static Sint
scc_uadd_lt(a, b, c)
uSint a;
uSint b;
Sint c;
{
  return (a < b) + c;
}

static Sint
scc_uadd_gt(a, b, c)
uSint a;
uSint b;
Sint c;
{
  return (a > b) + c;
}

static Sint
scc_uadd_le(a, b, c)
uSint a;
uSint b;
Sint c;
{
  return (a <= b) + c;
}

static Sint
scc_uadd_ge(a, b, c)
uSint a;
uSint b;
Sint c;
{
  return (a >= b) + c;
}

/*
 * Promoted small integer comparisons.
 */

static Sint
scc_qi_eq(a, b)
sQint a;
sQint b;
{
  return a == b;
}

static Sint
scc_qi_ne(a, b)
sQint a;
sQint b;
{
  return a != b;
}

static Sint
scc_qi_lt(a, b)
sQint a;
sQint b;
{
  return a < b;
}

static Sint
scc_qi_ge(a, b)
sQint a;
sQint b;
{
  return a >= b;
}

static Sint
scc_uqi_lt(a, b)
uQint a;
uQint b;
{
  return a < b;
}

static Sint
scc_uqi_ge(a, b)
uQint a;
uQint b;
{
  return a >= b;
}

static Sint
scc_hi_eq(a, b)
Hint a;
Hint b;
{
  return a == b;
}

static Sint
scc_hi_ne(a, b)
Hint a;
Hint b;
{
  return a != b;
}

static Sint
scc_hi_lt(a, b)
Hint a;
Hint b;
{
  return a < b;
}

static Sint
scc_hi_ge(a, b)
Hint a;
Hint b;
{
  return a >= b;
}

static Sint
scc_uhi_lt(a, b)
uHint a;
uHint b;
{
  return a < b;
}

static Sint
scc_uhi_ge(a, b)
uHint a;
uHint b;
{
  return a >= b;
}

/*
 * Pointer comparisons.  Equality is important; ordering is included as
 * ordinary C pointer comparison pressure but should be reviewed more
 * conservatively than integer comparisons.
 */

static Sint
scc_ptr_eq(a, b)
Sint *a;
Sint *b;
{
  return a == b;
}

static Sint
scc_ptr_ne(a, b)
Sint *a;
Sint *b;
{
  return a != b;
}

static Sint
scc_ptr_null_eq(a)
Sint *a;
{
  return a == 0;
}

static Sint
scc_ptr_null_ne(a)
Sint *a;
{
  return a != 0;
}

static Sint
scc_ptr_lt(a, b)
Sint *a;
Sint *b;
{
  return a < b;
}

static Sint
scc_ptr_ge(a, b)
Sint *a;
Sint *b;
{
  return a >= b;
}

/*
 * Avoid optimizing everything into pure branches: use multiple SCC
 * values in one expression.
 */

static Sint
scc_two_values(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a < b) + (b < c);
}

static Sint
scc_three_values(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return (a == b) + (b != c) + (a < c);
}

static Sint
scc_mixed_signed_unsigned(a, b, ua, ub)
Sint a;
Sint b;
uSint ua;
uSint ub;
{
  return (a < b) + (ua < ub);
}
