#include "insns.h"

/*
 * CAI instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended compiler-generated forms:
 *   CAIL   compare AC with small immediate, skip if less
 *   CAIE   skip if equal
 *   CAILE  skip if less-or-equal
 *   CAIGE  skip if greater-or-equal
 *   CAIN   skip if not-equal
 *   CAIG   skip if greater
 *
 * Plain CAI and CAIA are not normally useful C branch forms; ordinary
 * conditional C against small immediates should exercise the practical
 * CAI lowering surface.  The backend also has special CAI forms for
 * right-half masked pointer/index expressions.
 */

extern Sint f(void);
extern void clobber(void);

#define CAI_BRANCH(NAME, OP, K)                 \
static Sint                                     \
cai_##NAME(a)                                  \
Sint a;                                        \
{                                              \
  if (a OP K)                                  \
    a = 0;                                     \
  return a;                                    \
}

#define CAI_BRANCH_INV(NAME, OP, K)             \
static Sint                                     \
cai_##NAME##_inv(a)                            \
Sint a;                                        \
{                                              \
  if (!(a OP K))                               \
    a = 0;                                     \
  return a;                                    \
}

#define CAI_CALL(NAME, OP, K)                   \
static Sint                                     \
cai_##NAME##_call(a)                           \
Sint a;                                        \
{                                              \
  if (a OP K)                                  \
    a += f();                                  \
  return a;                                    \
}

#define CAI_LOOP(NAME, OP, K)                   \
static Sint                                     \
cai_##NAME##_loop(a, x)                        \
Sint a;                                        \
Sint x;                                        \
{                                              \
  while (a OP K) {                             \
    x += a;                                    \
    ++a;                                       \
  }                                            \
  return x + a;                                \
}

#define CAI_VALUE(NAME, OP, K)                  \
static Sint                                     \
cai_##NAME##_value(a)                          \
Sint a;                                        \
{                                              \
  Sint r;                                      \
                                               \
  r = 0;                                       \
  if (a OP K)                                  \
    r = 1;                                     \
  return r;                                    \
}

#define CAI_TEST(NAME, OP, K)                   \
  CAI_BRANCH(NAME, OP, K)                      \
  CAI_BRANCH_INV(NAME, OP, K)                  \
  CAI_CALL(NAME, OP, K)                        \
  CAI_LOOP(NAME, OP, K)                        \
  CAI_VALUE(NAME, OP, K)

CAI_TEST(lt_2, <, 2)
CAI_TEST(eq_2, ==, 2)
CAI_TEST(le_2, <=, 2)
CAI_TEST(ge_2, >=, 2)
CAI_TEST(ne_2, !=, 2)
CAI_TEST(gt_2, >, 2)

CAI_TEST(lt_0, <, 0)
CAI_TEST(eq_0, ==, 0)
CAI_TEST(le_0, <=, 0)
CAI_TEST(ge_0, >=, 0)
CAI_TEST(ne_0, !=, 0)
CAI_TEST(gt_0, >, 0)

CAI_TEST(lt_1, <, 1)
CAI_TEST(eq_1, ==, 1)
CAI_TEST(le_1, <=, 1)
CAI_TEST(ge_1, >=, 1)
CAI_TEST(ne_1, !=, 1)
CAI_TEST(gt_1, >, 1)

CAI_TEST(lt_777777, <, 0777777)
CAI_TEST(eq_777777, ==, 0777777)
CAI_TEST(le_777777, <=, 0777777)
CAI_TEST(ge_777777, >=, 0777777)
CAI_TEST(ne_777777, !=, 0777777)
CAI_TEST(gt_777777, >, 0777777)

static Sint
cai_chain(a)
Sint a;
{
  if (a < 0)
    return 01;
  if (a == 0)
    return 02;
  if (a <= 1)
    return 03;
  if (a >= 0777777)
    return 04;
  if (a != 0123456)
    return 05;
  if (a > 0123456)
    return 06;

  return a;
}

