#include "insns.h"

/*
 * Byte-pointer runtime table coverage.
 *
 * File:
 *   misc/byteptr-runtime-tables.c
 *
 * This is a misc coverage test, not a normal instruction-pattern test.
 *
 * PDP-6/166 and KA10 do not have XKL2 SUBBP/CMPBP.  For pointer
 * subtraction on packed byte pointers, the backend lowers ordinary C
 * pointer differences through a software sequence and emits references
 * to byte-position correction tables.
 *
 * Intended non-extended runtime-table references:
 *
 *   %BADL6   6-bit byte pointers
 *   %BADL7   7-bit byte pointers
 *   %BADL8   8-bit byte pointers
 *   %BADL9   9-bit byte pointers, including ordinary char
 *   %BADLH   18-bit halfword pointers; 16-bit objects normalize here
 *
 * The local BADL tables are still a libgcc/runtime obligation.  This
 * test is meant to make those references visible in generated PDP-6
 * and KA10 assembly.  It must not depend on SUBBP, CMPBP, KL string
 * instructions.
 */

extern int f(void);
extern void clobber(void);

static char c9[48];
static unsigned char uc9[48];
static char6 c6[48];
static uchar6 uc6[48];
static char7 c7[48];
static uchar7 uc7[48];
static char8 c8[48];
static uchar8 uc8[48];
static char9 x9[48];
static uchar9 ux9[48];
static short16 h16[32];
static ushort16 uh16[32];
static short18 h18[32];
static ushort18 uh18[32];
static int words[32];

static char * volatile vc9;
static unsigned char * volatile vuc9;
static char6 * volatile vc6;
static uchar6 * volatile vuc6;
static char7 * volatile vc7;
static uchar7 * volatile vuc7;
static char8 * volatile vc8;
static uchar8 * volatile vuc8;
static char9 * volatile vx9;
static uchar9 * volatile vux9;
static short16 * volatile vh16;
static ushort16 * volatile vuh16;
static short18 * volatile vh18;
static ushort18 * volatile vuh18;
static int * volatile vwords;

/*
 * Direct pointer-minus-pointer forms.  Pointer parameters prevent
 * constant folding and should select the byte-pointer subtraction
 * expander directly.
 */

static int diff_char(p, q) char *p; char *q; { return p - q; }
static int diff_uchar(p, q) unsigned char *p; unsigned char *q; { return p - q; }
static int diff_6(p, q) char6 *p; char6 *q; { return p - q; }
static int diffu_6(p, q) uchar6 *p; uchar6 *q; { return p - q; }
static int diff_7(p, q) char7 *p; char7 *q; { return p - q; }
static int diffu_7(p, q) uchar7 *p; uchar7 *q; { return p - q; }
static int diff_8(p, q) char8 *p; char8 *q; { return p - q; }
static int diffu_8(p, q) uchar8 *p; uchar8 *q; { return p - q; }
static int diff_9(p, q) char9 *p; char9 *q; { return p - q; }
static int diffu_9(p, q) uchar9 *p; uchar9 *q; { return p - q; }
static int diff_16(p, q) short16 *p; short16 *q; { return p - q; }
static int diffu_16(p, q) ushort16 *p; ushort16 *q; { return p - q; }
static int diff_18(p, q) short18 *p; short18 *q; { return p - q; }
static int diffu_18(p, q) ushort18 *p; ushort18 *q; { return p - q; }
static int diff_word(p, q) int *p; int *q; { return p - q; }

/*
 * Volatile global pointer forms.  These are deliberately clobbered
 * between address formation and subtraction so GCC cannot simply fold
 * the difference back to the original integer index.
 */

static int table_char(p, n)
char *p;
int n;
{
  vc9 = p + n;
  clobber();
  return vc9 - p;
}

static int table_uchar(p, n)
unsigned char *p;
int n;
{
  vuc9 = p + n;
  clobber();
  return vuc9 - p;
}

static int table_6(p, n)
char6 *p;
int n;
{
  vc6 = p + n;
  clobber();
  return vc6 - p;
}

static int tableu_6(p, n)
uchar6 *p;
int n;
{
  vuc6 = p + n;
  clobber();
  return vuc6 - p;
}

static int table_7(p, n)
char7 *p;
int n;
{
  vc7 = p + n;
  clobber();
  return vc7 - p;
}

static int tableu_7(p, n)
uchar7 *p;
int n;
{
  vuc7 = p + n;
  clobber();
  return vuc7 - p;
}

static int table_8(p, n)
char8 *p;
int n;
{
  vc8 = p + n;
  clobber();
  return vc8 - p;
}

static int tableu_8(p, n)
uchar8 *p;
int n;
{
  vuc8 = p + n;
  clobber();
  return vuc8 - p;
}

static int table_9(p, n)
char9 *p;
int n;
{
  vx9 = p + n;
  clobber();
  return vx9 - p;
}

static int tableu_9(p, n)
uchar9 *p;
int n;
{
  vux9 = p + n;
  clobber();
  return vux9 - p;
}

static int table_16(p, n)
short16 *p;
int n;
{
  vh16 = p + n;
  clobber();
  return vh16 - p;
}

static int tableu_16(p, n)
ushort16 *p;
int n;
{
  vuh16 = p + n;
  clobber();
  return vuh16 - p;
}

static int table_18(p, n)
short18 *p;
int n;
{
  vh18 = p + n;
  clobber();
  return vh18 - p;
}

static int tableu_18(p, n)
ushort18 *p;
int n;
{
  vuh18 = p + n;
  clobber();
  return vuh18 - p;
}

static int table_word(p, n)
int *p;
int n;
{
  vwords = p + n;
  clobber();
  return vwords - p;
}

