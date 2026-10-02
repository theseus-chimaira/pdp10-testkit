#include "insns.h"

/*
 * SOS instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SOS    memory <- memory - 1
 *   SOSL   decrement memory; skip if result <  0
 *   SOSE   decrement memory; skip if result == 0
 *   SOSLE  decrement memory; skip if result <= 0
 *   SOSA   decrement memory; always skip
 *   SOSGE  decrement memory; skip if result >= 0
 *   SOSN   decrement memory; skip if result != 0
 *   SOSG   decrement memory; skip if result >  0
 *
 * Register decrement-and-branch belongs to SOJ.c.  Keep the decremented
 * object in memory here.
 */

extern Sint f(void);

static Sint sos_ga;
static Sint sos_gb;
static Sint sos_buf[16];

struct sos_pair {
  Sint a;
  Sint b;
};

static struct sos_pair sos_gp;

static void
sos_mem(x)
Sint *x;
{
  --*x;
}

static Sint
sos_ac(x)
Sint *x;
{
  return --*x;
}

static void
sos_global_a(void)
{
  --sos_ga;
}

static void
sos_global_b(void)
{
  --sos_gb;
}

static Sint
sos_global_a_ac(void)
{
  return --sos_ga;
}

static Sint
sos_global_b_ac(void)
{
  return --sos_gb;
}

static void
sos_array(v, i)
Sint *v;
Sint i;
{
  --v[i & 017];
}

static Sint
sos_array_ac(v, i)
Sint *v;
Sint i;
{
  return --v[i & 017];
}

static void
sos_global_array(i)
Sint i;
{
  --sos_buf[i & 017];
}

static Sint
sos_global_array_ac(i)
Sint i;
{
  return --sos_buf[i & 017];
}

static void
sos_struct_a(p)
struct sos_pair *p;
{
  --p->a;
}

static void
sos_struct_b(p)
struct sos_pair *p;
{
  --p->b;
}

static Sint
sos_struct_a_ac(p)
struct sos_pair *p;
{
  return --p->a;
}

static Sint
sos_struct_b_ac(p)
struct sos_pair *p;
{
  return --p->b;
}

static void
sos_global_struct_a(void)
{
  --sos_gp.a;
}

static void
sos_global_struct_b(void)
{
  --sos_gp.b;
}

static Sint
sos_global_struct_a_ac(void)
{
  return --sos_gp.a;
}

static Sint
sos_global_struct_b_ac(void)
{
  return --sos_gp.b;
}

static void
sos_indirect(pp)
Sint **pp;
{
  --**pp;
}

static Sint
sos_indirect_ac(pp)
Sint **pp;
{
  return --**pp;
}

static void
sos_volatile(x)
volatile Sint *x;
{
  --*x;
}

static Sint
sos_volatile_ac(x)
volatile Sint *x;
{
  return --*x;
}

#define SOS_BRANCH(N, OP)                 \
static void                               \
sos##N(x)                                 \
Sint *x;                                  \
{                                         \
  if (likely(!(--*x OP 0)))               \
    f();                                  \
}

#define SOS_BRANCH_UNLIKELY(N, OP)        \
static void                               \
sos##N##_unlikely(x)                      \
Sint *x;                                  \
{                                         \
  if (unlikely(!(--*x OP 0)))             \
    f();                                  \
}

#define SOS_AC_BRANCH(N, OP)              \
static Sint                               \
sos##N##_ac(x)                            \
Sint *x;                                  \
{                                         \
  Sint y;                                 \
                                          \
  y = --*x;                               \
  if (likely(!(y OP 0)))                  \
    y = 0;                                \
  return y;                               \
}

#define SOS_AC_BRANCH_UNLIKELY(N, OP)     \
static Sint                               \
sos##N##_ac_unlikely(x)                   \
Sint *x;                                  \
{                                         \
  Sint y;                                 \
                                          \
  y = --*x;                               \
  if (unlikely(!(y OP 0)))                \
    y = 0;                                \
  return y;                               \
}

#define SOS_DIRECT_BRANCH(N, OP)          \
static Sint                               \
sos##N##_direct(x, a, b)                  \
Sint *x;                                  \
Sint a;                                   \
Sint b;                                   \
{                                         \
  if (--*x OP 0)                          \
    return a;                             \
  return b;                               \
}

