#include "insns.h"

/*
 * insv pattern coverage for PDP-6/166 and KA10.
 *
 * Store-side partner for extv/extzv:
 *
 *   insertion into custom-size struct fields
 *   insertion into custom-size arrays
 *   pointer, global, volatile, indexed destinations
 *   constants and negative source values
 *   read/modify/write forms
 *   small ordinary C bitfields
 *
 * Signedness mostly matters for later loads; the insertion itself is the
 * interesting operation here.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

struct S {
  char6    x6_0,  x6_1,  x6_2,  x6_3,  x6_4,  x6_5;
  char7    x7_0,  x7_1,  x7_2,  x7_3,  x7_4;
  char8    x8_0,  x8_1,  x8_2,  x8_3;
  char9    x9_0,  x9_1,  x9_2,  x9_3;
  short16 x16_0, x16_1;
  short18 x18_0, x18_1;
  int32   x32_0;
  int     x4_0 : 4;
};

struct S32 {
  int32 x32_0;
  int   x4_0 : 4;
};

static struct S s;
static volatile struct S vs;

static char6 x6[12];
static char7 x7[10];
static char8 x8[8];
static char9 x9[8];
static short16 x16[4];
static short18 x18[4];

static volatile char6 vx6[12];
static volatile char7 vx7[10];
static volatile char8 vx8[8];
static volatile char9 vx9[8];
static volatile short16 vx16[4];
static volatile short18 vx18[4];

static struct S32 x32[2];
static volatile struct S32 vx32[2];

#define STORE_STRUCT(len, pos)                        \
static void                                           \
store##len##_##pos(x)                                 \
int x;                                                \
{                                                     \
  s.x##len##_##pos = x;                               \
}

#define STORE_PTR(len, pos)                           \
static void                                           \
sptr##len##_##pos(p, x)                               \
struct S *p;                                          \
int x;                                                \
{                                                     \
  p->x##len##_##pos = x;                              \
}

#define STORE_VOLPTR(len, pos)                        \
static void                                           \
svptr##len##_##pos(p, x)                              \
volatile struct S *p;                                 \
int x;                                                \
{                                                     \
  p->x##len##_##pos = x;                              \
}

#define STORE_GLOBAL_VOL(len, pos)                    \
static void                                           \
svstore##len##_##pos(x)                               \
int x;                                                \
{                                                     \
  vs.x##len##_##pos = x;                              \
}

#define STORE_ARR(len, pos)                           \
static void                                           \
sarr##len##_##pos(x)                                  \
int x;                                                \
{                                                     \
  x##len[(36 / len) + pos] = x;                       \
}

#define STORE_VARR(len, pos)                          \
static void                                           \
svarr##len##_##pos(x)                                 \
int x;                                                \
{                                                     \
  vx##len[(36 / len) + pos] = x;                      \
}

#define STORE_ALL(len, pos)                           \
STORE_STRUCT(len, pos)                                \
STORE_PTR(len, pos)                                   \
STORE_VOLPTR(len, pos)                                \
STORE_GLOBAL_VOL(len, pos)                            \
STORE_ARR(len, pos)                                   \
STORE_VARR(len, pos)

STORE_ALL(6, 0)
STORE_ALL(6, 1)
STORE_ALL(6, 2)
STORE_ALL(6, 3)
STORE_ALL(6, 4)
STORE_ALL(6, 5)

STORE_ALL(7, 0)
STORE_ALL(7, 1)
STORE_ALL(7, 2)
STORE_ALL(7, 3)
STORE_ALL(7, 4)

STORE_ALL(8, 0)
STORE_ALL(8, 1)
STORE_ALL(8, 2)
STORE_ALL(8, 3)

STORE_ALL(9, 0)
STORE_ALL(9, 1)
STORE_ALL(9, 2)
STORE_ALL(9, 3)

STORE_ALL(16, 0)
STORE_ALL(16, 1)

STORE_ALL(18, 0)
STORE_ALL(18, 1)

static void
store32_0(x)
int x;
{
  s.x32_0 = x;
}

static void
sarr32_0(x)
int x;
{
  x32[1].x32_0 = x;
}

static void
sptr32_0(p, x)
struct S *p;
int x;
{
  p->x32_0 = x;
}

static void
svptr32_0(p, x)
volatile struct S *p;
int x;
{
  p->x32_0 = x;
}

static void
svstore32_0(x)
int x;
{
  vs.x32_0 = x;
}

static void
svarr32_0(x)
int x;
{
  vx32[1].x32_0 = x;
}

static void
store4_0(x)
int x;
{
  s.x4_0 = x;
}

static void
sarr4_0(x)
int x;
{
  x32[1].x4_0 = x;
}

static void
sptr4_0(p, x)
struct S *p;
int x;
{
  p->x4_0 = x;
}

static void
sptr4s_0(p, x)
struct S32 *p;
int x;
{
  p->x4_0 = x;
}

static void
svptr4_0(p, x)
volatile struct S *p;
int x;
{
  p->x4_0 = x;
}

static void
svptr4s_0(p, x)
volatile struct S32 *p;
int x;
{
  p->x4_0 = x;
}

static void
svstore4_0(x)
int x;
{
  vs.x4_0 = x;
}

static void
svarr4_0(x)
int x;
{
  vx32[1].x4_0 = x;
}

static void
store_mixed_struct(a, b, c, d, e, f, g)
int a;
int b;
int c;
int d;
int e;
int f;
int g;
{
  s.x6_0 = a;
  s.x7_1 = b;
  s.x8_2 = c;
  s.x9_3 = d;
  s.x16_1 = e;
  s.x18_0 = f;
  s.x32_0 = g;
}

static void
store_mixed_ptr(p, a, b, c, d, e, f, g)
struct S *p;
int a;
int b;
int c;
int d;
int e;
int f;
int g;
{
  p->x6_5 = a;
  p->x7_4 = b;
  p->x8_3 = c;
  p->x9_2 = d;
  p->x16_0 = e;
  p->x18_1 = f;
  p->x32_0 = g;
}

static void
store_mixed_volatile(p, a, b, c, d, e, f, g)
volatile struct S *p;
int a;
int b;
int c;
int d;
int e;
int f;
int g;
{
  p->x6_0 = a;
  p->x7_1 = b;
  p->x8_2 = c;
  p->x9_3 = d;
  p->x16_1 = e;
  p->x18_0 = f;
  p->x32_0 = g;
}

static int
store6_ret(x)
int x;
{
  s.x6_0 = x;
  return s.x6_0;
}

static int
store7_ret(x)
int x;
{
  s.x7_1 = x;
  return s.x7_1;
}

static int
store8_ret(x)
int x;
{
  s.x8_2 = x;
  return s.x8_2;
}

static int
store9_ret(x)
int x;
{
  s.x9_3 = x;
  return s.x9_3;
}

static int
store16_ret(x)
int x;
{
  s.x16_1 = x;
  return s.x16_1;
}

static int
store18_ret(x)
int x;
{
  s.x18_0 = x;
  return s.x18_0;
}

static int
store32_ret(x)
int x;
{
  s.x32_0 = x;
  return s.x32_0;
}

static int
store4_ret(x)
int x;
{
  s.x4_0 = x;
  return s.x4_0;
}

static int
sptr6_ret(p, x)
struct S *p;
int x;
{
  p->x6_0 = x;
  return p->x6_0;
}

static int
sptr9_ret(p, x)
struct S *p;
int x;
{
  p->x9_1 = x;
  return p->x9_1;
}

static int
sptr18_ret(p, x)
struct S *p;
int x;
{
  p->x18_1 = x;
  return p->x18_1;
}

static int
sptr32_ret(p, x)
struct S *p;
int x;
{
  p->x32_0 = x;
  return p->x32_0;
}

static int
sptr4_ret(p, x)
struct S *p;
int x;
{
  p->x4_0 = x;
  return p->x4_0;
}

static void
store6_const_zero(void)
{
  s.x6_0 = 0;
}

static void
store7_const_zero(void)
{
  s.x7_1 = 0;
}

static void
store8_const_zero(void)
{
  s.x8_2 = 0;
}

static void
store9_const_zero(void)
{
  s.x9_3 = 0;
}

static void
store16_const_zero(void)
{
  s.x16_1 = 0;
}

static void
store18_const_zero(void)
{
  s.x18_0 = 0;
}

static void
store32_const_zero(void)
{
  s.x32_0 = 0;
}

static void
store4_const_zero(void)
{
  s.x4_0 = 0;
}

static void
store6_const_minus_one(void)
{
  s.x6_0 = -1;
}

static void
store7_const_minus_one(void)
{
  s.x7_1 = -1;
}

static void
store8_const_minus_one(void)
{
  s.x8_2 = -1;
}

static void
store9_const_minus_one(void)
{
  s.x9_3 = -1;
}

static void
store16_const_minus_one(void)
{
  s.x16_1 = -1;
}

static void
store18_const_minus_one(void)
{
  s.x18_0 = -1;
}

static void
store32_const_minus_one(void)
{
  s.x32_0 = -1;
}

static void
store4_const_minus_one(void)
{
  s.x4_0 = -1;
}

static void
store6_const_maxpos(void)
{
  s.x6_0 = 037;
}

static void
store7_const_maxpos(void)
{
  s.x7_1 = 077;
}

static void
store8_const_maxpos(void)
{
  s.x8_2 = 0177;
}

static void
store9_const_maxpos(void)
{
  s.x9_3 = 0377;
}

static void
store16_const_maxpos(void)
{
  s.x16_1 = 077777;
}

static void
store18_const_maxpos(void)
{
  s.x18_0 = 0377777;
}

static void
store32_const_large(void)
{
  s.x32_0 = 0123456123;
}

static void
store4_const_maxpos(void)
{
  s.x4_0 = 07;
}

static void
store6_const_minneg(void)
{
  s.x6_0 = -040;
}

static void
store7_const_minneg(void)
{
  s.x7_1 = -0100;
}

static void
store8_const_minneg(void)
{
  s.x8_2 = -0200;
}

static void
store9_const_minneg(void)
{
  s.x9_3 = -0400;
}

static void
store16_const_minneg(void)
{
  s.x16_1 = -0100000;
}

static void
store18_const_minneg(void)
{
  s.x18_0 = -0400000;
}

static void
store32_const_neg_large(void)
{
  s.x32_0 = -0123456123;
}

static void
store4_const_minneg(void)
{
  s.x4_0 = -010;
}

static void
sidx6(i, x)
int i;
int x;
{
  i &= 07;
  x6[i] = x;
}

static void
sidx6_hi(i, x)
int i;
int x;
{
  i &= 07;
  x6[i + 4] = x;
}

static void
sidx7(i, x)
int i;
int x;
{
  i &= 07;
  x7[i] = x;
}

static void
sidx7_hi(i, x)
int i;
int x;
{
  i &= 03;
  x7[i + 5] = x;
}

static void
sidx8(i, x)
int i;
int x;
{
  i &= 07;
  x8[i] = x;
}

static void
sidx9(i, x)
int i;
int x;
{
  i &= 07;
  x9[i] = x;
}

static void
sidx16(i, x)
int i;
int x;
{
  i &= 03;
  x16[i] = x;
}

static void
sidx18(i, x)
int i;
int x;
{
  i &= 03;
  x18[i] = x;
}

static void
sidx32(i, x)
int i;
int x;
{
  i &= 01;
  x32[i].x32_0 = x;
}

static void
sidx4(i, x)
int i;
int x;
{
  i &= 01;
  x32[i].x4_0 = x;
}

static void
svidx6(i, x)
int i;
int x;
{
  i &= 07;
  vx6[i] = x;
}

static void
svidx6_hi(i, x)
int i;
int x;
{
  i &= 07;
  vx6[i + 4] = x;
}

static void
svidx7(i, x)
int i;
int x;
{
  i &= 07;
  vx7[i] = x;
}

static void
svidx7_hi(i, x)
int i;
int x;
{
  i &= 03;
  vx7[i + 5] = x;
}

static void
svidx8(i, x)
int i;
int x;
{
  i &= 07;
  vx8[i] = x;
}

static void
svidx9(i, x)
int i;
int x;
{
  i &= 07;
  vx9[i] = x;
}

static void
svidx16(i, x)
int i;
int x;
{
  i &= 03;
  vx16[i] = x;
}

static void
svidx18(i, x)
int i;
int x;
{
  i &= 03;
  vx18[i] = x;
}

static void
svidx32(i, x)
int i;
int x;
{
  i &= 01;
  vx32[i].x32_0 = x;
}

static void
svidx4(i, x)
int i;
int x;
{
  i &= 01;
  vx32[i].x4_0 = x;
}

static int
sidx6_ret(i, x)
int i;
int x;
{
  i &= 07;
  x6[i] = x;
  return x6[i];
}

static int
sidx9_ret(i, x)
int i;
int x;
{
  i &= 07;
  x9[i] = x;
  return x9[i];
}

static int
sidx18_ret(i, x)
int i;
int x;
{
  i &= 03;
  x18[i] = x;
  return x18[i];
}

static int
sidx32_ret(i, x)
int i;
int x;
{
  i &= 01;
  x32[i].x32_0 = x;
  return x32[i].x32_0;
}

static int
sidx4_ret(i, x)
int i;
int x;
{
  i &= 01;
  x32[i].x4_0 = x;
  return x32[i].x4_0;
}

static void
store6_expr(a, b)
int a;
int b;
{
  int x;

  x = a + b;
  OPAQUE_REG(x);
  s.x6_0 = x;
}

static void
store7_expr(a, b)
int a;
int b;
{
  int x;

  x = a - b;
  OPAQUE_REG(x);
  s.x7_1 = x;
}

static void
store8_expr(a, b)
int a;
int b;
{
  int x;

  x = a ^ b;
  OPAQUE_REG(x);
  s.x8_2 = x;
}

static void
store9_expr(a, b)
int a;
int b;
{
  int x;

  x = a | b;
  OPAQUE_REG(x);
  s.x9_3 = x;
}

static void
store16_expr(a, b)
int a;
int b;
{
  int x;

  x = a & b;
  OPAQUE_REG(x);
  s.x16_1 = x;
}

static void
store18_expr(a, b)
int a;
int b;
{
  int x;

  x = a + b;
  OPAQUE_REG(x);
  s.x18_0 = x;
}

static void
store32_expr(a, b)
int a;
int b;
{
  int x;

  x = a - b;
  OPAQUE_REG(x);
  s.x32_0 = x;
}

static void
store4_expr(a, b)
int a;
int b;
{
  int x;

  x = a ^ b;
  OPAQUE_REG(x);
  s.x4_0 = x;
}

static int
update6_add(x)
int x;
{
  s.x6_0 = s.x6_0 + x;
  return s.x6_0;
}

static int
update7_sub(x)
int x;
{
  s.x7_1 = s.x7_1 - x;
  return s.x7_1;
}

static int
update8_xor(x)
int x;
{
  s.x8_2 = s.x8_2 ^ x;
  return s.x8_2;
}

static int
update9_or(x)
int x;
{
  s.x9_3 = s.x9_3 | x;
  return s.x9_3;
}

static int
update16_and(x)
int x;
{
  s.x16_1 = s.x16_1 & x;
  return s.x16_1;
}

static int
update18_add(x)
int x;
{
  s.x18_0 = s.x18_0 + x;
  return s.x18_0;
}

static int
update32_add(x)
int x;
{
  s.x32_0 = s.x32_0 + x;
  return s.x32_0;
}

static int
update4_add(x)
int x;
{
  s.x4_0 = s.x4_0 + x;
  return s.x4_0;
}

static int
ptr_update6_add(p, x)
struct S *p;
int x;
{
  p->x6_0 = p->x6_0 + x;
  return p->x6_0;
}

static int
ptr_update9_add(p, x)
struct S *p;
int x;
{
  p->x9_1 = p->x9_1 + x;
  return p->x9_1;
}

static int
ptr_update18_add(p, x)
struct S *p;
int x;
{
  p->x18_1 = p->x18_1 + x;
  return p->x18_1;
}

static int
ptr_update32_add(p, x)
struct S *p;
int x;
{
  p->x32_0 = p->x32_0 + x;
  return p->x32_0;
}

static int
ptr_update4_add(p, x)
struct S *p;
int x;
{
  p->x4_0 = p->x4_0 + x;
  return p->x4_0;
}

static void
store6_call_pressure(x)
int x;
{
  extern void clobber(void);

  OPAQUE_REG(x);
  s.x6_0 = x;
  clobber();
  s.x6_1 = x + 1;
}

static void
store9_call_pressure(x)
int x;
{
  extern void clobber(void);

  OPAQUE_REG(x);
  s.x9_0 = x;
  clobber();
  s.x9_1 = x + 1;
}

static void
store18_call_pressure(x)
int x;
{
  extern void clobber(void);

  OPAQUE_REG(x);
  s.x18_0 = x;
  clobber();
  s.x18_1 = x + 1;
}

static void
store32_call_pressure(x)
int x;
{
  extern void clobber(void);

  OPAQUE_REG(x);
  s.x32_0 = x;
  clobber();
  s.x32_0 = x + 1;
}

static void
store4_call_pressure(x)
int x;
{
  extern void clobber(void);

  OPAQUE_REG(x);
  s.x4_0 = x;
  clobber();
  s.x4_0 = x + 1;
}

static int
store6_branch(x)
int x;
{
  OPAQUE_REG(x);
  s.x6_0 = x;

  if (s.x6_0 == 0)
    return 1;
  return s.x6_0;
}

static int
store9_branch(x)
int x;
{
  OPAQUE_REG(x);
  s.x9_1 = x;

  if (s.x9_1 < 0)
    return -1;
  return s.x9_1;
}

static int
store18_branch(x)
int x;
{
  OPAQUE_REG(x);
  s.x18_1 = x;

  if (s.x18_1 == 0)
    return 1;
  return s.x18_1;
}

static int
store32_branch(x)
int x;
{
  OPAQUE_REG(x);
  s.x32_0 = x;

  if (s.x32_0 < 0)
    return -1;
  return s.x32_0;
}

static int
store4_branch(x)
int x;
{
  OPAQUE_REG(x);
  s.x4_0 = x;

  if (s.x4_0 == 0)
    return 1;
  return s.x4_0;
}

static void
store_loop6(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x6[i & 07] = x + i;
}

static void
store_loop7(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x7[i & 07] = x + i;
}

static void
store_loop8(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x8[i & 07] = x + i;
}

static void
store_loop9(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x9[i & 07] = x + i;
}

static void
store_loop16(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x16[i & 03] = x + i;
}

static void
store_loop18(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x18[i & 03] = x + i;
}

static void
store_loop32(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x32[i & 01].x32_0 = x + i;
}

static void
store_loop4(n, x)
int n;
int x;
{
  int i;

  OPAQUE_REG(x);

  for (i = 0; i < n; ++i)
    x32[i & 01].x4_0 = x + i;
}

static int
store_loop6_sum(n, x)
int n;
int x;
{
  int i;
  int r;

  OPAQUE_REG(x);
  r = 0;

  for (i = 0; i < n; ++i) {
    x6[i & 07] = x + i;
    r += x6[i & 07];
  }

  return r;
}

static int
store_loop9_sum(n, x)
int n;
int x;
{
  int i;
  int r;

  OPAQUE_REG(x);
  r = 0;

  for (i = 0; i < n; ++i) {
    x9[i & 07] = x + i;
    r += x9[i & 07];
  }

  return r;
}

static int
store_loop18_sum(n, x)
int n;
int x;
{
  int i;
  int r;

  OPAQUE_REG(x);
  r = 0;

  for (i = 0; i < n; ++i) {
    x18[i & 03] = x + i;
    r += x18[i & 03];
  }

  return r;
}

static int
store_loop32_sum(n, x)
int n;
int x;
{
  int i;
  int r;

  OPAQUE_REG(x);
  r = 0;

  for (i = 0; i < n; ++i) {
    x32[i & 01].x32_0 = x + i;
    r += x32[i & 01].x32_0;
  }

  return r;
}

static int
store_loop4_sum(n, x)
int n;
int x;
{
  int i;
  int r;

  OPAQUE_REG(x);
  r = 0;

  for (i = 0; i < n; ++i) {
    x32[i & 01].x4_0 = x + i;
    r += x32[i & 01].x4_0;
  }

  return r;
}

/*
 * Manual word insertion shapes.  These are not the primary source of
 * insv coverage, but they are useful combine targets and catch broken
 * mask/shift insertion sequences.
 */

static void
insert_low6(p, x)
uSint *p;
int x;
{
  *p = (*p & ~077) | (x & 077);
}

static void
insert_low9(p, x)
uSint *p;
int x;
{
  *p = (*p & ~0777) | (x & 0777);
}

static void
insert_low18(p, x)
uSint *p;
int x;
{
  *p = (*p & ~0777777) | (x & 0777777);
}

static void
insert_mid6(p, x)
uSint *p;
int x;
{
  *p = (*p & ~(077 << 18)) | ((x & 077) << 18);
}

static void
insert_mid9(p, x)
uSint *p;
int x;
{
  *p = (*p & ~(0777 << 18)) | ((x & 0777) << 18);
}

static void
insert_left18(p, x)
uSint *p;
int x;
{
  *p = (*p & 0777777) | ((x & 0777777) << 18);
}

static uSint
insert_low9_ret(p, x)
uSint *p;
int x;
{
  *p = (*p & ~0777) | (x & 0777);
  return *p;
}

static uSint
insert_left18_ret(p, x)
uSint *p;
int x;
{
  *p = (*p & 0777777) | ((x & 0777777) << 18);
  return *p;
}
