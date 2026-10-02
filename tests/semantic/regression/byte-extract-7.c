#include "insns.h"

/*
 * 7-bit packed byte extraction/store coverage.
 *
 * File:
 *   misc/byte-extract-7.c
 *
 * Five 7-bit bytes fit in one 36-bit word with one spare bit.
 * This test deliberately covers each useful byte position in a word,
 * crosses word boundaries, and exercises dynamic byte-pointer
 * adjustment.
 *
 * It stresses:
 *   - signed and unsigned 7-bit machine byte loads
 *   - every 7-bit byte position inside a 36-bit word
 *   - crossing 36-bit word boundaries
 *   - static byte-pointer constants
 *   - pointer indexing
 *   - stores and store-return forms
 *   - copy/sum/zero loops
 *   - pointer-walk forms
 *   - widening and truncation around char7/uchar7
 *
 * 7-bit pointer arithmetic is especially useful on PDP-6/KA10 because
 * there are five bytes per word.  Dynamic pointer adjustment must not
 * require KL10 ADJBP.
 */

extern int f(void);
extern unsigned int uf(void);
extern void clobber(void);

struct bytes7 {
  char7 c0, c1, c2, c3, c4;
  uchar7 u0, u1, u2, u3, u4;
};

struct signed7 {
  char7 c0, c1, c2, c3, c4;
};

struct unsigned7 {
  uchar7 u0, u1, u2, u3, u4;
};

struct mixed7 {
  int filler;
  char7 c0;
  uchar7 u0;
  char7 c1;
  uchar7 u1;
  int word;
  char7 c2;
  uchar7 u2;
};

static char7 s7[30];
static uchar7 u7[30];
static volatile char7 vs7[30];
static volatile uchar7 vu7[30];

static struct bytes7 b7;
static struct signed7 sb7;
static struct unsigned7 ub7;
static struct mixed7 mb7;

static struct bytes7 b7a[8];
static struct signed7 sb7a[8];
static struct unsigned7 ub7a[8];
static struct mixed7 mb7a[8];

/*
 * Do not keep file-scope initializers for pointers to non-word 7-bit
 * elements here.  This old backend cannot yet fold several packed-byte
 * addresses into static pointer constants.  The tests below still form
 * the same constant element addresses, but do so inside functions.
 */

/*
 * Original seed shape.
 */

#define LOAD7(N)                                                \
static int                                                      \
load7_##N()                                                     \
{                                                               \
  return b7.c##N;                                               \
}                                                               \
static unsigned int                                             \
loadu7_##N()                                                    \
{                                                               \
  return b7.u##N;                                               \
}

LOAD7(0)
LOAD7(1)
LOAD7(2)
LOAD7(3)
LOAD7(4)

static int
load_char7_index(i)
int i;
{
  return s7[i];
}

static unsigned int
load_uchar7_index(i)
int i;
{
  return u7[i];
}

static int
load_char7_const_cross()
{
  return s7[0] + s7[4] + s7[5] + s7[9] + s7[10];
}

static void
store_char7_index(i, x)
int i;
int x;
{
  s7[i] = (char7)x;
  u7[i] = (uchar7)(x + 1);
}

static int
copy_char7(d, s, n)
char7 *d;
char7 *s;
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
copy_uchar7(d, s, n)
uchar7 *d;
uchar7 *s;
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
use_byte7(i, x)
int i;
int x;
{
  store_char7_index(i, x);
  b7.c0 = (char7)x;
  b7.c1 = (char7)(x + 1);
  b7.c2 = (char7)(x + 2);
  b7.c3 = (char7)(x + 3);
  b7.c4 = (char7)(x + 4);
  b7.u0 = (uchar7)x;
  b7.u1 = (uchar7)(x + 1);
  b7.u2 = (uchar7)(x + 2);
  b7.u3 = (uchar7)(x + 3);
  b7.u4 = (uchar7)(x + 4);
  return load_char7_index(i)
      + (int)load_uchar7_index(i)
      + load_char7_const_cross()
      + load7_0() + load7_1() + load7_2()
      + load7_3() + load7_4()
      + (int)loadu7_0() + (int)loadu7_1()
      + (int)loadu7_2() + (int)loadu7_3()
      + (int)loadu7_4();
}

