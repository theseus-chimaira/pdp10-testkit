#include "insns.h"

/*
 * 6-bit packed byte extraction/store coverage.
 *
 * File:
 *   misc/byte-extract-6.c
 *
 * This is a misc coverage test, not a single instruction-pattern test.
 *
 * It stresses:
 *   - signed and unsigned 6-bit machine byte loads
 *   - every 6-bit byte position inside a 36-bit word
 *   - crossing 36-bit word boundaries
 *   - static byte-pointer constants
 *   - pointer indexing
 *   - stores and store-return forms
 *   - copy/sum/zero loops
 *   - pointer-walk forms
 *   - widening and truncation around int6/uchar6
 *
 * 6-bit byte-pointer arithmetic is especially useful on PDP-6/KA10
 * because it is not a power-of-two byte count per word.  Dynamic
 * pointer adjustment must not require KL10 ADJBP.
 */

extern int f(void);
extern unsigned int uf(void);
extern void clobber(void);

struct bytes6 {
  int6 c0, c1, c2, c3, c4, c5;
  uchar6 u0, u1, u2, u3, u4, u5;
};

struct signed6 {
  int6 c0, c1, c2, c3, c4, c5;
};

struct unsigned6 {
  uchar6 u0, u1, u2, u3, u4, u5;
};

struct mixed6 {
  int filler;
  int6 c0;
  uchar6 u0;
  int6 c1;
  uchar6 u1;
  int word;
  int6 c2;
  uchar6 u2;
};

static int6 s6[36];
static uchar6 u6[36];
static volatile int6 vs6[36];
static volatile uchar6 vu6[36];

static struct bytes6 b6;
static struct signed6 sb6;
static struct unsigned6 ub6;
static struct mixed6 mb6;

static struct bytes6 b6a[8];
static struct signed6 sb6a[8];
static struct unsigned6 ub6a[8];
static struct mixed6 mb6a[8];

static int6 *s6p0 = &s6[0];
static int6 *s6p5 = &s6[5];
static int6 *s6p6 = &s6[6];
static int6 *s6p11 = &s6[11];
static int6 *s6p12 = &s6[12];

static uchar6 *u6p0 = &u6[0];
static uchar6 *u6p5 = &u6[5];
static uchar6 *u6p6 = &u6[6];
static uchar6 *u6p11 = &u6[11];
static uchar6 *u6p12 = &u6[12];

static int6 *b6cp0 = &b6.c0;
static int6 *b6cp1 = &b6.c1;
static int6 *b6cp2 = &b6.c2;
static int6 *b6cp3 = &b6.c3;
static int6 *b6cp4 = &b6.c4;
static int6 *b6cp5 = &b6.c5;

static uchar6 *b6up0 = &b6.u0;
static uchar6 *b6up1 = &b6.u1;
static uchar6 *b6up2 = &b6.u2;
static uchar6 *b6up3 = &b6.u3;
static uchar6 *b6up4 = &b6.u4;
static uchar6 *b6up5 = &b6.u5;

/*
 * Original seed shape.
 */

#define LOAD6(N)                                                \
static int                                                      \
load6_##N()                                                     \
{                                                               \
  return b6.c##N;                                               \
}                                                               \
static unsigned int                                             \
loadu6_##N()                                                    \
{                                                               \
  return b6.u##N;                                               \
}

LOAD6(0)
LOAD6(1)
LOAD6(2)
LOAD6(3)
LOAD6(4)
LOAD6(5)

static int
load_char6_index(i)
int i;
{
  return s6[i];
}

static unsigned int
load_uchar6_index(i)
int i;
{
  return u6[i];
}

static int
load_char6_const_cross()
{
  return s6[0] + s6[5] + s6[6] + s6[11] + s6[12];
}

static void
store_char6_index(i, x)
int i;
int x;
{
  s6[i] = (int6)x;
  u6[i] = (uchar6)(x + 1);
}

static int
copy_char6(d, s, n)
int6 *d;
int6 *s;
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++) {
    d[i] = s[i];
    sum += d[i];
  }
  return sum;
}

