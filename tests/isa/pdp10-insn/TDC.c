#include "insns.h"

/*
 * TDC instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TDC   AC,E    AC <- AC ^ E
 *   TDCE  AC,E    AC <- AC ^ E; skip if tested bits are nonzero
 *   TDCA  AC,E    AC <- AC ^ E; always skip
 *   TDCN  AC,E    AC <- AC ^ E; skip if tested bits are zero
 *
 * Keep this file focused on full-word direct masks:
 *   AC ^ E
 *
 * Right-half immediate complement belongs to TRC.c.  Left-half immediate
 * complement belongs to TLC.c.  Swapped-source complement belongs to
 * TSC.c.  Plain XOR.c covers the ordinary logical XOR family; this file
 * adds the test-and-complement skip-family pressure.
 */

extern Sint f(void);

static Sint tdc_ga;
static Sint tdc_gb;
static uSint tdc_uga;
static Sint tdc_buf[16];
static uSint tdc_ubuf[16];

struct tdc_pair {
  Sint a;
  Sint b;
};

struct tdc_upair {
  uSint a;
  uSint b;
};

static struct tdc_pair tdc_gp;
static struct tdc_upair tdc_ugp;

/*
 * Plain TDC pressure.  These intentionally overlap ordinary XOR
 * semantics, but are kept here for the test-and-complement family.
 */

static Sint
tdc_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac ^ e;
}

static Sint
tdc_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac ^ *e;
}

static Sint
tdc_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac ^ e;
}

static Sint
tdc_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac ^ *e;
}

static Sint
tdc_global_a(ac)
Sint ac;
{
  return ac ^ tdc_ga;
}

static Sint
tdc_global_b(void)
{
  return tdc_ga ^ tdc_gb;
}

static Sint
tdc_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac ^ v[i & 017];
}

static Sint
tdc_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac ^ tdc_buf[i & 017];
}

static Sint
tdc_struct_a(ac, p)
Sint ac;
struct tdc_pair *p;
{
  return ac ^ p->a;
}

static Sint
tdc_struct_b(ac, p)
Sint ac;
struct tdc_pair *p;
{
  return ac ^ p->b;
}

static Sint
tdc_global_struct_a(ac)
Sint ac;
{
  return ac ^ tdc_gp.a;
}

static Sint
tdc_global_struct_b(ac)
Sint ac;
{
  return ac ^ tdc_gp.b;
}

static Sint
tdc_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac ^ **pp;
}

static Sint
tdc_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac ^ *e;
}

static Sint
tdc_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return ac ^ m;
}

static Sint
tdc_loaded_global(ac)
Sint ac;
{
  Sint m;

  m = tdc_ga;
  return ac ^ m;
}

static Sint
tdc_literal_a(ac)
Sint ac;
{
  return ac ^ 0123456123456;
}

static Sint
tdc_literal_b(ac)
Sint ac;
{
  return ac ^ 0525252252525;
}

static Sint
tdc_literal_sparse(ac)
Sint ac;
{
  return ac ^ 0707070070707;
}

static Sint
tdc_literal_left(ac)
Sint ac;
{
  return ac ^ 0123456000000;
}

static Sint
tdc_literal_right(ac)
Sint ac;
{
  return ac ^ 0000000123456;
}

static Sint
tdc_literal_highbit(ac)
Sint ac;
{
  return ac ^ 0400000000000;
}

static Sint
tdc_literal_all(ac)
Sint ac;
{
  return ac ^ 0777777777777;
}

static void
tdc_store(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  *out = ac ^ e;
}

static void
tdc_store_mem(out, ac, e)
Sint *out;
Sint ac;
Sint *e;
{
  *out = ac ^ *e;
}

static Sint
tdc_store_return(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  *out = t;
  return t;
}

static Sint
tdc_store_global(ac, e)
Sint ac;
Sint e;
{
  tdc_ga = ac ^ e;
  return tdc_ga;
}

static Sint
tdc_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac ^ e;
  return v[i & 017];
}

static Sint
tdc_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tdc_pair *p;
{
  p->a = ac ^ e;
  return p->a;
}

static Sint
tdc_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tdc_pair *p;
{
  p->b = ac ^ e;
  return p->b;
}

/*
 * TDC with memory update after computing AC ^ E.
 */

static void
tdc_update_mem(p, e)
Sint *p;
Sint e;
{
  *p = *p ^ e;
}

static void
tdc_update_mem_mem(p, e)
Sint *p;
Sint *e;
{
  *p = *p ^ *e;
}

static void
tdc_update_global(e)
Sint e;
{
  tdc_ga = tdc_ga ^ e;
}

static void
tdc_update_global_mem(e)
Sint *e;
{
  tdc_ga = tdc_ga ^ *e;
}

static void
tdc_update_array(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  v[i & 017] = v[i & 017] ^ e;
}

static void
tdc_update_global_array(i, e)
Sint i;
Sint e;
{
  tdc_buf[i & 017] = tdc_buf[i & 017] ^ e;
}

static void
tdc_update_struct_a(p, e)
struct tdc_pair *p;
Sint e;
{
  p->a = p->a ^ e;
}

static void
tdc_update_struct_b(p, e)
struct tdc_pair *p;
Sint e;
{
  p->b = p->b ^ e;
}

static Sint
tdc_update_return(p, e)
Sint *p;
Sint e;
{
  *p = *p ^ e;
  return *p;
}

static Sint
tdc_global_update_return(e)
Sint e;
{
  tdc_ga = tdc_ga ^ e;
  return tdc_ga;
}

