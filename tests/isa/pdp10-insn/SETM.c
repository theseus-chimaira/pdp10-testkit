#include "insns.h"

/*
 * SETM instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended logical family:
 *   SETM   AC <- E
 *   SETMI  AC <- immediate E
 *   SETMM  E <- E
 *   SETMB  AC and E <- E
 *
 * This family is semantically very close to MOVE/MOVEI and sometimes to
 * a no-op for SETMM/SETMB memory forms.  Use loads, constants, volatile
 * self-stores, and store-and-return shapes as pressure for the SETM
 * family, but keep SETA identity and SETZ/SETO constants out of scope.
 */

static Sint setm_ga;
static Sint setm_gb;
static uSint setm_uga;
static Sint setm_buf[16];
static uSint setm_ubuf[16];

struct setm_pair {
  Sint a;
  Sint b;
};

struct setm_upair {
  uSint a;
  uSint b;
};

static struct setm_pair setm_gp;
static struct setm_upair setm_ugp;

static Sint
setm_mem(p)
Sint *p;
{
  return *p;
}

static Sint
setm_mem_2(p, q)
Sint *p;
Sint *q;
{
  if (*q)
    return *p;
  return *q;
}

static Sint
setm_global_a(void)
{
  return setm_ga;
}

static Sint
setm_global_b(void)
{
  return setm_gb;
}

static Sint
setm_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017];
}

static Sint
setm_global_array(i)
Sint i;
{
  return setm_buf[i & 017];
}

static Sint
setm_struct_a(p)
struct setm_pair *p;
{
  return p->a;
}

static Sint
setm_struct_b(p)
struct setm_pair *p;
{
  return p->b;
}

static Sint
setm_global_struct_a(void)
{
  return setm_gp.a;
}

static Sint
setm_global_struct_b(void)
{
  return setm_gp.b;
}

static Sint
setm_indirect(pp)
Sint **pp;
{
  return **pp;
}

static Sint
setm_volatile(p)
volatile Sint *p;
{
  return *p;
}

/*
 * SETMI pressure.  Avoid 0 and -1 here; those belong naturally to
 * SETZ/SETO tests.
 */

static Sint
setmi_small(void)
{
  return 0123456;
}

static Sint
setmi_one(void)
{
  return 1;
}

static Sint
setmi_low18(void)
{
  return 0777777;
}

static Sint
setmi_alt(void)
{
  return 0525252;
}

static Sint
setmi_sparse(void)
{
  return 0707070;
}

static Sint
setmi_fullword(void)
{
  return 0123456123456;
}

static Sint
setmi_left(void)
{
  return 0123456000000;
}

static Sint
setmi_right(void)
{
  return 0000000123456;
}

static Sint
setmi_sign(void)
{
  return 0400000000000;
}

static Sint
setmi_mixed(void)
{
  return 0525252252525;
}

/*
 * SETMM pressure.  For f(A,E)=E, the memory result is the original
 * memory value.  Non-volatile self stores may vanish, so keep volatile
 * forms too.
 */

static void
setmm_self(p)
Sint *p;
{
  *p = *p;
}

static void
setmm_global_a(void)
{
  setm_ga = setm_ga;
}

static void
setmm_global_b(void)
{
  setm_gb = setm_gb;
}

static void
setmm_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017];
}

static void
setmm_global_array(i)
Sint i;
{
  setm_buf[i & 017] = setm_buf[i & 017];
}

static void
setmm_struct_a(p)
struct setm_pair *p;
{
  p->a = p->a;
}

static void
setmm_struct_b(p)
struct setm_pair *p;
{
  p->b = p->b;
}

static void
setmm_global_struct_a(void)
{
  setm_gp.a = setm_gp.a;
}

static void
setmm_global_struct_b(void)
{
  setm_gp.b = setm_gp.b;
}

static void
setmm_indirect(pp)
Sint **pp;
{
  **pp = **pp;
}

