#include "insns.h"

/*
 * Move-and-skip register-pressure coverage for PDP-6/166 and KA10.
 *
 * The goal is to keep many values live across skip-like memory tests so
 * any hidden fixed scratch register use becomes visible in generated code.
 *
 * This is not the basic move-and-skip idiom test; that is
 * move_and_skip.c.  This file stresses:
 *
 *   loaded memory value tested against zero
 *   many live SImode values across the test
 *   both arms using different live values
 *   stores after skip-like tests
 *   globals, arrays, structs, volatile memory
 *   calls near live skip results
 *   smaller-mode load controls
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern void sink_int();

static int mskip_pg0;
static int mskip_pg1;
static int mskip_pg2;
static int mskip_pbuf[16];

static Sint mskip_psg0;
static Sint mskip_psg1;
static Sint mskip_psbuf[16];

struct mskip_pair {
  int a;
  int b;
};

struct mskip_three {
  int a;
  int b;
  int c;
};

struct mskip_spair {
  Sint a;
  Sint b;
};

static struct mskip_pair mskip_gp;
static struct mskip_three mskip_gt;
static struct mskip_spair mskip_sgp;

static int
pressure_skip_mem(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int s3;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;
  s3 = s0 + s1 + s2;

  x = *p;
  if (x != 0)
    s3 += x + s0;
  else
    s3 += *q + s1;

  return s3 + s0 + s1 + s2;
}

static int
pressure_skip_compare(p, a, b, c, d, e, f)
int *p;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a - b;
  s1 = c - d;
  s2 = e - f;

  x = *p;
  if (x < 0)
    return s0 + s1 + s2 - x;
  if (x > 0)
    return s0 - s1 + s2 + x;

  return s0 + s1 - s2;
}

static int
pressure_skip_store(p, q, a, b, c, d)
int *p;
int *q;
int a;
int b;
int c;
int d;
{
  int s;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  s = a + b + c + d;
  x = *p;

  if (x == 0)
    *p = s;
  else
    *q = s + x;

  return *p + *q + s;
}

#define PRESSURE_SKIP_MEM(name, cmp)                  \
static int                                            \
pressure_skip_##name(p, q, a, b, c, d, e, f)          \
int *p;                                               \
int *q;                                               \
int a;                                                \
int b;                                                \
int c;                                                \
int d;                                                \
int e;                                                \
int f;                                                \
{                                                     \
  int s0;                                             \
  int s1;                                             \
  int s2;                                             \
  int s3;                                             \
  int s4;                                             \
  int x;                                              \
                                                      \
  OPAQUE_REG(a);                                      \
  OPAQUE_REG(b);                                      \
  OPAQUE_REG(c);                                      \
  OPAQUE_REG(d);                                      \
  OPAQUE_REG(e);                                      \
  OPAQUE_REG(f);                                      \
                                                      \
  s0 = a + b;                                         \
  s1 = c + d;                                         \
  s2 = e + f;                                         \
  s3 = a - d;                                         \
  s4 = b ^ f;                                         \
                                                      \
  x = *p;                                             \
  if (x cmp 0)                                        \
    return x + s0 + s2 + s4;                          \
  return *q + s1 + s3 + s4;                           \
}

PRESSURE_SKIP_MEM(eq, ==)
PRESSURE_SKIP_MEM(ne, !=)
PRESSURE_SKIP_MEM(ge, >=)
PRESSURE_SKIP_MEM(le, <=)
PRESSURE_SKIP_MEM(gt, >)
PRESSURE_SKIP_MEM(lt, <)

#define PRESSURE_SKIP_DIRECT(name, cmp)               \
static int                                            \
pressure_direct_##name(p, q, a, b, c, d, e, f)        \
int *p;                                               \
int *q;                                               \
int a;                                                \
int b;                                                \
int c;                                                \
int d;                                                \
int e;                                                \
int f;                                                \
{                                                     \
  int s0;                                             \
  int s1;                                             \
  int s2;                                             \
  int s3;                                             \
                                                      \
  OPAQUE_REG(a);                                      \
  OPAQUE_REG(b);                                      \
  OPAQUE_REG(c);                                      \
  OPAQUE_REG(d);                                      \
  OPAQUE_REG(e);                                      \
  OPAQUE_REG(f);                                      \
                                                      \
  s0 = a + b;                                         \
  s1 = c + d;                                         \
  s2 = e + f;                                         \
  s3 = s0 + s1 + s2;                                  \
                                                      \
  if (*p cmp 0)                                       \
    return *p + s3 + s0;                              \
  return *q + s3 + s1;                                \
}

PRESSURE_SKIP_DIRECT(eq, ==)
PRESSURE_SKIP_DIRECT(ne, !=)
PRESSURE_SKIP_DIRECT(ge, >=)
PRESSURE_SKIP_DIRECT(le, <=)
PRESSURE_SKIP_DIRECT(gt, >)
PRESSURE_SKIP_DIRECT(lt, <)

#define PRESSURE_SKIP_LIKELY(name, cmp, hint)         \
static int                                            \
pressure_##hint##_##name(p, q, a, b, c, d, e, f)      \
int *p;                                               \
int *q;                                               \
int a;                                                \
int b;                                                \
int c;                                                \
int d;                                                \
int e;                                                \
int f;                                                \
{                                                     \
  int s0;                                             \
  int s1;                                             \
  int s2;                                             \
  int s3;                                             \
  int x;                                              \
                                                      \
  OPAQUE_REG(a);                                      \
  OPAQUE_REG(b);                                      \
  OPAQUE_REG(c);                                      \
  OPAQUE_REG(d);                                      \
  OPAQUE_REG(e);                                      \
  OPAQUE_REG(f);                                      \
                                                      \
  s0 = a + b;                                         \
  s1 = c - d;                                         \
  s2 = e ^ f;                                         \
  s3 = s0 + s1 + s2;                                  \
                                                      \
  x = *p;                                             \
  if (hint(x cmp 0))                                  \
    return s3 + x + s0;                               \
  return s3 + *q + s1;                                \
}

PRESSURE_SKIP_LIKELY(eq, ==, likely)
PRESSURE_SKIP_LIKELY(ne, !=, likely)
PRESSURE_SKIP_LIKELY(lt, <, likely)
PRESSURE_SKIP_LIKELY(gt, >, likely)

PRESSURE_SKIP_LIKELY(eq, ==, unlikely)
PRESSURE_SKIP_LIKELY(ne, !=, unlikely)
PRESSURE_SKIP_LIKELY(lt, <, unlikely)
PRESSURE_SKIP_LIKELY(gt, >, unlikely)

static int
pressure_skip_inverted(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int s3;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;
  s3 = s0 + s1 + s2;

  x = *p;
  if (x == 0)
    return *q + s1 + s3;

  return x + s0 + s2 + s3;
}

static int
pressure_skip_goto(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int s3;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;
  s3 = s0 + s1 + s2;

  x = *p;
  if (x != 0)
    goto nonzero;

  return *q + s1 + s3;

nonzero:
  return x + s0 + s2 + s3;
}

static int
pressure_skip_two_tests(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int s3;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c - d;
  s2 = e + f;
  s3 = s0 + s1 + s2;

  x = *p;
  if (x < 0)
    return s3 - x + s0;
  if (x > 0)
    return s3 + x + s1;

  return s3 + *q + s2;
}

static int
pressure_skip_three_tests(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int s3;
  int s4;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;
  s3 = a - f;
  s4 = s0 + s1 + s2 + s3;

  x = *p;
  if (x == 0)
    return s4 + *q;
  if (x < 0)
    return s4 - x + s0;
  if (x > 0)
    return s4 + x + s1;

  return s4 + s2;
}

static int
pressure_skip_store_eq(p, q, r, a, b, c, d, e, f)
int *p;
int *q;
int *r;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;
  int y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = *p;
  if (x == 0)
    y = s0 + s2;
  else
    y = x + *q + s1;

  *r = y;
  return *r + s0 + s1 + s2;
}

static int
pressure_skip_store_ne(p, q, r, a, b, c, d, e, f)
int *p;
int *q;
int *r;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;
  int y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a - b;
  s1 = c - d;
  s2 = e - f;

  x = *p;
  if (x != 0)
    y = x + s0 + s2;
  else
    y = *q + s1;

  *r = y;
  return *r + s0 + s1 + s2;
}

static int
pressure_skip_update_p(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = *p;
  if (x != 0)
    *p = x + s0;
  else
    *p = *q + s1;

  return *p + s0 + s1 + s2;
}

static int
pressure_skip_update_q(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a - b;
  s1 = c - d;
  s2 = e - f;

  x = *p;
  if (x < 0)
    *q = s0 - x;
  else
    *q = s1 + x;

  return *q + s0 + s1 + s2;
}

static int
pressure_skip_global(a, b, c, d, e, f)
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_pg0;
  if (x != 0)
    return x + s0 + s2;

  return mskip_pg1 + s1 + s2;
}

static int
pressure_skip_global_store(a, b, c, d, e, f)
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_pg0;
  if (x == 0)
    mskip_pg2 = s0 + s2;
  else
    mskip_pg2 = x + s1;

  return mskip_pg2 + s0 + s1 + s2;
}

static Sint
pressure_skip_sint_global(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  Sint s0;
  Sint s1;
  Sint s2;
  Sint x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_psg0;
  if (x < 0)
    return x + s0 + s2;

  return mskip_psg1 + s1 + s2;
}

static int
pressure_skip_array(i, a, b, c, d, e, f)
int i;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(i);
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  i &= 017;
  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_pbuf[i];
  if (x != 0)
    return x + s0 + s2;

  return mskip_pbuf[(i + 1) & 017] + s1 + s2;
}

static int
pressure_skip_array_store(i, a, b, c, d, e, f)
int i;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(i);
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  i &= 017;
  s0 = a - b;
  s1 = c - d;
  s2 = e - f;

  x = mskip_pbuf[i];
  if (x < 0)
    mskip_pbuf[(i + 1) & 017] = s0 - x;
  else
    mskip_pbuf[(i + 1) & 017] = s1 + x;

  return mskip_pbuf[(i + 1) & 017] + s0 + s1 + s2;
}

static Sint
pressure_skip_sint_array(i, a, b, c, d, e, f)
Sint i;
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  Sint s0;
  Sint s1;
  Sint s2;
  Sint x;

  OPAQUE_REG(i);
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  i &= 017;
  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_psbuf[i];
  if (x >= 0)
    return x + s0 + s2;

  return mskip_psbuf[(i + 1) & 017] + s1 + s2;
}

static int
pressure_skip_struct(p, a, b, c, d, e, f)
struct mskip_pair *p;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = p->a;
  if (x != 0)
    return x + s0 + s2;

  return p->b + s1 + s2;
}

static int
pressure_skip_struct_store(p, a, b, c, d, e, f)
struct mskip_three *p;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = p->a;
  if (x == 0)
    p->c = s0 + s2;
  else
    p->c = x + p->b + s1;

  return p->c + s0 + s1 + s2;
}

static int
pressure_skip_global_struct(a, b, c, d, e, f)
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_gp.a;
  if (x != 0)
    return x + s0 + s2;

  return mskip_gp.b + s1 + s2;
}

static Sint
pressure_skip_sint_struct(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  Sint s0;
  Sint s1;
  Sint s2;
  Sint x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = mskip_sgp.a;
  if (x < 0)
    return x + s0 + s2;

  return mskip_sgp.b + s1 + s2;
}

static int
pressure_skip_volatile(p, q, a, b, c, d, e, f)
volatile int *p;
volatile int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = *p;
  if (x != 0)
    return x + s0 + s2;

  return *q + s1 + s2;
}

static int
pressure_skip_volatile_store(p, q, a, b, c, d, e, f)
volatile int *p;
volatile int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a - b;
  s1 = c - d;
  s2 = e - f;

  x = *p;
  if (x < 0)
    *q = s0 - x;
  else
    *q = s1 + x;

  return *q + s0 + s1 + s2;
}

static int
pressure_skip_call_after(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = *p;
  if (x != 0)
    r = x + s0;
  else
    r = *q + s1;

  sink_int(r);

  return r + s0 + s1 + s2;
}

static int
pressure_skip_call_in_arms(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = *p;
  if (x != 0) {
    r = x + s0;
    sink_int(r);
  } else {
    r = *q + s1;
    sink_int(r);
  }

  return r + s0 + s1 + s2;
}

static int
pressure_skip_call_before(p, q, a, b, c, d, e, f)
int *p;
int *q;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  sink_int(s0 + s1 + s2);

  x = *p;
  if (x != 0)
    return x + s0 + s2;

  return *q + s1 + s2;
}

static int
pressure_skip_nested(p, q, r, a, b, c, d, e, f)
int *p;
int *q;
int *r;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int s0;
  int s1;
  int s2;
  int x;
  int y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  x = *p;
  if (x != 0) {
    y = *q;
    if (y < 0)
      return x - y + s0 + s2;
    return x + y + s1 + s2;
  }

  return *r + s0 + s1;
}

static int
pressure_skip_loop(v, n, a, b, c, d, e, f)
int *v;
int n;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int i;
  int s0;
  int s1;
  int s2;
  int acc;
  int x;

  OPAQUE_REG(n);
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;
  acc = 0;

  for (i = 0; i < n; ++i) {
    x = v[i & 017];
    if (x != 0)
      acc += x + s0;
    else
      acc += s1;
  }

  return acc + s0 + s1 + s2;
}

static int
pressure_skip_loop_store(v, n, a, b, c, d, e, f)
int *v;
int n;
int a;
int b;
int c;
int d;
int e;
int f;
{
  int i;
  int s0;
  int s1;
  int s2;
  int x;

  OPAQUE_REG(n);
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = a + b;
  s1 = c + d;
  s2 = e + f;

  for (i = 0; i < n; ++i) {
    x = v[i & 017];
    if (x == 0)
      v[i & 017] = s0;
    else
      v[i & 017] = x + s1;
  }

  return v[(n - 1) & 017] + s0 + s1 + s2;
}

/*
 * Smaller-mode controls.  These may require byte/halfword load before
 * the skip-like compare, but they still stress fixed scratch usage.
 */

