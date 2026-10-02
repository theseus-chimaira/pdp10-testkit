#include "insns.h"

/*
 * Byte-pointer subtraction coverage.
 *
 * File:
 *   misc/byte-pointer-diff.c
 *
 * This is a misc coverage test, not a single instruction-pattern test.
 *
 * It stresses pointer subtraction for PDP-10 byte pointers on the
 * PDP-6/166 and KA10 baseline.  These machines do not have SUBBP, so
 * non-word byte-pointer subtraction must be lowered through the
 * software sequence and byte-position correction tables:
 *
 *   %BADL6, %BADL7, %BADL8, %BADL9, %BADLH
 *
 * XKL2 SUBBP itself is intentionally out of scope for this pass.
 *
 * Covered byte sizes:
 *   - ordinary char and unsigned char, normally 9-bit on this target
 *   - explicit 6-bit, 7-bit, 8-bit, and 9-bit bytes
 *   - explicit 16-bit and 18-bit halfword-sized objects
 *   - int pointers as a word-pointer control case
 *
 * The volatile pointer temporaries and clobber calls are deliberate:
 * they keep GCC from simplifying (p + n) - p into n before the PDP-10
 * pointer-subtraction expander has a chance to run.
 */

extern int f(void);
extern void clobber(void);

static char cbuf[48];
static unsigned char ucbuf[48];
static char6 b6[48];
static uchar6 ub6[48];
static char7 b7[48];
static uchar7 ub7[48];
static char8 b8[48];
static uchar8 ub8[48];
static char9 b9[48];
static uchar9 ub9[48];
static short16 h16[32];
static ushort16 uh16[32];
static short18 h18[32];
static ushort18 uh18[32];
static int wbuf[32];

static char * volatile vpc;
static unsigned char * volatile vpuc;
static char6 * volatile vp6;
static uchar6 * volatile vpu6;
static char7 * volatile vp7;
static uchar7 * volatile vpu7;
static char8 * volatile vp8;
static uchar8 * volatile vpu8;
static char9 * volatile vp9;
static uchar9 * volatile vpu9;
static short16 * volatile vph16;
static ushort16 * volatile vpuh16;
static short18 * volatile vph18;
static ushort18 * volatile vpuh18;
static int * volatile vpw;

/*
 * Direct pointer-minus-pointer forms.
 */

static int diff_char(char *p, char *q) { return p - q; }
static int diff_uchar(unsigned char *p, unsigned char *q) { return p - q; }
static int diff_6(char6 *p, char6 *q) { return p - q; }
static int diffu_6(uchar6 *p, uchar6 *q) { return p - q; }
static int diff_7(char7 *p, char7 *q) { return p - q; }
static int diffu_7(uchar7 *p, uchar7 *q) { return p - q; }
static int diff_8(char8 *p, char8 *q) { return p - q; }
static int diffu_8(uchar8 *p, uchar8 *q) { return p - q; }
static int diff_9(char9 *p, char9 *q) { return p - q; }
static int diffu_9(uchar9 *p, uchar9 *q) { return p - q; }
static int diff_16(short16 *p, short16 *q) { return p - q; }
static int diffu_16(ushort16 *p, ushort16 *q) { return p - q; }
static int diff_18(short18 *p, short18 *q) { return p - q; }
static int diffu_18(ushort18 *p, ushort18 *q) { return p - q; }
static int diff_word(int *p, int *q) { return p - q; }

static int rdiff_char(char *p, char *q) { return q - p; }
static int rdiff_6(char6 *p, char6 *q) { return q - p; }
static int rdiff_7(char7 *p, char7 *q) { return q - p; }
static int rdiff_8(char8 *p, char8 *q) { return q - p; }
static int rdiff_9(char9 *p, char9 *q) { return q - p; }
static int rdiff_16(short16 *p, short16 *q) { return q - p; }
static int rdiff_18(short18 *p, short18 *q) { return q - p; }

/*
 * Dynamic span forms: force pointer adjustment first, then subtraction.
 */

static int
span_char(p, n)
char *p;
int n;
{
  char *q;

  q = p + n;
  vpc = q;
  clobber();
  return vpc - p;
}

static int
span_uchar(p, n)
unsigned char *p;
int n;
{
  unsigned char *q;

  q = p + n;
  vpuc = q;
  clobber();
  return vpuc - p;
}

static int
span_6(p, n)
char6 *p;
int n;
{
  char6 *q;

  q = p + n;
  vp6 = q;
  clobber();
  return vp6 - p;
}

static int
spanu_6(p, n)
uchar6 *p;
int n;
{
  uchar6 *q;

  q = p + n;
  vpu6 = q;
  clobber();
  return vpu6 - p;
}

