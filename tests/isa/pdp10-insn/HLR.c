#include "insns.h"

/*
 * HLR instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   HLR    replace right half of AC with left half of source
 *   HLRI   immediate/source-half variant where combine can form it
 *   HLRM   store left half of AC into right half of memory
 *   HLRS   self form / memory right-half update
 *
 * Closely related generated forms:
 *   HLRZ   copy left half to right half, zero left half
 *   HLRO   copy left half to right half, fill left half with ones
 *   HLRE   copy left half to right half, sign extend
 *   HLRZM  store zero-extended result
 *   HLREM  store sign-extended result
 *   HLROM  store ones-extended result
 *
 * HLL/HRL/HRR have their own instruction-family files.
 */

static uHint A[8];
static Hint B[8];

static uH2int C;
static H2int D;

static Sint WA[8];
static Sint WB[8];

struct hlr_words {
  Sint a;
  Sint b;
  Sint c;
};

struct hlr_halves {
  uH2int u0;
  H2int s0;
  uH2int u1;
  H2int s1;
};

static struct hlr_words GW;
static struct hlr_halves GH;

static uH2int
hlr_reg_reg(ac, y)
uH2int ac;
uH2int y;
{
  ac.r = y.l;
  return ac;
}

static H2int
hlr_sreg_sreg(ac, y)
H2int ac;
H2int y;
{
  ac.r = y.l;
  return ac;
}

static uH2int
hlr_reg_mem(ac, x)
uH2int ac;
uH2int *x;
{
  ac.r = x->l;
  return ac;
}

static H2int
hlr_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  ac.r = x->l;
  return ac;
}

static uH2int
hlr_preserve_left(ac, x)
uH2int ac;
uH2int *x;
{
  uHint l;

  l = ac.l;
  ac.r = x->l;
  ac.l = l;
  return ac;
}

static uH2int
hlr_from_global_array(ac)
uH2int ac;
{
  ac.r = A[2];
  return ac;
}

static H2int
hlr_from_signed_global_array(ac)
H2int ac;
{
  ac.r = B[2];
  return ac;
}

static uH2int
hlr_from_global_struct(ac)
uH2int ac;
{
  ac.r = C.l;
  return ac;
}

static H2int
hlr_from_signed_global_struct(ac)
H2int ac;
{
  ac.r = D.l;
  return ac;
}

static uH2int
hlr_from_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  ac.r = A[i & 7];
  return ac;
}

static H2int
hlr_from_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  ac.r = B[i & 7];
  return ac;
}

static uH2int
hlr_from_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  ac.r = p[i & 7];
  return ac;
}

static H2int
hlr_from_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  ac.r = p[i & 7];
  return ac;
}

static uH2int
hlri_zero(ac)
uH2int ac;
{
  ac.r = 0;
  return ac;
}

static uH2int
hlri_one(ac)
uH2int ac;
{
  ac.r = 1;
  return ac;
}

static uH2int
hlri_small(ac)
uH2int ac;
{
  ac.r = 0123456;
  return ac;
}

static uH2int
hlri_max(ac)
uH2int ac;
{
  ac.r = 0777777;
  return ac;
}

static H2int
hlri_signed_neg_one(ac)
H2int ac;
{
  ac.r = -1;
  return ac;
}

static H2int
hlri_signed_small(ac)
H2int ac;
{
  ac.r = 0123456;
  return ac;
}

static uH2int
hlr_from_word_shift(ac, x)
uH2int ac;
uSint *x;
{
  ac.r = *x >> 18;
  return ac;
}

static H2int
hlr_from_signed_word_shift(ac, x)
H2int ac;
Sint *x;
{
  ac.r = *x >> 18;
  return ac;
}

static uH2int
hlr_from_word_index(ac, x, i)
uH2int ac;
uSint *x;
Sint i;
{
  ac.r = x[i & 7] >> 18;
  return ac;
}

static H2int
hlr_from_signed_word_index(ac, x, i)
H2int ac;
Sint *x;
Sint i;
{
  ac.r = x[i & 7] >> 18;
  return ac;
}

