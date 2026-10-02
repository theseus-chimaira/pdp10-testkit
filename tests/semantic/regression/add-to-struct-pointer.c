#include "insns.h"

/*
 * Constant add-to-struct/pointer pressure.
 *
 * File:
 *   misc/add-to-struct-pointer.c
 *
 * This is a misc coverage test, not a single instruction-pattern test.
 *
 * It covers C pointer arithmetic with constant offsets over:
 *
 *   - structures made from Qint fields
 *   - structures made from Hint fields
 *   - structures containing full Sint fields
 *   - scalar Qint/uQint pointers
 *   - scalar Hint/uHint pointers
 *   - scalar Sint/uSint pointers
 *   - char pointers
 *
 * On PDP-10 this is interesting because byte-sized and halfword-sized
 * objects may require byte-pointer adjustment, while word-sized
 * objects should reduce to normal address arithmetic.  PDP-6/KA10 must
 * not require ADJBP.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

#define FULL

static struct S {
  Qint a, b, c, d, e, f, g;
#ifdef HALF
  Hint A, B, C;
#endif
#ifdef FULL
  Sint D;
#endif
} s_global;

struct q7_struct {
  Qint a, b, c, d, e, f, g;
};

struct q8_struct {
  Qint a, b, c, d, e, f, g, h;
};

struct q9_struct {
  Qint a, b, c, d, e, f, g, h, i;
};

struct q10_struct {
  Qint a, b, c, d, e, f, g, h, i, j;
};

struct h3_struct {
  Hint a, b, c;
};

struct h4_struct {
  Hint a, b, c, d;
};

struct h5_struct {
  Hint a, b, c, d, e;
};

struct word_struct {
  Sint a;
};

struct word3_struct {
  Sint a, b, c;
};

struct mixed_qw_struct {
  Qint a, b, c;
  Sint d;
};

struct mixed_hq_struct {
  Hint a;
  Qint b, c;
  Hint d;
};

struct nested_struct {
  struct q7_struct q;
  Sint w;
  Qint tail;
};

static struct q7_struct q7_buf[32];
static struct q8_struct q8_buf[32];
static struct q9_struct q9_buf[32];
static struct q10_struct q10_buf[32];
static struct h3_struct h3_buf[32];
static struct h4_struct h4_buf[32];
static struct h5_struct h5_buf[32];
static struct word_struct word_buf[32];
static struct word3_struct word3_buf[32];
static struct mixed_qw_struct mixed_qw_buf[32];
static struct mixed_hq_struct mixed_hq_buf[32];
static struct nested_struct nested_buf[32];

static Qint q_buf[256];
static uQint uq_buf[256];
static Hint h_buf[256];
static uHint uh_buf[256];
static Sint w_buf[256];
static uSint uw_buf[256];
static char c_buf[256];

static struct q7_struct *q7_gp;
static Qint *q_gp;
static Hint *h_gp;
static Sint *w_gp;
static char *c_gp;

/*
 * Original small test shape.
 */

static struct S *
scalar_memory_forms(x)
struct S *x;
{
  return x + 1;
}

static Qint *
bar(x)
Qint *x;
{
  return x + 0123;
}

#define T Qint

static T *
baz(x)
T *x;
{
  return x + 0123;
}

static T *
baz1(x)
T *x;
{
  return x + 1;
}

static T *
baz2(x)
T *x;
{
  return x + 2;
}

static T *
baz3(x)
T *x;
{
  return x + 3;
}

static T *
baz4(x)
T *x;
{
  return x + 4;
}

static T *
baz5(x)
T *x;
{
  return x + 5;
}

static T *
baz6(x)
T *x;
{
  return x + 6;
}

static T *
baz7(x)
T *x;
{
  return x + 7;
}

static T *
baz8(x)
T *x;
{
  return x + 8;
}

static T *
baz9(x)
T *x;
{
  return x + 9;
}

/*
 * Struct pointer constant offsets.
 */

static struct S *
s_add_0(p)
struct S *p;
{
  return p + 0;
}

