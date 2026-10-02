#include "insns.h"

/*
 * CAM instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   CAML   compare AC with memory/literal, skip if less
 *   CAME   skip if equal
 *   CAMLE  skip if less-or-equal
 *   CAMGE  skip if greater-or-equal
 *   CAMN   skip if not-equal
 *   CAMG   skip if greater
 *
 * CAI covers small immediates.  CAM is the important path for memory
 * operands and large constants/literals.
 */

struct cam_struct {
  Sint a;
  Sint b;
  Sint c;
} *p;

extern Sint f(void);
extern void clobber(void);

#define CAM_BRANCH(NAME, OP)                    \
static Sint                                     \
cam_mem_##NAME(a, p)                            \
Sint a;                                         \
Sint *p;                                        \
{                                               \
  if (a OP *p)                                  \
    a = 0;                                      \
  return a;                                     \
}

#define CAM_BRANCH_REV(NAME, OP)                \
static Sint                                     \
cam_mem_rev_##NAME(a, p)                        \
Sint a;                                         \
Sint *p;                                        \
{                                               \
  if (*p OP a)                                  \
    a = 0;                                      \
  return a;                                     \
}

#define CAM_BRANCH_INV(NAME, OP)                \
static Sint                                     \
cam_mem_##NAME##_inv(a, p)                      \
Sint a;                                         \
Sint *p;                                        \
{                                               \
  if (!(a OP *p))                               \
    a = 0;                                      \
  return a;                                     \
}

#define CAM_LITERAL(NAME, OP, K)                \
static Sint                                     \
cam_lit_##NAME(a)                               \
Sint a;                                         \
{                                               \
  if (a OP K)                                   \
    a = 0;                                      \
  return a;                                     \
}

#define CAM_LITERAL_INV(NAME, OP, K)            \
static Sint                                     \
cam_lit_##NAME##_inv(a)                         \
Sint a;                                         \
{                                               \
  if (!(a OP K))                                \
    a = 0;                                      \
  return a;                                     \
}

#define CAM_VALUE(NAME, OP)                     \
static Sint                                     \
cam_value_##NAME(a, p)                          \
Sint a;                                         \
Sint *p;                                        \
{                                               \
  Sint r;                                       \
                                                \
  r = 0;                                        \
  if (a OP *p)                                  \
    r = 1;                                      \
  return r;                                     \
}

#define CAM_CALL(NAME, OP)                      \
static Sint                                     \
cam_call_##NAME(a, p)                           \
Sint a;                                         \
Sint *p;                                        \
{                                               \
  if (a OP *p)                                  \
    a += f();                                   \
  return a;                                     \
}

#define CAM_LOOP(NAME, OP)                      \
static Sint                                     \
cam_loop_##NAME(a, p, x)                        \
Sint a;                                         \
Sint *p;                                        \
Sint x;                                         \
{                                               \
  while (a OP *p) {                             \
    x += a;                                     \
    ++a;                                        \
  }                                             \
  return x + a;                                 \
}

#define CAM_TEST(NAME, OP)                      \
  CAM_BRANCH(NAME, OP)                          \
  CAM_BRANCH_REV(NAME, OP)                      \
  CAM_BRANCH_INV(NAME, OP)                      \
  CAM_VALUE(NAME, OP)                           \
  CAM_CALL(NAME, OP)                            \
  CAM_LOOP(NAME, OP)

CAM_TEST(lt, <)
CAM_TEST(eq, ==)
CAM_TEST(le, <=)
CAM_TEST(ge, >=)
CAM_TEST(ne, !=)
CAM_TEST(gt, >)

CAM_LITERAL(lt_big, <, 0123456123456)
CAM_LITERAL(eq_big, ==, 0123456123456)
CAM_LITERAL(le_big, <=, 0123456123456)
CAM_LITERAL(ge_big, >=, 0123456123456)
CAM_LITERAL(ne_big, !=, 0123456123456)
CAM_LITERAL(gt_big, >, 0123456123456)

CAM_LITERAL_INV(lt_big, <, 0123456123456)
CAM_LITERAL_INV(eq_big, ==, 0123456123456)
CAM_LITERAL_INV(le_big, <=, 0123456123456)
CAM_LITERAL_INV(ge_big, >=, 0123456123456)
CAM_LITERAL_INV(ne_big, !=, 0123456123456)
CAM_LITERAL_INV(gt_big, >, 0123456123456)

