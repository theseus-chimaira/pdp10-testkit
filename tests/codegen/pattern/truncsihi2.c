#include "insns.h"

/*
 * SImode to HImode truncation pattern pressure.
 *
 * Intended pattern:
 *   truncsihi2
 *
 * PDP-6/KA10-relevant backend form:
 *   HRR AC,E
 *
 * Keep this file focused on narrowing from 36-bit SImode values to
 * 18-bit HImode values.  Sign-extension back to SImode belongs to
 * extendhisi2.c; zero-extension back to SImode belongs to
 * zero_extendhisi2.c.
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

static Sint trunch_ga;
static Sint trunch_gb;
static volatile Sint trunch_vga;
static Sint trunch_sbuf[16];

static uSint trunch_uga;
static volatile uSint trunch_vuga;
static uSint trunch_usbuf[16];

static Hint trunch_ha;
static Hint trunch_hb;
static volatile Hint trunch_vha;
static Hint trunch_hbuf[16];

static uHint trunch_uha;
static volatile uHint trunch_vuha;
static uHint trunch_uhbuf[16];

struct trunch_pair {
  Hint a;
  Hint b;
};

struct truncuh_pair {
  uHint a;
  uHint b;
};

struct trunch_sipair {
  Sint a;
  Sint b;
};

static struct trunch_pair trunch_gp;
static struct truncuh_pair trunch_ugp;
static struct trunch_sipair trunch_sgp;

/*
 * Original expected basename shape.
 */

Hint
truncsihi2(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x;
}

/*
 * Basic register truncation forms.
 */

static Hint
trunch_arg(a)
Sint a;
{
  return (Hint)a;
}

static Hint
trunch_second_arg(a, b)
Sint a;
Sint b;
{
  return (Hint)b;
}

static uHint
utrunch_arg(a)
uSint a;
{
  return (uHint)a;
}

static Hint
trunch_local(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x;
}

static uHint
utrunch_local(a)
uSint a;
{
  uHint x;

  x = (uHint)a;
  return x;
}

static Hint
trunch_reuse(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  x = (Hint)x;
  return x;
}

static Hint
trunch_add(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a + b);
  return x;
}

static Hint
trunch_sub(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a - b);
  return x;
}

static Hint
trunch_mul(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a * b);
  return x;
}

static Hint
trunch_neg(a)
Sint a;
{
  Hint x;

  x = (Hint)-a;
  return x;
}

static Hint
trunch_xor(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a ^ b);
  return x;
}

static Hint
trunch_or(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a | b);
  return x;
}

static Hint
trunch_and(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a & b);
  return x;
}

static Hint
trunch_shift_left(a)
Sint a;
{
  Hint x;

  x = (Hint)(a << 1);
  return x;
}

static Hint
trunch_shift_right(a)
Sint a;
{
  Hint x;

  x = (Hint)(a >> 1);
  return x;
}

static Hint
trunch_call()
{
  Hint x;

  x = (Hint)f();
  return x;
}

static uHint
utrunch_call()
{
  uHint x;

  x = (uHint)uf();
  return x;
}

/*
 * Constants and boundary masks.
 */

static Hint
trunch_const_zero()
{
  return (Hint)0;
}

static Hint
trunch_const_one()
{
  return (Hint)1;
}

static Hint
trunch_const_177777()
{
  return (Hint)0177777;
}

static Hint
trunch_const_377777()
{
  return (Hint)0377777;
}

static Hint
trunch_const_400000()
{
  return (Hint)0400000;
}

static Hint
trunch_const_777777()
{
  return (Hint)0777777;
}

static Hint
trunch_const_1000000()
{
  return (Hint)01000000;
}

static Hint
trunch_const_full()
{
  return (Hint)0123456123456;
}

static Hint
trunch_const_minus_one()
{
  return (Hint)-1;
}

static Hint
trunch_const_minus_small()
{
  return (Hint)-012345;
}

static uHint
utrunch_const_777777()
{
  return (uHint)0777777;
}

static uHint
utrunch_const_1000000()
{
  return (uHint)01000000;
}

static uHint
utrunch_const_full()
{
  return (uHint)0123456123456;
}

/*
 * Memory and global sources narrowed to HI registers.
 */

static Hint
trunch_mem(p)
Sint *p;
{
  Hint x;

  x = (Hint)*p;
  return x;
}

