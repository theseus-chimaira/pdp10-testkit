#include "insns.h"

/*
 * Byte pointer, halfword pointer, and bitfield pressure.
 *
 * File:
 *   misc/byte-pointers.c
 *
 * This is a misc coverage test, not a single instruction-pattern test.
 *
 * It stresses:
 *   - static byte-pointer constants for Qint/uQint objects
 *   - static halfword-pointer constants for Hint/uHint objects
 *   - loads from packed QI/HI fields
 *   - stores into packed QI/HI fields
 *   - pointer constants into arrays and structs
 *   - dynamic QI/HI pointer indexing
 *   - unsigned and signed bitfield extraction
 *   - unsigned and signed bitfield insertion
 *   - bitfields passed in structs by value
 *
 * On PDP-10 these cases should exercise LDB/DPB-like byte operations,
 * halfword move logic, and extv/extzv/insv lowering.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Qint Q;
static Qint QA[8];

static uQint UQ;
static uQint UQA[8];

static Hint H;
static Hint HA[4];

static uHint UH;
static uHint UHA[4];

static char C;
static char CA[8];

static struct S {
  int filler;
  uQint Q1;
  uQint Q2;
  uQint Q3;
  uQint Q4;
  Hint H1;
  Hint H2;
  unsigned : 8;
  unsigned a : 8;
  unsigned b : 10;
} S;

struct T {
  unsigned : 8;
  unsigned a : 8;
  unsigned b : 10;
};

struct signed_bits {
  signed int a : 8;
  signed int b : 10;
  signed int c : 18;
};

struct mixed_bytes {
  int filler;
  Qint q1;
  Qint q2;
  uQint uq1;
  uQint uq2;
  Hint h1;
  Hint h2;
  uHint uh1;
  uHint uh2;
  char c1;
  char c2;
};

static struct T TA[8];
static struct signed_bits SB;
static struct signed_bits SBA[8];
static struct mixed_bytes MB;
static struct mixed_bytes MBA[8];

static volatile Qint VQ;
static volatile Qint VQA[8];
static volatile Hint VH;
static volatile Hint VHA[4];

static Qint *Qp1 = &Q;
static Qint *Qp2 = &QA[4];
static Qint *Qp3 = &QA[5];
static Qint *Qp4 = &QA[6];
static Qint *Qp5 = &QA[7];

static uQint *UQp1 = &UQ;
static uQint *UQp2 = &UQA[4];
static uQint *UQp3 = &S.Q1;
static uQint *UQp4 = &S.Q2;
static uQint *UQp5 = &S.Q3;
static uQint *UQp6 = &S.Q4;

static Hint *Hp1 = &H;
static Hint *Hp2 = &HA[2];
static Hint *Hp3 = &HA[3];
static Hint *Hp4 = &S.H1;
static Hint *Hp5 = &S.H2;

static uHint *UHp1 = &UH;
static uHint *UHp2 = &UHA[2];

static char *Cp1 = &C;
static char *Cp2 = &CA[4];

/*
 * Original load shape.
 */

static uSint
ldb1()
{
  return S.Q1;
}

static uSint
ldb2()
{
  return S.Q2;
}

static uSint
ldb3()
{
  return S.Q3;
}

static uSint
ldb4()
{
  return S.Q4;
}

static uSint
ldb5()
{
  return S.a;
}

static uSint
ldb6()
{
  return S.b;
}

static uSint
ldb7(AC)
struct T AC;
{
  return AC.a;
}

static uSint
ldb8(AC)
struct T AC;
{
  return AC.b;
}

/*
 * Static pointer constants: Qint/uQint loads.
 */

static Qint
qptr_load_1()
{
  return *Qp1;
}

static Qint
qptr_load_2()
{
  return *Qp2;
}

static Qint
qptr_load_3()
{
  return *Qp3;
}

static Qint
qptr_load_4()
{
  return *Qp4;
}

static Qint
qptr_load_5()
{
  return *Qp5;
}

static uQint
uqptr_load_1()
{
  return *UQp1;
}

static uQint
uqptr_load_2()
{
  return *UQp2;
}

static uQint
uqptr_load_3()
{
  return *UQp3;
}

static uQint
uqptr_load_4()
{
  return *UQp4;
}

static uQint
uqptr_load_5()
{
  return *UQp5;
}

static uQint
uqptr_load_6()
{
  return *UQp6;
}

