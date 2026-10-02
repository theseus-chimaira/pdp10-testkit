#include "insns.h"

/*
 * HRL instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   HRL    replace left half of AC with right half of source
 *   HRLI   replace left half from immediate, preserve right half
 *   HRLM   store right half of AC into left half of memory
 *   HRLS   self form / memory left-half update
 *
 * Closely related generated forms:
 *   HRLZ   copy right half to left half, zero right half
 *   HRLO   copy right half to left half, fill right half with ones
 *   HRLE   copy right half to left half, sign extend/fill right half
 *   HRLZM  store zero-extended shifted result
 *   HRLOM  store ones-extended shifted result
 *   HRLEM  store sign-extended shifted result
 *
 * HLL/HLR/HRR have their own instruction-family files.
 */

static uHint A[8];
static Hint B[8];

static uH2int C;
static H2int D;

static Sint WA[8];
static Sint WB[8];

struct hrl_words {
  Sint a;
  Sint b;
  Sint c;
};

struct hrl_halves {
  uH2int u0;
  H2int s0;
  uH2int u1;
  H2int s1;
};

static struct hrl_words GW;
static struct hrl_halves GH;

static uH2int
hrl_reg_reg(ac, y)
uH2int ac;
uH2int y;
{
  ac.l = y.r;
  return ac;
}

static H2int
hrl_sreg_sreg(ac, y)
H2int ac;
H2int y;
{
  ac.l = y.r;
  return ac;
}

static uH2int
hrl_reg_mem(ac, x)
uH2int ac;
uH2int *x;
{
  ac.l = x->r;
  return ac;
}

static H2int
hrl_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  ac.l = x->r;
  return ac;
}

static uH2int
hrl_preserve_right(ac, x)
uH2int ac;
uH2int *x;
{
  uHint r;

  r = ac.r;
  ac.l = x->r;
  ac.r = r;
  return ac;
}

static uH2int
hrl_from_global_array(ac)
uH2int ac;
{
  ac.l = A[3];
  return ac;
}

static H2int
hrl_from_signed_global_array(ac)
H2int ac;
{
  ac.l = B[3];
  return ac;
}

static uH2int
hrl_from_global_struct(ac)
uH2int ac;
{
  ac.l = C.r;
  return ac;
}

static H2int
hrl_from_signed_global_struct(ac)
H2int ac;
{
  ac.l = D.r;
  return ac;
}

static uH2int
hrl_from_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  ac.l = A[i & 7];
  return ac;
}

static H2int
hrl_from_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  ac.l = B[i & 7];
  return ac;
}

static uH2int
hrl_from_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  ac.l = p[i & 7];
  return ac;
}

static H2int
hrl_from_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  ac.l = p[i & 7];
  return ac;
}

static uH2int
hrli_zero(ac)
uH2int ac;
{
  ac.l = 0;
  return ac;
}

static uH2int
hrli_one(ac)
uH2int ac;
{
  ac.l = 1;
  return ac;
}

static uH2int
hrli_small(ac)
uH2int ac;
{
  ac.l = 0123456;
  return ac;
}

static uH2int
hrli_max(ac)
uH2int ac;
{
  ac.l = 0777777;
  return ac;
}

static H2int
hrli_signed_neg_one(ac)
H2int ac;
{
  ac.l = -1;
  return ac;
}

static H2int
hrli_signed_small(ac)
H2int ac;
{
  ac.l = 0123456;
  return ac;
}

static Sint
hrloi_small(void)
{
  return 0123456777777;
}

static Sint
hrloi_zero(void)
{
  return 0000000777777;
}

static Sint
hrloi_max(void)
{
  return 0777777777777;
}

static uH2int
hrl_from_word_right(ac, x)
uH2int ac;
uSint *x;
{
  ac.l = *x;
  return ac;
}

static H2int
hrl_from_signed_word_right(ac, x)
H2int ac;
Sint *x;
{
  ac.l = *x;
  return ac;
}

static uH2int
hrl_from_word_index(ac, x, i)
uH2int ac;
uSint *x;
Sint i;
{
  ac.l = x[i & 7];
  return ac;
}

static H2int
hrl_from_signed_word_index(ac, x, i)
H2int ac;
Sint *x;
Sint i;
{
  ac.l = x[i & 7];
  return ac;
}

static uH2int
hrl_from_masked_word(ac, x)
uH2int ac;
uSint x;
{
  ac.l = (uHint)(x & 0777777);
  return ac;
}

