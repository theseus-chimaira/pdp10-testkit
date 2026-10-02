#include "insns.h"

/*
 * Signed QImode to SImode extension pattern pressure.
 *
 * Intended pattern:
 *   extendqisi2
 *
 * PDP-6/KA10-relevant backend forms:
 *   - register/subreg sign extension
 *   - TRNE/ORCMI sequence for already zero-extended 9-bit values
 *   - LSH/ASH sequence for general 9-bit sign extension
 *
 * Do not expect XKL2 EXTEND [SEXT 9] in this scope.
 *
 * Keep this file signed-QI only.  Unsigned QImode zero-extension
 * belongs to zero_extendqisi2.c.  HImode sign-extension belongs to
 * extendhisi2.c.
 *
 * Do not use inline assembly here.
 */

extern Qint qfunc(void);
extern uQint uqfunc(void);
extern void clobber(void);

static Qint extqisi_ga;
static Qint extqisi_gb;
static volatile Qint extqisi_vga;
static Qint extqisi_buf[16];

static Sint extqisi_sga;
static volatile Sint extqisi_vsga;
static Sint extqisi_sbuf[16];

static uQint extqisi_uga;
static uQint extqisi_ubuf[16];

struct extqisi_pair {
  Qint a;
  Qint b;
};

struct extqisi_three {
  Qint a;
  Qint b;
  Qint c;
};

struct extuqisi_pair {
  uQint a;
  uQint b;
};

static struct extqisi_pair extqisi_gp;
static struct extqisi_three extqisi_gt;
static struct extuqisi_pair extqisi_ugp;

/*
 * Original expected basename shape.
 */

Sint
extendqisi2(a)
Qint a;
{
  return a;
}

/*
 * Basic register-result forms.
 */

static Sint
extqisi_arg(a)
Qint a;
{
  return a;
}

static Sint
extqisi_second_arg(a, b)
Qint a;
Qint b;
{
  return b;
}

static Sint
extqisi_local(a)
Qint a;
{
  Sint x;

  x = a;
  return x;
}

static Sint
extqisi_reuse(a)
Qint a;
{
  Sint x;

  x = a;
  x += 0;
  return x;
}

static Sint
extqisi_plus(a, b)
Qint a;
Sint b;
{
  Sint x;

  x = a;
  return x + b;
}

static Sint
extqisi_minus(a, b)
Qint a;
Sint b;
{
  Sint x;

  x = a;
  return x - b;
}

static Sint
extqisi_xor(a, b)
Qint a;
Sint b;
{
  Sint x;

  x = a;
  return x ^ b;
}

static Sint
extqisi_or(a, b)
Qint a;
Sint b;
{
  Sint x;

  x = a;
  return x | b;
}

static Sint
extqisi_and(a, b)
Qint a;
Sint b;
{
  Sint x;

  x = a;
  return x & b;
}

static Sint
extqisi_shift_left(a)
Qint a;
{
  Sint x;

  x = a;
  return x << 1;
}

static Sint
extqisi_shift_right(a)
Qint a;
{
  Sint x;

  x = a;
  return x >> 1;
}

