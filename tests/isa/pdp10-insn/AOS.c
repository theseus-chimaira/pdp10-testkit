#include "insns.h"

/*
 * AOS instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   AOS    increment memory
 *   AOS    increment memory and return/load the incremented value
 *   AOSL   ++mem <  0
 *   AOSE   ++mem == 0
 *   AOSLE  ++mem <= 0
 *   AOSGE  ++mem >= 0
 *   AOSN   ++mem != 0
 *   AOSG   ++mem >  0
 *
 * AOSA is not a normal useful C branch form in this backend pass.  The
 * useful unconditional memory-increment cases are covered by plain AOS
 * and AOS-and-move shapes.
 */

extern Sint f(void);
extern void clobber(void);

struct aos_struct {
  Sint a;
  Sint b;
  Sint c;
} *p;

static void
aos_plain(x)
Sint *x;
{
  ++*x;
}

static void
aos_post_plain(x)
Sint *x;
{
  (*x)++;
}

static Sint
aos_value_pre(x)
Sint *x;
{
  return ++*x;
}

static Sint
aos_value_post(x)
Sint *x;
{
  return (*x)++;
}

static Sint
aos_value_plus_arg(x, a)
Sint *x;
Sint a;
{
  return ++*x + a;
}

static Sint
aos_value_twice(x)
Sint *x;
{
  Sint y;

  y = ++*x;
  return y + *x;
}

static Sint
aos_local_addr(a)
Sint a;
{
  Sint x;

  x = a;
  ++x;
  return x;
}

static Sint
aos_through_arg(x, y)
Sint *x;
Sint *y;
{
  ++*x;
  return *x + *y;
}

static void
aos_volatile_plain(x)
volatile Sint *x;
{
  ++*x;
}

static Sint
aos_volatile_value(x)
volatile Sint *x;
{
  return ++*x;
}

#define AOS_BRANCH(NAME, OP)                    \
static void                                     \
aos_##NAME(x)                                  \
Sint *x;                                       \
{                                              \
  if (++*x OP 0)                               \
    f();                                       \
}

#define AOS_BRANCH_INV(NAME, OP)                \
static void                                     \
aos_##NAME##_inv(x)                            \
Sint *x;                                       \
{                                              \
  if (!(++*x OP 0))                            \
    f();                                       \
}

#define AOS_VALUE(NAME, OP)                     \
static Sint                                    \
aos_##NAME##_value(x)                          \
Sint *x;                                       \
{                                              \
  Sint y;                                      \
                                               \
  y = ++*x;                                    \
  if (y OP 0)                                  \
    y += f();                                  \
  return y;                                    \
}

#define AOS_VALUE_INV(NAME, OP)                 \
static Sint                                    \
aos_##NAME##_value_inv(x)                      \
Sint *x;                                       \
{                                              \
  Sint y;                                      \
                                               \
  y = ++*x;                                    \
  if (!(y OP 0))                               \
    y += f();                                  \
  return y;                                    \
}

#define AOS_LOOP(NAME, OP)                      \
static Sint                                    \
aos_##NAME##_loop(x, a)                        \
Sint *x;                                       \
Sint a;                                        \
{                                              \
  do {                                         \
    a += *x;                                   \
  } while (++*x OP 0);                         \
  return a + *x;                               \
}

#define AOS_TEST(NAME, OP)                      \
  AOS_BRANCH(NAME, OP)                         \
  AOS_BRANCH_INV(NAME, OP)                     \
  AOS_VALUE(NAME, OP)                          \
  AOS_VALUE_INV(NAME, OP)                      \
  AOS_LOOP(NAME, OP)

AOS_TEST(l, <)
AOS_TEST(e, ==)
AOS_TEST(le, <=)
AOS_TEST(ge, >=)
AOS_TEST(n, !=)
AOS_TEST(g, >)

static Sint
aos_call_pressure(x, a, b)
Sint *x;
Sint a;
Sint b;
{
  Sint y;

  y = ++*x;
  clobber();
  return y + a + b + *x;
}

static Sint
aos_branch_call_pressure(x, a)
Sint *x;
Sint a;
{
  if (++*x > 0)
    clobber();

  return *x + a;
}

static Sint
aos_array_elem(v, i)
Sint *v;
Sint i;
{
  return ++v[i & 7];
}

static void
aos_array_elem_void(v, i)
Sint *v;
Sint i;
{
  ++v[i & 7];
}

static Sint
aos_struct_member(p)
struct aos_struct *p;
{
  return ++p->b;
}

static void
aos_struct_member_void(p)
struct aos_struct *p;
{
  ++p->c;
}

static Sint
aos_nested(x, y, a)
Sint *x;
Sint *y;
Sint a;
{
  do {
    a += ++*y;
  } while (++*x != 0);

  return a + *x + *y;
}

static Sint
aos_edge_minus_one(x)
Sint *x;
{
  *x = -1;
  return ++*x;
}

static Sint
aos_edge_zero(x)
Sint *x;
{
  *x = 0;
  return ++*x;
}

static Sint
aos_edge_sign(x)
Sint *x;
{
  *x = 0377777777777;
  return ++*x;
}