static struct S *
s_add_1(p)
struct S *p;
{
  return p + 1;
}

static struct S *
s_add_2(p)
struct S *p;
{
  return p + 2;
}

static struct S *
s_add_3(p)
struct S *p;
{
  return p + 3;
}

static struct S *
s_add_7(p)
struct S *p;
{
  return p + 7;
}

static struct S *
s_add_0123(p)
struct S *p;
{
  return p + 0123;
}

static struct S *
s_sub_1(p)
struct S *p;
{
  return p - 1;
}

static struct S *
s_sub_2(p)
struct S *p;
{
  return p - 2;
}

static struct S *
s_sub_7(p)
struct S *p;
{
  return p - 7;
}

static struct S *
s_sub_0123(p)
struct S *p;
{
  return p - 0123;
}

static struct S *
s_global_base_add_1()
{
  return &s_global + 1;
}

static struct S *
s_global_base_add_2()
{
  return &s_global + 2;
}

/*
 * Qint-only struct sizes.  These are byte-pointer-heavy cases.
 */

static struct q7_struct *
q7_add_1(p)
struct q7_struct *p;
{
  return p + 1;
}

static struct q7_struct *
q7_add_2(p)
struct q7_struct *p;
{
  return p + 2;
}

static struct q7_struct *
q7_add_3(p)
struct q7_struct *p;
{
  return p + 3;
}

static struct q7_struct *
q7_add_4(p)
struct q7_struct *p;
{
  return p + 4;
}

static struct q7_struct *
q7_add_5(p)
struct q7_struct *p;
{
  return p + 5;
}

static struct q7_struct *
q7_add_7(p)
struct q7_struct *p;
{
  return p + 7;
}

static struct q7_struct *
q7_add_8(p)
struct q7_struct *p;
{
  return p + 8;
}

static struct q7_struct *
q7_add_9(p)
struct q7_struct *p;
{
  return p + 9;
}

static struct q7_struct *
q7_add_0123(p)
struct q7_struct *p;
{
  return p + 0123;
}

static struct q7_struct *
q7_sub_1(p)
struct q7_struct *p;
{
  return p - 1;
}

static struct q7_struct *
q7_sub_2(p)
struct q7_struct *p;
{
  return p - 2;
}

static struct q7_struct *
q7_sub_0123(p)
struct q7_struct *p;
{
  return p - 0123;
}

static struct q8_struct *
q8_add_1(p)
struct q8_struct *p;
{
  return p + 1;
}

static struct q8_struct *
q8_add_2(p)
struct q8_struct *p;
{
  return p + 2;
}

static struct q8_struct *
q8_add_0123(p)
struct q8_struct *p;
{
  return p + 0123;
}

static struct q9_struct *
q9_add_1(p)
struct q9_struct *p;
{
  return p + 1;
}

static struct q9_struct *
q9_add_2(p)
struct q9_struct *p;
{
  return p + 2;
}

static struct q9_struct *
q9_add_0123(p)
struct q9_struct *p;
{
  return p + 0123;
}

static struct q10_struct *
q10_add_1(p)
struct q10_struct *p;
{
  return p + 1;
}

static struct q10_struct *
q10_add_2(p)
struct q10_struct *p;
{
  return p + 2;
}

static struct q10_struct *
q10_add_0123(p)
struct q10_struct *p;
{
  return p + 0123;
}

/*
 * Halfword-heavy struct sizes.
 */

static struct h3_struct *
h3_add_1(p)
struct h3_struct *p;
{
  return p + 1;
}

static struct h3_struct *
h3_add_2(p)
struct h3_struct *p;
{
  return p + 2;
}

static struct h3_struct *
h3_add_3(p)
struct h3_struct *p;
{
  return p + 3;
}

static struct h3_struct *
h3_add_0123(p)
struct h3_struct *p;
{
  return p + 0123;
}

static struct h3_struct *
h3_sub_1(p)
struct h3_struct *p;
{
  return p - 1;
}

static struct h3_struct *
h3_sub_0123(p)
struct h3_struct *p;
{
  return p - 0123;
}

