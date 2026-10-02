#include "insns.h"

/*
 * TRZ instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TRZ   AC,imm18    AC <- AC & ~imm18
 *   TRZE  AC,imm18    AC <- AC & ~imm18; skip if tested bits are nonzero
 *   TRZA  AC,imm18    AC <- AC & ~imm18; always skip
 *   TRZN  AC,imm18    AC <- AC & ~imm18; skip if tested bits are zero
 *
 * Keep masks strictly in the right half:
 *   000000,,xxxxxx
 *
 * In C this appears as:
 *   AC & 777777,,yyyyyy
 *
 * where yyyyyy is the right-half complement of the bits being cleared.
 * Left-half clearing belongs to TLZ.c; full-word memory/direct tests
 * belong to TDZ-style files.
 */

extern Sint f(void);

static Sint trz_ga;
static uSint trz_uga;
static Sint trz_buf[16];

struct trz_pair {
  Sint a;
  Sint b;
};

static struct trz_pair trz_gp;

/*
 * Plain TRZ pressure.
 */

static Sint
trz_small(ac)
Sint ac;
{
  return ac & 0777777654321;
}

static Sint
trz_one(ac)
Sint ac;
{
  return ac & 0777777777776;
}

static Sint
trz_lowbit(ac)
Sint ac;
{
  return ac & 0777777777776;
}

static Sint
trz_highbit(ac)
Sint ac;
{
  return ac & 0777777377777;
}

static Sint
trz_all_right(ac)
Sint ac;
{
  return ac & 0777777000000;
}

static Sint
trz_alt1(ac)
Sint ac;
{
  return ac & 0777777252525;
}

static Sint
trz_alt2(ac)
Sint ac;
{
  return ac & 0777777525252;
}

static Sint
trz_sparse(ac)
Sint ac;
{
  return ac & 0777777070707;
}

static Sint
trz_sign_low(ac)
Sint ac;
{
  return ac & 0777777377776;
}

static Sint
trz_maxpos(ac)
Sint ac;
{
  return ac & 0777777400000;
}

static Sint
trz_from_mem(p)
Sint *p;
{
  return *p & 0777777654321;
}

static Sint
trz_global(void)
{
  return trz_ga & 0777777654321;
}

static Sint
trz_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017] & 0777777654321;
}

static Sint
trz_global_array(i)
Sint i;
{
  return trz_buf[i & 017] & 0777777654321;
}

static Sint
trz_struct_a(p)
struct trz_pair *p;
{
  return p->a & 0777777654321;
}

static Sint
trz_struct_b(p)
struct trz_pair *p;
{
  return p->b & 0777777252525;
}

static Sint
trz_global_struct_a(void)
{
  return trz_gp.a & 0777777654321;
}

static Sint
trz_global_struct_b(void)
{
  return trz_gp.b & 0777777252525;
}

static Sint
trz_indirect(pp)
Sint **pp;
{
  return **pp & 0777777654321;
}

static Sint
trz_volatile_load(p)
volatile Sint *p;
{
  return *p & 0777777654321;
}

static void
trz_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac & 0777777654321;
}

static void
trz_store_alt(p, ac)
Sint *p;
Sint ac;
{
  *p = ac & 0777777252525;
}

static void
trz_store_global(ac)
Sint ac;
{
  trz_ga = ac & 0777777654321;
}

static void
trz_update_mem(p)
Sint *p;
{
  *p = *p & 0777777654321;
}

static void
trz_update_global(void)
{
  trz_ga = trz_ga & 0777777654321;
}

static void
trz_update_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017] & 0777777654321;
}

static void
trz_update_global_array(i)
Sint i;
{
  trz_buf[i & 017] = trz_buf[i & 017] & 0777777654321;
}

static void
trz_update_struct_a(p)
struct trz_pair *p;
{
  p->a = p->a & 0777777654321;
}

static void
trz_update_struct_b(p)
struct trz_pair *p;
{
  p->b = p->b & 0777777252525;
}

static Sint
trz_update_return(p)
Sint *p;
{
  *p = *p & 0777777654321;
  return *p;
}

static Sint
trz_global_update_return(void)
{
  trz_ga = trz_ga & 0777777654321;
  return trz_ga;
}

static void
trz_volatile_store(p, ac)
volatile Sint *p;
Sint ac;
{
  *p = ac & 0777777654321;
}

static void
trz_volatile_update(p)
volatile Sint *p;
{
  *p = *p & 0777777654321;
}

/*
 * TRZE/TRZN pressure.  The skip condition is based on the bits being
 * tested, while the AC value is still cleared.
 */