/*
 * Static pointer constants: Hint/uHint loads.
 */

static Hint
hptr_load_1()
{
  return *Hp1;
}

static Hint
hptr_load_2()
{
  return *Hp2;
}

static Hint
hptr_load_3()
{
  return *Hp3;
}

static Hint
hptr_load_4()
{
  return *Hp4;
}

static Hint
hptr_load_5()
{
  return *Hp5;
}

static uHint
uhptr_load_1()
{
  return *UHp1;
}

static uHint
uhptr_load_2()
{
  return *UHp2;
}

/*
 * Static pointer constants: char loads.
 */

static char
cptr_load_1()
{
  return *Cp1;
}

static char
cptr_load_2()
{
  return *Cp2;
}

/*
 * Static pointer constants: stores.
 */

static void
qptr_store_1(x)
Qint x;
{
  *Qp1 = x;
}

static void
qptr_store_2(x)
Qint x;
{
  *Qp2 = x;
}

static void
qptr_store_3(x)
Qint x;
{
  *Qp3 = x;
}

static void
qptr_store_4(x)
Qint x;
{
  *Qp4 = x;
}

static void
qptr_store_5(x)
Qint x;
{
  *Qp5 = x;
}

static void
uqptr_store_1(x)
uQint x;
{
  *UQp1 = x;
}

static void
uqptr_store_2(x)
uQint x;
{
  *UQp2 = x;
}

static void
uqptr_store_3(x)
uQint x;
{
  *UQp3 = x;
}

static void
uqptr_store_4(x)
uQint x;
{
  *UQp4 = x;
}

static void
uqptr_store_5(x)
uQint x;
{
  *UQp5 = x;
}

static void
uqptr_store_6(x)
uQint x;
{
  *UQp6 = x;
}

static void
hptr_store_1(x)
Hint x;
{
  *Hp1 = x;
}

static void
hptr_store_2(x)
Hint x;
{
  *Hp2 = x;
}

static void
hptr_store_3(x)
Hint x;
{
  *Hp3 = x;
}

static void
hptr_store_4(x)
Hint x;
{
  *Hp4 = x;
}

static void
hptr_store_5(x)
Hint x;
{
  *Hp5 = x;
}

static void
uhptr_store_1(x)
uHint x;
{
  *UHp1 = x;
}

static void
uhptr_store_2(x)
uHint x;
{
  *UHp2 = x;
}

static void
cptr_store_1(x)
char x;
{
  *Cp1 = x;
}

static void
cptr_store_2(x)
char x;
{
  *Cp2 = x;
}

/*
 * Direct global and array byte loads.
 */

static Sint
q_global_load()
{
  return Q;
}

static uSint
uq_global_load()
{
  return UQ;
}

static Sint
q_array_load_0()
{
  return QA[0];
}

static Sint
q_array_load_4()
{
  return QA[4];
}

static Sint
q_array_load_7()
{
  return QA[7];
}

static uSint
uq_array_load_0()
{
  return UQA[0];
}

static uSint
uq_array_load_4()
{
  return UQA[4];
}

static uSint
uq_array_load_7()
{
  return UQA[7];
}

/*
 * Direct global and array halfword loads.
 */

static Sint
h_global_load()
{
  return H;
}

static uSint
uh_global_load()
{
  return UH;
}

static Sint
h_array_load_0()
{
  return HA[0];
}

static Sint
h_array_load_2()
{
  return HA[2];
}

static Sint
h_array_load_3()
{
  return HA[3];
}

static uSint
uh_array_load_0()
{
  return UHA[0];
}

static uSint
uh_array_load_2()
{
  return UHA[2];
}

/*
 * Direct global and array stores.
 */

static void
q_global_store(x)
Qint x;
{
  Q = x;
}

static void
uq_global_store(x)
uQint x;
{
  UQ = x;
}

static void
q_array_store_0(x)
Qint x;
{
  QA[0] = x;
}

static void
q_array_store_4(x)
Qint x;
{
  QA[4] = x;
}

static void
q_array_store_7(x)
Qint x;
{
  QA[7] = x;
}

static void
uq_array_store_0(x)
uQint x;
{
  UQA[0] = x;
}

static void
uq_array_store_4(x)
uQint x;
{
  UQA[4] = x;
}

static void
uq_array_store_7(x)
uQint x;
{
  UQA[7] = x;
}

static void
h_global_store(x)
Hint x;
{
  H = x;
}

