#include "insns.h"

/*
 * DPB instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   DPB for QI/byte stores through byte pointers
 *   DPB for byte array and indexed byte stores
 *   DPB for bit-field insertion
 *   DPB/halfword deposit paths for sub-word scalar stores
 *
 * IDPB is tested separately.  This file avoids pre-increment byte
 * stores as primary coverage so it stays centered on ordinary DPB.
 */

struct dpb_bits8 {
  unsigned filler : 8;
  unsigned a : 8;
};

struct dpb_bits9 {
  unsigned a : 9;
  unsigned b : 9;
  unsigned c : 9;
  unsigned d : 9;
};

struct dpb_bits6_7_8_9 {
  unsigned a : 6;
  unsigned b : 7;
  unsigned c : 8;
  unsigned d : 9;
};

struct dpb_bits18 {
  unsigned left : 18;
  unsigned right : 18;
};

struct dpb_mixed {
  unsigned p0 : 3;
  unsigned q0 : 9;
  unsigned q1 : 9;
  unsigned h0 : 15;
  unsigned h1 : 18;
  unsigned q2 : 9;
};

struct dpb_signed_bits {
  signed a : 9;
  signed b : 18;
  unsigned c : 9;
};

struct dpb_chars {
  Qint q[16];
  uQint uq[16];
  sQint sq[16];
};

Qint dpb_qbuf[16];
uQint dpb_uqbuf[16];
sQint dpb_sqbuf[16];
Hint dpb_hbuf[16];
uHint dpb_uhbuf[16];

struct dpb_bits8 dpb_g8;
struct dpb_bits9 dpb_g9;
struct dpb_bits6_7_8_9 dpb_g6789;
struct dpb_bits18 dpb_g18;
struct dpb_mixed dpb_gmixed;
struct dpb_signed_bits dpb_gsigned;
struct dpb_chars dpb_gchars;

static void
dpb_qi_store(ac, x)
Qint ac;
Qint *x;
{
  *x = ac;
}

static Qint
dpb_qi_store_ret(ac, x)
Qint ac;
Qint *x;
{
  *x = ac;
  return *x;
}

static void
dpb_sqi_store(ac, x)
sQint ac;
sQint *x;
{
  *x = ac;
}

static sQint
dpb_sqi_store_ret(ac, x)
sQint ac;
sQint *x;
{
  *x = ac;
  return *x;
}

static void
dpb_uqi_store(ac, x)
uQint ac;
uQint *x;
{
  *x = ac;
}

static uQint
dpb_uqi_store_ret(ac, x)
uQint ac;
uQint *x;
{
  *x = ac;
  return *x;
}

static void
dpb_hi_store(ac, x)
Hint ac;
Hint *x;
{
  *x = ac;
}

static Hint
dpb_hi_store_ret(ac, x)
Hint ac;
Hint *x;
{
  *x = ac;
  return *x;
}

static void
dpb_uhi_store(ac, x)
uHint ac;
uHint *x;
{
  *x = ac;
}

static uHint
dpb_uhi_store_ret(ac, x)
uHint ac;
uHint *x;
{
  *x = ac;
  return *x;
}

static void
dpb_qi_const(x)
Qint *x;
{
  *x = 0123;
}

static void
dpb_qi_const_neg(x)
sQint *x;
{
  *x = -0123;
}

static void
dpb_uqi_const_masked(x)
uQint *x;
{
  *x = 0777;
}

static void
dpb_hi_const(x)
Hint *x;
{
  *x = 0123456;
}

static void
dpb_uhi_const_masked(x)
uHint *x;
{
  *x = 0777777;
}

static void
dpb_qi_from_sint(a, x)
Sint a;
Qint *x;
{
  *x = (Qint)a;
}

static void
dpb_sqi_from_sint(a, x)
Sint a;
sQint *x;
{
  *x = (sQint)a;
}

static void
dpb_uqi_from_sint(a, x)
Sint a;
uQint *x;
{
  *x = (uQint)a;
}

static void
dpb_hi_from_sint(a, x)
Sint a;
Hint *x;
{
  *x = (Hint)a;
}

static void
dpb_uhi_from_sint(a, x)
Sint a;
uHint *x;
{
  *x = (uHint)a;
}

static void
dpb_qi_index(ac, v, i)
Qint ac;
Qint *v;
Sint i;
{
  v[i & 017] = ac;
}

static Qint
dpb_qi_index_ret(ac, v, i)
Qint ac;
Qint *v;
Sint i;
{
  v[i & 017] = ac;
  return v[i & 017];
}

static void
dpb_sqi_index(ac, v, i)
sQint ac;
sQint *v;
Sint i;
{
  v[i & 017] = ac;
}

static void
dpb_uqi_index(ac, v, i)
uQint ac;
uQint *v;
Sint i;
{
  v[i & 017] = ac;
}

static void
dpb_hi_index(ac, v, i)
Hint ac;
Hint *v;
Sint i;
{
  v[i & 017] = ac;
}