#define SOS_DIRECT_AC(N, OP)              \
static Sint                               \
sos##N##_direct_ac(x, a)                  \
Sint *x;                                  \
Sint a;                                   \
{                                         \
  Sint y;                                 \
                                          \
  y = --*x;                               \
  if (y OP 0)                             \
    a = y;                                \
  return a;                               \
}

#define TEST(N, OP)                       \
  SOS_BRANCH(N, OP)                       \
  SOS_BRANCH_UNLIKELY(N, OP)              \
  SOS_AC_BRANCH(N, OP)                    \
  SOS_AC_BRANCH_UNLIKELY(N, OP)           \
  SOS_DIRECT_BRANCH(N, OP)                \
  SOS_DIRECT_AC(N, OP)

TEST(l, <)
TEST(e, ==)
TEST(le, <=)
TEST(ge, >=)
TEST(n, !=)
TEST(g, >)

static void
sosl_global(void)
{
  if (!(--sos_ga < 0))
    f();
}

static void
sose_global(void)
{
  if (!(--sos_ga == 0))
    f();
}

static void
sosle_global(void)
{
  if (!(--sos_ga <= 0))
    f();
}

static void
sosge_global(void)
{
  if (!(--sos_ga >= 0))
    f();
}

static void
sosn_global(void)
{
  if (!(--sos_ga != 0))
    f();
}

static void
sosg_global(void)
{
  if (!(--sos_ga > 0))
    f();
}

static Sint
sosl_global_ac(void)
{
  Sint y;

  y = --sos_ga;
  if (!(y < 0))
    y = 0;
  return y;
}

static Sint
sose_global_ac(void)
{
  Sint y;

  y = --sos_ga;
  if (!(y == 0))
    y = 0;
  return y;
}

static Sint
sosle_global_ac(void)
{
  Sint y;

  y = --sos_ga;
  if (!(y <= 0))
    y = 0;
  return y;
}

static Sint
sosge_global_ac(void)
{
  Sint y;

  y = --sos_ga;
  if (!(y >= 0))
    y = 0;
  return y;
}

static Sint
sosn_global_ac(void)
{
  Sint y;

  y = --sos_ga;
  if (!(y != 0))
    y = 0;
  return y;
}

static Sint
sosg_global_ac(void)
{
  Sint y;

  y = --sos_ga;
  if (!(y > 0))
    y = 0;
  return y;
}

static void
sosl_array(v, i)
Sint *v;
Sint i;
{
  if (!(--v[i & 017] < 0))
    f();
}

static void
sose_array(v, i)
Sint *v;
Sint i;
{
  if (!(--v[i & 017] == 0))
    f();
}

static void
sosle_array(v, i)
Sint *v;
Sint i;
{
  if (!(--v[i & 017] <= 0))
    f();
}

static void
sosge_array(v, i)
Sint *v;
Sint i;
{
  if (!(--v[i & 017] >= 0))
    f();
}

static void
sosn_array(v, i)
Sint *v;
Sint i;
{
  if (!(--v[i & 017] != 0))
    f();
}

static void
sosg_array(v, i)
Sint *v;
Sint i;
{
  if (!(--v[i & 017] > 0))
    f();
}

static Sint
sosl_array_ac(v, i)
Sint *v;
Sint i;
{
  Sint y;

  y = --v[i & 017];
  if (!(y < 0))
    y = 0;
  return y;
}

static Sint
sose_array_ac(v, i)
Sint *v;
Sint i;
{
  Sint y;

  y = --v[i & 017];
  if (!(y == 0))
    y = 0;
  return y;
}

static Sint
sosle_array_ac(v, i)
Sint *v;
Sint i;
{
  Sint y;

  y = --v[i & 017];
  if (!(y <= 0))
    y = 0;
  return y;
}

static Sint
sosge_array_ac(v, i)
Sint *v;
Sint i;
{
  Sint y;

  y = --v[i & 017];
  if (!(y >= 0))
    y = 0;
  return y;
}

static Sint
sosn_array_ac(v, i)
Sint *v;
Sint i;
{
  Sint y;

  y = --v[i & 017];
  if (!(y != 0))
    y = 0;
  return y;
}

