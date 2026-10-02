#include "insns.h"

/*
 * HLL instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   HLL    replace left half of destination, preserve right half
 *   HLLI   replace left half from immediate, preserve right half
 *   HLLM   store left half into memory, preserve memory right half
 *   HLLS   self form / memory left-half update where combine allows it
 *
 * Closely related generated forms also covered here:
 *   HLLZ   copy left half, zero right half
 *   HLLO   copy left half, fill right half with ones
 *
 * HLR/HRL/HRR have their own instruction-family files.
 */

static uHint A[8];
static Hint B[8];

static uH2int C;
static H2int D;

static Sint WA[8];
static Sint WB[8];

struct hll_words {
  Sint a;
  Sint b;
  Sint c;
};

struct hll_halves {
  uH2int u0;
  H2int s0;
  uH2int u1;
  H2int s1;
};

static struct hll_words GW;
static struct hll_halves GH;

static uH2int
hll_reg_reg(ac, y)
uH2int ac;
uH2int y;
{
  ac.l = y.l;
  return ac;
}

static H2int
hll_sreg_sreg(ac, y)
H2int ac;
H2int y;
{
  ac.l = y.l;
  return ac;
}

static uH2int
hll_reg_mem(ac, x)
uH2int ac;
uH2int *x;
{
  ac.l = x->l;
  return ac;
}

static H2int
hll_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  ac.l = x->l;
  return ac;
}

static uH2int
hll_reg_mem_right_preserve(ac, x)
uH2int ac;
uH2int *x;
{
  uHint r;

  r = ac.r;
  ac.l = x->l;
  ac.r = r;
  return ac;
}

static uH2int
hll_from_global_array(ac)
uH2int ac;
{
  ac.l = A[2];
  return ac;
}

static H2int
hll_from_signed_global_array(ac)
H2int ac;
{
  ac.l = B[2];
  return ac;
}

static uH2int
hll_from_global_struct(ac)
uH2int ac;
{
  ac.l = C.l;
  return ac;
}

static H2int
hll_from_signed_global_struct(ac)
H2int ac;
{
  ac.l = D.l;
  return ac;
}

static uH2int
hll_from_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  ac.l = A[i & 7];
  return ac;
}

static H2int
hll_from_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  ac.l = B[i & 7];
  return ac;
}

static uH2int
hll_from_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  ac.l = p[i & 7];
  return ac;
}

static H2int
hll_from_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  ac.l = p[i & 7];
  return ac;
}

static uH2int
hlli_zero(ac)
uH2int ac;
{
  ac.l = 0;
  return ac;
}

static uH2int
hlli_one(ac)
uH2int ac;
{
  ac.l = 1;
  return ac;
}

static uH2int
hlli_small(ac)
uH2int ac;
{
  ac.l = 0123456;
  return ac;
}

static uH2int
hlli_max(ac)
uH2int ac;
{
  ac.l = 0777777;
  return ac;
}

static H2int
hlli_signed_neg_one(ac)
H2int ac;
{
  ac.l = -1;
  return ac;
}

static H2int
hlli_signed_small(ac)
H2int ac;
{
  ac.l = 0123456;
  return ac;
}

static H2int
hll_from_word_shift(ac, x)
H2int ac;
Sint *x;
{
  ac.l = *x >> 18;
  return ac;
}

static H2int
hll_from_word_lshr(ac, x)
H2int ac;
uSint *x;
{
  ac.l = (Hint)(*x >> 18);
  return ac;
}

static H2int
hll_from_word_index(ac, x, i)
H2int ac;
Sint *x;
Sint i;
{
  ac.l = x[i & 7] >> 18;
  return ac;
}

static uH2int
hll_from_masked_word(ac, x)
uH2int ac;
uSint x;
{
  ac.l = (uHint)(x >> 18);
  return ac;
}

static Sint
hllz_mem(x)
Sint *x;
{
  return *x & 0777777000000;
}

static Sint
hllz_reg(x)
Sint x;
{
  return x & 0777777000000;
}

static Sint
hllz_global(void)
{
  return GW.b & 0777777000000;
}

static Sint
hllz_index(v, i)
Sint *v;
Sint i;
{
  return v[i & 7] & 0777777000000;
}

static Sint
hllz_struct(p)
struct hll_words *p;
{
  return p->b & 0777777000000;
}

static uSint
uhllz_mem(x)
uSint *x;
{
  return *x & 0777777000000;
}

static uSint
uhllz_reg(x)
uSint x;
{
  return x & 0777777000000;
}

static Sint
hllo_mem(x)
Sint *x;
{
  return *x | 0000000777777;
}

static Sint
hllo_reg(x)
Sint x;
{
  return x | 0000000777777;
}

static Sint
hllo_global(void)
{
  return GW.c | 0000000777777;
}