static unsigned int
copy_uchar6(d, s, n)
uchar6 *d;
uchar6 *s;
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++) {
    d[i] = s[i];
    sum += d[i];
  }
  return sum;
}

static int
use_byte6(i, x)
int i;
int x;
{
  store_char6_index(i, x);
  b6.c0 = (int6)x;
  b6.c1 = (int6)(x + 1);
  b6.c2 = (int6)(x + 2);
  b6.c3 = (int6)(x + 3);
  b6.c4 = (int6)(x + 4);
  b6.c5 = (int6)(x + 5);
  b6.u0 = (uchar6)x;
  b6.u1 = (uchar6)(x + 1);
  b6.u2 = (uchar6)(x + 2);
  b6.u3 = (uchar6)(x + 3);
  b6.u4 = (uchar6)(x + 4);
  b6.u5 = (uchar6)(x + 5);
  return load_char6_index(i)
      + (int)load_uchar6_index(i)
      + load_char6_const_cross()
      + load6_0() + load6_1() + load6_2()
      + load6_3() + load6_4() + load6_5()
      + (int)loadu6_0() + (int)loadu6_1() + (int)loadu6_2()
      + (int)loadu6_3() + (int)loadu6_4() + (int)loadu6_5();
}

/*
 * Direct array loads: every 6-bit position in the first two words.
 */

static int load_s6_0()  { return s6[0]; }
static int load_s6_1()  { return s6[1]; }
static int load_s6_2()  { return s6[2]; }
static int load_s6_3()  { return s6[3]; }
static int load_s6_4()  { return s6[4]; }
static int load_s6_5()  { return s6[5]; }
static int load_s6_6()  { return s6[6]; }
static int load_s6_7()  { return s6[7]; }
static int load_s6_8()  { return s6[8]; }
static int load_s6_9()  { return s6[9]; }
static int load_s6_10() { return s6[10]; }
static int load_s6_11() { return s6[11]; }
static int load_s6_12() { return s6[12]; }

static unsigned int load_u6_0()  { return u6[0]; }
static unsigned int load_u6_1()  { return u6[1]; }
static unsigned int load_u6_2()  { return u6[2]; }
static unsigned int load_u6_3()  { return u6[3]; }
static unsigned int load_u6_4()  { return u6[4]; }
static unsigned int load_u6_5()  { return u6[5]; }
static unsigned int load_u6_6()  { return u6[6]; }
static unsigned int load_u6_7()  { return u6[7]; }
static unsigned int load_u6_8()  { return u6[8]; }
static unsigned int load_u6_9()  { return u6[9]; }
static unsigned int load_u6_10() { return u6[10]; }
static unsigned int load_u6_11() { return u6[11]; }
static unsigned int load_u6_12() { return u6[12]; }

/*
 * Direct array stores.
 */

static void store_s6_0(x)  int x; { s6[0] = (int6)x; }
static void store_s6_1(x)  int x; { s6[1] = (int6)x; }
static void store_s6_2(x)  int x; { s6[2] = (int6)x; }
static void store_s6_3(x)  int x; { s6[3] = (int6)x; }
static void store_s6_4(x)  int x; { s6[4] = (int6)x; }
static void store_s6_5(x)  int x; { s6[5] = (int6)x; }
static void store_s6_6(x)  int x; { s6[6] = (int6)x; }
static void store_s6_7(x)  int x; { s6[7] = (int6)x; }
static void store_s6_8(x)  int x; { s6[8] = (int6)x; }
static void store_s6_9(x)  int x; { s6[9] = (int6)x; }
static void store_s6_10(x) int x; { s6[10] = (int6)x; }
static void store_s6_11(x) int x; { s6[11] = (int6)x; }
static void store_s6_12(x) int x; { s6[12] = (int6)x; }

