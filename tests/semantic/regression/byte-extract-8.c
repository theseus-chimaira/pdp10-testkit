#include "insns.h"

/*
 * 8-bit packed byte extraction/store coverage.
 *
 * File:
 *   misc/byte-extract-8.c
 *
 * This is a misc coverage test, not a single instruction-pattern test.
 *
 * It stresses:
 *   - signed and unsigned 8-bit machine byte loads
 *   - every useful 8-bit byte position inside a 36-bit word
 *   - crossing 36-bit word boundaries
 *   - static byte-pointer constants
 *   - pointer indexing
 *   - stores and store-return forms
 *   - copy/sum/zero loops
 *   - pointer-walk forms
 *   - widening and truncation around char8/uchar8
 *
 * Four 8-bit bytes fit in one PDP-10 word, leaving four unused bits.
 * This file deliberately covers positions 0..3, the 3->4 boundary,
 * positions 4..7, and the start of the next word at position 8.
 *
 * 8-bit bytes are lower priority than DAIMON's native 9-bit chars, but
 * they are important for exchange formats and later Unix-compatible
 * byte streams.  Dynamic pointer adjustment must not require KL10 ADJBP.
 */

extern int f(void);
extern unsigned int uf(void);
extern void clobber(void);

struct bytes8 {
  char8 c0, c1, c2, c3;
  uchar8 u0, u1, u2, u3;
};

struct signed8 {
  char8 c0, c1, c2, c3;
};

struct unsigned8 {
  uchar8 u0, u1, u2, u3;
};

struct mixed8 {
  int filler;
  char8 c0;
  uchar8 u0;
  char8 c1;
  uchar8 u1;
  int word;
  char8 c2;
  uchar8 u2;
};

static char8 s8[32];
static uchar8 u8[32];
static volatile char8 vs8[32];
static volatile uchar8 vu8[32];

static struct bytes8 b8;
static struct signed8 sb8;
static struct unsigned8 ub8;
static struct mixed8 mb8;

static struct bytes8 b8a[8];
static struct signed8 sb8a[8];
static struct unsigned8 ub8a[8];
static struct mixed8 mb8a[8];

/*
 * Do not keep file-scope initializers for pointers to non-word 8-bit
 * elements here.  The tests below still form constant byte addresses,
 * but do so inside functions.
 */

/*
 * Original seed shape.
 */

#define LOAD8(N)                                                \
static int                                                      \
load8_##N()                                                     \
{                                                               \
  return b8.c##N;                                               \
}                                                               \
static unsigned int                                             \
loadu8_##N()                                                    \
{                                                               \
  return b8.u##N;                                               \
}

LOAD8(0)
LOAD8(1)
LOAD8(2)
LOAD8(3)

static int
load_char8_index(i)
int i;
{
  return s8[i];
}

static unsigned int
load_uchar8_index(i)
int i;
{
  return u8[i];
}

static int
load_char8_const_cross()
{
  return s8[0] + s8[3] + s8[4] + s8[7] + s8[8];
}

static void
store_char8_index(i, x)
int i;
int x;
{
  s8[i] = (char8)x;
  u8[i] = (uchar8)(x + 1);
}

static int
copy_char8(d, s, n)
char8 *d;
char8 *s;
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
copy_uchar8(d, s, n)
uchar8 *d;
uchar8 *s;
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
use_byte8(i, x)
int i;
int x;
{
  store_char8_index(i, x);
  b8.c0 = (char8)x;
  b8.c1 = (char8)(x + 1);
  b8.c2 = (char8)(x + 2);
  b8.c3 = (char8)(x + 3);
  b8.u0 = (uchar8)x;
  b8.u1 = (uchar8)(x + 1);
  b8.u2 = (uchar8)(x + 2);
  b8.u3 = (uchar8)(x + 3);
  return load_char8_index(i)
      + (int)load_uchar8_index(i)
      + load_char8_const_cross()
      + load8_0() + load8_1() + load8_2() + load8_3()
      + (int)loadu8_0() + (int)loadu8_1()
      + (int)loadu8_2() + (int)loadu8_3();
}

/*
 * Direct array loads: every 8-bit position in the first two words,
 * plus the first byte of the third word.
 */