static void
uh_global_store(x)
uHint x;
{
  UH = x;
}

static void
h_array_store_0(x)
Hint x;
{
  HA[0] = x;
}

static void
h_array_store_2(x)
Hint x;
{
  HA[2] = x;
}

static void
h_array_store_3(x)
Hint x;
{
  HA[3] = x;
}

static void
uh_array_store_0(x)
uHint x;
{
  UHA[0] = x;
}

static void
uh_array_store_2(x)
uHint x;
{
  UHA[2] = x;
}

/*
 * Return-after-store forms.
 */

static Qint
q_store_return(x)
Qint x;
{
  return Q = x;
}

static uQint
uq_store_return(x)
uQint x;
{
  return UQ = x;
}

static Hint
h_store_return(x)
Hint x;
{
  return H = x;
}

static uHint
uh_store_return(x)
uHint x;
{
  return UH = x;
}

static Qint
q_array_store_return(i, x)
Sint i;
Qint x;
{
  return QA[i & 7] = x;
}

static uQint
uq_array_store_return(i, x)
Sint i;
uQint x;
{
  return UQA[i & 7] = x;
}

static Hint
h_array_store_return(i, x)
Sint i;
Hint x;
{
  return HA[i & 3] = x;
}

static uHint
uh_array_store_return(i, x)
Sint i;
uHint x;
{
  return UHA[i & 3] = x;
}

/*
 * Dynamic QI/HI pointer indexing.
 */

static Qint
q_load_index(p, i)
Qint *p;
Sint i;
{
  return p[i];
}

static uQint
uq_load_index(p, i)
uQint *p;
Sint i;
{
  return p[i];
}

static Hint
h_load_index(p, i)
Hint *p;
Sint i;
{
  return p[i];
}

static uHint
uh_load_index(p, i)
uHint *p;
Sint i;
{
  return p[i];
}

static char
c_load_index(p, i)
char *p;
Sint i;
{
  return p[i];
}

static void
q_store_index(p, i, x)
Qint *p;
Sint i;
Qint x;
{
  p[i] = x;
}

static void
uq_store_index(p, i, x)
uQint *p;
Sint i;
uQint x;
{
  p[i] = x;
}

static void
h_store_index(p, i, x)
Hint *p;
Sint i;
Hint x;
{
  p[i] = x;
}

static void
uh_store_index(p, i, x)
uHint *p;
Sint i;
uHint x;
{
  p[i] = x;
}

static void
c_store_index(p, i, x)
char *p;
Sint i;
char x;
{
  p[i] = x;
}

/*
 * Masked dynamic indexing, useful for small runtime harnesses.
 */

static Qint
q_load_masked(i)
Sint i;
{
  return QA[i & 7];
}

static uQint
uq_load_masked(i)
Sint i;
{
  return UQA[i & 7];
}

static Hint
h_load_masked(i)
Sint i;
{
  return HA[i & 3];
}

static uHint
uh_load_masked(i)
Sint i;
{
  return UHA[i & 3];
}

static void
q_store_masked(i, x)
Sint i;
Qint x;
{
  QA[i & 7] = x;
}

static void
uq_store_masked(i, x)
Sint i;
uQint x;
{
  UQA[i & 7] = x;
}

static void
h_store_masked(i, x)
Sint i;
Hint x;
{
  HA[i & 3] = x;
}

static void
uh_store_masked(i, x)
Sint i;
uHint x;
{
  UHA[i & 3] = x;
}

/*
 * Address-of QI/HI objects.
 */

static Qint *
addr_Q()
{
  return &Q;
}

static Qint *
addr_QA0()
{
  return &QA[0];
}

static Qint *
addr_QA4()
{
  return &QA[4];
}

static Qint *
addr_QA7()
{
  return &QA[7];
}

static uQint *
addr_UQ()
{
  return &UQ;
}

static uQint *
addr_UQA4()
{
  return &UQA[4];
}

static uQint *
addr_S_Q1()
{
  return &S.Q1;
}

static uQint *
addr_S_Q2()
{
  return &S.Q2;
}

static uQint *
addr_S_Q3()
{
  return &S.Q3;
}

static uQint *
addr_S_Q4()
{
  return &S.Q4;
}

static Hint *
addr_H()
{
  return &H;
}

static Hint *
addr_HA2()
{
  return &HA[2];
}

static Hint *
addr_HA3()
{
  return &HA[3];
}

static Hint *
addr_S_H1()
{
  return &S.H1;
}