static void store_u6_0(x)  unsigned int x; { u6[0] = (uchar6)x; }
static void store_u6_1(x)  unsigned int x; { u6[1] = (uchar6)x; }
static void store_u6_2(x)  unsigned int x; { u6[2] = (uchar6)x; }
static void store_u6_3(x)  unsigned int x; { u6[3] = (uchar6)x; }
static void store_u6_4(x)  unsigned int x; { u6[4] = (uchar6)x; }
static void store_u6_5(x)  unsigned int x; { u6[5] = (uchar6)x; }
static void store_u6_6(x)  unsigned int x; { u6[6] = (uchar6)x; }
static void store_u6_7(x)  unsigned int x; { u6[7] = (uchar6)x; }
static void store_u6_8(x)  unsigned int x; { u6[8] = (uchar6)x; }
static void store_u6_9(x)  unsigned int x; { u6[9] = (uchar6)x; }
static void store_u6_10(x) unsigned int x; { u6[10] = (uchar6)x; }
static void store_u6_11(x) unsigned int x; { u6[11] = (uchar6)x; }
static void store_u6_12(x) unsigned int x; { u6[12] = (uchar6)x; }

/*
 * Store-return forms.
 */

static int
store_s6_return(i, x)
int i;
int x;
{
  return s6[i & 017] = (int6)x;
}

static unsigned int
store_u6_return(i, x)
int i;
unsigned int x;
{
  return u6[i & 017] = (uchar6)x;
}

static int
store_s6_const_return(x)
int x;
{
  return s6[5] = (int6)x;
}

static unsigned int
store_u6_const_return(x)
unsigned int x;
{
  return u6[5] = (uchar6)x;
}

/*
 * Static byte-pointer constants.
 */

static int
load_s6_ptr_0()
{
  return *s6p0;
}

static int
load_s6_ptr_5()
{
  return *s6p5;
}

static int
load_s6_ptr_6()
{
  return *s6p6;
}

static int
load_s6_ptr_11()
{
  return *s6p11;
}

static int
load_s6_ptr_12()
{
  return *s6p12;
}

static unsigned int
load_u6_ptr_0()
{
  return *u6p0;
}

static unsigned int
load_u6_ptr_5()
{
  return *u6p5;
}

static unsigned int
load_u6_ptr_6()
{
  return *u6p6;
}

static unsigned int
load_u6_ptr_11()
{
  return *u6p11;
}

static unsigned int
load_u6_ptr_12()
{
  return *u6p12;
}

static void
store_s6_ptr_0(x)
int x;
{
  *s6p0 = (int6)x;
}

static void
store_s6_ptr_5(x)
int x;
{
  *s6p5 = (int6)x;
}

static void
store_s6_ptr_6(x)
int x;
{
  *s6p6 = (int6)x;
}

static void
store_u6_ptr_0(x)
unsigned int x;
{
  *u6p0 = (uchar6)x;
}

static void
store_u6_ptr_5(x)
unsigned int x;
{
  *u6p5 = (uchar6)x;
}

static void
store_u6_ptr_6(x)
unsigned int x;
{
  *u6p6 = (uchar6)x;
}

/*
 * Struct field pointer constants.
 */

static int load_b6p_c0() { return *b6cp0; }
static int load_b6p_c1() { return *b6cp1; }
static int load_b6p_c2() { return *b6cp2; }
static int load_b6p_c3() { return *b6cp3; }
static int load_b6p_c4() { return *b6cp4; }
static int load_b6p_c5() { return *b6cp5; }

static unsigned int load_b6p_u0() { return *b6up0; }
static unsigned int load_b6p_u1() { return *b6up1; }
static unsigned int load_b6p_u2() { return *b6up2; }
static unsigned int load_b6p_u3() { return *b6up3; }
static unsigned int load_b6p_u4() { return *b6up4; }
static unsigned int load_b6p_u5() { return *b6up5; }

static void store_b6p_c0(x) int x; { *b6cp0 = (int6)x; }
static void store_b6p_c1(x) int x; { *b6cp1 = (int6)x; }
static void store_b6p_c2(x) int x; { *b6cp2 = (int6)x; }
static void store_b6p_c3(x) int x; { *b6cp3 = (int6)x; }
static void store_b6p_c4(x) int x; { *b6cp4 = (int6)x; }
static void store_b6p_c5(x) int x; { *b6cp5 = (int6)x; }

