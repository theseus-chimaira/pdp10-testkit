#include "insns.h"

/*
 * movsi pattern coverage for PDP-6/166 and KA10.
 *
 * This is SImode move coverage, not the full MOVE instruction-family
 * test.  Keep it centered on:
 *
 *   reg = reg
 *   reg = mem
 *   mem = reg
 *   mem = mem through a temporary
 *   small right-half constants       MOVEI-style
 *   left-half constants              MOVSI-style
 *   negative right-half constants    HRROI-style
 *   left-half plus all-right-ones    HRLOI-style
 *   large literals                   literal/load path
 *   globals, arrays, structs, volatile
 *   values live across calls
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern void sink_int();
extern void sink_sint();

static Sint movsi_g0;
static Sint movsi_g1;
static Sint movsi_g2;

static uSint movsi_ug0;
static uSint movsi_ug1;

static volatile Sint movsi_vg0;
static volatile Sint movsi_vg1;

static Sint movsi_buf[16];
static uSint movsi_ubuf[16];

struct movsi_pair {
  Sint a;
  Sint b;
};

struct movsi_upair {
  uSint a;
  uSint b;
};

static struct movsi_pair movsi_gp;
static struct movsi_upair movsi_ugp;

static Sint
move_reg(a)
Sint a;
{
  OPAQUE_REG(a);
  return a;
}

static Sint
move_reg_second(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return e;
}

static uSint
umove_reg(a)
uSint a;
{
  OPAQUE_REG(a);
  return a;
}

static uSint
umove_reg_second(a, e)
uSint a;
uSint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return e;
}

static Sint
move_mem(p)
Sint *p;
{
  return *p;
}

static Sint
move_mem_offset(p)
Sint *p;
{
  return p[1];
}

static Sint
move_mem_index(p, i)
Sint *p;
Sint i;
{
  return p[i & 017];
}

static uSint
umove_mem(p)
uSint *p;
{
  return *p;
}

static uSint
umove_mem_index(p, i)
uSint *p;
Sint i;
{
  return p[i & 017];
}

static Sint
move_volatile_mem(p)
volatile Sint *p;
{
  return *p;
}

static Sint
move_volatile_mem_offset(p)
volatile Sint *p;
{
  return p[1];
}

static Sint
move_global(void)
{
  return movsi_g0;
}

static Sint
move_global_1(void)
{
  return movsi_g1;
}

static uSint
umove_global(void)
{
  return movsi_ug0;
}

static Sint
move_vglobal(void)
{
  return movsi_vg0;
}

static Sint
move_array(i)
Sint i;
{
  return movsi_buf[i & 017];
}

static uSint
umove_array(i)
Sint i;
{
  return movsi_ubuf[i & 017];
}

static Sint
move_struct(p)
struct movsi_pair *p;
{
  return p->a;
}

static Sint
move_struct_b(p)
struct movsi_pair *p;
{
  return p->b;
}

static uSint
umove_struct(p)
struct movsi_upair *p;
{
  return p->a;
}

static Sint
move_global_struct(void)
{
  return movsi_gp.a;
}

static Sint
move_global_struct_b(void)
{
  return movsi_gp.b;
}

static uSint
umove_global_struct(void)
{
  return movsi_ugp.a;
}

static void
movem_reg(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = a;
}

static void
movem_reg_offset(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  p[1] = a;
}

static void
movem_reg_index(p, i, a)
Sint *p;
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  p[i & 017] = a;
}

static void
umovem_reg(p, a)
uSint *p;
uSint a;
{
  OPAQUE_REG(a);
  *p = a;
}

static void
umovem_reg_index(p, i, a)
uSint *p;
Sint i;
uSint a;
{
  OPAQUE_REG(a);
  p[i & 017] = a;
}

static void
movem_volatile(p, a)
volatile Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = a;
}

static void
movem_volatile_offset(p, a)
volatile Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  p[1] = a;
}

static void
movem_global(a)
Sint a;
{
  OPAQUE_REG(a);
  movsi_g0 = a;
}

static void
movem_global_1(a)
Sint a;
{
  OPAQUE_REG(a);
  movsi_g1 = a;
}

static void
umovem_global(a)
uSint a;
{
  OPAQUE_REG(a);
  movsi_ug0 = a;
}

static void
movem_vglobal(a)
Sint a;
{
  OPAQUE_REG(a);
  movsi_vg0 = a;
}

static void
movem_array(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  movsi_buf[i & 017] = a;
}

static void
umovem_array(i, a)
Sint i;
uSint a;
{
  OPAQUE_REG(a);
  movsi_ubuf[i & 017] = a;
}

static void
movem_struct(p, a)
struct movsi_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->a = a;
}

static void
movem_struct_b(p, a)
struct movsi_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->b = a;
}

static void
umovem_struct(p, a)
struct movsi_upair *p;
uSint a;
{
  OPAQUE_REG(a);
  p->a = a;
}

static void
movem_global_struct(a)
Sint a;
{
  OPAQUE_REG(a);
  movsi_gp.a = a;
}

static void
movem_global_struct_b(a)
Sint a;
{
  OPAQUE_REG(a);
  movsi_gp.b = a;
}

static void
umovem_global_struct(a)
uSint a;
{
  OPAQUE_REG(a);
  movsi_ugp.a = a;
}

static Sint
movem_reg_ret(p, a)
Sint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = a;
  return *p;
}

static Sint
movem_global_ret(a)
Sint a;
{
  OPAQUE_REG(a);
  movsi_g0 = a;
  return movsi_g0;
}

static Sint
movem_array_ret(i, a)
Sint i;
Sint a;
{
  OPAQUE_REG(a);
  i &= 017;
  movsi_buf[i] = a;
  return movsi_buf[i];
}

static Sint
movem_struct_ret(p, a)
struct movsi_pair *p;
Sint a;
{
  OPAQUE_REG(a);
  p->a = a;
  return p->a;
}

static Sint
move_mem_to_mem(dst, src)
Sint *dst;
Sint *src;
{
  Sint t;

  t = *src;
  *dst = t;
  return t;
}

static uSint
umove_mem_to_mem(dst, src)
uSint *dst;
uSint *src;
{
  uSint t;

  t = *src;
  *dst = t;
  return t;
}

static Sint
move_mem_to_global(src)
Sint *src;
{
  Sint t;

  t = *src;
  movsi_g0 = t;
  return movsi_g0;
}

static Sint
move_global_to_mem(dst)
Sint *dst;
{
  Sint t;

  t = movsi_g0;
  *dst = t;
  return t;
}

static Sint
move_array_to_array(i, j)
Sint i;
Sint j;
{
  Sint t;

  i &= 017;
  j &= 017;

  t = movsi_buf[i];
  movsi_buf[j] = t;

  return movsi_buf[j];
}

static Sint
move_struct_to_struct(dst, src)
struct movsi_pair *dst;
struct movsi_pair *src;
{
  Sint t;

  t = src->a;
  dst->b = t;
  return dst->b;
}

static Sint
move_local_copy(a)
Sint a;
{
  Sint t;

  OPAQUE_REG(a);
  t = a;
  return t;
}

static Sint
move_local_chain(a)
Sint a;
{
  Sint t0;
  Sint t1;
  Sint t2;

  OPAQUE_REG(a);

  t0 = a;
  t1 = t0;
  t2 = t1;

  return t2;
}

static Sint
move_local_array(a, b)
Sint a;
Sint b;
{
  Sint v[4];

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  v[0] = a;
  v[1] = b;
  v[2] = v[0];
  v[3] = v[1];

  return v[2] ^ v[3];
}

static Sint
move_local_address_escape(a)
Sint a;
{
  Sint t;
  Sint *p;

  OPAQUE_REG(a);

  p = &t;
  *p = a;

  return t;
}

/*
 * Constant forms.  These map onto the useful PDP-10 immediate and
 * halfword-immediate cases when the backend recognizes them.
 */

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
movsi_zero_left(void)
{
  return 0;
}