static void
setmm_volatile(p)
volatile Sint *p;
{
  *p = *p;
}

static void
setmm_volatile_global_a(void)
{
  volatile Sint *p;

  p = &setm_ga;
  *p = *p;
}

static void
setmm_volatile_array(v, i)
volatile Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017];
}

static void
setmm_volatile_struct_a(p)
volatile struct setm_pair *p;
{
  p->a = p->a;
}

/*
 * SETMB pressure: AC/result and memory both become E.  For SETM this
 * means return the source value while keeping a memory self-store shape.
 */

static Sint
setmb_mem(p)
Sint *p;
{
  *p = *p;
  return *p;
}

static Sint
setmb_mem_temp(p)
Sint *p;
{
  Sint t;

  t = *p;
  *p = t;
  return t;
}

static Sint
setmb_global_a(void)
{
  setm_ga = setm_ga;
  return setm_ga;
}

static Sint
setmb_global_b(void)
{
  setm_gb = setm_gb;
  return setm_gb;
}

static Sint
setmb_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017];
  return v[i & 017];
}

static Sint
setmb_array_temp(v, i)
Sint *v;
Sint i;
{
  Sint t;

  t = v[i & 017];
  v[i & 017] = t;
  return t;
}

static Sint
setmb_global_array(i)
Sint i;
{
  setm_buf[i & 017] = setm_buf[i & 017];
  return setm_buf[i & 017];
}

static Sint
setmb_struct_a(p)
struct setm_pair *p;
{
  p->a = p->a;
  return p->a;
}

static Sint
setmb_struct_b(p)
struct setm_pair *p;
{
  p->b = p->b;
  return p->b;
}

static Sint
setmb_struct_a_temp(p)
struct setm_pair *p;
{
  Sint t;

  t = p->a;
  p->a = t;
  return t;
}

static Sint
setmb_struct_b_temp(p)
struct setm_pair *p;
{
  Sint t;

  t = p->b;
  p->b = t;
  return t;
}

static Sint
setmb_global_struct_a(void)
{
  setm_gp.a = setm_gp.a;
  return setm_gp.a;
}

static Sint
setmb_global_struct_b(void)
{
  setm_gp.b = setm_gp.b;
  return setm_gp.b;
}

static Sint
setmb_indirect(pp)
Sint **pp;
{
  **pp = **pp;
  return **pp;
}

static Sint
setmb_volatile(p)
volatile Sint *p;
{
  Sint t;

  t = *p;
  *p = t;
  return t;
}

static Sint
setmb_volatile_array(v, i)
volatile Sint *v;
Sint i;
{
  Sint t;

  t = v[i & 017];
  v[i & 017] = t;
  return t;
}

static Sint
setmb_volatile_struct_a(p)
volatile struct setm_pair *p;
{
  Sint t;

  t = p->a;
  p->a = t;
  return t;
}

/*
 * Copy forms are not exact SETMM encoding, because the PDP-10 M variant
 * stores back into E itself.  Still useful as source-E load pressure.
 */

static void
setm_copy_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst = *src;
}

static Sint
setm_copy_mem_return(dst, src)
Sint *dst;
Sint *src;
{
  Sint t;

  t = *src;
  *dst = t;
  return t;
}

static void
setm_copy_global_to_mem(dst)
Sint *dst;
{
  *dst = setm_ga;
}

static void
setm_copy_mem_to_global(src)
Sint *src;
{
  setm_ga = *src;
}

static Sint
setm_copy_mem_to_global_return(src)
Sint *src;
{
  setm_ga = *src;
  return setm_ga;
}

static void
setm_copy_array(dst, src, i)
Sint *dst;
Sint *src;
Sint i;
{
  dst[i & 017] = src[i & 017];
}

static Sint
setm_copy_array_return(dst, src, i)
Sint *dst;
Sint *src;
Sint i;
{
  Sint t;

  t = src[i & 017];
  dst[i & 017] = t;
  return t;
}