/*
 * Direct array loads: every 7-bit position in the first words.
 */

static int load_s7_0()  { return s7[0]; }
static int load_s7_1()  { return s7[1]; }
static int load_s7_2()  { return s7[2]; }
static int load_s7_3()  { return s7[3]; }
static int load_s7_4()  { return s7[4]; }
static int load_s7_5()  { return s7[5]; }
static int load_s7_6()  { return s7[6]; }
static int load_s7_7()  { return s7[7]; }
static int load_s7_8()  { return s7[8]; }
static int load_s7_9()  { return s7[9]; }
static int load_s7_10() { return s7[10]; }

static unsigned int load_u7_0()  { return u7[0]; }
static unsigned int load_u7_1()  { return u7[1]; }
static unsigned int load_u7_2()  { return u7[2]; }
static unsigned int load_u7_3()  { return u7[3]; }
static unsigned int load_u7_4()  { return u7[4]; }
static unsigned int load_u7_5()  { return u7[5]; }
static unsigned int load_u7_6()  { return u7[6]; }
static unsigned int load_u7_7()  { return u7[7]; }
static unsigned int load_u7_8()  { return u7[8]; }
static unsigned int load_u7_9()  { return u7[9]; }
static unsigned int load_u7_10() { return u7[10]; }

/*
 * Direct array stores.
 */

static void store_s7_0(x)  int x; { s7[0] = (char7)x; }
static void store_s7_1(x)  int x; { s7[1] = (char7)x; }
static void store_s7_2(x)  int x; { s7[2] = (char7)x; }
static void store_s7_3(x)  int x; { s7[3] = (char7)x; }
static void store_s7_4(x)  int x; { s7[4] = (char7)x; }
static void store_s7_5(x)  int x; { s7[5] = (char7)x; }
static void store_s7_6(x)  int x; { s7[6] = (char7)x; }
static void store_s7_7(x)  int x; { s7[7] = (char7)x; }
static void store_s7_8(x)  int x; { s7[8] = (char7)x; }
static void store_s7_9(x)  int x; { s7[9] = (char7)x; }
static void store_s7_10(x) int x; { s7[10] = (char7)x; }

static void store_u7_0(x)  unsigned int x; { u7[0] = (uchar7)x; }
static void store_u7_1(x)  unsigned int x; { u7[1] = (uchar7)x; }
static void store_u7_2(x)  unsigned int x; { u7[2] = (uchar7)x; }
static void store_u7_3(x)  unsigned int x; { u7[3] = (uchar7)x; }
static void store_u7_4(x)  unsigned int x; { u7[4] = (uchar7)x; }
static void store_u7_5(x)  unsigned int x; { u7[5] = (uchar7)x; }
static void store_u7_6(x)  unsigned int x; { u7[6] = (uchar7)x; }
static void store_u7_7(x)  unsigned int x; { u7[7] = (uchar7)x; }
static void store_u7_8(x)  unsigned int x; { u7[8] = (uchar7)x; }
static void store_u7_9(x)  unsigned int x; { u7[9] = (uchar7)x; }
static void store_u7_10(x) unsigned int x; { u7[10] = (uchar7)x; }

/*
 * Store-return forms.
 */

static int
store_s7_return(i, x)
int i;
int x;
{
  return s7[i & 017] = (char7)x;
}

static unsigned int
store_u7_return(i, x)
int i;
unsigned int x;
{
  return u7[i & 017] = (uchar7)x;
}

static int
store_s7_const_return(x)
int x;
{
  return s7[4] = (char7)x;
}

static unsigned int
store_u7_const_return(x)
unsigned int x;
{
  return u7[4] = (uchar7)x;
}

/*
 * Static byte-pointer constants.
 */