static Sint
movsi_small(void)
{
  return 0123456000000;
}

static Sint
movsi_one_left(void)
{
  return 0000001000000;
}

static Sint
movsi_all_left(void)
{
  return 0777777000000;
}

static Sint
hrroi_small(void)
{
  return -0123456;
}

static Sint
hrroi_one(void)
{
  return -1;
}

static Sint
hrroi_low9(void)
{
  return -0777;
}

static Sint
hrroi_low18(void)
{
  return -0777777;
}

static Sint
hrloi_small(void)
{
  return 0123456777777;
}

static Sint
hrloi_zero_left(void)
{
  return 0000000777777;
}

static Sint
hrloi_all_left(void)
{
  return 0777777777777;
}

static Sint
move_literal_large(void)
{
  return 0123456123456;
}

static Sint
move_literal_sparse(void)
{
  return 0525252252525;
}

static Sint
move_literal_sign(void)
{
  return 0400000000000;
}

static Sint
move_literal_right_half(void)
{
  return 0000000777777;
}

static Sint
move_literal_left_half(void)
{
  return 0777777000000;
}

static uSint
umove_literal_large(void)
{
  return 0123456123456;
}

static uSint
umove_literal_allones(void)
{
  return 0777777777777;
}

static void
movem_const_zero(p)
Sint *p;
{
  *p = 0;
}