CAM_LITERAL(lt_sign, <, 0400000000000)
CAM_LITERAL(eq_sign, ==, 0400000000000)
CAM_LITERAL(le_sign, <=, 0400000000000)
CAM_LITERAL(ge_sign, >=, 0400000000000)
CAM_LITERAL(ne_sign, !=, 0400000000000)
CAM_LITERAL(gt_sign, >, 0400000000000)

CAM_LITERAL(lt_maxpos, <, 0377777777777)
CAM_LITERAL(eq_maxpos, ==, 0377777777777)
CAM_LITERAL(le_maxpos, <=, 0377777777777)
CAM_LITERAL(ge_maxpos, >=, 0377777777777)
CAM_LITERAL(ne_maxpos, !=, 0377777777777)
CAM_LITERAL(gt_maxpos, >, 0377777777777)

static Sint
cam_chain(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  if (a < *p)
    return 01;
  if (a == *q)
    return 02;
  if (a <= 0123456123456)
    return 03;
  if (a >= *p)
    return 04;
  if (a != 0377777777777)
    return 05;
  if (a > *q)
    return 06;

  return a;
}

static Sint
cam_chain_inverted(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  if (!(a < *p))
    a += 01;
  if (!(a == *q))
    a += 02;
  if (!(a <= 0123456123456))
    a += 03;
  if (!(a >= *p))
    a += 04;
  if (!(a != 0377777777777))
    a += 05;
  if (!(a > *q))
    a += 06;

  return a;
}

static Sint
cam_mem_mem(p, q)
Sint *p;
Sint *q;
{
  Sint a;

  a = *p;
  if (a < *q)
    a = 0;
  return a;
}

static Sint
cam_mem_mem_rev(p, q)
Sint *p;
Sint *q;
{
  Sint a;

  a = *p;
  if (*q > a)
    a = 0;
  return a;
}

static Sint
cam_volatile_mem(a, p)
Sint a;
volatile Sint *p;
{
  if (a == *p)
    a = 0;
  return a;
}

static Sint
cam_volatile_mem_ne(a, p)
Sint a;
volatile Sint *p;
{
  if (a != *p)
    a = 0;
  return a;
}

static Sint
cam_volatile_mem_lt(a, p)
Sint a;
volatile Sint *p;
{
  if (a < *p)
    a = 0;
  return a;
}

static Sint
cam_volatile_mem_gt(a, p)
Sint a;
volatile Sint *p;
{
  if (a > *p)
    a = 0;
  return a;
}

static Sint
cam_qi_signed(a, p)
sQint a;
Sint *p;
{
  if (a < *p)
    return 1;
  return 0;
}

static Sint
cam_qi_unsigned(a, p)
uQint a;
Sint *p;
{
  if (a == *p)
    return 1;
  return 0;
}

static Sint
cam_hi_signed(a, p)
Hint a;
Sint *p;
{
  if (a >= *p)
    return 1;
  return 0;
}

static Sint
cam_hi_unsigned(a, p)
uHint a;
Sint *p;
{
  if (a != *p)
    return 1;
  return 0;
}

static Sint
cam_array_value(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  if (a <= v[i & 7])
    return a;
  return v[i & 7];
}

static Sint
cam_array_value_rev(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  if (v[i & 7] >= a)
    return a;
  return v[i & 7];
}

static Sint
cam_struct_value(a, p)
Sint a;
struct cam_struct *p;
{
  if (a > p->b)
    return a;
  return p->b;
}

static Sint
cam_struct_value_eq(a, p)
Sint a;
struct cam_struct *p;
{
  if (a == p->c)
    return p->a;
  return a;
}

static Sint
cam_call_pressure(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  Sint r;

  r = a + *p;
  if (a < *q)
    clobber();
  if (a != 0123456123456)
    clobber();

  return r + a + *p + *q;
}

static Sint
cam_two_compares(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  if (a < *p && a > *q)
    return a;
  return *p + *q;
}

static Sint
cam_or_compares(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  if (a == *p || a == *q)
    return a;
  return *p - *q;
}

static Sint
cam_nested(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  if (a >= *p) {
    if (a <= *q)
      return a;
    return *q;
  }

  return *p;
}

static uSint
ucam_mem_eq(a, p)
uSint a;
uSint *p;
{
  if (a == *p)
    a = 0;
  return a;
}

static uSint
ucam_mem_ne(a, p)
uSint a;
uSint *p;
{
  if (a != *p)
    a = 0;
  return a;
}

static uSint
ucam_big_eq(a)
uSint a;
{
  if (a == 0123456123456)
    return 1;
  return 0;
}

static uSint
ucam_big_ne(a)
uSint a;
{
  if (a != 0123456123456)
    return 1;
  return 0;
}
