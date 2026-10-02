#include "insns.h"

/*
 * SETCA instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SETCA   AC <- ~AC
 *   SETCAM  memory <- ~AC
 *   SETCAB  AC and memory both receive ~AC
 *
 * SETCAI exists as an instruction variant, but normal C has no useful
 * way to distinguish it from SETCA because the effective address field
 * is ignored by the operation.  Keep this file focused on complementing
 * the accumulator-like operand.  Memory-source complement belongs more
 * naturally to SETCM.
 */

static Sint setca_ga;
static Sint setca_gb;
static uSint setca_uga;
static Sint setca_buf[16];

struct setca_pair {
  Sint a;
  Sint b;
};

static struct setca_pair setca_gp;

static Sint
setca_reg(a)
Sint a;
{
  return ~a;
}

static Sint
setca_reg_plus(a, b)
Sint a;
Sint b;
{
  a += b;
  return ~a;
}

static Sint
setca_reg_xor(a, b)
Sint a;
Sint b;
{
  a ^= b;
  return ~a;
}

static Sint
setca_reg_and(a, b)
Sint a;
Sint b;
{
  a &= b;
  return ~a;
}

static Sint
setca_reg_or(a, b)
Sint a;
Sint b;
{
  a |= b;
  return ~a;
}

static Sint
setca_global_value(void)
{
  Sint a;

  a = setca_ga;
  return ~a;
}

static Sint
setca_array_value(i)
Sint i;
{
  Sint a;

  a = setca_buf[i & 017];
  return ~a;
}

static Sint
setca_struct_a(p)
struct setca_pair *p;
{
  Sint a;

  a = p->a;
  return ~a;
}

static Sint
setca_struct_b(p)
struct setca_pair *p;
{
  Sint a;

  a = p->b;
  return ~a;
}

static Sint
setca_global_struct_a(void)
{
  Sint a;

  a = setca_gp.a;
  return ~a;
}

static Sint
setca_global_struct_b(void)
{
  Sint a;

  a = setca_gp.b;
  return ~a;
}

static void
setcam_mem(a, x)
Sint a;
Sint *x;
{
  *x = ~a;
}

static void
setcam_global(a)
Sint a;
{
  setca_ga = ~a;
}

static void
setcam_global_b(a)
Sint a;
{
  setca_gb = ~a;
}

static void
setcam_array(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  v[i & 017] = ~a;
}

static void
setcam_global_array(a, i)
Sint a;
Sint i;
{
  setca_buf[i & 017] = ~a;
}

static void
setcam_struct_a(a, p)
Sint a;
struct setca_pair *p;
{
  p->a = ~a;
}

static void
setcam_struct_b(a, p)
Sint a;
struct setca_pair *p;
{
  p->b = ~a;
}

static void
setcam_from_expr(a, b, x)
Sint a;
Sint b;
Sint *x;
{
  a += b;
  *x = ~a;
}

static void
setcam_volatile(a, x)
Sint a;
volatile Sint *x;
{
  *x = ~a;
}

static Sint
setcam_return_original(a, x)
Sint a;
Sint *x;
{
  *x = ~a;
  return a;
}

static Sint
setcam_return_loaded(a, x)
Sint a;
Sint *x;
{
  *x = ~a;
  return *x;
}

static Sint
setcab_mem_return(a, x)
Sint a;
Sint *x;
{
  *x = ~a;
  return *x;
}

static Sint
setcab_global_return(a)
Sint a;
{
  setca_ga = ~a;
  return setca_ga;
}

static Sint
setcab_array_return(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  v[i & 017] = ~a;
  return v[i & 017];
}

static Sint
setcab_struct_a_return(a, p)
Sint a;
struct setca_pair *p;
{
  p->a = ~a;
  return p->a;
}

static Sint
setcab_struct_b_return(a, p)
Sint a;
struct setca_pair *p;
{
  p->b = ~a;
  return p->b;
}

static uSint
usetca_reg(a)
uSint a;
{
  return ~a;
}

static uSint
usetca_reg_plus(a, b)
uSint a;
uSint b;
{
  a += b;
  return ~a;
}

static void
usetcam_mem(a, x)
uSint a;
uSint *x;
{
  *x = ~a;
}

static void
usetcam_global(a)
uSint a;
{
  setca_uga = ~a;
}

static uSint
usetcab_mem_return(a, x)
uSint a;
uSint *x;
{
  *x = ~a;
  return *x;
}

static Sint
setca_qi(a)
sQint a;
{
  return ~a;
}

static Sint
setca_uqi(a)
uQint a;
{
  return ~a;
}

static Sint
setca_hi(a)
Hint a;
{
  return ~a;
}

static Sint
setca_uhi(a)
uHint a;
{
  return ~a;
}

static void
setcam_qi(a, x)
sQint a;
Sint *x;
{
  *x = ~a;
}

static void
setcam_uqi(a, x)
uQint a;
Sint *x;
{
  *x = ~a;
}

static void
setcam_hi(a, x)
Hint a;
Sint *x;
{
  *x = ~a;
}

static void
setcam_uhi(a, x)
uHint a;
Sint *x;
{
  *x = ~a;
}

static Sint
setca_chain(a, b)
Sint a;
Sint b;
{
  a = ~a;
  b = ~b;
  return a ^ b;
}

static Sint
setca_double(a)
Sint a;
{
  return ~~a;
}

BOTH (setcab_reg_mem, ~a)
BOTH1 (uSint, usetcab_reg_mem, ~a)