static int
span_7(p, n)
char7 *p;
int n;
{
  char7 *q;

  q = p + n;
  vp7 = q;
  clobber();
  return vp7 - p;
}

static int
spanu_7(p, n)
uchar7 *p;
int n;
{
  uchar7 *q;

  q = p + n;
  vpu7 = q;
  clobber();
  return vpu7 - p;
}

static int
span_8(p, n)
char8 *p;
int n;
{
  char8 *q;

  q = p + n;
  vp8 = q;
  clobber();
  return vp8 - p;
}

static int
spanu_8(p, n)
uchar8 *p;
int n;
{
  uchar8 *q;

  q = p + n;
  vpu8 = q;
  clobber();
  return vpu8 - p;
}

static int
span_9(p, n)
char9 *p;
int n;
{
  char9 *q;

  q = p + n;
  vp9 = q;
  clobber();
  return vp9 - p;
}

static int
spanu_9(p, n)
uchar9 *p;
int n;
{
  uchar9 *q;

  q = p + n;
  vpu9 = q;
  clobber();
  return vpu9 - p;
}

static int
span_16(p, n)
short16 *p;
int n;
{
  short16 *q;

  q = p + n;
  vph16 = q;
  clobber();
  return vph16 - p;
}

static int
spanu_16(p, n)
ushort16 *p;
int n;
{
  ushort16 *q;

  q = p + n;
  vpuh16 = q;
  clobber();
  return vpuh16 - p;
}

static int
span_18(p, n)
short18 *p;
int n;
{
  short18 *q;

  q = p + n;
  vph18 = q;
  clobber();
  return vph18 - p;
}

static int
spanu_18(p, n)
ushort18 *p;
int n;
{
  ushort18 *q;

  q = p + n;
  vpuh18 = q;
  clobber();
  return vpuh18 - p;
}

static int
span_word(p, n)
int *p;
int n;
{
  int *q;

  q = p + n;
  vpw = q;
  clobber();
  return vpw - p;
}

/*
 * Backward dynamic spans.  These exercise negative byte-pointer
 * differences and reversed subtract operands.
 */

static int
backspan_char(p, n)
char *p;
int n;
{
  char *q;

  q = p - n;
  vpc = q;
  clobber();
  return vpc - p;
}

static int
backspan_6(p, n)
char6 *p;
int n;
{
  char6 *q;

  q = p - n;
  vp6 = q;
  clobber();
  return vp6 - p;
}

static int
backspan_7(p, n)
char7 *p;
int n;
{
  char7 *q;

  q = p - n;
  vp7 = q;
  clobber();
  return vp7 - p;
}

static int
backspan_8(p, n)
char8 *p;
int n;
{
  char8 *q;

  q = p - n;
  vp8 = q;
  clobber();
  return vp8 - p;
}

static int
backspan_9(p, n)
char9 *p;
int n;
{
  char9 *q;

  q = p - n;
  vp9 = q;
  clobber();
  return vp9 - p;
}

static int
backspan_16(p, n)
short16 *p;
int n;
{
  short16 *q;

  q = p - n;
  vph16 = q;
  clobber();
  return vph16 - p;
}

static int
backspan_18(p, n)
short18 *p;
int n;
{
  short18 *q;

  q = p - n;
  vph18 = q;
  clobber();
  return vph18 - p;
}

/*
 * Indexed array forms.  These give the expander dynamic byte-pointer
 * operands whose byte position is not known until after address
 * formation.
 */

static int idx_char(i, j) int i; int j; { return &cbuf[i] - &cbuf[j]; }
static int idx_uchar(i, j) int i; int j; { return &ucbuf[i] - &ucbuf[j]; }
static int idx_6(i, j) int i; int j; { return &b6[i] - &b6[j]; }
static int idxu_6(i, j) int i; int j; { return &ub6[i] - &ub6[j]; }
static int idx_7(i, j) int i; int j; { return &b7[i] - &b7[j]; }
static int idxu_7(i, j) int i; int j; { return &ub7[i] - &ub7[j]; }
static int idx_8(i, j) int i; int j; { return &b8[i] - &b8[j]; }
static int idxu_8(i, j) int i; int j; { return &ub8[i] - &ub8[j]; }
static int idx_9(i, j) int i; int j; { return &b9[i] - &b9[j]; }
static int idxu_9(i, j) int i; int j; { return &ub9[i] - &ub9[j]; }
static int idx_16(i, j) int i; int j; { return &h16[i] - &h16[j]; }
static int idxu_16(i, j) int i; int j; { return &uh16[i] - &uh16[j]; }
static int idx_18(i, j) int i; int j; { return &h18[i] - &h18[j]; }
static int idxu_18(i, j) int i; int j; { return &uh18[i] - &uh18[j]; }
static int idx_word(i, j) int i; int j; { return &wbuf[i] - &wbuf[j]; }

