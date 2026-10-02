#include "insns.h"

/*
 * Array element reference pressure.
 *
 * File:
 *   misc/array-eref.c
 *
 * This is a misc test, not a single instruction-pattern test.
 *
 * It stresses:
 *   - a[i] loads from pointer bases
 *   - A[i] loads from static array bases
 *   - a[i] stores through pointer bases
 *   - A[i] stores through static array bases
 *   - signed and unsigned QI/HI/SI/DI element types
 *   - constant, variable, negative, and expression indices
 *   - address-of element forms
 *   - pointer-walk forms derived from array references
 *
 * Floating point cases from the original seed are kept behind
 * ARRAY_EREF_ENABLE_FLOAT.  The current PDP-6/KA10 review pass excludes
 * floating point.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Qint AQint[0100];
static uQint AuQint[0100];
static Hint AHint[0100];
static uHint AuHint[0100];
static Sint ASint[0100];
static uSint AuSint[0100];
static Dint ADint[0100];
static uDint AuDint[0100];

static volatile Qint VAQint[0100];
static volatile uQint VAuQint[0100];
static volatile Hint VAHint[0100];
static volatile uHint VAuHint[0100];
static volatile Sint VASint[0100];
static volatile uSint VAuSint[0100];
static volatile Dint VADint[0100];
static volatile uDint VAuDint[0100];

#ifdef ARRAY_EREF_ENABLE_FLOAT
static Sfloat ASfloat[0100];
static Dfloat ADfloat[0100];
static volatile Sfloat VASfloat[0100];
static volatile Dfloat VADfloat[0100];
#endif

struct q_pair {
  Qint a;
  Qint b;
};

struct h_pair {
  Hint a;
  Hint b;
};

struct s_pair {
  Sint a;
  Sint b;
};

struct d_pair {
  Dint a;
  Dint b;
};

static struct q_pair Aqpair[0100];
static struct h_pair Ahpair[0100];
static struct s_pair Aspair[0100];
static struct d_pair Adpair[0100];

/*
 * Original seed shape, kept as macro-generated base cases.
 */

#define LOAD1(T)                                                \
static T                                                        \
load1_##T(a, i)                                                 \
T *a;                                                           \
int i;                                                          \
{                                                               \
  return a[i];                                                  \
}

#define LOAD2(T)                                                \
static T                                                        \
load2_##T(i)                                                    \
int i;                                                          \
{                                                               \
  return A##T[i];                                               \
}

#define STORE1(T)                                               \
static void                                                     \
store1_##T(a, i, x)                                             \
T *a;                                                           \
int i;                                                          \
T x;                                                            \
{                                                               \
  a[i] = x;                                                     \
}

#define STORE2(T)                                               \
static void                                                     \
store2_##T(i, x)                                                \
int i;                                                          \
T x;                                                            \
{                                                               \
  A##T[i] = x;                                                  \
}

#define TEST(T)                                                 \
LOAD1(T)                                                        \
LOAD2(T)                                                        \
STORE1(T)                                                       \
STORE2(T)

TEST(Qint)
TEST(uQint)
TEST(Hint)
TEST(uHint)
TEST(Sint)
TEST(uSint)
TEST(Dint)
TEST(uDint)

#ifdef ARRAY_EREF_ENABLE_FLOAT
TEST(Sfloat)
TEST(Dfloat)
#endif

/*
 * Constant-index loads.
 */

static Qint
q_load_0()
{
  return AQint[0];
}

static Qint
q_load_1()
{
  return AQint[1];
}

static Qint
q_load_2()
{
  return AQint[2];
}

static Qint
q_load_3()
{
  return AQint[3];
}

static Qint
q_load_4()
{
  return AQint[4];
}

static Qint
q_load_7()
{
  return AQint[7];
}

static Qint
q_load_010()
{
  return AQint[010];
}

static Qint
q_load_077()
{
  return AQint[077];
}

