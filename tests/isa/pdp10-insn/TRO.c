#include "insns.h"

/*
 * TRO instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TRO   AC,imm18    AC <- AC | imm18
 *   TROE  AC,imm18    AC <- AC | imm18; skip if tested bits are nonzero
 *   TROA  AC,imm18    AC <- AC | imm18; always skip
 *   TRON  AC,imm18    AC <- AC | imm18; skip if tested bits are zero
 *
 * Keep masks strictly in the right half:
 *   000000,,xxxxxx
 *
 * Left-half immediate OR belongs to TLO.c.  Full-word OR belongs to
 * IOR.c/ORI-style tests.  Full-word/direct test-and-ones belongs to
 * TDO.c.
 */

extern Sint f(void);

static Sint tro_ga;
static uSint tro_uga;
static Sint tro_buf[16];

struct tro_pair {
  Sint a;
  Sint b;
};

static struct tro_pair tro_gp;

/*
 * Plain TRO pressure.
 */

static Sint
tro_small(ac)
Sint ac;
{
  return ac | 0123456;
}

static Sint
tro_one(ac)
Sint ac;
{
  return ac | 0000001;
}

static Sint
tro_highbit(ac)
Sint ac;
{
  return ac | 0400000;
}

static Sint
tro_all_right(ac)
Sint ac;
{
  return ac | 0777777;
}

static Sint
tro_alt1(ac)
Sint ac;
{
  return ac | 0525252;
}

static Sint
tro_alt2(ac)
Sint ac;
{
  return ac | 0252525;
}

static Sint
tro_sparse(ac)
Sint ac;
{
  return ac | 0707070;
}

static Sint
tro_sign_low(ac)
Sint ac;
{
  return ac | 0400001;
}

static Sint
tro_maxpos(ac)
Sint ac;
{
  return ac | 0377777;
}

static Sint
tro_from_mem(p)
Sint *p;
{
  return *p | 0123456;
}

static Sint
tro_global(void)
{
  return tro_ga | 0123456;
}

static Sint
tro_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017] | 0123456;
}

static Sint
tro_global_array(i)
Sint i;
{
  return tro_buf[i & 017] | 0123456;
}

static Sint
tro_struct_a(p)
struct tro_pair *p;
{
  return p->a | 0123456;
}

static Sint
tro_struct_b(p)
struct tro_pair *p;
{
  return p->b | 0525252;
}

static Sint
tro_global_struct_a(void)
{
  return tro_gp.a | 0123456;
}

static Sint
tro_global_struct_b(void)
{
  return tro_gp.b | 0525252;
}

static Sint
tro_indirect(pp)
Sint **pp;
{
  return **pp | 0123456;
}

static Sint
tro_volatile_load(p)
volatile Sint *p;
{
  return *p | 0123456;
}

static void
tro_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac | 0123456;
}

static void
tro_store_alt(p, ac)
Sint *p;
Sint ac;
{
  *p = ac | 0525252;
}

static void
tro_store_global(ac)
Sint ac;
{
  tro_ga = ac | 0123456;
}

static void
tro_update_mem(p)
Sint *p;
{
  *p = *p | 0123456;
}

static void
tro_update_global(void)
{
  tro_ga = tro_ga | 0123456;
}

static void
tro_update_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017] | 0123456;
}

static void
tro_update_global_array(i)
Sint i;
{
  tro_buf[i & 017] = tro_buf[i & 017] | 0123456;
}

static void
tro_update_struct_a(p)
struct tro_pair *p;
{
  p->a = p->a | 0123456;
}

static void
tro_update_struct_b(p)
struct tro_pair *p;
{
  p->b = p->b | 0525252;
}

static Sint
tro_update_return(p)
Sint *p;
{
  *p = *p | 0123456;
  return *p;
}

static Sint
tro_global_update_return(void)
{
  tro_ga = tro_ga | 0123456;
  return tro_ga;
}

static void
tro_volatile_store(p, ac)
volatile Sint *p;
Sint ac;
{
  *p = ac | 0123456;
}

static void
tro_volatile_update(p)
volatile Sint *p;
{
  *p = *p | 0123456;
}

/*
 * TROE/TRON pressure.  The skip test is based on the original tested
 * right-half bits, while the resulting AC value is AC | imm18.
 */

static Sint
troe_clear(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (ac & 0123456)
    t = 0;
  return t;
}

static Sint
troe_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac | 0123456;
  if (ac & 0123456)
    return yes + t;
  return no + t;
}

