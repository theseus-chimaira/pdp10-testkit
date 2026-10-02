#include "insns.h"

/*
 * Zero-extension QImode to SImode pattern pressure.
 *
 * Intended pattern:
 *   zero_extendqisi2
 *
 * Ordinary C shape:
 *
 *   uQint q;
 *   uSint s;
 *
 *   s = q;
 *   return s;
 *
 * Keep this file unsigned-QI only.  Signed QImode extension belongs to
 * extendqisi2.c.  HImode zero-extension belongs to zero_extendhisi2.c.
 *
 * Do not use inline assembly here.
 */

extern uQint uqfunc(void);
extern void clobber(void);

static uQint zxqisi_ga;
static uQint zxqisi_gb;
static volatile uQint zxqisi_vga;
static uQint zxqisi_buf[16];

static uSint zxqisi_sga;
static volatile uSint zxqisi_vsga;
static uSint zxqisi_sbuf[16];

struct zxqisi_pair {
  uQint a;
  uQint b;
};

struct zxqisi_three {
  uQint a;
  uQint b;
  uQint c;
};

static struct zxqisi_pair zxqisi_gp;
static struct zxqisi_three zxqisi_gt;

/*
 * Original skeleton shape, kept with the expected basename.
 */

uSint
zero_extendqisi2(a)
uQint a;
{
  return a;
}

/*
 * Basic register-result forms.
 */

static uSint
zxqisi_arg(a)
uQint a;
{
  return a;
}

static uSint
zxqisi_second_arg(a, b)
uQint a;
uQint b;
{
  return b;
}

static uSint
zxqisi_local(a)
uQint a;
{
  uSint x;

  x = a;
  return x;
}

static uSint
zxqisi_reuse(a)
uQint a;
{
  uSint x;

  x = a;
  x += 0;
  return x;
}

static uSint
zxqisi_plus(a, b)
uQint a;
uSint b;
{
  uSint x;

  x = a;
  return x + b;
}

static uSint
zxqisi_minus(a, b)
uQint a;
uSint b;
{
  uSint x;

  x = a;
  return x - b;
}

static uSint
zxqisi_xor(a, b)
uQint a;
uSint b;
{
  uSint x;

  x = a;
  return x ^ b;
}

static uSint
zxqisi_or(a, b)
uQint a;
uSint b;
{
  uSint x;

  x = a;
  return x | b;
}

static uSint
zxqisi_and(a, b)
uQint a;
uSint b;
{
  uSint x;

  x = a;
  return x & b;
}

static uSint
zxqisi_shift_left(a)
uQint a;
{
  uSint x;

  x = a;
  return x << 1;
}

static uSint
zxqisi_shift_right(a)
uQint a;
{
  uSint x;

  x = a;
  return x >> 1;
}

/*
 * Memory, globals, arrays, structs, and volatile sources.
 */

static uSint
zxqisi_mem(p)
uQint *p;
{
  return *p;
}

static uSint
zxqisi_mem_local(p)
uQint *p;
{
  uSint x;

  x = *p;
  return x;
}

static uSint
zxqisi_mem_plus(p, b)
uQint *p;
uSint b;
{
  uSint x;

  x = *p;
  return x + b;
}

static uSint
zxqisi_mem_xor(p, b)
uQint *p;
uSint b;
{
  uSint x;

  x = *p;
  return x ^ b;
}

static uSint
zxqisi_volatile_mem(p)
volatile uQint *p;
{
  return *p;
}

static uSint
zxqisi_volatile_mem_local(p)
volatile uQint *p;
{
  uSint x;

  x = *p;
  return x;
}

static uSint
zxqisi_global()
{
  return zxqisi_ga;
}

static uSint
zxqisi_global_b()
{
  return zxqisi_gb;
}

static uSint
zxqisi_volatile_global()
{
  return zxqisi_vga;
}

static uSint
zxqisi_global_after_call()
{
  uQint x;

  x = uqfunc();
  zxqisi_ga = x;
  clobber();
  return zxqisi_ga;
}

static uSint
zxqisi_array(i)
Sint i;
{
  return zxqisi_buf[i & 017];
}

static uSint
zxqisi_array_local(i)
Sint i;
{
  uSint x;

  x = zxqisi_buf[i & 017];
  return x;
}

static uSint
zxqisi_array_plus(i, b)
Sint i;
uSint b;
{
  uSint x;

  x = zxqisi_buf[i & 017];
  return x + b;
}

static uSint
zxqisi_ptr_array(p, i)
uQint *p;
Sint i;
{
  return p[i & 017];
}