static uQint
uq_load_077()
{
  return AuQint[077];
}

static Hint
h_load_077()
{
  return AHint[077];
}

static uHint
uh_load_077()
{
  return AuHint[077];
}

static Sint
s_load_077()
{
  return ASint[077];
}

static uSint
us_load_077()
{
  return AuSint[077];
}

static Dint
d_load_077()
{
  return ADint[077];
}

static uDint
ud_load_077()
{
  return AuDint[077];
}

/*
 * Constant-index stores.
 */

static void
q_store_0(x)
Qint x;
{
  AQint[0] = x;
}

static void
q_store_1(x)
Qint x;
{
  AQint[1] = x;
}

static void
q_store_2(x)
Qint x;
{
  AQint[2] = x;
}

static void
q_store_3(x)
Qint x;
{
  AQint[3] = x;
}

static void
q_store_4(x)
Qint x;
{
  AQint[4] = x;
}

static void
q_store_7(x)
Qint x;
{
  AQint[7] = x;
}

static void
q_store_010(x)
Qint x;
{
  AQint[010] = x;
}

static void
q_store_077(x)
Qint x;
{
  AQint[077] = x;
}

static void
uq_store_077(x)
uQint x;
{
  AuQint[077] = x;
}

static void
h_store_077(x)
Hint x;
{
  AHint[077] = x;
}

static void
uh_store_077(x)
uHint x;
{
  AuHint[077] = x;
}

static void
s_store_077(x)
Sint x;
{
  ASint[077] = x;
}

static void
us_store_077(x)
uSint x;
{
  AuSint[077] = x;
}

static void
d_store_077(x)
Dint x;
{
  ADint[077] = x;
}

static void
ud_store_077(x)
uDint x;
{
  AuDint[077] = x;
}

/*
 * Variable index through static arrays.
 */

static Qint
q_load_i(i)
Sint i;
{
  return AQint[i];
}

static uQint
uq_load_i(i)
Sint i;
{
  return AuQint[i];
}

static Hint
h_load_i(i)
Sint i;
{
  return AHint[i];
}

static uHint
uh_load_i(i)
Sint i;
{
  return AuHint[i];
}

static Sint
s_load_i(i)
Sint i;
{
  return ASint[i];
}

static uSint
us_load_i(i)
Sint i;
{
  return AuSint[i];
}

static Dint
d_load_i(i)
Sint i;
{
  return ADint[i];
}

static uDint
ud_load_i(i)
Sint i;
{
  return AuDint[i];
}

static void
q_store_i(i, x)
Sint i;
Qint x;
{
  AQint[i] = x;
}

static void
uq_store_i(i, x)
Sint i;
uQint x;
{
  AuQint[i] = x;
}

static void
h_store_i(i, x)
Sint i;
Hint x;
{
  AHint[i] = x;
}

static void
uh_store_i(i, x)
Sint i;
uHint x;
{
  AuHint[i] = x;
}

static void
s_store_i(i, x)
Sint i;
Sint x;
{
  ASint[i] = x;
}

static void
us_store_i(i, x)
Sint i;
uSint x;
{
  AuSint[i] = x;
}

static void
d_store_i(i, x)
Sint i;
Dint x;
{
  ADint[i] = x;
}

static void
ud_store_i(i, x)
Sint i;
uDint x;
{
  AuDint[i] = x;
}

/*
 * Masked variable index.  These avoid undefined out-of-range access in
 * simple runtime harnesses while still producing indexed addressing.
 */

static Qint
q_load_masked(i)
Sint i;
{
  return AQint[i & 077];
}

static uQint
uq_load_masked(i)
Sint i;
{
  return AuQint[i & 077];
}

static Hint
h_load_masked(i)
Sint i;
{
  return AHint[i & 077];
}

static uHint
uh_load_masked(i)
Sint i;
{
  return AuHint[i & 077];
}

