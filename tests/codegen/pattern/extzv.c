#include "insns.h"

/*
 * extzv pattern coverage for PDP-6/166 and KA10.
 *
 * Unsigned extraction only:
 *
 *   zero_extract from memory/register-like scalar fields
 *   unsigned custom-size struct fields
 *   unsigned custom-size arrays
 *   pointer, global, volatile, indexed, arithmetic, branch uses
 *
 * Signed extraction belongs in extv.c.
 * Insertion belongs in insv.c.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

struct S {
  uchar6    x6_0,  x6_1,  x6_2,  x6_3,  x6_4,  x6_5;
  uchar7    x7_0,  x7_1,  x7_2,  x7_3,  x7_4;
  uchar8    x8_0,  x8_1,  x8_2,  x8_3;
  uchar9    x9_0,  x9_1,  x9_2,  x9_3;
  ushort16 x16_0, x16_1;
  ushort18 x18_0, x18_1;
  uint32   x32_0;
};

static struct S s;
static volatile struct S vs;

static uchar6 x6[12];
static uchar7 x7[10];
static uchar8 x8[8];
static uchar9 x9[8];
static ushort16 x16[4];
static ushort18 x18[4];
static uint32 x32[2];

static volatile uchar6 vx6[12];
static volatile uchar7 vx7[10];
static volatile uchar8 vx8[8];
static volatile uchar9 vx9[8];
static volatile ushort16 vx16[4];
static volatile ushort18 vx18[4];
static volatile uint32 vx32[2];

#define LOAD_STRUCT(len, pos)                         \
static int                                            \
load##len##_##pos(void)                               \
{                                                     \
  return s.x##len##_##pos;                            \
}

#define LOAD_PTR(len, pos)                            \
static int                                            \
lptr##len##_##pos(p)                                  \
struct S *p;                                          \
{                                                     \
  return p->x##len##_##pos;                           \
}

#define LOAD_VOLPTR(len, pos)                         \
static int                                            \
lvptr##len##_##pos(p)                                 \
volatile struct S *p;                                 \
{                                                     \
  return p->x##len##_##pos;                           \
}

#define LOAD_GLOBAL_VOL(len, pos)                     \
static int                                            \
lvload##len##_##pos(void)                             \
{                                                     \
  return vs.x##len##_##pos;                           \
}

#define LOAD_ARR(len, pos)                            \
static int                                            \
larr##len##_##pos(void)                               \
{                                                     \
  return x##len[(36 / len) + pos];                    \
}

#define LOAD_VARR(len, pos)                           \
static int                                            \
lvarr##len##_##pos(void)                              \
{                                                     \
  return vx##len[(36 / len) + pos];                   \
}

#define LOAD_ALL(len, pos)                            \
LOAD_STRUCT(len, pos)                                 \
LOAD_PTR(len, pos)                                    \
LOAD_VOLPTR(len, pos)                                 \
LOAD_GLOBAL_VOL(len, pos)                             \
LOAD_ARR(len, pos)                                    \
LOAD_VARR(len, pos)

LOAD_ALL(6, 0)
LOAD_ALL(6, 1)
LOAD_ALL(6, 2)
LOAD_ALL(6, 3)
LOAD_ALL(6, 4)
LOAD_ALL(6, 5)

LOAD_ALL(7, 0)
LOAD_ALL(7, 1)
LOAD_ALL(7, 2)
LOAD_ALL(7, 3)
LOAD_ALL(7, 4)

LOAD_ALL(8, 0)
LOAD_ALL(8, 1)
LOAD_ALL(8, 2)
LOAD_ALL(8, 3)

LOAD_ALL(9, 0)
LOAD_ALL(9, 1)
LOAD_ALL(9, 2)
LOAD_ALL(9, 3)

LOAD_ALL(16, 0)
LOAD_ALL(16, 1)

LOAD_ALL(18, 0)
LOAD_ALL(18, 1)

LOAD_STRUCT(32, 0)
LOAD_PTR(32, 0)
LOAD_VOLPTR(32, 0)
LOAD_GLOBAL_VOL(32, 0)
LOAD_ARR(32, 0)
LOAD_VARR(32, 0)

static int
load6_sum(void)
{
  return s.x6_0 + s.x6_1 + s.x6_2 + s.x6_3 + s.x6_4 + s.x6_5;
}

static int
load7_sum(void)
{
  return s.x7_0 + s.x7_1 + s.x7_2 + s.x7_3 + s.x7_4;
}

static int
load8_sum(void)
{
  return s.x8_0 + s.x8_1 + s.x8_2 + s.x8_3;
}

static int
load9_sum(void)
{
  return s.x9_0 + s.x9_1 + s.x9_2 + s.x9_3;
}

static int
load16_sum(void)
{
  return s.x16_0 + s.x16_1;
}

static int
load18_sum(void)
{
  return s.x18_0 + s.x18_1;
}

static int
load_mixed_sum(void)
{
  return s.x6_0
       + s.x7_1
       + s.x8_2
       + s.x9_3
       + s.x16_1
       + s.x18_0
       + s.x32_0;
}

static int
load_ptr_mixed_sum(p)
struct S *p;
{
  return p->x6_5
       + p->x7_4
       + p->x8_3
       + p->x9_2
       + p->x16_0
       + p->x18_1
       + p->x32_0;
}

static int
load_volatile_mixed_sum(p)
volatile struct S *p;
{
  return p->x6_0
       + p->x7_1
       + p->x8_2
       + p->x9_3
       + p->x16_1
       + p->x18_0
       + p->x32_0;
}

static int
lidx6(a)
int a;
{
  a &= 07;
  return x6[a];
}

static int
lidx6_hi(a)
int a;
{
  a &= 07;
  return x6[a + 4];
}

static int
lidx7(a)
int a;
{
  a &= 07;
  return x7[a];
}

static int
lidx7_hi(a)
int a;
{
  a &= 03;
  return x7[a + 5];
}

static int
lidx8(a)
int a;
{
  a &= 07;
  return x8[a];
}

static int
lidx9(a)
int a;
{
  a &= 07;
  return x9[a];
}

static int
lidx16(a)
int a;
{
  a &= 03;
  return x16[a];
}

static int
lidx18(a)
int a;
{
  a &= 03;
  return x18[a];
}

static int
lidx32(a)
int a;
{
  a &= 01;
  return x32[a];
}

static int
lvindex6(a)
int a;
{
  a &= 07;
  return vx6[a];
}

static int
lvindex6_hi(a)
int a;
{
  a &= 07;
  return vx6[a + 4];
}

static int
lvindex7(a)
int a;
{
  a &= 07;
  return vx7[a];
}

static int
lvindex7_hi(a)
int a;
{
  a &= 03;
  return vx7[a + 5];
}

static int
lvindex8(a)
int a;
{
  a &= 07;
  return vx8[a];
}

static int
lvindex9(a)
int a;
{
  a &= 07;
  return vx9[a];
}

static int
lvindex16(a)
int a;
{
  a &= 03;
  return vx16[a];
}

static int
lvindex18(a)
int a;
{
  a &= 03;
  return vx18[a];
}

static int
lvindex32(a)
int a;
{
  a &= 01;
  return vx32[a];
}

static int
lidx6_add(a, b)
int a;
int b;
{
  a &= 07;
  return x6[a] + b;
}

static int
lidx7_sub(a, b)
int a;
int b;
{
  a &= 07;
  return x7[a] - b;
}

static int
lidx8_not(a)
int a;
{
  a &= 07;
  return ~x8[a];
}

static int
lidx9_shift_left(a)
int a;
{
  a &= 07;
  return x9[a] << 2;
}

static int
lidx9_shift_right(a)
int a;
{
  a &= 07;
  return x9[a] >> 2;
}

static int
lidx16_shift_left(a)
int a;
{
  a &= 03;
  return x16[a] << 4;
}

static int
lidx16_shift_right(a)
int a;
{
  a &= 03;
  return x16[a] >> 4;
}

static int
lidx18_shift_left(a)
int a;
{
  a &= 03;
  return x18[a] << 9;
}

static int
lidx18_shift_right(a)
int a;
{
  a &= 03;
  return x18[a] >> 9;
}

static int
lidx32_shift_right(a)
int a;
{
  a &= 01;
  return x32[a] >> 16;
}

static int
load6_branch_zero(void)
{
  if (s.x6_0 == 0)
    return 1;
  return s.x6_0;
}

static int
load7_branch_zero(void)
{
  if (s.x7_1 == 0)
    return 1;
  return s.x7_1;
}

static int
load8_branch_zero(void)
{
  if (s.x8_2 == 0)
    return 1;
  return s.x8_2;
}

static int
load9_branch_zero(void)
{
  if (s.x9_3 == 0)
    return 1;
  return s.x9_3;
}

static int
load16_branch_zero(void)
{
  if (s.x16_1 == 0)
    return 1;
  return s.x16_1;
}

static int
load18_branch_zero(void)
{
  if (s.x18_0 == 0)
    return 1;
  return s.x18_0;
}

static int
load32_branch_zero(void)
{
  if (s.x32_0 == 0)
    return 1;
  return s.x32_0;
}

static int
load6_branch_nonzero(void)
{
  if (s.x6_5 != 0)
    return s.x6_5;
  return 0;
}

static int
load7_branch_nonzero(void)
{
  if (s.x7_4 != 0)
    return s.x7_4;
  return 0;
}

static int
load8_branch_nonzero(void)
{
  if (s.x8_3 != 0)
    return s.x8_3;
  return 0;
}

static int
load9_branch_nonzero(void)
{
  if (s.x9_2 != 0)
    return s.x9_2;
  return 0;
}

static int
load16_branch_nonzero(void)
{
  if (s.x16_0 != 0)
    return s.x16_0;
  return 0;
}

static int
load18_branch_nonzero(void)
{
  if (s.x18_1 != 0)
    return s.x18_1;
  return 0;
}

static int
load32_branch_nonzero(void)
{
  if (s.x32_0 != 0)
    return s.x32_0;
  return 0;
}

static int
ptr_load6_branch(p)
struct S *p;
{
  if (p->x6_0 == 0)
    return 1;
  return p->x6_0;
}

static int
ptr_load9_branch(p)
struct S *p;
{
  if (p->x9_2 == 0)
    return 1;
  return p->x9_2;
}

static int
ptr_load18_branch(p)
struct S *p;
{
  if (p->x18_1 == 0)
    return 1;
  return p->x18_1;
}

static int
ptr_load32_branch(p)
struct S *p;
{
  if (p->x32_0 == 0)
    return 1;
  return p->x32_0;
}

static int
load6_compare_max(void)
{
  if (s.x6_0 == 077)
    return 1;
  return 0;
}

static int
load7_compare_max(void)
{
  if (s.x7_1 == 0177)
    return 1;
  return 0;
}

static int
load8_compare_max(void)
{
  if (s.x8_2 == 0377)
    return 1;
  return 0;
}

static int
load9_compare_max(void)
{
  if (s.x9_3 == 0777)
    return 1;
  return 0;
}

static int
load16_compare_max(void)
{
  if (s.x16_0 == 0177777)
    return 1;
  return 0;
}

static int
load18_compare_max(void)
{
  if (s.x18_1 == 0777777)
    return 1;
  return 0;
}

static int
load32_compare_max(void)
{
  if (s.x32_0 == 037777777777)
    return 1;
  return 0;
}

static int
load6_compare_less(void)
{
  if (s.x6_0 < 040)
    return 1;
  return 0;
}

static int
load7_compare_less(void)
{
  if (s.x7_1 < 0100)
    return 1;
  return 0;
}

static int
load8_compare_less(void)
{
  if (s.x8_2 < 0200)
    return 1;
  return 0;
}

static int
load9_compare_less(void)
{
  if (s.x9_3 < 0400)
    return 1;
  return 0;
}

static int
load16_compare_less(void)
{
  if (s.x16_0 < 0100000)
    return 1;
  return 0;
}

static int
load18_compare_less(void)
{
  if (s.x18_1 < 0400000)
    return 1;
  return 0;
}

static int
load32_compare_less(void)
{
  if (s.x32_0 < 020000000000)
    return 1;
  return 0;
}

static int
load6_store_result(out)
int *out;
{
  *out = s.x6_0;
  return *out;
}

static int
load9_store_result(out)
int *out;
{
  *out = s.x9_1;
  return *out;
}

static int
load18_store_result(out)
int *out;
{
  *out = s.x18_1;
  return *out;
}

static int
load32_store_result(out)
int *out;
{
  *out = s.x32_0;
  return *out;
}

static int
load6_call_pressure(void)
{
  extern void clobber(void);
  int r;

  r = s.x6_0;
  clobber();
  return r + s.x6_1;
}

static int
load9_call_pressure(void)
{
  extern void clobber(void);
  int r;

  r = s.x9_0;
  clobber();
  return r + s.x9_1;
}

static int
load18_call_pressure(void)
{
  extern void clobber(void);
  int r;

  r = s.x18_0;
  clobber();
  return r + s.x18_1;
}

static int
load32_call_pressure(void)
{
  extern void clobber(void);
  int r;

  r = s.x32_0;
  clobber();
  return r + s.x32_0;
}

static int
load_array_sum6(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x6[i & 07];

  return r;
}

static int
load_array_sum6_hi(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x6[(i & 07) + 4];

  return r;
}

static int
load_array_sum7(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x7[i & 07];

  return r;
}

static int
load_array_sum7_hi(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x7[(i & 03) + 5];

  return r;
}

static int
load_array_sum8(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x8[i & 07];

  return r;
}

static int
load_array_sum9(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x9[i & 07];

  return r;
}

static int
load_array_sum16(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x16[i & 03];

  return r;
}

static int
load_array_sum18(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x18[i & 03];

  return r;
}

static int
load_array_sum32(n)
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += x32[i & 01];

  return r;
}

static int
load_word_manual_6(x)
uSint x;
{
  return (x >> 30) & 077;
}

static int
load_word_manual_7(x)
uSint x;
{
  return (x >> 29) & 0177;
}

static int
load_word_manual_8(x)
uSint x;
{
  return (x >> 28) & 0377;
}

static int
load_word_manual_9(x)
uSint x;
{
  return (x >> 27) & 0777;
}

static int
load_word_manual_16(x)
uSint x;
{
  return (x >> 20) & 0177777;
}

static int
load_word_manual_18_left(x)
uSint x;
{
  return (x >> 18) & 0777777;
}

static int
load_word_manual_18_right(x)
uSint x;
{
  return x & 0777777;
}

static int
load_word_manual_32(x)
uSint x;
{
  return (x >> 4) & 037777777777;
}

static int
load_word_manual_mid6(x)
uSint x;
{
  return (x >> 18) & 077;
}

static int
load_word_manual_mid9(x)
uSint x;
{
  return (x >> 18) & 0777;
}

static int
load_word_manual_mid16(x)
uSint x;
{
  return (x >> 10) & 0177777;
}

static int
load_word_manual_var6(x, n)
uSint x;
int n;
{
  n &= 017;
  OPAQUE_REG(n);
  return (x >> n) & 077;
}

static int
load_word_manual_var9(x, n)
uSint x;
int n;
{
  n &= 017;
  OPAQUE_REG(n);
  return (x >> n) & 0777;
}

static int
load_word_manual_var18(x, n)
uSint x;
int n;
{
  n &= 017;
  OPAQUE_REG(n);
  return (x >> n) & 0777777;
}

static int
load_word_manual_expr(x, y)
uSint x;
uSint y;
{
  uSint z;

  z = x ^ y;
  OPAQUE_REG(z);
  return (z >> 9) & 0777;
}

static int
load_word_manual_add(x, y)
uSint x;
uSint y;
{
  uSint z;

  z = x + y;
  OPAQUE_REG(z);
  return (z >> 18) & 0777777;
}

static int
load_word_manual_branch(x)
uSint x;
{
  int r;

  r = (x >> 27) & 0777;
  if (r == 0)
    return 1;
  return r;
}

static int
load_word_manual_compare(x)
uSint x;
{
  int r;

  r = (x >> 27) & 0777;
  if (r == 0777)
    return 1;
  return 0;
}

/*
 * Original skeleton macro shape, kept semantically visible above via
 * the LOAD_ALL instances.
 */

static int
load9_1_original_shape(void)
{
  return s.x9_1;
}
