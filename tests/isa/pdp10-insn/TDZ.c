#include "insns.h"

/*
 * TDZ instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TDZ   AC,E    AC <- AC & ~E
 *   TDZE  AC,E    AC <- AC & ~E; skip if tested bits are nonzero
 *   TDZA  AC,E    AC <- AC & ~E; always skip
 *   TDZN  AC,E    AC <- AC & ~E; skip if tested bits are zero
 *
 * Keep this file focused on full-word direct masks:
 *   AC & ~E
 *
 * Right-half immediate clearing belongs to TRZ.c.  Left-half immediate
 * clearing belongs to TLZ.c.  Swapped source clearing belongs to TSZ.c.
 */

extern Sint f(void);

static Sint tdz_ga;
static Sint tdz_gb;
static uSint tdz_uga;
static Sint tdz_buf[16];
static uSint tdz_ubuf[16];

struct tdz_pair {
  Sint a;
  Sint b;
};

struct tdz_upair {
  uSint a;
  uSint b;
};

static struct tdz_pair tdz_gp;
static struct tdz_upair tdz_ugp;

/*
 * Plain TDZ pressure.
 */

static Sint
tdz_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac & ~e;
}

static Sint
tdz_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac & ~*e;
}

static Sint
tdz_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac & ~e;
}

static Sint
tdz_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac & ~*e;
}

static Sint
tdz_global_a(ac)
Sint ac;
{
  return ac & ~tdz_ga;
}

static Sint
tdz_global_b(void)
{
  return tdz_ga & ~tdz_gb;
}

static Sint
tdz_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac & ~v[i & 017];
}

static Sint
tdz_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac & ~tdz_buf[i & 017];
}

static Sint
tdz_struct_a(ac, p)
Sint ac;
struct tdz_pair *p;
{
  return ac & ~p->a;
}

static Sint
tdz_struct_b(ac, p)
Sint ac;
struct tdz_pair *p;
{
  return ac & ~p->b;
}

static Sint
tdz_global_struct_a(ac)
Sint ac;
{
  return ac & ~tdz_gp.a;
}

static Sint
tdz_global_struct_b(ac)
Sint ac;
{
  return ac & ~tdz_gp.b;
}

static Sint
tdz_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac & ~**pp;
}

static Sint
tdz_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac & ~*e;
}

static Sint
tdz_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return ac & ~m;
}

static Sint
tdz_loaded_global(ac)
Sint ac;
{
  Sint m;

  m = tdz_ga;
  return ac & ~m;
}

static Sint
tdz_literal_a(ac)
Sint ac;
{
  return ac & ~0123456123456;
}

static Sint
tdz_literal_b(ac)
Sint ac;
{
  return ac & ~0525252252525;
}

static Sint
tdz_literal_sparse(ac)
Sint ac;
{
  return ac & ~0707070070707;
}

static Sint
tdz_literal_left(ac)
Sint ac;
{
  return ac & ~0123456000000;
}

static Sint
tdz_literal_right(ac)
Sint ac;
{
  return ac & ~0000000123456;
}

static Sint
tdz_literal_highbit(ac)
Sint ac;
{
  return ac & ~0400000000000;
}

static Sint
tdz_literal_all(ac)
Sint ac;
{
  return ac & ~0777777777777;
}

static void
tdz_store(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  *out = ac & ~e;
}

static void
tdz_store_mem(out, ac, e)
Sint *out;
Sint ac;
Sint *e;
{
  *out = ac & ~*e;
}

static Sint
tdz_store_return(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  *out = t;
  return t;
}

static Sint
tdz_store_global(ac, e)
Sint ac;
Sint e;
{
  tdz_ga = ac & ~e;
  return tdz_ga;
}

static Sint
tdz_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac & ~e;
  return v[i & 017];
}

static Sint
tdz_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tdz_pair *p;
{
  p->a = ac & ~e;
  return p->a;
}

static Sint
tdz_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tdz_pair *p;
{
  p->b = ac & ~e;
  return p->b;
}

/*
 * TDZ with memory update after computing AC & ~E.  The modified object is
 * the destination chosen by C, not the PDP-10 E field itself.
 */

static void
tdz_update_mem(p, e)
Sint *p;
Sint e;
{
  *p = *p & ~e;
}

static void
tdz_update_mem_mem(p, e)
Sint *p;
Sint *e;
{
  *p = *p & ~*e;
}

static void
tdz_update_global(e)
Sint e;
{
  tdz_ga = tdz_ga & ~e;
}

static void
tdz_update_global_mem(e)
Sint *e;
{
  tdz_ga = tdz_ga & ~*e;
}

static void
tdz_update_array(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  v[i & 017] = v[i & 017] & ~e;
}

static void
tdz_update_global_array(i, e)
Sint i;
Sint e;
{
  tdz_buf[i & 017] = tdz_buf[i & 017] & ~e;
}

static void
tdz_update_struct_a(p, e)
struct tdz_pair *p;
Sint e;
{
  p->a = p->a & ~e;
}

static void
tdz_update_struct_b(p, e)
struct tdz_pair *p;
Sint e;
{
  p->b = p->b & ~e;
}

static Sint
tdz_update_return(p, e)
Sint *p;
Sint e;
{
  *p = *p & ~e;
  return *p;
}

static Sint
tdz_global_update_return(e)
Sint e;
{
  tdz_ga = tdz_ga & ~e;
  return tdz_ga;
}