static Sint
s_load_masked(i)
Sint i;
{
  return ASint[i & 077];
}

static uSint
us_load_masked(i)
Sint i;
{
  return AuSint[i & 077];
}

static Dint
d_load_masked(i)
Sint i;
{
  return ADint[i & 077];
}

static uDint
ud_load_masked(i)
Sint i;
{
  return AuDint[i & 077];
}

static void
q_store_masked(i, x)
Sint i;
Qint x;
{
  AQint[i & 077] = x;
}

static void
uq_store_masked(i, x)
Sint i;
uQint x;
{
  AuQint[i & 077] = x;
}

static void
h_store_masked(i, x)
Sint i;
Hint x;
{
  AHint[i & 077] = x;
}

static void
uh_store_masked(i, x)
Sint i;
uHint x;
{
  AuHint[i & 077] = x;
}

static void
s_store_masked(i, x)
Sint i;
Sint x;
{
  ASint[i & 077] = x;
}

static void
us_store_masked(i, x)
Sint i;
uSint x;
{
  AuSint[i & 077] = x;
}

static void
d_store_masked(i, x)
Sint i;
Dint x;
{
  ADint[i & 077] = x;
}

static void
ud_store_masked(i, x)
Sint i;
uDint x;
{
  AuDint[i & 077] = x;
}

/*
 * Pointer-base variable index.
 */

static Qint
q_ptr_load_i(a, i)
Qint *a;
Sint i;
{
  return a[i];
}

static uQint
uq_ptr_load_i(a, i)
uQint *a;
Sint i;
{
  return a[i];
}

static Hint
h_ptr_load_i(a, i)
Hint *a;
Sint i;
{
  return a[i];
}

static uHint
uh_ptr_load_i(a, i)
uHint *a;
Sint i;
{
  return a[i];
}

static Sint
s_ptr_load_i(a, i)
Sint *a;
Sint i;
{
  return a[i];
}

static uSint
us_ptr_load_i(a, i)
uSint *a;
Sint i;
{
  return a[i];
}

static Dint
d_ptr_load_i(a, i)
Dint *a;
Sint i;
{
  return a[i];
}

static uDint
ud_ptr_load_i(a, i)
uDint *a;
Sint i;
{
  return a[i];
}

static void
q_ptr_store_i(a, i, x)
Qint *a;
Sint i;
Qint x;
{
  a[i] = x;
}

static void
uq_ptr_store_i(a, i, x)
uQint *a;
Sint i;
uQint x;
{
  a[i] = x;
}

static void
h_ptr_store_i(a, i, x)
Hint *a;
Sint i;
Hint x;
{
  a[i] = x;
}

static void
uh_ptr_store_i(a, i, x)
uHint *a;
Sint i;
uHint x;
{
  a[i] = x;
}

static void
s_ptr_store_i(a, i, x)
Sint *a;
Sint i;
Sint x;
{
  a[i] = x;
}

static void
us_ptr_store_i(a, i, x)
uSint *a;
Sint i;
uSint x;
{
  a[i] = x;
}

static void
d_ptr_store_i(a, i, x)
Dint *a;
Sint i;
Dint x;
{
  a[i] = x;
}

static void
ud_ptr_store_i(a, i, x)
uDint *a;
Sint i;
uDint x;
{
  a[i] = x;
}

/*
 * Index expression forms.
 */

static Qint
q_load_i_plus_1(i)
Sint i;
{
  return AQint[(i + 1) & 077];
}

static Qint
q_load_i_plus_2(i)
Sint i;
{
  return AQint[(i + 2) & 077];
}

static Qint
q_load_i_minus_1(i)
Sint i;
{
  return AQint[(i - 1) & 077];
}

static Qint
q_load_sum_index(i, j)
Sint i;
Sint j;
{
  return AQint[(i + j) & 077];
}

static Qint
q_load_diff_index(i, j)
Sint i;
Sint j;
{
  return AQint[(i - j) & 077];
}

