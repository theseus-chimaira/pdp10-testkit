#include "insns.h"

/*
 * LDBE coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   signed byte/subword load with extension to full Sint
 *   signed bit-field extraction
 *
 * Unsigned byte extraction belongs in LDB.c.
 * Pre-increment signed byte extraction belongs in ILDBE.c.
 */

struct ldbe_bits6 {
  signed a : 6;
  signed b : 6;
  signed c : 6;
  signed d : 6;
  signed e : 6;
  signed f : 6;
};

struct ldbe_bits7 {
  signed a : 7;
  signed b : 7;
  signed c : 7;
  signed d : 7;
};

struct ldbe_bits8 {
  unsigned filler : 8;
  signed a : 8;
  signed b : 8;
};

struct ldbe_bits9 {
  signed a : 9;
  signed b : 9;
  signed c : 9;
  signed d : 9;
};

struct ldbe_bits16 {
  signed a : 16;
  signed b : 16;
};

struct ldbe_bits18 {
  signed left : 18;
  signed right : 18;
};

struct ldbe_mixed {
  unsigned p0 : 3;
  signed q0 : 9;
  signed q1 : 9;
  signed h0 : 15;
  signed h1 : 18;
  signed q2 : 9;
};

struct ldbe_chars {
  Qint q[16];
  sQint sq[16];
  char6 c6[16];
  char7 c7[16];
  char8 c8[16];
  char9 c9[16];
  int6 i6[16];
  int7 i7[16];
  int8 i8[16];
  int9 i9[16];
  short16 h16[16];
  short18 h18[16];
};

static Qint ldbe_qbuf[16];
static sQint ldbe_sqbuf[16];
static Hint ldbe_hbuf[16];
static char6 ldbe_c6buf[16];
static char7 ldbe_c7buf[16];
static char8 ldbe_c8buf[16];
static char9 ldbe_c9buf[16];
static int6 ldbe_i6buf[16];
static int7 ldbe_i7buf[16];
static int8 ldbe_i8buf[16];
static int9 ldbe_i9buf[16];
static short16 ldbe_h16buf[16];
static short18 ldbe_h18buf[16];

static struct ldbe_bits6 ldbe_g6;
static struct ldbe_bits7 ldbe_g7;
static struct ldbe_bits8 ldbe_g8;
static struct ldbe_bits9 ldbe_g9;
static struct ldbe_bits16 ldbe_g16;
static struct ldbe_bits18 ldbe_g18;
static struct ldbe_mixed ldbe_gmixed;
static struct ldbe_chars ldbe_gchars;

static Sint
ldbe_qint(p)
Qint *p;
{
  return *p;
}

static Sint
ldbe_sqint(p)
sQint *p;
{
  return *p;
}

static Sint
ldbe_hint(p)
Hint *p;
{
  return *p;
}

static Sint
ldbe_char6(p)
char6 *p;
{
  return *p;
}

static Sint
ldbe_char7(p)
char7 *p;
{
  return *p;
}

static Sint
ldbe_char8(p)
char8 *p;
{
  return *p;
}

static Sint
ldbe_char9(p)
char9 *p;
{
  return *p;
}

static Sint
ldbe_int6(p)
int6 *p;
{
  return *p;
}

static Sint
ldbe_int7(p)
int7 *p;
{
  return *p;
}

static Sint
ldbe_int8(p)
int8 *p;
{
  return *p;
}

static Sint
ldbe_int9(p)
int9 *p;
{
  return *p;
}

static Sint
ldbe_short16(p)
short16 *p;
{
  return *p;
}

static Sint
ldbe_short18(p)
short18 *p;
{
  return *p;
}

static Sint
ldbe_qint_twice(p)
Qint *p;
{
  Sint a;
  Sint b;

  a = *p;
  b = *p;
  return a + b;
}

static Sint
ldbe_hint_twice(p)
Hint *p;
{
  Sint a;
  Sint b;

  a = *p;
  b = *p;
  return a + b;
}

static Sint
ldbe_qint_add(p, x)
Qint *p;
Sint x;
{
  return *p + x;
}

static Sint
ldbe_hint_add(p, x)
Hint *p;
Sint x;
{
  return *p + x;
}

static Sint
ldbe_qint_sub(p, x)
Qint *p;
Sint x;
{
  return *p - x;
}

