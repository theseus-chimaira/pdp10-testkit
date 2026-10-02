#include "insns.h"


/*
 * Unsigned SImode maximum pattern pressure.
 *
 * Intended pattern:
 *   umaxsi3
 *
 * Ordinary C shape:
 *
 *   return x > y ? x : y;
 *
 * Keep this file unsigned-only.  Signed maximum belongs to smaxsi3.c.
 * Do not use inline assembly here.
 */

static uSint umax_ga;
static uSint umax_gb;
static volatile uSint umax_vga;
static uSint umax_buf[16];

struct umax_pair {
  uSint a;
  uSint b;
};

struct umax_trip {
  uSint a;
  uSint b;
  uSint c;
};

static struct umax_pair umax_gp;
static struct umax_trip umax_gt;

/*
 * Basic two-register unsigned maximum forms.
 */

static uSint
umax(x, y)
uSint x;
uSint y;
{
  return y > x ? y : x;
}

static uSint
umax_commuted(x, y)
uSint x;
uSint y;
{
  return x > y ? x : y;
}

static uSint
umax_if(x, y)
uSint x;
uSint y;
{
  if (x > y)
    return x;
  return y;
}

static uSint
umax_if_commuted(x, y)
uSint x;
uSint y;
{
  if (y > x)
    return y;
  return x;
}

static uSint
umax_ge(x, y)
uSint x;
uSint y;
{
  return x >= y ? x : y;
}

static uSint
umax_ge_commuted(x, y)
uSint x;
uSint y;
{
  return y >= x ? y : x;
}

static uSint
umax_lt(x, y)
uSint x;
uSint y;
{
  return x < y ? y : x;
}

static uSint
umax_lt_commuted(x, y)
uSint x;
uSint y;
{
  return y < x ? x : y;
}

static uSint
umax_le(x, y)
uSint x;
uSint y;
{
  return x <= y ? y : x;
}

static uSint
umax_le_commuted(x, y)
uSint x;
uSint y;
{
  return y <= x ? x : y;
}

/*
 * Constants.
 */

static uSint
umax_zero(x)
uSint x;
{
  return x > 0 ? x : 0;
}

static uSint
umax_zero_commuted(x)
uSint x;
{
  return 0 > x ? 0 : x;
}

static uSint
umax_one(x)
uSint x;
{
  return x > 1 ? x : 1;
}

static uSint
umax_small_positive(x)
uSint x;
{
  return x > 0123 ? x : 0123;
}

static uSint
umax_large_positive(x)
uSint x;
{
  return x > 0123456 ? x : 0123456;
}

static uSint
umax_right_half(x)
uSint x;
{
  return x > 0000000777777 ? x : 0000000777777;
}

static uSint
umax_left_half(x)
uSint x;
{
  return x > 0777777000000 ? x : 0777777000000;
}

static uSint
umax_high_bit(x)
uSint x;
{
  return x > 0400000000000 ? x : 0400000000000;
}

static uSint
umax_all_ones(x)
uSint x;
{
  return x > 0777777777777 ? x : 0777777777777;
}

static uSint
umax_const_left(x)
uSint x;
{
  return 0123456 > x ? 0123456 : x;
}

static uSint
umax_high_const_left(x)
uSint x;
{
  return 0400000000000 > x ? 0400000000000 : x;
}