static Hint *
addr_S_H2()
{
  return &S.H2;
}

/*
 * Struct QI/HI field loads.
 */

static uSint
s_q1()
{
  return S.Q1;
}

static uSint
s_q2()
{
  return S.Q2;
}

static uSint
s_q3()
{
  return S.Q3;
}

static uSint
s_q4()
{
  return S.Q4;
}

static Sint
s_h1()
{
  return S.H1;
}

static Sint
s_h2()
{
  return S.H2;
}

static uSint
mb_q1()
{
  return MB.q1;
}

static uSint
mb_q2()
{
  return MB.q2;
}

static uSint
mb_uq1()
{
  return MB.uq1;
}

static uSint
mb_uq2()
{
  return MB.uq2;
}

static Sint
mb_h1()
{
  return MB.h1;
}

static Sint
mb_h2()
{
  return MB.h2;
}

static uSint
mb_uh1()
{
  return MB.uh1;
}

static uSint
mb_uh2()
{
  return MB.uh2;
}

static Sint
mb_c1()
{
  return MB.c1;
}

static Sint
mb_c2()
{
  return MB.c2;
}

/*
 * Struct QI/HI field stores.
 */

static void
s_q1_store(x)
uQint x;
{
  S.Q1 = x;
}

static void
s_q2_store(x)
uQint x;
{
  S.Q2 = x;
}

static void
s_q3_store(x)
uQint x;
{
  S.Q3 = x;
}

static void
s_q4_store(x)
uQint x;
{
  S.Q4 = x;
}

static void
s_h1_store(x)
Hint x;
{
  S.H1 = x;
}

static void
s_h2_store(x)
Hint x;
{
  S.H2 = x;
}

static void
mb_q1_store(x)
Qint x;
{
  MB.q1 = x;
}

static void
mb_q2_store(x)
Qint x;
{
  MB.q2 = x;
}

static void
mb_uq1_store(x)
uQint x;
{
  MB.uq1 = x;
}

static void
mb_uq2_store(x)
uQint x;
{
  MB.uq2 = x;
}

static void
mb_h1_store(x)
Hint x;
{
  MB.h1 = x;
}

static void
mb_h2_store(x)
Hint x;
{
  MB.h2 = x;
}

static void
mb_uh1_store(x)
uHint x;
{
  MB.uh1 = x;
}

static void
mb_uh2_store(x)
uHint x;
{
  MB.uh2 = x;
}

static void
mb_c1_store(x)
char x;
{
  MB.c1 = x;
}

static void
mb_c2_store(x)
char x;
{
  MB.c2 = x;
}

/*
 * Struct array field references.
 */

static uSint
mba_q1(i)
Sint i;
{
  return MBA[i & 7].q1;
}

static uSint
mba_q2(i)
Sint i;
{
  return MBA[i & 7].q2;
}

static uSint
mba_uq1(i)
Sint i;
{
  return MBA[i & 7].uq1;
}

static uSint
mba_uq2(i)
Sint i;
{
  return MBA[i & 7].uq2;
}

static Sint
mba_h1(i)
Sint i;
{
  return MBA[i & 7].h1;
}

static Sint
mba_h2(i)
Sint i;
{
  return MBA[i & 7].h2;
}

static uSint
mba_uh1(i)
Sint i;
{
  return MBA[i & 7].uh1;
}

static uSint
mba_uh2(i)
Sint i;
{
  return MBA[i & 7].uh2;
}

static void
mba_q1_store(i, x)
Sint i;
Qint x;
{
  MBA[i & 7].q1 = x;
}

static void
mba_q2_store(i, x)
Sint i;
Qint x;
{
  MBA[i & 7].q2 = x;
}

static void
mba_uq1_store(i, x)
Sint i;
uQint x;
{
  MBA[i & 7].uq1 = x;
}

static void
mba_uq2_store(i, x)
Sint i;
uQint x;
{
  MBA[i & 7].uq2 = x;
}

static void
mba_h1_store(i, x)
Sint i;
Hint x;
{
  MBA[i & 7].h1 = x;
}

static void
mba_h2_store(i, x)
Sint i;
Hint x;
{
  MBA[i & 7].h2 = x;
}

static void
mba_uh1_store(i, x)
Sint i;
uHint x;
{
  MBA[i & 7].uh1 = x;
}

static void
mba_uh2_store(i, x)
Sint i;
uHint x;
{
  MBA[i & 7].uh2 = x;
}

