#include "insns.h"

/*
 * SImode to QImode truncation pattern pressure.
 *
 * Intended pattern:
 *   truncsiqi2
 *
 * PDP-6/KA10-relevant backend form:
 *   ANDI AC,777
 *
 * Keep this file focused on narrowing from 36-bit SImode values to
 * 9-bit QImode values.  Sign-extension back to SImode belongs to
 * extendqisi2.c; zero-extension back to SImode belongs to
 * zero_extendqisi2.c.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint truncq_ga;
static Sint truncq_gb;
static volatile Sint truncq_vga;
static Sint truncq_sbuf[16];

static uSint truncq_uga;
static volatile uSint truncq_vuga;
static uSint truncq_usbuf[16];

static Qint truncq_qa;
static Qint truncq_qb;
static volatile Qint truncq_vqa;
static Qint truncq_qbuf[16];

static uQint truncq_uqa;
static volatile uQint truncq_vuqa;
static uQint truncq_uqbuf[16];

struct truncq_pair {
  Qint a;
  Qint b;
};

struct truncuq_pair {
  uQint a;
  uQint b;
};

struct truncq_sipair {
  Sint a;
  Sint b;
};

static struct truncq_pair truncq_gp;
static struct truncuq_pair truncq_ugp;
static struct truncq_sipair truncq_sgp;

/*
 * Original expected basename shape.
 */

Qint
truncsiqi2(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x;
}

/*
 * Basic register truncation forms.
 */

static Qint
truncq_arg(a)
Sint a;
{
  return (Qint)a;
}

static Qint
truncq_second_arg(a, b)
Sint a;
Sint b;
{
  return (Qint)b;
}

static uQint
utruncq_arg(a)
uSint a;
{
  return (uQint)a;
}

static Qint
truncq_local(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x;
}

static uQint
utruncq_local(a)
uSint a;
{
  uQint x;

  x = (uQint)a;
  return x;
}

static Qint
truncq_reuse(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  x = (Qint)x;
  return x;
}

static Qint
truncq_add(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a + b);
  return x;
}

static Qint
truncq_sub(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a - b);
  return x;
}

static Qint
truncq_mul(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a * b);
  return x;
}

static Qint
truncq_neg(a)
Sint a;
{
  Qint x;

  x = (Qint)-a;
  return x;
}

static Qint
truncq_xor(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a ^ b);
  return x;
}

static Qint
truncq_or(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a | b);
  return x;
}

static Qint
truncq_and(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a & b);
  return x;
}

static Qint
truncq_shift_left(a)
Sint a;
{
  Qint x;

  x = (Qint)(a << 1);
  return x;
}

static Qint
truncq_shift_right(a)
Sint a;
{
  Qint x;

  x = (Qint)(a >> 1);
  return x;
}

static Qint
truncq_call()
{
  Qint x;

  x = (Qint)f();
  return x;
}

static uQint
utruncq_call()
{
  uQint x;

  x = (uQint)uf();
  return x;
}

/*
 * Constants and boundary masks.
 */

static Qint
truncq_const_zero()
{
  return (Qint)0;
}

static Qint
truncq_const_one()
{
  return (Qint)1;
}

static Qint
truncq_const_177()
{
  return (Qint)0177;
}

static Qint
truncq_const_377()
{
  return (Qint)0377;
}

static Qint
truncq_const_400()
{
  return (Qint)0400;
}

static Qint
truncq_const_777()
{
  return (Qint)0777;
}

static Qint
truncq_const_1000()
{
  return (Qint)01000;
}

static Qint
truncq_const_full()
{
  return (Qint)0123456123456;
}

static Qint
truncq_const_minus_one()
{
  return (Qint)-1;
}

static Qint
truncq_const_minus_small()
{
  return (Qint)-0123;
}

static uQint
utruncq_const_777()
{
  return (uQint)0777;
}

static uQint
utruncq_const_1000()
{
  return (uQint)01000;
}

static uQint
utruncq_const_full()
{
  return (uQint)0123456123456;
}

/*
 * Memory and global sources narrowed to QI registers.
 */

static Qint
truncq_mem(p)
Sint *p;
{
  Qint x;

  x = (Qint)*p;
  return x;
}

static Qint
truncq_umem(p)
uSint *p;
{
  Qint x;

  x = (Qint)*p;
  return x;
}

