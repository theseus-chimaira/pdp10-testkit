#include "insns.h"

/*
 * TDO instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TDO   AC,E    AC <- AC | E
 *   TDOE  AC,E    AC <- AC | E; skip if tested bits are nonzero
 *   TDOA  AC,E    AC <- AC | E; always skip
 *   TDON  AC,E    AC <- AC | E; skip if tested bits are zero
 *
 * Keep this file focused on full-word direct masks:
 *   AC | E
 *
 * Right-half immediate OR belongs to TRO.c.  Left-half immediate OR
 * belongs to TLO.c.  Swapped-source OR belongs to TSO.c.  Plain IOR.c
 * covers the ordinary logical OR family; this file adds the
 * test-and-ones skip-family pressure.
 */

extern Sint f(void);

static Sint tdo_ga;
static Sint tdo_gb;
static uSint tdo_uga;
static Sint tdo_buf[16];
static uSint tdo_ubuf[16];

struct tdo_pair {
  Sint a;
  Sint b;
};

struct tdo_upair {
  uSint a;
  uSint b;
};

static struct tdo_pair tdo_gp;
static struct tdo_upair tdo_ugp;

/*
 * Plain TDO pressure.
 */

static Sint
tdo_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac | e;
}

static Sint
tdo_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac | *e;
}

static Sint
tdo_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac | e;
}

static Sint
tdo_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac | *e;
}

static Sint
tdo_global_a(ac)
Sint ac;
{
  return ac | tdo_ga;
}

static Sint
tdo_global_b(void)
{
  return tdo_ga | tdo_gb;
}

static Sint
tdo_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac | v[i & 017];
}

static Sint
tdo_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac | tdo_buf[i & 017];
}

static Sint
tdo_struct_a(ac, p)
Sint ac;
struct tdo_pair *p;
{
  return ac | p->a;
}

static Sint
tdo_struct_b(ac, p)
Sint ac;
struct tdo_pair *p;
{
  return ac | p->b;
}

static Sint
tdo_global_struct_a(ac)
Sint ac;
{
  return ac | tdo_gp.a;
}

static Sint
tdo_global_struct_b(ac)
Sint ac;
{
  return ac | tdo_gp.b;
}

static Sint
tdo_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac | **pp;
}

static Sint
tdo_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac | *e;
}

static Sint
tdo_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return ac | m;
}

static Sint
tdo_loaded_global(ac)
Sint ac;
{
  Sint m;

  m = tdo_ga;
  return ac | m;
}

static Sint
tdo_literal_a(ac)
Sint ac;
{
  return ac | 0123456123456;
}

static Sint
tdo_literal_b(ac)
Sint ac;
{
  return ac | 0525252252525;
}

static Sint
tdo_literal_sparse(ac)
Sint ac;
{
  return ac | 0707070070707;
}

static Sint
tdo_literal_left(ac)
Sint ac;
{
  return ac | 0123456000000;
}

static Sint
tdo_literal_right(ac)
Sint ac;
{
  return ac | 0000000123456;
}

static Sint
tdo_literal_highbit(ac)
Sint ac;
{
  return ac | 0400000000000;
}

static Sint
tdo_literal_all(ac)
Sint ac;
{
  return ac | 0777777777777;
}

static void
tdo_store(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  *out = ac | e;
}

static void
tdo_store_mem(out, ac, e)
Sint *out;
Sint ac;
Sint *e;
{
  *out = ac | *e;
}

static Sint
tdo_store_return(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  *out = t;
  return t;
}

static Sint
tdo_store_global(ac, e)
Sint ac;
Sint e;
{
  tdo_ga = ac | e;
  return tdo_ga;
}

static Sint
tdo_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac | e;
  return v[i & 017];
}

static Sint
tdo_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tdo_pair *p;
{
  p->a = ac | e;
  return p->a;
}

static Sint
tdo_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tdo_pair *p;
{
  p->b = ac | e;
  return p->b;
}

/*
 * TDO with memory update after computing AC | E.
 */

static void
tdo_update_mem(p, e)
Sint *p;
Sint e;
{
  *p = *p | e;
}

static void
tdo_update_mem_mem(p, e)
Sint *p;
Sint *e;
{
  *p = *p | *e;
}

static void
tdo_update_global(e)
Sint e;
{
  tdo_ga = tdo_ga | e;
}

static void
tdo_update_global_mem(e)
Sint *e;
{
  tdo_ga = tdo_ga | *e;
}

static void
tdo_update_array(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  v[i & 017] = v[i & 017] | e;
}

static void
tdo_update_global_array(i, e)
Sint i;
Sint e;
{
  tdo_buf[i & 017] = tdo_buf[i & 017] | e;
}

static void
tdo_update_struct_a(p, e)
struct tdo_pair *p;
Sint e;
{
  p->a = p->a | e;
}

static void
tdo_update_struct_b(p, e)
struct tdo_pair *p;
Sint e;
{
  p->b = p->b | e;
}

static Sint
tdo_update_return(p, e)
Sint *p;
Sint e;
{
  *p = *p | e;
  return *p;
}

static Sint
tdo_global_update_return(e)
Sint e;
{
  tdo_ga = tdo_ga | e;
  return tdo_ga;
}

static void
tdo_volatile_update(p, e)
volatile Sint *p;
Sint e;
{
  *p = *p | e;
}