static void
tdz_volatile_update(p, e)
volatile Sint *p;
Sint e;
{
  *p = *p & ~e;
}

/*
 * TDZE/TDZN pressure.  The skip test is based on the original tested
 * bits AC & E, while the resulting AC value is AC & ~E.
 */

static Sint
tdze_clear(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (ac & e)
    t = 0;
  return t;
}

static Sint
tdze_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac & ~m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tdze_global(ac)
Sint ac;
{
  Sint t;

  t = ac & ~tdz_ga;
  if (ac & tdz_ga)
    t = 0;
  return t;
}

static Sint
tdze_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & ~e;
  if (ac & e)
    return yes + t;
  return no + t;
}

static Sint
tdze_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (ac & e)
    t += f();
  return t;
}

static Sint
tdze_likely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (likely(ac & e))
    t = 0;
  return t;
}

static Sint
tdze_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (unlikely(ac & e))
    t = 0;
  return t;
}

static Sint
tdze_literal(ac)
Sint ac;
{
  Sint t;

  t = ac & ~0123456123456;
  if (ac & 0123456123456)
    t = 0;
  return t;
}

static Sint
tdze_literal_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac & ~0400000000000;
  if (ac & 0400000000000)
    t = 0;
  return t;
}

static Sint
tdzn_clear(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (!(ac & e))
    t = 0;
  return t;
}

static Sint
tdzn_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac & ~m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tdzn_global(ac)
Sint ac;
{
  Sint t;

  t = ac & ~tdz_ga;
  if (!(ac & tdz_ga))
    t = 0;
  return t;
}

static Sint
tdzn_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & ~e;
  if (!(ac & e))
    return yes + t;
  return no + t;
}

static Sint
tdzn_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (!(ac & e))
    t += f();
  return t;
}

static Sint
tdzn_likely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (likely(!(ac & e)))
    t = 0;
  return t;
}

static Sint
tdzn_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~e;
  if (unlikely(!(ac & e)))
    t = 0;
  return t;
}

static Sint
tdzn_literal(ac)
Sint ac;
{
  Sint t;

  t = ac & ~0123456123456;
  if (!(ac & 0123456123456))
    t = 0;
  return t;
}

static Sint
tdzn_literal_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac & ~0400000000000;
  if (!(ac & 0400000000000))
    t = 0;
  return t;
}

/*
 * TDZA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-clear control flow gives the backend a useful
 * decrement-and-always-skip style shape.
 */

static Sint
tdza_goto(ac, e)
Sint ac;
Sint e;
{
  ac = ac & ~e;
  goto done;
done:
  return ac;
}

static Sint
tdza_mem_goto(ac, e)
Sint ac;
Sint *e;
{
  ac = ac & ~*e;
  goto done;
done:
  return ac;
}

static Sint
tdza_select(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac = ac & ~e;
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
tdza_call(ac, e)
Sint ac;
Sint e;
{
  ac = ac & ~e;
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after clearing.
 */

static Sint
tdz_chain(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac & ~e;
  return ac & ~fmask;
}

static Sint
tdz_chain_same(ac, e)
Sint ac;
Sint e;
{
  ac = ac & ~e;
  return ac & ~e;
}

static Sint
tdz_mix_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~e) + y;
}

static Sint
tdz_mix_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~e) | y;
}

static Sint
tdz_mix_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~e) ^ y;
}

static Sint
tdz_mix_sub(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~e) - y;
}

static Sint
tdz_from_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a + b;
  return ac & ~e;
}

static Sint
tdz_from_xor_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a ^ b;
  return ac & ~e;
}

static Sint
tdz_two_tests(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac & ~e;
  if (ac & fmask)
    ac = ac & ~fmask;
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utdz_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac & ~e;
}

static uSint
utdz_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac & ~*e;
}

static uSint
utdz_global(ac)
uSint ac;
{
  return ac & ~tdz_uga;
}

static uSint
utdz_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac & ~v[i & 017];
}

static uSint
utdz_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac & ~tdz_ubuf[i & 017];
}

static uSint
utdz_struct_a(ac, p)
uSint ac;
struct tdz_upair *p;
{
  return ac & ~p->a;
}

static uSint
utdz_global_struct_a(ac)
uSint ac;
{
  return ac & ~tdz_ugp.a;
}

static uSint
utdz_literal(ac)
uSint ac;
{
  return ac & ~0123456123456;
}

static void
utdz_update_mem(p, e)
uSint *p;
uSint e;
{
  *p = *p & ~e;
}

static void
utdz_update_global(e)
uSint e;
{
  tdz_uga = tdz_uga & ~e;
}

static uSint
utdz_update_return(p, e)
uSint *p;
uSint e;
{
  *p = *p & ~e;
  return *p;
}

static Sint
utdze_bool(ac, e)
uSint ac;
uSint e;
{
  uSint t;

  t = ac & ~e;
  if (ac & e)
    return t != 0;
  return 0;
}

static Sint
utdzn_bool(ac, e)
uSint ac;
uSint e;
{
  uSint t;

  t = ac & ~e;
  if (!(ac & e))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tdz_qi(ac, e)
Sint ac;
uQint e;
{
  return ac & ~((Sint)e);
}

static Sint
tdz_hi(ac, e)
Sint ac;
uHint e;
{
  return ac & ~((Sint)e);
}

static Sint
tdz_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac & ~((Sint)*e);
}

static Sint
tdz_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac & ~((Sint)*e);
}