static Sint
hrlz_mem(x)
Sint *x;
{
  return *x << 18;
}

static Sint
hrlz_reg(x)
Sint x;
{
  return x << 18;
}

static Sint
hrlz_masked_reg(x)
Sint x;
{
  return (x & 0777777) << 18;
}

static Sint
hrlz_global(void)
{
  return GW.b << 18;
}

static Sint
hrlz_index(v, i)
Sint *v;
Sint i;
{
  return v[i & 7] << 18;
}

static Sint
hrlz_struct(p)
struct hrl_words *p;
{
  return p->b << 18;
}

static uSint
uhrlz_mem(x)
uSint *x;
{
  return *x << 18;
}

static uSint
uhrlz_reg(x)
uSint x;
{
  return x << 18;
}

static uSint
uhrlz_masked_reg(x)
uSint x;
{
  return (x & 0777777) << 18;
}

static Sint
hrlo_mem(x)
Sint *x;
{
  return (*x << 18) | 0777777;
}

static Sint
hrlo_reg(x)
Sint x;
{
  return (x << 18) | 0777777;
}

static Sint
hrlo_masked_reg(x)
Sint x;
{
  return ((x & 0777777) << 18) | 0777777;
}

static Sint
hrlo_global(void)
{
  return (GW.c << 18) | 0777777;
}

static Sint
hrlo_index(v, i)
Sint *v;
Sint i;
{
  return (v[i & 7] << 18) | 0777777;
}

static Sint
hrlo_struct(p)
struct hrl_words *p;
{
  return (p->c << 18) | 0777777;
}

static uSint
uhrlo_mem(x)
uSint *x;
{
  return (*x << 18) | 0777777;
}

static uSint
uhrlo_reg(x)
uSint x;
{
  return (x << 18) | 0777777;
}

static Sint
hrle_mem(x)
Hint *x;
{
  return ((Sint)*x << 18) | ((*x < 0) ? 0777777 : 0);
}

static Sint
hrle_reg(x)
Hint x;
{
  return ((Sint)x << 18) | ((x < 0) ? 0777777 : 0);
}

static Sint
hrle_word_mem(x)
Sint *x;
{
  Hint h;

  h = (Hint)*x;
  return ((Sint)h << 18) | ((h < 0) ? 0777777 : 0);
}

static Sint
hrle_word_reg(x)
Sint x;
{
  Hint h;

  h = (Hint)x;
  return ((Sint)h << 18) | ((h < 0) ? 0777777 : 0);
}

static void
hrlm_reg_mem(ac, x)
uH2int ac;
H2int *x;
{
  x->l = ac.r;
}

static void
hrlm_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  x->l = ac.r;
}

static void
hrlm_to_global(ac)
uH2int ac;
{
  C.l = ac.r;
}

static void
hrlm_to_signed_global(ac)
H2int ac;
{
  D.l = ac.r;
}

static void
hrlm_to_array(ac)
uH2int ac;
{
  A[2] = ac.r;
}

static void
hrlm_to_signed_array(ac)
H2int ac;
{
  B[2] = ac.r;
}

static void
hrlm_to_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  A[i & 7] = ac.r;
}

static void
hrlm_to_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  B[i & 7] = ac.r;
}

static void
hrlm_to_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  p[i & 7] = ac.r;
}

static void
hrlm_to_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  p[i & 7] = ac.r;
}

static void
hrlm_word_from_reg(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0000000777777) | ((src & 0777777) << 18);
}

static void
hrlm_word_from_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & 0000000777777) | ((*src & 0777777) << 18);
}

static Sint
hrlm_word_return(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0000000777777) | ((src & 0777777) << 18);
  return *dst;
}

static void
hrlm_word_global(src)
Sint src;
{
  GW.a = (GW.a & 0000000777777) | ((src & 0777777) << 18);
}

static void
hrlm_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  dst[i & 7] = (dst[i & 7] & 0000000777777) |
               ((src & 0777777) << 18);
}

static void
hrlm_word_struct(p, src)
struct hrl_words *p;
Sint src;
{
  p->b = (p->b & 0000000777777) | ((src & 0777777) << 18);
}

static void
hrlzm_word(dst, src)
Sint *dst;
uH2int src;
{
  *dst = ((Sint)src.r) << 18;
}

