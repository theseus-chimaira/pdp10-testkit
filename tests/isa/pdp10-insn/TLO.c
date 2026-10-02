#include "insns.h"

/*
 * TLO instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TLO AC,imm18    AC <- AC | (imm18 << 18)
 *
 * Keep constants in the left half with a zero right half.  Full-word
 * OR constants and memory OR belong to IOR.c/ORI-style tests.
 */

static Sint tlo_ga;
static uSint tlo_uga;
static Sint tlo_buf[16];

struct tlo_pair {
  Sint a;
  Sint b;
};

static struct tlo_pair tlo_gp;

static Sint
tlo_small(ac)
Sint ac;
{
  return ac | 0123456000000;
}

static Sint
tlo_one(ac)
Sint ac;
{
  return ac | 0000001000000;
}

static Sint
tlo_highbit(ac)
Sint ac;
{
  return ac | 0400000000000;
}

static Sint
tlo_all_left(ac)
Sint ac;
{
  return ac | 0777777000000;
}

static Sint
tlo_alt1(ac)
Sint ac;
{
  return ac | 0525252000000;
}

static Sint
tlo_alt2(ac)
Sint ac;
{
  return ac | 0252525000000;
}

static Sint
tlo_sparse(ac)
Sint ac;
{
  return ac | 0707070000000;
}

static Sint
tlo_sign_and_low(ac)
Sint ac;
{
  return ac | 0400001000000;
}

static Sint
tlo_max_positive_left(ac)
Sint ac;
{
  return ac | 0377777000000;
}

static Sint
tlo_zero(ac)
Sint ac;
{
  return ac | 0000000000000;
}

static Sint
tlo_from_mem(p)
Sint *p;
{
  return *p | 0123456000000;
}

static Sint
tlo_global(void)
{
  return tlo_ga | 0123456000000;
}

static Sint
tlo_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017] | 0123456000000;
}

static Sint
tlo_global_array(i)
Sint i;
{
  return tlo_buf[i & 017] | 0123456000000;
}

static Sint
tlo_struct_a(p)
struct tlo_pair *p;
{
  return p->a | 0123456000000;
}

static Sint
tlo_struct_b(p)
struct tlo_pair *p;
{
  return p->b | 0525252000000;
}

static Sint
tlo_global_struct_a(void)
{
  return tlo_gp.a | 0123456000000;
}

static Sint
tlo_global_struct_b(void)
{
  return tlo_gp.b | 0525252000000;
}

static void
tlo_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac | 0123456000000;
}

static void
tlo_store_alt(p, ac)
Sint *p;
Sint ac;
{
  *p = ac | 0525252000000;
}

static void
tlo_store_global(ac)
Sint ac;
{
  tlo_ga = ac | 0123456000000;
}

static void
tlo_update_mem(p)
Sint *p;
{
  *p = *p | 0123456000000;
}

static void
tlo_update_global(void)
{
  tlo_ga = tlo_ga | 0123456000000;
}

static void
tlo_update_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017] | 0123456000000;
}

static void
tlo_update_global_array(i)
Sint i;
{
  tlo_buf[i & 017] = tlo_buf[i & 017] | 0123456000000;
}

static void
tlo_update_struct_a(p)
struct tlo_pair *p;
{
  p->a = p->a | 0123456000000;
}

static void
tlo_update_struct_b(p)
struct tlo_pair *p;
{
  p->b = p->b | 0525252000000;
}

static Sint
tlo_update_return(p)
Sint *p;
{
  *p = *p | 0123456000000;
  return *p;
}

static Sint
tlo_global_update_return(void)
{
  tlo_ga = tlo_ga | 0123456000000;
  return tlo_ga;
}

static Sint
tlo_chain(ac)
Sint ac;
{
  ac = ac | 0123456000000;
  return ac | 0525252000000;
}

static Sint
tlo_chain_same(ac)
Sint ac;
{
  ac = ac | 0123456000000;
  return ac | 0123456000000;
}

static Sint
tlo_mix_add(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456000000) + y;
}

static Sint
tlo_mix_and(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456000000) & y;
}

static Sint
tlo_mix_xor(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456000000) ^ y;
}

static Sint
tlo_mix_sub(ac, y)
Sint ac;
Sint y;
{
  return (ac | 0123456000000) - y;
}

static uSint
utlo_small(ac)
uSint ac;
{
  return ac | 0123456000000;
}

static uSint
utlo_all_left(ac)
uSint ac;
{
  return ac | 0777777000000;
}

static uSint
utlo_highbit(ac)
uSint ac;
{
  return ac | 0400000000000;
}

static uSint
utlo_from_mem(p)
uSint *p;
{
  return *p | 0123456000000;
}

static void
utlo_store(p, ac)
uSint *p;
uSint ac;
{
  *p = ac | 0123456000000;
}

static void
utlo_update_mem(p)
uSint *p;
{
  *p = *p | 0123456000000;
}

static void
utlo_update_global(void)
{
  tlo_uga = tlo_uga | 0123456000000;
}

static Sint
tlo_qi_promote(a)
uQint a;
{
  return ((Sint)a) | 0123456000000;
}

static Sint
tlo_hi_promote(a)
uHint a;
{
  return ((Sint)a) | 0123456000000;
}

static void
tlo_volatile_store(p, ac)
volatile Sint *p;
Sint ac;
{
  *p = ac | 0123456000000;
}

static Sint
tlo_volatile_load(p)
volatile Sint *p;
{
  return *p | 0123456000000;
}