static int
load_s7_ptr_0()
{
  char7 *p;

  p = &s7[0];
  return *p;
}
static int
load_s7_ptr_4()
{
  char7 *p;

  p = &s7[4];
  return *p;
}
static int
load_s7_ptr_5()
{
  char7 *p;

  p = &s7[5];
  return *p;
}
static int
load_s7_ptr_9()
{
  char7 *p;

  p = &s7[9];
  return *p;
}
static int
load_s7_ptr_10()
{
  char7 *p;

  p = &s7[10];
  return *p;
}
static unsigned int
load_u7_ptr_0()
{
  uchar7 *p;

  p = &u7[0];
  return *p;
}
static unsigned int
load_u7_ptr_4()
{
  uchar7 *p;

  p = &u7[4];
  return *p;
}
static unsigned int
load_u7_ptr_5()
{
  uchar7 *p;

  p = &u7[5];
  return *p;
}
static unsigned int
load_u7_ptr_9()
{
  uchar7 *p;

  p = &u7[9];
  return *p;
}
static unsigned int
load_u7_ptr_10()
{
  uchar7 *p;

  p = &u7[10];
  return *p;
}
static void
store_s7_ptr_0(x)
int x;
{
  char7 *p;

  p = &s7[0];
  *p = (char7)x;
}
static void
store_s7_ptr_4(x)
int x;
{
  char7 *p;

  p = &s7[4];
  *p = (char7)x;
}
static void
store_s7_ptr_5(x)
int x;
{
  char7 *p;

  p = &s7[5];
  *p = (char7)x;
}
static void
store_u7_ptr_0(x)
unsigned int x;
{
  uchar7 *p;

  p = &u7[0];
  *p = (uchar7)x;
}
static void
store_u7_ptr_4(x)
unsigned int x;
{
  uchar7 *p;

  p = &u7[4];
  *p = (uchar7)x;
}
static void
store_u7_ptr_5(x)
unsigned int x;
{
  uchar7 *p;

  p = &u7[5];
  *p = (uchar7)x;
}

/*
 * Struct field pointer constants.
 */

static int
load_b7p_c0()
{
  char7 *p;

  p = &b7.c0;
  return *p;
}
static int
load_b7p_c1()
{
  char7 *p;

  p = &b7.c1;
  return *p;
}
static int
load_b7p_c2()
{
  char7 *p;

  p = &b7.c2;
  return *p;
}
static int
load_b7p_c3()
{
  char7 *p;

  p = &b7.c3;
  return *p;
}
static int
load_b7p_c4()
{
  char7 *p;

  p = &b7.c4;
  return *p;
}
static unsigned int
load_b7p_u0()
{
  uchar7 *p;

  p = &b7.u0;
  return *p;
}
static unsigned int
load_b7p_u1()
{
  uchar7 *p;

  p = &b7.u1;
  return *p;
}
static unsigned int
load_b7p_u2()
{
  uchar7 *p;

  p = &b7.u2;
  return *p;
}
static unsigned int
load_b7p_u3()
{
  uchar7 *p;

  p = &b7.u3;
  return *p;
}
static unsigned int
load_b7p_u4()
{
  uchar7 *p;

  p = &b7.u4;
  return *p;
}
static void
store_b7p_c0(x)
int x;
{
  char7 *p;

  p = &b7.c0;
  *p = (char7)x;
}
static void
store_b7p_c1(x)
int x;
{
  char7 *p;

  p = &b7.c1;
  *p = (char7)x;
}
static void
store_b7p_c2(x)
int x;
{
  char7 *p;

  p = &b7.c2;
  *p = (char7)x;
}
static void
store_b7p_c3(x)
int x;
{
  char7 *p;

  p = &b7.c3;
  *p = (char7)x;
}
static void
store_b7p_c4(x)
int x;
{
  char7 *p;

  p = &b7.c4;
  *p = (char7)x;
}
static void
store_b7p_u0(x)
unsigned int x;
{
  uchar7 *p;

  p = &b7.u0;
  *p = (uchar7)x;
}
static void
store_b7p_u1(x)
unsigned int x;
{
  uchar7 *p;

  p = &b7.u1;
  *p = (uchar7)x;
}
static void
store_b7p_u2(x)
unsigned int x;
{
  uchar7 *p;

  p = &b7.u2;
  *p = (uchar7)x;
}
static void
store_b7p_u3(x)
unsigned int x;
{
  uchar7 *p;

  p = &b7.u3;
  *p = (uchar7)x;
}
static void
store_b7p_u4(x)
unsigned int x;
{
  uchar7 *p;

  p = &b7.u4;
  *p = (uchar7)x;
}