static Hint
h_load_i_plus_1(i)
Sint i;
{
  return AHint[(i + 1) & 077];
}

static Hint
h_load_i_plus_2(i)
Sint i;
{
  return AHint[(i + 2) & 077];
}

static Hint
h_load_i_minus_1(i)
Sint i;
{
  return AHint[(i - 1) & 077];
}

static Hint
h_load_sum_index(i, j)
Sint i;
Sint j;
{
  return AHint[(i + j) & 077];
}

static Sint
s_load_i_plus_1(i)
Sint i;
{
  return ASint[(i + 1) & 077];
}

static Sint
s_load_i_plus_2(i)
Sint i;
{
  return ASint[(i + 2) & 077];
}

static Sint
s_load_i_minus_1(i)
Sint i;
{
  return ASint[(i - 1) & 077];
}

static Sint
s_load_sum_index(i, j)
Sint i;
Sint j;
{
  return ASint[(i + j) & 077];
}

static Dint
d_load_i_plus_1(i)
Sint i;
{
  return ADint[(i + 1) & 077];
}

static Dint
d_load_i_plus_2(i)
Sint i;
{
  return ADint[(i + 2) & 077];
}

static Dint
d_load_i_minus_1(i)
Sint i;
{
  return ADint[(i - 1) & 077];
}

/*
 * Store with index expression forms.
 */

static void
q_store_i_plus_1(i, x)
Sint i;
Qint x;
{
  AQint[(i + 1) & 077] = x;
}

static void
q_store_i_plus_2(i, x)
Sint i;
Qint x;
{
  AQint[(i + 2) & 077] = x;
}

static void
q_store_i_minus_1(i, x)
Sint i;
Qint x;
{
  AQint[(i - 1) & 077] = x;
}

static void
q_store_sum_index(i, j, x)
Sint i;
Sint j;
Qint x;
{
  AQint[(i + j) & 077] = x;
}

static void
h_store_i_plus_1(i, x)
Sint i;
Hint x;
{
  AHint[(i + 1) & 077] = x;
}

static void
h_store_i_plus_2(i, x)
Sint i;
Hint x;
{
  AHint[(i + 2) & 077] = x;
}

static void
h_store_i_minus_1(i, x)
Sint i;
Hint x;
{
  AHint[(i - 1) & 077] = x;
}

static void
s_store_i_plus_1(i, x)
Sint i;
Sint x;
{
  ASint[(i + 1) & 077] = x;
}

static void
s_store_i_plus_2(i, x)
Sint i;
Sint x;
{
  ASint[(i + 2) & 077] = x;
}

static void
s_store_i_minus_1(i, x)
Sint i;
Sint x;
{
  ASint[(i - 1) & 077] = x;
}

static void
d_store_i_plus_1(i, x)
Sint i;
Dint x;
{
  ADint[(i + 1) & 077] = x;
}

static void
d_store_i_plus_2(i, x)
Sint i;
Dint x;
{
  ADint[(i + 2) & 077] = x;
}

/*
 * Return value after store.
 */

static Qint
q_store_i_return(i, x)
Sint i;
Qint x;
{
  return AQint[i & 077] = x;
}

static uQint
uq_store_i_return(i, x)
Sint i;
uQint x;
{
  return AuQint[i & 077] = x;
}

static Hint
h_store_i_return(i, x)
Sint i;
Hint x;
{
  return AHint[i & 077] = x;
}

static uHint
uh_store_i_return(i, x)
Sint i;
uHint x;
{
  return AuHint[i & 077] = x;
}

static Sint
s_store_i_return(i, x)
Sint i;
Sint x;
{
  return ASint[i & 077] = x;
}

static uSint
us_store_i_return(i, x)
Sint i;
uSint x;
{
  return AuSint[i & 077] = x;
}

static Dint
d_store_i_return(i, x)
Sint i;
Dint x;
{
  return ADint[i & 077] = x;
}