static void
tdc_volatile_update(p, e)
volatile Sint *p;
Sint e;
{
  *p = *p ^ e;
}

/*
 * TDCE/TDCN pressure.  The skip test is based on the original tested
 * bits AC & E, while the resulting AC value is AC ^ E.
 */

static Sint
tdce_clear(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (ac & e)
    t = 0;
  return t;
}

static Sint
tdce_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tdce_global(ac)
Sint ac;
{
  Sint t;

  t = ac ^ tdc_ga;
  if (ac & tdc_ga)
    t = 0;
  return t;
}

static Sint
tdce_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac ^ e;
  if (ac & e)
    return yes + t;
  return no + t;
}

static Sint
tdce_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (ac & e)
    t += f();
  return t;
}

static Sint
tdce_likely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (likely(ac & e))
    t = 0;
  return t;
}

static Sint
tdce_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (unlikely(ac & e))
    t = 0;
  return t;
}

static Sint
tdce_literal(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456123456;
  if (ac & 0123456123456)
    t = 0;
  return t;
}

static Sint
tdce_literal_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0400000000000;
  if (ac & 0400000000000)
    t = 0;
  return t;
}

static Sint
tdce_literal_all(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0777777777777;
  if (ac & 0777777777777)
    t = 0;
  return t;
}

static Sint
tdcn_clear(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (!(ac & e))
    t = 0;
  return t;
}

static Sint
tdcn_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tdcn_global(ac)
Sint ac;
{
  Sint t;

  t = ac ^ tdc_ga;
  if (!(ac & tdc_ga))
    t = 0;
  return t;
}

static Sint
tdcn_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac ^ e;
  if (!(ac & e))
    return yes + t;
  return no + t;
}

static Sint
tdcn_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (!(ac & e))
    t += f();
  return t;
}

static Sint
tdcn_likely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (likely(!(ac & e)))
    t = 0;
  return t;
}

static Sint
tdcn_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ e;
  if (unlikely(!(ac & e)))
    t = 0;
  return t;
}

static Sint
tdcn_literal(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456123456;
  if (!(ac & 0123456123456))
    t = 0;
  return t;
}

static Sint
tdcn_literal_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0400000000000;
  if (!(ac & 0400000000000))
    t = 0;
  return t;
}

static Sint
tdcn_literal_all(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0777777777777;
  if (!(ac & 0777777777777))
    t = 0;
  return t;
}

/*
 * TDCA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-complement control flow gives the backend a useful
 * always-skip style shape.
 */

static Sint
tdca_goto(ac, e)
Sint ac;
Sint e;
{
  ac = ac ^ e;
  goto done;
done:
  return ac;
}

static Sint
tdca_mem_goto(ac, e)
Sint ac;
Sint *e;
{
  ac = ac ^ *e;
  goto done;
done:
  return ac;
}

static Sint
tdca_select(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac = ac ^ e;
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
tdca_call(ac, e)
Sint ac;
Sint e;
{
  ac = ac ^ e;
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after complementing.
 */

static Sint
tdc_chain(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac ^ e;
  return ac ^ fmask;
}

static Sint
tdc_chain_same(ac, e)
Sint ac;
Sint e;
{
  ac = ac ^ e;
  return ac ^ e;
}

static Sint
tdc_mix_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ e) + y;
}

static Sint
tdc_mix_and(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ e) & y;
}

static Sint
tdc_mix_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ e) | y;
}

static Sint
tdc_mix_sub(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ e) - y;
}

static Sint
tdc_from_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a + b;
  return ac ^ e;
}

static Sint
tdc_from_xor_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a ^ b;
  return ac ^ e;
}

static Sint
tdc_two_tests(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac ^ e;
  if (ac & fmask)
    ac = ac ^ fmask;
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utdc_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac ^ e;
}

static uSint
utdc_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac ^ *e;
}

static uSint
utdc_global(ac)
uSint ac;
{
  return ac ^ tdc_uga;
}

static uSint
utdc_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac ^ v[i & 017];
}

static uSint
utdc_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac ^ tdc_ubuf[i & 017];
}

static uSint
utdc_struct_a(ac, p)
uSint ac;
struct tdc_upair *p;
{
  return ac ^ p->a;
}

static uSint
utdc_global_struct_a(ac)
uSint ac;
{
  return ac ^ tdc_ugp.a;
}

static uSint
utdc_literal(ac)
uSint ac;
{
  return ac ^ 0123456123456;
}

static void
utdc_update_mem(p, e)
uSint *p;
uSint e;
{
  *p = *p ^ e;
}

static void
utdc_update_global(e)
uSint e;
{
  tdc_uga = tdc_uga ^ e;
}

static uSint
utdc_update_return(p, e)
uSint *p;
uSint e;
{
  *p = *p ^ e;
  return *p;
}

static Sint
utdce_bool(ac, e)
uSint ac;
uSint e;
{
  uSint t;

  t = ac ^ e;
  if (ac & e)
    return t != 0;
  return 0;
}

static Sint
utdcn_bool(ac, e)
uSint ac;
uSint e;
{
  uSint t;

  t = ac ^ e;
  if (!(ac & e))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tdc_qi(ac, e)
Sint ac;
uQint e;
{
  return ac ^ ((Sint)e);
}

static Sint
tdc_hi(ac, e)
Sint ac;
uHint e;
{
  return ac ^ ((Sint)e);
}

static Sint
tdc_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac ^ ((Sint)*e);
}

static Sint
tdc_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac ^ ((Sint)*e);
}