/*
 * Pointer-indexed dynamic loads and stores.
 */

static int
load_char7_masked(i)
int i;
{
  return s7[i & 017];
}

static unsigned int
load_uchar7_masked(i)
int i;
{
  return u7[i & 017];
}

static int
load_char7_pointer(p, i)
char7 *p;
int i;
{
  return p[i];
}

static unsigned int
load_uchar7_pointer(p, i)
uchar7 *p;
int i;
{
  return p[i];
}

static void
store_char7_pointer(p, i, x)
char7 *p;
int i;
int x;
{
  p[i] = (char7)x;
}

static void
store_uchar7_pointer(p, i, x)
uchar7 *p;
int i;
unsigned int x;
{
  p[i] = (uchar7)x;
}

static int
load_char7_index_plus_1(i)
int i;
{
  return s7[(i + 1) & 017];
}

static int
load_char7_index_plus_4(i)
int i;
{
  return s7[(i + 4) & 017];
}

static int
load_char7_index_plus_5(i)
int i;
{
  return s7[(i + 5) & 017];
}

static int
load_char7_index_minus_1(i)
int i;
{
  return s7[(i - 1) & 017];
}

static unsigned int
load_uchar7_index_plus_1(i)
int i;
{
  return u7[(i + 1) & 017];
}

static unsigned int
load_uchar7_index_plus_4(i)
int i;
{
  return u7[(i + 4) & 017];
}

static unsigned int
load_uchar7_index_plus_5(i)
int i;
{
  return u7[(i + 5) & 017];
}

static unsigned int
load_uchar7_index_minus_1(i)
int i;
{
  return u7[(i - 1) & 017];
}

static void
store_char7_index_plus_1(i, x)
int i;
int x;
{
  s7[(i + 1) & 017] = (char7)x;
}

static void
store_char7_index_plus_4(i, x)
int i;
int x;
{
  s7[(i + 4) & 017] = (char7)x;
}

static void
store_char7_index_plus_5(i, x)
int i;
int x;
{
  s7[(i + 5) & 017] = (char7)x;
}

static void
store_char7_index_minus_1(i, x)
int i;
int x;
{
  s7[(i - 1) & 017] = (char7)x;
}

static void
store_uchar7_index_plus_1(i, x)
int i;
unsigned int x;
{
  u7[(i + 1) & 017] = (uchar7)x;
}

static void
store_uchar7_index_plus_4(i, x)
int i;
unsigned int x;
{
  u7[(i + 4) & 017] = (uchar7)x;
}

static void
store_uchar7_index_plus_5(i, x)
int i;
unsigned int x;
{
  u7[(i + 5) & 017] = (uchar7)x;
}

static void
store_uchar7_index_minus_1(i, x)
int i;
unsigned int x;
{
  u7[(i - 1) & 017] = (uchar7)x;
}

/*
 * Address-of element forms.
 */

static char7 *addr_s7_0() { return &s7[0]; }
static char7 *addr_s7_4() { return &s7[4]; }
static char7 *addr_s7_5() { return &s7[5]; }

static char7 *
addr_s7_index(i)
int i;
{
  return &s7[i & 017];
}

static uchar7 *addr_u7_0() { return &u7[0]; }
static uchar7 *addr_u7_4() { return &u7[4]; }
static uchar7 *addr_u7_5() { return &u7[5]; }

