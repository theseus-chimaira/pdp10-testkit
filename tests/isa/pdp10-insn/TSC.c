#include "insns.h"

/*
 * TSC instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TSC   AC,E    AC <- AC ^ SWAP(E)
 *   TSCE  AC,E    AC <- AC ^ SWAP(E); skip if tested bits are nonzero
 *   TSCA  AC,E    AC <- AC ^ SWAP(E); always skip
 *   TSCN  AC,E    AC <- AC ^ SWAP(E); skip if tested bits are zero
 *
 * Keep this file focused on swapped-source complement:
 *   AC ^ SWAP(E)
 *
 * Direct/full-word complement belongs to TDC.c.  Right-half immediate
 * complement belongs to TRC.c.  Left-half immediate complement belongs
 * to TLC.c.
 */

extern Sint f(void);

static Sint tsc_ga;
static Sint tsc_gb;
static uSint tsc_uga;
static Sint tsc_buf[16];
static uSint tsc_ubuf[16];

struct tsc_pair {
  Sint a;
  Sint b;
};

struct tsc_upair {
  uSint a;
  uSint b;
};

static struct tsc_pair tsc_gp;
static struct tsc_upair tsc_ugp;

/*
 * Plain TSC pressure.
 */

static Sint
tsc_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac ^ SWAP(e);
}

static Sint
tsc_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac ^ SWAP(*e);
}

static Sint
tsc_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac ^ SWAP(e);
}

static Sint
tsc_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac ^ SWAP(*e);
}

static Sint
tsc_global_a(ac)
Sint ac;
{
  return ac ^ SWAP(tsc_ga);
}

static Sint
tsc_global_b(void)
{
  return tsc_ga ^ SWAP(tsc_gb);
}

static Sint
tsc_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac ^ SWAP(v[i & 017]);
}

static Sint
tsc_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac ^ SWAP(tsc_buf[i & 017]);
}

static Sint
tsc_struct_a(ac, p)
Sint ac;
struct tsc_pair *p;
{
  return ac ^ SWAP(p->a);
}

static Sint
tsc_struct_b(ac, p)
Sint ac;
struct tsc_pair *p;
{
  return ac ^ SWAP(p->b);
}

static Sint
tsc_global_struct_a(ac)
Sint ac;
{
  return ac ^ SWAP(tsc_gp.a);
}

static Sint
tsc_global_struct_b(ac)
Sint ac;
{
  return ac ^ SWAP(tsc_gp.b);
}

static Sint
tsc_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac ^ SWAP(**pp);
}

static Sint
tsc_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac ^ SWAP(*e);
}

static Sint
tsc_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return ac ^ SWAP(m);
}

static Sint
tsc_loaded_global(ac)
Sint ac;
{
  Sint m;

  m = tsc_ga;
  return ac ^ SWAP(m);
}

static Sint
tsc_literal_a(ac)
Sint ac;
{
  return ac ^ SWAP(0123456123456);
}

static Sint
tsc_literal_b(ac)
Sint ac;
{
  return ac ^ SWAP(0525252252525);
}

static Sint
tsc_literal_sparse(ac)
Sint ac;
{
  return ac ^ SWAP(0707070070707);
}

static Sint
tsc_literal_left(ac)
Sint ac;
{
  return ac ^ SWAP(0123456000000);
}

static Sint
tsc_literal_right(ac)
Sint ac;
{
  return ac ^ SWAP(0000000123456);
}

static Sint
tsc_literal_highbit(ac)
Sint ac;
{
  return ac ^ SWAP(0400000000000);
}

static Sint
tsc_literal_all(ac)
Sint ac;
{
  return ac ^ SWAP(0777777777777);
}

static void
tsc_store(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  *out = ac ^ SWAP(e);
}

static void
tsc_store_mem(out, ac, e)
Sint *out;
Sint ac;
Sint *e;
{
  *out = ac ^ SWAP(*e);
}

