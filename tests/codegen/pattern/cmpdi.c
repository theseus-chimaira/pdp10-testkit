#include "insns.h"

/*
 * DImode comparison coverage.
 *
 * Lower priority for first DAIMON bring-up, but important as soon as
 * long long / Dint values become visible in userland, filesystems, or
 * counters.
 *
 * This is a pattern-level test for compare:DI lowering:
 *
 *   signed equality / inequality
 *   signed relational comparisons
 *   unsigned relational comparisons
 *   compare against zero
 *   compare against small and cross-word constants
 *   memory operands
 *   branch chains
 *   compare result used as an int value
 *
 * The default DAIMON direction is native PDP-10-style long long, not a
 * separate raw-72-bit semantic test.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern void sink_int();

static Dint cmpdi_ga;
static Dint cmpdi_gb;
static uDint cmpdi_uga;
static uDint cmpdi_ugb;

static Dint cmpdi_buf[16];
static uDint cmpdi_ubuf[16];

struct cmpdi_pair {
  Dint a;
  Dint b;
};

struct cmpdi_upair {
  uDint a;
  uDint b;
};

static struct cmpdi_pair cmpdi_gp;
static struct cmpdi_upair cmpdi_ugp;

static Dint
make_dint(hi, lo)
Sint hi;
uSint lo;
{
  Dint r;

  r = (Dint)hi;
  r = r << 36;
  r += (Dint)lo;
  return r;
}

static uDint
make_udint(hi, lo)
uSint hi;
uSint lo;
{
  uDint r;

  r = (uDint)hi;
  r = r << 36;
  r += (uDint)lo;
  return r;
}

static int
cmpdi_eq(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a == b;
}

static int
cmpdi_ne(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a != b;
}

static int
cmpdi_lt(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a < b;
}

static int
cmpdi_le(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a <= b;
}

static int
cmpdi_gt(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a > b;
}

static int
cmpdi_ge(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a >= b;
}

static int
cmpdi_ueq(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a == b;
}

static int
cmpdi_une(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a != b;
}

static int
cmpdi_ult(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a < b;
}

static int
cmpdi_ule(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a <= b;
}

static int
cmpdi_ugt(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a > b;
}

static int
cmpdi_uge(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a >= b;
}

static int
cmpdi_eq_zero(a)
Dint a;
{
  OPAQUE_REG(a);
  return a == 0;
}

static int
cmpdi_ne_zero(a)
Dint a;
{
  OPAQUE_REG(a);
  return a != 0;
}

static int
cmpdi_lt_zero(a)
Dint a;
{
  OPAQUE_REG(a);
  return a < 0;
}

static int
cmpdi_le_zero(a)
Dint a;
{
  OPAQUE_REG(a);
  return a <= 0;
}

static int
cmpdi_gt_zero(a)
Dint a;
{
  OPAQUE_REG(a);
  return a > 0;
}

static int
cmpdi_ge_zero(a)
Dint a;
{
  OPAQUE_REG(a);
  return a >= 0;
}

static int
cmpdi_ueq_zero(a)
uDint a;
{
  OPAQUE_REG(a);
  return a == 0;
}

static int
cmpdi_une_zero(a)
uDint a;
{
  OPAQUE_REG(a);
  return a != 0;
}

static int
cmpdi_ugt_zero(a)
uDint a;
{
  OPAQUE_REG(a);
  return a > 0;
}

static int
cmpdi_uge_zero(a)
uDint a;
{
  OPAQUE_REG(a);
  return a >= 0;
}

static int
cmpdi_eq_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a == (Dint)1;
}

static int
cmpdi_ne_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a != (Dint)1;
}

static int
cmpdi_lt_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a < (Dint)1;
}

static int
cmpdi_ge_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a >= (Dint)1;
}

static int
cmpdi_eq_minus_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a == (Dint)-1;
}

static int
cmpdi_lt_minus_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a < (Dint)-1;
}

static int
cmpdi_ge_minus_one(a)
Dint a;
{
  OPAQUE_REG(a);
  return a >= (Dint)-1;
}

static int
cmpdi_eq_low18(a)
Dint a;
{
  OPAQUE_REG(a);
  return a == (Dint)0777777;
}

static int
cmpdi_lt_low18(a)
Dint a;
{
  OPAQUE_REG(a);
  return a < (Dint)0777777;
}

static int
cmpdi_ge_low18(a)
Dint a;
{
  OPAQUE_REG(a);
  return a >= (Dint)0777777;
}

static int
cmpdi_eq_word_cross(a)
Dint a;
{
  Dint c;

  c = make_dint(1, 0);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a == c;
}

static int
cmpdi_lt_word_cross(a)
Dint a;
{
  Dint c;

  c = make_dint(1, 0);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a < c;
}

static int
cmpdi_ge_word_cross(a)
Dint a;
{
  Dint c;

  c = make_dint(1, 0);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a >= c;
}

static int
cmpdi_eq_large_const(a)
Dint a;
{
  Dint c;

  c = make_dint(0123456, 0654321);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a == c;
}

static int
cmpdi_lt_large_const(a)
Dint a;
{
  Dint c;

  c = make_dint(0123456, 0654321);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a < c;
}

static int
cmpdi_gt_large_const(a)
Dint a;
{
  Dint c;

  c = make_dint(0123456, 0654321);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a > c;
}

static int
cmpdi_ult_large_const(a)
uDint a;
{
  uDint c;

  c = make_udint(0123456, 0654321);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a < c;
}

static int
cmpdi_uge_large_const(a)
uDint a;
{
  uDint c;

  c = make_udint(0123456, 0654321);
  OPAQUE_REG(a);
  OPAQUE_REG(c);
  return a >= c;
}

static int
cmpdi_mem_eq(p, q)
Dint *p;
Dint *q;
{
  return *p == *q;
}

static int
cmpdi_mem_ne(p, q)
Dint *p;
Dint *q;
{
  return *p != *q;
}

static int
cmpdi_mem_lt(p, q)
Dint *p;
Dint *q;
{
  return *p < *q;
}

static int
cmpdi_mem_le(p, q)
Dint *p;
Dint *q;
{
  return *p <= *q;
}

static int
cmpdi_mem_gt(p, q)
Dint *p;
Dint *q;
{
  return *p > *q;
}

static int
cmpdi_mem_ge(p, q)
Dint *p;
Dint *q;
{
  return *p >= *q;
}

static int
cmpdi_umem_lt(p, q)
uDint *p;
uDint *q;
{
  return *p < *q;
}

static int
cmpdi_umem_le(p, q)
uDint *p;
uDint *q;
{
  return *p <= *q;
}

static int
cmpdi_umem_gt(p, q)
uDint *p;
uDint *q;
{
  return *p > *q;
}

static int
cmpdi_umem_ge(p, q)
uDint *p;
uDint *q;
{
  return *p >= *q;
}

static int
cmpdi_reg_mem_eq(a, p)
Dint a;
Dint *p;
{
  OPAQUE_REG(a);
  return a == *p;
}

static int
cmpdi_reg_mem_lt(a, p)
Dint a;
Dint *p;
{
  OPAQUE_REG(a);
  return a < *p;
}

static int
cmpdi_reg_mem_ge(a, p)
Dint a;
Dint *p;
{
  OPAQUE_REG(a);
  return a >= *p;
}

static int
cmpdi_mem_reg_lt(p, a)
Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  return *p < a;
}

static int
cmpdi_mem_reg_ge(p, a)
Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  return *p >= a;
}

static int
cmpdi_volatile_eq(p, q)
volatile Dint *p;
volatile Dint *q;
{
  return *p == *q;
}

static int
cmpdi_volatile_lt(p, q)
volatile Dint *p;
volatile Dint *q;
{
  return *p < *q;
}

static int
cmpdi_volatile_ge(p, q)
volatile Dint *p;
volatile Dint *q;
{
  return *p >= *q;
}

static int
cmpdi_global_eq(a)
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_ga == a;
}

static int
cmpdi_global_lt(a)
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_ga < a;
}

static int
cmpdi_global_ge(a)
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_gb >= a;
}

static int
cmpdi_uglobal_lt(a)
uDint a;
{
  OPAQUE_REG(a);
  return cmpdi_uga < a;
}

static int
cmpdi_uglobal_ge(a)
uDint a;
{
  OPAQUE_REG(a);
  return cmpdi_ugb >= a;
}

static int
cmpdi_array_eq(v, i, a)
Dint *v;
Sint i;
Dint a;
{
  OPAQUE_REG(a);
  return v[i & 017] == a;
}

static int
cmpdi_array_lt(v, i, a)
Dint *v;
Sint i;
Dint a;
{
  OPAQUE_REG(a);
  return v[i & 017] < a;
}

static int
cmpdi_array_ge(v, i, a)
Dint *v;
Sint i;
Dint a;
{
  OPAQUE_REG(a);
  return v[i & 017] >= a;
}

static int
cmpdi_uarray_lt(v, i, a)
uDint *v;
Sint i;
uDint a;
{
  OPAQUE_REG(a);
  return v[i & 017] < a;
}

static int
cmpdi_uarray_ge(v, i, a)
uDint *v;
Sint i;
uDint a;
{
  OPAQUE_REG(a);
  return v[i & 017] >= a;
}

static int
cmpdi_global_array_eq(i, a)
Sint i;
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_buf[i & 017] == a;
}

static int
cmpdi_global_array_lt(i, a)
Sint i;
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_buf[i & 017] < a;
}

static int
cmpdi_global_uarray_lt(i, a)
Sint i;
uDint a;
{
  OPAQUE_REG(a);
  return cmpdi_ubuf[i & 017] < a;
}

static int
cmpdi_struct_eq(p, a)
struct cmpdi_pair *p;
Dint a;
{
  OPAQUE_REG(a);
  return p->a == a;
}

static int
cmpdi_struct_lt(p, a)
struct cmpdi_pair *p;
Dint a;
{
  OPAQUE_REG(a);
  return p->a < a;
}

static int
cmpdi_struct_ge(p, a)
struct cmpdi_pair *p;
Dint a;
{
  OPAQUE_REG(a);
  return p->b >= a;
}

static int
cmpdi_ustruct_lt(p, a)
struct cmpdi_upair *p;
uDint a;
{
  OPAQUE_REG(a);
  return p->a < a;
}

static int
cmpdi_ustruct_ge(p, a)
struct cmpdi_upair *p;
uDint a;
{
  OPAQUE_REG(a);
  return p->b >= a;
}

static int
cmpdi_global_struct_eq(a)
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_gp.a == a;
}

static int
cmpdi_global_struct_lt(a)
Dint a;
{
  OPAQUE_REG(a);
  return cmpdi_gp.a < a;
}

static int
cmpdi_global_ustruct_lt(a)
uDint a;
{
  OPAQUE_REG(a);
  return cmpdi_ugp.a < a;
}

static int
cmpdi_branch(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a < b)
    return x;
  if (a == b)
    return x + y;
  return y;
}

static int
cmpdi_branch_all(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a < b)
    return -1;
  if (a > b)
    return 1;
  return 0;
}

static int
cmpdi_branch_inverted(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (!(a >= b))
    return x;
  if (!(a != b))
    return x + y;
  return y;
}

static int
cmpdi_branch_zero(a, x, y)
Dint a;
int x;
int y;
{
  OPAQUE_REG(a);

  if (a < 0)
    return x;
  if (a == 0)
    return x + y;
  return y;
}

static int
cmpdi_branch_const(a, x, y)
Dint a;
int x;
int y;
{
  Dint c;

  c = make_dint(1, 0);
  OPAQUE_REG(a);
  OPAQUE_REG(c);

  if (a < c)
    return x;
  if (a == c)
    return x + y;
  return y;
}

static int
cmpdi_unsigned_branch(a, b, x, y)
uDint a;
uDint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a >= b)
    return x;
  return y;
}

static int
cmpdi_unsigned_branch_all(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a < b)
    return -1;
  if (a > b)
    return 1;
  return 0;
}

static int
cmpdi_unsigned_branch_inverted(a, b, x, y)
uDint a;
uDint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (!(a < b))
    return x;
  return y;
}

static int
cmpdi_select_eq(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return (a == b) ? x : y;
}

static int
cmpdi_select_ne(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return (a != b) ? x : y;
}

static int
cmpdi_select_lt(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return (a < b) ? x : y;
}

static int
cmpdi_select_ge(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return (a >= b) ? x : y;
}

static int
cmpdi_use_as_value_eq(a, b)
Dint a;
Dint b;
{
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  r = (a == b);
  return r + 1;
}

static int
cmpdi_use_as_value_lt(a, b)
Dint a;
Dint b;
{
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  r = (a < b);
  return r + 1;
}

static int
cmpdi_use_as_value_ult(a, b)
uDint a;
uDint b;
{
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  r = (a < b);
  return r + 1;
}

static int
cmpdi_and_condition(a, b, c, d)
Dint a;
Dint b;
Dint c;
Dint d;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  if (a < b && c != d)
    return 1;
  return 0;
}

static int
cmpdi_or_condition(a, b, c, d)
Dint a;
Dint b;
Dint c;
Dint d;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  if (a < b || c == d)
    return 1;
  return 0;
}

static int
cmpdi_mixed_signed_unsigned(a, b, c, d)
Dint a;
Dint b;
uDint c;
uDint d;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  if (a < b && c >= d)
    return 1;
  return 0;
}

static int
cmpdi_after_add(a, b, c)
Dint a;
Dint b;
Dint c;
{
  Dint x;

  x = a + b;
  OPAQUE_REG(x);
  OPAQUE_REG(c);

  return x < c;
}

static int
cmpdi_after_sub(a, b, c)
Dint a;
Dint b;
Dint c;
{
  Dint x;

  x = a - b;
  OPAQUE_REG(x);
  OPAQUE_REG(c);

  return x == c;
}

static int
cmpdi_after_shift(a, b)
Dint a;
Dint b;
{
  Dint x;

  x = a << 1;
  OPAQUE_REG(x);
  OPAQUE_REG(b);

  return x >= b;
}

static int
cmpdi_unsigned_after_shift(a, b)
uDint a;
uDint b;
{
  uDint x;

  x = a >> 1;
  OPAQUE_REG(x);
  OPAQUE_REG(b);

  return x < b;
}

static int
cmpdi_call_pressure(a, b)
Dint a;
Dint b;
{
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  r = a < b;
  sink_int(r);

  return r;
}

static int
cmpdi_branch_call_pressure(a, b, x, y)
Dint a;
Dint b;
int x;
int y;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a < b) {
    sink_int(x);
    return x;
  }

  sink_int(y);
  return y;
}

static int
cmpdi_loop_count_less(v, n, limit)
Dint *v;
int n;
Dint limit;
{
  int i;
  int c;

  OPAQUE_REG(limit);
  c = 0;

  for (i = 0; i < n; ++i)
    if (v[i & 017] < limit)
      ++c;

  return c;
}

static int
cmpdi_loop_find_eq(v, n, key)
Dint *v;
int n;
Dint key;
{
  int i;

  OPAQUE_REG(key);

  for (i = 0; i < n; ++i)
    if (v[i & 017] == key)
      return i;

  return -1;
}

static int
cmpdi_loop_find_ge(v, n, key)
Dint *v;
int n;
Dint key;
{
  int i;

  OPAQUE_REG(key);

  for (i = 0; i < n; ++i)
    if (v[i & 017] >= key)
      return i;

  return -1;
}

static int
cmpdi_unsigned_loop_count_less(v, n, limit)
uDint *v;
int n;
uDint limit;
{
  int i;
  int c;

  OPAQUE_REG(limit);
  c = 0;

  for (i = 0; i < n; ++i)
    if (v[i & 017] < limit)
      ++c;

  return c;
}

static int
cmpdi_unsigned_loop_find_ge(v, n, key)
uDint *v;
int n;
uDint key;
{
  int i;

  OPAQUE_REG(key);

  for (i = 0; i < n; ++i)
    if (v[i & 017] >= key)
      return i;

  return -1;
}

static int
cmpdi_struct_loop_count(p, n, key)
struct cmpdi_pair *p;
int n;
Dint key;
{
  int i;
  int c;

  OPAQUE_REG(key);
  c = 0;

  for (i = 0; i < n; ++i)
    if (p[i & 017].a == key)
      ++c;

  return c;
}

static int
cmpdi_compare_then_store(a, b, out)
Dint a;
Dint b;
int *out;
{
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a < b)
    r = -1;
  else if (a > b)
    r = 1;
  else
    r = 0;

  *out = r;
  return r;
}

static int
cmpdi_compare_then_update(a, b, p)
Dint a;
Dint b;
int *p;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (a == b)
    *p += 1;
  else
    *p -= 1;

  return *p;
}

/*
 * Original skeleton names, kept intact.
 */

static int
cmpdi_eq_orig(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a == b;
}

static int
cmpdi_ne_orig(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a != b;
}

static int
cmpdi_lt_orig(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a < b;
}

static int
cmpdi_le_orig(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a <= b;
}

static int
cmpdi_gt_orig(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a > b;
}

static int
cmpdi_ge_orig(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a >= b;
}

static int
cmpdi_ult_orig(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a < b;
}

static int
cmpdi_ule_orig(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a <= b;
}

static int
cmpdi_ugt_orig(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a > b;
}

static int
cmpdi_uge_orig(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return a >= b;
}