static Sint
extqisi_neg(a)
Qint a;
{
  Sint x;

  x = a;
  return -x;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static Sint
extqisi_mem(p)
Qint *p;
{
  return *p;
}

static Sint
extqisi_mem_local(p)
Qint *p;
{
  Sint x;

  x = *p;
  return x;
}

static Sint
extqisi_mem_plus(p, b)
Qint *p;
Sint b;
{
  Sint x;

  x = *p;
  return x + b;
}

static Sint
extqisi_mem_xor(p, b)
Qint *p;
Sint b;
{
  Sint x;

  x = *p;
  return x ^ b;
}

static Sint
extqisi_volatile_mem(p)
volatile Qint *p;
{
  return *p;
}

static Sint
extqisi_volatile_mem_local(p)
volatile Qint *p;
{
  Sint x;

  x = *p;
  return x;
}

static Sint
extqisi_global()
{
  return extqisi_ga;
}

static Sint
extqisi_global_b()
{
  return extqisi_gb;
}

static Sint
extqisi_volatile_global()
{
  return extqisi_vga;
}

static Sint
extqisi_global_after_call()
{
  Qint x;

  x = qfunc();
  extqisi_ga = x;
  clobber();
  return extqisi_ga;
}

static Sint
extqisi_array(i)
Sint i;
{
  return extqisi_buf[i & 017];
}

static Sint
extqisi_array_local(i)
Sint i;
{
  Sint x;

  x = extqisi_buf[i & 017];
  return x;
}

static Sint
extqisi_array_plus(i, b)
Sint i;
Sint b;
{
  Sint x;

  x = extqisi_buf[i & 017];
  return x + b;
}

static Sint
extqisi_ptr_array(p, i)
Qint *p;
Sint i;
{
  return p[i & 017];
}

static Sint
extqisi_struct_a(p)
struct extqisi_pair *p;
{
  return p->a;
}

static Sint
extqisi_struct_b(p)
struct extqisi_pair *p;
{
  return p->b;
}

static Sint
extqisi_struct_two(p)
struct extqisi_pair *p;
{
  return p->a + p->b;
}

static Sint
extqisi_struct_index(p, i)
struct extqisi_three *p;
Sint i;
{
  if (i & 1)
    return p->b;
  return p->c;
}

static Sint
extqisi_global_struct_a()
{
  return extqisi_gp.a;
}

static Sint
extqisi_global_struct_b()
{
  return extqisi_gp.b;
}

static Sint
extqisi_global_struct_c()
{
  return extqisi_gt.c;
}

/*
 * Store promoted sign-extended values into SImode destinations.
 */

static void
extqisi_store_global(a)
Qint a;
{
  extqisi_sga = a;
}

static void
extqisi_store_volatile_global(a)
Qint a;
{
  extqisi_vsga = a;
}

static void
extqisi_store_ptr(dst, a)
Sint *dst;
Qint a;
{
  *dst = a;
}

static void
extqisi_store_array(i, a)
Sint i;
Qint a;
{
  extqisi_sbuf[i & 017] = a;
}

static void
extqisi_store_from_mem(dst, src)
Sint *dst;
Qint *src;
{
  *dst = *src;
}

static void
extqisi_store_from_volatile(dst, src)
Sint *dst;
volatile Qint *src;
{
  *dst = *src;
}

/*
 * Constants and truncation-before-sign-extension cases.
 */

static Sint
extqisi_const_zero()
{
  Qint x;

  x = (Qint)0;
  return x;
}

static Sint
extqisi_const_one()
{
  Qint x;

  x = (Qint)1;
  return x;
}

static Sint
extqisi_const_177()
{
  Qint x;

  x = (Qint)0177;
  return x;
}

static Sint
extqisi_const_377()
{
  Qint x;

  x = (Qint)0377;
  return x;
}

static Sint
extqisi_const_400()
{
  Qint x;

  x = (Qint)0400;
  return x;
}

static Sint
extqisi_const_777()
{
  Qint x;

  x = (Qint)0777;
  return x;
}

static Sint
extqisi_const_minus_one()
{
  Qint x;

  x = (Qint)-1;
  return x;
}

static Sint
extqisi_const_minus_small()
{
  Qint x;

  x = (Qint)-0123;
  return x;
}

static Sint
extqisi_from_sint(a)
Sint a;
{
  Qint x;

  x = (Qint)a;
  return x;
}

static Sint
extqisi_from_uint(a)
uSint a;
{
  Qint x;

  x = (Qint)a;
  return x;
}

static Sint
extqisi_from_sint_plus(a, b)
Sint a;
Sint b;
{
  Qint x;
  Sint y;

  x = (Qint)(a + b);
  y = x;
  return y;
}

static Sint
extqisi_from_negative(a)
Sint a;
{
  Qint x;

  x = (Qint)-a;
  return x;
}

/*
 * Explicit zero-extended-to-signed paths.  These are intended to
 * pressure the TRNE/ORCMI form when the backend can prove the input is
 * already a zero-extended 9-bit value.
 */

static Sint
extqisi_from_uq_arg(a)
uQint a;
{
  Qint x;

  x = (Qint)a;
  return x;
}

static Sint
extqisi_from_uq_mem(p)
uQint *p;
{
  Qint x;

  x = (Qint)*p;
  return x;
}

static Sint
extqisi_from_uq_global()
{
  Qint x;

  x = (Qint)extqisi_uga;
  return x;
}

static Sint
extqisi_from_uq_array(i)
Sint i;
{
  Qint x;

  x = (Qint)extqisi_ubuf[i & 017];
  return x;
}

static Sint
extqisi_from_uq_struct(p)
struct extuqisi_pair *p;
{
  Qint x;

  x = (Qint)p->b;
  return x;
}

static Sint
extqisi_from_mask(a)
Sint a;
{
  Qint x;

  x = (Qint)(a & 0777);
  return x;
}

static Sint
extqisi_from_mask_plus(a)
Sint a;
{
  Qint x;

  x = (Qint)((a + 0123) & 0777);
  return x;
}

static Sint
extqisi_from_call()
{
  Qint x;

  x = qfunc();
  return x;
}

static Sint
extqisi_from_uq_call()
{
  Qint x;

  x = (Qint)uqfunc();
  return x;
}

/*
 * Branch and compare uses after sign-extension.
 */

static Sint
extqisi_eq_zero(a)
Qint a;
{
  Sint x;

  x = a;
  return x == 0;
}

static Sint
extqisi_ne_zero(a)
Qint a;
{
  Sint x;

  x = a;
  return x != 0;
}

static Sint
extqisi_lt_zero(a)
Qint a;
{
  Sint x;

  x = a;
  return x < 0;
}

static Sint
extqisi_ge_zero(a)
Qint a;
{
  Sint x;

  x = a;
  return x >= 0;
}

static Sint
extqisi_lt_200(a)
Qint a;
{
  Sint x;

  x = a;
  return x < 0200;
}

static Sint
extqisi_gt_200(a)
Qint a;
{
  Sint x;

  x = a;
  return x > 0200;
}

static Sint
extqisi_mem_eq(p)
Qint *p;
{
  Sint x;

  x = *p;
  return x == -1;
}

static Sint
extqisi_mem_range(p)
Qint *p;
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
extqisi_sum3(a, b, c)
Qint a;
Qint b;
Qint c;
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
extqisi_sum_mem3(p)
Qint *p;
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
extqisi_mix(a, p, i)
Qint a;
Qint *p;
Sint i;
{
  Sint x;
  Sint y;
  Sint z;

  x = a;
  y = p[i & 017];
  z = extqisi_buf[(i + 1) & 017];
  return (x << 2) ^ (y + z);
}

static Sint
extqisi_unsigned_mix(a, p, i)
uQint a;
uQint *p;
Sint i;
{
  Qint x;
  Qint y;
  Qint z;
  Sint sx;
  Sint sy;
  Sint sz;

  x = (Qint)a;
  y = (Qint)p[i & 017];
  z = (Qint)extqisi_ubuf[(i + 1) & 017];
  sx = x;
  sy = y;
  sz = z;
  return sx + sy - sz;
}

static Sint
extqisi_store_then_use(p, a)
Qint *p;
Qint a;
{
  Sint x;

  *p = a;
  x = *p;
  return x;
}

static Sint
extqisi_call_local()
{
  Qint x;
  Sint y;

  x = qfunc();
  y = x;
  return y;
}