/*
 * Constant byte positions across word boundaries.  Store one operand
 * through a volatile pointer so the expression is not just folded to a
 * host constant.
 */

static int
const_char()
{
  vpc = &cbuf[17];
  clobber();
  return vpc - &cbuf[2];
}

static int
const_uchar()
{
  vpuc = &ucbuf[17];
  clobber();
  return vpuc - &ucbuf[2];
}

static int
const_6()
{
  int sum;

  sum = 0;
  vp6 = &b6[5];
  clobber();
  sum += vp6 - &b6[0];
  vp6 = &b6[6];
  clobber();
  sum += vp6 - &b6[0];
  vp6 = &b6[11];
  clobber();
  sum += vp6 - &b6[5];
  vp6 = &b6[12];
  clobber();
  sum += vp6 - &b6[6];
  vp6 = &b6[23];
  clobber();
  sum += vp6 - &b6[17];
  return sum;
}

static int
constu_6()
{
  vpu6 = &ub6[17];
  clobber();
  return vpu6 - &ub6[2];
}

static int
const_7()
{
  int sum;

  sum = 0;
  vp7 = &b7[4];
  clobber();
  sum += vp7 - &b7[0];
  vp7 = &b7[5];
  clobber();
  sum += vp7 - &b7[0];
  vp7 = &b7[9];
  clobber();
  sum += vp7 - &b7[4];
  vp7 = &b7[10];
  clobber();
  sum += vp7 - &b7[5];
  vp7 = &b7[19];
  clobber();
  sum += vp7 - &b7[3];
  return sum;
}

static int
constu_7()
{
  vpu7 = &ub7[17];
  clobber();
  return vpu7 - &ub7[2];
}

static int
const_8()
{
  int sum;

  sum = 0;
  vp8 = &b8[3];
  clobber();
  sum += vp8 - &b8[0];
  vp8 = &b8[4];
  clobber();
  sum += vp8 - &b8[0];
  vp8 = &b8[7];
  clobber();
  sum += vp8 - &b8[3];
  vp8 = &b8[8];
  clobber();
  sum += vp8 - &b8[4];
  vp8 = &b8[17];
  clobber();
  sum += vp8 - &b8[2];
  return sum;
}

static int
constu_8()
{
  vpu8 = &ub8[17];
  clobber();
  return vpu8 - &ub8[2];
}

static int
const_9()
{
  int sum;

  sum = 0;
  vp9 = &b9[3];
  clobber();
  sum += vp9 - &b9[0];
  vp9 = &b9[4];
  clobber();
  sum += vp9 - &b9[0];
  vp9 = &b9[7];
  clobber();
  sum += vp9 - &b9[3];
  vp9 = &b9[8];
  clobber();
  sum += vp9 - &b9[4];
  vp9 = &b9[17];
  clobber();
  sum += vp9 - &b9[2];
  return sum;
}

static int
constu_9()
{
  vpu9 = &ub9[17];
  clobber();
  return vpu9 - &ub9[2];
}

static int
const_16()
{
  int sum;

  sum = 0;
  vph16 = &h16[1];
  clobber();
  sum += vph16 - &h16[0];
  vph16 = &h16[2];
  clobber();
  sum += vph16 - &h16[0];
  vph16 = &h16[5];
  clobber();
  sum += vph16 - &h16[1];
  return sum;
}

static int
constu_16()
{
  vpuh16 = &uh16[9];
  clobber();
  return vpuh16 - &uh16[2];
}

static int
const_18()
{
  int sum;

  sum = 0;
  vph18 = &h18[1];
  clobber();
  sum += vph18 - &h18[0];
  vph18 = &h18[2];
  clobber();
  sum += vph18 - &h18[0];
  vph18 = &h18[5];
  clobber();
  sum += vph18 - &h18[1];
  return sum;
}

static int
constu_18()
{
  vpuh18 = &uh18[9];
  clobber();
  return vpuh18 - &uh18[2];
}

static int
const_word()
{
  vpw = &wbuf[17];
  clobber();
  return vpw - &wbuf[2];
}

/*
 * Pointer-difference values used in arithmetic and comparisons.
 */

