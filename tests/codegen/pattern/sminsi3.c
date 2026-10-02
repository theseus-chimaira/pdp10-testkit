#include "insns.h"


/*
 * Signed SImode minimum pattern pressure.
 *
 * Intended pattern:
 *   sminsi3
 *
 * Ordinary C shape:
 *
 *   return x < y ? x : y;
 *
 * Keep this file signed-only.  Unsigned minimum belongs to uminsi3.c.
 * Do not use inline assembly here.
 */

static Sint smin_ga;
static Sint smin_gb;
static volatile Sint smin_vga;
static Sint smin_buf[16];

struct smin_pair {
  Sint a;
  Sint b;
};

struct smin_trip {
  Sint a;
  Sint b;
  Sint c;
};

static struct smin_pair smin_gp;
static struct smin_trip smin_gtrip;

/*
 * Basic two-register signed minimum forms.
 */

static Sint
smin(x, y)
Sint x;
Sint y;
{
  return y < x ? y : x;
}

static Sint
smin_commuted(x, y)
Sint x;
Sint y;
{
  return x < y ? x : y;
}

static Sint
smin_if(x, y)
Sint x;
Sint y;
{
  if (x < y)
    return x;
  return y;
}

static Sint
smin_if_commuted(x, y)
Sint x;
Sint y;
{
  if (y < x)
    return y;
  return x;
}

static Sint
smin_le(x, y)
Sint x;
Sint y;
{
  return x <= y ? x : y;
}

static Sint
smin_le_commuted(x, y)
Sint x;
Sint y;
{
  return y <= x ? y : x;
}

static Sint
smin_gt(x, y)
Sint x;
Sint y;
{
  return x > y ? y : x;
}

static Sint
smin_gt_commuted(x, y)
Sint x;
Sint y;
{
  return y > x ? x : y;
}

static Sint
smin_ge(x, y)
Sint x;
Sint y;
{
  return x >= y ? y : x;
}

static Sint
smin_ge_commuted(x, y)
Sint x;
Sint y;
{
  return y >= x ? x : y;
}

/*
 * Constants.
 */

static Sint
smin_zero(x)
Sint x;
{
  return x < 0 ? x : 0;
}

static Sint
smin_zero_commuted(x)
Sint x;
{
  return 0 < x ? 0 : x;
}

static Sint
smin_one(x)
Sint x;
{
  return x < 1 ? x : 1;
}

static Sint
smin_minus_one(x)
Sint x;
{
  return x < -1 ? x : -1;
}

static Sint
smin_small_positive(x)
Sint x;
{
  return x < 0123 ? x : 0123;
}

static Sint
smin_small_negative(x)
Sint x;
{
  return x < -0123 ? x : -0123;
}

static Sint
smin_large_positive(x)
Sint x;
{
  return x < 0123456 ? x : 0123456;
}

static Sint
smin_large_negative(x)
Sint x;
{
  return x < -0123456 ? x : -0123456;
}

static Sint
smin_const_left(x)
Sint x;
{
  return 0123456 < x ? 0123456 : x;
}

static Sint
smin_const_negative_left(x)
Sint x;
{
  return -0123456 < x ? -0123456 : x;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
smin_mem(x, p)
Sint x;
Sint *p;
{
  return x < *p ? x : *p;
}

static Sint
smin_mem_commuted(x, p)
Sint x;
Sint *p;
{
  return *p < x ? *p : x;
}

static Sint
smin_mem_mem(p, q)
Sint *p;
Sint *q;
{
  return *p < *q ? *p : *q;
}

static Sint
smin_global(x)
Sint x;
{
  return x < smin_ga ? x : smin_ga;
}

static Sint
smin_global_commuted(x)
Sint x;
{
  return smin_ga < x ? smin_ga : x;
}

static Sint
smin_global_global()
{
  return smin_ga < smin_gb ? smin_ga : smin_gb;
}

static Sint
smin_volatile_global(x)
Sint x;
{
  Sint v;

  v = smin_vga;
  return x < v ? x : v;
}

static Sint
smin_volatile_mem(x, p)
Sint x;
volatile Sint *p;
{
  Sint v;

  v = *p;
  return x < v ? x : v;
}

static Sint
smin_array(v, i, x)
Sint *v;
Sint i;
Sint x;
{
  return x < v[i & 017] ? x : v[i & 017];
}

static Sint
smin_array_commuted(v, i, x)
Sint *v;
Sint i;
Sint x;
{
  return v[i & 017] < x ? v[i & 017] : x;
}

static Sint
smin_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  return v[i & 017] < v[j & 017] ? v[i & 017] : v[j & 017];
}