static uchar7 *
addr_u7_index(i)
int i;
{
  return &u7[i & 017];
}

static char7 *addr_b7_c0() { return &b7.c0; }
static char7 *addr_b7_c4() { return &b7.c4; }

static uchar7 *addr_b7_u0() { return &b7.u0; }
static uchar7 *addr_b7_u4() { return &b7.u4; }

/*
 * Loads and stores through computed element addresses.
 */

static int
addr_load_s7(i)
int i;
{
  char7 *p;

  p = &s7[i & 017];
  return *p;
}

static unsigned int
addr_load_u7(i)
int i;
{
  uchar7 *p;

  p = &u7[i & 017];
  return *p;
}

static void
addr_store_s7(i, x)
int i;
int x;
{
  char7 *p;

  p = &s7[i & 017];
  *p = (char7)x;
}

static void
addr_store_u7(i, x)
int i;
unsigned int x;
{
  uchar7 *p;

  p = &u7[i & 017];
  *p = (uchar7)x;
}

/*
 * Struct field loads and stores.
 */

static int b7_load_c0() { return b7.c0; }
static int b7_load_c1() { return b7.c1; }
static int b7_load_c2() { return b7.c2; }
static int b7_load_c3() { return b7.c3; }
static int b7_load_c4() { return b7.c4; }

static unsigned int b7_load_u0() { return b7.u0; }
static unsigned int b7_load_u1() { return b7.u1; }
static unsigned int b7_load_u2() { return b7.u2; }
static unsigned int b7_load_u3() { return b7.u3; }
static unsigned int b7_load_u4() { return b7.u4; }

static void b7_store_c0(x) int x; { b7.c0 = (char7)x; }
static void b7_store_c1(x) int x; { b7.c1 = (char7)x; }
static void b7_store_c2(x) int x; { b7.c2 = (char7)x; }
static void b7_store_c3(x) int x; { b7.c3 = (char7)x; }
static void b7_store_c4(x) int x; { b7.c4 = (char7)x; }

static void b7_store_u0(x) unsigned int x; { b7.u0 = (uchar7)x; }
static void b7_store_u1(x) unsigned int x; { b7.u1 = (uchar7)x; }
static void b7_store_u2(x) unsigned int x; { b7.u2 = (uchar7)x; }
static void b7_store_u3(x) unsigned int x; { b7.u3 = (uchar7)x; }
static void b7_store_u4(x) unsigned int x; { b7.u4 = (uchar7)x; }

static int
b7_sum_signed()
{
  return b7.c0 + b7.c1 + b7.c2 + b7.c3 + b7.c4;
}

static unsigned int
b7_sum_unsigned()
{
  return b7.u0 + b7.u1 + b7.u2 + b7.u3 + b7.u4;
}

static int
b7_sum_mixed()
{
  return b7.c0 + (int)b7.u0 + b7.c4 + (int)b7.u4;
}

/*
 * Struct arguments and struct pointers.
 */

static int
arg7_c0(x)
struct bytes7 x;
{
  return x.c0;
}

static int
arg7_c4(x)
struct bytes7 x;
{
  return x.c4;
}

static unsigned int
arg7_u0(x)
struct bytes7 x;
{
  return x.u0;
}

static unsigned int
arg7_u4(x)
struct bytes7 x;
{
  return x.u4;
}

static int
arg7_sum(x)
struct bytes7 x;
{
  return x.c0 + x.c1 + x.c2 + x.c3 + x.c4
      + (int)x.u0 + (int)x.u1 + (int)x.u2
      + (int)x.u3 + (int)x.u4;
}

static int
ptr7_c0(p)
struct bytes7 *p;
{
  return p->c0;
}

static int
ptr7_c4(p)
struct bytes7 *p;
{
  return p->c4;
}

static unsigned int
ptr7_u0(p)
struct bytes7 *p;
{
  return p->u0;
}

static unsigned int
ptr7_u4(p)
struct bytes7 *p;
{
  return p->u4;
}