static int load_s8_0() { return s8[0]; }
static int load_s8_1() { return s8[1]; }
static int load_s8_2() { return s8[2]; }
static int load_s8_3() { return s8[3]; }
static int load_s8_4() { return s8[4]; }
static int load_s8_5() { return s8[5]; }
static int load_s8_6() { return s8[6]; }
static int load_s8_7() { return s8[7]; }
static int load_s8_8() { return s8[8]; }

static unsigned int load_u8_0() { return u8[0]; }
static unsigned int load_u8_1() { return u8[1]; }
static unsigned int load_u8_2() { return u8[2]; }
static unsigned int load_u8_3() { return u8[3]; }
static unsigned int load_u8_4() { return u8[4]; }
static unsigned int load_u8_5() { return u8[5]; }
static unsigned int load_u8_6() { return u8[6]; }
static unsigned int load_u8_7() { return u8[7]; }
static unsigned int load_u8_8() { return u8[8]; }

/*
 * Direct array stores.
 */

static void store_s8_0(x) int x; { s8[0] = (char8)x; }
static void store_s8_1(x) int x; { s8[1] = (char8)x; }
static void store_s8_2(x) int x; { s8[2] = (char8)x; }
static void store_s8_3(x) int x; { s8[3] = (char8)x; }
static void store_s8_4(x) int x; { s8[4] = (char8)x; }
static void store_s8_5(x) int x; { s8[5] = (char8)x; }
static void store_s8_6(x) int x; { s8[6] = (char8)x; }
static void store_s8_7(x) int x; { s8[7] = (char8)x; }
static void store_s8_8(x) int x; { s8[8] = (char8)x; }

static void store_u8_0(x) unsigned int x; { u8[0] = (uchar8)x; }
static void store_u8_1(x) unsigned int x; { u8[1] = (uchar8)x; }
static void store_u8_2(x) unsigned int x; { u8[2] = (uchar8)x; }
static void store_u8_3(x) unsigned int x; { u8[3] = (uchar8)x; }
static void store_u8_4(x) unsigned int x; { u8[4] = (uchar8)x; }
static void store_u8_5(x) unsigned int x; { u8[5] = (uchar8)x; }
static void store_u8_6(x) unsigned int x; { u8[6] = (uchar8)x; }
static void store_u8_7(x) unsigned int x; { u8[7] = (uchar8)x; }
static void store_u8_8(x) unsigned int x; { u8[8] = (uchar8)x; }

/*
 * Store-return forms.
 */

static int
store_s8_return(i, x)
int i;
int x;
{
  return s8[i & 017] = (char8)x;
}

static unsigned int
store_u8_return(i, x)
int i;
unsigned int x;
{
  return u8[i & 017] = (uchar8)x;
}

static int
store_s8_const_return(x)
int x;
{
  return s8[3] = (char8)x;
}

static unsigned int
store_u8_const_return(x)
unsigned int x;
{
  return u8[3] = (uchar8)x;
}

/*
 * Static byte-pointer constants.
 */

static int
load_s8_ptr_0()
{
  char8 *p;

  p = &s8[0];
  return *p;
}

static int
load_s8_ptr_3()
{
  char8 *p;

  p = &s8[3];
  return *p;
}

static int
load_s8_ptr_4()
{
  char8 *p;

  p = &s8[4];
  return *p;
}

static int
load_s8_ptr_7()
{
  char8 *p;

  p = &s8[7];
  return *p;
}

static int
load_s8_ptr_8()
{
  char8 *p;

  p = &s8[8];
  return *p;
}

static unsigned int
load_u8_ptr_0()
{
  uchar8 *p;

  p = &u8[0];
  return *p;
}

static unsigned int
load_u8_ptr_3()
{
  uchar8 *p;

  p = &u8[3];
  return *p;
}

static unsigned int
load_u8_ptr_4()
{
  uchar8 *p;

  p = &u8[4];
  return *p;
}

static unsigned int
load_u8_ptr_7()
{
  uchar8 *p;

  p = &u8[7];
  return *p;
}

static unsigned int
load_u8_ptr_8()
{
  uchar8 *p;

  p = &u8[8];
  return *p;
}

