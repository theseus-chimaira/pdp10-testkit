#include "insns.h"

/*
 * TSN instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TSN AC,E     test AC against swapped E, no modification,
 *                no skip/never-skip variant
 *
 * This is the swapped/direct no-modify family companion to TDN/TDNE/etc.
 * In ordinary C, the useful shape is:
 *
 *   AC & SWAP(E)
 *
 * but the tested value is only used as a value here, not as a branch
 * condition.  Branching/nonzero skip belongs to TSNE.c.
 */

static Sint tsn_ga;
static Sint tsn_gb;
static uSint tsn_uga;
static Sint tsn_buf[16];
static uSint tsn_ubuf[16];

struct tsn_pair {
  Sint a;
  Sint b;
};

struct tsn_upair {
  uSint a;
  uSint b;
};

static struct tsn_pair tsn_gp;
static struct tsn_upair tsn_ugp;

static Sint
tsn_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return ac & SWAP(e);
}

static Sint
tsn_reg_mem(ac, e)
Sint ac;
Sint *e;
{
  return ac & SWAP(*e);
}

static Sint
tsn_mem_reg(ac, e)
Sint *ac;
Sint e;
{
  return *ac & SWAP(e);
}

static Sint
tsn_mem_mem(ac, e)
Sint *ac;
Sint *e;
{
  return *ac & SWAP(*e);
}

static Sint
tsn_global_a(ac)
Sint ac;
{
  return ac & SWAP(tsn_ga);
}

static Sint
tsn_global_b(void)
{
  return tsn_ga & SWAP(tsn_gb);
}

static Sint
tsn_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  return ac & SWAP(v[i & 017]);
}

static Sint
tsn_global_array(ac, i)
Sint ac;
Sint i;
{
  return ac & SWAP(tsn_buf[i & 017]);
}

static Sint
tsn_struct_a(ac, p)
Sint ac;
struct tsn_pair *p;
{
  return ac & SWAP(p->a);
}

static Sint
tsn_struct_b(ac, p)
Sint ac;
struct tsn_pair *p;
{
  return ac & SWAP(p->b);
}

static Sint
tsn_global_struct_a(ac)
Sint ac;
{
  return ac & SWAP(tsn_gp.a);
}

static Sint
tsn_global_struct_b(ac)
Sint ac;
{
  return ac & SWAP(tsn_gp.b);
}

static Sint
tsn_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  return ac & SWAP(**pp);
}

static Sint
tsn_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  return ac & SWAP(*e);
}

static Sint
tsn_loaded(ac, e)
Sint ac;
Sint *e;
{
  Sint t;

  t = *e;
  return ac & SWAP(t);
}

static Sint
tsn_loaded_global(ac)
Sint ac;
{
  Sint t;

  t = tsn_ga;
  return ac & SWAP(t);
}

static Sint
tsn_loaded_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  Sint t;

  t = v[i & 017];
  return ac & SWAP(t);
}

static Sint
tsn_literal_a(ac)
Sint ac;
{
  return ac & SWAP(0123456123456);
}

static Sint
tsn_literal_b(ac)
Sint ac;
{
  return ac & SWAP(0525252252525);
}

static Sint
tsn_literal_sparse(ac)
Sint ac;
{
  return ac & SWAP(0707070070707);
}

static Sint
tsn_literal_left(ac)
Sint ac;
{
  return ac & SWAP(0123456000000);
}

static Sint
tsn_literal_right(ac)
Sint ac;
{
  return ac & SWAP(0000000123456);
}

static Sint
tsn_literal_highbit(ac)
Sint ac;
{
  return ac & SWAP(0400000000000);
}

static Sint
tsn_literal_all(ac)
Sint ac;
{
  return ac & SWAP(0777777777777);
}

static Sint
tsn_commuted_reg_reg(ac, e)
Sint ac;
Sint e;
{
  return SWAP(e) & ac;
}

static Sint
tsn_commuted_mem(ac, e)
Sint ac;
Sint *e;
{
  return SWAP(*e) & ac;
}

static Sint
tsn_chain(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  return (ac & SWAP(e)) + x;
}

static Sint
tsn_chain_and(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  return (ac & SWAP(e)) & x;
}

static Sint
tsn_chain_or(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  return (ac & SWAP(e)) | x;
}

