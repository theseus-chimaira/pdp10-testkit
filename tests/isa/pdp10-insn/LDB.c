#include "insns.h"

/*
 * LDB instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   LDB for unsigned byte/subword loads through byte pointers
 *   LDB for unsigned bit-field extraction
 *   LDB for QI/HI-sized scalar loads and indexed loads
 *
 * Signed byte loads/sign-extension belong in LDBE.c.  Pre-increment
 * byte loads belong in ILDB.c.  Stores belong in DPB.c.
 */

struct ldb_bits6 {
  unsigned a : 6;
  unsigned b : 6;
  unsigned c : 6;
  unsigned d : 6;
  unsigned e : 6;
  unsigned f : 6;
};

struct ldb_bits7 {
  unsigned a : 7;
  unsigned b : 7;
  unsigned c : 7;
  unsigned d : 7;
};

struct ldb_bits8 {
  unsigned filler : 8;
  unsigned a : 8;
  unsigned b : 8;
};

struct ldb_bits9 {
  unsigned a : 9;
  unsigned b : 9;
  unsigned c : 9;
  unsigned d : 9;
};

struct ldb_bits18 {
  unsigned left : 18;
  unsigned right : 18;
};

struct ldb_mixed {
  unsigned p0 : 3;
  unsigned q0 : 9;
  unsigned q1 : 9;
  unsigned h0 : 15;
  unsigned h1 : 18;
  unsigned q2 : 9;
};

struct ldb_chars {
  uQint q[16];
  uHint h[16];
  uchar6 c6[16];
  uchar7 c7[16];
  uchar8 c8[16];
  uchar9 c9[16];
  ushort16 h16[16];
  ushort18 h18[16];
};

static uQint ldb_qbuf[16];
static uHint ldb_hbuf[16];
static uchar6 ldb_c6buf[16];
static uchar7 ldb_c7buf[16];
static uchar8 ldb_c8buf[16];
static uchar9 ldb_c9buf[16];
static ushort16 ldb_h16buf[16];
static ushort18 ldb_h18buf[16];

static struct ldb_bits6 ldb_g6;
static struct ldb_bits7 ldb_g7;
static struct ldb_bits8 ldb_g8;
static struct ldb_bits9 ldb_g9;
static struct ldb_bits18 ldb_g18;
static struct ldb_mixed ldb_gmixed;
static struct ldb_chars ldb_gchars;

static uSint
ldb_uqi(p)
uQint *p;
{
  return *p;
}

static uSint
ldb_uhi(p)
uHint *p;
{
  return *p;
}

static uSint
ldb_uchar6(p)
uchar6 *p;
{
  return *p;
}

static uSint
ldb_uchar7(p)
uchar7 *p;
{
  return *p;
}

static uSint
ldb_uchar8(p)
uchar8 *p;
{
  return *p;
}

static uSint
ldb_uchar9(p)
uchar9 *p;
{
  return *p;
}

static uSint
ldb_ushort16(p)
ushort16 *p;
{
  return *p;
}

static uSint
ldb_ushort18(p)
ushort18 *p;
{
  return *p;
}

static uSint
ldb_uqi_twice(p)
uQint *p;
{
  uSint a;
  uSint b;

  a = *p;
  b = *p;
  return a + b;
}

static uSint
ldb_uhi_twice(p)
uHint *p;
{
  uSint a;
  uSint b;

  a = *p;
  b = *p;
  return a + b;
}

static uSint
ldb_uqi_add(p, x)
uQint *p;
uSint x;
{
  return *p + x;
}

static uSint
ldb_uhi_add(p, x)
uHint *p;
uSint x;
{
  return *p + x;
}

static uSint
ldb_uqi_and(p)
uQint *p;
{
  return *p & 0777;
}

static uSint
ldb_uhi_and(p)
uHint *p;
{
  return *p & 0777777;
}

static uSint
ldb_uqi_or(p, x)
uQint *p;
uSint x;
{
  return *p | x;
}

static uSint
ldb_uhi_or(p, x)
uHint *p;
uSint x;
{
  return *p | x;
}

static uSint
ldb_uqi_xor(p, x)
uQint *p;
uSint x;
{
  return *p ^ x;
}

static uSint
ldb_uhi_xor(p, x)
uHint *p;
uSint x;
{
  return *p ^ x;
}

static uSint
ldb_uqi_shift_left(p)
uQint *p;
{
  return *p << 3;
}

static uSint
ldb_uqi_shift_right(p)
uQint *p;
{
  return *p >> 3;
}

static uSint
ldb_uhi_shift_left(p)
uHint *p;
{
  return *p << 9;
}

static uSint
ldb_uhi_shift_right(p)
uHint *p;
{
  return *p >> 9;
}

