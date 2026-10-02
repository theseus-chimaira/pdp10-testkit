#include "insns.h"

/*
 * TLZ instruction coverage for PDP-6/166 and KA10.
 *
 * Intended form:
 *   TLZ AC,imm18    AC <- AC & ~(imm18 << 18)
 *
 * In C this appears as:
 *   AC & LEFT_MASK_WITH_RIGHT_HALF_ALL_ONES
 *
 * So keep constants in the form:
 *   xxxxxx,,777777
 *
 * Full-word AND constants belong to AND.c/ANDI-style tests.  Right-half
 * clear constants belong to TRZ.c.
 */

static Sint tlz_ga;
static uSint tlz_uga;
static Sint tlz_buf[16];

struct tlz_pair {
  Sint a;
  Sint b;
};

static struct tlz_pair tlz_gp;

static Sint
tlz_small(ac)
Sint ac;
{
  return ac & 0123456777777;
}

static Sint
tlz_clear_one_left(ac)
Sint ac;
{
  return ac & 0777776777777;
}

static Sint
tlz_clear_highbit(ac)
Sint ac;
{
  return ac & 0377777777777;
}

static Sint
tlz_clear_all_left(ac)
Sint ac;
{
  return ac & 0000000777777;
}

static Sint
tlz_alt1(ac)
Sint ac;
{
  return ac & 0525252777777;
}

static Sint
tlz_alt2(ac)
Sint ac;
{
  return ac & 0252525777777;
}

static Sint
tlz_sparse(ac)
Sint ac;
{
  return ac & 0707070777777;
}

static Sint
tlz_sign_and_low(ac)
Sint ac;
{
  return ac & 0400001777777;
}

static Sint
tlz_max_positive_left(ac)
Sint ac;
{
  return ac & 0377777777777;
}

static Sint
tlz_from_mem(p)
Sint *p;
{
  return *p & 0123456777777;
}

static Sint
tlz_global(void)
{
  return tlz_ga & 0123456777777;
}

static Sint
tlz_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017] & 0123456777777;
}

static Sint
tlz_global_array(i)
Sint i;
{
  return tlz_buf[i & 017] & 0123456777777;
}

static Sint
tlz_struct_a(p)
struct tlz_pair *p;
{
  return p->a & 0123456777777;
}

static Sint
tlz_struct_b(p)
struct tlz_pair *p;
{
  return p->b & 0525252777777;
}

static Sint
tlz_global_struct_a(void)
{
  return tlz_gp.a & 0123456777777;
}

static Sint
tlz_global_struct_b(void)
{
  return tlz_gp.b & 0525252777777;
}

static void
tlz_store(p, ac)
Sint *p;
Sint ac;
{
  *p = ac & 0123456777777;
}

static void
tlz_store_alt(p, ac)
Sint *p;
Sint ac;
{
  *p = ac & 0525252777777;
}

static void
tlz_store_global(ac)
Sint ac;
{
  tlz_ga = ac & 0123456777777;
}

static void
tlz_update_mem(p)
Sint *p;
{
  *p = *p & 0123456777777;
}

static void
tlz_update_global(void)
{
  tlz_ga = tlz_ga & 0123456777777;
}

static void
tlz_update_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = v[i & 017] & 0123456777777;
}

static void
tlz_update_global_array(i)
Sint i;
{
  tlz_buf[i & 017] = tlz_buf[i & 017] & 0123456777777;
}

static void
tlz_update_struct_a(p)
struct tlz_pair *p;
{
  p->a = p->a & 0123456777777;
}

static void
tlz_update_struct_b(p)
struct tlz_pair *p;
{
  p->b = p->b & 0525252777777;
}

static Sint
tlz_update_return(p)
Sint *p;
{
  *p = *p & 0123456777777;
  return *p;
}

static Sint
tlz_global_update_return(void)
{
  tlz_ga = tlz_ga & 0123456777777;
  return tlz_ga;
}

static Sint
tlz_chain(ac)
Sint ac;
{
  ac = ac & 0123456777777;
  return ac & 0525252777777;
}

static Sint
tlz_chain_same(ac)
Sint ac;
{
  ac = ac & 0123456777777;
  return ac & 0123456777777;
}

static Sint
tlz_mix_add(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0123456777777) + y;
}

static Sint
tlz_mix_or(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0123456777777) | y;
}

static Sint
tlz_mix_xor(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0123456777777) ^ y;
}

static Sint
tlz_mix_sub(ac, y)
Sint ac;
Sint y;
{
  return (ac & 0123456777777) - y;
}

static uSint
utlz_small(ac)
uSint ac;
{
  return ac & 0123456777777;
}

static uSint
utlz_clear_all_left(ac)
uSint ac;
{
  return ac & 0000000777777;
}

static uSint
utlz_clear_highbit(ac)
uSint ac;
{
  return ac & 0377777777777;
}

static uSint
utlz_from_mem(p)
uSint *p;
{
  return *p & 0123456777777;
}

static void
utlz_store(p, ac)
uSint *p;
uSint ac;
{
  *p = ac & 0123456777777;
}

static void
utlz_update_mem(p)
uSint *p;
{
  *p = *p & 0123456777777;
}

static void
utlz_update_global(void)
{
  tlz_uga = tlz_uga & 0123456777777;
}

static Sint
tlz_qi_promote(a)
uQint a;
{
  return ((Sint)a) & 0123456777777;
}

static Sint
tlz_hi_promote(a)
uHint a;
{
  return ((Sint)a) & 0123456777777;
}

static void
tlz_volatile_store(p, ac)
volatile Sint *p;
Sint ac;
{
  *p = ac & 0123456777777;
}

static Sint
tlz_volatile_load(p)
volatile Sint *p;
{
  return *p & 0123456777777;
}