static void store_b6p_u0(x) unsigned int x; { *b6up0 = (uchar6)x; }
static void store_b6p_u1(x) unsigned int x; { *b6up1 = (uchar6)x; }
static void store_b6p_u2(x) unsigned int x; { *b6up2 = (uchar6)x; }
static void store_b6p_u3(x) unsigned int x; { *b6up3 = (uchar6)x; }
static void store_b6p_u4(x) unsigned int x; { *b6up4 = (uchar6)x; }
static void store_b6p_u5(x) unsigned int x; { *b6up5 = (uchar6)x; }

/*
 * Pointer-indexed dynamic loads and stores.
 */

static int
load_char6_masked(i)
int i;
{
  return s6[i & 017];
}

static unsigned int
load_uchar6_masked(i)
int i;
{
  return u6[i & 017];
}

static int
load_char6_pointer(p, i)
int6 *p;
int i;
{
  return p[i];
}

static unsigned int
load_uchar6_pointer(p, i)
uchar6 *p;
int i;
{
  return p[i];
}

static void
store_char6_pointer(p, i, x)
int6 *p;
int i;
int x;
{
  p[i] = (int6)x;
}

static void
store_uchar6_pointer(p, i, x)
uchar6 *p;
int i;
unsigned int x;
{
  p[i] = (uchar6)x;
}

static int
load_char6_index_plus_1(i)
int i;
{
  return s6[(i + 1) & 017];
}

static int
load_char6_index_plus_5(i)
int i;
{
  return s6[(i + 5) & 017];
}

static int
load_char6_index_minus_1(i)
int i;
{
  return s6[(i - 1) & 017];
}

static unsigned int
load_uchar6_index_plus_1(i)
int i;
{
  return u6[(i + 1) & 017];
}

static unsigned int
load_uchar6_index_plus_5(i)
int i;
{
  return u6[(i + 5) & 017];
}

static unsigned int
load_uchar6_index_minus_1(i)
int i;
{
  return u6[(i - 1) & 017];
}

static void
store_char6_index_plus_1(i, x)
int i;
int x;
{
  s6[(i + 1) & 017] = (int6)x;
}

static void
store_char6_index_plus_5(i, x)
int i;
int x;
{
  s6[(i + 5) & 017] = (int6)x;
}

static void
store_char6_index_minus_1(i, x)
int i;
int x;
{
  s6[(i - 1) & 017] = (int6)x;
}

static void
store_uchar6_index_plus_1(i, x)
int i;
unsigned int x;
{
  u6[(i + 1) & 017] = (uchar6)x;
}

static void
store_uchar6_index_plus_5(i, x)
int i;
unsigned int x;
{
  u6[(i + 5) & 017] = (uchar6)x;
}

static void
store_uchar6_index_minus_1(i, x)
int i;
unsigned int x;
{
  u6[(i - 1) & 017] = (uchar6)x;
}

/*
 * Address-of element forms.
 */

static int6 *
addr_s6_0()
{
  return &s6[0];
}

static int6 *
addr_s6_5()
{
  return &s6[5];
}

static int6 *
addr_s6_6()
{
  return &s6[6];
}

static int6 *
addr_s6_index(i)
int i;
{
  return &s6[i & 017];
}

static uchar6 *
addr_u6_0()
{
  return &u6[0];
}

static uchar6 *
addr_u6_5()
{
  return &u6[5];
}

static uchar6 *
addr_u6_6()
{
  return &u6[6];
}

static uchar6 *
addr_u6_index(i)
int i;
{
  return &u6[i & 017];
}

static int6 *
addr_b6_c0()
{
  return &b6.c0;
}

static int6 *
addr_b6_c5()
{
  return &b6.c5;
}

static uchar6 *
addr_b6_u0()
{
  return &b6.u0;
}

static uchar6 *
addr_b6_u5()
{
  return &b6.u5;
}

/*
 * Loads and stores through computed element addresses.
 */