/*
 * Volatile QI/HI loads and stores.
 */

static Sint
vq_load()
{
  return VQ;
}

static Sint
vq_array_load(i)
Sint i;
{
  return VQA[i & 7];
}

static Sint
vh_load()
{
  return VH;
}

static Sint
vh_array_load(i)
Sint i;
{
  return VHA[i & 3];
}

static void
vq_store(x)
Qint x;
{
  VQ = x;
}

static void
vq_array_store(i, x)
Sint i;
Qint x;
{
  VQA[i & 7] = x;
}

static void
vh_store(x)
Hint x;
{
  VH = x;
}

static void
vh_array_store(i, x)
Sint i;
Hint x;
{
  VHA[i & 3] = x;
}

/*
 * Bitfield extraction from global struct.
 */

static uSint
bf_s_a()
{
  return S.a;
}

static uSint
bf_s_b()
{
  return S.b;
}

static uSint
bf_s_a_plus_b()
{
  return S.a + S.b;
}

static uSint
bf_s_a_shift()
{
  return S.a << 1;
}

static uSint
bf_s_b_mask()
{
  return S.b & 0777;
}

static Sint
bf_s_a_eq_zero()
{
  return S.a == 0;
}

static Sint
bf_s_b_gt_100()
{
  return S.b > 0100;
}

/*
 * Bitfield extraction from struct by value.
 */

static uSint
bf_arg_a(x)
struct T x;
{
  return x.a;
}

static uSint
bf_arg_b(x)
struct T x;
{
  return x.b;
}

static uSint
bf_arg_sum(x)
struct T x;
{
  return x.a + x.b;
}

static Sint
bf_arg_a_eq_zero(x)
struct T x;
{
  return x.a == 0;
}

static Sint
bf_arg_b_gt_100(x)
struct T x;
{
  return x.b > 0100;
}

/*
 * Bitfield extraction from struct pointer and array.
 */

static uSint
bf_ptr_a(p)
struct T *p;
{
  return p->a;
}

static uSint
bf_ptr_b(p)
struct T *p;
{
  return p->b;
}

static uSint
bf_ptr_sum(p)
struct T *p;
{
  return p->a + p->b;
}

static uSint
bf_array_a(i)
Sint i;
{
  return TA[i & 7].a;
}

static uSint
bf_array_b(i)
Sint i;
{
  return TA[i & 7].b;
}

static uSint
bf_array_sum(i)
Sint i;
{
  return TA[i & 7].a + TA[i & 7].b;
}

/*
 * Bitfield insertion into global struct.
 */

static void
bf_s_a_store(x)
uSint x;
{
  S.a = x;
}

static void
bf_s_b_store(x)
uSint x;
{
  S.b = x;
}

static uSint
bf_s_a_store_return(x)
uSint x;
{
  return S.a = x;
}

static uSint
bf_s_b_store_return(x)
uSint x;
{
  return S.b = x;
}

static void
bf_s_a_inc()
{
  S.a = S.a + 1;
}

static void
bf_s_b_inc()
{
  S.b = S.b + 1;
}

static uSint
bf_s_a_inc_return()
{
  return S.a = S.a + 1;
}

static uSint
bf_s_b_inc_return()
{
  return S.b = S.b + 1;
}

static void
bf_s_a_or(x)
uSint x;
{
  S.a = S.a | x;
}

static void
bf_s_b_xor(x)
uSint x;
{
  S.b = S.b ^ x;
}

/*
 * Bitfield insertion through pointer and array.
 */

static void
bf_ptr_a_store(p, x)
struct T *p;
uSint x;
{
  p->a = x;
}

static void
bf_ptr_b_store(p, x)
struct T *p;
uSint x;
{
  p->b = x;
}

static uSint
bf_ptr_a_store_return(p, x)
struct T *p;
uSint x;
{
  return p->a = x;
}

static uSint
bf_ptr_b_store_return(p, x)
struct T *p;
uSint x;
{
  return p->b = x;
}

static void
bf_array_a_store(i, x)
Sint i;
uSint x;
{
  TA[i & 7].a = x;
}

static void
bf_array_b_store(i, x)
Sint i;
uSint x;
{
  TA[i & 7].b = x;
}

static uSint
bf_array_a_store_return(i, x)
Sint i;
uSint x;
{
  return TA[i & 7].a = x;
}

