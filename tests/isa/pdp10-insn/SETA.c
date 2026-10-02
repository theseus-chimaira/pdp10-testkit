#include "insns.h"

/*
 * SETA instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended logical family:
 *   SETA   AC <- AC
 *   SETAI  AC <- AC
 *   SETAM  memory <- AC
 *   SETAB  AC and memory <- AC
 *
 * This family is semantically very close to MOVE/MOVEM.  Normal C cannot
 * strongly distinguish "set from AC" from "move AC", so this file mostly
 * provides identity, store, and store-and-return pressure for the SETA
 * family while keeping SETM/SETZ/SETCA/etc. out of scope.
 */

static Sint seta_ga;
static Sint seta_gb;
static uSint seta_uga;
static Sint seta_buf[16];
static uSint seta_ubuf[16];

struct seta_pair {
  Sint a;
  Sint b;
};

struct seta_upair {
  uSint a;
  uSint b;
};

static struct seta_pair seta_gp;
static struct seta_upair seta_ugp;

static Sint
seta_reg(a)
Sint a;
{
  return a;
}

static Sint
seta_reg_2(a, b)
Sint a;
Sint b;
{
  b = a;
  return b;
}

static Sint
seta_reg_phi(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (c)
    b = a;
  return b;
}

static Sint
seta_from_global(void)
{
  return seta_ga;
}

static Sint
seta_from_global_b(void)
{
  return seta_gb;
}

static Sint
seta_from_array(i)
Sint i;
{
  return seta_buf[i & 017];
}

static Sint
seta_from_mem(p)
Sint *p;
{
  return *p;
}

static Sint
seta_from_struct_a(p)
struct seta_pair *p;
{
  return p->a;
}

static Sint
seta_from_struct_b(p)
struct seta_pair *p;
{
  return p->b;
}

static Sint
seta_from_global_struct_a(void)
{
  return seta_gp.a;
}

static Sint
seta_from_global_struct_b(void)
{
  return seta_gp.b;
}

static Sint
seta_from_indirect(pp)
Sint **pp;
{
  return **pp;
}

static Sint
seta_from_volatile(p)
volatile Sint *p;
{
  return *p;
}

static void
setam_mem(a, p)
Sint a;
Sint *p;
{
  *p = a;
}

static void
setam_global(a)
Sint a;
{
  seta_ga = a;
}

static void
setam_global_b(a)
Sint a;
{
  seta_gb = a;
}

static void
setam_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  v[i & 017] = a;
}

static void
setam_global_array(a, i)
Sint a;
Sint i;
{
  seta_buf[i & 017] = a;
}

static void
setam_struct_a(a, p)
Sint a;
struct seta_pair *p;
{
  p->a = a;
}

static void
setam_struct_b(a, p)
Sint a;
struct seta_pair *p;
{
  p->b = a;
}

static void
setam_global_struct_a(a)
Sint a;
{
  seta_gp.a = a;
}

static void
setam_global_struct_b(a)
Sint a;
{
  seta_gp.b = a;
}

static void
setam_indirect(a, pp)
Sint a;
Sint **pp;
{
  **pp = a;
}

static void
setam_volatile(a, p)
Sint a;
volatile Sint *p;
{
  *p = a;
}

static Sint
setab_mem(a, p)
Sint a;
Sint *p;
{
  *p = a;
  return a;
}

static Sint
setab_mem_reload(a, p)
Sint a;
Sint *p;
{
  *p = a;
  return *p;
}

static Sint
setab_global(a)
Sint a;
{
  seta_ga = a;
  return a;
}

static Sint
setab_global_reload(a)
Sint a;
{
  seta_ga = a;
  return seta_ga;
}

static Sint
setab_global_b(a)
Sint a;
{
  seta_gb = a;
  return a;
}

static Sint
setab_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  v[i & 017] = a;
  return a;
}

static Sint
setab_array_reload(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  v[i & 017] = a;
  return v[i & 017];
}

static Sint
setab_global_array(a, i)
Sint a;
Sint i;
{
  seta_buf[i & 017] = a;
  return a;
}

static Sint
setab_global_array_reload(a, i)
Sint a;
Sint i;
{
  seta_buf[i & 017] = a;
  return seta_buf[i & 017];
}

static Sint
setab_struct_a(a, p)
Sint a;
struct seta_pair *p;
{
  p->a = a;
  return a;
}

static Sint
setab_struct_a_reload(a, p)
Sint a;
struct seta_pair *p;
{
  p->a = a;
  return p->a;
}

static Sint
setab_struct_b(a, p)
Sint a;
struct seta_pair *p;
{
  p->b = a;
  return a;
}

