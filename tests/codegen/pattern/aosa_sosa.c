#include "insns.h"

/*
 * AOSA/SOSA peephole coverage.
 *
 * These are code-quality targets, not required semantic lowering.
 * Plain AOS/SOS plus JUMP/SKIP is still correct for early DAIMON.
 *
 * Source shapes covered here:
 *
 *   ++*p / --*p followed by compare against zero
 *   updated memory value used in either branch
 *   increment/decrement then return updated value
 *   pre/post increment forms
 *   global, array, struct, volatile memory destinations
 *
 * AOS.c/SOS.c cover the raw instruction families.  This file is about
 * branch/use peepholes around memory inc/dec.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static int aosa_gi;
static int sosa_gi;
static Sint aosa_gs;
static Sint sosa_gs;

static int aosa_buf[16];
static Sint aosa_sbuf[16];

struct aosa_pair {
  int a;
  int b;
};

struct aosa_spair {
  Sint a;
  Sint b;
};

static struct aosa_pair aosa_gp;
static struct aosa_spair aosa_gsp;

static int
inc_branch_eq(p, a, b)
int *p;
int a;
int b;
{
  if (++*p == 0)
    return a;
  return b + *p;
}

static int
inc_branch_ne(p, a, b)
int *p;
int a;
int b;
{
  if (++*p != 0)
    return a + *p;
  return b;
}

static int
inc_branch_gt(p, a, b)
int *p;
int a;
int b;
{
  if (++*p > 0)
    return a + *p;
  return b;
}

static int
inc_branch_ge(p, a, b)
int *p;
int a;
int b;
{
  if (++*p >= 0)
    return a + *p;
  return b;
}

static int
inc_branch_lt(p, a, b)
int *p;
int a;
int b;
{
  if (++*p < 0)
    return a + *p;
  return b;
}

static int
inc_branch_le(p, a, b)
int *p;
int a;
int b;
{
  if (++*p <= 0)
    return a + *p;
  return b;
}

static int
dec_branch_eq(p, a, b)
int *p;
int a;
int b;
{
  if (--*p == 0)
    return a;
  return b + *p;
}

static int
dec_branch_ne(p, a, b)
int *p;
int a;
int b;
{
  if (--*p != 0)
    return a + *p;
  return b;
}

static int
dec_branch_gt(p, a, b)
int *p;
int a;
int b;
{
  if (--*p > 0)
    return a + *p;
  return b;
}

static int
dec_branch_ge(p, a, b)
int *p;
int a;
int b;
{
  if (--*p >= 0)
    return a + *p;
  return b;
}

static int
dec_branch_lt(p, a, b)
int *p;
int a;
int b;
{
  if (--*p < 0)
    return a + *p;
  return b;
}

static int
dec_branch_le(p, a, b)
int *p;
int a;
int b;
{
  if (--*p <= 0)
    return a + *p;
  return b;
}

static int
inc_then_use(p)
int *p;
{
  ++*p;
  return *p;
}

static int
dec_then_use(p)
int *p;
{
  --*p;
  return *p;
}

static int
inc_then_use_plus(p, a)
int *p;
int a;
{
  ++*p;
  return *p + a;
}

static int
dec_then_use_plus(p, a)
int *p;
int a;
{
  --*p;
  return *p + a;
}

static void
inc_then_void(p)
int *p;
{
  ++*p;
}

static void
dec_then_void(p)
int *p;
{
  --*p;
}

static int
preinc_value(p)
int *p;
{
  int x;

  x = ++*p;
  return x;
}

static int
predec_value(p)
int *p;
{
  int x;

  x = --*p;
  return x;
}

static int
preinc_value_branch(p)
int *p;
{
  int x;

  x = ++*p;
  if (x == 0)
    return 1;
  return x;
}

static int
predec_value_branch(p)
int *p;
{
  int x;

  x = --*p;
  if (x == 0)
    return 1;
  return x;
}

static int
postinc_value(p)
int *p;
{
  int x;

  x = (*p)++;
  return x + *p;
}

static int
postdec_value(p)
int *p;
{
  int x;

  x = (*p)--;
  return x + *p;
}

static int
postinc_branch_old(p, a, b)
int *p;
int a;
int b;
{
  if ((*p)++ == 0)
    return a;
  return b + *p;
}

static int
postdec_branch_old(p, a, b)
int *p;
int a;
int b;
{
  if ((*p)-- == 0)
    return a;
  return b + *p;
}

static int
postinc_branch_new(p, a, b)
int *p;
int a;
int b;
{
  (*p)++;
  if (*p == 0)
    return a;
  return b + *p;
}

static int
postdec_branch_new(p, a, b)
int *p;
int a;
int b;
{
  (*p)--;
  if (*p == 0)
    return a;
  return b + *p;
}

static int
inc_goto_eq(p, a, b)
int *p;
int a;
int b;
{
  ++*p;
  if (*p == 0)
    goto yes;
  return b + *p;

yes:
  return a;
}

static int
dec_goto_eq(p, a, b)
int *p;
int a;
int b;
{
  --*p;
  if (*p == 0)
    goto yes;
  return b + *p;

yes:
  return a;
}

static int
inc_goto_gt(p, a, b)
int *p;
int a;
int b;
{
  ++*p;
  if (*p > 0)
    goto yes;
  return b;

yes:
  return a + *p;
}

static int
dec_goto_lt(p, a, b)
int *p;
int a;
int b;
{
  --*p;
  if (*p < 0)
    goto yes;
  return b;

yes:
  return a + *p;
}

static int
inc_branch_inverted_eq(p, a, b)
int *p;
int a;
int b;
{
  ++*p;
  if (*p != 0)
    goto no;
  return a;

no:
  return b + *p;
}

static int
dec_branch_inverted_eq(p, a, b)
int *p;
int a;
int b;
{
  --*p;
  if (*p != 0)
    goto no;
  return a;

no:
  return b + *p;
}

static int
inc_branch_inverted_gt(p, a, b)
int *p;
int a;
int b;
{
  ++*p;
  if (*p <= 0)
    goto no;
  return a + *p;

no:
  return b;
}

static int
dec_branch_inverted_lt(p, a, b)
int *p;
int a;
int b;
{
  --*p;
  if (*p >= 0)
    goto no;
  return a + *p;

no:
  return b;
}

static int
inc_global_eq(a, b)
int a;
int b;
{
  if (++aosa_gi == 0)
    return a;
  return b + aosa_gi;
}

static int
dec_global_eq(a, b)
int a;
int b;
{
  if (--sosa_gi == 0)
    return a;
  return b + sosa_gi;
}

static int
inc_global_gt(a, b)
int a;
int b;
{
  if (++aosa_gi > 0)
    return a + aosa_gi;
  return b;
}

static int
dec_global_lt(a, b)
int a;
int b;
{
  if (--sosa_gi < 0)
    return a + sosa_gi;
  return b;
}

static int
inc_global_then_use(void)
{
  ++aosa_gi;
  return aosa_gi;
}

static int
dec_global_then_use(void)
{
  --sosa_gi;
  return sosa_gi;
}

static Sint
inc_sint_branch_eq(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (++*p == 0)
    return a;
  return b + *p;
}

static Sint
dec_sint_branch_eq(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (--*p == 0)
    return a;
  return b + *p;
}

static Sint
inc_sint_branch_gt(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (++*p > 0)
    return a + *p;
  return b;
}

static Sint
dec_sint_branch_lt(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (--*p < 0)
    return a + *p;
  return b;
}

static Sint
inc_sint_global_eq(a, b)
Sint a;
Sint b;
{
  if (++aosa_gs == 0)
    return a;
  return b + aosa_gs;
}

static Sint
dec_sint_global_eq(a, b)
Sint a;
Sint b;
{
  if (--sosa_gs == 0)
    return a;
  return b + sosa_gs;
}

static int
inc_array_eq(v, i, a, b)
int *v;
int i;
int a;
int b;
{
  i &= 017;
  if (++v[i] == 0)
    return a;
  return b + v[i];
}

static int
dec_array_eq(v, i, a, b)
int *v;
int i;
int a;
int b;
{
  i &= 017;
  if (--v[i] == 0)
    return a;
  return b + v[i];
}

static int
inc_array_gt(v, i, a, b)
int *v;
int i;
int a;
int b;
{
  i &= 017;
  if (++v[i] > 0)
    return a + v[i];
  return b;
}

static int
dec_array_lt(v, i, a, b)
int *v;
int i;
int a;
int b;
{
  i &= 017;
  if (--v[i] < 0)
    return a + v[i];
  return b;
}

static int
inc_array_then_use(v, i)
int *v;
int i;
{
  i &= 017;
  ++v[i];
  return v[i];
}

static int
dec_array_then_use(v, i)
int *v;
int i;
{
  i &= 017;
  --v[i];
  return v[i];
}

static int
inc_global_array_eq(i, a, b)
int i;
int a;
int b;
{
  i &= 017;
  if (++aosa_buf[i] == 0)
    return a;
  return b + aosa_buf[i];
}

static int
dec_global_array_eq(i, a, b)
int i;
int a;
int b;
{
  i &= 017;
  if (--aosa_buf[i] == 0)
    return a;
  return b + aosa_buf[i];
}

static int
inc_struct_a_eq(p, a, b)
struct aosa_pair *p;
int a;
int b;
{
  if (++p->a == 0)
    return a;
  return b + p->a;
}

static int
dec_struct_a_eq(p, a, b)
struct aosa_pair *p;
int a;
int b;
{
  if (--p->a == 0)
    return a;
  return b + p->a;
}

static int
inc_struct_b_gt(p, a, b)
struct aosa_pair *p;
int a;
int b;
{
  if (++p->b > 0)
    return a + p->b;
  return b;
}

static int
dec_struct_b_lt(p, a, b)
struct aosa_pair *p;
int a;
int b;
{
  if (--p->b < 0)
    return a + p->b;
  return b;
}

static int
inc_struct_then_use(p)
struct aosa_pair *p;
{
  ++p->a;
  return p->a;
}

static int
dec_struct_then_use(p)
struct aosa_pair *p;
{
  --p->a;
  return p->a;
}

static int
inc_global_struct_eq(a, b)
int a;
int b;
{
  if (++aosa_gp.a == 0)
    return a;
  return b + aosa_gp.a;
}

static int
dec_global_struct_eq(a, b)
int a;
int b;
{
  if (--aosa_gp.b == 0)
    return a;
  return b + aosa_gp.b;
}

static int
inc_volatile_eq(p, a, b)
volatile int *p;
int a;
int b;
{
  if (++*p == 0)
    return a;
  return b + *p;
}

static int
dec_volatile_eq(p, a, b)
volatile int *p;
int a;
int b;
{
  if (--*p == 0)
    return a;
  return b + *p;
}

static int
inc_volatile_then_use(p)
volatile int *p;
{
  ++*p;
  return *p;
}

static int
dec_volatile_then_use(p)
volatile int *p;
{
  --*p;
  return *p;
}

static int
inc_branch_with_live(p, a, b, c)
int *p;
int a;
int b;
int c;
{
  int live;

  live = a + b;
  OPAQUE_REG(live);

  if (++*p == 0)
    return live + c;

  return live + *p;
}

static int
dec_branch_with_live(p, a, b, c)
int *p;
int a;
int b;
int c;
{
  int live;

  live = a + b;
  OPAQUE_REG(live);

  if (--*p == 0)
    return live + c;

  return live + *p;
}

static int
inc_branch_call_after(p, a, b)
int *p;
int a;
int b;
{
  extern void clobber(void);

  if (++*p == 0) {
    clobber();
    return a;
  }

  clobber();
  return b + *p;
}

static int
dec_branch_call_after(p, a, b)
int *p;
int a;
int b;
{
  extern void clobber(void);

  if (--*p == 0) {
    clobber();
    return a;
  }

  clobber();
  return b + *p;
}

static int
inc_then_branch_two_tests(p, a, b)
int *p;
int a;
int b;
{
  ++*p;

  if (*p == 0)
    return a;
  if (*p > 0)
    return b + *p;

  return b - *p;
}

static int
dec_then_branch_two_tests(p, a, b)
int *p;
int a;
int b;
{
  --*p;

  if (*p == 0)
    return a;
  if (*p < 0)
    return b + *p;

  return b - *p;
}

static int
inc_loop_until_zero(p)
int *p;
{
  int n;

  n = 0;

again:
  ++*p;
  ++n;
  if (*p != 0)
    goto again;

  return n;
}

static int
dec_loop_until_zero(p)
int *p;
{
  int n;

  n = 0;

again:
  --*p;
  ++n;
  if (*p != 0)
    goto again;

  return n;
}

static int
inc_loop_until_positive(p)
int *p;
{
  int n;

  n = 0;

again:
  ++*p;
  ++n;
  if (*p <= 0)
    goto again;

  return n;
}

static int
dec_loop_until_negative(p)
int *p;
{
  int n;

  n = 0;

again:
  --*p;
  ++n;
  if (*p >= 0)
    goto again;

  return n;
}

static int
inc_loop_array(v, n)
int *v;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; ++i) {
    ++v[i & 017];
    s += v[i & 017];
  }

  return s;
}

static int
dec_loop_array(v, n)
int *v;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; ++i) {
    --v[i & 017];
    s += v[i & 017];
  }

  return s;
}

static int
inc_loop_array_branch(v, n)
int *v;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; ++i) {
    if (++v[i & 017] == 0)
      s += 1;
    else
      s += v[i & 017];
  }

  return s;
}

static int
dec_loop_array_branch(v, n)
int *v;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; ++i) {
    if (--v[i & 017] == 0)
      s += 1;
    else
      s += v[i & 017];
  }

  return s;
}

/*
 * Smaller-type memory forms.  These may lower through byte/halfword
 * load/store sequences rather than AOS/SOS, but they are useful
 * correctness controls for increment/decrement-and-branch.
 */