static Sint
tsc_store_return(out, ac, e)
Sint *out;
Sint ac;
Sint e;
{
  Sint t;

  t = ac ^ SWAP(e);
  *out = t;
  return t;
}

static Sint
tsc_store_global(ac, e)
Sint ac;
Sint e;
{
  tsc_ga = ac ^ SWAP(e);
  return tsc_ga;
}

static Sint
tsc_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac ^ SWAP(e);
  return v[i & 017];
}

static Sint
tsc_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tsc_pair *p;
{
  p->a = ac ^ SWAP(e);
  return p->a;
}

static Sint
tsc_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tsc_pair *p;
{
  p->b = ac ^ SWAP(e);
  return p->b;
}

/*
 * TSC with memory update after computing AC ^ SWAP(E).
 */

static void
tsc_update_mem(p, e)
Sint *p;
Sint e;
{
  *p = *p ^ SWAP(e);
}

static void
tsc_update_mem_mem(p, e)
Sint *p;
Sint *e;
{
  *p = *p ^ SWAP(*e);
}

static void
tsc_update_global(e)
Sint e;
{
  tsc_ga = tsc_ga ^ SWAP(e);
}

static void
tsc_update_global_mem(e)
Sint *e;
{
  tsc_ga = tsc_ga ^ SWAP(*e);
}

static void
tsc_update_array(v, i, e)
Sint *v;
Sint i;
Sint e;
{
  v[i & 017] = v[i & 017] ^ SWAP(e);
}

static void
tsc_update_global_array(i, e)
Sint i;
Sint e;
{
  tsc_buf[i & 017] = tsc_buf[i & 017] ^ SWAP(e);
}

static void
tsc_update_struct_a(p, e)
struct tsc_pair *p;
Sint e;
{
  p->a = p->a ^ SWAP(e);
}

static void
tsc_update_struct_b(p, e)
struct tsc_pair *p;
Sint e;
{
  p->b = p->b ^ SWAP(e);
}

static Sint
tsc_update_return(p, e)
Sint *p;
Sint e;
{
  *p = *p ^ SWAP(e);
  return *p;
}

static Sint
tsc_global_update_return(e)
Sint e;
{
  tsc_ga = tsc_ga ^ SWAP(e);
  return tsc_ga;
}

static void
tsc_volatile_update(p, e)
volatile Sint *p;
Sint e;
{
  *p = *p ^ SWAP(e);
}

/*
 * TSCE/TSCN pressure.  The skip test is based on the original tested
 * bits AC & SWAP(E), while the resulting AC value is AC ^ SWAP(E).
 */

static Sint
tsce_clear(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsce_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsce_global(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(tsc_ga);
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsce_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (ac & m)
    return yes + t;
  return no + t;
}

static Sint
tsce_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (ac & m)
    t += f();
  return t;
}

static Sint
tsce_likely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (likely(ac & m))
    t = 0;
  return t;
}

static Sint
tsce_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (unlikely(ac & m))
    t = 0;
  return t;
}

static Sint
tsce_literal(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0123456123456);
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsce_literal_highbit(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0400000000000);
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tsce_literal_all(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0777777777777);
  t = ac ^ m;
  if (ac & m)
    t = 0;
  return t;
}

static Sint
tscn_clear(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tscn_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tscn_global(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(tsc_ga);
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tscn_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (!(ac & m))
    return yes + t;
  return no + t;
}

static Sint
tscn_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (!(ac & m))
    t += f();
  return t;
}

static Sint
tscn_likely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (likely(!(ac & m)))
    t = 0;
  return t;
}

static Sint
tscn_unlikely(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac ^ m;
  if (unlikely(!(ac & m)))
    t = 0;
  return t;
}

static Sint
tscn_literal(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0123456123456);
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tscn_literal_highbit(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0400000000000);
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

