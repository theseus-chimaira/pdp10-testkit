#include "insns.h"

/*
 * HRR instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   HRR    replace right half of destination, preserve left half
 *   HRRI   replace right half from immediate/address, preserve left half
 *   HRRM   store right half into memory, preserve memory left half
 *
 * Closely related generated forms covered here:
 *   HRRZ   copy right half, zero left half
 *   HRRO   copy right half, fill left half with ones
 *   HRRE   copy right half, sign-extend source bit 18 through left half
 *   HRRZM  store zero-extended right half
 *   HRROM  store ones-extended right half
 *   HRREM  store sign-extended right half
 *
 * Self forms HRRS/HRRZS/HRROS/HRRES have separate files.
 * HLL/HLR/HRL have their own instruction-family files.
 */

#define HRR_LEFT   0777777000000
#define HRR_RIGHT  0000000777777
#define HRR_RSIGN  0000000400000
#define HRR_LOW(x) (((uSint)(x)) & HRR_RIGHT)
#define HRR_EXT(x) ((((uSint)(x)) & HRR_RSIGN) ? HRR_LEFT : 0)
#define HRR_RO(x)  (HRR_LEFT | HRR_LOW(x))
#define HRR_RE(x)  (HRR_EXT(x) | HRR_LOW(x))

static uHint A[8];
static Hint B[8];

static uH2int C;
static H2int D;

static Sint WA[8];
static uSint UWA[8];
static volatile Sint VWA[8];

struct hrr_words {
  Sint a;
  Sint b;
  Sint c;
};

struct hrr_halves {
  uH2int u0;
  H2int s0;
  uH2int u1;
  H2int s1;
};

static struct hrr_words GW;
static struct hrr_halves GH;

/*
 * Basic HRR: destination right half comes from source right half,
 * destination left half survives.
 */

static uH2int
hrr_reg_reg(ac, y)
uH2int ac;
uH2int y;
{
  ac.r = y.r;
  return ac;
}

static H2int
hrr_sreg_sreg(ac, y)
H2int ac;
H2int y;
{
  ac.r = y.r;
  return ac;
}

static uH2int
hrr_reg_mem(ac, x)
uH2int ac;
uH2int *x;
{
  ac.r = x->r;
  return ac;
}

static H2int
hrr_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  ac.r = x->r;
  return ac;
}

static uH2int
hrr_preserve_left(ac, x)
uH2int ac;
uH2int *x;
{
  uHint l;

  l = ac.l;
  ac.r = x->r;
  ac.l = l;
  return ac;
}

static uH2int
hrr_from_global_array(ac)
uH2int ac;
{
  ac.r = A[3];
  return ac;
}

static H2int
hrr_from_signed_global_array(ac)
H2int ac;
{
  ac.r = B[3];
  return ac;
}

static uH2int
hrr_from_global_struct(ac)
uH2int ac;
{
  ac.r = C.r;
  return ac;
}

static H2int
hrr_from_signed_global_struct(ac)
H2int ac;
{
  ac.r = D.r;
  return ac;
}

static uH2int
hrr_from_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  ac.r = A[i & 7];
  return ac;
}

static H2int
hrr_from_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  ac.r = B[i & 7];
  return ac;
}

static uH2int
hrr_from_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  ac.r = p[i & 7];
  return ac;
}

static H2int
hrr_from_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  ac.r = p[i & 7];
  return ac;
}

static uH2int
hrr_nested_struct_load(ac, p)
uH2int ac;
struct hrr_halves *p;
{
  ac.r = p->u1.r;
  return ac;
}

static H2int
hrr_nested_signed_struct_load(ac, p)
H2int ac;
struct hrr_halves *p;
{
  ac.r = p->s1.r;
  return ac;
}

/*
 * HRRI pressure: set only the right half of an accumulator from
 * small constants or address-like values, leaving the left half live.
 */

static uH2int
hrri_zero(ac)
uH2int ac;
{
  ac.r = 0;
  return ac;
}

static uH2int
hrri_one(ac)
uH2int ac;
{
  ac.r = 1;
  return ac;
}

static uH2int
hrri_small(ac)
uH2int ac;
{
  ac.r = 0123456;
  return ac;
}

static uH2int
hrri_max(ac)
uH2int ac;
{
  ac.r = 0777777;
  return ac;
}

static H2int
hrri_signed_neg_one(ac)
H2int ac;
{
  ac.r = -1;
  return ac;
}

static H2int
hrri_signed_small(ac)
H2int ac;
{
  ac.r = 0123456;
  return ac;
}

static uH2int
hrri_from_global_address(ac)
uH2int ac;
{
  ac.r = (uHint)(uSint)A;
  return ac;
}

static uH2int
hrri_from_struct_address(ac)
uH2int ac;
{
  ac.r = (uHint)(uSint)&GW.b;
  return ac;
}

/*
 * HRRZ: right half only, left half cleared.
 */

static Sint
hrrz_mem(x)
uH2int *x;
{
  return x->r;
}