static int
pressure_skip_qi(p, q, a, b, c, d)
Qint *p;
Qint *q;
int a;
int b;
int c;
int d;
{
  int s0;
  int s1;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  s0 = a + b;
  s1 = c + d;

  x = *p;
  if (x != 0)
    return x + s0;

  return *q + s1;
}

static int
pressure_skip_qi_signed(p, q, a, b, c, d)
Qint *p;
Qint *q;
int a;
int b;
int c;
int d;
{
  int s0;
  int s1;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  s0 = a - b;
  s1 = c - d;

  x = *p;
  if (x < 0)
    return s0 - x;

  return s1 + *q;
}

static int
pressure_skip_hi(p, q, a, b, c, d)
Hint *p;
Hint *q;
int a;
int b;
int c;
int d;
{
  int s0;
  int s1;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  s0 = a + b;
  s1 = c + d;

  x = *p;
  if (x != 0)
    return x + s0;

  return *q + s1;
}

static int
pressure_skip_hi_signed(p, q, a, b, c, d)
Hint *p;
Hint *q;
int a;
int b;
int c;
int d;
{
  int s0;
  int s1;
  int x;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  s0 = a - b;
  s1 = c - d;

  x = *p;
  if (x < 0)
    return s0 - x;

  return s1 + *q;
}