static void
ptr7_store_c0(p, x)
struct bytes7 *p;
int x;
{
  p->c0 = (char7)x;
}

static void
ptr7_store_c4(p, x)
struct bytes7 *p;
int x;
{
  p->c4 = (char7)x;
}

static void
ptr7_store_u0(p, x)
struct bytes7 *p;
unsigned int x;
{
  p->u0 = (uchar7)x;
}

static void
ptr7_store_u4(p, x)
struct bytes7 *p;
unsigned int x;
{
  p->u4 = (uchar7)x;
}

/*
 * Struct array references.
 */

static int
b7a_load_c0(i)
int i;
{
  return b7a[i & 7].c0;
}

static int
b7a_load_c4(i)
int i;
{
  return b7a[i & 7].c4;
}

static unsigned int
b7a_load_u0(i)
int i;
{
  return b7a[i & 7].u0;
}

static unsigned int
b7a_load_u4(i)
int i;
{
  return b7a[i & 7].u4;
}

static void
b7a_store_c0(i, x)
int i;
int x;
{
  b7a[i & 7].c0 = (char7)x;
}

static void
b7a_store_c4(i, x)
int i;
int x;
{
  b7a[i & 7].c4 = (char7)x;
}

static void
b7a_store_u0(i, x)
int i;
unsigned int x;
{
  b7a[i & 7].u0 = (uchar7)x;
}

static void
b7a_store_u4(i, x)
int i;
unsigned int x;
{
  b7a[i & 7].u4 = (uchar7)x;
}

/*
 * Mixed struct field references.
 */

static int
mb7_load_c0()
{
  return mb7.c0;
}

static unsigned int
mb7_load_u0()
{
  return mb7.u0;
}

static int
mb7_load_c1()
{
  return mb7.c1;
}

static unsigned int
mb7_load_u1()
{
  return mb7.u1;
}

static int
mb7_load_c2()
{
  return mb7.c2;
}

static unsigned int
mb7_load_u2()
{
  return mb7.u2;
}

static int
mb7_sum()
{
  return mb7.filler + mb7.c0 + (int)mb7.u0
      + mb7.c1 + (int)mb7.u1
      + mb7.word + mb7.c2 + (int)mb7.u2;
}

static void
mb7_store_all(x)
int x;
{
  mb7.c0 = (char7)x;
  mb7.u0 = (uchar7)(x + 1);
  mb7.c1 = (char7)(x + 2);
  mb7.u1 = (uchar7)(x + 3);
  mb7.c2 = (char7)(x + 4);
  mb7.u2 = (uchar7)(x + 5);
}

/*
 * Volatile loads and stores.
 */

static int
vload_s7(i)
int i;
{
  return vs7[i & 017];
}

static unsigned int
vload_u7(i)
int i;
{
  return vu7[i & 017];
}

static void
vstore_s7(i, x)
int i;
int x;
{
  vs7[i & 017] = (char7)x;
}

static void
vstore_u7(i, x)
int i;
unsigned int x;
{
  vu7[i & 017] = (uchar7)x;
}

static int
vload_s7_4()
{
  return vs7[4];
}

static unsigned int
vload_u7_4()
{
  return vu7[4];
}

static void
vstore_s7_4(x)
int x;
{
  vs7[4] = (char7)x;
}

static void
vstore_u7_4(x)
unsigned int x;
{
  vu7[4] = (uchar7)x;
}

/*
 * Widening and truncation.
 */

static int
extend_char7(p)
char7 *p;
{
  int x;

  x = *p;
  return x;
}

static unsigned int
extend_uchar7(p)
uchar7 *p;
{
  unsigned int x;

  x = *p;
  return x;
}

static int
extend_char7_array(i)
int i;
{
  int x;

  x = s7[i & 017];
  return x;
}

static unsigned int
extend_uchar7_array(i)
int i;
{
  unsigned int x;

  x = u7[i & 017];
  return x;
}

static void
trunc_store_char7(p, x)
char7 *p;
int x;
{
  *p = (char7)x;
}