static void
movem_const_one(p)
Sint *p;
{
  *p = 1;
}

static void
movem_const_small(p)
Sint *p;
{
  *p = 0123456;
}

static void
movem_const_movsi(p)
Sint *p;
{
  *p = 0123456000000;
}

static void
movem_const_hrroi(p)
Sint *p;
{
  *p = -0123456;
}

static void
movem_const_hrloi(p)
Sint *p;
{
  *p = 0123456777777;
}

static void
movem_const_large(p)
Sint *p;
{
  *p = 0123456123456;
}

static Sint
movem_const_large_ret(p)
Sint *p;
{
  *p = 0123456123456;
  return *p;
}

static void
movem_global_const_small(void)
{
  movsi_g0 = 0123456;
}

static void
movem_global_const_movsi(void)
{
  movsi_g0 = 0123456000000;
}

static void
movem_global_const_hrroi(void)
{
  movsi_g0 = -0123456;
}

static void
movem_global_const_hrloi(void)
{
  movsi_g0 = 0123456777777;
}

static void
movem_global_const_large(void)
{
  movsi_g0 = 0123456123456;
}

static Sint
movem_global_const_large_ret(void)
{
  movsi_g0 = 0123456123456;
  return movsi_g0;
}

static void
movem_array_const_small(i)
Sint i;
{
  movsi_buf[i & 017] = 0123456;
}

static void
movem_array_const_large(i)
Sint i;
{
  movsi_buf[i & 017] = 0123456123456;
}

static Sint
movem_array_const_large_ret(i)
Sint i;
{
  i &= 017;
  movsi_buf[i] = 0123456123456;
  return movsi_buf[i];
}

static Sint
move_select_arg(flag, a, b)
int flag;
Sint a;
Sint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    return a;
  return b;
}

static Sint
move_select_mem(flag, p, q)
int flag;
Sint *p;
Sint *q;
{
  OPAQUE_REG(flag);

  if (flag)
    return *p;
  return *q;
}

static Sint
move_select_global(flag)
int flag;
{
  OPAQUE_REG(flag);

  if (flag)
    return movsi_g0;
  return movsi_g1;
}

static Sint
move_branch_store(flag, p, a, b)
int flag;
Sint *p;
Sint a;
Sint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    *p = a;
  else
    *p = b;

  return *p;
}

static Sint
move_branch_global_store(flag, a, b)
int flag;
Sint a;
Sint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    movsi_g0 = a;
  else
    movsi_g0 = b;

  return movsi_g0;
}

static Sint
move_live_across_call(a)
Sint a;
{
  Sint t;

  OPAQUE_REG(a);

  t = a;
  sink_int(1);

  return t;
}

static Sint
move_live_across_call_2(a, b)
Sint a;
Sint b;
{
  Sint t0;
  Sint t1;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  t0 = a;
  t1 = b;

  sink_sint(t0);

  return t1;
}

static Sint
move_store_across_call(p, a)
Sint *p;
Sint a;
{
  Sint t;

  OPAQUE_REG(a);

  t = a;
  sink_sint(t);
  *p = t;

  return *p;
}

static Sint
move_load_across_call(p)
Sint *p;
{
  Sint t;

  t = *p;
  sink_sint(t);

  return t;
}

static Sint
move_many_args(a, b, c, d, e, f)
Sint a;
Sint b;
Sint c;
Sint d;
int e;
int f;
{
  Sint t;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  if (e)
    t = a;
  else
    t = b;

  sink_int(f);

  if (f)
    return c;
  return t;
}