static void
store_s8_ptr_0(x)
int x;
{
  char8 *p;

  p = &s8[0];
  *p = (char8)x;
}

static void
store_s8_ptr_3(x)
int x;
{
  char8 *p;

  p = &s8[3];
  *p = (char8)x;
}

static void
store_s8_ptr_4(x)
int x;
{
  char8 *p;

  p = &s8[4];
  *p = (char8)x;
}

static void
store_u8_ptr_0(x)
unsigned int x;
{
  uchar8 *p;

  p = &u8[0];
  *p = (uchar8)x;
}

static void
store_u8_ptr_3(x)
unsigned int x;
{
  uchar8 *p;

  p = &u8[3];
  *p = (uchar8)x;
}

static void
store_u8_ptr_4(x)
unsigned int x;
{
  uchar8 *p;

  p = &u8[4];
  *p = (uchar8)x;
}

/*
 * Struct field pointer constants.
 */

static int
load_b8p_c0()
{
  char8 *p;

  p = &b8.c0;
  return *p;
}

static int
load_b8p_c1()
{
  char8 *p;

  p = &b8.c1;
  return *p;
}

static int
load_b8p_c2()
{
  char8 *p;

  p = &b8.c2;
  return *p;
}

static int
load_b8p_c3()
{
  char8 *p;

  p = &b8.c3;
  return *p;
}

static unsigned int
load_b8p_u0()
{
  uchar8 *p;

  p = &b8.u0;
  return *p;
}

static unsigned int
load_b8p_u1()
{
  uchar8 *p;

  p = &b8.u1;
  return *p;
}

static unsigned int
load_b8p_u2()
{
  uchar8 *p;

  p = &b8.u2;
  return *p;
}

static unsigned int
load_b8p_u3()
{
  uchar8 *p;

  p = &b8.u3;
  return *p;
}

static void
store_b8p_c0(x)
int x;
{
  char8 *p;

  p = &b8.c0;
  *p = (char8)x;
}

static void
store_b8p_c1(x)
int x;
{
  char8 *p;

  p = &b8.c1;
  *p = (char8)x;
}

static void
store_b8p_c2(x)
int x;
{
  char8 *p;

  p = &b8.c2;
  *p = (char8)x;
}

static void
store_b8p_c3(x)
int x;
{
  char8 *p;

  p = &b8.c3;
  *p = (char8)x;
}

static void
store_b8p_u0(x)
unsigned int x;
{
  uchar8 *p;

  p = &b8.u0;
  *p = (uchar8)x;
}

static void
store_b8p_u1(x)
unsigned int x;
{
  uchar8 *p;

  p = &b8.u1;
  *p = (uchar8)x;
}

static void
store_b8p_u2(x)
unsigned int x;
{
  uchar8 *p;

  p = &b8.u2;
  *p = (uchar8)x;
}

static void
store_b8p_u3(x)
unsigned int x;
{
  uchar8 *p;

  p = &b8.u3;
  *p = (uchar8)x;
}

/*
 * Pointer-indexed dynamic loads and stores.
 */

static int
load_char8_masked(i)
int i;
{
  return s8[i & 017];
}

static unsigned int
load_uchar8_masked(i)
int i;
{
  return u8[i & 017];
}

static int
load_char8_pointer(p, i)
char8 *p;
int i;
{
  return p[i];
}

static unsigned int
load_uchar8_pointer(p, i)
uchar8 *p;
int i;
{
  return p[i];
}

static int
load_char8_pointer_plus_1(p, i)
char8 *p;
int i;
{
  return p[i + 1];
}

static int
load_char8_pointer_plus_3(p, i)
char8 *p;
int i;
{
  return p[i + 3];
}

static int
load_char8_pointer_plus_4(p, i)
char8 *p;
int i;
{
  return p[i + 4];
}

static unsigned int
load_uchar8_pointer_plus_1(p, i)
uchar8 *p;
int i;
{
  return p[i + 1];
}

static unsigned int
load_uchar8_pointer_plus_3(p, i)
uchar8 *p;
int i;
{
  return p[i + 3];
}