static struct h4_struct *
h4_add_1(p)
struct h4_struct *p;
{
  return p + 1;
}

static struct h4_struct *
h4_add_2(p)
struct h4_struct *p;
{
  return p + 2;
}

static struct h4_struct *
h4_add_0123(p)
struct h4_struct *p;
{
  return p + 0123;
}

static struct h5_struct *
h5_add_1(p)
struct h5_struct *p;
{
  return p + 1;
}

static struct h5_struct *
h5_add_2(p)
struct h5_struct *p;
{
  return p + 2;
}

static struct h5_struct *
h5_add_0123(p)
struct h5_struct *p;
{
  return p + 0123;
}

/*
 * Word-sized struct pointer offsets.  These should be the boring
 * address arithmetic cases.
 */

static struct word_struct *
word_struct_add_1(p)
struct word_struct *p;
{
  return p + 1;
}

static struct word_struct *
word_struct_add_2(p)
struct word_struct *p;
{
  return p + 2;
}

static struct word_struct *
word_struct_add_0123(p)
struct word_struct *p;
{
  return p + 0123;
}

static struct word_struct *
word_struct_sub_1(p)
struct word_struct *p;
{
  return p - 1;
}

static struct word3_struct *
word3_struct_add_1(p)
struct word3_struct *p;
{
  return p + 1;
}

static struct word3_struct *
word3_struct_add_2(p)
struct word3_struct *p;
{
  return p + 2;
}

static struct word3_struct *
word3_struct_add_0123(p)
struct word3_struct *p;
{
  return p + 0123;
}

/*
 * Mixed structs.
 */

static struct mixed_qw_struct *
mixed_qw_add_1(p)
struct mixed_qw_struct *p;
{
  return p + 1;
}

static struct mixed_qw_struct *
mixed_qw_add_2(p)
struct mixed_qw_struct *p;
{
  return p + 2;
}

static struct mixed_qw_struct *
mixed_qw_add_0123(p)
struct mixed_qw_struct *p;
{
  return p + 0123;
}

static struct mixed_qw_struct *
mixed_qw_sub_1(p)
struct mixed_qw_struct *p;
{
  return p - 1;
}

static struct mixed_hq_struct *
mixed_hq_add_1(p)
struct mixed_hq_struct *p;
{
  return p + 1;
}

static struct mixed_hq_struct *
mixed_hq_add_2(p)
struct mixed_hq_struct *p;
{
  return p + 2;
}

static struct mixed_hq_struct *
mixed_hq_add_0123(p)
struct mixed_hq_struct *p;
{
  return p + 0123;
}

static struct nested_struct *
nested_add_1(p)
struct nested_struct *p;
{
  return p + 1;
}

static struct nested_struct *
nested_add_2(p)
struct nested_struct *p;
{
  return p + 2;
}

static struct nested_struct *
nested_add_0123(p)
struct nested_struct *p;
{
  return p + 0123;
}

/*
 * Scalar byte pointer constant offsets.
 */

static Qint *
q_add_0(p)
Qint *p;
{
  return p + 0;
}

static Qint *
q_add_1(p)
Qint *p;
{
  return p + 1;
}

static Qint *
q_add_2(p)
Qint *p;
{
  return p + 2;
}

static Qint *
q_add_3(p)
Qint *p;
{
  return p + 3;
}

static Qint *
q_add_4(p)
Qint *p;
{
  return p + 4;
}

static Qint *
q_add_5(p)
Qint *p;
{
  return p + 5;
}

static Qint *
q_add_6(p)
Qint *p;
{
  return p + 6;
}

static Qint *
q_add_7(p)
Qint *p;
{
  return p + 7;
}

static Qint *
q_add_8(p)
Qint *p;
{
  return p + 8;
}

static Qint *
q_add_9(p)
Qint *p;
{
  return p + 9;
}

static Qint *
q_add_0123(p)
Qint *p;
{
  return p + 0123;
}

static Qint *
q_add_01000(p)
Qint *p;
{
  return p + 01000;
}

