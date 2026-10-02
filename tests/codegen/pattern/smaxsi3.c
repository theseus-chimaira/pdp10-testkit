#include "insns.h"


/*
 * Signed SImode maximum pattern pressure.
 *
 * Intended pattern:
 *   smaxsi3
 *
 * Ordinary C shape:
 *
 *   return x > y ? x : y;
 *
 * Keep this file signed-only.  Unsigned maximum belongs to umaxsi3.c.
 * Do not use inline assembly here.
 */

static Sint smax_ga;
static Sint smax_gb;
static volatile Sint smax_vga;
static Sint smax_buf[16];

struct smax_pair {
  Sint a;
  Sint b;
};

struct smax_trip {
  Sint a;
  Sint b;
  Sint c;
};

static struct smax_pair smax_gp;
static struct smax_trip smax_gt;

/*
 * Basic two-register signed maximum forms.
 */

static Sint
smax(x, y)
Sint x;
Sint y;
{
  return y > x ? y : x;
}

static Sint
smax_commuted(x, y)
Sint x;
Sint y;
{
  return x > y ? x : y;
}

static Sint
smax_if(x, y)
Sint x;
Sint y;
{
  if (x > y)
    return x;
  return y;
}

static Sint
smax_if_commuted(x, y)
Sint x;
Sint y;
{
  if (y > x)
    return y;
  return x;
}

static Sint
smax_ge(x, y)
Sint x;
Sint y;
{
  return x >= y ? x : y;
}

static Sint
smax_ge_commuted(x, y)
Sint x;
Sint y;
{
  return y >= x ? y : x;
}

static Sint
smax_lt(x, y)
Sint x;
Sint y;
{
  return x < y ? y : x;
}

static Sint
smax_lt_commuted(x, y)
Sint x;
Sint y;
{
  return y < x ? x : y;
}

static Sint
smax_le(x, y)
Sint x;
Sint y;
{
  return x <= y ? y : x;
}

static Sint
smax_le_commuted(x, y)
Sint x;
Sint y;
{
  return y <= x ? x : y;
}

/*
 * Constants.
 */

static Sint
smax_zero(x)
Sint x;
{
  return x > 0 ? x : 0;
}

static Sint
smax_zero_commuted(x)
Sint x;
{
  return 0 > x ? 0 : x;
}

static Sint
smax_one(x)
Sint x;
{
  return x > 1 ? x : 1;
}

static Sint
smax_minus_one(x)
Sint x;
{
  return x > -1 ? x : -1;
}

static Sint
smax_small_positive(x)
Sint x;
{
  return x > 0123 ? x : 0123;
}

static Sint
smax_small_negative(x)
Sint x;
{
  return x > -0123 ? x : -0123;
}

static Sint
smax_large_positive(x)
Sint x;
{
  return x > 0123456 ? x : 0123456;
}

static Sint
smax_large_negative(x)
Sint x;
{
  return x > -0123456 ? x : -0123456;
}

static Sint
smax_const_left(x)
Sint x;
{
  return 0123456 > x ? 0123456 : x;
}

static Sint
smax_const_negative_left(x)
Sint x;
{
  return -0123456 > x ? -0123456 : x;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
smax_mem(x, p)
Sint x;
Sint *p;
{
  return x > *p ? x : *p;
}

static Sint
smax_mem_commuted(x, p)
Sint x;
Sint *p;
{
  return *p > x ? *p : x;
}

static Sint
smax_mem_mem(p, q)
Sint *p;
Sint *q;
{
  return *p > *q ? *p : *q;
}

static Sint
smax_global(x)
Sint x;
{
  return x > smax_ga ? x : smax_ga;
}

static Sint
smax_global_commuted(x)
Sint x;
{
  return smax_ga > x ? smax_ga : x;
}

static Sint
smax_global_global()
{
  return smax_ga > smax_gb ? smax_ga : smax_gb;
}

static Sint
smax_volatile_global(x)
Sint x;
{
  Sint v;

  v = smax_vga;
  return x > v ? x : v;
}

static Sint
smax_volatile_mem(x, p)
Sint x;
volatile Sint *p;
{
  Sint v;

  v = *p;
  return x > v ? x : v;
}

static Sint
smax_array(v, i, x)
Sint *v;
Sint i;
Sint x;
{
  return x > v[i & 017] ? x : v[i & 017];
}

static Sint
smax_array_commuted(v, i, x)
Sint *v;
Sint i;
Sint x;
{
  return v[i & 017] > x ? v[i & 017] : x;
}

static Sint
smax_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  return v[i & 017] > v[j & 017] ? v[i & 017] : v[j & 017];
}

