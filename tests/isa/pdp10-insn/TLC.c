#include "insns.h"

/*
 * TLC instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TLC AC,imm18    AC <- AC ^ (imm18 << 18)
 *
 * Keep constants in the left half with a zero right half.  Full-word
 * XOR constants and memory XOR belong to XOR.c/XORI-style tests.
 */

static Sint tlc_ga;
static uSint tlc_uga;
static Sint tlc_buf[16];

struct tlc_pair {
  Sint a;
  Sint b;
};

static struct tlc_pair tlc_gp;

static Sint
tlc_small(ac)
Sint ac;
{
  return ac ^ 0123456000000;
}

static Sint
tlc_one(ac)
Sint ac;
{
  return ac ^ 0000001000000;
}

static Sint
tlc_lowbit(ac)
Sint ac;
{
  return ac ^ 0000001000000;
}

static Sint
tlc_highbit(ac)
Sint ac;
{
  return ac ^ 0400000000000;
}

static Sint
tlc_all_left(ac)
Sint ac;
{
  return ac ^ 0777777000000;
}

static Sint
tlc_alt1(ac)
Sint ac;
{
  return ac ^ 0525252000000;
}

static Sint
tlc_alt2(ac)
Sint ac;
{
  return ac ^ 0252525000000;
}

static Sint
tlc_sparse(ac)
Sint ac;
{
  return ac ^ 0707070000000;
}

static Sint
tlc_sign_and_low(ac)
Sint ac;
{
  return ac ^ 0400001000000;
}

static Sint
tlc_max_positive_left(ac)
Sint ac;
{
  return ac ^ 0377777000000;
}

static Sint
tlc_zero(ac)
Sint ac;
{
  return ac ^ 0000000000000;
}

static Sint
tlc_from_mem(p)
Sint *p;
{
  return *p ^ 0123456000000;
}

static Sint
tlc_global(void)
{
  return tlc_ga ^ 0123456000000;
}

static Sint
tlc_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017] ^ 0123456000000;
}

static Sint
tlc_global_array(i)
Sint i;
{
  return tlc_buf[i & 017] ^ 0123456000000;
}

static Sint
tlc_struct_a(p)
struct tlc_pair *p;
{
  return p->a ^ 0123456000000;
}

static Sint
tlc_struct_b(p)
struct tlc_pair *p;
{
  return p->b ^ 0525252000000;
}

static Sint
tlc_global_struct_a(void)
{
  return tlc_gp.a ^ 0123456000000;
}

static Sint
tlc_global_struct_b(void)
{
  return tlc_gp.b ^ 0525252000000;
}

static void
tlc_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac ^ 0123456000000;
}

static void
tlc_store_alt(p, ac)
Sint *p;
Sint ac;
{
  *p = ac ^ 0525252000000;
}

static void
tlc_store_global(ac)
Sint ac;
{
  tlc_ga = ac ^ 0123456000000;
}

static void
tlc_update_mem(p)
Sint *p;
{
  *p = *p ^ 0123456000000;
}

static void
tlc_update_global(void)
{
  tlc_ga = tlc_ga ^ 0123456000000;
}

static void
tlc_update_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017] ^ 0123456000000;
}

static void
tlc_update_global_array(i)
Sint i;
{
  tlc_buf[i & 017] = tlc_buf[i & 017] ^ 0123456000000;
}

static void
tlc_update_struct_a(p)
struct tlc_pair *p;
{
  p->a = p->a ^ 0123456000000;
}

static void
tlc_update_struct_b(p)
struct tlc_pair *p;
{
  p->b = p->b ^ 0525252000000;
}

static Sint
tlc_update_return(p)
Sint *p;
{
  *p = *p ^ 0123456000000;
  return *p;
}

static Sint
tlc_global_update_return(void)
{
  tlc_ga = tlc_ga ^ 0123456000000;
  return tlc_ga;
}

static Sint
tlc_chain(ac)
Sint ac;
{
  ac = ac ^ 0123456000000;
  return ac ^ 0525252000000;
}

static Sint
tlc_chain_same(ac)
Sint ac;
{
  ac = ac ^ 0123456000000;
  return ac ^ 0123456000000;
}

static Sint
tlc_mix_add(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456000000) + y;
}

static Sint
tlc_mix_and(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456000000) & y;
}

static Sint
tlc_mix_or(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456000000) | y;
}

static Sint
tlc_mix_xor(ac, y)
Sint ac;
Sint y;
{
  return (ac ^ 0123456000000) ^ y;
}

static uSint
utlc_small(ac)
uSint ac;
{
  return ac ^ 0123456000000;
}

static uSint
utlc_all_left(ac)
uSint ac;
{
  return ac ^ 0777777000000;
}

static uSint
utlc_highbit(ac)
uSint ac;
{
  return ac ^ 0400000000000;
}

static uSint
utlc_from_mem(p)
uSint *p;
{
  return *p ^ 0123456000000;
}

static void
utlc_store(p, ac)
uSint *p;
uSint ac;
{
  *p = ac ^ 0123456000000;
}

static void
utlc_update_mem(p)
uSint *p;
{
  *p = *p ^ 0123456000000;
}

static void
utlc_update_global(void)
{
  tlc_uga = tlc_uga ^ 0123456000000;
}

static Sint
tlc_qi_promote(a)
uQint a;
{
  return ((Sint)a) ^ 0123456000000;
}

static Sint
tlc_hi_promote(a)
uHint a;
{
  return ((Sint)a) ^ 0123456000000;
}

static void
tlc_volatile_store(p, ac)
volatile Sint *p;
Sint ac;
{
  *p = ac ^ 0123456000000;
}

static Sint
tlc_volatile_load(p)
volatile Sint *p;
{
  return *p ^ 0123456000000;
}
