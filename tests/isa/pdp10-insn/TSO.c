#include "insns.h"

/*
 * TSO instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TSO   AC,E    AC <- AC | SWAP(E)
 *   TSOE  AC,E    AC <- AC | SWAP(E); skip if tested bits are nonzero
 *   TSOA  AC,E    AC <- AC | SWAP(E); always skip
 *   TSON  AC,E    AC <- AC | SWAP(E); skip if tested bits are zero
 *
 * Keep this file focused on swapped-source OR:
 *   AC | SWAP(E)
 *
 * Direct/full-word OR belongs to TDO.c.  Right-half immediate OR belongs
 * to TRO.c.  Left-half immediate OR belongs to TLO.c.
 */

extern Sint f(void);

static Sint tso_ga;
static Sint tso_gb;
static uSint tso_uga;
static Sint tso_buf[16];
static uSint tso_ubuf[16];

struct tso_pair {
  Sint a;
  Sint b;
};

struct tso_upair {
  uSint a;
  uSint b;
};

static struct tso_pair tso_gp;
static struct tso_upair tso_ugp;

/*
 * Plain TSO pressure.
 */

static Sint
tso_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac | SWAP(e);
}

static Sint
tso_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac | SWAP(*e);
}

static Sint
tso_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac | SWAP(e);
}

static Sint
tso_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac | SWAP(*e);
}

static Sint
tso_global_a(ac)
Sint ac;
{
  return ac | SWAP(tso_ga);
}

static Sint
tso_global_b(void)
{
  return tso_ga | SWAP(tso_gb);
}

static Sint
tso_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac | SWAP(v[i & 017]);
}

static Sint
tso_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac | SWAP(tso_buf[i & 017]);
}

static Sint
tso_struct_a(ac, p)
Sint ac;
struct tso_pair *p;
{
  return ac | SWAP(p->a);
}

static Sint
tso_struct_b(ac, p)
Sint ac;
struct tso_pair *p;
{
  return ac | SWAP(p->b);
}

static Sint
tso_global_struct_a(ac)
Sint ac;
{
  return ac | SWAP(tso_gp.a);
}

static Sint
tso_global_struct_b(ac)
Sint ac;
{
  return ac | SWAP(tso_gp.b);
}

static Sint
tso_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac | SWAP(**pp);
}

static Sint
tso_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac | SWAP(*e);
}

static Sint
tso_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return ac | SWAP(m);
}

static Sint
tso_loaded_global(ac)
Sint ac;
{
  Sint m;

  m = tso_ga;
  return ac | SWAP(m);
}

static Sint
tso_literal_a(ac)
Sint ac;
{
  return ac | SWAP(0123456123456);
}

static Sint
tso_literal_b(ac)
Sint ac;
{
  return ac | SWAP(0525252252525);
}

static Sint
tso_literal_sparse(ac)
Sint ac;
{
  return ac | SWAP(0707070070707);
}

static Sint
tso_literal_left(ac)
Sint ac;
{
  return ac | SWAP(0123456000000);
}

static Sint
tso_literal_right(ac)
Sint ac;
{
  return ac | SWAP(0000000123456);
}

static Sint
tso_literal_highbit(ac)
Sint ac;
{
  return ac | SWAP(0400000000000);
}

static Sint
tso_literal_all(ac)
Sint ac;
{
  return ac | SWAP(0777777777777);
}

static void
tso_store(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  *out = ac | SWAP(e);
}

static void
tso_store_mem(out, ac, e)
Sint *out;
Sint ac;
Sint *e;
{
  *out = ac | SWAP(*e);
}

static Sint
tso_store_return(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  Sint t;

  t = ac | SWAP(e);
  *out = t;
  return t;
}

static Sint
tso_store_global(ac, e)
Sint ac;
Sint e;
{
  tso_ga = ac | SWAP(e);
  return tso_ga;
}

static Sint
tso_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac | SWAP(e);
  return v[i & 017];
}

static Sint
tso_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tso_pair *p;
{
  p->a = ac | SWAP(e);
  return p->a;
}

static Sint
tso_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tso_pair *p;
{
  p->b = ac | SWAP(e);
  return p->b;
}

/*
 * TSO with memory update after computing AC | SWAP(E).
 */

static void
tso_update_mem(p, e)
Sint *p;
Sint e;
{
  *p = *p | SWAP(e);
}

static void
tso_update_mem_mem(p, e)
Sint *p;
Sint *e;
{
  *p = *p | SWAP(*e);
}

static void
tso_update_global(e)
Sint e;
{
  tso_ga = tso_ga | SWAP(e);
}

static void
tso_update_global_mem(e)
Sint *e;
{
  tso_ga = tso_ga | SWAP(*e);
}

static void
tso_update_array(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  v[i & 017] = v[i & 017] | SWAP(e);
}

static void
tso_update_global_array(i, e)
Sint i;
Sint e;
{
  tso_buf[i & 017] = tso_buf[i & 017] | SWAP(e);
}

static void
tso_update_struct_a(p, e)
struct tso_pair *p;
Sint e;
{
  p->a = p->a | SWAP(e);
}

static void
tso_update_struct_b(p, e)
struct tso_pair *p;
Sint e;
{
  p->b = p->b | SWAP(e);
}