static Sint
hllo_index(v, i)
Sint *v;
Sint i;
{
  return v[i & 7] | 0000000777777;
}

static Sint
hllo_struct(p)
struct hll_words *p;
{
  return p->c | 0000000777777;
}

static uSint
uhllo_mem(x)
uSint *x;
{
  return *x | 0000000777777;
}

static uSint
uhllo_reg(x)
uSint x;
{
  return x | 0000000777777;
}

static void
hllm_reg_mem(ac, x)
uH2int ac;
H2int *x;
{
  x->l = ac.l;
}

static void
hllm_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  x->l = ac.l;
}

static void
hllm_to_global(ac)
uH2int ac;
{
  C.l = ac.l;
}

static void
hllm_to_signed_global(ac)
H2int ac;
{
  D.l = ac.l;
}

static void
hllm_to_array(ac)
uH2int ac;
{
  A[2] = ac.l;
}

static void
hllm_to_signed_array(ac)
H2int ac;
{
  B[2] = ac.l;
}

static void
hllm_to_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  A[i & 7] = ac.l;
}

static void
hllm_to_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  B[i & 7] = ac.l;
}

static void
hllm_to_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  p[i & 7] = ac.l;
}

static void
hllm_to_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  p[i & 7] = ac.l;
}

static void
hllm_word_from_shift(x, y)
Sint *x;
Sint y;
{
  *x = (*x & 0000000777777) | (y & 0777777000000);
}

static void
hllm_word_from_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & 0000000777777) | (*src & 0777777000000);
}

static void
hllm_word_from_reg(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0000000777777) | (src & 0777777000000);
}

static Sint
hllm_word_return(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0000000777777) | (src & 0777777000000);
  return *dst;
}

static void
hllm_word_global(src)
Sint src;
{
  GW.a = (GW.a & 0000000777777) | (src & 0777777000000);
}

static void
hllm_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  dst[i & 7] = (dst[i & 7] & 0000000777777) | (src & 0777777000000);
}

static void
hllm_word_struct(p, src)
struct hll_words *p;
Sint src;
{
  p->b = (p->b & 0000000777777) | (src & 0777777000000);
}

static Sint
hlls_word(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0000000777777) | (src & 0777777000000);
  return *dst;
}

static Sint
hlls_word_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & 0000000777777) | (*src & 0777777000000);
  return *dst;
}

static Sint
hlls_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  Sint *p;

  p = &dst[i & 7];
  *p = (*p & 0000000777777) | (src & 0777777000000);
  return *p;
}

static uH2int
hll_chain(ac, x, y)
uH2int ac;
uH2int *x;
uH2int *y;
{
  ac.l = x->l;
  ac.r = y->r;
  ac.l = y->l;
  return ac;
}

static H2int
hll_signed_chain(ac, x, y)
H2int ac;
H2int *x;
H2int *y;
{
  ac.l = x->l;
  ac.r = y->r;
  ac.l = y->l;
  return ac;
}

static Sint
hllz_then_add(x, y)
Sint *x;
Sint y;
{
  return (*x & 0777777000000) + y;
}

static Sint
hllo_then_xor(x, y)
Sint *x;
Sint y;
{
  return (*x | 0000000777777) ^ y;
}

static void
hll_call_pressure(ac, x)
uH2int ac;
uH2int *x;
{
  extern void clobber(void);

  x->l = ac.l;
  clobber();
  C.l = x->l;
}

static Sint
hll_word_call_pressure(dst, src)
Sint *dst;
Sint src;
{
  extern void clobber(void);
  Sint r;

  *dst = (*dst & 0000000777777) | (src & 0777777000000);
  clobber();

  r = *dst & 0777777000000;
  return r;
}

static Sint
hll_volatile_load(p)
volatile Sint *p;
{
  return *p & 0777777000000;
}

static void
hll_volatile_store(p, src)
volatile Sint *p;
Sint src;
{
  *p = (*p & 0000000777777) | (src & 0777777000000);
}

static uH2int
hll_volatile_half_load(ac, p)
uH2int ac;
volatile uH2int *p;
{
  ac.l = p->l;
  return ac;
}

static void
hll_volatile_half_store(ac, p)
uH2int ac;
volatile uH2int *p;
{
  p->l = ac.l;
}

static uH2int
hll_nested_struct_load(ac, p)
uH2int ac;
struct hll_halves *p;
{
  ac.l = p->u1.l;
  return ac;
}

static void
hll_nested_struct_store(ac, p)
uH2int ac;
struct hll_halves *p;
{
  p->u0.l = ac.l;
}

static Sint
hll_nested_word_load(p)
struct hll_halves *p;
{
  return ((Sint)p->s0.l) << 18;
}

static void
hll_nested_word_store(p, x)
struct hll_halves *p;
Sint x;
{
  p->s1.l = x >> 18;
}