static unsigned int
load_uchar8_pointer_plus_4(p, i)
uchar8 *p;
int i;
{
  return p[i + 4];
}

static void
store_char8_pointer(p, i, x)
char8 *p;
int i;
int x;
{
  p[i] = (char8)x;
}

static void
store_uchar8_pointer(p, i, x)
uchar8 *p;
int i;
unsigned int x;
{
  p[i] = (uchar8)x;
}

static void
store_char8_pointer_plus_1(p, i, x)
char8 *p;
int i;
int x;
{
  p[i + 1] = (char8)x;
}

static void
store_char8_pointer_plus_3(p, i, x)
char8 *p;
int i;
int x;
{
  p[i + 3] = (char8)x;
}

static void
store_char8_pointer_plus_4(p, i, x)
char8 *p;
int i;
int x;
{
  p[i + 4] = (char8)x;
}

static void
store_uchar8_pointer_plus_1(p, i, x)
uchar8 *p;
int i;
unsigned int x;
{
  p[i + 1] = (uchar8)x;
}

static void
store_uchar8_pointer_plus_3(p, i, x)
uchar8 *p;
int i;
unsigned int x;
{
  p[i + 3] = (uchar8)x;
}

static void
store_uchar8_pointer_plus_4(p, i, x)
uchar8 *p;
int i;
unsigned int x;
{
  p[i + 4] = (uchar8)x;
}

static void
store_char8_index_plus_1(i, x)
int i;
int x;
{
  s8[(i + 1) & 017] = (char8)x;
}

static void
store_uchar8_index_plus_3(i, x)
int i;
unsigned int x;
{
  u8[(i + 3) & 017] = (uchar8)x;
}

static void
store_uchar8_index_plus_4(i, x)
int i;
unsigned int x;
{
  u8[(i + 4) & 017] = (uchar8)x;
}

/*
 * Volatile packed-byte memory.  These should still use byte loads and
 * stores, but must not be optimized into nonvolatile temporaries.
 */

static int
load_vchar8_index(i)
int i;
{
  return vs8[i & 017];
}

static unsigned int
load_vuchar8_index(i)
int i;
{
  return vu8[i & 017];
}

static void
store_vchar8_index(i, x)
int i;
int x;
{
  vs8[i & 017] = (char8)x;
}

static void
store_vuchar8_index(i, x)
int i;
unsigned int x;
{
  vu8[i & 017] = (uchar8)x;
}

static int
sum_vchar8_pair(i)
int i;
{
  int a;
  int b;

  a = vs8[i & 017];
  b = vs8[(i + 4) & 017];
  return a + b;
}

static unsigned int
sum_vuchar8_pair(i)
int i;
{
  unsigned int a;
  unsigned int b;

  a = vu8[i & 017];
  b = vu8[(i + 4) & 017];
  return a + b;
}

/*
 * Struct member loads and stores.  Cover direct packed fields, arrayed
 * structs, and mixed layouts with word and byte-sized objects adjacent.
 */

static int b8_load_c0() { return b8.c0; }
static int b8_load_c1() { return b8.c1; }
static int b8_load_c2() { return b8.c2; }
static int b8_load_c3() { return b8.c3; }

static unsigned int b8_load_u0() { return b8.u0; }
static unsigned int b8_load_u1() { return b8.u1; }
static unsigned int b8_load_u2() { return b8.u2; }
static unsigned int b8_load_u3() { return b8.u3; }

static void b8_store_c0(x) int x; { b8.c0 = (char8)x; }
static void b8_store_c1(x) int x; { b8.c1 = (char8)x; }
static void b8_store_c2(x) int x; { b8.c2 = (char8)x; }
static void b8_store_c3(x) int x; { b8.c3 = (char8)x; }

static void b8_store_u0(x) unsigned int x; { b8.u0 = (uchar8)x; }
static void b8_store_u1(x) unsigned int x; { b8.u1 = (uchar8)x; }
static void b8_store_u2(x) unsigned int x; { b8.u2 = (uchar8)x; }
static void b8_store_u3(x) unsigned int x; { b8.u3 = (uchar8)x; }

static int
b8_sum_signed()
{
  return b8.c0 + b8.c1 + b8.c2 + b8.c3;
}