static Sint
troe_call(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (ac & 0123456)
    t += f();
  return t;
}

static Sint
troe_likely(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (likely(ac & 0123456))
    t = 0;
  return t;
}

static Sint
troe_unlikely(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (unlikely(ac & 0123456))
    t = 0;
  return t;
}

static Sint
troe_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac | 0400000;
  if (ac & 0400000)
    t = 0;
  return t;
}

static Sint
troe_all(ac)
Sint ac;
{
  Sint t;

  t = ac | 0777777;
  if (ac & 0777777)
    t = 0;
  return t;
}

static Sint
troe_alt(ac)
Sint ac;
{
  Sint t;

  t = ac | 0525252;
  if (ac & 0525252)
    t = 0;
  return t;
}

static Sint
tron_clear(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (!(ac & 0123456))
    t = 0;
  return t;
}

static Sint
tron_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac | 0123456;
  if (!(ac & 0123456))
    return yes + t;
  return no + t;
}

static Sint
tron_call(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (!(ac & 0123456))
    t += f();
  return t;
}

static Sint
tron_likely(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (likely(!(ac & 0123456)))
    t = 0;
  return t;
}

static Sint
tron_unlikely(ac)
Sint ac;
{
  Sint t;

  t = ac | 0123456;
  if (unlikely(!(ac & 0123456)))
    t = 0;
  return t;
}

static Sint
tron_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac | 0400000;
  if (!(ac & 0400000))
    t = 0;
  return t;
}

static Sint
tron_all(ac)
Sint ac;
{
  Sint t;

  t = ac | 0777777;
  if (!(ac & 0777777))
    t = 0;
  return t;
}

static Sint
tron_alt(ac)
Sint ac;
{
  Sint t;

  t = ac | 0525252;
  if (!(ac & 0525252))
    t = 0;
  return t;
}

/*
 * TROA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-OR control flow gives the backend a useful
 * always-skip shape.
 */

static Sint
troa_goto(ac)
Sint ac;
{
  ac = ac | 0123456;
  goto done;
done:
  return ac;
}

static Sint
troa_select(ac, x)
Sint ac;
Sint x;
{
  ac = ac | 0123456;
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
troa_call(ac)
Sint ac;
{
  ac = ac | 0123456;
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after setting bits.
 */

static Sint
tro_chain(ac)
Sint ac;
{
  ac = ac | 0123456;
  return ac | 0525252;
}

static Sint
tro_chain_same(ac)
Sint ac;
{
  ac = ac | 0123456;
  return ac | 0123456;
}

static Sint
tro_mix_add(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456) + y;
}

static Sint
tro_mix_and(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456) & y;
}

static Sint
tro_mix_xor(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456) ^ y;
}

static Sint
tro_mix_sub(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456) - y;
}

static Sint
tro_two_tests(ac)
Sint ac;
{
  ac = ac | 0123456;
  if (ac & 0525252)
    ac = ac | 0525252;
  return ac;
}

static Sint
tro_from_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a + b;
  return ac | 0123456;
}

static Sint
tro_from_xor_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a ^ b;
  return ac | 0123456;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utro_small(ac)
uSint ac;
{
  return ac | 0123456;
}

static uSint
utro_highbit(ac)
uSint ac;
{
  return ac | 0400000;
}

static uSint
utro_all_right(ac)
uSint ac;
{
  return ac | 0777777;
}

static uSint
utro_from_mem(p)
uSint *p;
{
  return *p | 0123456;
}

static void
utro_store(p, ac)
uSint *p;
uSint ac;
{
  *p = ac | 0123456;
}

static void
utro_update_mem(p)
uSint *p;
{
  *p = *p | 0123456;
}

static void
utro_update_global(void)
{
  tro_uga = tro_uga | 0123456;
}

static uSint
utro_update_return(p)
uSint *p;
{
  *p = *p | 0123456;
  return *p;
}

static Sint
utroe_bool(ac)
uSint ac;
{
  uSint t;

  t = ac | 0123456;
  if (ac & 0123456)
    return t != 0;
  return 0;
}

static Sint
utron_bool(ac)
uSint ac;
{
  uSint t;

  t = ac | 0123456;
  if (!(ac & 0123456))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
tro_qi_promote(a)
uQint a;
{
  return ((Sint)a) | 0123456;
}

static Sint
tro_hi_promote(a)
uHint a;
{
  return ((Sint)a) | 0123456;
}