static uSint
ldb_uqi_index(v, i)
uQint *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_uhi_index(v, i)
uHint *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_uchar6_index(v, i)
uchar6 *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_uchar7_index(v, i)
uchar7 *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_uchar8_index(v, i)
uchar8 *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_uchar9_index(v, i)
uchar9 *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_ushort16_index(v, i)
ushort16 *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_ushort18_index(v, i)
ushort18 *v;
Sint i;
{
  return v[i & 017];
}

static uSint
ldb_global_uqi(i)
Sint i;
{
  return ldb_qbuf[i & 017];
}

static uSint
ldb_global_uhi(i)
Sint i;
{
  return ldb_hbuf[i & 017];
}

static uSint
ldb_global_c6(i)
Sint i;
{
  return ldb_c6buf[i & 017];
}

static uSint
ldb_global_c7(i)
Sint i;
{
  return ldb_c7buf[i & 017];
}

static uSint
ldb_global_c8(i)
Sint i;
{
  return ldb_c8buf[i & 017];
}

static uSint
ldb_global_c9(i)
Sint i;
{
  return ldb_c9buf[i & 017];
}

static uSint
ldb_global_h16(i)
Sint i;
{
  return ldb_h16buf[i & 017];
}

static uSint
ldb_global_h18(i)
Sint i;
{
  return ldb_h18buf[i & 017];
}

static uSint
ldb_struct_q(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->q[i & 017];
}

static uSint
ldb_struct_h(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->h[i & 017];
}

static uSint
ldb_struct_c6(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->c6[i & 017];
}

static uSint
ldb_struct_c7(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->c7[i & 017];
}

static uSint
ldb_struct_c8(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->c8[i & 017];
}

static uSint
ldb_struct_c9(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->c9[i & 017];
}

static uSint
ldb_struct_h16(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->h16[i & 017];
}

static uSint
ldb_struct_h18(p, i)
struct ldb_chars *p;
Sint i;
{
  return p->h18[i & 017];
}

static uSint
ldb_volatile_uqi(p)
volatile uQint *p;
{
  return *p;
}

static uSint
ldb_volatile_uhi(p)
volatile uHint *p;
{
  return *p;
}

static uSint
ldb_volatile_uchar8(p)
volatile uchar8 *p;
{
  return *p;
}

static uSint
ldb_volatile_uchar9(p)
volatile uchar9 *p;
{
  return *p;
}

static uSint
ldb_volatile_ushort18(p)
volatile ushort18 *p;
{
  return *p;
}

static uSint
ldb_bit6_a(s)
struct ldb_bits6 s;
{
  return s.a;
}

static uSint
ldb_bit6_c(s)
struct ldb_bits6 s;
{
  return s.c;
}

static uSint
ldb_bit6_f(s)
struct ldb_bits6 s;
{
  return s.f;
}

static uSint
ldb_bit7_a(s)
struct ldb_bits7 s;
{
  return s.a;
}

static uSint
ldb_bit7_c(s)
struct ldb_bits7 s;
{
  return s.c;
}

static uSint
ldb_bit8_a(s)
struct ldb_bits8 s;
{
  return s.a;
}

static uSint
ldb_bit8_b(s)
struct ldb_bits8 s;
{
  return s.b;
}

static uSint
ldb_bit9_a(s)
struct ldb_bits9 s;
{
  return s.a;
}

static uSint
ldb_bit9_b(s)
struct ldb_bits9 s;
{
  return s.b;
}

static uSint
ldb_bit9_c(s)
struct ldb_bits9 s;
{
  return s.c;
}

static uSint
ldb_bit9_d(s)
struct ldb_bits9 s;
{
  return s.d;
}

static uSint
ldb_bit18_left(s)
struct ldb_bits18 s;
{
  return s.left;
}

static uSint
ldb_bit18_right(s)
struct ldb_bits18 s;
{
  return s.right;
}

static uSint
ldb_bit6_ptr_a(p)
struct ldb_bits6 *p;
{
  return p->a;
}

static uSint
ldb_bit6_ptr_f(p)
struct ldb_bits6 *p;
{
  return p->f;
}

static uSint
ldb_bit7_ptr_b(p)
struct ldb_bits7 *p;
{
  return p->b;
}

static uSint
ldb_bit8_ptr_a(p)
struct ldb_bits8 *p;
{
  return p->a;
}

static uSint
ldb_bit8_ptr_b(p)
struct ldb_bits8 *p;
{
  return p->b;
}

static uSint
ldb_bit9_ptr_a(p)
struct ldb_bits9 *p;
{
  return p->a;
}

static uSint
ldb_bit9_ptr_b(p)
struct ldb_bits9 *p;
{
  return p->b;
}

static uSint
ldb_bit9_ptr_c(p)
struct ldb_bits9 *p;
{
  return p->c;
}