static void
setm_copy_struct(dst, src)
struct setm_pair *dst;
struct setm_pair *src;
{
  dst->a = src->a;
}

static Sint
setm_copy_struct_return(dst, src)
struct setm_pair *dst;
struct setm_pair *src;
{
  Sint t;

  t = src->b;
  dst->b = t;
  return t;
}

static uSint
usetm_mem(p)
uSint *p;
{
  return *p;
}

static uSint
usetm_global(void)
{
  return setm_uga;
}

static uSint
usetm_array(v, i)
uSint *v;
Sint i;
{
  return v[i & 017];
}

static uSint
usetm_global_array(i)
Sint i;
{
  return setm_ubuf[i & 017];
}

static uSint
usetm_struct_a(p)
struct setm_upair *p;
{
  return p->a;
}

static uSint
usetm_global_struct_a(void)
{
  return setm_ugp.a;
}

static uSint
usetmi_small(void)
{
  return 0123456;
}

static uSint
usetmi_low18(void)
{
  return 0777777;
}

static uSint
usetmi_fullword(void)
{
  return 0123456123456;
}

static void
usetmm_self(p)
uSint *p;
{
  *p = *p;
}

static void
usetmm_global(void)
{
  setm_uga = setm_uga;
}

static void
usetmm_array(v, i)
uSint *v;
Sint i;
{
  v[i & 017] = v[i & 017];
}

static void
usetmm_volatile(p)
volatile uSint *p;
{
  *p = *p;
}

static uSint
usetmb_mem(p)
uSint *p;
{
  *p = *p;
  return *p;
}

static uSint
usetmb_mem_temp(p)
uSint *p;
{
  uSint t;

  t = *p;
  *p = t;
  return t;
}

static uSint
usetmb_global(void)
{
  setm_uga = setm_uga;
  return setm_uga;
}

static uSint
usetmb_array(v, i)
uSint *v;
Sint i;
{
  v[i & 017] = v[i & 017];
  return v[i & 017];
}

static Sint
setm_qi(p)
sQint *p;
{
  return *p;
}

static Sint
setm_uqi(p)
uQint *p;
{
  return *p;
}

static Sint
setm_hi(p)
Hint *p;
{
  return *p;
}

static Sint
setm_uhi(p)
uHint *p;
{
  return *p;
}

static void
setmm_qi(p)
sQint *p;
{
  *p = *p;
}

static void
setmm_uqi(p)
uQint *p;
{
  *p = *p;
}

static void
setmm_hi(p)
Hint *p;
{
  *p = *p;
}

static void
setmm_uhi(p)
uHint *p;
{
  *p = *p;
}

static Sint
setmb_qi(p)
sQint *p;
{
  sQint t;

  t = *p;
  *p = t;
  return t;
}

static Sint
setmb_uqi(p)
uQint *p;
{
  uQint t;

  t = *p;
  *p = t;
  return t;
}

static Sint
setmb_hi(p)
Hint *p;
{
  Hint t;

  t = *p;
  *p = t;
  return t;
}

static Sint
setmb_uhi(p)
uHint *p;
{
  uHint t;

  t = *p;
  *p = t;
  return t;
}

/*
 * Control-flow variants to keep loaded E live across simple branches.
 */

static Sint
setm_select(p, q, c)
Sint *p;
Sint *q;
Sint c;
{
  if (c)
    return *p;
  return *q;
}

static Sint
setm_after_call(p)
Sint *p;
{
  extern Sint f(void);

  f();
  return *p;
}

static Sint
setm_store_two_from_source(src, p, q)
Sint *src;
Sint *p;
Sint *q;
{
  Sint t;

  t = *src;
  *p = t;
  *q = t;
  return t;
}

static Sint
setm_reload_chain(p)
Sint *p;
{
  Sint t;

  t = *p;
  p[1] = t;
  return t;
}