static Sint
ldbe_hint_sub(p, x)
Hint *p;
Sint x;
{
  return *p - x;
}

static Sint
ldbe_qint_neg(p)
Qint *p;
{
  return -*p;
}

static Sint
ldbe_hint_neg(p)
Hint *p;
{
  return -*p;
}

static Sint
ldbe_qint_and(p)
Qint *p;
{
  return *p & 0777;
}

static Sint
ldbe_hint_and(p)
Hint *p;
{
  return *p & 0777777;
}

static Sint
ldbe_qint_shift_left(p)
Qint *p;
{
  return *p << 3;
}

static Sint
ldbe_qint_shift_right(p)
Qint *p;
{
  return *p >> 3;
}

static Sint
ldbe_hint_shift_left(p)
Hint *p;
{
  return *p << 9;
}

static Sint
ldbe_hint_shift_right(p)
Hint *p;
{
  return *p >> 9;
}

static Sint
ldbe_qint_index(v, i)
Qint *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_sqint_index(v, i)
sQint *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_hint_index(v, i)
Hint *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_char6_index(v, i)
char6 *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_char7_index(v, i)
char7 *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_char8_index(v, i)
char8 *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_char9_index(v, i)
char9 *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_short16_index(v, i)
short16 *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_short18_index(v, i)
short18 *v;
Sint i;
{
  return v[i & 017];
}

static Sint
ldbe_global_qint(i)
Sint i;
{
  return ldbe_qbuf[i & 017];
}

static Sint
ldbe_global_sqint(i)
Sint i;
{
  return ldbe_sqbuf[i & 017];
}

static Sint
ldbe_global_hint(i)
Sint i;
{
  return ldbe_hbuf[i & 017];
}

static Sint
ldbe_global_c6(i)
Sint i;
{
  return ldbe_c6buf[i & 017];
}

static Sint
ldbe_global_c7(i)
Sint i;
{
  return ldbe_c7buf[i & 017];
}

static Sint
ldbe_global_c8(i)
Sint i;
{
  return ldbe_c8buf[i & 017];
}

static Sint
ldbe_global_c9(i)
Sint i;
{
  return ldbe_c9buf[i & 017];
}

static Sint
ldbe_global_i6(i)
Sint i;
{
  return ldbe_i6buf[i & 017];
}

static Sint
ldbe_global_i7(i)
Sint i;
{
  return ldbe_i7buf[i & 017];
}

static Sint
ldbe_global_i8(i)
Sint i;
{
  return ldbe_i8buf[i & 017];
}

static Sint
ldbe_global_i9(i)
Sint i;
{
  return ldbe_i9buf[i & 017];
}

static Sint
ldbe_global_h16(i)
Sint i;
{
  return ldbe_h16buf[i & 017];
}

static Sint
ldbe_global_h18(i)
Sint i;
{
  return ldbe_h18buf[i & 017];
}

static Sint
ldbe_struct_q(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->q[i & 017];
}

static Sint
ldbe_struct_sq(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->sq[i & 017];
}

static Sint
ldbe_struct_c6(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->c6[i & 017];
}

static Sint
ldbe_struct_c7(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->c7[i & 017];
}

static Sint
ldbe_struct_c8(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->c8[i & 017];
}

static Sint
ldbe_struct_c9(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->c9[i & 017];
}

static Sint
ldbe_struct_i6(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->i6[i & 017];
}

static Sint
ldbe_struct_i7(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->i7[i & 017];
}

static Sint
ldbe_struct_i8(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->i8[i & 017];
}

static Sint
ldbe_struct_i9(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->i9[i & 017];
}

static Sint
ldbe_struct_h16(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->h16[i & 017];
}

static Sint
ldbe_struct_h18(p, i)
struct ldbe_chars *p;
Sint i;
{
  return p->h18[i & 017];
}

static Sint
ldbe_volatile_qint(p)
volatile Qint *p;
{
  return *p;
}

static Sint
ldbe_volatile_sqint(p)
volatile sQint *p;
{
  return *p;
}

static Sint
ldbe_volatile_hint(p)
volatile Hint *p;
{
  return *p;
}

static Sint
ldbe_volatile_char8(p)
volatile char8 *p;
{
  return *p;
}