/*
 * Fixed positions chosen to cross word boundaries for each packing:
 *   6-bit: 5 -> 6, 11 -> 12
 *   7-bit: 4 -> 5, 9 -> 10
 *   8-bit: 3 -> 4, 7 -> 8
 *   9-bit: 3 -> 4, 7 -> 8
 *   18-bit: 1 -> 2
 */

static int fixed_6()
{
  int sum;

  sum = 0;
  vc6 = &c6[6];
  clobber();
  sum += vc6 - &c6[5];
  vc6 = &c6[12];
  clobber();
  sum += vc6 - &c6[11];
  vc6 = &c6[23];
  clobber();
  sum += vc6 - &c6[0];
  return sum;
}

static int fixed_7()
{
  int sum;

  sum = 0;
  vc7 = &c7[5];
  clobber();
  sum += vc7 - &c7[4];
  vc7 = &c7[10];
  clobber();
  sum += vc7 - &c7[9];
  vc7 = &c7[23];
  clobber();
  sum += vc7 - &c7[0];
  return sum;
}

static int fixed_8()
{
  int sum;

  sum = 0;
  vc8 = &c8[4];
  clobber();
  sum += vc8 - &c8[3];
  vc8 = &c8[8];
  clobber();
  sum += vc8 - &c8[7];
  vc8 = &c8[23];
  clobber();
  sum += vc8 - &c8[0];
  return sum;
}

static int fixed_9()
{
  int sum;

  sum = 0;
  vx9 = &x9[4];
  clobber();
  sum += vx9 - &x9[3];
  vx9 = &x9[8];
  clobber();
  sum += vx9 - &x9[7];
  vx9 = &x9[23];
  clobber();
  sum += vx9 - &x9[0];
  return sum;
}

static int fixed_h()
{
  int sum;

  sum = 0;
  vh16 = &h16[2];
  clobber();
  sum += vh16 - &h16[1];
  vh18 = &h18[2];
  clobber();
  sum += vh18 - &h18[1];
  vh18 = &h18[17];
  clobber();
  sum += vh18 - &h18[0];
  return sum;
}

/*
 * Dynamic indexed forms make the byte position unknown at C source
 * level and should still use the same table family.
 */

static int indexed_6(i, j) int i; int j; { return &c6[i] - &c6[j]; }
static int indexed_7(i, j) int i; int j; { return &c7[i] - &c7[j]; }
static int indexed_8(i, j) int i; int j; { return &c8[i] - &c8[j]; }
static int indexed_9(i, j) int i; int j; { return &x9[i] - &x9[j]; }
static int indexed_h(i, j) int i; int j; { return &h18[i] - &h18[j]; }

/*
 * Use pointer-difference results in ordinary arithmetic and branches so
 * the produced values remain live beyond simple returns.
 */

static int diff_gate_6(p, q, limit)
char6 *p;
char6 *q;
int limit;
{
  int d;

  d = p - q;
  if (d > limit)
    return d + 1;
  return d - 1;
}

static int diff_gate_9(p, q, limit)
char9 *p;
char9 *q;
int limit;
{
  int d;

  d = p - q;
  if (d <= limit)
    return d + 2;
  return d - 2;
}

static int diff_gate_h(p, q, limit)
short18 *p;
short18 *q;
int limit;
{
  int d;

  d = p - q;
  if (d == limit)
    return d + 3;
  return d - 3;
}

int
use_byteptr_runtime_tables(n)
int n;
{
  int i;
  int j;
  int m;
  int sum;

  i = (n + f()) & 017;
  j = (i + 5) & 017;
  m = n & 7;

  sum = 0;

  sum += diff_char(&c9[17], &c9[2]);
  sum += diff_uchar(&uc9[17], &uc9[2]);
  sum += diff_6(&c6[17], &c6[2]);
  sum += diffu_6(&uc6[17], &uc6[2]);
  sum += diff_7(&c7[17], &c7[2]);
  sum += diffu_7(&uc7[17], &uc7[2]);
  sum += diff_8(&c8[17], &c8[2]);
  sum += diffu_8(&uc8[17], &uc8[2]);
  sum += diff_9(&x9[17], &x9[2]);
  sum += diffu_9(&ux9[17], &ux9[2]);
  sum += diff_16(&h16[9], &h16[2]);
  sum += diffu_16(&uh16[9], &uh16[2]);
  sum += diff_18(&h18[9], &h18[2]);
  sum += diffu_18(&uh18[9], &uh18[2]);

  /* Control case: word-pointer subtraction should not need BADL. */
  sum += diff_word(&words[17], &words[2]);

  sum += table_char(&c9[24], m);
  sum += table_uchar(&uc9[24], m);
  sum += table_6(&c6[24], m);
  sum += tableu_6(&uc6[24], m);
  sum += table_7(&c7[24], m);
  sum += tableu_7(&uc7[24], m);
  sum += table_8(&c8[24], m);
  sum += tableu_8(&uc8[24], m);
  sum += table_9(&x9[24], m);
  sum += tableu_9(&ux9[24], m);
  sum += table_16(&h16[16], m);
  sum += tableu_16(&uh16[16], m);
  sum += table_18(&h18[16], m);
  sum += tableu_18(&uh18[16], m);
  sum += table_word(&words[16], m);

  sum += fixed_6();
  sum += fixed_7();
  sum += fixed_8();
  sum += fixed_9();
  sum += fixed_h();

  sum += indexed_6(i, j);
  sum += indexed_7(i, j);
  sum += indexed_8(i, j);
  sum += indexed_9(i, j);
  sum += indexed_h(i, j);

  sum += diff_gate_6(&c6[17], &c6[2], n);
  sum += diff_gate_9(&x9[17], &x9[2], n);
  sum += diff_gate_h(&h18[9], &h18[2], n & 017);

  return sum;
}