static Qint *
q_sub_1(p)
Qint *p;
{
  return p - 1;
}

static Qint *
q_sub_2(p)
Qint *p;
{
  return p - 2;
}

static Qint *
q_sub_3(p)
Qint *p;
{
  return p - 3;
}

static Qint *
q_sub_4(p)
Qint *p;
{
  return p - 4;
}

static Qint *
q_sub_0123(p)
Qint *p;
{
  return p - 0123;
}

static uQint *
uq_add_1(p)
uQint *p;
{
  return p + 1;
}

static uQint *
uq_add_2(p)
uQint *p;
{
  return p + 2;
}

static uQint *
uq_add_3(p)
uQint *p;
{
  return p + 3;
}

static uQint *
uq_add_4(p)
uQint *p;
{
  return p + 4;
}

static uQint *
uq_add_0123(p)
uQint *p;
{
  return p + 0123;
}

static uQint *
uq_sub_0123(p)
uQint *p;
{
  return p - 0123;
}

/*
 * Scalar halfword pointer constant offsets.
 */

static Hint *
h_add_1(p)
Hint *p;
{
  return p + 1;
}

static Hint *
h_add_2(p)
Hint *p;
{
  return p + 2;
}

static Hint *
h_add_3(p)
Hint *p;
{
  return p + 3;
}

static Hint *
h_add_4(p)
Hint *p;
{
  return p + 4;
}

static Hint *
h_add_5(p)
Hint *p;
{
  return p + 5;
}

static Hint *
h_add_0123(p)
Hint *p;
{
  return p + 0123;
}

static Hint *
h_add_01000(p)
Hint *p;
{
  return p + 01000;
}

static Hint *
h_sub_1(p)
Hint *p;
{
  return p - 1;
}

static Hint *
h_sub_2(p)
Hint *p;
{
  return p - 2;
}

static Hint *
h_sub_3(p)
Hint *p;
{
  return p - 3;
}

static Hint *
h_sub_0123(p)
Hint *p;
{
  return p - 0123;
}

static uHint *
uh_add_1(p)
uHint *p;
{
  return p + 1;
}

static uHint *
uh_add_2(p)
uHint *p;
{
  return p + 2;
}

static uHint *
uh_add_3(p)
uHint *p;
{
  return p + 3;
}

static uHint *
uh_add_0123(p)
uHint *p;
{
  return p + 0123;
}

static uHint *
uh_sub_0123(p)
uHint *p;
{
  return p - 0123;
}

/*
 * Word pointer constant offsets.
 */

static Sint *
w_add_1(p)
Sint *p;
{
  return p + 1;
}

static Sint *
w_add_2(p)
Sint *p;
{
  return p + 2;
}

static Sint *
w_add_3(p)
Sint *p;
{
  return p + 3;
}

static Sint *
w_add_0123(p)
Sint *p;
{
  return p + 0123;
}

static Sint *
w_add_01000(p)
Sint *p;
{
  return p + 01000;
}

static Sint *
w_sub_1(p)
Sint *p;
{
  return p - 1;
}

static Sint *
w_sub_0123(p)
Sint *p;
{
  return p - 0123;
}

static uSint *
uw_add_1(p)
uSint *p;
{
  return p + 1;
}

static uSint *
uw_add_2(p)
uSint *p;
{
  return p + 2;
}

static uSint *
uw_add_0123(p)
uSint *p;
{
  return p + 0123;
}

static uSint *
uw_sub_0123(p)
uSint *p;
{
  return p - 0123;
}

/*
 * char pointer offsets.  Default DAIMON/PDP-10 char is 9-bit, so these
 * should behave like Qint byte-pointer cases.
 */

static char *
c_add_1(p)
char *p;
{
  return p + 1;
}

static char *
c_add_2(p)
char *p;
{
  return p + 2;
}

static char *
c_add_3(p)
char *p;
{
  return p + 3;
}

static char *
c_add_4(p)
char *p;
{
  return p + 4;
}