static uSint
umax_all_ones_left(x)
uSint x;
{
  return 0777777777777 > x ? 0777777777777 : x;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static uSint
umax_mem(x, p)
uSint x;
uSint *p;
{
  return x > *p ? x : *p;
}

static uSint
umax_mem_commuted(x, p)
uSint x;
uSint *p;
{
  return *p > x ? *p : x;
}

static uSint
umax_mem_mem(p, q)
uSint *p;
uSint *q;
{
  return *p > *q ? *p : *q;
}

static uSint
umax_global(x)
uSint x;
{
  return x > umax_ga ? x : umax_ga;
}

static uSint
umax_global_commuted(x)
uSint x;
{
  return umax_ga > x ? umax_ga : x;
}

static uSint
umax_global_global()
{
  return umax_ga > umax_gb ? umax_ga : umax_gb;
}

static uSint
umax_volatile_global(x)
uSint x;
{
  uSint v;

  v = umax_vga;
  return x > v ? x : v;
}

static uSint
umax_volatile_mem(x, p)
uSint x;
volatile uSint *p;
{
  uSint v;

  v = *p;
  return x > v ? x : v;
}

static uSint
umax_array(v, i, x)
uSint *v;
Sint i;
uSint x;
{
  return x > v[i & 017] ? x : v[i & 017];
}

static uSint
umax_array_commuted(v, i, x)
uSint *v;
Sint i;
uSint x;
{
  return v[i & 017] > x ? v[i & 017] : x;
}

static uSint
umax_array_array(v, i, j)
uSint *v;
Sint i;
Sint j;
{
  return v[i & 017] > v[j & 017] ? v[i & 017] : v[j & 017];
}

static uSint
umax_global_array(i, x)
Sint i;
uSint x;
{
  return x > umax_buf[i & 017] ? x : umax_buf[i & 017];
}

static uSint
umax_global_array_array(i, j)
Sint i;
Sint j;
{
  return umax_buf[i & 017] > umax_buf[j & 017]
       ? umax_buf[i & 017]
       : umax_buf[j & 017];
}

static uSint
umax_struct_a(p, x)
struct umax_pair *p;
uSint x;
{
  return x > p->a ? x : p->a;
}

static uSint
umax_struct_b(p, x)
struct umax_pair *p;
uSint x;
{
  return p->b > x ? p->b : x;
}

static uSint
umax_struct_ab(p)
struct umax_pair *p;
{
  return p->a > p->b ? p->a : p->b;
}

static uSint
umax_trip_ab(p)
struct umax_trip *p;
{
  return p->a > p->b ? p->a : p->b;
}

static uSint
umax_trip_abc(p)
struct umax_trip *p;
{
  uSint t;

  t = p->a > p->b ? p->a : p->b;
  return t > p->c ? t : p->c;
}

static uSint
umax_global_struct()
{
  return umax_gp.a > umax_gp.b ? umax_gp.a : umax_gp.b;
}

static uSint
umax_global_trip()
{
  uSint t;

  t = umax_gt.a > umax_gt.b ? umax_gt.a : umax_gt.b;
  return t > umax_gt.c ? t : umax_gt.c;
}

/*
 * Store the unsigned maximum.
 */

static void
umax_store(out, x, y)
uSint *out;
uSint x;
uSint y;
{
  *out = x > y ? x : y;
}

static uSint
umax_store_return(out, x, y)
uSint *out;
uSint x;
uSint y;
{
  uSint t;

  t = x > y ? x : y;
  *out = t;
  return t;
}

static void
umax_store_global(x, y)
uSint x;
uSint y;
{
  umax_ga = x > y ? x : y;
}

static void
umax_store_array(v, i, x, y)
uSint *v;
Sint i;
uSint x;
uSint y;
{
  v[i & 017] = x > y ? x : y;
}

static void
umax_store_struct_a(p, x, y)
struct umax_pair *p;
uSint x;
uSint y;
{
  p->a = x > y ? x : y;
}

static uSint
umax_store_then_use(out, x, y, z)
uSint *out;
uSint x;
uSint y;
uSint z;
{
  uSint t;

  t = x > y ? x : y;
  *out = t;
  return t + z;
}

/*
 * Result consumed by arithmetic/logical expressions.
 */

static uSint
umax_add(x, y, z)
uSint x;
uSint y;
uSint z;
{
  return (x > y ? x : y) + z;
}

static uSint
umax_sub(x, y, z)
uSint x;
uSint y;
uSint z;
{
  return (x > y ? x : y) - z;
}

static uSint
umax_xor(x, y, z)
uSint x;
uSint y;
uSint z;
{
  return (x > y ? x : y) ^ z;
}

static uSint
umax_or(x, y, z)
uSint x;
uSint y;
uSint z;
{
  return (x > y ? x : y) | z;
}

static uSint
umax_and(x, y, z)
uSint x;
uSint y;
uSint z;
{
  return (x > y ? x : y) & z;
}

static uSint
umax_mul(x, y, z)
uSint x;
uSint y;
uSint z;
{
  return (x > y ? x : y) * z;
}

static uSint
umax_nested_add(a, b, c, d)
uSint a;
uSint b;
uSint c;
uSint d;
{
  uSint x;
  uSint y;

  x = a > b ? a : b;
  y = c > d ? c : d;
  return x + y;
}

static uSint
umax_nested_max(a, b, c)
uSint a;
uSint b;
uSint c;
{
  uSint t;

  t = a > b ? a : b;
  return t > c ? t : c;
}

static uSint
umax_nested_max4(a, b, c, d)
uSint a;
uSint b;
uSint c;
uSint d;
{
  uSint t;
  uSint u;

  t = a > b ? a : b;
  u = c > d ? c : d;
  return t > u ? t : u;
}

/*
 * Local temporaries and source-liveness pressure.
 */

static uSint
umax_local(x, y)
uSint x;
uSint y;
{
  uSint t;

  t = x > y ? x : y;
  return t;
}

static uSint
umax_local_sources_live(x, y, z)
uSint x;
uSint y;
uSint z;
{
  uSint t;

  t = x > y ? x : y;
  return t + x + y + z;
}

static uSint
umax_memory_sources_live(p, q, z)
uSint *p;
uSint *q;
uSint z;
{
  uSint x;
  uSint y;
  uSint t;

  x = *p;
  y = *q;
  t = x > y ? x : y;
  return t + x + y + z;
}

static uSint
umax_reuse_left(x, y)
uSint x;
uSint y;
{
  x = x > y ? x : y;
  return x;
}

static uSint
umax_reuse_right(x, y)
uSint x;
uSint y;
{
  y = x > y ? x : y;
  return y;
}

/*
 * Branches based on the unsigned maximum result.
 */

static uSint
umax_if_result_zero(x, y, yes, no)
uSint x;
uSint y;
uSint yes;
uSint no;
{
  uSint t;

  t = x > y ? x : y;
  if (t == 0)
    return yes;
  return no;
}

static uSint
umax_if_result_nonzero(x, y, yes, no)
uSint x;
uSint y;
uSint yes;
uSint no;
{
  uSint t;

  t = x > y ? x : y;
  if (t != 0)
    return yes;
  return no;
}

static uSint
umax_if_result_highbit(x, y, yes, no)
uSint x;
uSint y;
uSint yes;
uSint no;
{
  uSint t;

  t = x > y ? x : y;
  if (t & 0400000000000)
    return yes;
  return no;
}

static uSint
umax_if_result_right_nonzero(x, y, yes, no)
uSint x;
uSint y;
uSint yes;
uSint no;
{
  uSint t;

  t = x > y ? x : y;
  if (t & 0000000777777)
    return yes;
  return no;
}

static uSint
umax_likely(x, y)
uSint x;
uSint y;
{
  if (likely(x > y))
    return x;
  return y;
}

static uSint
umax_unlikely(x, y)
uSint x;
uSint y;
{
  if (unlikely(x > y))
    return x;
  return y;
}

/*
 * Conditional inputs and mixed control flow.
 */

static uSint
umax_after_if(flag, x, y)
Sint flag;
uSint x;
uSint y;
{
  if (flag)
    x += 1;
  else
    y += 1;

  return x > y ? x : y;
}

static uSint
umax_before_if(flag, x, y, z)
Sint flag;
uSint x;
uSint y;
uSint z;
{
  uSint t;

  t = x > y ? x : y;
  if (flag)
    return t + z;
  return t - z;
}

static uSint
umax_switch(a, b, c)
uSint a;
uSint b;
uSint c;
{
  switch (a & 3) {
  case 0:
    return a > b ? a : b;
  case 1:
    return b > c ? b : c;
  case 2:
    return a > c ? a : c;
  default:
    return a > 0400000000000 ? a : 0400000000000;
  }
}

/*
 * Loop pressure.
 */

static uSint
umax_loop_pair(v, n)
uSint *v;
Sint n;
{
  uSint best;
  Sint i;

  best = v[0];
  i = 1;
  while (i < n) {
    best = best > v[i & 017] ? best : v[i & 017];
    ++i;
  }

  return best;
}

static uSint
umax_loop_two_arrays(a, b, n)
uSint *a;
uSint *b;
Sint n;
{
  uSint best;
  Sint i;
  uSint t;

  best = a[0];
  i = 0;
  while (i < n) {
    t = a[i & 017] > b[i & 017] ? a[i & 017] : b[i & 017];
    best = best > t ? best : t;
    ++i;
  }

  return best;
}

static uSint
umax_loop_accumulate(x, y, n)
uSint x;
uSint y;
Sint n;
{
  uSint t;

  t = x;
  while (n-- > 0) {
    t = t > y ? t : y;
    y += 1;
  }

  return t;
}

/*
 * Promoted small unsigned inputs.  These are secondary pressure only;
 * the main pattern is unsigned SImode.
 */

static uSint
umax_uqi(a, b)
uQint a;
uQint b;
{
  uSint x;
  uSint y;

  x = (uSint)a;
  y = (uSint)b;
  return x > y ? x : y;
}

static uSint
umax_uqi_si(a, y)
uQint a;
uSint y;
{
  uSint x;

  x = (uSint)a;
  return x > y ? x : y;
}

static uSint
umax_uhi(a, b)
uHint a;
uHint b;
{
  uSint x;
  uSint y;

  x = (uSint)a;
  y = (uSint)b;
  return x > y ? x : y;
}

static uSint
umax_uhi_si(a, y)
uHint a;
uSint y;
{
  uSint x;

  x = (uSint)a;
  return x > y ? x : y;
}

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

uSint
umaxsi3_smoke(a, b, c)
uSint a;
uSint b;
uSint c;
{
  uSint t;

  t = umax(a, b);
  t = umax_nested_max(t, b, c);
  return umax_add(t, c, a);
}

uSint
ux3mem(p, q, a)
uSint *p;
uSint *q;
uSint a;
{
  uSint t;

  t = umax_mem_mem(p, q);
  t = umax_store_return(p, t, a);
  return umax_memory_sources_live(p, q, t);
}

uSint
ux3ctl(v, n, a)
uSint *v;
Sint n;
uSint a;
{
  uSint t;

  t = umax_loop_pair(v, n);
  return umax_before_if(a != 0, t, umax_ga, n);
}