static Sint
tscn_literal_all(ac)
Sint ac;
{
  Sint m;
  Sint t;

  m = SWAP(0777777777777);
  t = ac ^ m;
  if (!(ac & m))
    t = 0;
  return t;
}

/*
 * TSCA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-complement control flow gives the backend a useful
 * always-skip style shape.
 */

static Sint
tsca_goto(ac, e)
Sint ac;
Sint e;
{
  ac = ac ^ SWAP(e);
  goto done;
done:
  return ac;
}

static Sint
tsca_mem_goto(ac, e)
Sint ac;
Sint *e;
{
  ac = ac ^ SWAP(*e);
  goto done;
done:
  return ac;
}

static Sint
tsca_select(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac = ac ^ SWAP(e);
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
tsca_call(ac, e)
Sint ac;
Sint e;
{
  ac = ac ^ SWAP(e);
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after complementing.
 */

static Sint
tsc_chain(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac ^ SWAP(e);
  return ac ^ SWAP(fmask);
}

static Sint
tsc_mix_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ SWAP(e)) + y;
}

static Sint
tsc_mix_and(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ SWAP(e)) & y;
}

static Sint
tsc_mix_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ SWAP(e)) | y;
}

static Sint
tsc_mix_sub(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return (ac ^ SWAP(e)) - y;
}

static Sint
tsc_from_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a + b;
  return ac ^ SWAP(e);
}

static Sint
tsc_from_xor_expr(a, b, e)
Sint a;
Sint b;
Sint e;
{
  Sint ac;

  ac = a ^ b;
  return ac ^ SWAP(e);
}

static Sint
tsc_two_tests(ac, e, fmask)
Sint ac;
Sint e;
Sint fmask;
{
  ac = ac ^ SWAP(e);
  if (ac & SWAP(fmask))
    ac = ac ^ SWAP(fmask);
  return ac;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utsc_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac ^ SWAP(e);
}

static uSint
utsc_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac ^ SWAP(*e);
}

static uSint
utsc_global(ac)
uSint ac;
{
  return ac ^ SWAP(tsc_uga);
}

static uSint
utsc_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac ^ SWAP(v[i & 017]);
}

static uSint
utsc_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac ^ SWAP(tsc_ubuf[i & 017]);
}

static uSint
utsc_struct_a(ac, p)
uSint ac;
struct tsc_upair *p;
{
  return ac ^ SWAP(p->a);
}

static uSint
utsc_global_struct_a(ac)
uSint ac;
{
  return ac ^ SWAP(tsc_ugp.a);
}

static uSint
utsc_literal(ac)
uSint ac;
{
  return ac ^ SWAP(0123456123456);
}

static void
utsc_update_mem(p, e)
uSint *p;
uSint e;
{
  *p = *p ^ SWAP(e);
}

static void
utsc_update_global(e)
uSint e;
{
  tsc_uga = tsc_uga ^ SWAP(e);
}

static uSint
utsc_update_return(p, e)
uSint *p;
uSint e;
{
  *p = *p ^ SWAP(e);
  return *p;
}

static Sint
utsce_bool(ac, e)
uSint ac;
uSint e;
{
  uSint m;
  uSint t;

  m = SWAP(e);
  t = ac ^ m;
  if (ac & m)
    return t != 0;
  return 0;
}

static Sint
utscn_bool(ac, e)
uSint ac;
uSint e;
{
  uSint m;
  uSint t;

  m = SWAP(e);
  t = ac ^ m;
  if (!(ac & m))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tsc_qi(ac, e)
Sint ac;
uQint e;
{
  return ac ^ SWAP((Sint)e);
}

static Sint
tsc_hi(ac, e)
Sint ac;
uHint e;
{
  return ac ^ SWAP((Sint)e);
}

static Sint
tsc_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac ^ SWAP((Sint)*e);
}

static Sint
tsc_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac ^ SWAP((Sint)*e);
}