static unsigned int
b8_sum_unsigned()
{
  return b8.u0 + b8.u1 + b8.u2 + b8.u3;
}

static int
sb8_sum()
{
  return sb8.c0 + sb8.c1 + sb8.c2 + sb8.c3;
}

static unsigned int
ub8_sum()
{
  return ub8.u0 + ub8.u1 + ub8.u2 + ub8.u3;
}

static int
load_b8a_signed(i)
int i;
{
  return b8a[i & 7].c0 + b8a[i & 7].c3;
}

static unsigned int
load_b8a_unsigned(i)
int i;
{
  return b8a[i & 7].u0 + b8a[i & 7].u3;
}

static void
store_b8a_signed(i, x)
int i;
int x;
{
  b8a[i & 7].c0 = (char8)x;
  b8a[i & 7].c3 = (char8)(x + 3);
}

static void
store_b8a_unsigned(i, x)
int i;
unsigned int x;
{
  b8a[i & 7].u0 = (uchar8)x;
  b8a[i & 7].u3 = (uchar8)(x + 3);
}

static int
mixed8_load(i)
int i;
{
  return mb8.word + mb8.c0 + (int)mb8.u0 + mb8.c1 + (int)mb8.u1
      + mb8.c2 + (int)mb8.u2 + mb8a[i & 7].word;
}

static void
mixed8_store(i, x)
int i;
int x;
{
  mb8.word = x;
  mb8.c0 = (char8)x;
  mb8.u0 = (uchar8)(x + 1);
  mb8.c1 = (char8)(x + 2);
  mb8.u1 = (uchar8)(x + 3);
  mb8.c2 = (char8)(x + 4);
  mb8.u2 = (uchar8)(x + 5);

  mb8a[i & 7].word = x + 6;
  mb8a[i & 7].c0 = (char8)(x + 7);
  mb8a[i & 7].u2 = (uchar8)(x + 8);
}

/*
 * Signedness and truncation pressure.
 */

static int
char8_sign_extend_value(x)
int x;
{
  char8 c;

  c = (char8)x;
  return c;
}

static unsigned int
uchar8_zero_extend_value(x)
unsigned int x;
{
  uchar8 c;

  c = (uchar8)x;
  return c;
}

static int
char8_plus(i, x)
int i;
int x;
{
  char8 c;

  c = s8[i & 017];
  c = (char8)(c + x);
  s8[(i + 1) & 017] = c;
  return c;
}

static unsigned int
uchar8_plus(i, x)
int i;
unsigned int x;
{
  uchar8 c;

  c = u8[i & 017];
  c = (uchar8)(c + x);
  u8[(i + 1) & 017] = c;
  return c;
}

static int
char8_cmp_zero(i)
int i;
{
  char8 c;

  c = s8[i & 017];
  if (c < 0)
    return -1;
  if (c == 0)
    return 0;
  return 1;
}

static int
uchar8_cmp_200(i)
int i;
{
  uchar8 c;

  c = u8[i & 017];
  if (c < (uchar8)0200)
    return -1;
  if (c == (uchar8)0200)
    return 0;
  return 1;
}

static int
char8_range(i)
int i;
{
  int x;

  x = s8[i & 017];
  return x >= -0200 && x <= 0177;
}

static int
uchar8_range(i)
int i;
{
  unsigned int x;

  x = u8[i & 017];
  return x <= 0377;
}

/*
 * Copy, zero, sum, and pointer-walk loops.
 */

static int
sum_char8(p, n)
char8 *p;
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += p[i];
  return sum;
}

static unsigned int
sum_uchar8(p, n)
uchar8 *p;
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = 0; i < n; i++)
    sum += p[i];
  return sum;
}

static int
sum_char8_walk(p, n)
char8 *p;
int n;
{
  int sum;

  sum = 0;
  while (n-- > 0)
    sum += *p++;
  return sum;
}

static unsigned int
sum_uchar8_walk(p, n)
uchar8 *p;
int n;
{
  unsigned int sum;

  sum = 0;
  while (n-- > 0)
    sum += *p++;
  return sum;
}

static void
zero_char8(p, n)
char8 *p;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    p[i] = (char8)0;
}