static Sint
smin_global_array(i, x)
Sint i;
Sint x;
{
  return x < smin_buf[i & 017] ? x : smin_buf[i & 017];
}

static Sint
smin_global_array_array(i, j)
Sint i;
Sint j;
{
  return smin_buf[i & 017] < smin_buf[j & 017]
       ? smin_buf[i & 017]
       : smin_buf[j & 017];
}

static Sint
smin_struct_a(p, x)
struct smin_pair *p;
Sint x;
{
  return x < p->a ? x : p->a;
}

static Sint
smin_struct_b(p, x)
struct smin_pair *p;
Sint x;
{
  return p->b < x ? p->b : x;
}

static Sint
smin_struct_ab(p)
struct smin_pair *p;
{
  return p->a < p->b ? p->a : p->b;
}

static Sint
smin_trip_ab(p)
struct smin_trip *p;
{
  return p->a < p->b ? p->a : p->b;
}

static Sint
smin_trip_abc(p)
struct smin_trip *p;
{
  Sint t;

  t = p->a < p->b ? p->a : p->b;
  return t < p->c ? t : p->c;
}

static Sint
smin_global_struct()
{
  return smin_gp.a < smin_gp.b ? smin_gp.a : smin_gp.b;
}

static Sint
smin_global_trip()
{
  Sint t;

  t = smin_gtrip.a < smin_gtrip.b ? smin_gtrip.a : smin_gtrip.b;
  return t < smin_gtrip.c ? t : smin_gtrip.c;
}

/*
 * Store the signed minimum.
 */

static void
smin_store(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  *out = x < y ? x : y;
}

static Sint
smin_store_return(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  Sint t;

  t = x < y ? x : y;
  *out = t;
  return t;
}

static void
smin_store_global(x, y)
Sint x;
Sint y;
{
  smin_ga = x < y ? x : y;
}

static void
smin_store_array(v, i, x, y)
Sint *v;
Sint i;
Sint x;
Sint y;
{
  v[i & 017] = x < y ? x : y;
}

static void
smin_store_struct_a(p, x, y)
struct smin_pair *p;
Sint x;
Sint y;
{
  p->a = x < y ? x : y;
}

static Sint
smin_store_then_use(out, x, y, z)
Sint *out;
Sint x;
Sint y;
Sint z;
{
  Sint t;

  t = x < y ? x : y;
  *out = t;
  return t + z;
}

/*
 * Result consumed by arithmetic/logical expressions.
 */

static Sint
smin_add(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x < y ? x : y) + z;
}

static Sint
smin_sub(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x < y ? x : y) - z;
}

static Sint
smin_xor(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x < y ? x : y) ^ z;
}

static Sint
smin_or(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x < y ? x : y) | z;
}

static Sint
smin_and(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x < y ? x : y) & z;
}

static Sint
smin_mul(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x < y ? x : y) * z;
}

static Sint
smin_nested_add(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint x;
  Sint y;

  x = a < b ? a : b;
  y = c < d ? c : d;
  return x + y;
}

static Sint
smin_nested_min(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint t;

  t = a < b ? a : b;
  return t < c ? t : c;
}

static Sint
smin_nested_min4(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint t;
  Sint u;

  t = a < b ? a : b;
  u = c < d ? c : d;
  return t < u ? t : u;
}

/*
 * Local temporaries and source-liveness pressure.
 */

static Sint
smin_local(x, y)
Sint x;
Sint y;
{
  Sint t;

  t = x < y ? x : y;
  return t;
}

static Sint
smin_local_sources_live(x, y, z)
Sint x;
Sint y;
Sint z;
{
  Sint t;

  t = x < y ? x : y;
  return t + x + y + z;
}

static Sint
smin_memory_sources_live(p, q, z)
Sint *p;
Sint *q;
Sint z;
{
  Sint x;
  Sint y;
  Sint t;

  x = *p;
  y = *q;
  t = x < y ? x : y;
  return t + x + y + z;
}