static char *
c_add_5(p)
char *p;
{
  return p + 5;
}

static char *
c_add_0123(p)
char *p;
{
  return p + 0123;
}

static char *
c_sub_1(p)
char *p;
{
  return p - 1;
}

static char *
c_sub_2(p)
char *p;
{
  return p - 2;
}

static char *
c_sub_0123(p)
char *p;
{
  return p - 0123;
}

/*
 * Array-base constant offsets.
 */

static struct q7_struct *
q7_base_add_1()
{
  return q7_buf + 1;
}

static struct q7_struct *
q7_base_add_2()
{
  return q7_buf + 2;
}

static struct q7_struct *
q7_base_add_0123()
{
  return q7_buf + 0123;
}

static struct q8_struct *
q8_base_add_1()
{
  return q8_buf + 1;
}

static struct q9_struct *
q9_base_add_1()
{
  return q9_buf + 1;
}

static struct q10_struct *
q10_base_add_1()
{
  return q10_buf + 1;
}

static struct h3_struct *
h3_base_add_1()
{
  return h3_buf + 1;
}

static struct h4_struct *
h4_base_add_1()
{
  return h4_buf + 1;
}

static struct h5_struct *
h5_base_add_1()
{
  return h5_buf + 1;
}

static struct word_struct *
word_base_add_1()
{
  return word_buf + 1;
}

static struct word3_struct *
word3_base_add_1()
{
  return word3_buf + 1;
}

static struct mixed_qw_struct *
mixed_qw_base_add_1()
{
  return mixed_qw_buf + 1;
}

static struct mixed_hq_struct *
mixed_hq_base_add_1()
{
  return mixed_hq_buf + 1;
}

static struct nested_struct *
nested_base_add_1()
{
  return nested_buf + 1;
}

static Qint *
q_base_add_0123()
{
  return q_buf + 0123;
}

static Hint *
h_base_add_0123()
{
  return h_buf + 0123;
}

static Sint *
w_base_add_0123()
{
  return w_buf + 0123;
}

static char *
c_base_add_0123()
{
  return c_buf + 0123;
}

/*
 * Dereference through constant-adjusted pointers.
 */

static Qint
q_load_add_1(p)
Qint *p;
{
  return *(p + 1);
}

static Qint
q_load_add_2(p)
Qint *p;
{
  return *(p + 2);
}

static Qint
q_load_add_3(p)
Qint *p;
{
  return *(p + 3);
}

static Qint
q_load_add_4(p)
Qint *p;
{
  return *(p + 4);
}

static Qint
q_load_add_0123(p)
Qint *p;
{
  return *(p + 0123);
}

static Qint
q_load_sub_1(p)
Qint *p;
{
  return *(p - 1);
}

static Qint
q_load_sub_0123(p)
Qint *p;
{
  return *(p - 0123);
}

static void
q_store_add_1(p, v)
Qint *p;
Qint v;
{
  *(p + 1) = v;
}

static void
q_store_add_2(p, v)
Qint *p;
Qint v;
{
  *(p + 2) = v;
}

static void
q_store_add_3(p, v)
Qint *p;
Qint v;
{
  *(p + 3) = v;
}

static void
q_store_add_4(p, v)
Qint *p;
Qint v;
{
  *(p + 4) = v;
}

static void
q_store_add_0123(p, v)
Qint *p;
Qint v;
{
  *(p + 0123) = v;
}

static Hint
h_load_add_1(p)
Hint *p;
{
  return *(p + 1);
}

static Hint
h_load_add_2(p)
Hint *p;
{
  return *(p + 2);
}

static Hint
h_load_add_0123(p)
Hint *p;
{
  return *(p + 0123);
}

static void
h_store_add_1(p, v)
Hint *p;
Hint v;
{
  *(p + 1) = v;
}

static void
h_store_add_2(p, v)
Hint *p;
Hint v;
{
  *(p + 2) = v;
}

static void
h_store_add_0123(p, v)
Hint *p;
Hint v;
{
  *(p + 0123) = v;
}