static Sint
ldbe_volatile_char9(p)
volatile char9 *p;
{
  return *p;
}

static Sint
ldbe_volatile_short18(p)
volatile short18 *p;
{
  return *p;
}

static Sint
ldbe_bit6_a(s)
struct ldbe_bits6 s;
{
  return s.a;
}

static Sint
ldbe_bit6_c(s)
struct ldbe_bits6 s;
{
  return s.c;
}

static Sint
ldbe_bit6_f(s)
struct ldbe_bits6 s;
{
  return s.f;
}

static Sint
ldbe_bit7_a(s)
struct ldbe_bits7 s;
{
  return s.a;
}

static Sint
ldbe_bit7_c(s)
struct ldbe_bits7 s;
{
  return s.c;
}

static Sint
ldbe_bit8_a(s)
struct ldbe_bits8 s;
{
  return s.a;
}

static Sint
ldbe_bit8_b(s)
struct ldbe_bits8 s;
{
  return s.b;
}

static Sint
ldbe_bit9_a(s)
struct ldbe_bits9 s;
{
  return s.a;
}

static Sint
ldbe_bit9_b(s)
struct ldbe_bits9 s;
{
  return s.b;
}

static Sint
ldbe_bit9_c(s)
struct ldbe_bits9 s;
{
  return s.c;
}

static Sint
ldbe_bit9_d(s)
struct ldbe_bits9 s;
{
  return s.d;
}

static Sint
ldbe_bit16_a(s)
struct ldbe_bits16 s;
{
  return s.a;
}

static Sint
ldbe_bit16_b(s)
struct ldbe_bits16 s;
{
  return s.b;
}

static Sint
ldbe_bit18_left(s)
struct ldbe_bits18 s;
{
  return s.left;
}

static Sint
ldbe_bit18_right(s)
struct ldbe_bits18 s;
{
  return s.right;
}

static Sint
ldbe_bit6_ptr_a(p)
struct ldbe_bits6 *p;
{
  return p->a;
}

static Sint
ldbe_bit6_ptr_f(p)
struct ldbe_bits6 *p;
{
  return p->f;
}

static Sint
ldbe_bit7_ptr_b(p)
struct ldbe_bits7 *p;
{
  return p->b;
}

static Sint
ldbe_bit8_ptr_a(p)
struct ldbe_bits8 *p;
{
  return p->a;
}

static Sint
ldbe_bit8_ptr_b(p)
struct ldbe_bits8 *p;
{
  return p->b;
}

static Sint
ldbe_bit9_ptr_a(p)
struct ldbe_bits9 *p;
{
  return p->a;
}

static Sint
ldbe_bit9_ptr_b(p)
struct ldbe_bits9 *p;
{
  return p->b;
}

static Sint
ldbe_bit9_ptr_c(p)
struct ldbe_bits9 *p;
{
  return p->c;
}

static Sint
ldbe_bit9_ptr_d(p)
struct ldbe_bits9 *p;
{
  return p->d;
}

static Sint
ldbe_bit16_ptr_a(p)
struct ldbe_bits16 *p;
{
  return p->a;
}

static Sint
ldbe_bit16_ptr_b(p)
struct ldbe_bits16 *p;
{
  return p->b;
}

static Sint
ldbe_bit18_ptr_left(p)
struct ldbe_bits18 *p;
{
  return p->left;
}

static Sint
ldbe_bit18_ptr_right(p)
struct ldbe_bits18 *p;
{
  return p->right;
}

static Sint
ldbe_mixed_q0(s)
struct ldbe_mixed s;
{
  return s.q0;
}

static Sint
ldbe_mixed_q1(s)
struct ldbe_mixed s;
{
  return s.q1;
}

static Sint
ldbe_mixed_h0(s)
struct ldbe_mixed s;
{
  return s.h0;
}

static Sint
ldbe_mixed_h1(s)
struct ldbe_mixed s;
{
  return s.h1;
}

static Sint
ldbe_mixed_q2(s)
struct ldbe_mixed s;
{
  return s.q2;
}

static Sint
ldbe_mixed_ptr_q0(p)
struct ldbe_mixed *p;
{
  return p->q0;
}

static Sint
ldbe_mixed_ptr_q1(p)
struct ldbe_mixed *p;
{
  return p->q1;
}

