#include "insns.h"

/*
 * Stack-adjustment coverage for PDP-6/166 and KA10.
 *
 * The source-level operation is ADJSP-like stack adjustment.  On
 * PDP-6/KA10 the backend must not emit a real ADJSP instruction;
 * it should use the non-KL fallback forms, usually:
 *
 *   add 17,[n,,n]
 *
 * and for dynamic or too-large adjustments:
 *
 *   move tmp,n
 *   hrl  tmp,n
 *   add  17,tmp
 *
 * This test deliberately exercises outgoing stack arguments, local
 * stack frames, saved registers, structure arguments, and dynamic
 * alloca-style stack allocation.
 */

struct adjsp_block {
  Sint a0;
  Sint a1;
  Sint a2;
  Sint a3;
  Sint a4;
  Sint a5;
};


static Sint
adjsp_call5(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
{
  extern Sint ajsp5(Sint, Sint, Sint, Sint, Sint);
  Sint r;

  r = ajsp5(a, b, c, d, e);
  return r + a;
}

static Sint
adjsp_call6(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  extern Sint ajsp6(Sint, Sint, Sint, Sint, Sint, Sint);
  Sint r;

  r = ajsp6(a, b, c, d, e, f);
  return r + f;
}

static Sint
adjsp_call_mixed(a, d)
Sint a;
Dint d;
{
  extern Sint ajmix(Sint, Sint, Sint, Dint, Sint);
  Sint r;

  r = ajmix(a, a + 1, a + 2, d, a + 3);
  return r + a;
}

static Sint
adjsp_local_addr(a)
Sint a;
{
  extern void ajusp(Sint *);
  Sint x;

  x = a + 1;
  ajusp(&x);
  return x + a;
}

static Sint
adjsp_two_locals_addr(a, b)
Sint a;
Sint b;
{
  extern void ajusp(Sint *);
  Sint x;
  Sint y;

  x = a + 1;
  y = b + 2;
  ajusp(&x);
  ajusp(&y);
  return x + y;
}

static Sint
adjsp_local_array(a, i)
Sint a;
Sint i;
{
  extern void ajusp(Sint *);
  Sint v[8];

  v[0] = a;
  v[1] = a + 1;
  v[2] = a + 2;
  v[3] = a + 3;
  v[4] = a + 4;
  v[5] = a + 5;
  v[6] = a + 6;
  v[7] = a + 7;
  ajusp(v);
  return v[i & 7];
}

static Dint
adjsp_save_dint(d)
Dint d;
{
  extern void clobber(void);
  Dint x;

  x = d + 1;
  clobber();
  return x + d;
}

static Sint
adjsp_save_many(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint f;
{
  extern void clobber(void);
  Sint r0;
  Sint r1;
  Sint r2;
  Sint r3;
  Sint r4;
  Sint r5;

  r0 = a + 01;
  r1 = b + 02;
  r2 = c + 03;
  r3 = d + 04;
  r4 = e + 05;
  r5 = f + 06;

  clobber();

  return r0 + r1 + r2 + r3 + r4 + r5;
}

static Sint
adjsp_block_arg(a)
Sint a;
{
  extern Sint ajsbk(struct adjsp_block);
  struct adjsp_block b;
  Sint r;

  b.a0 = a;
  b.a1 = a + 1;
  b.a2 = a + 2;
  b.a3 = a + 3;
  b.a4 = a + 4;
  b.a5 = a + 5;

  r = ajsbk(b);
  return r + b.a0 + b.a5;
}

static Sint
adjsp_block_addr(a)
Sint a;
{
  extern void ajubp(struct adjsp_block *);
  struct adjsp_block b;

  b.a0 = a;
  b.a1 = a + 1;
  b.a2 = a + 2;
  b.a3 = a + 3;
  b.a4 = a + 4;
  b.a5 = a + 5;

  ajubp(&b);
  return b.a0 + b.a1 + b.a2 + b.a3 + b.a4 + b.a5;
}

static Sint
adjsp_alloca_small(a, n)
Sint a;
uSint n;
{
  extern void ajusp(Sint *);
  Sint *p;
  uSint m;

  m = (n & 017) + 1;
  p = (Sint *) __builtin_alloca(m * sizeof(Sint));

  p[0] = a;
  p[m - 1] = a + 1;
  ajusp(p);

  return p[0] + p[m - 1];
}

static Sint
adjsp_alloca_mixed(a, n)
Sint a;
uSint n;
{
  extern Sint ajsp5(Sint, Sint, Sint, Sint, Sint);
  extern void ajusp(Sint *);
  Sint *p;
  Sint r;
  uSint m;

  m = (n & 077) + 5;
  p = (Sint *) __builtin_alloca(m * sizeof(Sint));

  p[0] = a;
  p[1] = a + 1;
  p[2] = a + 2;
  p[m - 1] = a + 3;

  r = ajsp5(p[0], p[1], p[2], p[m - 1], a);
  ajusp(p);

  return r + p[0];
}

static Sint
adjsp_large_const_frame(a)
Sint a;
{
  extern void ajusp(Sint *);
  Sint big[0400000];

  big[0] = a;
  ajusp(big);
  return big[0];
}
