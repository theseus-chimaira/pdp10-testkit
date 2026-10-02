#include "insns.h"

/*
 * MOVE instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   MOVE   AC <- memory/register
 *   MOVEI  AC <- small immediate/effective-address constant
 *   MOVEM  memory <- AC
 *   MOVES  self/memory form where the backend can expose it
 *
 * MOVS/MOVN/MOVM have their own semantic families and should not be
 * folded into this file.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint move_ga;
static Sint move_gb;
static Sint move_gc;
static uSint move_uga;
static uSint move_ugb;
static Sint move_buf[16];
static uSint move_ubuf[16];

struct move_pair {
  Sint a;
  Sint b;
};

struct move_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct move_pair move_gp;
static struct move_three move_gt;

static Sint
move_reg_reg(a, e)
Sint a;
Sint e;
{
  a = e;
  return a;
}

static uSint
umove_reg_reg(a, e)
uSint a;
uSint e;
{
  a = e;
  return a;
}

static Sint
move_mem(e)
Sint *e;
{
  return *e;
}

static uSint
umove_mem(e)
uSint *e;
{
  return *e;
}

static Sint
move_mem_plus(e, a)
Sint *e;
Sint a;
{
  return *e + a;
}

static Sint
move_mem_minus(e, a)
Sint *e;
Sint a;
{
  return *e - a;
}

static Sint
move_mem_and(e, a)
Sint *e;
Sint a;
{
  return *e & a;
}

static Sint
move_mem_or(e, a)
Sint *e;
Sint a;
{
  return *e | a;
}

static Sint
move_mem_xor(e, a)
Sint *e;
Sint a;
{
  return *e ^ a;
}

static Sint
move_volatile_mem(e)
volatile Sint *e;
{
  return *e;
}

static uSint
umove_volatile_mem(e)
volatile uSint *e;
{
  return *e;
}

static Sint
move_global_a(void)
{
  return move_ga;
}

static Sint
move_global_b(void)
{
  return move_gb;
}

static uSint
umove_global_a(void)
{
  return move_uga;
}

static Sint
move_array(v, i)
Sint *v;
Sint i;
{
  return v[i & 017];
}

static uSint
umove_array(v, i)
uSint *v;
Sint i;
{
  return v[i & 017];
}

static Sint
move_global_array(i)
Sint i;
{
  return move_buf[i & 017];
}

static uSint
umove_global_array(i)
Sint i;
{
  return move_ubuf[i & 017];
}

static Sint
move_struct_a(p)
struct move_pair *p;
{
  return p->a;
}

static Sint
move_struct_b(p)
struct move_pair *p;
{
  return p->b;
}

static Sint
move_global_struct_a(void)
{
  return move_gp.a;
}

static Sint
move_global_struct_b(void)
{
  return move_gt.b;
}

static Sint
move_indirect(pp)
Sint **pp;
{
  Sint *p;

  p = *pp;
  return *p;
}

static Sint
move_indexed_indirect(pp, i)
Sint **pp;
Sint i;
{
  Sint *p;

  p = *pp;
  return p[i & 017];
}

static Sint
movei_zero(void)
{
  return 0;
}

static Sint
movei_one(void)
{
  return 1;
}

static Sint
movei_minus_one(void)
{
  return -1;
}

static Sint
movei_small(void)
{
  return 0123456;
}

static Sint
movei_low9(void)
{
  return 0777;
}

static Sint
movei_low18(void)
{
  return 0777777;
}

static uSint
umovei_low18(void)
{
  return 0777777;
}

static Sint
movei_addr_like_a(void)
{
  return 0400;
}

static Sint
movei_addr_like_b(void)
{
  return 01234;
}

static Sint
move_large_literal(void)
{
  return 0123456123456;
}

static Sint
move_large_literal_ones(void)
{
  return 0777777777777;
}

static Sint
move_large_literal_left(void)
{
  return 0777777000000;
}

static Sint
move_large_literal_right(void)
{
  return 0000000777777;
}

static uSint
umove_large_literal(void)
{
  return 0123456123456;
}

static Sint
move_const_after_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  a = 0123456;
  return a;
}

static Sint
move_literal_after_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  a = 0123456123456;
  return a;
}

static Sint
move_reg_after_const(a)
Sint a;
{
  Sint r;

  r = 0123456;
  OPAQUE_REG(a);
  r = a;
  return r;
}

static Sint
move_select_const(a)
Sint a;
{
  if (a != 0)
    return 0123456;
  return 0123456123456;
}

static Sint
move_select_reg(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (c != 0)
    return a;
  return b;
}

static void
movem_reg_mem(a, e)
Sint a;
Sint *e;
{
  *e = a;
}

static void
umovem_reg_mem(a, e)
uSint a;
uSint *e;
{
  *e = a;
}

static Sint
movem_reg_mem_ret(a, e)
Sint a;
Sint *e;
{
  *e = a;
  return *e;
}

static Sint
movem_reg_mem_ret_arg(a, e)
Sint a;
Sint *e;
{
  *e = a;
  return a;
}

static void
movem_const(e)
Sint *e;
{
  *e = 0123456;
}

static void
movem_literal(e)
Sint *e;
{
  *e = 0123456123456;
}

static void
movem_zero(e)
Sint *e;
{
  *e = 0;
}

static void
movem_minus_one(e)
Sint *e;
{
  *e = -1;
}

static void
movem_global(a)
Sint a;
{
  move_ga = a;
}

static void
umovem_global(a)
uSint a;
{
  move_uga = a;
}

static Sint
movem_global_ret(a)
Sint a;
{
  move_gb = a;
  return move_gb;
}

static void
movem_array(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] = a;
}

static void
umovem_array(v, i, a)
uSint *v;
Sint i;
uSint a;
{
  v[i & 017] = a;
}

static Sint
movem_array_ret(v, i, a)
Sint *v;
Sint i;
Sint a;
{
  v[i & 017] = a;
  return v[i & 017];
}

static void
movem_global_array(i, a)
Sint i;
Sint a;
{
  move_buf[i & 017] = a;
}

static void
umovem_global_array(i, a)
Sint i;
uSint a;
{
  move_ubuf[i & 017] = a;
}

static void
movem_struct_a(p, a)
struct move_pair *p;
Sint a;
{
  p->a = a;
}

static void
movem_struct_b(p, a)
struct move_pair *p;
Sint a;
{
  p->b = a;
}

static Sint
movem_struct_ret(p, a)
struct move_pair *p;
Sint a;
{
  p->b = a;
  return p->b;
}

static void
movem_global_struct_a(a)
Sint a;
{
  move_gp.a = a;
}

static void
movem_global_struct_b(a)
Sint a;
{
  move_gt.b = a;
}

static void
movem_volatile(a, e)
Sint a;
volatile Sint *e;
{
  *e = a;
}

static Sint
movem_volatile_ret(a, e)
Sint a;
volatile Sint *e;
{
  *e = a;
  return *e;
}

static void
movem_indirect(pp, a)
Sint **pp;
Sint a;
{
  Sint *p;

  p = *pp;
  *p = a;
}

static void
movem_indexed_indirect(pp, i, a)
Sint **pp;
Sint i;
Sint a;
{
  Sint *p;

  p = *pp;
  p[i & 017] = a;
}

static Sint
move_store_reload(dst, src)
Sint *dst;
Sint *src;
{
  Sint a;

  a = *src;
  *dst = a;
  return *dst;
}

static Sint
move_store_reload_reg(dst, a)
Sint *dst;
Sint a;
{
  *dst = a;
  a = *dst;
  return a;
}

static Sint
move_two_loads(a, b)
Sint *a;
Sint *b;
{
  Sint x;
  Sint y;

  x = *a;
  y = *b;
  return x + y;
}

static void
move_two_stores(p, q, a, b)
Sint *p;
Sint *q;
Sint a;
Sint b;
{
  *p = a;
  *q = b;
}

static Sint
move_copy_chain(p, q, r)
Sint *p;
Sint *q;
Sint *r;
{
  Sint a;

  a = *p;
  *q = a;
  *r = a;
  return a;
}

static Sint
move_call_pressure_load(p)
Sint *p;
{
  extern void clobber(void);
  Sint a;

  a = *p;
  clobber();
  return a + *p;
}

static Sint
move_call_pressure_store(p, a)
Sint *p;
Sint a;
{
  extern void clobber(void);

  *p = a;
  clobber();
  return *p;
}

static Sint
move_loop_load(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;

  r = 0;
  for (i = 0; i < n; ++i)
    r += v[i & 017];

  return r;
}

static void
move_loop_store(v, n, a)
Sint *v;
Sint n;
Sint a;
{
  Sint i;

  for (i = 0; i < n; ++i)
    v[i & 017] = a + i;
}

static Sint
move_qi_to_sint(p)
Qint *p;
{
  return *p;
}

static uSint
move_uqi_to_usint(p)
uQint *p;
{
  return *p;
}

static Sint
move_hi_to_sint(p)
Hint *p;
{
  return *p;
}

static uSint
move_uhi_to_usint(p)
uHint *p;
{
  return *p;
}

static void
movem_sint_to_qi(p, a)
Qint *p;
Sint a;
{
  *p = (Qint)a;
}

static void
movem_usint_to_uqi(p, a)
uQint *p;
uSint a;
{
  *p = (uQint)a;
}

static void
movem_sint_to_hi(p, a)
Hint *p;
Sint a;
{
  *p = (Hint)a;
}

static void
movem_usint_to_uhi(p, a)
uHint *p;
uSint a;
{
  *p = (uHint)a;
}

/*
 * MOVES-like source shapes: load from memory, immediately write the same
 * value back, and use the value in AC.  If the backend has a useful self
 * form, these are where it tends to appear; otherwise plain MOVE/MOVEM is
 * still acceptable.
 */

static Sint
moves_mem(e)
Sint *e;
{
  Sint a;

  a = *e;
  *e = a;
  return a;
}

static uSint
umoves_mem(e)
uSint *e;
{
  uSint a;

  a = *e;
  *e = a;
  return a;
}

static Sint
moves_array(v, i)
Sint *v;
Sint i;
{
  Sint a;

  a = v[i & 017];
  v[i & 017] = a;
  return a;
}

static Sint
moves_struct(p)
struct move_pair *p;
{
  Sint a;

  a = p->b;
  p->b = a;
  return a;
}

static Sint
moves_volatile(e)
volatile Sint *e;
{
  Sint a;

  a = *e;
  *e = a;
  return a;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
move1(a, e)
Sint a;
Sint e;
{
  return e;
}

static Sint
move2(a, e)
Sint a;
Sint *e;
{
  return *e;
}

static Sint
movei(void)
{
  return 0123456;
}

static Sint
move3(void)
{
  return 0123456123456;
}

static void
movem(a, e)
Sint a;
Sint *e;
{
  *e = a;
}