static void
zero_uchar8(p, n)
uchar8 *p;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    p[i] = (uchar8)0;
}

static void
fill_char8(p, n, x)
char8 *p;
int n;
int x;
{
  int i;

  for (i = 0; i < n; i++)
    p[i] = (char8)(x + i);
}

static void
fill_uchar8(p, n, x)
uchar8 *p;
int n;
unsigned int x;
{
  int i;

  for (i = 0; i < n; i++)
    p[i] = (uchar8)(x + (unsigned int)i);
}

static int
copy_char8_reverse(d, s, n)
char8 *d;
char8 *s;
int n;
{
  int i;
  int sum;

  sum = 0;
  for (i = n - 1; i >= 0; i--) {
    d[i] = s[i];
    sum += d[i];
  }
  return sum;
}

static unsigned int
copy_uchar8_reverse(d, s, n)
uchar8 *d;
uchar8 *s;
int n;
{
  int i;
  unsigned int sum;

  sum = 0;
  for (i = n - 1; i >= 0; i--) {
    d[i] = s[i];
    sum += d[i];
  }
  return sum;
}

/*
 * Explicit pointer arithmetic.  These should exercise byte-pointer
 * adjustment without assuming extended instructions.
 */

static char8 *
add_char8_pointer(p, n)
char8 *p;
int n;
{
  return p + n;
}

static uchar8 *
add_uchar8_pointer(p, n)
uchar8 *p;
int n;
{
  return p + n;
}

static char8 *
sub_char8_pointer(p, n)
char8 *p;
int n;
{
  return p - n;
}

static uchar8 *
sub_uchar8_pointer(p, n)
uchar8 *p;
int n;
{
  return p - n;
}

static char8 *
add_char8_pointer_const_1(p)
char8 *p;
{
  return p + 1;
}

static char8 *
add_char8_pointer_const_3(p)
char8 *p;
{
  return p + 3;
}

static char8 *
add_char8_pointer_const_4(p)
char8 *p;
{
  return p + 4;
}

static char8 *
add_char8_pointer_const_5(p)
char8 *p;
{
  return p + 5;
}

static uchar8 *
add_uchar8_pointer_const_1(p)
uchar8 *p;
{
  return p + 1;
}

static uchar8 *
add_uchar8_pointer_const_3(p)
uchar8 *p;
{
  return p + 3;
}

static uchar8 *
add_uchar8_pointer_const_4(p)
uchar8 *p;
{
  return p + 4;
}

static uchar8 *
add_uchar8_pointer_const_5(p)
uchar8 *p;
{
  return p + 5;
}

/*
 * Combined smoke use.
 */

static int
use_byte8_more(i, x)
int i;
int x;
{
  int sum;

  store_char8_index(i, x);
  store_char8_index_plus_1(i, x + 1);
  store_uchar8_index_plus_3(i, (unsigned int)(x + 3));
  store_uchar8_index_plus_4(i, (unsigned int)(x + 4));

  b8_store_c0(x);
  b8_store_c1(x + 1);
  b8_store_c2(x + 2);
  b8_store_c3(x + 3);

  b8_store_u0((unsigned int)x);
  b8_store_u1((unsigned int)(x + 1));
  b8_store_u2((unsigned int)(x + 2));
  b8_store_u3((unsigned int)(x + 3));

  mixed8_store(i, x);

  sum = 0;
  sum += load_char8_masked(i);
  sum += (int)load_uchar8_masked(i);
  sum += load_char8_const_cross();
  sum += b8_sum_signed();
  sum += (int)b8_sum_unsigned();
  sum += sb8_sum();
  sum += (int)ub8_sum();
  sum += char8_plus(i, x);
  sum += (int)uchar8_plus(i, (unsigned int)x);
  sum += char8_cmp_zero(i);
  sum += uchar8_cmp_200(i);
  sum += char8_range(i);
  sum += uchar8_range(i);
  sum += mixed8_load(i);
  sum += load_vchar8_index(i);
  sum += (int)load_vuchar8_index(i);
  sum += sum_vchar8_pair(i);
  sum += (int)sum_vuchar8_pair(i);

  return sum;
}