static int
addr_load_s6(i)
int i;
{
  int6 *p;

  p = &s6[i & 017];
  return *p;
}

static unsigned int
addr_load_u6(i)
int i;
{
  uchar6 *p;

  p = &u6[i & 017];
  return *p;
}

static void
addr_store_s6(i, x)
int i;
int x;
{
  int6 *p;

  p = &s6[i & 017];
  *p = (int6)x;
}

static void
addr_store_u6(i, x)
int i;
unsigned int x;
{
  uchar6 *p;

  p = &u6[i & 017];
  *p = (uchar6)x;
}

/*
 * Struct field loads and stores.
 */

static int b6_load_c0() { return b6.c0; }
static int b6_load_c1() { return b6.c1; }
static int b6_load_c2() { return b6.c2; }
static int b6_load_c3() { return b6.c3; }
static int b6_load_c4() { return b6.c4; }
static int b6_load_c5() { return b6.c5; }

static unsigned int b6_load_u0() { return b6.u0; }
static unsigned int b6_load_u1() { return b6.u1; }
static unsigned int b6_load_u2() { return b6.u2; }
static unsigned int b6_load_u3() { return b6.u3; }
static unsigned int b6_load_u4() { return b6.u4; }
static unsigned int b6_load_u5() { return b6.u5; }

static void b6_store_c0(x) int x; { b6.c0 = (int6)x; }
static void b6_store_c1(x) int x; { b6.c1 = (int6)x; }
static void b6_store_c2(x) int x; { b6.c2 = (int6)x; }
static void b6_store_c3(x) int x; { b6.c3 = (int6)x; }
static void b6_store_c4(x) int x; { b6.c4 = (int6)x; }
static void b6_store_c5(x) int x; { b6.c5 = (int6)x; }

static void b6_store_u0(x) unsigned int x; { b6.u0 = (uchar6)x; }
static void b6_store_u1(x) unsigned int x; { b6.u1 = (uchar6)x; }
static void b6_store_u2(x) unsigned int x; { b6.u2 = (uchar6)x; }
static void b6_store_u3(x) unsigned int x; { b6.u3 = (uchar6)x; }
static void b6_store_u4(x) unsigned int x; { b6.u4 = (uchar6)x; }
static void b6_store_u5(x) unsigned int x; { b6.u5 = (uchar6)x; }

static int
b6_sum_signed()
{
  return b6.c0 + b6.c1 + b6.c2 + b6.c3 + b6.c4 + b6.c5;
}

static unsigned int
b6_sum_unsigned()
{
  return b6.u0 + b6.u1 + b6.u2 + b6.u3 + b6.u4 + b6.u5;
}

static int
b6_sum_mixed()
{
  return b6.c0 + (int)b6.u0 + b6.c5 + (int)b6.u5;
}

/*
 * Struct arguments and struct pointers.
 */

static int
arg6_c0(x)
struct bytes6 x;
{
  return x.c0;
}

static int
arg6_c5(x)
struct bytes6 x;
{
  return x.c5;
}

static unsigned int
arg6_u0(x)
struct bytes6 x;
{
  return x.u0;
}

static unsigned int
arg6_u5(x)
struct bytes6 x;
{
  return x.u5;
}

static int
arg6_sum(x)
struct bytes6 x;
{
  return x.c0 + x.c1 + x.c2 + x.c3 + x.c4 + x.c5
      + (int)x.u0 + (int)x.u1 + (int)x.u2
      + (int)x.u3 + (int)x.u4 + (int)x.u5;
}

static int
ptr6_c0(p)
struct bytes6 *p;
{
  return p->c0;
}

static int
ptr6_c5(p)
struct bytes6 *p;
{
  return p->c5;
}

static unsigned int
ptr6_u0(p)
struct bytes6 *p;
{
  return p->u0;
}

static unsigned int
ptr6_u5(p)
struct bytes6 *p;
{
  return p->u5;
}

static void
ptr6_store_c0(p, x)
struct bytes6 *p;
int x;
{
  p->c0 = (int6)x;
}

