#include "insns.h"

/*
 * TRC instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   TRC   AC,imm18    AC <- AC ^ imm18
 *   TRCE  AC,imm18    AC <- AC ^ imm18; skip if tested bits are nonzero
 *   TRCA  AC,imm18    AC <- AC ^ imm18; always skip
 *   TRCN  AC,imm18    AC <- AC ^ imm18; skip if tested bits are zero
 *
 * Keep masks strictly in the right half:
 *   000000,,xxxxxx
 *
 * Left-half immediate complement belongs to TLC.c.  Full-word XOR belongs
 * to XOR.c.  Full-word/direct test-and-complement belongs to TDC.c.
 */

extern Sint f(void);

static Sint trc_ga;
static uSint trc_uga;
static Sint trc_buf[16];

struct trc_pair {
  Sint a;
  Sint b;
};

static struct trc_pair trc_gp;

/*
 * Plain TRC pressure.
 */

static Sint
trc_small(ac)
Sint ac;
{
  return ac ^ 0123456;
}

static Sint
trc_one(ac)
Sint ac;
{
  return ac ^ 0000001;
}

static Sint
trc_highbit(ac)
Sint ac;
{
  return ac ^ 0400000;
}

static Sint
trc_all_right(ac)
Sint ac;
{
  return ac ^ 0777777;
}

static Sint
trc_alt1(ac)
Sint ac;
{
  return ac ^ 0525252;
}

static Sint
trc_alt2(ac)
Sint ac;
{
  return ac ^ 0252525;
}

static Sint
trc_sparse(ac)
Sint ac;
{
  return ac ^ 0707070;
}

static Sint
trc_sign_low(ac)
Sint ac;
{
  return ac ^ 0400001;
}

static Sint
trc_maxpos(ac)
Sint ac;
{
  return ac ^ 0377777;
}

static Sint
trc_from_mem(p)
Sint *p;
{
  return *p ^ 0123456;
}

static Sint
trc_global(void)
{
  return trc_ga ^ 0123456;
}

static Sint
trc_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017] ^ 0123456;
}

static Sint
trc_global_array(i)
Sint i;
{
  return trc_buf[i & 017] ^ 0123456;
}

static Sint
trc_struct_a(p)
struct trc_pair *p;
{
  return p->a ^ 0123456;
}

static Sint
trc_struct_b(p)
struct trc_pair *p;
{
  return p->b ^ 0525252;
}

static Sint
trc_global_struct_a(void)
{
  return trc_gp.a ^ 0123456;
}

static Sint
trc_global_struct_b(void)
{
  return trc_gp.b ^ 0525252;
}

static Sint
trc_indirect(pp)
Sint **pp;
{
  return **pp ^ 0123456;
}

static Sint
trc_volatile_load(p)
volatile Sint *p;
{
  return *p ^ 0123456;
}

static void
trc_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac ^ 0123456;
}

static void
trc_store_alt(p, ac)
Sint *p;
Sint ac;
{
  *p = ac ^ 0525252;
}

static void
trc_store_global(ac)
Sint ac;
{
  trc_ga = ac ^ 0123456;
}

static void
trc_update_mem(p)
Sint *p;
{
  *p = *p ^ 0123456;
}

static void
trc_update_global(void)
{
  trc_ga = trc_ga ^ 0123456;
}

static void
trc_update_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017] ^ 0123456;
}

static void
trc_update_global_array(i)
Sint i;
{
  trc_buf[i & 017] = trc_buf[i & 017] ^ 0123456;
}

static void
trc_update_struct_a(p)
struct trc_pair *p;
{
  p->a = p->a ^ 0123456;
}

static void
trc_update_struct_b(p)
struct trc_pair *p;
{
  p->b = p->b ^ 0525252;
}

static Sint
trc_update_return(p)
Sint *p;
{
  *p = *p ^ 0123456;
  return *p;
}

static Sint
trc_global_update_return(void)
{
  trc_ga = trc_ga ^ 0123456;
  return trc_ga;
}

static void
trc_volatile_store(p, ac)
volatile Sint *p;
Sint ac;
{
  *p = ac ^ 0123456;
}

static void
trc_volatile_update(p)
volatile Sint *p;
{
  *p = *p ^ 0123456;
}

/*
 * TRCE/TRCN pressure.  The skip test is based on the original tested
 * right-half bits, while the resulting AC value is AC ^ imm18.
 */

static Sint
trce_clear(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (ac & 0123456)
    t = 0;
  return t;
}

static Sint
trce_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac ^ 0123456;
  if (ac & 0123456)
    return yes + t;
  return no + t;
}

static Sint
trce_call(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (ac & 0123456)
    t += f();
  return t;
}