static Hint
trunch_umem(p)
uSint *p;
{
  Hint x;

  x = (Hint)*p;
  return x;
}

static uHint
utrunch_umem(p)
uSint *p;
{
  uHint x;

  x = (uHint)*p;
  return x;
}

static Hint
trunch_volatile_mem(p)
volatile Sint *p;
{
  Hint x;

  x = (Hint)*p;
  return x;
}

static Hint
trunch_global()
{
  Hint x;

  x = (Hint)trunch_ga;
  return x;
}

static Hint
trunch_global_b()
{
  Hint x;

  x = (Hint)trunch_gb;
  return x;
}

static Hint
trunch_volatile_global()
{
  Hint x;

  x = (Hint)trunch_vga;
  return x;
}

static uHint
utrunch_global()
{
  uHint x;

  x = (uHint)trunch_uga;
  return x;
}

static uHint
utrunch_volatile_global()
{
  uHint x;

  x = (uHint)trunch_vuga;
  return x;
}

static Hint
trunch_array(i)
Sint i;
{
  Hint x;

  x = (Hint)trunch_sbuf[i & 017];
  return x;
}

static Hint
trunch_uarray(i)
Sint i;
{
  Hint x;

  x = (Hint)trunch_usbuf[i & 017];
  return x;
}

static uHint
utrunch_uarray(i)
Sint i;
{
  uHint x;

  x = (uHint)trunch_usbuf[i & 017];
  return x;
}

static Hint
trunch_ptr_array(p, i)
Sint *p;
Sint i;
{
  Hint x;

  x = (Hint)p[i & 017];
  return x;
}

static Hint
trunch_struct_a(p)
struct trunch_sipair *p;
{
  Hint x;

  x = (Hint)p->a;
  return x;
}

static Hint
trunch_struct_b(p)
struct trunch_sipair *p;
{
  Hint x;

  x = (Hint)p->b;
  return x;
}

static Hint
trunch_global_struct_a()
{
  Hint x;

  x = (Hint)trunch_sgp.a;
  return x;
}

static Hint
trunch_global_struct_b()
{
  Hint x;

  x = (Hint)trunch_sgp.b;
  return x;
}

/*
 * Store forms: narrowing SImode values into HImode memory.
 */

static void
trunch_store_global(a)
Sint a;
{
  trunch_ha = (Hint)a;
}

static void
trunch_store_global_u(a)
uSint a;
{
  trunch_uha = (uHint)a;
}

static void
trunch_store_volatile_global(a)
Sint a;
{
  trunch_vha = (Hint)a;
}

static void
trunch_store_volatile_global_u(a)
uSint a;
{
  trunch_vuha = (uHint)a;
}

static void
trunch_store_ptr(dst, a)
Hint *dst;
Sint a;
{
  *dst = (Hint)a;
}

static void
trunch_store_uptr(dst, a)
uHint *dst;
uSint a;
{
  *dst = (uHint)a;
}

static void
trunch_store_array(i, a)
Sint i;
Sint a;
{
  trunch_hbuf[i & 017] = (Hint)a;
}

static void
trunch_store_uarray(i, a)
Sint i;
uSint a;
{
  trunch_uhbuf[i & 017] = (uHint)a;
}

static void
trunch_store_struct_a(p, a)
struct trunch_pair *p;
Sint a;
{
  p->a = (Hint)a;
}

static void
trunch_store_struct_b(p, a)
struct trunch_pair *p;
Sint a;
{
  p->b = (Hint)a;
}

static void
trunch_store_ustruct_a(p, a)
struct truncuh_pair *p;
uSint a;
{
  p->a = (uHint)a;
}

static void
trunch_store_ustruct_b(p, a)
struct truncuh_pair *p;
uSint a;
{
  p->b = (uHint)a;
}

/*
 * Store with returned narrowed result.
 */

static Hint
trunch_store_global_return(a)
Sint a;
{
  return trunch_ha = (Hint)a;
}

static uHint
trunch_store_global_u_return(a)
uSint a;
{
  return trunch_uha = (uHint)a;
}

static Hint
trunch_store_ptr_return(dst, a)
Hint *dst;
Sint a;
{
  return *dst = (Hint)a;
}

static uHint
trunch_store_uptr_return(dst, a)
uHint *dst;
uSint a;
{
  return *dst = (uHint)a;
}

