#include "insns.h"

/*
 * TSZ instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TSZ   AC,E    AC <- AC & ~SWAP(E)
 *   TSZE  AC,E    AC <- AC & ~SWAP(E); skip if tested bits are nonzero
 *   TSZA  AC,E    AC <- AC & ~SWAP(E); always skip
 *   TSZN  AC,E    AC <- AC & ~SWAP(E); skip if tested bits are zero
 *
 * Keep this file focused on swapped-source masks:
 *   AC & ~SWAP(E)
 *
 * Direct/full-word clearing belongs to TDZ.c.  Right-half immediate
 * clearing belongs to TRZ.c.  Left-half immediate clearing belongs to
 * TLZ.c.
 */

extern Sint f(void);

static Sint tsz_ga;
static Sint tsz_gb;
static uSint tsz_uga;
static Sint tsz_buf[16];
static uSint tsz_ubuf[16];

struct tsz_pair {
  Sint a;
  Sint b;
};

struct tsz_upair {
  uSint a;
  uSint b;
};

static struct tsz_pair tsz_gp;
static struct tsz_upair tsz_ugp;

/*
 * Plain TSZ pressure.
 */

static Sint
tsz_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac & ~SWAP(e);
}

static Sint
tsz_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac & ~SWAP(*e);
}

static Sint
tsz_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac & ~SWAP(e);
}

static Sint
tsz_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac & ~SWAP(*e);
}

static Sint
tsz_global_a(ac)
Sint ac;
{
  return ac & ~SWAP(tsz_ga);
}

static Sint
tsz_global_b(void)
{
  return tsz_ga & ~SWAP(tsz_gb);
}

static Sint
tsz_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac & ~SWAP(v[i & 017]);
}

static Sint
tsz_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac & ~SWAP(tsz_buf[i & 017]);
}

static Sint
tsz_struct_a(ac, p)
Sint ac;
struct tsz_pair *p;
{
  return ac & ~SWAP(p->a);
}

static Sint
tsz_struct_b(ac, p)
Sint ac;
struct tsz_pair *p;
{
  return ac & ~SWAP(p->b);
}

static Sint
tsz_global_struct_a(ac)
Sint ac;
{
  return ac & ~SWAP(tsz_gp.a);
}

static Sint
tsz_global_struct_b(ac)
Sint ac;
{
  return ac & ~SWAP(tsz_gp.b);
}

static Sint
tsz_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac & ~SWAP(**pp);
}

static Sint
tsz_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac & ~SWAP(*e);
}

static Sint
tsz_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return ac & ~SWAP(m);
}

static Sint
tsz_loaded_global(ac)
Sint ac;
{
  Sint m;

  m = tsz_ga;
  return ac & ~SWAP(m);
}

static Sint
tsz_literal_a(ac)
Sint ac;
{
  return ac & ~SWAP(0123456123456);
}

static Sint
tsz_literal_b(ac)
Sint ac;
{
  return ac & ~SWAP(0525252252525);
}

static Sint
tsz_literal_sparse(ac)
Sint ac;
{
  return ac & ~SWAP(0707070070707);
}

static Sint
tsz_literal_left(ac)
Sint ac;
{
  return ac & ~SWAP(0123456000000);
}

static Sint
tsz_literal_right(ac)
Sint ac;
{
  return ac & ~SWAP(0000000123456);
}

static Sint
tsz_literal_highbit(ac)
Sint ac;
{
  return ac & ~SWAP(0400000000000);
}

static Sint
tsz_literal_all(ac)
Sint ac;
{
  return ac & ~SWAP(0777777777777);
}

static void
tsz_store(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  *out = ac & ~SWAP(e);
}

static void
tsz_store_mem(out, ac, e)
Sint *out;
Sint ac;
Sint *e;
{
  *out = ac & ~SWAP(*e);
}

static Sint
tsz_store_return(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  Sint t;

  t = ac & ~SWAP(e);
  *out = t;
  return t;
}

static Sint
tsz_store_global(ac, e)
Sint ac;
Sint e;
{
  tsz_ga = ac & ~SWAP(e);
  return tsz_ga;
}

static Sint
tsz_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac & ~SWAP(e);
  return v[i & 017];
}

static Sint
tsz_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tsz_pair *p;
{
  p->a = ac & ~SWAP(e);
  return p->a;
}

static Sint
tsz_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tsz_pair *p;
{
  p->b = ac & ~SWAP(e);
  return p->b;
}

/*
 * TSZ with memory update after computing AC & ~SWAP(E).
 */

static void
tsz_update_mem(p, e)
Sint *p;
Sint e;
{
  *p = *p & ~SWAP(e);
}

static void
tsz_update_mem_mem(p, e)
Sint *p;
Sint *e;
{
  *p = *p & ~SWAP(*e);
}

static void
tsz_update_global(e)
Sint e;
{
  tsz_ga = tsz_ga & ~SWAP(e);
}

static void
tsz_update_global_mem(e)
Sint *e;
{
  tsz_ga = tsz_ga & ~SWAP(*e);
}

static void
tsz_update_array(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  v[i & 017] = v[i & 017] & ~SWAP(e);
}

static void
tsz_update_global_array(i, e)
Sint i;
Sint e;
{
  tsz_buf[i & 017] = tsz_buf[i & 017] & ~SWAP(e);
}

static void
tsz_update_struct_a(p, e)
struct tsz_pair *p;
Sint e;
{
  p->a = p->a & ~SWAP(e);
}

static void
tsz_update_struct_b(p, e)
struct tsz_pair *p;
Sint e;
{
  p->b = p->b & ~SWAP(e);
}