static uSint
ldb_bit9_ptr_d(p)
struct ldb_bits9 *p;
{
  return p->d;
}

static uSint
ldb_bit18_ptr_left(p)
struct ldb_bits18 *p;
{
  return p->left;
}

static uSint
ldb_bit18_ptr_right(p)
struct ldb_bits18 *p;
{
  return p->right;
}

static uSint
ldb_mixed_q0(s)
struct ldb_mixed s;
{
  return s.q0;
}

static uSint
ldb_mixed_q1(s)
struct ldb_mixed s;
{
  return s.q1;
}

static uSint
ldb_mixed_h0(s)
struct ldb_mixed s;
{
  return s.h0;
}

static uSint
ldb_mixed_h1(s)
struct ldb_mixed s;
{
  return s.h1;
}

static uSint
ldb_mixed_q2(s)
struct ldb_mixed s;
{
  return s.q2;
}

static uSint
ldb_mixed_ptr_q0(p)
struct ldb_mixed *p;
{
  return p->q0;
}

static uSint
ldb_mixed_ptr_q1(p)
struct ldb_mixed *p;
{
  return p->q1;
}

static uSint
ldb_mixed_ptr_h0(p)
struct ldb_mixed *p;
{
  return p->h0;
}

static uSint
ldb_mixed_ptr_h1(p)
struct ldb_mixed *p;
{
  return p->h1;
}

static uSint
ldb_mixed_ptr_q2(p)
struct ldb_mixed *p;
{
  return p->q2;
}

static uSint
ldb_global_bit6(void)
{
  return ldb_g6.c;
}

static uSint
ldb_global_bit7(void)
{
  return ldb_g7.b;
}

static uSint
ldb_global_bit8(void)
{
  return ldb_g8.a;
}

static uSint
ldb_global_bit9(void)
{
  return ldb_g9.d;
}

static uSint
ldb_global_bit18_left(void)
{
  return ldb_g18.left;
}

static uSint
ldb_global_bit18_right(void)
{
  return ldb_g18.right;
}

static uSint
ldb_global_mixed_q0(void)
{
  return ldb_gmixed.q0;
}

static uSint
ldb_global_mixed_h1(void)
{
  return ldb_gmixed.h1;
}

static uSint
ldb_global_mixed_q2(void)
{
  return ldb_gmixed.q2;
}

static uSint
ldb_bit9_add(p, x)
struct ldb_bits9 *p;
uSint x;
{
  return p->b + x;
}

static uSint
ldb_bit18_add(p, x)
struct ldb_bits18 *p;
uSint x;
{
  return p->right + x;
}

static uSint
ldb_bit9_mask(p)
struct ldb_bits9 *p;
{
  return p->c & 0777;
}

static uSint
ldb_bit18_mask(p)
struct ldb_bits18 *p;
{
  return p->left & 0777777;
}

static uSint
ldb_bit9_shift_left(p)
struct ldb_bits9 *p;
{
  return p->d << 9;
}

static uSint
ldb_bit18_shift_right(p)
struct ldb_bits18 *p;
{
  return p->right >> 9;
}

static uSint
ldb_two_qi(a, b)
uQint *a;
uQint *b;
{
  return *a + *b;
}

static uSint
ldb_two_hi(a, b)
uHint *a;
uHint *b;
{
  return *a + *b;
}

static uSint
ldb_qi_hi(a, b)
uQint *a;
uHint *b;
{
  return *a + *b;
}

static uSint
ldb_two_fields(p)
struct ldb_bits9 *p;
{
  return p->a + p->d;
}

static uSint
ldb_mixed_fields(p)
struct ldb_mixed *p;
{
  return p->q0 + p->q1 + p->h1 + p->q2;
}

static uSint
ldb_call_pressure_qi(p)
uQint *p;
{
  extern void clobber(void);
  uSint r;

  r = *p;
  clobber();
  return r + *p;
}

static uSint
ldb_call_pressure_hi(p)
uHint *p;
{
  extern void clobber(void);
  uSint r;

  r = *p;
  clobber();
  return r + *p;
}

static uSint
ldb_call_pressure_field(p)
struct ldb_bits9 *p;
{
  extern void clobber(void);
  uSint r;

  r = p->b;
  clobber();
  return r + p->d;
}

static uSint
ldb_loop_qi(v, n)
uQint *v;
Sint n;
{
  Sint i;
  uSint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017];

  return r;
}

static uSint
ldb_loop_hi(v, n)
uHint *v;
Sint n;
{
  Sint i;
  uSint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017];

  return r;
}

static uSint
ldb_loop_fields(p, n)
struct ldb_bits9 *p;
Sint n;
{
  Sint i;
  uSint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += p[i & 3].b;

  return r;
}