static Sint
smin_reuse_left(x, y)
Sint x;
Sint y;
{
  x = x < y ? x : y;
  return x;
}

static Sint
smin_reuse_right(x, y)
Sint x;
Sint y;
{
  y = x < y ? x : y;
  return y;
}

/*
 * Branches based on the signed minimum result.
 */

static Sint
smin_if_result_zero(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x < y ? x : y;
  if (t == 0)
    return yes;
  return no;
}

static Sint
smin_if_result_nonzero(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x < y ? x : y;
  if (t != 0)
    return yes;
  return no;
}

static Sint
smin_if_result_negative(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x < y ? x : y;
  if (t < 0)
    return yes;
  return no;
}

static Sint
smin_if_result_positive(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x < y ? x : y;
  if (t > 0)
    return yes;
  return no;
}

static Sint
smin_likely(x, y)
Sint x;
Sint y;
{
  if (likely(x < y))
    return x;
  return y;
}

static Sint
smin_unlikely(x, y)
Sint x;
Sint y;
{
  if (unlikely(x < y))
    return x;
  return y;
}

/*
 * Conditional inputs and mixed control flow.
 */

static Sint
smin_after_if(flag, x, y)
Sint flag;
Sint x;
Sint y;
{
  if (flag)
    x -= 1;
  else
    y -= 1;

  return x < y ? x : y;
}

static Sint
smin_before_if(flag, x, y, z)
Sint flag;
Sint x;
Sint y;
Sint z;
{
  Sint t;

  t = x < y ? x : y;
  if (flag)
    return t + z;
  return t - z;
}

static Sint
smin_switch(a, b, c)
Sint a;
Sint b;
Sint c;
{
  switch (a & 3) {
  case 0:
    return a < b ? a : b;
  case 1:
    return b < c ? b : c;
  case 2:
    return a < c ? a : c;
  default:
    return a < 0 ? a : 0;
  }
}

/*
 * Loop pressure.
 */

static Sint
smin_loop_pair(v, n)
Sint *v;
Sint n;
{
  Sint best;
  Sint i;

  best = v[0];
  i = 1;
  while (i < n) {
    best = best < v[i & 017] ? best : v[i & 017];
    ++i;
  }

  return best;
}

static Sint
smin_loop_two_arrays(a, b, n)
Sint *a;
Sint *b;
Sint n;
{
  Sint best;
  Sint i;
  Sint t;

  best = a[0];
  i = 0;
  while (i < n) {
    t = a[i & 017] < b[i & 017] ? a[i & 017] : b[i & 017];
    best = best < t ? best : t;
    ++i;
  }

  return best;
}

static Sint
smin_loop_accumulate(x, y, n)
Sint x;
Sint y;
Sint n;
{
  Sint t;

  t = x;
  while (n-- > 0) {
    t = t < y ? t : y;
    y -= 1;
  }

  return t;
}

/*
 * Promoted small signed inputs.  These are secondary pressure only;
 * the main pattern is signed SImode.
 */

static Sint
smin_sqi(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = (Sint)a;
  y = (Sint)b;
  return x < y ? x : y;
}

static Sint
smin_sqi_si(a, y)
sQint a;
Sint y;
{
  Sint x;

  x = (Sint)a;
  return x < y ? x : y;
}

static Sint
smin_hi(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = (Sint)a;
  y = (Sint)b;
  return x < y ? x : y;
}

static Sint
smin_hi_si(a, y)
Hint a;
Sint y;
{
  Sint x;

  x = (Sint)a;
  return x < y ? x : y;
}

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

Sint
sminsi3_smoke(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint t;

  t = smin(a, b);
  t = smin_nested_min(t, b, c);
  return smin_add(t, c, a);
}

Sint
sn3mem(p, q, a)
Sint *p;
Sint *q;
Sint a;
{
  Sint t;

  t = smin_mem_mem(p, q);
  t = smin_store_return(p, t, a);
  return smin_memory_sources_live(p, q, t);
}

Sint
sn3ctl(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint t;

  t = smin_loop_pair(v, n);
  return smin_before_if(a, t, smin_ga, n);
}
