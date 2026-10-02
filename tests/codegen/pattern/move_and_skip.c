#include "insns.h"

/*
 * move_and_skip pattern coverage for PDP-6/166 and KA10.
 *
 * This is for the useful "load/move value and branch/skip based on
 * that same value" idiom:
 *
 *   v = *p;
 *   if (v == 0) ...
 *   if (v != 0) ...
 *   if (v >= 0) ...
 *   if (v <= 0) ...
 *   if (v > 0) ...
 *   if (v < 0) ...
 *
 * The raw SKIP instruction-family test belongs elsewhere.  This file
 * should keep natural C branch/select shapes visible.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static int move_skip_g0;
static int move_skip_g1;
static Sint move_skip_sg0;
static Sint move_skip_sg1;

static int move_skip_buf[16];
static Sint move_skip_sbuf[16];

struct move_skip_pair {
  int a;
  int b;
};

struct move_skip_spair {
  Sint a;
  Sint b;
};

static struct move_skip_pair move_skip_gp;
static struct move_skip_spair move_skip_sgp;

#define SKIP_LOCAL(name, cmp)                         \
static int                                            \
skip_local_##name(ac, x1, x2)                         \
int ac;                                               \
int *x1;                                              \
int *x2;                                              \
{                                                     \
  int v;                                              \
                                                      \
  OPAQUE_REG(ac);                                     \
  v = *x1;                                            \
  if (v cmp 0)                                        \
    return v + ac;                                    \
  return *x2 + ac;                                    \
}

#define SKIP_DIRECT(name, cmp)                        \
static int                                            \
skip_direct_##name(ac, x1, x2)                        \
int ac;                                               \
int *x1;                                              \
int *x2;                                              \
{                                                     \
  OPAQUE_REG(ac);                                     \
  return (*x1 cmp 0) ? *x1 + ac : *x2 + ac;           \
}

#define SKIP_UNLIKELY(name, cmp)                      \
static int                                            \
skip_unlikely_##name(ac, x1, x2)                      \
int ac;                                               \
int *x1;                                              \
int *x2;                                              \
{                                                     \
  int v;                                              \
                                                      \
  OPAQUE_REG(ac);                                     \
  v = *x1;                                            \
  return unlikely(v cmp 0) ? v + ac : *x2 + ac;       \
}

#define SKIP_LIKELY(name, cmp)                        \
static int                                            \
skip_likely_##name(ac, x1, x2)                        \
int ac;                                               \
int *x1;                                              \
int *x2;                                              \
{                                                     \
  int v;                                              \
                                                      \
  OPAQUE_REG(ac);                                     \
  v = *x1;                                            \
  return likely(v cmp 0) ? v + ac : *x2 + ac;         \
}

#define SKIP_ALL(name, cmp)                           \
SKIP_LOCAL(name, cmp)                                 \
SKIP_DIRECT(name, cmp)                                \
SKIP_UNLIKELY(name, cmp)                              \
SKIP_LIKELY(name, cmp)

SKIP_ALL(e, ==)
SKIP_ALL(n, !=)
SKIP_ALL(ge, >=)
SKIP_ALL(le, <=)
SKIP_ALL(g, >)
SKIP_ALL(l, <)

#define SSKIP_LOCAL(name, cmp)                        \
static Sint                                           \
sskip_local_##name(ac, x1, x2)                        \
Sint ac;                                              \
Sint *x1;                                             \
Sint *x2;                                             \
{                                                     \
  Sint v;                                             \
                                                      \
  OPAQUE_REG(ac);                                     \
  v = *x1;                                            \
  if (v cmp 0)                                        \
    return v + ac;                                    \
  return *x2 + ac;                                   \
}

SSKIP_LOCAL(e, ==)
SSKIP_LOCAL(n, !=)
SSKIP_LOCAL(ge, >=)
SSKIP_LOCAL(le, <=)
SSKIP_LOCAL(g, >)
SSKIP_LOCAL(l, <)

static int
skip_e(ac, x1, x2)
int ac;
int *x1;
int *x2;
{
  OPAQUE_REG(ac);
  return unlikely(*x1 == 0) ? *x1 + ac : *x2 + ac;
}

static int
skip_n(ac, x1, x2)
int ac;
int *x1;
int *x2;
{
  OPAQUE_REG(ac);
  return unlikely(*x1 != 0) ? *x1 + ac : *x2 + ac;
}

static int
skip_ge(ac, x1, x2)
int ac;
int *x1;
int *x2;
{
  OPAQUE_REG(ac);
  return unlikely(*x1 >= 0) ? *x1 + ac : *x2 + ac;
}

static int
skip_le(ac, x1, x2)
int ac;
int *x1;
int *x2;
{
  OPAQUE_REG(ac);
  return unlikely(*x1 <= 0) ? *x1 + ac : *x2 + ac;
}

static int
skip_g(ac, x1, x2)
int ac;
int *x1;
int *x2;
{
  OPAQUE_REG(ac);
  return unlikely(*x1 > 0) ? *x1 + ac : *x2 + ac;
}

static int
skip_l(ac, x1, x2)
int ac;
int *x1;
int *x2;
{
  OPAQUE_REG(ac);
  return unlikely(*x1 < 0) ? *x1 + ac : *x2 + ac;
}

static int
skip_e_plain(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v == 0)
    return v;
  return *x2;
}

static int
skip_n_plain(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v != 0)
    return v;
  return *x2;
}

static int
skip_ge_plain(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v >= 0)
    return v;
  return *x2;
}

static int
skip_le_plain(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v <= 0)
    return v;
  return *x2;
}

static int
skip_g_plain(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v > 0)
    return v;
  return *x2;
}

static int
skip_l_plain(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v < 0)
    return v;
  return *x2;
}

static int
skip_e_inverted(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v != 0)
    return *x2;
  return v;
}

static int
skip_n_inverted(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v == 0)
    return *x2;
  return v;
}

static int
skip_ge_inverted(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v < 0)
    return *x2;
  return v;
}

static int
skip_le_inverted(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v > 0)
    return *x2;
  return v;
}

static int
skip_g_inverted(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v <= 0)
    return *x2;
  return v;
}

static int
skip_l_inverted(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v >= 0)
    return *x2;
  return v;
}

static int
skip_e_goto(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v == 0)
    goto yes;
  return *x2;

yes:
  return v;
}

static int
skip_n_goto(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v != 0)
    goto yes;
  return *x2;

yes:
  return v;
}

static int
skip_ge_goto(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v >= 0)
    goto yes;
  return *x2;

yes:
  return v;
}

static int
skip_le_goto(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v <= 0)
    goto yes;
  return *x2;

yes:
  return v;
}

static int
skip_g_goto(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v > 0)
    goto yes;
  return *x2;

yes:
  return v;
}

static int
skip_l_goto(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v < 0)
    goto yes;
  return *x2;

yes:
  return v;
}

static int
skip_e_store(out, x1, x2)
int *out;
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v == 0)
    *out = v;
  else
    *out = *x2;

  return *out;
}

static int
skip_n_store(out, x1, x2)
int *out;
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v != 0)
    *out = v;
  else
    *out = *x2;

  return *out;
}

static int
skip_ge_store(out, x1, x2)
int *out;
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v >= 0)
    *out = v;
  else
    *out = *x2;

  return *out;
}

static int
skip_le_store(out, x1, x2)
int *out;
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v <= 0)
    *out = v;
  else
    *out = *x2;

  return *out;
}

static int
skip_g_store(out, x1, x2)
int *out;
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v > 0)
    *out = v;
  else
    *out = *x2;

  return *out;
}

static int
skip_l_store(out, x1, x2)
int *out;
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v < 0)
    *out = v;
  else
    *out = *x2;

  return *out;
}

static int
skip_e_global(void)
{
  int v;

  v = move_skip_g0;
  if (v == 0)
    return v;
  return move_skip_g1;
}

static int
skip_n_global(void)
{
  int v;

  v = move_skip_g0;
  if (v != 0)
    return v;
  return move_skip_g1;
}

static int
skip_ge_global(void)
{
  int v;

  v = move_skip_g0;
  if (v >= 0)
    return v;
  return move_skip_g1;
}

static int
skip_le_global(void)
{
  int v;

  v = move_skip_g0;
  if (v <= 0)
    return v;
  return move_skip_g1;
}

static int
skip_g_global(void)
{
  int v;

  v = move_skip_g0;
  if (v > 0)
    return v;
  return move_skip_g1;
}

static int
skip_l_global(void)
{
  int v;

  v = move_skip_g0;
  if (v < 0)
    return v;
  return move_skip_g1;
}

static Sint
sskip_e_global(void)
{
  Sint v;

  v = move_skip_sg0;
  if (v == 0)
    return v;
  return move_skip_sg1;
}

static Sint
sskip_l_global(void)
{
  Sint v;

  v = move_skip_sg0;
  if (v < 0)
    return v;
  return move_skip_sg1;
}

static int
skip_e_array(i)
int i;
{
  int v;

  i &= 017;
  v = move_skip_buf[i];

  if (v == 0)
    return v;
  return move_skip_buf[(i + 1) & 017];
}

static int
skip_n_array(i)
int i;
{
  int v;

  i &= 017;
  v = move_skip_buf[i];

  if (v != 0)
    return v;
  return move_skip_buf[(i + 1) & 017];
}

static int
skip_ge_array(i)
int i;
{
  int v;

  i &= 017;
  v = move_skip_buf[i];

  if (v >= 0)
    return v;
  return move_skip_buf[(i + 1) & 017];
}

static int
skip_le_array(i)
int i;
{
  int v;

  i &= 017;
  v = move_skip_buf[i];

  if (v <= 0)
    return v;
  return move_skip_buf[(i + 1) & 017];
}

static int
skip_g_array(i)
int i;
{
  int v;

  i &= 017;
  v = move_skip_buf[i];

  if (v > 0)
    return v;
  return move_skip_buf[(i + 1) & 017];
}

static int
skip_l_array(i)
int i;
{
  int v;

  i &= 017;
  v = move_skip_buf[i];

  if (v < 0)
    return v;
  return move_skip_buf[(i + 1) & 017];
}

static Sint
sskip_l_array(i)
Sint i;
{
  Sint v;

  i &= 017;
  v = move_skip_sbuf[i];

  if (v < 0)
    return v;
  return move_skip_sbuf[(i + 1) & 017];
}

static int
skip_e_struct(p)
struct move_skip_pair *p;
{
  int v;

  v = p->a;
  if (v == 0)
    return v;
  return p->b;
}

static int
skip_n_struct(p)
struct move_skip_pair *p;
{
  int v;

  v = p->a;
  if (v != 0)
    return v;
  return p->b;
}

static int
skip_ge_struct(p)
struct move_skip_pair *p;
{
  int v;

  v = p->a;
  if (v >= 0)
    return v;
  return p->b;
}

static int
skip_le_struct(p)
struct move_skip_pair *p;
{
  int v;

  v = p->a;
  if (v <= 0)
    return v;
  return p->b;
}

static int
skip_g_struct(p)
struct move_skip_pair *p;
{
  int v;

  v = p->a;
  if (v > 0)
    return v;
  return p->b;
}

static int
skip_l_struct(p)
struct move_skip_pair *p;
{
  int v;

  v = p->a;
  if (v < 0)
    return v;
  return p->b;
}

static int
skip_e_global_struct(void)
{
  int v;

  v = move_skip_gp.a;
  if (v == 0)
    return v;
  return move_skip_gp.b;
}

static int
skip_l_global_struct(void)
{
  int v;

  v = move_skip_gp.a;
  if (v < 0)
    return v;
  return move_skip_gp.b;
}

static Sint
sskip_l_global_struct(void)
{
  Sint v;

  v = move_skip_sgp.a;
  if (v < 0)
    return v;
  return move_skip_sgp.b;
}

static int
skip_e_volatile(p, q)
volatile int *p;
volatile int *q;
{
  int v;

  v = *p;
  if (v == 0)
    return v;
  return *q;
}

static int
skip_n_volatile(p, q)
volatile int *p;
volatile int *q;
{
  int v;

  v = *p;
  if (v != 0)
    return v;
  return *q;
}

static int
skip_l_volatile(p, q)
volatile int *p;
volatile int *q;
{
  int v;

  v = *p;
  if (v < 0)
    return v;
  return *q;
}

static int
skip_g_volatile(p, q)
volatile int *p;
volatile int *q;
{
  int v;

  v = *p;
  if (v > 0)
    return v;
  return *q;
}

static int
skip_e_then_add(x1, x2, add)
int *x1;
int *x2;
int add;
{
  int v;

  OPAQUE_REG(add);
  v = *x1;

  if (v == 0)
    return v + add;
  return *x2 + add;
}

static int
skip_n_then_sub(x1, x2, sub)
int *x1;
int *x2;
int sub;
{
  int v;

  OPAQUE_REG(sub);
  v = *x1;

  if (v != 0)
    return v - sub;
  return *x2 - sub;
}

static int
skip_l_then_neg(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v < 0)
    return -v;
  return -*x2;
}

static int
skip_g_then_inc(x1, x2)
int *x1;
int *x2;
{
  int v;

  v = *x1;
  if (v > 0)
    return v + 1;
  return *x2 + 1;
}

static int
skip_e_call_pressure(x1, x2)
int *x1;
int *x2;
{
  extern void clobber(void);
  int v;
  int r;

  v = *x1;
  if (v == 0)
    r = v;
  else
    r = *x2;

  clobber();
  return r;
}

static int
skip_n_call_pressure(x1, x2)
int *x1;
int *x2;
{
  extern void clobber(void);
  int v;
  int r;

  v = *x1;
  if (v != 0)
    r = v;
  else
    r = *x2;

  clobber();
  return r;
}

static int
skip_l_call_pressure(x1, x2)
int *x1;
int *x2;
{
  extern void clobber(void);
  int v;
  int r;

  v = *x1;
  if (v < 0)
    r = v;
  else
    r = *x2;

  clobber();
  return r;
}

static int
skip_loop_count_zero(v, n)
int *v;
int n;
{
  int i;
  int r;
  int x;

  r = 0;

  for (i = 0; i < n; ++i) {
    x = v[i & 017];
    if (x == 0)
      r += x;
    else
      r += 1;
  }

  return r;
}

static int
skip_loop_count_nonzero(v, n)
int *v;
int n;
{
  int i;
  int r;
  int x;

  r = 0;

  for (i = 0; i < n; ++i) {
    x = v[i & 017];
    if (x != 0)
      r += x;
    else
      r += 1;
  }

  return r;
}

static int
skip_loop_count_negative(v, n)
int *v;
int n;
{
  int i;
  int r;
  int x;

  r = 0;

  for (i = 0; i < n; ++i) {
    x = v[i & 017];
    if (x < 0)
      r += x;
    else
      r += 1;
  }

  return r;
}

static int
skip_loop_store(out, in, n)
int *out;
int *in;
int n;
{
  int i;
  int x;

  for (i = 0; i < n; ++i) {
    x = in[i & 017];
    if (x == 0)
      out[i & 017] = x;
    else
      out[i & 017] = -1;
  }

  return out[(n - 1) & 017];
}

/*
 * Smaller-mode correctness controls.  These may lower through byte or
 * halfword loads before the skip/branch.
 */

static int
skip_qi_e(p, q)
Qint *p;
Qint *q;
{
  int v;

  v = *p;
  if (v == 0)
    return v;
  return *q;
}

static int
skip_qi_l(p, q)
Qint *p;
Qint *q;
{
  int v;

  v = *p;
  if (v < 0)
    return v;
  return *q;
}

static int
skip_hi_e(p, q)
Hint *p;
Hint *q;
{
  int v;

  v = *p;
  if (v == 0)
    return v;
  return *q;
}

static int
skip_hi_l(p, q)
Hint *p;
Hint *q;
{
  int v;

  v = *p;
  if (v < 0)
    return v;
  return *q;
}