static void
hrlzm_word_from_word(dst, src)
Sint *dst;
uSint src;
{
  *dst = (src & 0777777) << 18;
}

static void
hrlzm_word_global(src)
uH2int src;
{
  GW.a = ((Sint)src.r) << 18;
}

static void
hrlzm_word_index(dst, src, i)
Sint *dst;
uH2int src;
Sint i;
{
  dst[i & 7] = ((Sint)src.r) << 18;
}

static void
hrlom_word(dst, src)
Sint *dst;
uH2int src;
{
  *dst = (((Sint)src.r) << 18) | 0777777;
}

static void
hrlom_word_from_word(dst, src)
Sint *dst;
uSint src;
{
  *dst = ((src & 0777777) << 18) | 0777777;
}

static void
hrlom_word_global(src)
uH2int src;
{
  GW.b = (((Sint)src.r) << 18) | 0777777;
}

static void
hrlom_word_index(dst, src, i)
Sint *dst;
uH2int src;
Sint i;
{
  dst[i & 7] = (((Sint)src.r) << 18) | 0777777;
}

static void
hrlem_word(dst, src)
Sint *dst;
H2int src;
{
  *dst = (((Sint)src.r) << 18) | ((src.r < 0) ? 0777777 : 0);
}

static void
hrlem_word_from_half(dst, src)
Sint *dst;
Hint src;
{
  *dst = (((Sint)src) << 18) | ((src < 0) ? 0777777 : 0);
}

static void
hrlem_word_global(src)
H2int src;
{
  GW.c = (((Sint)src.r) << 18) | ((src.r < 0) ? 0777777 : 0);
}

static Sint
hrls_word(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & 0000000777777) | ((src & 0777777) << 18);
  return *dst;
}

static Sint
hrls_word_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & 0000000777777) | ((*src & 0777777) << 18);
  return *dst;
}

static Sint
hrls_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  Sint *p;

  p = &dst[i & 7];
  *p = (*p & 0000000777777) | ((src & 0777777) << 18);
  return *p;
}

static uH2int
hrl_chain(ac, x, y)
uH2int ac;
uH2int *x;
uH2int *y;
{
  ac.l = x->r;
  ac.r = y->l;
  ac.l = y->r;
  return ac;
}

static H2int
hrl_signed_chain(ac, x, y)
H2int ac;
H2int *x;
H2int *y;
{
  ac.l = x->r;
  ac.r = y->l;
  ac.l = y->r;
  return ac;
}

static Sint
hrlz_then_add(x, y)
Sint *x;
Sint y;
{
  return ((*x & 0777777) << 18) + y;
}

static Sint
hrlo_then_xor(x, y)
Sint *x;
Sint y;
{
  return (((*x & 0777777) << 18) | 0777777) ^ y;
}

static void
hrl_call_pressure(ac, x)
uH2int ac;
uH2int *x;
{
  extern void clobber(void);

  x->l = ac.r;
  clobber();
  C.l = x->l;
}

static Sint
hrl_word_call_pressure(dst, src)
Sint *dst;
Sint src;
{
  extern void clobber(void);
  Sint r;

  *dst = (*dst & 0000000777777) | ((src & 0777777) << 18);
  clobber();

  r = *dst & 0777777000000;
  return r;
}

static Sint
hrl_volatile_load(p)
volatile Sint *p;
{
  return (*p & 0777777) << 18;
}

static void
hrl_volatile_store(p, src)
volatile Sint *p;
Sint src;
{
  *p = (*p & 0000000777777) | ((src & 0777777) << 18);
}

static uH2int
hrl_volatile_half_load(ac, p)
uH2int ac;
volatile uH2int *p;
{
  ac.l = p->r;
  return ac;
}

static void
hrl_volatile_half_store(ac, p)
uH2int ac;
volatile uH2int *p;
{
  p->l = ac.r;
}

static uH2int
hrl_nested_struct_load(ac, p)
uH2int ac;
struct hrl_halves *p;
{
  ac.l = p->u1.r;
  return ac;
}

static void
hrl_nested_struct_store(ac, p)
uH2int ac;
struct hrl_halves *p;
{
  p->u0.l = ac.r;
}

static Sint
hrl_nested_word_load(p)
struct hrl_halves *p;
{
  return ((Sint)p->u1.r) << 18;
}

static void
hrl_nested_word_store(p, x)
struct hrl_halves *p;
Sint x;
{
  p->s1.l = x;
}