static uDint
ud_store_i_return(i, x)
Sint i;
uDint x;
{
  return AuDint[i & 077] = x;
}

/*
 * Volatile static arrays.
 */

static Qint
vq_load_i(i)
Sint i;
{
  return VAQint[i & 077];
}

static uQint
vuq_load_i(i)
Sint i;
{
  return VAuQint[i & 077];
}

static Hint
vh_load_i(i)
Sint i;
{
  return VAHint[i & 077];
}

static uHint
vuh_load_i(i)
Sint i;
{
  return VAuHint[i & 077];
}

static Sint
vs_load_i(i)
Sint i;
{
  return VASint[i & 077];
}

static uSint
vus_load_i(i)
Sint i;
{
  return VAuSint[i & 077];
}

static Dint
vd_load_i(i)
Sint i;
{
  return VADint[i & 077];
}

static uDint
vud_load_i(i)
Sint i;
{
  return VAuDint[i & 077];
}

static void
vq_store_i(i, x)
Sint i;
Qint x;
{
  VAQint[i & 077] = x;
}

static void
vuq_store_i(i, x)
Sint i;
uQint x;
{
  VAuQint[i & 077] = x;
}

static void
vh_store_i(i, x)
Sint i;
Hint x;
{
  VAHint[i & 077] = x;
}

static void
vuh_store_i(i, x)
Sint i;
uHint x;
{
  VAuHint[i & 077] = x;
}

static void
vs_store_i(i, x)
Sint i;
Sint x;
{
  VASint[i & 077] = x;
}

static void
vus_store_i(i, x)
Sint i;
uSint x;
{
  VAuSint[i & 077] = x;
}

static void
vd_store_i(i, x)
Sint i;
Dint x;
{
  VADint[i & 077] = x;
}

static void
vud_store_i(i, x)
Sint i;
uDint x;
{
  VAuDint[i & 077] = x;
}

/*
 * Address-of array element forms.
 */

static Qint *
q_addr_i(i)
Sint i;
{
  return &AQint[i & 077];
}

static uQint *
uq_addr_i(i)
Sint i;
{
  return &AuQint[i & 077];
}

static Hint *
h_addr_i(i)
Sint i;
{
  return &AHint[i & 077];
}

static uHint *
uh_addr_i(i)
Sint i;
{
  return &AuHint[i & 077];
}

static Sint *
s_addr_i(i)
Sint i;
{
  return &ASint[i & 077];
}

static uSint *
us_addr_i(i)
Sint i;
{
  return &AuSint[i & 077];
}

static Dint *
d_addr_i(i)
Sint i;
{
  return &ADint[i & 077];
}

static uDint *
ud_addr_i(i)
Sint i;
{
  return &AuDint[i & 077];
}

static Qint *
q_ptr_addr_i(a, i)
Qint *a;
Sint i;
{
  return &a[i];
}

static Hint *
h_ptr_addr_i(a, i)
Hint *a;
Sint i;
{
  return &a[i];
}

static Sint *
s_ptr_addr_i(a, i)
Sint *a;
Sint i;
{
  return &a[i];
}

static Dint *
d_ptr_addr_i(a, i)
Dint *a;
Sint i;
{
  return &a[i];
}

/*
 * Load through computed element address.
 */

static Qint
q_addr_load_i(i)
Sint i;
{
  Qint *p;

  p = &AQint[i & 077];
  return *p;
}

static Hint
h_addr_load_i(i)
Sint i;
{
  Hint *p;

  p = &AHint[i & 077];
  return *p;
}

static Sint
s_addr_load_i(i)
Sint i;
{
  Sint *p;

  p = &ASint[i & 077];
  return *p;
}

static Dint
d_addr_load_i(i)
Sint i;
{
  Dint *p;

  p = &ADint[i & 077];
  return *p;
}