static Sint
move_many_moves(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  Sint t0;
  Sint t1;
  Sint t2;
  Sint t3;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  t0 = a;
  t1 = b;
  t2 = c;
  t3 = d;

  movsi_g0 = t0;
  movsi_g1 = t1;
  movsi_g2 = t2;

  return t3;
}

static Sint
move_many_stores(a, b, c)
Sint a;
Sint b;
Sint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  movsi_buf[0] = a;
  movsi_buf[1] = b;
  movsi_buf[2] = c;

  return movsi_buf[0] ^ movsi_buf[1] ^ movsi_buf[2];
}

static Sint
move_loop_copy(dst, src, n)
Sint *dst;
Sint *src;
Sint n;
{
  Sint i;
  Sint last;

  last = 0;

  for (i = 0; i < n; ++i) {
    last = src[i & 017];
    dst[i & 017] = last;
  }

  return last;
}

static uSint
umove_loop_copy(dst, src, n)
uSint *dst;
uSint *src;
Sint n;
{
  Sint i;
  uSint last;

  last = 0;

  for (i = 0; i < n; ++i) {
    last = src[i & 017];
    dst[i & 017] = last;
  }

  return last;
}

static Sint
move_loop_fill(dst, n, value)
Sint *dst;
Sint n;
Sint value;
{
  Sint i;

  OPAQUE_REG(value);

  for (i = 0; i < n; ++i)
    dst[i & 017] = value;

  return value;
}

static Sint
move_loop_select(dst, src0, src1, n, flag)
Sint *dst;
Sint *src0;
Sint *src1;
Sint n;
int flag;
{
  Sint i;
  Sint t;

  OPAQUE_REG(flag);
  t = 0;

  for (i = 0; i < n; ++i) {
    if (flag)
      t = src0[i & 017];
    else
      t = src1[i & 017];

    dst[i & 017] = t;
  }

  return t;
}

static Sint
move_volatile_copy(dst, src)
volatile Sint *dst;
volatile Sint *src;
{
  Sint t;

  t = *src;
  *dst = t;

  return t;
}

static Sint
move_volatile_global_copy(void)
{
  Sint t;

  t = movsi_vg0;
  movsi_vg1 = t;

  return t;
}

/*
 * Smaller-mode controls.  The conversion tests have their own files;
 * these are only here to make sure SImode moves after extension/truncation
 * are not accidentally tied to bad constraints.
 */

static Sint
move_from_qi(a)
Qint a;
{
  Sint x;

  x = a;
  return x;
}

static Sint
move_from_hi(a)
Hint a;
{
  Sint x;

  x = a;
  return x;
}

static uSint
move_from_uqi(a)
uQint a;
{
  uSint x;

  x = a;
  return x;
}

static uSint
move_from_uhi(a)
uHint a;
{
  uSint x;

  x = a;
  return x;
}

static void
movem_from_qi(p, a)
Sint *p;
Qint a;
{
  Sint x;

  x = a;
  *p = x;
}

static void
movem_from_hi(p, a)
Sint *p;
Hint a;
{
  Sint x;

  x = a;
  *p = x;
}

static Qint
move_to_qi(a)
Sint a;
{
  OPAQUE_REG(a);
  return (Qint)a;
}

static Hint
move_to_hi(a)
Sint a;
{
  OPAQUE_REG(a);
  return (Hint)a;
}

static Sint
move_struct_local(a, b)
Sint a;
Sint b;
{
  struct movsi_pair p;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  p.a = a;
  p.b = b;

  return p.a;
}

static Sint
move_struct_local_b(a, b)
Sint a;
Sint b;
{
  struct movsi_pair p;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  p.a = a;
  p.b = b;

  return p.b;
}

static Sint
move_nested_struct_copy(dst, src)
struct movsi_pair *dst;
struct movsi_pair *src;
{
  dst->a = src->a;
  dst->b = src->b;

  return dst->a ^ dst->b;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
move1(a, e)
Sint a;
Sint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return e;
}

static Sint
move2(a, e)
Sint a;
Sint *e;
{
  OPAQUE_REG(a);
  return *e;
}

static Sint
movei(void)
{
  return 0123456;
}

static Sint
movsi(void)
{
  return 0123456000000;
}

static Sint
hrroi(void)
{
  return -0123456;
}

static Sint
hrloi(void)
{
  return 0123456777777;
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
  OPAQUE_REG(a);
  *e = a;
}