static uSint
bf_array_b_store_return(i, x)
Sint i;
uSint x;
{
  return TA[i & 7].b = x;
}

static void
bf_array_a_inc(i)
Sint i;
{
  TA[i & 7].a = TA[i & 7].a + 1;
}

static void
bf_array_b_inc(i)
Sint i;
{
  TA[i & 7].b = TA[i & 7].b + 1;
}

/*
 * Signed bitfield extraction.
 */

static Sint
sbf_a()
{
  return SB.a;
}

static Sint
sbf_b()
{
  return SB.b;
}

static Sint
sbf_c()
{
  return SB.c;
}

static Sint
sbf_a_plus_b()
{
  return SB.a + SB.b;
}

static Sint
sbf_a_lt_zero()
{
  return SB.a < 0;
}

static Sint
sbf_b_ge_zero()
{
  return SB.b >= 0;
}

static Sint
sbf_array_a(i)
Sint i;
{
  return SBA[i & 7].a;
}

static Sint
sbf_array_b(i)
Sint i;
{
  return SBA[i & 7].b;
}

static Sint
sbf_array_c(i)
Sint i;
{
  return SBA[i & 7].c;
}

/*
 * Signed bitfield insertion.
 */

static void
sbf_a_store(x)
Sint x;
{
  SB.a = x;
}

static void
sbf_b_store(x)
Sint x;
{
  SB.b = x;
}

static void
sbf_c_store(x)
Sint x;
{
  SB.c = x;
}

static Sint
sbf_a_store_return(x)
Sint x;
{
  return SB.a = x;
}

static Sint
sbf_b_store_return(x)
Sint x;
{
  return SB.b = x;
}

static Sint
sbf_c_store_return(x)
Sint x;
{
  return SB.c = x;
}

static void
sbf_array_a_store(i, x)
Sint i;
Sint x;
{
  SBA[i & 7].a = x;
}

static void
sbf_array_b_store(i, x)
Sint i;
Sint x;
{
  SBA[i & 7].b = x;
}

static void
sbf_array_c_store(i, x)
Sint i;
Sint x;
{
  SBA[i & 7].c = x;
}

/*
 * Subword copy forms.
 */

static void
copy_q_to_q()
{
  Q = QA[4];
}

static void
copy_uq_to_uq()
{
  UQ = UQA[4];
}

static void
copy_h_to_h()
{
  H = HA[2];
}

static void
copy_uh_to_uh()
{
  UH = UHA[2];
}

static void
copy_struct_q()
{
  S.Q1 = S.Q2;
}

static void
copy_struct_q_cross()
{
  S.Q4 = UQA[7];
}

static void
copy_struct_h()
{
  S.H1 = S.H2;
}

static void
copy_q_to_struct()
{
  S.Q3 = UQ;
}

static void
copy_h_to_struct()
{
  S.H2 = H;
}

static void
copy_mb_q()
{
  MB.q1 = MB.q2;
}

static void
copy_mb_h()
{
  MB.h1 = MB.h2;
}

static void
copy_mb_c()
{
  MB.c1 = MB.c2;
}

/*
 * Subword widening and narrowing around loads/stores.
 */

static Sint
q_load_extend(p)
Qint *p;
{
  Sint x;

  x = *p;
  return x;
}

static uSint
uq_load_extend(p)
uQint *p;
{
  uSint x;

  x = *p;
  return x;
}

static Sint
h_load_extend(p)
Hint *p;
{
  Sint x;

  x = *p;
  return x;
}

static uSint
uh_load_extend(p)
uHint *p;
{
  uSint x;

  x = *p;
  return x;
}

static void
q_store_trunc(p, x)
Qint *p;
Sint x;
{
  *p = (Qint)x;
}

static void
uq_store_trunc(p, x)
uQint *p;
uSint x;
{
  *p = (uQint)x;
}

static void
h_store_trunc(p, x)
Hint *p;
Sint x;
{
  *p = (Hint)x;
}

static void
uh_store_trunc(p, x)
uHint *p;
uSint x;
{
  *p = (uHint)x;
}

/*
 * Pointer walk forms.  These can become pre/post increment byte-pointer
 * loads/stores where the backend recognizes them.
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

static uQint
uq_postinc_load(p)
uQint *p;
{
  return *p++;
}

static void
uq_postinc_store(p, x)
uQint *p;
uQint x;
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

static char
c_postinc_load(p)
char *p;
{
  return *p++;
}

static void
c_postinc_store(p, x)
char *p;
char x;
{
  *p++ = x;
}

/*
 * Loops with byte/halfword pointer accesses.
 */