static void
ptr6_store_c5(p, x)
struct bytes6 *p;
int x;
{
  p->c5 = (int6)x;
}

static void
ptr6_store_u0(p, x)
struct bytes6 *p;
unsigned int x;
{
  p->u0 = (uchar6)x;
}

static void
ptr6_store_u5(p, x)
struct bytes6 *p;
unsigned int x;
{
  p->u5 = (uchar6)x;
}

/*
 * Struct array references.
 */

static int
b6a_load_c0(i)
int i;
{
  return b6a[i & 7].c0;
}

static int
b6a_load_c5(i)
int i;
{
  return b6a[i & 7].c5;
}

static unsigned int
b6a_load_u0(i)
int i;
{
  return b6a[i & 7].u0;
}

static unsigned int
b6a_load_u5(i)
int i;
{
  return b6a[i & 7].u5;
}

static void
b6a_store_c0(i, x)
int i;
int x;
{
  b6a[i & 7].c0 = (int6)x;
}

static void
b6a_store_c5(i, x)
int i;
int x;
{
  b6a[i & 7].c5 = (int6)x;
}

static void
b6a_store_u0(i, x)
int i;
unsigned int x;
{
  b6a[i & 7].u0 = (uchar6)x;
}

static void
b6a_store_u5(i, x)
int i;
unsigned int x;
{
  b6a[i & 7].u5 = (uchar6)x;
}

/*
 * Mixed struct field references.
 */

static int
mb6_load_c0()
{
  return mb6.c0;
}

static unsigned int
mb6_load_u0()
{
  return mb6.u0;
}

static int
mb6_load_c1()
{
  return mb6.c1;
}

static unsigned int
mb6_load_u1()
{
  return mb6.u1;
}

static int
mb6_load_c2()
{
  return mb6.c2;
}

static unsigned int
mb6_load_u2()
{
  return mb6.u2;
}

static int
mb6_sum()
{
  return mb6.filler + mb6.c0 + (int)mb6.u0
      + mb6.c1 + (int)mb6.u1
      + mb6.word + mb6.c2 + (int)mb6.u2;
}

static void
mb6_store_all(x)
int x;
{
  mb6.c0 = (int6)x;
  mb6.u0 = (uchar6)(x + 1);
  mb6.c1 = (int6)(x + 2);
  mb6.u1 = (uchar6)(x + 3);
  mb6.c2 = (int6)(x + 4);
  mb6.u2 = (uchar6)(x + 5);
}

/*
 * Volatile loads and stores.
 */

static int
vload_s6(i)
int i;
{
  return vs6[i & 017];
}

static unsigned int
vload_u6(i)
int i;
{
  return vu6[i & 017];
}

static void
vstore_s6(i, x)
int i;
int x;
{
  vs6[i & 017] = (int6)x;
}

static void
vstore_u6(i, x)
int i;
unsigned int x;
{
  vu6[i & 017] = (uchar6)x;
}

static int
vload_s6_5()
{
  return vs6[5];
}

static unsigned int
vload_u6_5()
{
  return vu6[5];
}

static void
vstore_s6_5(x)
int x;
{
  vs6[5] = (int6)x;
}

static void
vstore_u6_5(x)
unsigned int x;
{
  vu6[5] = (uchar6)x;
}

/*
 * Widening and truncation.
 */

static int
extend_char6(p)
int6 *p;
{
  int x;

  x = *p;
  return x;
}

static unsigned int
extend_uchar6(p)
uchar6 *p;
{
  unsigned int x;

  x = *p;
  return x;
}

static int
extend_char6_array(i)
int i;
{
  int x;

  x = s6[i & 017];
  return x;
}

static unsigned int
extend_uchar6_array(i)
int i;
{
  unsigned int x;

  x = u6[i & 017];
  return x;
}

static void
trunc_store_char6(p, x)
int6 *p;
int x;
{
  *p = (int6)x;
}

static void
trunc_store_uchar6(p, x)
uchar6 *p;
unsigned int x;
{
  *p = (uchar6)x;
}