static Sint
sosg_array_ac(v, i)
Sint *v;
Sint i;
{
  Sint y;

  y = --v[i & 017];
  if (!(y > 0))
    y = 0;
  return y;
}

static void
sosl_struct_a(p)
struct sos_pair *p;
{
  if (!(--p->a < 0))
    f();
}

static void
sose_struct_a(p)
struct sos_pair *p;
{
  if (!(--p->a == 0))
    f();
}

static void
sosle_struct_a(p)
struct sos_pair *p;
{
  if (!(--p->a <= 0))
    f();
}

static void
sosge_struct_b(p)
struct sos_pair *p;
{
  if (!(--p->b >= 0))
    f();
}

static void
sosn_struct_b(p)
struct sos_pair *p;
{
  if (!(--p->b != 0))
    f();
}

static void
sosg_struct_b(p)
struct sos_pair *p;
{
  if (!(--p->b > 0))
    f();
}

static Sint
sosl_struct_a_ac(p)
struct sos_pair *p;
{
  Sint y;

  y = --p->a;
  if (!(y < 0))
    y = 0;
  return y;
}

static Sint
sose_struct_a_ac(p)
struct sos_pair *p;
{
  Sint y;

  y = --p->a;
  if (!(y == 0))
    y = 0;
  return y;
}

static Sint
sosle_struct_a_ac(p)
struct sos_pair *p;
{
  Sint y;

  y = --p->a;
  if (!(y <= 0))
    y = 0;
  return y;
}

static Sint
sosge_struct_b_ac(p)
struct sos_pair *p;
{
  Sint y;

  y = --p->b;
  if (!(y >= 0))
    y = 0;
  return y;
}

static Sint
sosn_struct_b_ac(p)
struct sos_pair *p;
{
  Sint y;

  y = --p->b;
  if (!(y != 0))
    y = 0;
  return y;
}

static Sint
sosg_struct_b_ac(p)
struct sos_pair *p;
{
  Sint y;

  y = --p->b;
  if (!(y > 0))
    y = 0;
  return y;
}

/*
 * SOSA pressure.  Plain decrement plus an unconditional transfer is the
 * closest normal-C shape for decrement-and-always-skip.  The backend may
 * still lower these as SOS plus JRST today.
 */

static void
sosa_goto(x)
Sint *x;
{
  --*x;
  goto done;
done:
  f();
}

static Sint
sosa_ac_goto(x)
Sint *x;
{
  Sint y;

  y = --*x;
  goto done;
done:
  return y;
}

static Sint
sosa_select(x, a)
Sint *x;
Sint a;
{
  Sint y;

  y = --*x;
  if (a)
    goto done;
  goto done;
done:
  return y;
}

static void
sos_two(x, y)
Sint *x;
Sint *y;
{
  --*x;
  --*y;
}

static Sint
sos_two_ac(x, y)
Sint *x;
Sint *y;
{
  Sint a;
  Sint b;

  a = --*x;
  b = --*y;
  return a + b;
}

static void
sos_chain_branch(x, y)
Sint *x;
Sint *y;
{
  if (--*x == 0)
    --*y;
}

static Sint
sos_chain_branch_ac(x, y)
Sint *x;
Sint *y;
{
  Sint a;

  a = --*x;
  if (a != 0)
    a += --*y;
  return a;
}

static Sint
sos_loop_count(x)
Sint *x;
{
  Sint s;

  s = 0;
  while (--*x > 0)
    s += *x;

  return s;
}

static Sint
sos_loop_until_zero(x)
Sint *x;
{
  Sint s;

  s = 0;
  while (--*x != 0)
    s += *x;

  return s;
}

static void
sos_qi(x)
sQint *x;
{
  --*x;
}

static Sint
sos_qi_ac(x)
sQint *x;
{
  return --*x;
}

static void
sos_hi(x)
Hint *x;
{
  --*x;
}

static Sint
sos_hi_ac(x)
Hint *x;
{
  return --*x;
}

static void
sos_unsigned_eq(x)
uSint *x;
{
  if (!(--*x == 0))
    f();
}

static void
sos_unsigned_ne(x)
uSint *x;
{
  if (!(--*x != 0))
    f();
}

static uSint
sos_unsigned_ac(x)
uSint *x;
{
  return --*x;
}