static Hint
trunch_store_array_return(i, a)
Sint i;
Sint a;
{
  return trunch_hbuf[i & 017] = (Hint)a;
}

static uHint
trunch_store_uarray_return(i, a)
Sint i;
uSint a;
{
  return trunch_uhbuf[i & 017] = (uHint)a;
}

/*
 * Narrowing after expression, then widening again.  These make the
 * truncation observable while still returning SImode.
 */

static Sint
trunch_to_sint(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x;
}

static uSint
utrunch_to_usint(a)
uSint a;
{
  uHint x;

  x = (uHint)a;
  return x;
}

static Sint
trunch_add_to_sint(a, b)
Sint a;
Sint b;
{
  Hint x;

  x = (Hint)(a + b);
  return x;
}

static uSint
utrunch_add_to_usint(a, b)
uSint a;
uSint b;
{
  uHint x;

  x = (uHint)(a + b);
  return x;
}

static Sint
trunch_mask_then_sint(a)
Sint a;
{
  Hint x;

  x = (Hint)(a & 0777777);
  return x;
}

static Sint
trunch_full_then_sint(a)
Sint a;
{
  Hint x;

  x = (Hint)(a ^ 0123456123456);
  return x;
}

static uSint
utrunch_full_then_usint(a)
uSint a;
{
  uHint x;

  x = (uHint)(a ^ 0123456123456);
  return x;
}

/*
 * In-place HI update forms.  These combine load, widen, arithmetic,
 * truncation, and store.
 */

static void
trunch_inc_global(a)
Sint a;
{
  trunch_ha = (Hint)(trunch_ha + a);
}

static Hint
trunch_inc_global_return(a)
Sint a;
{
  return trunch_ha = (Hint)(trunch_ha + a);
}

static void
trunch_sub_global(a)
Sint a;
{
  trunch_ha = (Hint)(trunch_ha - a);
}

static Hint
trunch_sub_global_return(a)
Sint a;
{
  return trunch_ha = (Hint)(trunch_ha - a);
}

static void
trunch_xor_global(a)
Sint a;
{
  trunch_ha = (Hint)(trunch_ha ^ a);
}

static Hint
trunch_xor_global_return(a)
Sint a;
{
  return trunch_ha = (Hint)(trunch_ha ^ a);
}

static void
trunch_inc_ptr(p, a)
Hint *p;
Sint a;
{
  *p = (Hint)(*p + a);
}

static Hint
trunch_inc_ptr_return(p, a)
Hint *p;
Sint a;
{
  return *p = (Hint)(*p + a);
}

static void
trunch_inc_array(i, a)
Sint i;
Sint a;
{
  trunch_hbuf[i & 017] = (Hint)(trunch_hbuf[i & 017] + a);
}

static Hint
trunch_inc_array_return(i, a)
Sint i;
Sint a;
{
  return trunch_hbuf[i & 017] = (Hint)(trunch_hbuf[i & 017] + a);
}

/*
 * Branch and compare uses after truncation.
 */

static Sint
trunch_eq_zero(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x == 0;
}

static Sint
trunch_ne_zero(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x != 0;
}

static Sint
trunch_lt_zero(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x < 0;
}

static Sint
trunch_ge_zero(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x >= 0;
}

static Sint
trunch_eq_177777(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x == 0177777;
}

static Sint
trunch_eq_minus_one(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x == -1;
}

static Sint
utrunch_gt_400000(a)
uSint a;
{
  uHint x;

  x = (uHint)a;
  return x > 0400000;
}

static Sint
trunch_range(a)
Sint a;
{
  Hint x;
  Sint y;

  x = (Hint)a;
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

static Hint
trunch_after_call(p)
Sint *p;
{
  Sint x;
  Hint y;

  x = *p;
  clobber();
  y = (Hint)x;
  return y;
}

static Hint
trunch_call_after_load(p)
Sint *p;
{
  Sint x;
  Hint y;

  x = *p;
  clobber();
  y = (Hint)(x + f());
  return y;
}

static void
trunch_store_after_call(p)
Hint *p;
{
  Sint x;

  x = f();
  clobber();
  *p = (Hint)x;
}

static Sint
trunch_global_after_call()
{
  Hint x;

  clobber();
  x = (Hint)trunch_ga;
  return x;
}