static int
trunc_store_char6_return(p, x)
int6 *p;
int x;
{
  return *p = (int6)x;
}

static unsigned int
trunc_store_uchar6_return(p, x)
uchar6 *p;
unsigned int x;
{
  return *p = (uchar6)x;
}

/*
 * Arithmetic and comparisons after extraction.
 */

static int
char6_plus(i, x)
int i;
int x;
{
  return s6[i & 017] + x;
}

static unsigned int
uchar6_plus(i, x)
int i;
unsigned int x;
{
  return u6[i & 017] + x;
}

static int
char6_sub(i, x)
int i;
int x;
{
  return s6[i & 017] - x;
}

static unsigned int
uchar6_xor(i, x)
int i;
unsigned int x;
{
  return u6[i & 017] ^ x;
}

static int
char6_eq_zero(i)
int i;
{
  return s6[i & 017] == 0;
}

static int
char6_lt_zero(i)
int i;
{
  return s6[i & 017] < 0;
}

static int
uchar6_eq_zero(i)
int i;
{
  return u6[i & 017] == 0;
}

static int
uchar6_gt_31(i)
int i;
{
  return u6[i & 017] > 31;
}

static int
char6_range(i)
int i;
{
  int x;

  x = s6[i & 017];
  if (x < -16)
    return -1;
  if (x > 15)
    return 1;
  return 0;
}

static int
uchar6_range(i)
int i;
{
  unsigned int x;

  x = u6[i & 017];
  if (x < 16)
    return -1;
  if (x > 47)
    return 1;
  return 0;
}

/*
 * Pointer-walk forms.
 */

static int
postinc_load_char6(p)
int6 *p;
{
  return *p++;
}

static unsigned int
postinc_load_uchar6(p)
uchar6 *p;
{
  return *p++;
}

static void
postinc_store_char6(p, x)
int6 *p;
int x;
{
  *p++ = (int6)x;
}

static void
postinc_store_uchar6(p, x)
uchar6 *p;
unsigned int x;
{
  *p++ = (uchar6)x;
}

static int
walk_sum_char6(p, n)
int6 *p;
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += *p++;
  return sum;
}

static unsigned int
walk_sum_uchar6(p, n)
uchar6 *p;
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += *p++;
  return sum;
}

static void
walk_zero_char6(p, n)
int6 *p;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

static void
walk_zero_uchar6(p, n)
uchar6 *p;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

/*
 * Loops over global arrays.
 */

static int
sum_char6_global(n)
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += s6[i & 017];
  return sum;
}

static unsigned int
sum_uchar6_global(n)
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += u6[i & 017];
  return sum;
}

static void
zero_char6_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    s6[i & 017] = 0;
}

static void
zero_uchar6_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    u6[i & 017] = 0;
}

static void
set_char6_index_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    s6[i & 017] = (int6)i;
}

static void
set_uchar6_index_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    u6[i & 017] = (uchar6)i;
}

static int
copy_char6_global(n)
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++) {
    s6[(i + 18) & 035] = s6[i & 017];
    sum += s6[(i + 18) & 035];
  }
  return sum;
}

static unsigned int
copy_uchar6_global(n)
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++) {
    u6[(i + 18) & 035] = u6[i & 017];
    sum += u6[(i + 18) & 035];
  }
  return sum;
}

/*
 * Loops over struct arrays.
 */

static int
sum_b6a_signed(n)
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += b6a[i & 7].c0 + b6a[i & 7].c5;
  return sum;
}

static unsigned int
sum_b6a_unsigned(n)
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += b6a[i & 7].u0 + b6a[i & 7].u5;
  return sum;
}

static void
zero_b6a_signed(n)
int n;
{
  int i;

  for (i = 0; i < n; i++) {
    b6a[i & 7].c0 = 0;
    b6a[i & 7].c1 = 0;
    b6a[i & 7].c2 = 0;
    b6a[i & 7].c3 = 0;
    b6a[i & 7].c4 = 0;
    b6a[i & 7].c5 = 0;
  }
}