static uH2int
hlr_from_masked_word(ac, x)
uH2int ac;
uSint x;
{
  ac.r = (uHint)(x >> 18);
  return ac;
}

static Sint
hlrz_mem(x)
uH2int *x;
{
  return x->l;
}

static Sint
hlrz_global_array(void)
{
  return A[2];
}

static Sint
hlrz_global_struct(void)
{
  return C.l;
}

static Sint
hlrz_word_mem(x)
uSint *x;
{
  return *x >> 18;
}

static Sint
hlrz_word_reg(x)
uSint x;
{
  return x >> 18;
}

static Sint
hlrz_word_global(void)
{
  return GW.b >> 18;
}

static Sint
hlrz_word_index(v, i)
uSint *v;
Sint i;
{
  return v[i & 7] >> 18;
}

static Sint
hlrz_word_struct(p)
struct hlr_words *p;
{
  return ((uSint)p->b) >> 18;
}

static Sint
hlre_mem(x)
H2int *x;
{
  return x->l;
}

static Sint
hlre_global_array(void)
{
  return B[2];
}

static Sint
hlre_global_struct(void)
{
  return D.l;
}

static Sint
hlre_word_mem(x)
Sint *x;
{
  return *x >> 18;
}

static Sint
hlre_word_reg(x)
Sint x;
{
  return x >> 18;
}

static Sint
hlre_word_global(void)
{
  return GW.c >> 18;
}

static Sint
hlre_word_index(v, i)
Sint *v;
Sint i;
{
  return v[i & 7] >> 18;
}

static Sint
hlre_word_struct(p)
struct hlr_words *p;
{
  return p->c >> 18;
}

static Sint
hlro_mem(x)
uSint *x;
{
  return ((*x >> 18) | 0777777000000);
}

static Sint
hlro_reg(x)
uSint x;
{
  return ((x >> 18) | 0777777000000);
}

static Sint
hlro_global(void)
{
  return ((GW.a >> 18) | 0777777000000);
}

static Sint
hlro_index(v, i)
uSint *v;
Sint i;
{
  return ((v[i & 7] >> 18) | 0777777000000);
}

static void
hlrm_reg_mem(ac, x)
uH2int ac;
H2int *x;
{
  x->r = ac.l;
}

static void
hlrm_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  x->r = ac.l;
}

static void
hlrm_to_global(ac)
uH2int ac;
{
  C.r = ac.l;
}

static void
hlrm_to_signed_global(ac)
H2int ac;
{
  D.r = ac.l;
}

static void
hlrm_to_array(ac)
uH2int ac;
{
  A[3] = ac.l;
}

static void
hlrm_to_signed_array(ac)
H2int ac;
{
  B[3] = ac.l;
}

static void
hlrm_to_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  A[i & 7] = ac.l;
}

static void
hlrm_to_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  B[i & 7] = ac.l;
}

static void
hlrm_to_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  p[i & 7] = ac.l;
}

static void
hlrm_to_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  p[i & 7] = ac.l;
}

static void
hlrm_word_from_reg(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0777777000000) | ((src >> 18) & 0777777);
}

static void
hlrm_word_from_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & 0777777000000) | ((*src >> 18) & 0777777);
}

static Sint
hlrm_word_return(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0777777000000) | ((src >> 18) & 0777777);
  return *dst;
}

static void
hlrm_word_global(src)
Sint src;
{
  GW.a = (GW.a & 0777777000000) | ((src >> 18) & 0777777);
}

static void
hlrm_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  dst[i & 7] = (dst[i & 7] & 0777777000000) |
               ((src >> 18) & 0777777);
}

static void
hlrm_word_struct(p, src)
struct hlr_words *p;
Sint src;
{
  p->b = (p->b & 0777777000000) | ((src >> 18) & 0777777);
}

static void
hlrzm_word(dst, src)
Sint *dst;
uH2int src;
{
  *dst = src.r;
}

