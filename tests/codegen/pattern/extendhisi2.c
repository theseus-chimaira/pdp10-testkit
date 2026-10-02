#include "insns.h"

/*
 * Signed HImode to SImode extension pattern pressure.
 *
 * Intended pattern:
 *   extendhisi2
 *
 * PDP-6/KA10-relevant backend forms:
 *   - HRRE for register HImode sign-extension
 *   - HRRE from scalar signed short memory
 *
 * Keep this file signed-HI only.  Unsigned HImode zero-extension
 * belongs to zero_extendhisi2.c.  QImode sign-extension belongs to
 * extendqisi2.c.
 *
 * Do not use inline assembly here.
 */

extern Hint hfunc(void);
extern uHint uhfunc(void);
extern void clobber(void);

static Hint exthisi_ga;
static Hint exthisi_gb;
static volatile Hint exthisi_vga;
static Hint exthisi_buf[16];

static Sint exthisi_sga;
static volatile Sint exthisi_vsga;
static Sint exthisi_sbuf[16];

static uHint exthisi_uga;
static uHint exthisi_ubuf[16];

struct exthisi_pair {
  Hint a;
  Hint b;
};

struct exthisi_three {
  Hint a;
  Hint b;
  Hint c;
};

struct extuhisi_pair {
  uHint a;
  uHint b;
};

static struct exthisi_pair exthisi_gp;
static struct exthisi_three exthisi_gt;
static struct extuhisi_pair exthisi_ugp;

/*
 * Original expected basename shape.
 */

Sint
extendhisi2(a)
Hint a;
{
  return a;
}

/*
 * Basic register-result forms.
 */

static Sint
exthisi_arg(a)
Hint a;
{
  return a;
}

static Sint
exthisi_second_arg(a, b)
Hint a;
Hint b;
{
  return b;
}

static Sint
exthisi_local(a)
Hint a;
{
  Sint x;

  x = a;
  return x;
}

static Sint
exthisi_reuse(a)
Hint a;
{
  Sint x;

  x = a;
  x += 0;
  return x;
}

static Sint
exthisi_plus(a, b)
Hint a;
Sint b;
{
  Sint x;

  x = a;
  return x + b;
}

static Sint
exthisi_minus(a, b)
Hint a;
Sint b;
{
  Sint x;

  x = a;
  return x - b;
}

static Sint
exthisi_xor(a, b)
Hint a;
Sint b;
{
  Sint x;

  x = a;
  return x ^ b;
}

static Sint
exthisi_or(a, b)
Hint a;
Sint b;
{
  Sint x;

  x = a;
  return x | b;
}

static Sint
exthisi_and(a, b)
Hint a;
Sint b;
{
  Sint x;

  x = a;
  return x & b;
}

static Sint
exthisi_shift_left(a)
Hint a;
{
  Sint x;

  x = a;
  return x << 1;
}

static Sint
exthisi_shift_right(a)
Hint a;
{
  Sint x;

  x = a;
  return x >> 1;
}