static Sint
setab_struct_b_reload(a, p)
Sint a;
struct seta_pair *p;
{
  p->b = a;
  return p->b;
}

static Sint
setab_global_struct_a(a)
Sint a;
{
  seta_gp.a = a;
  return a;
}

static Sint
setab_global_struct_a_reload(a)
Sint a;
{
  seta_gp.a = a;
  return seta_gp.a;
}

static Sint
setab_global_struct_b(a)
Sint a;
{
  seta_gp.b = a;
  return a;
}

static Sint
setab_global_struct_b_reload(a)
Sint a;
{
  seta_gp.b = a;
  return seta_gp.b;
}

static Sint
setab_indirect(a, pp)
Sint a;
Sint **pp;
{
  **pp = a;
  return a;
}

static Sint
setab_volatile(a, p)
Sint a;
volatile Sint *p;
{
  *p = a;
  return a;
}

static uSint
useta_reg(a)
uSint a;
{
  return a;
}

static uSint
useta_from_global(void)
{
  return seta_uga;
}

static uSint
useta_from_mem(p)
uSint *p;
{
  return *p;
}

static uSint
useta_from_array(v, i)
uSint *v;
Sint i;
{
  return v[i & 017];
}

static uSint
useta_from_struct_a(p)
struct seta_upair *p;
{
  return p->a;
}

static uSint
useta_from_global_struct_a(void)
{
  return seta_ugp.a;
}

static void
usetam_mem(a, p)
uSint a;
uSint *p;
{
  *p = a;
}

static void
usetam_global(a)
uSint a;
{
  seta_uga = a;
}

static void
usetam_array(a, v, i)
uSint a;
uSint *v;
Sint i;
{
  v[i & 017] = a;
}

static void
usetam_global_array(a, i)
uSint a;
Sint i;
{
  seta_ubuf[i & 017] = a;
}

static void
usetam_struct_a(a, p)
uSint a;
struct seta_upair *p;
{
  p->a = a;
}

static uSint
usetab_mem(a, p)
uSint a;
uSint *p;
{
  *p = a;
  return a;
}

static uSint
usetab_mem_reload(a, p)
uSint a;
uSint *p;
{
  *p = a;
  return *p;
}

static uSint
usetab_global(a)
uSint a;
{
  seta_uga = a;
  return a;
}

static uSint
usetab_global_reload(a)
uSint a;
{
  seta_uga = a;
  return seta_uga;
}

static uSint
usetab_array(a, v, i)
uSint a;
uSint *v;
Sint i;
{
  v[i & 017] = a;
  return a;
}

static uSint
usetab_global_array(a, i)
uSint a;
Sint i;
{
  seta_ubuf[i & 017] = a;
  return a;
}

static Sint
seta_qi(a)
sQint a;
{
  return a;
}

static Sint
seta_uqi(a)
uQint a;
{
  return a;
}

static Sint
seta_hi(a)
Hint a;
{
  return a;
}

static Sint
seta_uhi(a)
uHint a;
{
  return a;
}

static void
setam_qi(a, p)
sQint a;
sQint *p;
{
  *p = a;
}

static void
setam_uqi(a, p)
uQint a;
uQint *p;
{
  *p = a;
}

static void
setam_hi(a, p)
Hint a;
Hint *p;
{
  *p = a;
}

static void
setam_uhi(a, p)
uHint a;
uHint *p;
{
  *p = a;
}

static Sint
setab_qi(a, p)
sQint a;
sQint *p;
{
  *p = a;
  return a;
}

static Sint
setab_uqi(a, p)
uQint a;
uQint *p;
{
  *p = a;
  return a;
}

static Sint
setab_hi(a, p)
Hint a;
Hint *p;
{
  *p = a;
  return a;
}

static Sint
setab_uhi(a, p)
uHint a;
uHint *p;
{
  *p = a;
  return a;
}

/*
 * Extra identity pressure.  These are useful because SETA/SETAI are
 * semantic no-ops and may disappear unless the value is kept live in
 * slightly different ways.
 */

static Sint
seta_select(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (c)
    return a;
  return b;
}

static Sint
seta_after_call(a)
Sint a;
{
  extern Sint f(void);

  f();
  return a;
}

static Sint
seta_store_two(a, p, q)
Sint a;
Sint *p;
Sint *q;
{
  *p = a;
  *q = a;
  return a;
}

static Sint
seta_store_chain(a, p)
Sint a;
Sint *p;
{
  *p = a;
  a = *p;
  return a;
}

BOTH (setab_both, a)
BOTH1 (uSint, usetab_both, a)