static void
hlrzm_word_from_word(dst, src)
Sint *dst;
uSint src;
{
  *dst = src >> 18;
}

static void
hlrzm_word_global(src)
uH2int src;
{
  GW.a = src.r;
}

static void
hlrzm_word_index(dst, src, i)
Sint *dst;
uH2int src;
Sint i;
{
  dst[i & 7] = src.r;
}

static void
hlrem_word(dst, src)
Sint *dst;
H2int src;
{
  *dst = src.r;
}

static void
hlrem_word_from_word(dst, src)
Sint *dst;
Sint src;
{
  *dst = src >> 18;
}

static void
hlrem_word_global(src)
H2int src;
{
  GW.b = src.r;
}

static void
hlrem_word_index(dst, src, i)
Sint *dst;
H2int src;
Sint i;
{
  dst[i & 7] = src.r;
}

static void
hlrom_word(dst, src)
Sint *dst;
uSint src;
{
  *dst = (src >> 18) | 0777777000000;
}

static void
hlrom_word_global(src)
uSint src;
{
  GW.c = (src >> 18) | 0777777000000;
}

static Sint
hlrs_word(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0777777000000) | ((src >> 18) & 0777777);
  return *dst;
}

static Sint
hlrs_word_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & 0777777000000) | ((*src >> 18) & 0777777);
  return *dst;
}

static Sint
hlrs_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  Sint *p;

  p = &dst[i & 7];
  *p = (*p & 0777777000000) | ((src >> 18) & 0777777);
  return *p;
}

static uH2int
hlr_chain(ac, x, y)
uH2int ac;
uH2int *x;
uH2int *y;
{
  ac.r = x->l;
  ac.l = y->r;
  ac.r = y->l;
  return ac;
}

static H2int
hlr_signed_chain(ac, x, y)
H2int ac;
H2int *x;
H2int *y;
{
  ac.r = x->l;
  ac.l = y->r;
  ac.r = y->l;
  return ac;
}

static Sint
hlrz_then_add(x, y)
uSint *x;
Sint y;
{
  return (*x >> 18) + y;
}

static Sint
hlre_then_add(x, y)
Sint *x;
Sint y;
{
  return (*x >> 18) + y;
}

static Sint
hlro_then_xor(x, y)
uSint *x;
Sint y;
{
  return ((*x >> 18) | 0777777000000) ^ y;
}

static void
hlr_call_pressure(ac, x)
uH2int ac;
uH2int *x;
{
  extern void clobber(void);

  x->r = ac.l;
  clobber();
  C.r = x->r;
}

static Sint
hlr_word_call_pressure(dst, src)
Sint *dst;
Sint src;
{
  extern void clobber(void);
  Sint r;

  *dst = (*dst & 0777777000000) | ((src >> 18) & 0777777);
  clobber();

  r = *dst & 0777777;
  return r;
}

static Sint
hlr_volatile_load(p)
volatile Sint *p;
{
  return *p >> 18;
}

static void
hlr_volatile_store(p, src)
volatile Sint *p;
Sint src;
{
  *p = (*p & 0777777000000) | ((src >> 18) & 0777777);
}

static uH2int
hlr_volatile_half_load(ac, p)
uH2int ac;
volatile uH2int *p;
{
  ac.r = p->l;
  return ac;
}

static void
hlr_volatile_half_store(ac, p)
uH2int ac;
volatile uH2int *p;
{
  p->r = ac.l;
}

static uH2int
hlr_nested_struct_load(ac, p)
uH2int ac;
struct hlr_halves *p;
{
  ac.r = p->u1.l;
  return ac;
}

static void
hlr_nested_struct_store(ac, p)
uH2int ac;
struct hlr_halves *p;
{
  p->u0.r = ac.l;
}

static Sint
hlr_nested_word_load(p)
struct hlr_halves *p;
{
  return p->u1.l;
}

static void
hlr_nested_word_store(p, x)
struct hlr_halves *p;
Sint x;
{
  p->s1.r = x >> 18;
}