static void
dpb_uhi_index(ac, v, i)
uHint ac;
uHint *v;
Sint i;
{
  v[i & 017] = ac;
}

static void
dpb_global_qi(ac, i)
Qint ac;
Sint i;
{
  dpb_qbuf[i & 017] = ac;
}

static void
dpb_global_sqi(ac, i)
sQint ac;
Sint i;
{
  dpb_sqbuf[i & 017] = ac;
}

static void
dpb_global_uqi(ac, i)
uQint ac;
Sint i;
{
  dpb_uqbuf[i & 017] = ac;
}

static void
dpb_global_hi(ac, i)
Hint ac;
Sint i;
{
  dpb_hbuf[i & 017] = ac;
}

static void
dpb_global_uhi(ac, i)
uHint ac;
Sint i;
{
  dpb_uhbuf[i & 017] = ac;
}

static void
dpb_struct_qi(p, ac, i)
struct dpb_chars *p;
Qint ac;
Sint i;
{
  p->q[i & 017] = ac;
}

static void
dpb_struct_uqi(p, ac, i)
struct dpb_chars *p;
uQint ac;
Sint i;
{
  p->uq[i & 017] = ac;
}

static void
dpb_struct_sqi(p, ac, i)
struct dpb_chars *p;
sQint ac;
Sint i;
{
  p->sq[i & 017] = ac;
}

static void
dpb_volatile_qi(ac, x)
Qint ac;
volatile Qint *x;
{
  *x = ac;
}

static Qint
dpb_volatile_qi_ret(ac, x)
Qint ac;
volatile Qint *x;
{
  *x = ac;
  return *x;
}

static void
dpb_volatile_hi(ac, x)
Hint ac;
volatile Hint *x;
{
  *x = ac;
}

static Hint
dpb_volatile_hi_ret(ac, x)
Hint ac;
volatile Hint *x;
{
  *x = ac;
  return *x;
}

static struct dpb_bits8
dpb_bit8_a(s, y)
struct dpb_bits8 s;
Sint y;
{
  s.a = y;
  return s;
}

static struct dpb_bits8
dpb_bit8_const(s)
struct dpb_bits8 s;
{
  s.a = 0252;
  return s;
}

static void
dpb_bit8_ptr(p, y)
struct dpb_bits8 *p;
Sint y;
{
  p->a = y;
}

static void
dpb_bit8_ptr_const(p)
struct dpb_bits8 *p;
{
  p->a = 0377;
}

static struct dpb_bits9
dpb_bit9_a(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.a = y;
  return s;
}

static struct dpb_bits9
dpb_bit9_b(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.b = y;
  return s;
}

static struct dpb_bits9
dpb_bit9_c(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.c = y;
  return s;
}

static struct dpb_bits9
dpb_bit9_d(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.d = y;
  return s;
}

static void
dpb_bit9_ptr_a(p, y)
struct dpb_bits9 *p;
Sint y;
{
  p->a = y;
}

static void
dpb_bit9_ptr_b(p, y)
struct dpb_bits9 *p;
Sint y;
{
  p->b = y;
}

static void
dpb_bit9_ptr_c(p, y)
struct dpb_bits9 *p;
Sint y;
{
  p->c = y;
}

static void
dpb_bit9_ptr_d(p, y)
struct dpb_bits9 *p;
Sint y;
{
  p->d = y;
}

static struct dpb_bits6_7_8_9
dpb_bit6(s, y)
struct dpb_bits6_7_8_9 s;
Sint y;
{
  s.a = y;
  return s;
}

static struct dpb_bits6_7_8_9
dpb_bit7(s, y)
struct dpb_bits6_7_8_9 s;
Sint y;
{
  s.b = y;
  return s;
}

static struct dpb_bits6_7_8_9
dpb_bit8(s, y)
struct dpb_bits6_7_8_9 s;
Sint y;
{
  s.c = y;
  return s;
}

static struct dpb_bits6_7_8_9
dpb_bit9(s, y)
struct dpb_bits6_7_8_9 s;
Sint y;
{
  s.d = y;
  return s;
}

static void
dpb_bit6_ptr(p, y)
struct dpb_bits6_7_8_9 *p;
Sint y;
{
  p->a = y;
}

static void
dpb_bit7_ptr(p, y)
struct dpb_bits6_7_8_9 *p;
Sint y;
{
  p->b = y;
}

static void
dpb_bit8_6789_ptr(p, y)
struct dpb_bits6_7_8_9 *p;
Sint y;
{
  p->c = y;
}

static void
dpb_bit9_ptr(p, y)
struct dpb_bits6_7_8_9 *p;
Sint y;
{
  p->d = y;
}

static struct dpb_bits18
dpb_bit18_left(s, y)
struct dpb_bits18 s;
Sint y;
{
  s.left = y;
  return s;
}

static struct dpb_bits18
dpb_bit18_right(s, y)
struct dpb_bits18 s;
Sint y;
{
  s.right = y;
  return s;
}