static Sint
smax_global_array(i, x)
Sint i;
Sint x;
{
  return x > smax_buf[i & 017] ? x : smax_buf[i & 017];
}

static Sint
smax_global_array_array(i, j)
Sint i;
Sint j;
{
  return smax_buf[i & 017] > smax_buf[j & 017]
       ? smax_buf[i & 017]
       : smax_buf[j & 017];
}

static Sint
smax_struct_a(p, x)
struct smax_pair *p;
Sint x;
{
  return x > p->a ? x : p->a;
}

static Sint
smax_struct_b(p, x)
struct smax_pair *p;
Sint x;
{
  return p->b > x ? p->b : x;
}

static Sint
smax_struct_ab(p)
struct smax_pair *p;
{
  return p->a > p->b ? p->a : p->b;
}

static Sint
smax_trip_ab(p)
struct smax_trip *p;
{
  return p->a > p->b ? p->a : p->b;
}

static Sint
smax_trip_abc(p)
struct smax_trip *p;
{
  Sint t;

  t = p->a > p->b ? p->a : p->b;
  return t > p->c ? t : p->c;
}

static Sint
smax_global_struct()
{
  return smax_gp.a > smax_gp.b ? smax_gp.a : smax_gp.b;
}

static Sint
smax_global_trip()
{
  Sint t;

  t = smax_gt.a > smax_gt.b ? smax_gt.a : smax_gt.b;
  return t > smax_gt.c ? t : smax_gt.c;
}

/*
 * Store the signed maximum.
 */

static void
smax_store(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  *out = x > y ? x : y;
}

static Sint
smax_store_return(out, x, y)
Sint *out;
Sint x;
Sint y;
{
  Sint t;

  t = x > y ? x : y;
  *out = t;
  return t;
}

static void
smax_store_global(x, y)
Sint x;
Sint y;
{
  smax_ga = x > y ? x : y;
}

static void
smax_store_array(v, i, x, y)
Sint *v;
Sint i;
Sint x;
Sint y;
{
  v[i & 017] = x > y ? x : y;
}

static void
smax_store_struct_a(p, x, y)
struct smax_pair *p;
Sint x;
Sint y;
{
  p->a = x > y ? x : y;
}

static Sint
smax_store_then_use(out, x, y, z)
Sint *out;
Sint x;
Sint y;
Sint z;
{
  Sint t;

  t = x > y ? x : y;
  *out = t;
  return t + z;
}

/*
 * Result consumed by arithmetic/logical expressions.
 */

static Sint
smax_add(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x > y ? x : y) + z;
}

static Sint
smax_sub(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x > y ? x : y) - z;
}

static Sint
smax_xor(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x > y ? x : y) ^ z;
}

static Sint
smax_or(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x > y ? x : y) | z;
}

static Sint
smax_and(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x > y ? x : y) & z;
}

static Sint
smax_mul(x, y, z)
Sint x;
Sint y;
Sint z;
{
  return (x > y ? x : y) * z;
}

static Sint
smax_nested_add(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint x;
  Sint y;

  x = a > b ? a : b;
  y = c > d ? c : d;
  return x + y;
}

static Sint
smax_nested_max(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint t;

  t = a > b ? a : b;
  return t > c ? t : c;
}

static Sint
smax_nested_max4(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint t;
  Sint u;

  t = a > b ? a : b;
  u = c > d ? c : d;
  return t > u ? t : u;
}

/*
 * Local temporaries and source-liveness pressure.
 */

static Sint
smax_local(x, y)
Sint x;
Sint y;
{
  Sint t;

  t = x > y ? x : y;
  return t;
}

static Sint
smax_local_sources_live(x, y, z)
Sint x;
Sint y;
Sint z;
{
  Sint t;

  t = x > y ? x : y;
  return t + x + y + z;
}

static Sint
smax_memory_sources_live(p, q, z)
Sint *p;
Sint *q;
Sint z;
{
  Sint x;
  Sint y;
  Sint t;

  x = *p;
  y = *q;
  t = x > y ? x : y;
  return t + x + y + z;
}

