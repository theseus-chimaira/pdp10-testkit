#include "insns.h"

/*
 * movdi pattern coverage for PDP-6/166 and KA10.
 *
 * This is DImode move coverage, not DImode arithmetic coverage.
 *
 * Intended source shapes:
 *
 *   DI argument -> return
 *   DI memory load
 *   DI memory store
 *   DI memory -> memory through a temporary
 *   DI constants
 *   DI globals, arrays, structs
 *   volatile DI loads/stores
 *   DI values live across calls
 *   signed and unsigned DImode moves
 *
 * cmpdi.c and dimode_pressure.c cover comparisons and allocator stress.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern void sink_int();
extern void sink_di();
extern void sink_udi();

extern Dint ext_di_identity();
extern uDint ext_udi_identity();

static Dint movdi_g0;
static Dint movdi_g1;
static Dint movdi_g2;

static uDint movdi_ug0;
static uDint movdi_ug1;

static volatile Dint movdi_vg0;
static volatile Dint movdi_vg1;

static Dint movdi_buf[16];
static uDint movdi_ubuf[16];

struct movdi_pair {
  Dint a;
  Dint b;
};

struct movdi_upair {
  uDint a;
  uDint b;
};

static struct movdi_pair movdi_gp;
static struct movdi_upair movdi_ugp;

static Dint
make_di(hi, lo)
Sint hi;
uSint lo;
{
  Dint r;

  r = (Dint)hi;
  r = r << 36;
  r += (Dint)lo;
  return r;
}

static uDint
make_udi(hi, lo)
uSint hi;
uSint lo;
{
  uDint r;

  r = (uDint)hi;
  r = r << 36;
  r += (uDint)lo;
  return r;
}

static Dint
movdi_arg0(a)
Dint a;
{
  OPAQUE_REG(a);
  return a;
}

static Dint
movdi_arg1(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return b;
}

static Dint
movdi_arg2(a, b, c)
Dint a;
Dint b;
Dint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  return c;
}

static uDint
movdi_uarg0(a)
uDint a;
{
  OPAQUE_REG(a);
  return a;
}

static uDint
movdi_uarg1(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  return b;
}

static Dint
movdi_load(p)
Dint *p;
{
  return *p;
}

static Dint
movdi_load_offset(p)
Dint *p;
{
  return p[1];
}

static Dint
movdi_load_index(p, i)
Dint *p;
int i;
{
  return p[i & 017];
}

static uDint
movdi_uload(p)
uDint *p;
{
  return *p;
}

static uDint
movdi_uload_index(p, i)
uDint *p;
int i;
{
  return p[i & 017];
}

static Dint
movdi_load_volatile(p)
volatile Dint *p;
{
  return *p;
}

static Dint
movdi_load_volatile_offset(p)
volatile Dint *p;
{
  return p[1];
}

static Dint
movdi_load_global(void)
{
  return movdi_g0;
}

static Dint
movdi_load_global_1(void)
{
  return movdi_g1;
}

static uDint
movdi_uload_global(void)
{
  return movdi_ug0;
}

static Dint
movdi_load_vglobal(void)
{
  return movdi_vg0;
}

static Dint
movdi_load_array(i)
int i;
{
  return movdi_buf[i & 017];
}

static uDint
movdi_uload_array(i)
int i;
{
  return movdi_ubuf[i & 017];
}

static Dint
movdi_load_struct(p)
struct movdi_pair *p;
{
  return p->a;
}

static Dint
movdi_load_struct_b(p)
struct movdi_pair *p;
{
  return p->b;
}

static uDint
movdi_uload_struct(p)
struct movdi_upair *p;
{
  return p->a;
}

static Dint
movdi_load_global_struct(void)
{
  return movdi_gp.a;
}

static Dint
movdi_load_global_struct_b(void)
{
  return movdi_gp.b;
}

static uDint
movdi_uload_global_struct(void)
{
  return movdi_ugp.a;
}

static void
movdi_store(p, a)
Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  *p = a;
}

static void
movdi_store_offset(p, a)
Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  p[1] = a;
}

static void
movdi_store_index(p, i, a)
Dint *p;
int i;
Dint a;
{
  OPAQUE_REG(a);
  p[i & 017] = a;
}

static void
movdi_ustore(p, a)
uDint *p;
uDint a;
{
  OPAQUE_REG(a);
  *p = a;
}

static void
movdi_ustore_index(p, i, a)
uDint *p;
int i;
uDint a;
{
  OPAQUE_REG(a);
  p[i & 017] = a;
}

static void
movdi_store_volatile(p, a)
volatile Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  *p = a;
}

static void
movdi_store_volatile_offset(p, a)
volatile Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  p[1] = a;
}

static void
movdi_store_global(a)
Dint a;
{
  OPAQUE_REG(a);
  movdi_g0 = a;
}

static void
movdi_store_global_1(a)
Dint a;
{
  OPAQUE_REG(a);
  movdi_g1 = a;
}

static void
movdi_ustore_global(a)
uDint a;
{
  OPAQUE_REG(a);
  movdi_ug0 = a;
}

static void
movdi_store_vglobal(a)
Dint a;
{
  OPAQUE_REG(a);
  movdi_vg0 = a;
}

static void
movdi_store_array(i, a)
int i;
Dint a;
{
  OPAQUE_REG(a);
  movdi_buf[i & 017] = a;
}

static void
movdi_ustore_array(i, a)
int i;
uDint a;
{
  OPAQUE_REG(a);
  movdi_ubuf[i & 017] = a;
}

static void
movdi_store_struct(p, a)
struct movdi_pair *p;
Dint a;
{
  OPAQUE_REG(a);
  p->a = a;
}

static void
movdi_store_struct_b(p, a)
struct movdi_pair *p;
Dint a;
{
  OPAQUE_REG(a);
  p->b = a;
}

static void
movdi_ustore_struct(p, a)
struct movdi_upair *p;
uDint a;
{
  OPAQUE_REG(a);
  p->a = a;
}

static void
movdi_store_global_struct(a)
Dint a;
{
  OPAQUE_REG(a);
  movdi_gp.a = a;
}

static void
movdi_store_global_struct_b(a)
Dint a;
{
  OPAQUE_REG(a);
  movdi_gp.b = a;
}

static void
movdi_ustore_global_struct(a)
uDint a;
{
  OPAQUE_REG(a);
  movdi_ugp.a = a;
}

static Dint
movdi_store_ret(p, a)
Dint *p;
Dint a;
{
  OPAQUE_REG(a);
  *p = a;
  return *p;
}

static Dint
movdi_store_global_ret(a)
Dint a;
{
  OPAQUE_REG(a);
  movdi_g0 = a;
  return movdi_g0;
}

static Dint
movdi_store_array_ret(i, a)
int i;
Dint a;
{
  OPAQUE_REG(a);
  i &= 017;
  movdi_buf[i] = a;
  return movdi_buf[i];
}

static Dint
movdi_store_struct_ret(p, a)
struct movdi_pair *p;
Dint a;
{
  OPAQUE_REG(a);
  p->a = a;
  return p->a;
}

static Dint
movdi_mem_to_mem(dst, src)
Dint *dst;
Dint *src;
{
  Dint t;

  t = *src;
  *dst = t;
  return t;
}

static uDint
movdi_umem_to_mem(dst, src)
uDint *dst;
uDint *src;
{
  uDint t;

  t = *src;
  *dst = t;
  return t;
}

static Dint
movdi_mem_to_global(src)
Dint *src;
{
  Dint t;

  t = *src;
  movdi_g0 = t;
  return movdi_g0;
}

static Dint
movdi_global_to_mem(dst)
Dint *dst;
{
  Dint t;

  t = movdi_g0;
  *dst = t;
  return t;
}

static Dint
movdi_array_to_array(i, j)
int i;
int j;
{
  Dint t;

  i &= 017;
  j &= 017;

  t = movdi_buf[i];
  movdi_buf[j] = t;

  return movdi_buf[j];
}

static Dint
movdi_struct_to_struct(dst, src)
struct movdi_pair *dst;
struct movdi_pair *src;
{
  Dint t;

  t = src->a;
  dst->b = t;
  return dst->b;
}

static Dint
movdi_local_copy(a)
Dint a;
{
  Dint t;

  OPAQUE_REG(a);
  t = a;
  return t;
}

static Dint
movdi_local_chain(a)
Dint a;
{
  Dint t0;
  Dint t1;
  Dint t2;

  OPAQUE_REG(a);

  t0 = a;
  t1 = t0;
  t2 = t1;

  return t2;
}

static Dint
movdi_local_array(a, b)
Dint a;
Dint b;
{
  Dint v[4];

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  v[0] = a;
  v[1] = b;
  v[2] = v[0];
  v[3] = v[1];

  return v[2] ^ v[3];
}

static Dint
movdi_local_address_escape(a)
Dint a;
{
  Dint t;
  Dint *p;

  OPAQUE_REG(a);

  p = &t;
  *p = a;

  return t;
}

static Dint
movdi_const_zero(void)
{
  return (Dint)0;
}

static Dint
movdi_const_one(void)
{
  return (Dint)1;
}

static Dint
movdi_const_minus_one(void)
{
  return (Dint)-1;
}

static Dint
movdi_const_low18(void)
{
  return (Dint)0777777;
}

static Dint
movdi_const_low36(void)
{
  return (Dint)0777777777777;
}

static Dint
movdi_const_high_word(void)
{
  return make_di(1, 0);
}

static Dint
movdi_const_large(void)
{
  return make_di(0123456, 0654321);
}

static Dint
movdi_const_large_neg(void)
{
  return -make_di(0123456, 0654321);
}

static Dint
movdi_const_original_shape(void)
{
  return make_di(0123456, 0654321);
}

static uDint
movdi_uconst_zero(void)
{
  return (uDint)0;
}

static uDint
movdi_uconst_one(void)
{
  return (uDint)1;
}

static uDint
movdi_uconst_low36(void)
{
  return (uDint)0777777777777;
}

static uDint
movdi_uconst_high_word(void)
{
  return make_udi(1, 0);
}

static uDint
movdi_uconst_large(void)
{
  return make_udi(0123456, 0654321);
}

static void
movdi_store_const_zero(p)
Dint *p;
{
  *p = (Dint)0;
}

static void
movdi_store_const_one(p)
Dint *p;
{
  *p = (Dint)1;
}

static void
movdi_store_const_minus_one(p)
Dint *p;
{
  *p = (Dint)-1;
}

static void
movdi_store_const_large(p)
Dint *p;
{
  *p = make_di(0123456, 0654321);
}

static Dint
movdi_store_const_large_ret(p)
Dint *p;
{
  *p = make_di(0123456, 0654321);
  return *p;
}

static void
movdi_store_global_const_large(void)
{
  movdi_g0 = make_di(0123456, 0654321);
}

static Dint
movdi_store_global_const_large_ret(void)
{
  movdi_g0 = make_di(0123456, 0654321);
  return movdi_g0;
}

static void
movdi_store_array_const_large(i)
int i;
{
  movdi_buf[i & 017] = make_di(0123456, 0654321);
}

static Dint
movdi_store_array_const_large_ret(i)
int i;
{
  i &= 017;
  movdi_buf[i] = make_di(0123456, 0654321);
  return movdi_buf[i];
}

static Dint
movdi_select_arg(flag, a, b)
int flag;
Dint a;
Dint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    return a;
  return b;
}

static Dint
movdi_select_mem(flag, p, q)
int flag;
Dint *p;
Dint *q;
{
  if (flag)
    return *p;
  return *q;
}

static Dint
movdi_select_global(flag)
int flag;
{
  OPAQUE_REG(flag);

  if (flag)
    return movdi_g0;
  return movdi_g1;
}

static Dint
movdi_branch_store(flag, p, a, b)
int flag;
Dint *p;
Dint a;
Dint b;
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

static Dint
movdi_branch_global_store(flag, a, b)
int flag;
Dint a;
Dint b;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  if (flag)
    movdi_g0 = a;
  else
    movdi_g0 = b;

  return movdi_g0;
}

static Dint
movdi_call_arg(a)
Dint a;
{
  OPAQUE_REG(a);
  return ext_di_identity(a);
}

static uDint
movdi_ucall_arg(a)
uDint a;
{
  OPAQUE_REG(a);
  return ext_udi_identity(a);
}

static Dint
movdi_call_loaded(p)
Dint *p;
{
  Dint t;

  t = *p;
  return ext_di_identity(t);
}

static Dint
movdi_call_result(void)
{
  Dint t;

  t = ext_di_identity(movdi_g0);
  return t;
}

static Dint
movdi_live_across_call(a)
Dint a;
{
  Dint t;

  OPAQUE_REG(a);

  t = a;
  sink_int(1);

  return t;
}

static Dint
movdi_live_across_call_2(a, b)
Dint a;
Dint b;
{
  Dint t0;
  Dint t1;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  t0 = a;
  t1 = b;

  sink_di(t0);

  return t1;
}

static Dint
movdi_store_across_call(p, a)
Dint *p;
Dint a;
{
  Dint t;

  OPAQUE_REG(a);

  t = a;
  sink_di(t);
  *p = t;

  return *p;
}

static Dint
movdi_load_across_call(p)
Dint *p;
{
  Dint t;

  t = *p;
  sink_di(t);

  return t;
}

static uDint
movdi_ulive_across_call(a)
uDint a;
{
  uDint t;

  OPAQUE_REG(a);

  t = a;
  sink_udi(t);

  return t;
}

static Dint
movdi_many_args(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
{
  Dint t;

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

static Dint
movdi_many_moves(a, b, c, d)
Dint a;
Dint b;
Dint c;
Dint d;
{
  Dint t0;
  Dint t1;
  Dint t2;
  Dint t3;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  t0 = a;
  t1 = b;
  t2 = c;
  t3 = d;

  movdi_g0 = t0;
  movdi_g1 = t1;
  movdi_g2 = t2;

  return t3;
}

static Dint
movdi_many_stores(a, b, c)
Dint a;
Dint b;
Dint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  movdi_buf[0] = a;
  movdi_buf[1] = b;
  movdi_buf[2] = c;

  return movdi_buf[0] ^ movdi_buf[1] ^ movdi_buf[2];
}

static Dint
movdi_loop_copy(dst, src, n)
Dint *dst;
Dint *src;
int n;
{
  int i;
  Dint last;

  last = 0;

  for (i = 0; i < n; ++i) {
    last = src[i & 017];
    dst[i & 017] = last;
  }

  return last;
}

static uDint
movdi_uloop_copy(dst, src, n)
uDint *dst;
uDint *src;
int n;
{
  int i;
  uDint last;

  last = 0;

  for (i = 0; i < n; ++i) {
    last = src[i & 017];
    dst[i & 017] = last;
  }

  return last;
}

static Dint
movdi_loop_fill(dst, n, value)
Dint *dst;
int n;
Dint value;
{
  int i;

  OPAQUE_REG(value);

  for (i = 0; i < n; ++i)
    dst[i & 017] = value;

  return value;
}

static Dint
movdi_loop_select(dst, src0, src1, n, flag)
Dint *dst;
Dint *src0;
Dint *src1;
int n;
int flag;
{
  int i;
  Dint t;

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

static Dint
movdi_volatile_copy(dst, src)
volatile Dint *dst;
volatile Dint *src;
{
  Dint t;

  t = *src;
  *dst = t;

  return t;
}

static Dint
movdi_volatile_global_copy(void)
{
  Dint t;

  t = movdi_vg0;
  movdi_vg1 = t;

  return t;
}

static Dint
movdi_from_sint(a)
Sint a;
{
  OPAQUE_REG(a);
  return (Dint)a;
}

static uDint
movdi_from_usint(a)
uSint a;
{
  OPAQUE_REG(a);
  return (uDint)a;
}

static void
movdi_store_from_sint(p, a)
Dint *p;
Sint a;
{
  OPAQUE_REG(a);
  *p = (Dint)a;
}

static Sint
movdi_to_sint(a)
Dint a;
{
  OPAQUE_REG(a);
  return (Sint)a;
}

static uSint
movdi_to_usint(a)
uDint a;
{
  OPAQUE_REG(a);
  return (uSint)a;
}

static Dint
movdi_return_after_store(a, p)
Dint a;
Dint *p;
{
  Dint t;

  OPAQUE_REG(a);

  t = a;
  *p = t;

  return t;
}

static Dint
movdi_return_before_store(a, p)
Dint a;
Dint *p;
{
  Dint t;

  OPAQUE_REG(a);

  t = a;
  *p = t;

  return a;
}

static Dint
movdi_struct_local(a, b)
Dint a;
Dint b;
{
  struct movdi_pair p;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  p.a = a;
  p.b = b;

  return p.a;
}

static Dint
movdi_struct_local_b(a, b)
Dint a;
Dint b;
{
  struct movdi_pair p;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  p.a = a;
  p.b = b;

  return p.b;
}

static Dint
movdi_nested_struct_copy(dst, src)
struct movdi_pair *dst;
struct movdi_pair *src;
{
  dst->a = src->a;
  dst->b = src->b;

  return dst->a ^ dst->b;
}

/*
 * Original skeleton shapes, kept with short names.
 */

static Dint
dmove1(a, e)
Dint a;
Dint e;
{
  OPAQUE_REG(a);
  OPAQUE_REG(e);
  return e;
}

static Dint
dmove2(a, e)
Dint a;
Dint *e;
{
  OPAQUE_REG(a);
  return *e;
}

static Dint
dmove3(void)
{
  return make_di(0123456, 0654321);
}

static void
dmovem(a, e)
Dint a;
Dint *e;
{
  OPAQUE_REG(a);
  *e = a;
}