static Sint
tso_update_return(p, e)
Sint *p;
Sint e;
{
  *p = *p | SWAP(e);
  return *p;
}

static Sint
tso_global_update_return(e)
Sint e;
{
  tso_ga = tso_ga | SWAP(e);
  return tso_ga;
}

static void
tso_volatile_update(p, e)
volatile Sint *p;
Sint e;
{
  *p = *p | SWAP(e);
}

/*
 * TSOE/TSON pressure.  The skip test is based on the original tested
 * bits AC & SWAP(E), while the resulting AC value is AC | SWAP(E).
 */

static Sint
tsoe_clear(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsoe_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsoe_global(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(tso_ga);
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsoe_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (ac & m)
    return yes + t;
  return no + t;
}

static Sint
tsoe_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (ac & m)
    t += f();
  return t;
}

static Sint
tsoe_likely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (likely(ac & m))
    t = 0;
  return t;
}

static Sint
tsoe_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (unlikely(ac & m))
    t = 0;
  return t;
}

static Sint
tsoe_literal(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0123456123456);
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsoe_literal_highbit(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0400000000000);
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsoe_literal_all(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0777777777777);
  t = ac | m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tson_clear(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tson_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tson_global(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(tso_ga);
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tson_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (!(ac & m))
    return yes + t;
  return no + t;
}

static Sint
tson_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (!(ac & m))
    t += f();
  return t;
}

static Sint
tson_likely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (likely(!(ac & m)))
    t = 0;
  return t;
}

static Sint
tson_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac | m;
  if (unlikely(!(ac & m)))
    t = 0;
  return t;
}

static Sint
tson_literal(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0123456123456);
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tson_literal_highbit(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0400000000000);
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tson_literal_all(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0777777777777);
  t = ac | m;
  if (!(ac & m))
    t = 0;
  return t;
}

/*
 * TSOA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-OR control flow gives the backend a useful
 * always-skip style shape.
 */

static Sint
tsoa_goto(ac, e)
Sint ac;
Sint e;
{
  ac = ac | SWAP(e);
  goto done;
done:
  return ac;
}

static Sint
tsoa_mem_goto(ac, e)
Sint ac;
Sint *e;
{
  ac = ac | SWAP(*e);
  goto done;
done:
  return ac;
}

static Sint
tsoa_select(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac = ac | SWAP(e);
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
tsoa_call(ac, e)
Sint ac;
Sint e;
{
  ac = ac | SWAP(e);
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after setting bits.
 */

static Sint
tso_chain(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac | SWAP(e);
  return ac | SWAP(fmask);
}

static Sint
tso_chain_same(ac, e)
Sint ac;
Sint e;
{
  ac = ac | SWAP(e);
  return ac | SWAP(e);
}

static Sint
tso_mix_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | SWAP(e)) + y;
}

static Sint
tso_mix_and(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | SWAP(e)) & y;
}

static Sint
tso_mix_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | SWAP(e)) ^ y;
}

static Sint
tso_mix_sub(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac | SWAP(e)) - y;
}

static Sint
tso_from_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a + b;
  return ac | SWAP(e);
}

static Sint
tso_from_xor_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a ^ b;
  return ac | SWAP(e);
}

static Sint
tso_two_tests(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac | SWAP(e);
  if (ac & SWAP(fmask))
    ac = ac | SWAP(fmask);
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utso_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac | SWAP(e);
}

static uSint
utso_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac | SWAP(*e);
}

static uSint
utso_global(ac)
uSint ac;
{
  return ac | SWAP(tso_uga);
}

static uSint
utso_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac | SWAP(v[i & 017]);
}

static uSint
utso_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac | SWAP(tso_ubuf[i & 017]);
}

static uSint
utso_struct_a(ac, p)
uSint ac;
struct tso_upair *p;
{
  return ac | SWAP(p->a);
}

static uSint
utso_global_struct_a(ac)
uSint ac;
{
  return ac | SWAP(tso_ugp.a);
}

static uSint
utso_literal(ac)
uSint ac;
{
  return ac | SWAP(0123456123456);
}

static void
utso_update_mem(p, e)
uSint *p;
uSint e;
{
  *p = *p | SWAP(e);
}

static void
utso_update_global(e)
uSint e;
{
  tso_uga = tso_uga | SWAP(e);
}

static uSint
utso_update_return(p, e)
uSint *p;
uSint e;
{
  *p = *p | SWAP(e);
  return *p;
}

static Sint
utsoe_bool(ac, e)
uSint ac;
uSint e;
{
  uSint m;
  uSint t;

  m = SWAP(e);
  t = ac | m;
  if (ac & m)
    return t != 0;
  return 0;
}

static Sint
utson_bool(ac, e)
uSint ac;
uSint e;
{
  uSint m;
  uSint t;

  m = SWAP(e);
  t = ac | m;
  if (!(ac & m))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tso_qi(ac, e)
Sint ac;
uQint e;
{
  return ac | SWAP((Sint)e);
}

static Sint
tso_hi(ac, e)
Sint ac;
uHint e;
{
  return ac | SWAP((Sint)e);
}

static Sint
tso_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac | SWAP((Sint)*e);
}

static Sint
tso_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac | SWAP((Sint)*e);
}