static void
zero_b6a_unsigned(n)
int n;
{
  int i;

  for (i = 0; i < n; i++) {
    b6a[i & 7].u0 = 0;
    b6a[i & 7].u1 = 0;
    b6a[i & 7].u2 = 0;
    b6a[i & 7].u3 = 0;
    b6a[i & 7].u4 = 0;
    b6a[i & 7].u5 = 0;
  }
}

static void
copy_b6a(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    b6a[(i + 1) & 7] = b6a[i & 7];
}

/*
 * Calls and barriers.
 */

static int
load_char6_after_call(i)
int i;
{
  clobber();
  return s6[i & 017];
}

static unsigned int
load_uchar6_after_call(i)
int i;
{
  clobber();
  return u6[i & 017];
}

static void
store_char6_after_call(i, x)
int i;
int x;
{
  clobber();
  s6[i & 017] = (int6)x;
}

static void
store_uchar6_after_call(i, x)
int i;
unsigned int x;
{
  clobber();
  u6[i & 017] = (uchar6)x;
}

static int
load_char6_call_index()
{
  return s6[f() & 017];
}

static unsigned int
load_uchar6_call_index()
{
  return u6[f() & 017];
}

static void
store_char6_call_index(x)
int x;
{
  s6[f() & 017] = (int6)x;
}

static void
store_uchar6_call_index(x)
unsigned int x;
{
  u6[f() & 017] = (uchar6)x;
}

/*
 * Dynamic pointer adjustment with non-power-of-two bytes-per-word.
 */

static int6 *
add_char6_pointer(p, n)
int6 *p;
int n;
{
  return p + n;
}

static uchar6 *
add_uchar6_pointer(p, n)
uchar6 *p;
int n;
{
  return p + n;
}

static int6 *
sub_char6_pointer(p, n)
int6 *p;
int n;
{
  return p - n;
}

static uchar6 *
sub_uchar6_pointer(p, n)
uchar6 *p;
int n;
{
  return p - n;
}

static int6 *
add_char6_pointer_const_1(p)
int6 *p;
{
  return p + 1;
}

static int6 *
add_char6_pointer_const_5(p)
int6 *p;
{
  return p + 5;
}

static int6 *
add_char6_pointer_const_6(p)
int6 *p;
{
  return p + 6;
}

static int6 *
add_char6_pointer_const_7(p)
int6 *p;
{
  return p + 7;
}

static uchar6 *
add_uchar6_pointer_const_1(p)
uchar6 *p;
{
  return p + 1;
}

static uchar6 *
add_uchar6_pointer_const_5(p)
uchar6 *p;
{
  return p + 5;
}

static uchar6 *
add_uchar6_pointer_const_6(p)
uchar6 *p;
{
  return p + 6;
}

static uchar6 *
add_uchar6_pointer_const_7(p)
uchar6 *p;
{
  return p + 7;
}

/*
 * Combined smoke use.
 */

static int
use_byte6_more(i, x)
int i;
int x;
{
  int sum;

  store_char6_index(i, x);
  store_char6_index_plus_1(i, x + 1);
  store_uchar6_index_plus_5(i, (unsigned int)(x + 5));

  b6_store_c0(x);
  b6_store_c1(x + 1);
  b6_store_c2(x + 2);
  b6_store_c3(x + 3);
  b6_store_c4(x + 4);
  b6_store_c5(x + 5);

  b6_store_u0((unsigned int)x);
  b6_store_u1((unsigned int)(x + 1));
  b6_store_u2((unsigned int)(x + 2));
  b6_store_u3((unsigned int)(x + 3));
  b6_store_u4((unsigned int)(x + 4));
  b6_store_u5((unsigned int)(x + 5));

  sum = 0;
  sum += load_char6_masked(i);
  sum += (int)load_uchar6_masked(i);
  sum += load_char6_const_cross();
  sum += b6_sum_signed();
  sum += (int)b6_sum_unsigned();
  sum += char6_plus(i, x);
  sum += (int)uchar6_plus(i, (unsigned int)x);
  sum += char6_range(i);
  sum += uchar6_range(i);

  return sum;
}