static Sint
cai_chain_inverted(a)
Sint a;
{
  if (!(a < 0))
    a += 01;
  if (!(a == 0))
    a += 02;
  if (!(a <= 1))
    a += 03;
  if (!(a >= 0777777))
    a += 04;
  if (!(a != 0123456))
    a += 05;
  if (!(a > 0123456))
    a += 06;

  return a;
}

static Sint
cai_with_call_pressure(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = a + b;
  if (a < 0123456)
    clobber();
  if (b >= 0777777)
    clobber();

  return r + a + b;
}

static Sint
cai_memory_loaded(p)
Sint *p;
{
  Sint a;

  a = *p;
  if (a == 0123456)
    a = 0;
  return a;
}

static Sint
cai_memory_loaded_inv(p)
Sint *p;
{
  Sint a;

  a = *p;
  if (a != 0123456)
    a = 0;
  return a;
}

static Sint
cai_volatile_loaded(p)
volatile Sint *p;
{
  Sint a;

  a = *p;
  if (a <= 0123456)
    a = 0;
  return a;
}

static Sint
cai_qi_signed(a)
sQint a;
{
  if (a < 2)
    return 1;
  return 0;
}

static Sint
cai_qi_unsigned(a)
uQint a;
{
  if (a > 0377)
    return 1;
  return 0;
}

static Sint
cai_hi_signed(a)
Hint a;
{
  if (a >= 0123456)
    return 1;
  return 0;
}

static Sint
cai_hi_unsigned(a)
uHint a;
{
  if (a != 0777777)
    return 1;
  return 0;
}

/*
 * Special backend forms:
 *
 *   *CAI_reg_plus_const
 *   *CAI_const_plus_reg
 *
 * These compare right-half-masked add/index expressions against a
 * register, producing CAI with indexed effective-address syntax when
 * combine succeeds.
 */

static Sint
cai_reg_plus_const_lt(a, b)
Sint a;
Sint b;
{
  if (((a + 01234) & 0777777) < b)
    return a;
  return b;
}

static Sint
cai_reg_plus_const_eq(a, b)
Sint a;
Sint b;
{
  if (((a + 01234) & 0777777) == b)
    return a;
  return b;
}

static Sint
cai_reg_plus_const_le(a, b)
Sint a;
Sint b;
{
  if (((a + 01234) & 0777777) <= b)
    return a;
  return b;
}

static Sint
cai_reg_plus_const_ge(a, b)
Sint a;
Sint b;
{
  if (((a + 01234) & 0777777) >= b)
    return a;
  return b;
}

static Sint
cai_reg_plus_const_ne(a, b)
Sint a;
Sint b;
{
  if (((a + 01234) & 0777777) != b)
    return a;
  return b;
}

static Sint
cai_reg_plus_const_gt(a, b)
Sint a;
Sint b;
{
  if (((a + 01234) & 0777777) > b)
    return a;
  return b;
}

static Sint
cai_const_plus_reg_lt(a, b)
Sint a;
Sint b;
{
  if (b < ((a + 01234) & 0777777))
    return a;
  return b;
}

static Sint
cai_const_plus_reg_eq(a, b)
Sint a;
Sint b;
{
  if (b == ((a + 01234) & 0777777))
    return a;
  return b;
}

static Sint
cai_const_plus_reg_le(a, b)
Sint a;
Sint b;
{
  if (b <= ((a + 01234) & 0777777))
    return a;
  return b;
}

static Sint
cai_const_plus_reg_ge(a, b)
Sint a;
Sint b;
{
  if (b >= ((a + 01234) & 0777777))
    return a;
  return b;
}

static Sint
cai_const_plus_reg_ne(a, b)
Sint a;
Sint b;
{
  if (b != ((a + 01234) & 0777777))
    return a;
  return b;
}

static Sint
cai_const_plus_reg_gt(a, b)
Sint a;
Sint b;
{
  if (b > ((a + 01234) & 0777777))
    return a;
  return b;
}

static Sint
cai_small_index(a, b)
Sint a;
Sint b;
{
  if (((a + 1) & 0777777) == b)
    return a + b;
  return a - b;
}

static Sint
cai_large_index(a, b)
Sint a;
Sint b;
{
  if (((a + 0777777) & 0777777) != b)
    return a + b;
  return a - b;
}