static Sint
hrrz_global_array(void)
{
  return A[3];
}

static Sint
hrrz_global_struct(void)
{
  return C.r;
}

static Sint
hrrz_word_mem(x)
uSint *x;
{
  return *x & HRR_RIGHT;
}

static Sint
hrrz_word_reg(x)
uSint x;
{
  return x & HRR_RIGHT;
}

static Sint
hrrz_word_global(void)
{
  return GW.b & HRR_RIGHT;
}

static Sint
hrrz_word_index(v, i)
uSint *v;
Sint i;
{
  return v[i & 7] & HRR_RIGHT;
}

static Sint
hrrz_word_struct(p)
struct hrr_words *p;
{
  return ((uSint)p->b) & HRR_RIGHT;
}

static Sint
hrrz_add(x, y)
uSint *x;
Sint y;
{
  return (*x & HRR_RIGHT) + y;
}

static Sint
hrrz_xor(x, y)
uSint *x;
Sint y;
{
  return (*x & HRR_RIGHT) ^ y;
}

/*
 * HRRE: right half, sign-extended from bit 18.
 */

static Sint
hrre_mem(x)
H2int *x;
{
  return x->r;
}

static Sint
hrre_global_array(void)
{
  return B[3];
}

static Sint
hrre_global_struct(void)
{
  return D.r;
}

static Sint
hrre_word_mem(x)
Sint *x;
{
  return (Sint)HRR_RE(*x);
}

static Sint
hrre_word_reg(x)
Sint x;
{
  return (Sint)HRR_RE(x);
}

static Sint
hrre_word_global(void)
{
  return (Sint)HRR_RE(GW.c);
}

static Sint
hrre_word_index(v, i)
Sint *v;
Sint i;
{
  return (Sint)HRR_RE(v[i & 7]);
}

static Sint
hrre_word_struct(p)
struct hrr_words *p;
{
  return (Sint)HRR_RE(p->c);
}

static Sint
hrre_add(x, y)
Sint *x;
Sint y;
{
  return (Sint)HRR_RE(*x) + y;
}

/*
 * HRRO/HRROI: right half, left half filled with ones.
 */

static Sint
hrro_mem(x)
uSint *x;
{
  return (Sint)HRR_RO(*x);
}

static Sint
hrro_reg(x)
uSint x;
{
  return (Sint)HRR_RO(x);
}

static Sint
hrro_global(void)
{
  return (Sint)HRR_RO(GW.a);
}

static Sint
hrro_index(v, i)
uSint *v;
Sint i;
{
  return (Sint)HRR_RO(v[i & 7]);
}

static Sint
hrroi_zero(void)
{
  return HRR_LEFT;
}

static Sint
hrroi_one(void)
{
  return HRR_LEFT | 1;
}

static Sint
hrroi_small(void)
{
  return HRR_LEFT | 0123456;
}

static Sint
hrroi_max(void)
{
  return HRR_LEFT | HRR_RIGHT;
}

/*
 * HRRM: store source right half into destination right half,
 * preserving destination left half.  These cover direct, global,
 * indexed, pointer, struct, and volatile memory operands.
 */

static void
hrrm_reg_mem(ac, x)
uH2int ac;
uH2int *x;
{
  x->r = ac.r;
}

static void
hrrm_sreg_mem(ac, x)
H2int ac;
H2int *x;
{
  x->r = ac.r;
}

static void
hrrm_to_global(ac)
uH2int ac;
{
  C.r = ac.r;
}

static void
hrrm_to_signed_global(ac)
H2int ac;
{
  D.r = ac.r;
}

static void
hrrm_to_array(ac)
uH2int ac;
{
  A[3] = ac.r;
}

static void
hrrm_to_signed_array(ac)
H2int ac;
{
  B[3] = ac.r;
}

static void
hrrm_to_indexed_array(ac, i)
uH2int ac;
Sint i;
{
  A[i & 7] = ac.r;
}

static void
hrrm_to_signed_indexed_array(ac, i)
H2int ac;
Sint i;
{
  B[i & 7] = ac.r;
}

static void
hrrm_to_pointer_index(ac, p, i)
uH2int ac;
uHint *p;
Sint i;
{
  p[i & 7] = ac.r;
}

static void
hrrm_to_signed_pointer_index(ac, p, i)
H2int ac;
Hint *p;
Sint i;
{
  p[i & 7] = ac.r;
}

static void
hrrm_word_from_reg(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & HRR_LEFT) | (src & HRR_RIGHT);
}

static void
hrrm_word_from_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = (*dst & HRR_LEFT) | (*src & HRR_RIGHT);
}

static Sint
hrrm_word_return(dst, src)
Sint *dst;
Sint src;
{
  *dst = (*dst & HRR_LEFT) | (src & HRR_RIGHT);
  return *dst;
}

static void
hrrm_word_global(src)
Sint src;
{
  GW.a = (GW.a & HRR_LEFT) | (src & HRR_RIGHT);
}

