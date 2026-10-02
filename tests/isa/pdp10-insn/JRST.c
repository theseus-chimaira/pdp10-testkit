/* flag: -O2 */
#include "insns.h"


/*
 * JRST instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   JRST label       direct unconditional branch
 *   JRST (AC)        indirect jump through register
 *   JRST @mem        indirect jump through memory
 *   JRST @[...]      indirect jump through literal/constant address
 *
 * Also useful:
 *   tail-call-as-JRST for sibling calls
 *   recursive no-return loops
 *   goto cleanup/finally style control flow
 *   computed goto label tables
 *
 * This test uses GCC computed-goto extensions.  That is intentional:
 * the PDP-10 backend has an indirect_jump expander and instruction
 * pattern, and plain ISO C has no direct way to express it.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern Sint jre1(Sint);
extern Sint jre2(Sint, Sint);
extern Sint jre3(Sint, Sint, Sint);
extern void jrv1(Sint);
extern void jrv2(Sint, Sint);
extern void clobber(void);

static void
jrst_infinite_loop(void)
{
loop:
  goto loop;
}

static void
jrst_forward_loop(x)
Sint x;
{
start:
  if (x == 0)
    goto done;
  --x;
  goto start;

done:
  return;
}

static Sint
jrst_forward_join(a)
Sint a;
{
  if (a < 0)
    goto neg;
  if (a == 0)
    goto zero;
  goto pos;

neg:
  return -1;

zero:
  return 0;

pos:
  return 1;
}

static Sint
jrst_cleanup(a, p)
Sint a;
Sint *p;
{
  Sint r;

  r = 0;
  if (p == 0)
    goto out;
  if (a < 0)
    goto bad;

  r = *p + a;
  goto out;

bad:
  r = -1;

out:
  return r;
}

static Sint
jrst_multi_join(a, b)
Sint a;
Sint b;
{
  Sint r;

  if (a < 0)
    goto left;
  if (b < 0)
    goto right;
  r = a + b;
  goto done;

left:
  r = a - b;
  goto done;

right:
  r = b - a;

done:
  return r;
}

static Sint
jrst_loop_break_continue(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint s;

  i = 0;
  s = 0;

again:
  if (i >= n)
    goto done;
  if ((i & 1) != 0)
    goto cont;
  if (v[i & 7] == 0)
    goto done;

  s += v[i & 7];

cont:
  ++i;
  goto again;

done:
  return s;
}

static Sint
jrst_nested_loops(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint j;
  Sint s;

  i = 0;
  s = 0;

outer:
  if (i >= n)
    goto done;

  j = 0;

inner:
  if (j >= 4)
    goto next_outer;
  s += v[(i + j) & 7];
  ++j;
  goto inner;

next_outer:
  ++i;
  goto outer;

done:
  return s;
}

static Sint
jrst_switch_dense(x)
Sint x;
{
  switch (x & 7) {
  case 0:
    goto c0;
  case 1:
    goto c1;
  case 2:
    goto c2;
  case 3:
    goto c3;
  case 4:
    goto c4;
  case 5:
    goto c5;
  case 6:
    goto c6;
  default:
    goto c7;
  }

c0:
  return 010;
c1:
  return 011;
c2:
  return 012;
c3:
  return 013;
c4:
  return 014;
c5:
  return 015;
c6:
  return 016;
c7:
  return 017;
}

static Sint
jrst_switch_sparse(x)
Sint x;
{
  switch (x) {
  case -1:
    goto m1;
  case 0:
    goto z;
  case 0123456:
    goto big;
  case 0777777:
    goto max;
  default:
    goto def;
  }

m1:
  return -1;
z:
  return 0;
big:
  return 0123456;
max:
  return 0777777;
def:
  return x;
}


static Sint
jrst_tail_call1(a)
Sint a;
{
  return jre1(a);
}

static Sint
jrst_tail_call2(a, b)
Sint a;
Sint b;
{
  return jre2(a, b);
}

static Sint
jrst_tail_call3(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return jre3(a, b, c);
}

static void
jrst_tail_vcall1(a)
Sint a;
{
  jrv1(a);
}

static void
jrst_tail_vcall2(a, b)
Sint a;
Sint b;
{
  jrv2(a, b);
}

static Sint
jrst_tail_call_cond(a, b)
Sint a;
Sint b;
{
  if (a < 0)
    return jre1(a);
  return jre2(a, b);
}

static Sint
jrst_tail_call_after_work(a, b)
Sint a;
Sint b;
{
  a += b;
  return jre1(a);
}

static Sint
jrst_tail_call_through_ptr(fn, a)
Sint (*fn)();
Sint a;
{
  return (*fn)(a);
}

static Sint
jrst_tail_call_through_ptr2(fn, a, b)
Sint (*fn)();
Sint a;
Sint b;
{
  return (*fn)(a, b);
}

static void
jrst_recursive_void(void)
{
  jrst_recursive_void();
}

static Sint
jrst_recursive_sint(a)
Sint a;
{
  return jrst_recursive_sint(a + 1);
}

static Sint
jrst_tail_recursive_loop(a, n)
Sint a;
Sint n;
{
  if (n == 0)
    return a;
  return jrst_tail_recursive_loop(a + 1, n - 1);
}

static Sint
jrst_noreturn_like(a)
Sint a;
{
again:
  clobber();
  if (a == 0)
    goto again;
  --a;
  goto again;
}