static Sint
ldbe_mixed_ptr_h0(p)
struct ldbe_mixed *p;
{
  return p->h0;
}

static Sint
ldbe_mixed_ptr_h1(p)
struct ldbe_mixed *p;
{
  return p->h1;
}

static Sint
ldbe_mixed_ptr_q2(p)
struct ldbe_mixed *p;
{
  return p->q2;
}

static Sint
ldbe_global_bit6(void)
{
  return ldbe_g6.c;
}

static Sint
ldbe_global_bit7(void)
{
  return ldbe_g7.b;
}

static Sint
ldbe_global_bit8(void)
{
  return ldbe_g8.a;
}

static Sint
ldbe_global_bit9(void)
{
  return ldbe_g9.d;
}

static Sint
ldbe_global_bit16(void)
{
  return ldbe_g16.b;
}

static Sint
ldbe_global_bit18_left(void)
{
  return ldbe_g18.left;
}

static Sint
ldbe_global_bit18_right(void)
{
  return ldbe_g18.right;
}

static Sint
ldbe_global_mixed_q0(void)
{
  return ldbe_gmixed.q0;
}

static Sint
ldbe_global_mixed_h1(void)
{
  return ldbe_gmixed.h1;
}

static Sint
ldbe_global_mixed_q2(void)
{
  return ldbe_gmixed.q2;
}

static Sint
ldbe_bit9_add(p, x)
struct ldbe_bits9 *p;
Sint x;
{
  return p->b + x;
}

static Sint
ldbe_bit18_add(p, x)
struct ldbe_bits18 *p;
Sint x;
{
  return p->right + x;
}

static Sint
ldbe_bit9_neg(p)
struct ldbe_bits9 *p;
{
  return -p->c;
}

static Sint
ldbe_bit18_neg(p)
struct ldbe_bits18 *p;
{
  return -p->left;
}

static Sint
ldbe_bit9_shift_right(p)
struct ldbe_bits9 *p;
{
  return p->d >> 3;
}

static Sint
ldbe_bit18_shift_right(p)
struct ldbe_bits18 *p;
{
  return p->right >> 9;
}

static Sint
ldbe_bit9_compare_neg(p)
struct ldbe_bits9 *p;
{
  if (p->a < 0)
    return -1;
  return p->a;
}

static Sint
ldbe_bit18_compare_neg(p)
struct ldbe_bits18 *p;
{
  if (p->right < 0)
    return -1;
  return p->right;
}

static Sint
ldbe_qint_compare_neg(p)
Qint *p;
{
  if (*p < 0)
    return -1;
  return *p;
}

static Sint
ldbe_hint_compare_neg(p)
Hint *p;
{
  if (*p < 0)
    return -1;
  return *p;
}

static Sint
ldbe_two_qint(a, b)
Qint *a;
Qint *b;
{
  return *a + *b;
}

static Sint
ldbe_two_hint(a, b)
Hint *a;
Hint *b;
{
  return *a + *b;
}

static Sint
ldbe_qint_hint(a, b)
Qint *a;
Hint *b;
{
  return *a + *b;
}

static Sint
ldbe_two_fields(p)
struct ldbe_bits9 *p;
{
  return p->a + p->d;
}

static Sint
ldbe_mixed_fields(p)
struct ldbe_mixed *p;
{
  return p->q0 + p->q1 + p->h1 + p->q2;
}

static Sint
ldbe_call_pressure_qint(p)
Qint *p;
{
  extern void clobber(void);
  Sint r;

  r = *p;
  clobber();
  return r + *p;
}

static Sint
ldbe_call_pressure_hint(p)
Hint *p;
{
  extern void clobber(void);
  Sint r;

  r = *p;
  clobber();
  return r + *p;
}

static Sint
ldbe_call_pressure_field(p)
struct ldbe_bits9 *p;
{
  extern void clobber(void);
  Sint r;

  r = p->b;
  clobber();
  return r + p->d;
}

static Sint
ldbe_loop_qint(v, n)
Qint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017];

  return r;
}

static Sint
ldbe_loop_hint(v, n)
Hint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017];

  return r;
}

static Sint
ldbe_loop_fields(p, n)
struct ldbe_bits9 *p;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += p[i & 3].b;

  return r;
}