static Sint
q_sum_loop(p, n)
Qint *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];
  return s;
}

static uSint
uq_sum_loop(p, n)
uQint *p;
Sint n;
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];
  return s;
}

static Sint
h_sum_loop(p, n)
Hint *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];
  return s;
}

static uSint
uh_sum_loop(p, n)
uHint *p;
Sint n;
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];
  return s;
}

static void
q_zero_loop(p, n)
Qint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    p[i] = 0;
}

static void
uq_zero_loop(p, n)
uQint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    p[i] = 0;
}

static void
h_zero_loop(p, n)
Hint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    p[i] = 0;
}

static void
uh_zero_loop(p, n)
uHint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    p[i] = 0;
}

/*
 * Bitfield loops.
 */

static uSint
bf_sum_loop(n)
Sint n;
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += TA[i & 7].a + TA[i & 7].b;
  return s;
}

static void
bf_zero_loop(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++) {
    TA[i & 7].a = 0;
    TA[i & 7].b = 0;
  }
}

static Sint
sbf_sum_loop(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += SBA[i & 7].a + SBA[i & 7].b + SBA[i & 7].c;
  return s;
}

static void
sbf_zero_loop(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++) {
    SBA[i & 7].a = 0;
    SBA[i & 7].b = 0;
    SBA[i & 7].c = 0;
  }
}

/*
 * Calls/barriers to keep selected byte-pointer forms alive.
 */

static Qint
q_load_after_call(p)
Qint *p;
{
  Qint x;

  clobber();
  x = *p;
  return x;
}

static void
q_store_after_call(p, x)
Qint *p;
Qint x;
{
  clobber();
  *p = x;
}

static Hint
h_load_after_call(p)
Hint *p;
{
  Hint x;

  clobber();
  x = *p;
  return x;
}

static void
h_store_after_call(p, x)
Hint *p;
Hint x;
{
  clobber();
  *p = x;
}

static uSint
bf_load_after_call()
{
  clobber();
  return S.a + S.b;
}

static void
bf_store_after_call(x, y)
uSint x;
uSint y;
{
  clobber();
  S.a = x;
  S.b = y;
}

static Sint
sbf_load_after_call()
{
  clobber();
  return SB.a + SB.b + SB.c;
}

static void
sbf_store_after_call(x, y, z)
Sint x;
Sint y;
Sint z;
{
  clobber();
  SB.a = x;
  SB.b = y;
  SB.c = z;
}

/*
 * Conditional uses after extraction.
 */

static Sint
q_if_negative(p)
Qint *p;
{
  if (*p < 0)
    return -1;
  return 1;
}

static Sint
h_if_negative(p)
Hint *p;
{
  if (*p < 0)
    return -1;
  return 1;
}

static Sint
uq_if_gt_0177(p)
uQint *p;
{
  if (*p > 0177)
    return 1;
  return 0;
}

static Sint
uh_if_gt_077777(p)
uHint *p;
{
  if (*p > 077777)
    return 1;
  return 0;
}

static Sint
bf_if_a_zero()
{
  if (S.a == 0)
    return 0;
  return 1;
}

static Sint
bf_if_b_big()
{
  if (S.b > 0100)
    return 1;
  return -1;
}

static Sint
sbf_if_a_negative()
{
  if (SB.a < 0)
    return -1;
  return 1;
}

/*
 * Expression combinations around byte and bitfield results.
 */

static Sint
q_h_mix()
{
  return Q + H + S.Q1 + S.H1;
}

static uSint
uq_bf_mix()
{
  return UQ + S.Q2 + S.a + S.b;
}

static Sint
mb_mix()
{
  return MB.q1 + MB.q2 + MB.h1 + MB.h2 + MB.c1 + MB.c2;
}

static Sint
q_h_array_mix(i)
Sint i;
{
  return QA[i & 7] + HA[i & 3] + MBA[i & 7].q1 + MBA[i & 7].h1;
}

static void
q_h_array_store_mix(i, x)
Sint i;
Sint x;
{
  QA[i & 7] = (Qint)x;
  HA[i & 3] = (Hint)(x >> 1);
  MBA[i & 7].q1 = (Qint)(x + 1);
  MBA[i & 7].h1 = (Hint)(x + 2);
}