static void
trunc_store_uchar7(p, x)
uchar7 *p;
unsigned int x;
{
  *p = (uchar7)x;
}

static int
trunc_store_char7_return(p, x)
char7 *p;
int x;
{
  return *p = (char7)x;
}

static unsigned int
trunc_store_uchar7_return(p, x)
uchar7 *p;
unsigned int x;
{
  return *p = (uchar7)x;
}

/*
 * Arithmetic and comparisons after extraction.
 */

static int
char7_plus(i, x)
int i;
int x;
{
  return s7[i & 017] + x;
}

static unsigned int
uchar7_plus(i, x)
int i;
unsigned int x;
{
  return u7[i & 017] + x;
}

static int
char7_sub(i, x)
int i;
int x;
{
  return s7[i & 017] - x;
}

static unsigned int
uchar7_xor(i, x)
int i;
unsigned int x;
{
  return u7[i & 017] ^ x;
}

static int
char7_eq_zero(i)
int i;
{
  return s7[i & 017] == 0;
}

static int
char7_lt_zero(i)
int i;
{
  return s7[i & 017] < 0;
}

static int
uchar7_eq_zero(i)
int i;
{
  return u7[i & 017] == 0;
}

static int
uchar7_gt_63(i)
int i;
{
  return u7[i & 017] > 63;
}

static int
char7_range(i)
int i;
{
  int x;

  x = s7[i & 017];
  if (x < -32)
    return -1;
  if (x > 31)
    return 1;
  return 0;
}

static int
uchar7_range(i)
int i;
{
  unsigned int x;

  x = u7[i & 017];
  if (x < 32)
    return -1;
  if (x > 95)
    return 1;
  return 0;
}

/*
 * Pointer-walk forms.
 */

static int
postinc_load_char7(p)
char7 *p;
{
  return *p++;
}

static unsigned int
postinc_load_uchar7(p)
uchar7 *p;
{
  return *p++;
}

static void
postinc_store_char7(p, x)
char7 *p;
int x;
{
  *p++ = (char7)x;
}

static void
postinc_store_uchar7(p, x)
uchar7 *p;
unsigned int x;
{
  *p++ = (uchar7)x;
}

static int
walk_sum_char7(p, n)
char7 *p;
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
walk_sum_uchar7(p, n)
uchar7 *p;
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
walk_zero_char7(p, n)
char7 *p;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

static void
walk_zero_uchar7(p, n)
uchar7 *p;
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
sum_char7_global(n)
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += s7[i & 017];
  return sum;
}

static unsigned int
sum_uchar7_global(n)
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += u7[i & 017];
  return sum;
}

static void
zero_char7_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    s7[i & 017] = 0;
}

static void
zero_uchar7_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    u7[i & 017] = 0;
}

static void
set_char7_index_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    s7[i & 017] = (char7)i;
}

static void
set_uchar7_index_global(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    u7[i & 017] = (uchar7)i;
}

static int
copy_char7_global(n)
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++) {
    s7[(i + 15) & 035] = s7[i & 017];
    sum += s7[(i + 15) & 035];
  }
  return sum;
}

static unsigned int
copy_uchar7_global(n)
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++) {
    u7[(i + 15) & 035] = u7[i & 017];
    sum += u7[(i + 15) & 035];
  }
  return sum;
}

/*
 * Loops over struct arrays.
 */

static int
sum_b7a_signed(n)
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += b7a[i & 7].c0 + b7a[i & 7].c4;
  return sum;
}

static unsigned int
sum_b7a_unsigned(n)
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += b7a[i & 7].u0 + b7a[i & 7].u4;
  return sum;
}

static void
zero_b7a_signed(n)
int n;
{
  int i;

  for (i = 0; i < n; i++) {
    b7a[i & 7].c0 = 0;
    b7a[i & 7].c1 = 0;
    b7a[i & 7].c2 = 0;
    b7a[i & 7].c3 = 0;
    b7a[i & 7].c4 = 0;
  }
}