static void
dpb_bit18_ptr_left(p, y)
struct dpb_bits18 *p;
Sint y;
{
  p->left = y;
}

static void
dpb_bit18_ptr_right(p, y)
struct dpb_bits18 *p;
Sint y;
{
  p->right = y;
}

static struct dpb_mixed
dpb_mixed_q0(s, y)
struct dpb_mixed s;
Sint y;
{
  s.q0 = y;
  return s;
}

static struct dpb_mixed
dpb_mixed_q1(s, y)
struct dpb_mixed s;
Sint y;
{
  s.q1 = y;
  return s;
}

static struct dpb_mixed
dpb_mixed_h1(s, y)
struct dpb_mixed s;
Sint y;
{
  s.h1 = y;
  return s;
}

static struct dpb_mixed
dpb_mixed_q2(s, y)
struct dpb_mixed s;
Sint y;
{
  s.q2 = y;
  return s;
}

static void
dpb_mixed_ptr_q0(p, y)
struct dpb_mixed *p;
Sint y;
{
  p->q0 = y;
}

static void
dpb_mixed_ptr_q1(p, y)
struct dpb_mixed *p;
Sint y;
{
  p->q1 = y;
}

static void
dpb_mixed_ptr_h1(p, y)
struct dpb_mixed *p;
Sint y;
{
  p->h1 = y;
}

static void
dpb_mixed_ptr_q2(p, y)
struct dpb_mixed *p;
Sint y;
{
  p->q2 = y;
}

static struct dpb_signed_bits
dpb_signed_bit9(s, y)
struct dpb_signed_bits s;
Sint y;
{
  s.a = y;
  return s;
}

static struct dpb_signed_bits
dpb_signed_bit18(s, y)
struct dpb_signed_bits s;
Sint y;
{
  s.b = y;
  return s;
}

static struct dpb_signed_bits
dpb_unsigned_after_signed(s, y)
struct dpb_signed_bits s;
Sint y;
{
  s.c = y;
  return s;
}

static void
dpb_signed_ptr_bit9(p, y)
struct dpb_signed_bits *p;
Sint y;
{
  p->a = y;
}

static void
dpb_signed_ptr_bit18(p, y)
struct dpb_signed_bits *p;
Sint y;
{
  p->b = y;
}

static void
dpb_global_bit8(y)
Sint y;
{
  dpb_g8.a = y;
}

static void
dpb_global_bit9_b(y)
Sint y;
{
  dpb_g9.b = y;
}

static void
dpb_global_bit9_d(y)
Sint y;
{
  dpb_g9.d = y;
}

static void
dpb_global_bit18_left(y)
Sint y;
{
  dpb_g18.left = y;
}

static void
dpb_global_bit18_right(y)
Sint y;
{
  dpb_g18.right = y;
}

static void
dpb_global_mixed(y)
Sint y;
{
  dpb_gmixed.q0 = y;
  dpb_gmixed.q1 = y + 1;
  dpb_gmixed.h1 = y + 2;
  dpb_gmixed.q2 = y + 3;
}

static struct dpb_bits9
dpb_multiple_fields(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.a = y;
  s.b = y + 1;
  s.c = y + 2;
  s.d = y + 3;
  return s;
}

static void
dpb_multiple_fields_ptr(p, y)
struct dpb_bits9 *p;
Sint y;
{
  p->a = y;
  p->b = y + 1;
  p->c = y + 2;
  p->d = y + 3;
}

static struct dpb_bits9
dpb_masked_field(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.c = y & 0777;
  return s;
}

static struct dpb_bits18
dpb_masked_half(s, y)
struct dpb_bits18 s;
Sint y;
{
  s.right = y & 0777777;
  return s;
}

static struct dpb_bits9
dpb_shifted_field(s, y)
struct dpb_bits9 s;
Sint y;
{
  s.b = y >> 3;
  return s;
}

static struct dpb_bits18
dpb_shifted_half(s, y)
struct dpb_bits18 s;
Sint y;
{
  s.left = y >> 9;
  return s;
}

static Sint
dpb_store_then_sum(q, h, a, b)
Qint *q;
Hint *h;
Sint a;
Sint b;
{
  *q = (Qint)a;
  *h = (Hint)b;
  return *q + *h;
}

static Sint
dpb_field_then_sum(p, y)
struct dpb_bits9 *p;
Sint y;
{
  p->a = y;
  p->b = y + 1;
  return p->a + p->b;
}

static void
dpb_call_pressure(q, h, a, b)
Qint *q;
Hint *h;
Sint a;
Sint b;
{
  extern void clobber(void);

  *q = (Qint)a;
  clobber();
  *h = (Hint)b;
}

static void
dpb_field_call_pressure(p, y)
struct dpb_bits9 *p;
Sint y;
{
  extern void clobber(void);

  p->a = y;
  clobber();
  p->d = y + 1;
}