static Sint
w_load_add_1(p)
Sint *p;
{
  return *(p + 1);
}

static Sint
w_load_add_0123(p)
Sint *p;
{
  return *(p + 0123);
}

static void
w_store_add_1(p, v)
Sint *p;
Sint v;
{
  *(p + 1) = v;
}

static void
w_store_add_0123(p, v)
Sint *p;
Sint v;
{
  *(p + 0123) = v;
}

static char
c_load_add_1(p)
char *p;
{
  return *(p + 1);
}

static char
c_load_add_2(p)
char *p;
{
  return *(p + 2);
}

static char
c_load_add_0123(p)
char *p;
{
  return *(p + 0123);
}

static void
c_store_add_1(p, v)
char *p;
char v;
{
  *(p + 1) = v;
}

static void
c_store_add_2(p, v)
char *p;
char v;
{
  *(p + 2) = v;
}

static void
c_store_add_0123(p, v)
char *p;
char v;
{
  *(p + 0123) = v;
}

/*
 * Struct field access after constant pointer adjustment.
 */

static Qint
q7_load_field_add_1(p)
struct q7_struct *p;
{
  return (p + 1)->a;
}

static Qint
q7_load_field_add_2(p)
struct q7_struct *p;
{
  return (p + 2)->g;
}

static Qint
q7_load_field_add_0123(p)
struct q7_struct *p;
{
  return (p + 0123)->d;
}

static void
q7_store_field_add_1(p, v)
struct q7_struct *p;
Qint v;
{
  (p + 1)->a = v;
}

static void
q7_store_field_add_2(p, v)
struct q7_struct *p;
Qint v;
{
  (p + 2)->g = v;
}

static void
q7_store_field_add_0123(p, v)
struct q7_struct *p;
Qint v;
{
  (p + 0123)->d = v;
}

static Hint
h3_load_field_add_1(p)
struct h3_struct *p;
{
  return (p + 1)->a;
}

static Hint
h3_load_field_add_2(p)
struct h3_struct *p;
{
  return (p + 2)->c;
}

static void
h3_store_field_add_1(p, v)
struct h3_struct *p;
Hint v;
{
  (p + 1)->a = v;
}

static Sint
word3_load_field_add_1(p)
struct word3_struct *p;
{
  return (p + 1)->b;
}

static void
word3_store_field_add_1(p, v)
struct word3_struct *p;
Sint v;
{
  (p + 1)->c = v;
}

static Sint
mixed_qw_load_word_add_1(p)
struct mixed_qw_struct *p;
{
  return (p + 1)->d;
}

static Qint
mixed_qw_load_byte_add_1(p)
struct mixed_qw_struct *p;
{
  return (p + 1)->b;
}

static void
mixed_qw_store_byte_add_1(p, v)
struct mixed_qw_struct *p;
Qint v;
{
  (p + 1)->c = v;
}

static Qint
nested_load_tail_add_1(p)
struct nested_struct *p;
{
  return (p + 1)->tail;
}

static Sint
nested_load_word_add_1(p)
struct nested_struct *p;
{
  return (p + 1)->w;
}

/*
 * Store returned adjusted pointers.
 */

static void
store_q7_add_1(dst, p)
struct q7_struct **dst;
struct q7_struct *p;
{
  *dst = p + 1;
}

static struct q7_struct *
store_q7_add_1_return(dst, p)
struct q7_struct **dst;
struct q7_struct *p;
{
  return *dst = p + 1;
}

static void
store_q7_add_0123(dst, p)
struct q7_struct **dst;
struct q7_struct *p;
{
  *dst = p + 0123;
}

static struct q7_struct *
store_q7_add_0123_return(dst, p)
struct q7_struct **dst;
struct q7_struct *p;
{
  return *dst = p + 0123;
}

static void
store_q_add_1(dst, p)
Qint **dst;
Qint *p;
{
  *dst = p + 1;
}

static Qint *
store_q_add_1_return(dst, p)
Qint **dst;
Qint *p;
{
  return *dst = p + 1;
}