static uSint
zxqisi_struct_a(p)
struct zxqisi_pair *p;
{
  return p->a;
}

static uSint
zxqisi_struct_b(p)
struct zxqisi_pair *p;
{
  return p->b;
}

static uSint
zxqisi_struct_index(p, i)
struct zxqisi_three *p;
Sint i;
{
  if (i & 1)
    return p->b;
  return p->c;
}

static uSint
zxqisi_global_struct_a()
{
  return zxqisi_gp.a;
}

static uSint
zxqisi_global_struct_b()
{
  return zxqisi_gp.b;
}

static uSint
zxqisi_global_struct_c()
{
  return zxqisi_gt.c;
}

/*
 * Store promoted zero-extended values into SImode destinations.
 */

static void
zxqisi_store_global(a)
uQint a;
{
  zxqisi_sga = a;
}

static void
zxqisi_store_volatile_global(a)
uQint a;
{
  zxqisi_vsga = a;
}

static void
zxqisi_store_ptr(dst, a)
uSint *dst;
uQint a;
{
  *dst = a;
}

static void
zxqisi_store_array(i, a)
Sint i;
uQint a;
{
  zxqisi_sbuf[i & 017] = a;
}

static void
zxqisi_store_from_mem(dst, src)
uSint *dst;
uQint *src;
{
  *dst = *src;
}

static void
zxqisi_store_from_volatile(dst, src)
uSint *dst;
volatile uQint *src;
{
  *dst = *src;
}

/*
 * Constants and truncation-before-zero-extension cases.
 */

static uSint
zxqisi_const_zero()
{
  uQint x;

  x = (uQint)0;
  return x;
}

static uSint
zxqisi_const_one()
{
  uQint x;

  x = (uQint)1;
  return x;
}

static uSint
zxqisi_const_377()
{
  uQint x;

  x = (uQint)0377;
  return x;
}

static uSint
zxqisi_const_400()
{
  uQint x;

  x = (uQint)0400;
  return x;
}

static uSint
zxqisi_const_777()
{
  uQint x;

  x = (uQint)0777;
  return x;
}

static uSint
zxqisi_from_sint(a)
uSint a;
{
  uQint x;

  x = (uQint)a;
  return x;
}

static uSint
zxqisi_from_sint_plus(a, b)
uSint a;
uSint b;
{
  uQint x;
  uSint y;

  x = (uQint)(a + b);
  y = x;
  return y;
}

static uSint
zxqisi_from_negative(a)
Sint a;
{
  uQint x;

  x = (uQint)a;
  return x;
}

/*
 * Branch and compare uses after zero-extension.
 */

static Sint
zxqisi_eq_zero(a)
uQint a;
{
  uSint x;

  x = a;
  return x == 0;
}

static Sint
zxqisi_ne_zero(a)
uQint a;
{
  uSint x;

  x = a;
  return x != 0;
}

static Sint
zxqisi_lt_400(a)
uQint a;
{
  uSint x;

  x = a;
  return x < 0400;
}

static Sint
zxqisi_gt_400(a)
uQint a;
{
  uSint x;

  x = a;
  return x > 0400;
}

static Sint
zxqisi_mem_eq(p)
uQint *p;
{
  uSint x;

  x = *p;
  return x == 0777;
}

static Sint
zxqisi_mem_range(p)
uQint *p;
{
  uSint x;

  x = *p;
  if (x < 0100)
    return -1;
  if (x > 0677)
    return 1;
  return 0;
}

/*
 * Mixed expression pressure.
 */

static uSint
zxqisi_sum3(a, b, c)
uQint a;
uQint b;
uQint c;
{
  uSint x;
  uSint y;
  uSint z;

  x = a;
  y = b;
  z = c;
  return x + y + z;
}

static uSint
zxqisi_sum_mem3(p)
uQint *p;
{
  uSint a;
  uSint b;
  uSint c;

  a = p[0];
  b = p[1];
  c = p[2];
  return a + b + c;
}

static uSint
zxqisi_mix(a, p, i)
uQint a;
uQint *p;
Sint i;
{
  uSint x;
  uSint y;
  uSint z;

  x = a;
  y = p[i & 017];
  z = zxqisi_buf[(i + 1) & 017];
  return (x << 2) ^ (y + z);
}

static uSint
zxqisi_call()
{
  return uqfunc();
}

static uSint
zxqisi_call_local()
{
  uQint x;
  uSint y;

  x = uqfunc();
  y = x;
  return y;
}