/*
 * Store through computed element address.
 */

static void
q_addr_store_i(i, x)
Sint i;
Qint x;
{
  Qint *p;

  p = &AQint[i & 077];
  *p = x;
}

static void
h_addr_store_i(i, x)
Sint i;
Hint x;
{
  Hint *p;

  p = &AHint[i & 077];
  *p = x;
}

static void
s_addr_store_i(i, x)
Sint i;
Sint x;
{
  Sint *p;

  p = &ASint[i & 077];
  *p = x;
}

static void
d_addr_store_i(i, x)
Sint i;
Dint x;
{
  Dint *p;

  p = &ADint[i & 077];
  *p = x;
}

/*
 * Element update forms.
 */

static void
q_inc_i(i)
Sint i;
{
  AQint[i & 077] = (Qint)(AQint[i & 077] + 1);
}

static Qint
q_inc_i_return(i)
Sint i;
{
  return AQint[i & 077] = (Qint)(AQint[i & 077] + 1);
}

static void
uq_inc_i(i)
Sint i;
{
  AuQint[i & 077] = (uQint)(AuQint[i & 077] + 1);
}

static uQint
uq_inc_i_return(i)
Sint i;
{
  return AuQint[i & 077] = (uQint)(AuQint[i & 077] + 1);
}

static void
h_inc_i(i)
Sint i;
{
  AHint[i & 077] = (Hint)(AHint[i & 077] + 1);
}

static Hint
h_inc_i_return(i)
Sint i;
{
  return AHint[i & 077] = (Hint)(AHint[i & 077] + 1);
}

static void
uh_inc_i(i)
Sint i;
{
  AuHint[i & 077] = (uHint)(AuHint[i & 077] + 1);
}

static uHint
uh_inc_i_return(i)
Sint i;
{
  return AuHint[i & 077] = (uHint)(AuHint[i & 077] + 1);
}

static void
s_inc_i(i)
Sint i;
{
  ASint[i & 077] = ASint[i & 077] + 1;
}

static Sint
s_inc_i_return(i)
Sint i;
{
  return ASint[i & 077] = ASint[i & 077] + 1;
}

static void
us_inc_i(i)
Sint i;
{
  AuSint[i & 077] = AuSint[i & 077] + 1;
}

static uSint
us_inc_i_return(i)
Sint i;
{
  return AuSint[i & 077] = AuSint[i & 077] + 1;
}

/*
 * Dint update forms limited to add/sub.  Do not put DImode division
 * here; that belongs to the libgcc fallback tests.
 */

static void
d_add_i(i, x)
Sint i;
Dint x;
{
  ADint[i & 077] = ADint[i & 077] + x;
}

static Dint
d_add_i_return(i, x)
Sint i;
Dint x;
{
  return ADint[i & 077] = ADint[i & 077] + x;
}

static void
ud_add_i(i, x)
Sint i;
uDint x;
{
  AuDint[i & 077] = AuDint[i & 077] + x;
}

static uDint
ud_add_i_return(i, x)
Sint i;
uDint x;
{
  return AuDint[i & 077] = AuDint[i & 077] + x;
}

/*
 * Copy between pointer and static array.
 */

static void
q_copy_in(src, n)
Qint *src;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    AQint[i & 077] = src[i];
}

static void
q_copy_out(dst, n)
Qint *dst;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    dst[i] = AQint[i & 077];
}

static void
h_copy_in(src, n)
Hint *src;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    AHint[i & 077] = src[i];
}

static void
h_copy_out(dst, n)
Hint *dst;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    dst[i] = AHint[i & 077];
}

static void
s_copy_in(src, n)
Sint *src;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    ASint[i & 077] = src[i];
}

static void
s_copy_out(dst, n)
Sint *dst;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    dst[i] = ASint[i & 077];
}

static void
d_copy_in(src, n)
Dint *src;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    ADint[i & 077] = src[i];
}