static void
store_q_add_0123(dst, p)
Qint **dst;
Qint *p;
{
  *dst = p + 0123;
}

static Qint *
store_q_add_0123_return(dst, p)
Qint **dst;
Qint *p;
{
  return *dst = p + 0123;
}

static void
store_h_add_1(dst, p)
Hint **dst;
Hint *p;
{
  *dst = p + 1;
}

static Hint *
store_h_add_1_return(dst, p)
Hint **dst;
Hint *p;
{
  return *dst = p + 1;
}

static void
store_w_add_1(dst, p)
Sint **dst;
Sint *p;
{
  *dst = p + 1;
}

static Sint *
store_w_add_1_return(dst, p)
Sint **dst;
Sint *p;
{
  return *dst = p + 1;
}

/*
 * Globals as pointer bases.
 */

static struct q7_struct *
q7_global_ptr_add_1()
{
  return q7_gp + 1;
}

static struct q7_struct *
q7_global_ptr_add_0123()
{
  return q7_gp + 0123;
}

static Qint *
q_global_ptr_add_1()
{
  return q_gp + 1;
}

static Qint *
q_global_ptr_add_0123()
{
  return q_gp + 0123;
}

static Hint *
h_global_ptr_add_1()
{
  return h_gp + 1;
}

static Hint *
h_global_ptr_add_0123()
{
  return h_gp + 0123;
}

static Sint *
w_global_ptr_add_1()
{
  return w_gp + 1;
}

static Sint *
w_global_ptr_add_0123()
{
  return w_gp + 0123;
}

static char *
c_global_ptr_add_1()
{
  return c_gp + 1;
}

static char *
c_global_ptr_add_0123()
{
  return c_gp + 0123;
}

/*
 * Call barriers to avoid everything collapsing into constants.
 */

static Qint *
q_add_after_call(p)
Qint *p;
{
  clobber();
  return p + 0123;
}

static Hint *
h_add_after_call(p)
Hint *p;
{
  clobber();
  return p + 0123;
}

static Sint *
w_add_after_call(p)
Sint *p;
{
  clobber();
  return p + 0123;
}

static struct q7_struct *
q7_add_after_call(p)
struct q7_struct *p;
{
  clobber();
  return p + 0123;
}

static struct mixed_qw_struct *
mixed_qw_add_after_call(p)
struct mixed_qw_struct *p;
{
  clobber();
  return p + 0123;
}

static Qint
q_load_after_call(p)
Qint *p;
{
  clobber();
  return *(p + 0123);
}

static Hint
h_load_after_call(p)
Hint *p;
{
  clobber();
  return *(p + 0123);
}

static Sint
w_load_after_call(p)
Sint *p;
{
  clobber();
  return *(p + 0123);
}

static Qint
q7_field_after_call(p)
struct q7_struct *p;
{
  clobber();
  return (p + 0123)->e;
}

/*
 * Small selected pointer expressions.
 */

static struct q7_struct *
q7_select_add(p, flag)
struct q7_struct *p;
Sint flag;
{
  if (flag)
    return p + 1;
  return p + 0123;
}

static Qint *
q_select_add(p, flag)
Qint *p;
Sint flag;
{
  if (flag)
    return p + 1;
  return p + 0123;
}

static Hint *
h_select_add(p, flag)
Hint *p;
Sint flag;
{
  if (flag)
    return p + 1;
  return p + 0123;
}

static Sint *
w_select_add(p, flag)
Sint *p;
Sint flag;
{
  if (flag)
    return p + 1;
  return p + 0123;
}

static Sint
q_pointer_compare(p, q)
Qint *p;
Qint *q;
{
  return p + 0123 == q;
}

static Sint
h_pointer_compare(p, q)
Hint *p;
Hint *q;
{
  return p + 0123 == q;
}

static Sint
w_pointer_compare(p, q)
Sint *p;
Sint *q;
{
  return p + 0123 == q;
}

static Sint
q7_pointer_compare(p, q)
struct q7_struct *p;
struct q7_struct *q;
{
  return p + 0123 == q;
}