static void
hrrm_word_global_mem(src)
Sint *src;
{
  GW.b = (GW.b & HRR_LEFT) | (*src & HRR_RIGHT);
}

static void
hrrm_word_index(dst, src, i)
Sint *dst;
Sint src;
Sint i;
{
  dst[i & 7] = (dst[i & 7] & HRR_LEFT) | (src & HRR_RIGHT);
}

static void
hrrm_word_struct(p, src)
struct hrr_words *p;
Sint src;
{
  p->b = (p->b & HRR_LEFT) | (src & HRR_RIGHT);
}

static void
hrrm_nested_struct_store(ac, p)
uH2int ac;
struct hrr_halves *p;
{
  p->u0.r = ac.r;
}

static void
hrrm_nested_signed_struct_store(ac, p)
H2int ac;
struct hrr_halves *p;
{
  p->s0.r = ac.r;
}

/*
 * Store variants of HRRZ/HRRO/HRRE.  The self/update forms remain in
 * the dedicated HRR*S files; these are plain memory destinations.
 */

static void
hrrzm_word(dst, src)
Sint *dst;
uH2int src;
{
  *dst = src.r;
}

static void
hrrzm_word_from_word(dst, src)
Sint *dst;
uSint src;
{
  *dst = src & HRR_RIGHT;
}

static void
hrrzm_word_global(src)
uH2int src;
{
  GW.a = src.r;
}

static void
hrrzm_word_index(dst, src, i)
Sint *dst;
uH2int src;
Sint i;
{
  dst[i & 7] = src.r;
}

static void
hrrem_word(dst, src)
Sint *dst;
H2int src;
{
  *dst = src.r;
}

static void
hrrem_word_from_word(dst, src)
Sint *dst;
Sint src;
{
  *dst = (Sint)HRR_RE(src);
}

static void
hrrem_word_global(src)
H2int src;
{
  GW.b = src.r;
}

static void
hrrem_word_index(dst, src, i)
Sint *dst;
H2int src;
Sint i;
{
  dst[i & 7] = src.r;
}

static void
hrrom_word(dst, src)
Sint *dst;
uSint src;
{
  *dst = (Sint)HRR_RO(src);
}

static void
hrrom_word_global(src)
uSint src;
{
  GW.c = (Sint)HRR_RO(src);
}

static void
hrrom_word_index(dst, src, i)
Sint *dst;
uSint src;
Sint i;
{
  dst[i & 7] = (Sint)HRR_RO(src);
}

/*
 * Combined and pressure cases.  These keep the value live across
 * additional operations and calls, and also cover volatile memory.
 */

static uH2int
hrr_chain(ac, x, y)
uH2int ac;
uH2int *x;
uH2int *y;
{
  ac.r = x->r;
  ac.l = y->l;
  ac.r = y->r;
  return ac;
}

static H2int
hrr_signed_chain(ac, x, y)
H2int ac;
H2int *x;
H2int *y;
{
  ac.r = x->r;
  ac.l = y->l;
  ac.r = y->r;
  return ac;
}

static void
hrr_call_pressure(ac, x)
uH2int ac;
uH2int *x;
{
  extern void clobber(void);

  x->r = ac.r;
  clobber();
  C.r = x->r;
}

static Sint
hrr_word_call_pressure(dst, src)
Sint *dst;
Sint src;
{
  extern void clobber(void);
  Sint r;

  *dst = (*dst & HRR_LEFT) | (src & HRR_RIGHT);
  clobber();

  r = *dst & HRR_RIGHT;
  return r;
}

static Sint
hrr_volatile_load(p)
volatile Sint *p;
{
  return *p & HRR_RIGHT;
}

static Sint
hrre_volatile_load(p)
volatile Sint *p;
{
  return (Sint)HRR_RE(*p);
}

static void
hrr_volatile_store(p, src)
volatile Sint *p;
Sint src;
{
  *p = (*p & HRR_LEFT) | (src & HRR_RIGHT);
}

static void
hrr_volatile_array_store(i, src)
Sint i;
Sint src;
{
  VWA[i & 7] = (VWA[i & 7] & HRR_LEFT) | (src & HRR_RIGHT);
}

static uH2int
hrr_volatile_half_load(ac, p)
uH2int ac;
volatile uH2int *p;
{
  ac.r = p->r;
  return ac;
}

static void
hrr_volatile_half_store(ac, p)
uH2int ac;
volatile uH2int *p;
{
  p->r = ac.r;
}

static Sint
hrr_nested_word_load(p)
struct hrr_halves *p;
{
  return p->u1.r;
}

static void
hrr_nested_word_store(p, x)
struct hrr_halves *p;
Sint x;
{
  p->s1.r = x;
}

static Sint
hrr_global_mix(i, x)
Sint i;
Sint x;
{
  Sint r;

  C.r = A[i & 7];
  D.r = (Hint)x;
  UWA[(i + 1) & 7] = UWA[i & 7] & HRR_RIGHT;
  r = (Sint)HRR_RE(WA[i & 7]);
  return r + C.r + D.r;
}