static Sint
tsz_update_return(p, e)
Sint *p;
Sint e;
{
  *p = *p & ~SWAP(e);
  return *p;
}

static Sint
tsz_global_update_return(e)
Sint e;
{
  tsz_ga = tsz_ga & ~SWAP(e);
  return tsz_ga;
}

static void
tsz_volatile_update(p, e)
volatile Sint *p;
Sint e;
{
  *p = *p & ~SWAP(e);
}

/*
 * TSZE/TSZN pressure.  The skip test is based on the original tested
 * bits AC & SWAP(E), while the resulting AC value is AC & ~SWAP(E).
 */

static Sint
tsze_clear(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsze_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac & ~m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsze_global(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(tsz_ga);
  t = ac & ~m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsze_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (ac & m)
    return yes + t;
  return no + t;
}

static Sint
tsze_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (ac & m)
    t += f();
  return t;
}

static Sint
tsze_likely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (likely(ac & m))
    t = 0;
  return t;
}

static Sint
tsze_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (unlikely(ac & m))
    t = 0;
  return t;
}

static Sint
tsze_literal(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0123456123456);
  t = ac & ~m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsze_literal_highbit(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0400000000000);
  t = ac & ~m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tszn_clear(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tszn_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac & ~m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tszn_global(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(tsz_ga);
  t = ac & ~m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tszn_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (!(ac & m))
    return yes + t;
  return no + t;
}

static Sint
tszn_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (!(ac & m))
    t += f();
  return t;
}

static Sint
tszn_likely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (likely(!(ac & m)))
    t = 0;
  return t;
}

static Sint
tszn_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & ~m;
  if (unlikely(!(ac & m)))
    t = 0;
  return t;
}

static Sint
tszn_literal(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0123456123456);
  t = ac & ~m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tszn_literal_highbit(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0400000000000);
  t = ac & ~m;
  if (!(ac & m))
    t = 0;
  return t;
}

/*
 * TSZA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-clear control flow gives the backend a useful
 * always-skip style shape.
 */

static Sint
tsza_goto(ac, e)
Sint ac;
Sint e;
{
  ac = ac & ~SWAP(e);
  goto done;
done:
  return ac;
}

static Sint
tsza_mem_goto(ac, e)
Sint ac;
Sint *e;
{
  ac = ac & ~SWAP(*e);
  goto done;
done:
  return ac;
}

static Sint
tsza_select(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac = ac & ~SWAP(e);
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
tsza_call(ac, e)
Sint ac;
Sint e;
{
  ac = ac & ~SWAP(e);
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after clearing.
 */

static Sint
tsz_chain(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac & ~SWAP(e);
  return ac & ~SWAP(fmask);
}

static Sint
tsz_chain_same(ac, e)
Sint ac;
Sint e;
{
  ac = ac & ~SWAP(e);
  return ac & ~SWAP(e);
}

static Sint
tsz_mix_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~SWAP(e)) + y;
}

static Sint
tsz_mix_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~SWAP(e)) | y;
}

static Sint
tsz_mix_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~SWAP(e)) ^ y;
}

static Sint
tsz_mix_sub(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac & ~SWAP(e)) - y;
}

static Sint
tsz_from_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a + b;
  return ac & ~SWAP(e);
}

static Sint
tsz_from_xor_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a ^ b;
  return ac & ~SWAP(e);
}

static Sint
tsz_two_tests(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac & ~SWAP(e);
  if (ac & SWAP(fmask))
    ac = ac & ~SWAP(fmask);
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utsz_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac & ~SWAP(e);
}

static uSint
utsz_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac & ~SWAP(*e);
}

static uSint
utsz_global(ac)
uSint ac;
{
  return ac & ~SWAP(tsz_uga);
}

static uSint
utsz_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac & ~SWAP(v[i & 017]);
}

static uSint
utsz_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac & ~SWAP(tsz_ubuf[i & 017]);
}

static uSint
utsz_struct_a(ac, p)
uSint ac;
struct tsz_upair *p;
{
  return ac & ~SWAP(p->a);
}

static uSint
utsz_global_struct_a(ac)
uSint ac;
{
  return ac & ~SWAP(tsz_ugp.a);
}

static uSint
utsz_literal(ac)
uSint ac;
{
  return ac & ~SWAP(0123456123456);
}

static void
utsz_update_mem(p, e)
uSint *p;
uSint e;
{
  *p = *p & ~SWAP(e);
}

static void
utsz_update_global(e)
uSint e;
{
  tsz_uga = tsz_uga & ~SWAP(e);
}

static uSint
utsz_update_return(p, e)
uSint *p;
uSint e;
{
  *p = *p & ~SWAP(e);
  return *p;
}

static Sint
utsze_bool(ac, e)
uSint ac;
uSint e;
{
  uSint m;
  uSint t;

  m = SWAP(e);
  t = ac & ~m;
  if (ac & m)
    return t != 0;
  return 0;
}

static Sint
utszn_bool(ac, e)
uSint ac;
uSint e;
{
  uSint m;
  uSint t;

  m = SWAP(e);
  t = ac & ~m;
  if (!(ac & m))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tsz_qi(ac, e)
Sint ac;
uQint e;
{
  return ac & ~SWAP((Sint)e);
}

static Sint
tsz_hi(ac, e)
Sint ac;
uHint e;
{
  return ac & ~SWAP((Sint)e);
}

static Sint
tsz_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac & ~SWAP((Sint)*e);
}

static Sint
tsz_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac & ~SWAP((Sint)*e);
}