static void
d_copy_out(dst, n)
Dint *dst;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    dst[i] = ADint[i & 077];
}

/*
 * Array element references in conditionals.
 */

static Sint
q_if_eq_zero(i)
Sint i;
{
  if (AQint[i & 077] == 0)
    return 1;
  return 0;
}

static Sint
q_if_lt_zero(i)
Sint i;
{
  if (AQint[i & 077] < 0)
    return -1;
  return 1;
}

static Sint
uq_if_gt_0177(i)
Sint i;
{
  if (AuQint[i & 077] > 0177)
    return 1;
  return 0;
}

static Sint
h_if_eq_zero(i)
Sint i;
{
  if (AHint[i & 077] == 0)
    return 1;
  return 0;
}

static Sint
h_if_lt_zero(i)
Sint i;
{
  if (AHint[i & 077] < 0)
    return -1;
  return 1;
}

static Sint
uh_if_gt_077777(i)
Sint i;
{
  if (AuHint[i & 077] > 077777)
    return 1;
  return 0;
}

static Sint
s_if_eq_zero(i)
Sint i;
{
  if (ASint[i & 077] == 0)
    return 1;
  return 0;
}

static Sint
s_if_lt_zero(i)
Sint i;
{
  if (ASint[i & 077] < 0)
    return -1;
  return 1;
}

static Sint
d_if_eq(i, x)
Sint i;
Dint x;
{
  if (ADint[i & 077] == x)
    return 1;
  return 0;
}

/*
 * Struct array element reference forms.
 */

static Qint
qpair_load_a(i)
Sint i;
{
  return Aqpair[i & 077].a;
}

static Qint
qpair_load_b(i)
Sint i;
{
  return Aqpair[i & 077].b;
}

static void
qpair_store_a(i, x)
Sint i;
Qint x;
{
  Aqpair[i & 077].a = x;
}

static void
qpair_store_b(i, x)
Sint i;
Qint x;
{
  Aqpair[i & 077].b = x;
}

static Hint
hpair_load_a(i)
Sint i;
{
  return Ahpair[i & 077].a;
}

static Hint
hpair_load_b(i)
Sint i;
{
  return Ahpair[i & 077].b;
}

static void
hpair_store_a(i, x)
Sint i;
Hint x;
{
  Ahpair[i & 077].a = x;
}

static void
hpair_store_b(i, x)
Sint i;
Hint x;
{
  Ahpair[i & 077].b = x;
}

static Sint
spair_load_a(i)
Sint i;
{
  return Aspair[i & 077].a;
}

static Sint
spair_load_b(i)
Sint i;
{
  return Aspair[i & 077].b;
}

static void
spair_store_a(i, x)
Sint i;
Sint x;
{
  Aspair[i & 077].a = x;
}

static void
spair_store_b(i, x)
Sint i;
Sint x;
{
  Aspair[i & 077].b = x;
}

static Dint
dpair_load_a(i)
Sint i;
{
  return Adpair[i & 077].a;
}

static Dint
dpair_load_b(i)
Sint i;
{
  return Adpair[i & 077].b;
}

static void
dpair_store_a(i, x)
Sint i;
Dint x;
{
  Adpair[i & 077].a = x;
}

static void
dpair_store_b(i, x)
Sint i;
Dint x;
{
  Adpair[i & 077].b = x;
}

/*
 * Pointer-walk forms derived from array references.
 */

static Qint
q_postinc_load(p)
Qint *p;
{
  return *p++;
}

static void
q_postinc_store(p, x)
Qint *p;
Qint x;
{
  *p++ = x;
}

static Hint
h_postinc_load(p)
Hint *p;
{
  return *p++;
}

static void
h_postinc_store(p, x)
Hint *p;
Hint x;
{
  *p++ = x;
}

static Sint
s_postinc_load(p)
Sint *p;
{
  return *p++;
}