static Sint
trze_clear(ac)
Sint ac;
{
  if (ac & 0123456)
    ac = 0;
  return ac & 0777777654321;
}

static Sint
trze_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & 0777777654321;
  if (ac & 0123456)
    return yes + t;
  return no + t;
}

static Sint
trze_call(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777654321;
  if (ac & 0123456)
    t += f();
  return t;
}

static Sint
trze_likely(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777654321;
  if (likely(ac & 0123456))
    t = 0;
  return t;
}

static Sint
trze_unlikely(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777654321;
  if (unlikely(ac & 0123456))
    t = 0;
  return t;
}

static Sint
trze_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777377777;
  if (ac & 0400000)
    t = 0;
  return t;
}

static Sint
trze_all(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777000000;
  if (ac & 0777777)
    t = 0;
  return t;
}

static Sint
trzn_clear(ac)
Sint ac;
{
  if (!(ac & 0123456))
    ac = 0;
  return ac & 0777777654321;
}

static Sint
trzn_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & 0777777654321;
  if (!(ac & 0123456))
    return yes + t;
  return no + t;
}

static Sint
trzn_call(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777654321;
  if (!(ac & 0123456))
    t += f();
  return t;
}

static Sint
trzn_likely(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777654321;
  if (likely(!(ac & 0123456)))
    t = 0;
  return t;
}

static Sint
trzn_unlikely(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777654321;
  if (unlikely(!(ac & 0123456)))
    t = 0;
  return t;
}

static Sint
trzn_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777377777;
  if (!(ac & 0400000))
    t = 0;
  return t;
}

static Sint
trzn_all(ac)
Sint ac;
{
  Sint t;

  t = ac & 0777777000000;
  if (!(ac & 0777777))
    t = 0;
  return t;
}

/*
 * TRZA pressure.  Plain C has no skip instruction, but unconditional
 * post-clear control flow gives the backend a shape where TRZA is useful.
 */

static Sint
trza_goto(ac)
Sint ac;
{
  ac = ac & 0777777654321;
  goto done;
done:
  return ac;
}

static Sint
trza_select(ac, x)
Sint ac;
Sint x;
{
  ac = ac & 0777777654321;
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
trza_call(ac)
Sint ac;
{
  ac = ac & 0777777654321;
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after clearing.
 */

static Sint
trz_chain(ac)
Sint ac;
{
  ac = ac & 0777777654321;
  return ac & 0777777252525;
}

static Sint
trz_chain_same(ac)
Sint ac;
{
  ac = ac & 0777777654321;
  return ac & 0777777654321;
}

static Sint
trz_mix_add(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0777777654321) + y;
}

static Sint
trz_mix_or(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0777777654321) | y;
}

static Sint
trz_mix_xor(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0777777654321) ^ y;
}

static Sint
trz_mix_sub(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0777777654321) - y;
}

static Sint
trz_two_tests(ac)
Sint ac;
{
  ac = ac & 0777777654321;
  if (ac & 0525252)
    ac = ac & 0777777252525;
  return ac;
}

static Sint
trz_from_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a + b;
  return ac & 0777777654321;
}

static Sint
trz_from_xor_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a ^ b;
  return ac & 0777777654321;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utrz_small(ac)
uSint ac;
{
  return ac & 0777777654321;
}

static uSint
utrz_highbit(ac)
uSint ac;
{
  return ac & 0777777377777;
}

static uSint
utrz_all_right(ac)
uSint ac;
{
  return ac & 0777777000000;
}

static uSint
utrz_from_mem(p)
uSint *p;
{
  return *p & 0777777654321;
}

static void
utrz_store(p, ac)
uSint *p;
uSint ac;
{
  *p = ac & 0777777654321;
}

static void
utrz_update_mem(p)
uSint *p;
{
  *p = *p & 0777777654321;
}

static void
utrz_update_global(void)
{
  trz_uga = trz_uga & 0777777654321;
}

static Sint
utrze_bool(ac)
uSint ac;
{
  uSint t;

  t = ac & 0777777654321;
  if (ac & 0123456)
    return t != 0;
  return 0;
}

static Sint
utrzn_bool(ac)
uSint ac;
{
  uSint t;

  t = ac & 0777777654321;
  if (!(ac & 0123456))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
trz_qi_promote(a)
uQint a;
{
  return ((Sint)a) & 0777777654321;
}

static Sint
trz_hi_promote(a)
uHint a;
{
  return ((Sint)a) & 0777777654321;
}