static Sint
smax_reuse_left(x, y)
Sint x;
Sint y;
{
  x = x > y ? x : y;
  return x;
}

static Sint
smax_reuse_right(x, y)
Sint x;
Sint y;
{
  y = x > y ? x : y;
  return y;
}

/*
 * Branches based on the signed maximum result.
 */

static Sint
smax_if_result_zero(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x > y ? x : y;
  if (t == 0)
    return yes;
  return no;
}

static Sint
smax_if_result_nonzero(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x > y ? x : y;
  if (t != 0)
    return yes;
  return no;
}

static Sint
smax_if_result_negative(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x > y ? x : y;
  if (t < 0)
    return yes;
  return no;
}

static Sint
smax_if_result_positive(x, y, yes, no)
Sint x;
Sint y;
Sint yes;
Sint no;
{
  Sint t;

  t = x > y ? x : y;
  if (t > 0)
    return yes;
  return no;
}

static Sint
smax_likely(x, y)
Sint x;
Sint y;
{
  if (likely(x > y))
    return x;
  return y;
}

static Sint
smax_unlikely(x, y)
Sint x;
Sint y;
{
  if (unlikely(x > y))
    return x;
  return y;
}

/*
 * Conditional inputs and mixed control flow.
 */

static Sint
smax_after_if(flag, x, y)
Sint flag;
Sint x;
Sint y;
{
  if (flag)
    x += 1;
  else
    y += 1;

  return x > y ? x : y;
}

static Sint
smax_before_if(flag, x, y, z)
Sint flag;
Sint x;
Sint y;
Sint z;
{
  Sint t;

  t = x > y ? x : y;
  if (flag)
    return t + z;
  return t - z;
}

static Sint
smax_switch(a, b, c)
Sint a;
Sint b;
Sint c;
{
  switch (a & 3) {
  case 0:
    return a > b ? a : b;
  case 1:
    return b > c ? b : c;
  case 2:
    return a > c ? a : c;
  default:
    return a > 0 ? a : 0;
  }
}

/*
 * Loop pressure.
 */

static Sint
smax_loop_pair(v, n)
Sint *v;
Sint n;
{
  Sint best;
  Sint i;

  best = v[0];
  i = 1;
  while (i < n) {
    best = best > v[i & 017] ? best : v[i & 017];
    ++i;
  }

  return best;
}

static Sint
smax_loop_two_arrays(a, b, n)
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
    t = a[i & 017] > b[i & 017] ? a[i & 017] : b[i & 017];
    best = best > t ? best : t;
    ++i;
  }

  return best;
}

static Sint
smax_loop_accumulate(x, y, n)
Sint x;
Sint y;
Sint n;
{
  Sint t;

  t = x;
  while (n-- > 0) {
    t = t > y ? t : y;
    y += 1;
  }

  return t;
}

/*
 * Promoted small signed inputs.  These are secondary pressure only;
 * the main pattern is signed SImode.
 */

static Sint
smax_sqi(a, b)
sQint a;
sQint b;
{
  Sint x;
  Sint y;

  x = (Sint)a;
  y = (Sint)b;
  return x > y ? x : y;
}

static Sint
smax_sqi_si(a, y)
sQint a;
Sint y;
{
  Sint x;

  x = (Sint)a;
  return x > y ? x : y;
}

static Sint
smax_hi(a, b)
Hint a;
Hint b;
{
  Sint x;
  Sint y;

  x = (Sint)a;
  y = (Sint)b;
  return x > y ? x : y;
}

static Sint
smax_hi_si(a, y)
Hint a;
Sint y;
{
  Sint x;

  x = (Sint)a;
  return x > y ? x : y;
}

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

Sint
smaxsi3_smoke(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint t;

  t = smax(a, b);
  t = smax_nested_max(t, b, c);
  return smax_add(t, c, a);
}

Sint
sx3mem(p, q, a)
Sint *p;
Sint *q;
Sint a;
{
  Sint t;

  t = smax_mem_mem(p, q);
  t = smax_store_return(p, t, a);
  return smax_memory_sources_live(p, q, t);
}

Sint
sx3ctl(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint t;

  t = smax_loop_pair(v, n);
  return smax_before_if(a, t, smax_ga, n);
}