static Sint
trce_likely(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (likely(ac & 0123456))
    t = 0;
  return t;
}

static Sint
trce_unlikely(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (unlikely(ac & 0123456))
    t = 0;
  return t;
}

static Sint
trce_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0400000;
  if (ac & 0400000)
    t = 0;
  return t;
}

static Sint
trce_all(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0777777;
  if (ac & 0777777)
    t = 0;
  return t;
}

static Sint
trce_alt(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0525252;
  if (ac & 0525252)
    t = 0;
  return t;
}

static Sint
trcn_clear(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (!(ac & 0123456))
    t = 0;
  return t;
}

static Sint
trcn_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac ^ 0123456;
  if (!(ac & 0123456))
    return yes + t;
  return no + t;
}

static Sint
trcn_call(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (!(ac & 0123456))
    t += f();
  return t;
}

static Sint
trcn_likely(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (likely(!(ac & 0123456)))
    t = 0;
  return t;
}

static Sint
trcn_unlikely(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0123456;
  if (unlikely(!(ac & 0123456)))
    t = 0;
  return t;
}

static Sint
trcn_highbit(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0400000;
  if (!(ac & 0400000))
    t = 0;
  return t;
}

static Sint
trcn_all(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0777777;
  if (!(ac & 0777777))
    t = 0;
  return t;
}

static Sint
trcn_alt(ac)
Sint ac;
{
  Sint t;

  t = ac ^ 0525252;
  if (!(ac & 0525252))
    t = 0;
  return t;
}

/*
 * TRCA pressure.  Plain C has no explicit skip instruction, but
 * unconditional post-complement control flow gives the backend a useful
 * always-skip shape.
 */

static Sint
trca_goto(ac)
Sint ac;
{
  ac = ac ^ 0123456;
  goto done;
done:
  return ac;
}

static Sint
trca_select(ac, x)
Sint ac;
Sint x;
{
  ac = ac ^ 0123456;
  if (x)
    goto done;
  goto done;
done:
  return ac;
}

static Sint
trca_call(ac)
Sint ac;
{
  ac = ac ^ 0123456;
  goto done;
done:
  return ac + f();
}

/*
 * Mixed use after complementing.
 */

static Sint
trc_chain(ac)
Sint ac;
{
  ac = ac ^ 0123456;
  return ac ^ 0525252;
}

static Sint
trc_chain_same(ac)
Sint ac;
{
  ac = ac ^ 0123456;
  return ac ^ 0123456;
}

static Sint
trc_mix_add(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456) + y;
}

static Sint
trc_mix_and(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456) & y;
}

static Sint
trc_mix_or(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456) | y;
}

static Sint
trc_mix_sub(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456) - y;
}

static Sint
trc_two_tests(ac)
Sint ac;
{
  ac = ac ^ 0123456;
  if (ac & 0525252)
    ac = ac ^ 0525252;
  return ac;
}

static Sint
trc_from_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a + b;
  return ac ^ 0123456;
}

static Sint
trc_from_xor_expr(a, b)
Sint a;
Sint b;
{
  Sint ac;

  ac = a ^ b;
  return ac ^ 0123456;
}

/*
 * Unsigned variants.  Same machine instruction, but signedness must not
 * block recognition.
 */

static uSint
utrc_small(ac)
uSint ac;
{
  return ac ^ 0123456;
}

static uSint
utrc_highbit(ac)
uSint ac;
{
  return ac ^ 0400000;
}

static uSint
utrc_all_right(ac)
uSint ac;
{
  return ac ^ 0777777;
}

static uSint
utrc_from_mem(p)
uSint *p;
{
  return *p ^ 0123456;
}

static void
utrc_store(p, ac)
uSint *p;
uSint ac;
{
  *p = ac ^ 0123456;
}

static void
utrc_update_mem(p)
uSint *p;
{
  *p = *p ^ 0123456;
}

static void
utrc_update_global(void)
{
  trc_uga = trc_uga ^ 0123456;
}

static uSint
utrc_update_return(p)
uSint *p;
{
  *p = *p ^ 0123456;
  return *p;
}

static Sint
utrce_bool(ac)
uSint ac;
{
  uSint t;

  t = ac ^ 0123456;
  if (ac & 0123456)
    return t != 0;
  return 0;
}

static Sint
utrcn_bool(ac)
uSint ac;
{
  uSint t;

  t = ac ^ 0123456;
  if (!(ac & 0123456))
    return t != 0;
  return 0;
}

/*
 * Promoted small-type values.  These are secondary pressure only.
 */

static Sint
trc_qi_promote(a)
uQint a;
{
  return ((Sint)a) ^ 0123456;
}

static Sint
trc_hi_promote(a)
uHint a;
{
  return ((Sint)a) ^ 0123456;
}