static void
zero_b7a_unsigned(n)
int n;
{
  int i;

  for (i = 0; i < n; i++) {
    b7a[i & 7].u0 = 0;
    b7a[i & 7].u1 = 0;
    b7a[i & 7].u2 = 0;
    b7a[i & 7].u3 = 0;
    b7a[i & 7].u4 = 0;
  }
}

static void
copy_b7a(n)
int n;
{
  int i;

  for (i = 0; i < n; i++)
    b7a[(i + 1) & 7] = b7a[i & 7];
}

/*
 * Calls and barriers.
 */

static int
load_char7_after_call(i)
int i;
{
  clobber();
  return s7[i & 017];
}

static unsigned int
load_uchar7_after_call(i)
int i;
{
  clobber();
  return u7[i & 017];
}

static void
store_char7_after_call(i, x)
int i;
int x;
{
  clobber();
  s7[i & 017] = (char7)x;
}

static void
store_uchar7_after_call(i, x)
int i;
unsigned int x;
{
  clobber();
  u7[i & 017] = (uchar7)x;
}

static int
load_char7_call_index()
{
  return s7[f() & 017];
}

static unsigned int
load_uchar7_call_index()
{
  return u7[f() & 017];
}

static void
store_char7_call_index(x)
int x;
{
  s7[f() & 017] = (char7)x;
}

static void
store_uchar7_call_index(x)
unsigned int x;
{
  u7[f() & 017] = (uchar7)x;
}

/*
 * Dynamic pointer adjustment with five bytes per word.
 */

static char7 *
add_char7_pointer(p, n)
char7 *p;
int n;
{
  return p + n;
}

static uchar7 *
add_uchar7_pointer(p, n)
uchar7 *p;
int n;
{
  return p + n;
}

static char7 *
sub_char7_pointer(p, n)
char7 *p;
int n;
{
  return p - n;
}

static uchar7 *
sub_uchar7_pointer(p, n)
uchar7 *p;
int n;
{
  return p - n;
}

static char7 *
add_char7_pointer_const_1(p)
char7 *p;
{
  return p + 1;
}

static char7 *
add_char7_pointer_const_4(p)
char7 *p;
{
  return p + 4;
}

static char7 *
add_char7_pointer_const_5(p)
char7 *p;
{
  return p + 5;
}

static char7 *
add_char7_pointer_const_6(p)
char7 *p;
{
  return p + 6;
}

static uchar7 *
add_uchar7_pointer_const_1(p)
uchar7 *p;
{
  return p + 1;
}

static uchar7 *
add_uchar7_pointer_const_4(p)
uchar7 *p;
{
  return p + 4;
}

static uchar7 *
add_uchar7_pointer_const_5(p)
uchar7 *p;
{
  return p + 5;
}

static uchar7 *
add_uchar7_pointer_const_6(p)
uchar7 *p;
{
  return p + 6;
}

/*
 * Combined smoke use.
 */

static int
use_byte7_more(i, x)
int i;
int x;
{
  int sum;

  store_char7_index(i, x);
  store_char7_index_plus_1(i, x + 1);
  store_uchar7_index_plus_4(i, (unsigned int)(x + 4));

  b7_store_c0(x);
  b7_store_c1(x + 1);
  b7_store_c2(x + 2);
  b7_store_c3(x + 3);
  b7_store_c4(x + 4);

  b7_store_u0((unsigned int)x);
  b7_store_u1((unsigned int)(x + 1));
  b7_store_u2((unsigned int)(x + 2));
  b7_store_u3((unsigned int)(x + 3));
  b7_store_u4((unsigned int)(x + 4));

  sum = 0;
  sum += load_char7_masked(i);
  sum += (int)load_uchar7_masked(i);
  sum += load_char7_const_cross();
  sum += b7_sum_signed();
  sum += (int)b7_sum_unsigned();
  sum += char7_plus(i, x);
  sum += (int)uchar7_plus(i, (unsigned int)x);
  sum += char7_range(i);
  sum += uchar7_range(i);

  return sum;
}