/*
 * TDOE/TDON pressure.  The skip test is based on the original tested
 * bits AC & E, while the resulting AC value is AC | E.
 */

static Sint
tdoe_clear(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (ac & e)
    t = 0;
  return t;
}

static Sint
tdoe_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tdoe_global(ac)
Sint ac;
{
  Sint t;

  t = ac | tdo_ga;
  if (ac & tdo_ga)
    t = 0;
  return t;
}

static Sint
tdoe_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac | e;
  if (ac & e)
    return yes + t;
  return no + t;
}

static Sint
tdoe_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (ac & e)
    t += f();
  return t;
}

static Sint
tdoe_likely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (likely(ac & e))
    t = 0;
  return t;
}

static Sint
tdoe_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (unlikely(ac & e))
    t = 0;
  return t;
}

static Sint
tdoe_literal(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456123456;
  if (ac & 0123456123456)
    t = 0;
  return t;
}

static Sint
tdoe_literal_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac | 0400000000000;
  if (ac & 0400000000000)
    t = 0;
  return t;
}

static Sint
tdoe_literal_all(ac)
Sint ac;
{
  Sint t;

  t = ac | 0777777777777;
  if (ac & 0777777777777)
    t = 0;
  return t;
}

static Sint
tdon_clear(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (!(ac & e))
    t = 0;
  return t;
}

static Sint
tdon_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tdon_global(ac)
Sint ac;
{
  Sint t;

  t = ac | tdo_ga;
  if (!(ac & tdo_ga))
    t = 0;
  return t;
}

static Sint
tdon_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac | e;
  if (!(ac & e))
    return yes + t;
  return no + t;
}

static Sint
tdon_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (!(ac & e))
    t += f();
  return t;
}

static Sint
tdon_likely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (likely(!(ac & e)))
    t = 0;
  return t;
}

static Sint
tdon_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac | e;
  if (unlikely(!(ac & e)))
    t = 0;
  return t;
}

static Sint
tdon_literal(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456123456;
  if (!(ac & 0123456123456))
    t = 0;
  return t;
}

static Sint
tdon_literal_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac | 0400000000000;
  if (!(ac & 0400000000000))
    t = 0;
  return t;
}

static Sint
tdon_literal_all(ac)
Sint ac;
{
  Sint t;

  t = ac | 0777777777777;
  if (!(ac & 0777777777777))
    t = 0;
  return t;
}

/*
 * TDOA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-OR control flow gives the backend a useful
 * always-skip style shape.
 */

static Sint
tdoa_goto(ac, e)
Sint ac;
Sint e;
{
  ac = ac | e;
  goto done;
done:
  return ac;
}

static Sint
tdoa_mem_goto(ac, e)
Sint ac;
Sint *e;
{
  ac = ac | *e;
  goto done;
done:
  return ac;
}

static Sint
tdoa_select(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac = ac | e;
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
tdoa_call(ac, e)
Sint ac;
Sint e;
{
  ac = ac | e;
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after setting bits.
 */

static Sint
tdo_chain(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac | e;
  return ac | fmask;
}

static Sint
tdo_chain_same(ac, e)
Sint ac;
Sint e;
{
  ac = ac | e;
  return ac | e;
}

static Sint
tdo_mix_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | e) + y;
}

static Sint
tdo_mix_and(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | e) & y;
}

static Sint
tdo_mix_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | e) ^ y;
}

static Sint
tdo_mix_sub(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | e) - y;
}

static Sint
tdo_from_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a + b;
  return ac | e;
}

static Sint
tdo_from_xor_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a ^ b;
  return ac | e;
}

static Sint
tdo_two_tests(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac | e;
  if (ac & fmask)
    ac = ac | fmask;
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utdo_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac | e;
}

static uSint
utdo_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac | *e;
}

static uSint
utdo_global(ac)
uSint ac;
{
  return ac | tdo_uga;
}

static uSint
utdo_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac | v[i & 017];
}

static uSint
utdo_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac | tdo_ubuf[i & 017];
}

static uSint
utdo_struct_a(ac, p)
uSint ac;
struct tdo_upair *p;
{
  return ac | p->a;
}

static uSint
utdo_global_struct_a(ac)
uSint ac;
{
  return ac | tdo_ugp.a;
}

static uSint
utdo_literal(ac)
uSint ac;
{
  return ac | 0123456123456;
}

static void
utdo_update_mem(p, e)
uSint *p;
uSint e;
{
  *p = *p | e;
}

static void
utdo_update_global(e)
uSint e;
{
  tdo_uga = tdo_uga | e;
}

static uSint
utdo_update_return(p, e)
uSint *p;
uSint e;
{
  *p = *p | e;
  return *p;
}

static Sint
utdoe_bool(ac, e)
uSint ac;
uSint e;
{
  uSint t;

  t = ac | e;
  if (ac & e)
    return t != 0;
  return 0;
}

static Sint
utdon_bool(ac, e)
uSint ac;
uSint e;
{
  uSint t;

  t = ac | e;
  if (!(ac & e))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tdo_qi(ac, e)
Sint ac;
uQint e;
{
  return ac | ((Sint)e);
}

static Sint
tdo_hi(ac, e)
Sint ac;
uHint e;
{
  return ac | ((Sint)e);
}

static Sint
tdo_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac | ((Sint)*e);
}

static Sint
tdo_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac | ((Sint)*e);
}