static Sint
inc_qint_branch_eq(p, a, b)
Qint *p;
Sint a;
Sint b;
{
  if (++*p == 0)
    return a;
  return b + *p;
}

static Sint
dec_qint_branch_eq(p, a, b)
Qint *p;
Sint a;
Sint b;
{
  if (--*p == 0)
    return a;
  return b + *p;
}

static Sint
inc_hint_branch_eq(p, a, b)
Hint *p;
Sint a;
Sint b;
{
  if (++*p == 0)
    return a;
  return b + *p;
}

static Sint
dec_hint_branch_eq(p, a, b)
Hint *p;
Sint a;
Sint b;
{
  if (--*p == 0)
    return a;
  return b + *p;
}

static Sint
inc_spair_eq(p, a, b)
struct aosa_spair *p;
Sint a;
Sint b;
{
  if (++p->a == 0)
    return a;
  return b + p->a;
}

static Sint
dec_spair_eq(p, a, b)
struct aosa_spair *p;
Sint a;
Sint b;
{
  if (--p->b == 0)
    return a;
  return b + p->b;
}

static Sint
inc_global_spair_eq(a, b)
Sint a;
Sint b;
{
  if (++aosa_gsp.a == 0)
    return a;
  return b + aosa_gsp.a;
}

static Sint
dec_global_spair_eq(a, b)
Sint a;
Sint b;
{
  if (--aosa_gsp.b == 0)
    return a;
  return b + aosa_gsp.b;
}

/*
 * Forms where AOSA/SOSA should probably not be expected.  They remain
 * here as controls for correctness and to catch over-eager peepholes.
 */

static int
inc_by_two_branch_eq(p, a, b)
int *p;
int a;
int b;
{
  *p += 2;
  if (*p == 0)
    return a;
  return b + *p;
}

static int
dec_by_two_branch_eq(p, a, b)
int *p;
int a;
int b;
{
  *p -= 2;
  if (*p == 0)
    return a;
  return b + *p;
}

static int
inc_local_branch_eq(x, a, b)
int x;
int a;
int b;
{
  if (++x == 0)
    return a;
  return b + x;
}

static int
dec_local_branch_eq(x, a, b)
int x;
int a;
int b;
{
  if (--x == 0)
    return a;
  return b + x;
}