static Sint
tsn_chain_xor(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  return (ac & SWAP(e)) ^ x;
}

static Sint
tsn_store_value(ac, e, out)
Sint ac;
Sint e;
Sint *out;
{
  Sint t;

  t = ac & SWAP(e);
  *out = t;
  return t;
}

static void
tsn_store_only(ac, e, out)
Sint ac;
Sint e;
Sint *out;
{
  *out = ac & SWAP(e);
}

static Sint
tsn_store_global(ac, e)
Sint ac;
Sint e;
{
  tsn_ga = ac & SWAP(e);
  return tsn_ga;
}

static void
tsn_store_global_only(ac, e)
Sint ac;
Sint e;
{
  tsn_ga = ac & SWAP(e);
}

static Sint
tsn_store_array(ac, e, v, i)
Sint ac;
Sint e;
Sint *v;
Sint i;
{
  v[i & 017] = ac & SWAP(e);
  return v[i & 017];
}

static Sint
tsn_store_struct_a(ac, e, p)
Sint ac;
Sint e;
struct tsn_pair *p;
{
  p->a = ac & SWAP(e);
  return p->a;
}

static Sint
tsn_store_struct_b(ac, e, p)
Sint ac;
Sint e;
struct tsn_pair *p;
{
  p->b = ac & SWAP(e);
  return p->b;
}

static Sint
tsn_two_sources(ac, e, f)
Sint ac;
Sint e;
Sint f;
{
  return (ac & SWAP(e)) + (ac & SWAP(f));
}

static Sint
tsn_two_mem_sources(ac, e, f)
Sint ac;
Sint *e;
Sint *f;
{
  return (ac & SWAP(*e)) + (ac & SWAP(*f));
}

static Sint
tsn_after_add(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac += x;
  return ac & SWAP(e);
}

static Sint
tsn_after_xor(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac ^= x;
  return ac & SWAP(e);
}

static Sint
tsn_after_or(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  ac |= x;
  return ac & SWAP(e);
}

static uSint
utsn_reg_reg(ac, e)
uSint ac;
uSint e;
{
  return ac & SWAP(e);
}

static uSint
utsn_reg_mem(ac, e)
uSint ac;
uSint *e;
{
  return ac & SWAP(*e);
}

static uSint
utsn_global(ac)
uSint ac;
{
  return ac & SWAP(tsn_uga);
}

static uSint
utsn_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  return ac & SWAP(v[i & 017]);
}

static uSint
utsn_global_array(ac, i)
uSint ac;
Sint i;
{
  return ac & SWAP(tsn_ubuf[i & 017]);
}

static uSint
utsn_struct_a(ac, p)
uSint ac;
struct tsn_upair *p;
{
  return ac & SWAP(p->a);
}

static uSint
utsn_global_struct_a(ac)
uSint ac;
{
  return ac & SWAP(tsn_ugp.a);
}

static uSint
utsn_literal(ac)
uSint ac;
{
  return ac & SWAP(0123456123456);
}

static uSint
utsn_literal_right(ac)
uSint ac;
{
  return ac & SWAP(0000000123456);
}

static uSint
utsn_literal_left(ac)
uSint ac;
{
  return ac & SWAP(0123456000000);
}

static uSint
utsn_store_value(ac, e, out)
uSint ac;
uSint e;
uSint *out;
{
  uSint t;

  t = ac & SWAP(e);
  *out = t;
  return t;
}

static Sint
tsn_qi(ac, e)
Sint ac;
uQint e;
{
  return ac & SWAP((Sint)e);
}

static Sint
tsn_hi(ac, e)
Sint ac;
uHint e;
{
  return ac & SWAP((Sint)e);
}

static Sint
tsn_qi_mem(ac, e)
Sint ac;
uQint *e;
{
  return ac & SWAP((Sint)*e);
}

static Sint
tsn_hi_mem(ac, e)
Sint ac;
uHint *e;
{
  return ac & SWAP((Sint)*e);
}

static Sint
tsn_signed_qi(ac, e)
Sint ac;
sQint e;
{
  return ac & SWAP((Sint)e);
}

static Sint
tsn_signed_hi(ac, e)
Sint ac;
Hint e;
{
  return ac & SWAP((Sint)e);
}