static Sint
exthisi_neg(a)
Hint a;
{
  Sint x;

  x = a;
  return -x;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
exthisi_mem(p)
Hint *p;
{
  return *p;
}

static Sint
exthisi_mem_local(p)
Hint *p;
{
  Sint x;

  x = *p;
  return x;
}

static Sint
exthisi_mem_plus(p, b)
Hint *p;
Sint b;
{
  Sint x;

  x = *p;
  return x + b;
}

static Sint
exthisi_mem_xor(p, b)
Hint *p;
Sint b;
{
  Sint x;

  x = *p;
  return x ^ b;
}

static Sint
exthisi_volatile_mem(p)
volatile Hint *p;
{
  return *p;
}

static Sint
exthisi_volatile_mem_local(p)
volatile Hint *p;
{
  Sint x;

  x = *p;
  return x;
}

static Sint
exthisi_global()
{
  return exthisi_ga;
}

static Sint
exthisi_global_b()
{
  return exthisi_gb;
}

static Sint
exthisi_volatile_global()
{
  return exthisi_vga;
}

static Sint
exthisi_global_after_call()
{
  Hint x;

  x = hfunc();
  exthisi_ga = x;
  clobber();
  return exthisi_ga;
}

static Sint
exthisi_array(i)
Sint i;
{
  return exthisi_buf[i & 017];
}

static Sint
exthisi_array_local(i)
Sint i;
{
  Sint x;

  x = exthisi_buf[i & 017];
  return x;
}

static Sint
exthisi_array_plus(i, b)
Sint i;
Sint b;
{
  Sint x;

  x = exthisi_buf[i & 017];
  return x + b;
}

static Sint
exthisi_ptr_array(p, i)
Hint *p;
Sint i;
{
  return p[i & 017];
}

static Sint
exthisi_struct_a(p)
struct exthisi_pair *p;
{
  return p->a;
}

static Sint
exthisi_struct_b(p)
struct exthisi_pair *p;
{
  return p->b;
}

static Sint
exthisi_struct_two(p)
struct exthisi_pair *p;
{
  return p->a + p->b;
}

static Sint
exthisi_struct_index(p, i)
struct exthisi_three *p;
Sint i;
{
  if (i & 1)
    return p->b;
  return p->c;
}

static Sint
exthisi_global_struct_a()
{
  return exthisi_gp.a;
}

static Sint
exthisi_global_struct_b()
{
  return exthisi_gp.b;
}

static Sint
exthisi_global_struct_c()
{
  return exthisi_gt.c;
}

/*
 * Store promoted sign-extended values into SImode destinations.
 */

static void
exthisi_store_global(a)
Hint a;
{
  exthisi_sga = a;
}

static void
exthisi_store_volatile_global(a)
Hint a;
{
  exthisi_vsga = a;
}

static void
exthisi_store_ptr(dst, a)
Sint *dst;
Hint a;
{
  *dst = a;
}

static void
exthisi_store_array(i, a)
Sint i;
Hint a;
{
  exthisi_sbuf[i & 017] = a;
}

static void
exthisi_store_from_mem(dst, src)
Sint *dst;
Hint *src;
{
  *dst = *src;
}

static void
exthisi_store_from_volatile(dst, src)
Sint *dst;
volatile Hint *src;
{
  *dst = *src;
}

/*
 * Constants and truncation-before-sign-extension cases.
 */

static Sint
exthisi_const_zero()
{
  Hint x;

  x = (Hint)0;
  return x;
}

static Sint
exthisi_const_one()
{
  Hint x;

  x = (Hint)1;
  return x;
}

static Sint
exthisi_const_177777()
{
  Hint x;

  x = (Hint)0177777;
  return x;
}

static Sint
exthisi_const_377777()
{
  Hint x;

  x = (Hint)0377777;
  return x;
}

static Sint
exthisi_const_400000()
{
  Hint x;

  x = (Hint)0400000;
  return x;
}

static Sint
exthisi_const_777777()
{
  Hint x;

  x = (Hint)0777777;
  return x;
}

static Sint
exthisi_const_minus_one()
{
  Hint x;

  x = (Hint)-1;
  return x;
}

static Sint
exthisi_const_minus_small()
{
  Hint x;

  x = (Hint)-012345;
  return x;
}

static Sint
exthisi_from_sint(a)
Sint a;
{
  Hint x;

  x = (Hint)a;
  return x;
}

static Sint
exthisi_from_uint(a)
uSint a;
{
  Hint x;

  x = (Hint)a;
  return x;
}

static Sint
exthisi_from_sint_plus(a, b)
Sint a;
Sint b;
{
  Hint x;
  Sint y;

  x = (Hint)(a + b);
  y = x;
  return y;
}

static Sint
exthisi_from_negative(a)
Sint a;
{
  Hint x;

  x = (Hint)-a;
  return x;
}

/*
 * Explicit unsigned-halfword-to-signed-halfword paths.  These pressure
 * conversion from a known 18-bit value into signed HImode, then to SI.
 */

static Sint
exthisi_from_uh_arg(a)
uHint a;
{
  Hint x;

  x = (Hint)a;
  return x;
}

static Sint
exthisi_from_uh_mem(p)
uHint *p;
{
  Hint x;

  x = (Hint)*p;
  return x;
}

static Sint
exthisi_from_uh_global()
{
  Hint x;

  x = (Hint)exthisi_uga;
  return x;
}

static Sint
exthisi_from_uh_array(i)
Sint i;
{
  Hint x;

  x = (Hint)exthisi_ubuf[i & 017];
  return x;
}

static Sint
exthisi_from_uh_struct(p)
struct extuhisi_pair *p;
{
  Hint x;

  x = (Hint)p->b;
  return x;
}

static Sint
exthisi_from_mask(a)
Sint a;
{
  Hint x;

  x = (Hint)(a & 0777777);
  return x;
}

static Sint
exthisi_from_mask_plus(a)
Sint a;
{
  Hint x;

  x = (Hint)((a + 0123) & 0777777);
  return x;
}

static Sint
exthisi_from_call()
{
  Hint x;

  x = hfunc();
  return x;
}

static Sint
exthisi_from_uh_call()
{
  Hint x;

  x = (Hint)uhfunc();
  return x;
}

/*
 * Branch and compare uses after sign-extension.
 */

static Sint
exthisi_eq_zero(a)
Hint a;
{
  Sint x;

  x = a;
  return x == 0;
}

static Sint
exthisi_ne_zero(a)
Hint a;
{
  Sint x;

  x = a;
  return x != 0;
}

static Sint
exthisi_lt_zero(a)
Hint a;
{
  Sint x;

  x = a;
  return x < 0;
}

static Sint
exthisi_ge_zero(a)
Hint a;
{
  Sint x;

  x = a;
  return x >= 0;
}

static Sint
exthisi_lt_200000(a)
Hint a;
{
  Sint x;

  x = a;
  return x < 0200000;
}

static Sint
exthisi_gt_200000(a)
Hint a;
{
  Sint x;

  x = a;
  return x > 0200000;
}

static Sint
exthisi_mem_eq(p)
Hint *p;
{
  Sint x;

  x = *p;
  return x == -1;
}

static Sint
exthisi_mem_range(p)
Hint *p;
{
  Sint x;

  x = *p;
  if (x < -0100)
    return -1;
  if (x > 0100)
    return 1;
  return 0;
}

/*
 * Mixed expression pressure.
 */

static Sint
exthisi_sum3(a, b, c)
Hint a;
Hint b;
Hint c;
{
  Sint x;
  Sint y;
  Sint z;

  x = a;
  y = b;
  z = c;
  return x + y + z;
}

static Sint
exthisi_sum_mem3(p)
Hint *p;
{
  Sint a;
  Sint b;
  Sint c;

  a = p[0];
  b = p[1];
  c = p[2];
  return a + b + c;
}

static Sint
exthisi_mix(a, p, i)
Hint a;
Hint *p;
Sint i;
{
  Sint x;
  Sint y;
  Sint z;

  x = a;
  y = p[i & 017];
  z = exthisi_buf[(i + 1) & 017];
  return (x << 2) ^ (y + z);
}

static Sint
exthisi_unsigned_mix(a, p, i)
uHint a;
uHint *p;
Sint i;
{
  Hint x;
  Hint y;
  Hint z;
  Sint sx;
  Sint sy;
  Sint sz;

  x = (Hint)a;
  y = (Hint)p[i & 017];
  z = (Hint)exthisi_ubuf[(i + 1) & 017];
  sx = x;
  sy = y;
  sz = z;
  return sx + sy - sz;
}

static Sint
exthisi_store_then_use(p, a)
Hint *p;
Hint a;
{
  Sint x;

  *p = a;
  x = *p;
  return x;
}

static Sint
exthisi_call_local()
{
  Hint x;
  Sint y;

  x = hfunc();
  y = x;
  return y;
}