static int
sum_selected_diffs(i, j, n)
int i;
int j;
int n;
{
  int sum;

  sum = 0;
  sum += diff_char(&cbuf[i], &cbuf[j]);
  sum += diff_6(&b6[i], &b6[j]);
  sum += diff_7(&b7[i], &b7[j]);
  sum += diff_8(&b8[i], &b8[j]);
  sum += diff_9(&b9[i], &b9[j]);
  sum += diff_16(&h16[i & 017], &h16[j & 017]);
  sum += diff_18(&h18[i & 017], &h18[j & 017]);
  sum += span_char(&cbuf[24], n);
  sum += span_6(&b6[24], n);
  sum += span_7(&b7[24], n);
  sum += span_8(&b8[24], n);
  sum += span_9(&b9[24], n);
  sum += span_16(&h16[16], n & 7);
  sum += span_18(&h18[16], n & 7);
  return sum;
}

static int
compare_diff_6(p, q, limit)
char6 *p;
char6 *q;
int limit;
{
  return (p - q) > limit;
}

static int
compare_diff_9(p, q, limit)
char9 *p;
char9 *q;
int limit;
{
  return (p - q) <= limit;
}

static int
compare_diff_18(p, q, limit)
short18 *p;
short18 *q;
int limit;
{
  return (p - q) == limit;
}

/*
 * Combined entry point to keep all static coverage functions live.
 */

int
use_byte_pointer_diffs(n)
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

  sum += diff_char(&cbuf[17], &cbuf[2]);
  sum += diff_uchar(&ucbuf[17], &ucbuf[2]);
  sum += diff_6(&b6[17], &b6[2]);
  sum += diffu_6(&ub6[17], &ub6[2]);
  sum += diff_7(&b7[17], &b7[2]);
  sum += diffu_7(&ub7[17], &ub7[2]);
  sum += diff_8(&b8[17], &b8[2]);
  sum += diffu_8(&ub8[17], &ub8[2]);
  sum += diff_9(&b9[17], &b9[2]);
  sum += diffu_9(&ub9[17], &ub9[2]);
  sum += diff_16(&h16[9], &h16[2]);
  sum += diffu_16(&uh16[9], &uh16[2]);
  sum += diff_18(&h18[9], &h18[2]);
  sum += diffu_18(&uh18[9], &uh18[2]);
  sum += diff_word(&wbuf[17], &wbuf[2]);

  sum += rdiff_char(&cbuf[17], &cbuf[2]);
  sum += rdiff_6(&b6[17], &b6[2]);
  sum += rdiff_7(&b7[17], &b7[2]);
  sum += rdiff_8(&b8[17], &b8[2]);
  sum += rdiff_9(&b9[17], &b9[2]);
  sum += rdiff_16(&h16[9], &h16[2]);
  sum += rdiff_18(&h18[9], &h18[2]);

  sum += span_char(&cbuf[24], m);
  sum += span_uchar(&ucbuf[24], m);
  sum += span_6(&b6[24], m);
  sum += spanu_6(&ub6[24], m);
  sum += span_7(&b7[24], m);
  sum += spanu_7(&ub7[24], m);
  sum += span_8(&b8[24], m);
  sum += spanu_8(&ub8[24], m);
  sum += span_9(&b9[24], m);
  sum += spanu_9(&ub9[24], m);
  sum += span_16(&h16[16], m);
  sum += spanu_16(&uh16[16], m);
  sum += span_18(&h18[16], m);
  sum += spanu_18(&uh18[16], m);
  sum += span_word(&wbuf[16], m);

  sum += backspan_char(&cbuf[24], m);
  sum += backspan_6(&b6[24], m);
  sum += backspan_7(&b7[24], m);
  sum += backspan_8(&b8[24], m);
  sum += backspan_9(&b9[24], m);
  sum += backspan_16(&h16[16], m);
  sum += backspan_18(&h18[16], m);

  sum += idx_char(i, j);
  sum += idx_uchar(i, j);
  sum += idx_6(i, j);
  sum += idxu_6(i, j);
  sum += idx_7(i, j);
  sum += idxu_7(i, j);
  sum += idx_8(i, j);
  sum += idxu_8(i, j);
  sum += idx_9(i, j);
  sum += idxu_9(i, j);
  sum += idx_16(i & 017, j & 017);
  sum += idxu_16(i & 017, j & 017);
  sum += idx_18(i & 017, j & 017);
  sum += idxu_18(i & 017, j & 017);
  sum += idx_word(i & 017, j & 017);

  sum += const_char();
  sum += const_uchar();
  sum += const_6();
  sum += constu_6();
  sum += const_7();
  sum += constu_7();
  sum += const_8();
  sum += constu_8();
  sum += const_9();
  sum += constu_9();
  sum += const_16();
  sum += constu_16();
  sum += const_18();
  sum += constu_18();
  sum += const_word();

  sum += sum_selected_diffs(i, j, m);
  sum += compare_diff_6(&b6[17], &b6[2], n);
  sum += compare_diff_9(&b9[17], &b9[2], n);
  sum += compare_diff_18(&h18[9], &h18[2], n & 017);

  return sum;
}