static void
s_postinc_store(p, x)
Sint *p;
Sint x;
{
  *p++ = x;
}

static Dint
d_postinc_load(p)
Dint *p;
{
  return *p++;
}

static void
d_postinc_store(p, x)
Dint *p;
Dint x;
{
  *p++ = x;
}

/*
 * Loops using element references.
 */

static Sint
q_sum_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += AQint[i & 077];
  return s;
}

static uSint
uq_sum_n(n)
Sint n;
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += AuQint[i & 077];
  return s;
}

static Sint
h_sum_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += AHint[i & 077];
  return s;
}

static uSint
uh_sum_n(n)
Sint n;
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += AuHint[i & 077];
  return s;
}

static Sint
s_sum_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += ASint[i & 077];
  return s;
}

static uSint
us_sum_n(n)
Sint n;
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += AuSint[i & 077];
  return s;
}

static Dint
d_sum_n(n)
Sint n;
{
  Sint i;
  Dint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += ADint[i & 077];
  return s;
}

static uDint
ud_sum_n(n)
Sint n;
{
  Sint i;
  uDint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += AuDint[i & 077];
  return s;
}

/*
 * Call barriers to keep selected address calculations live.
 */

static Qint
q_load_after_call(i)
Sint i;
{
  clobber();
  return AQint[i & 077];
}

static void
q_store_after_call(i, x)
Sint i;
Qint x;
{
  clobber();
  AQint[i & 077] = x;
}

static Hint
h_load_after_call(i)
Sint i;
{
  clobber();
  return AHint[i & 077];
}

static void
h_store_after_call(i, x)
Sint i;
Hint x;
{
  clobber();
  AHint[i & 077] = x;
}

static Sint
s_load_after_call(i)
Sint i;
{
  clobber();
  return ASint[i & 077];
}

static void
s_store_after_call(i, x)
Sint i;
Sint x;
{
  clobber();
  ASint[i & 077] = x;
}

static Dint
d_load_after_call(i)
Sint i;
{
  clobber();
  return ADint[i & 077];
}

static void
d_store_after_call(i, x)
Sint i;
Dint x;
{
  clobber();
  ADint[i & 077] = x;
}

/*
 * Index values produced by calls.
 */

static Qint
q_load_call_index()
{
  return AQint[f() & 077];
}

static void
q_store_call_index(x)
Qint x;
{
  AQint[f() & 077] = x;
}

static Hint
h_load_call_index()
{
  return AHint[f() & 077];
}

static void
h_store_call_index(x)
Hint x;
{
  AHint[f() & 077] = x;
}

static Sint
s_load_call_index()
{
  return ASint[f() & 077];
}

static void
s_store_call_index(x)
Sint x;
{
  ASint[f() & 077] = x;
}

static Dint
d_load_call_index()
{
  return ADint[f() & 077];
}

static void
d_store_call_index(x)
Dint x;
{
  ADint[f() & 077] = x;
}

#ifdef ARRAY_EREF_ENABLE_FLOAT

static Sfloat
sf_load_i(i)
Sint i;
{
  return ASfloat[i & 077];
}

static void
sf_store_i(i, x)
Sint i;
Sfloat x;
{
  ASfloat[i & 077] = x;
}

static Dfloat
df_load_i(i)
Sint i;
{
  return ADfloat[i & 077];
}

static void
df_store_i(i, x)
Sint i;
Dfloat x;
{
  ADfloat[i & 077] = x;
}

static Sfloat
vsf_load_i(i)
Sint i;
{
  return VASfloat[i & 077];
}

static void
vsf_store_i(i, x)
Sint i;
Sfloat x;
{
  VASfloat[i & 077] = x;
}

static Dfloat
vdf_load_i(i)
Sint i;
{
  return VADfloat[i & 077];
}

static void
vdf_store_i(i, x)
Sint i;
Dfloat x;
{
  VADfloat[i & 077] = x;
}

#endif