static uQint
utruncq_umem(p)
uSint *p;
{
  uQint x;

  x = (uQint)*p;
  return x;
}

static Qint
truncq_volatile_mem(p)
volatile Sint *p;
{
  Qint x;

  x = (Qint)*p;
  return x;
}

static Qint
truncq_global()
{
  Qint x;

  x = (Qint)truncq_ga;
  return x;
}

static Qint
truncq_global_b()
{
  Qint x;

  x = (Qint)truncq_gb;
  return x;
}

static Qint
truncq_volatile_global()
{
  Qint x;

  x = (Qint)truncq_vga;
  return x;
}

static uQint
utruncq_global()
{
  uQint x;

  x = (uQint)truncq_uga;
  return x;
}

static uQint
utruncq_volatile_global()
{
  uQint x;

  x = (uQint)truncq_vuga;
  return x;
}

static Qint
truncq_array(i)
Sint i;
{
  Qint x;

  x = (Qint)truncq_sbuf[i & 017];
  return x;
}

static Qint
truncq_uarray(i)
Sint i;
{
  Qint x;

  x = (Qint)truncq_usbuf[i & 017];
  return x;
}

static uQint
utruncq_uarray(i)
Sint i;
{
  uQint x;

  x = (uQint)truncq_usbuf[i & 017];
  return x;
}

static Qint
truncq_ptr_array(p, i)
Sint *p;
Sint i;
{
  Qint x;

  x = (Qint)p[i & 017];
  return x;
}

static Qint
truncq_struct_a(p)
struct truncq_sipair *p;
{
  Qint x;

  x = (Qint)p->a;
  return x;
}

static Qint
truncq_struct_b(p)
struct truncq_sipair *p;
{
  Qint x;

  x = (Qint)p->b;
  return x;
}

static Qint
truncq_global_struct_a()
{
  Qint x;

  x = (Qint)truncq_sgp.a;
  return x;
}

static Qint
truncq_global_struct_b()
{
  Qint x;

  x = (Qint)truncq_sgp.b;
  return x;
}

/*
 * Store forms: narrowing SImode values into QImode memory.
 */

static void
truncq_store_global(a)
Sint a;
{
  truncq_qa = (Qint)a;
}

static void
truncq_store_global_u(a)
uSint a;
{
  truncq_uqa = (uQint)a;
}

static void
truncq_store_volatile_global(a)
Sint a;
{
  truncq_vqa = (Qint)a;
}

static void
truncq_store_volatile_global_u(a)
uSint a;
{
  truncq_vuqa = (uQint)a;
}

static void
truncq_store_ptr(dst, a)
Qint *dst;
Sint a;
{
  *dst = (Qint)a;
}

static void
truncq_store_uptr(dst, a)
uQint *dst;
uSint a;
{
  *dst = (uQint)a;
}

static void
truncq_store_array(i, a)
Sint i;
Sint a;
{
  truncq_qbuf[i & 017] = (Qint)a;
}

static void
truncq_store_uarray(i, a)
Sint i;
uSint a;
{
  truncq_uqbuf[i & 017] = (uQint)a;
}

static void
truncq_store_struct_a(p, a)
struct truncq_pair *p;
Sint a;
{
  p->a = (Qint)a;
}

static void
truncq_store_struct_b(p, a)
struct truncq_pair *p;
Sint a;
{
  p->b = (Qint)a;
}

static void
truncq_store_ustruct_a(p, a)
struct truncuq_pair *p;
uSint a;
{
  p->a = (uQint)a;
}

static void
truncq_store_ustruct_b(p, a)
struct truncuq_pair *p;
uSint a;
{
  p->b = (uQint)a;
}

/*
 * Store with returned narrowed result.
 */

static Qint
truncq_store_global_return(a)
Sint a;
{
  return truncq_qa = (Qint)a;
}

static uQint
truncq_store_global_u_return(a)
uSint a;
{
  return truncq_uqa = (uQint)a;
}

static Qint
truncq_store_ptr_return(dst, a)
Qint *dst;
Sint a;
{
  return *dst = (Qint)a;
}

static uQint
truncq_store_uptr_return(dst, a)
uQint *dst;
uSint a;
{
  return *dst = (uQint)a;
}

static Qint
truncq_store_array_return(i, a)
Sint i;
Sint a;
{
  return truncq_qbuf[i & 017] = (Qint)a;
}

static uQint
truncq_store_uarray_return(i, a)
Sint i;
uSint a;
{
  return truncq_uqbuf[i & 017] = (uQint)a;
}

/*
 * Narrowing after expression, then widening again.  These forms make
 * the truncation observable while still returning SImode.
 */

static Sint
truncq_to_sint(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x;
}

static uSint
utruncq_to_usint(a)
uSint a;
{
  uQint x;

  x = (uQint)a;
  return x;
}

static Sint
truncq_add_to_sint(a, b)
Sint a;
Sint b;
{
  Qint x;

  x = (Qint)(a + b);
  return x;
}

static uSint
utruncq_add_to_usint(a, b)
uSint a;
uSint b;
{
  uQint x;

  x = (uQint)(a + b);
  return x;
}

static Sint
truncq_mask_then_sint(a)
Sint a;
{
  Qint x;

  x = (Qint)(a & 0777);
  return x;
}

static Sint
truncq_full_then_sint(a)
Sint a;
{
  Qint x;

  x = (Qint)(a ^ 0123456123456);
  return x;
}

static uSint
utruncq_full_then_usint(a)
uSint a;
{
  uQint x;

  x = (uQint)(a ^ 0123456123456);
  return x;
}

/*
 * In-place QI update forms.  These combine load, widen, arithmetic,
 * truncation, and store.
 */

static void
truncq_inc_global(a)
Sint a;
{
  truncq_qa = (Qint)(truncq_qa + a);
}

static Qint
truncq_inc_global_return(a)
Sint a;
{
  return truncq_qa = (Qint)(truncq_qa + a);
}

static void
truncq_sub_global(a)
Sint a;
{
  truncq_qa = (Qint)(truncq_qa - a);
}

static Qint
truncq_sub_global_return(a)
Sint a;
{
  return truncq_qa = (Qint)(truncq_qa - a);
}

static void
truncq_xor_global(a)
Sint a;
{
  truncq_qa = (Qint)(truncq_qa ^ a);
}

static Qint
truncq_xor_global_return(a)
Sint a;
{
  return truncq_qa = (Qint)(truncq_qa ^ a);
}

static void
truncq_inc_ptr(p, a)
Qint *p;
Sint a;
{
  *p = (Qint)(*p + a);
}

static Qint
truncq_inc_ptr_return(p, a)
Qint *p;
Sint a;
{
  return *p = (Qint)(*p + a);
}

static void
truncq_inc_array(i, a)
Sint i;
Sint a;
{
  truncq_qbuf[i & 017] = (Qint)(truncq_qbuf[i & 017] + a);
}

static Qint
truncq_inc_array_return(i, a)
Sint i;
Sint a;
{
  return truncq_qbuf[i & 017] = (Qint)(truncq_qbuf[i & 017] + a);
}

/*
 * Branch and compare uses after truncation.
 */

static Sint
truncq_eq_zero(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x == 0;
}

static Sint
truncq_ne_zero(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x != 0;
}

static Sint
truncq_lt_zero(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x < 0;
}

static Sint
truncq_ge_zero(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x >= 0;
}

static Sint
truncq_eq_177(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x == 0177;
}

static Sint
truncq_eq_minus_one(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x == -1;
}

static Sint
utruncq_gt_400(a)
uSint a;
{
  uQint x;

  x = (uQint)a;
  return x > 0400;
}

static Sint
truncq_range(a)
Sint a;
{
  Qint x;
  Sint y;

  x = (Qint)a;
  y = x;
  if (y < -0100)
    return -1;
  if (y > 0100)
    return 1;
  return 0;
}

/*
 * Volatile/call barriers to keep selected forms alive.
 */

static Qint
truncq_after_call(p)
Sint *p;
{
  Sint x;
  Qint y;

  x = *p;
  clobber();
  y = (Qint)x;
  return y;
}

static Qint
truncq_call_after_load(p)
Sint *p;
{
  Sint x;
  Qint y;

  x = *p;
  clobber();
  y = (Qint)(x + f());
  return y;
}

static void
truncq_store_after_call(p)
Qint *p;
{
  Sint x;

  x = f();
  clobber();
  *p = (Qint)x;
}

static Sint
truncq_global_after_call()
{
  Qint x;

  clobber();
  x = (Qint)truncq_ga;
  return x;
}
