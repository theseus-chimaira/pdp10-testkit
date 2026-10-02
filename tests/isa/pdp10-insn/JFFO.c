/* flag: -O2 */
#include "insns.h"

/*
 * JFFO coverage for KA10.
 *
 * PDP-6 is unsupp in the matrix.  KA10 has JFFO.
 *
 * This is intentionally GCC-only backend/builtin coverage.
 * The backend exposes two related builtins:
 *
 *   int  __builtin_pdp10_jffo(unsigned int value)
 *        returns the JFFO bit number, or -1 for zero.
 *
 *   void __builtin_jffo(long long value, void *label)
 *        historical jump-form primitive.
 *
 * Cover both.  The value-returning form forces the backend helper to
 * emit the zero case explicitly because hardware JFFO only writes AC+1
 * when the input is nonzero.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

#define JFFO_JUMP(V, LABEL) __builtin_jffo((V), &&LABEL)

struct jffo_struct {
  uSint a;
  uSint b;
  uSint c;
} *p;

static Sint
jffo_reg(x)
uSint x;
{
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_mem(p)
uSint *p;
{
  uSint x;

  x = *p;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_volatile_mem(p)
volatile uSint *p;
{
  uSint x;

  x = *p;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_zero(x)
uSint x;
{
  x &= 0;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_low_bit(x)
uSint x;
{
  x |= 1;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_sign_bit(x)
uSint x;
{
  x |= 0400000000000;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_low_9(x)
uSint x;
{
  x &= 0777;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_low_18(x)
uSint x;
{
  x &= 0777777;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_high_18(x)
uSint x;
{
  x &= 0777777000000;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_literal_small(void)
{
  uSint x;

  x = 0123456;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_literal_big(void)
{
  uSint x;

  x = 0123456123456;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_literal_sparse(void)
{
  uSint x;

  x = 0525252252525;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_or(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a | b;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_and(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a & b;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_xor(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_complement(x)
uSint x;
{
  x = ~x;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_shift_left(x, n)
uSint x;
Sint n;
{
  x = x << (n & 017);
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_shift_right(x, n)
uSint x;
Sint n;
{
  x = x >> (n & 017);
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_add(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a + b;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_sub(a, b)
uSint a;
uSint b;
{
  uSint x;

  x = a - b;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_isolated_lowbit(x)
uSint x;
{
  x = x & -x;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_qi_unsigned(x)
uQint x;
{
  uSint y;

  y = x;
  OPAQUE_REG(y);
  return __builtin_pdp10_jffo(y);
}

static Sint
jffo_qi_signed(x)
sQint x;
{
  uSint y;

  y = (uSint)x;
  OPAQUE_REG(y);
  return __builtin_pdp10_jffo(y);
}

static Sint
jffo_hi_unsigned(x)
uHint x;
{
  uSint y;

  y = x;
  OPAQUE_REG(y);
  return __builtin_pdp10_jffo(y);
}

static Sint
jffo_hi_signed(x)
Hint x;
{
  uSint y;

  y = (uSint)x;
  OPAQUE_REG(y);
  return __builtin_pdp10_jffo(y);
}

static Sint
jffo_array(v, i)
uSint *v;
Sint i;
{
  uSint x;

  x = v[i & 7];
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_struct(p)
struct jffo_struct *p;
{
  uSint x;

  x = p->b;
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_store(dst, x)
Sint *dst;
uSint x;
{
  OPAQUE_REG(x);
  *dst = __builtin_pdp10_jffo(x);
  return *dst;
}

static void
jffo_store_void(dst, x)
Sint *dst;
uSint x;
{
  OPAQUE_REG(x);
  *dst = __builtin_pdp10_jffo(x);
}

static Sint
jffo_branch_zero(x)
uSint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_pdp10_jffo(x);
  if (r < 0)
    return 0;
  return r;
}

static Sint
jffo_branch_nonzero(x)
uSint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_pdp10_jffo(x);
  if (r >= 0)
    return r + 1;
  return -1;
}

static Sint
jffo_compare_low(x)
uSint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_pdp10_jffo(x);
  if (r <= 9)
    return r;
  return 0;
}

static Sint
jffo_compare_high(x)
uSint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_pdp10_jffo(x);
  if (r > 18)
    return r;
  return 0;
}

static Sint
jffo_two_values(a, b)
uSint a;
uSint b;
{
  Sint x;
  Sint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  x = __builtin_pdp10_jffo(a);
  y = __builtin_pdp10_jffo(b);

  return x + y;
}

static Sint
jffo_call_pressure(x)
uSint x;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_pdp10_jffo(x);
  clobber();

  return r + (Sint)x;
}

static Sint
jffo_loop(v, n)
uSint *v;
Sint n;
{
  Sint i;
  Sint r;
  uSint x;

  r = 0;
  for (i = 0; i < n; ++i) {
    x = v[i & 7];
    OPAQUE_REG(x);
    r += __builtin_pdp10_jffo(x);
  }

  return r;
}

static Sint
jffo_nested_expr(a, b, c)
uSint a;
uSint b;
uSint c;
{
  uSint x;

  x = (a & -a) | ((b ^ c) & 0777777);
  OPAQUE_REG(x);
  return __builtin_pdp10_jffo(x);
}

static Sint
jffo_jump_form_zero(x)
uSint x;
{
  Dint d;

  x &= 0;
  OPAQUE_REG(x);
  d = (Dint)x;

  JFFO_JUMP(d, nonzero);
  return 0;

nonzero:
  return 1;
}

static Sint
jffo_jump_form_nonzero(x)
uSint x;
{
  Dint d;

  x |= 1;
  OPAQUE_REG(x);
  d = (Dint)x;

  JFFO_JUMP(d, nonzero);
  return 0;

nonzero:
  return 1;
}

static Sint
jffo_jump_form_reg(x)
uSint x;
{
  Dint d;

  OPAQUE_REG(x);
  d = (Dint)x;

  JFFO_JUMP(d, nonzero);
  return -1;

nonzero:
  return 1;
}

static Sint
jffo_jump_form_mem(p)
uSint *p;
{
  Dint d;
  uSint x;

  x = *p;
  OPAQUE_REG(x);
  d = (Dint)x;

  JFFO_JUMP(d, nonzero);
  return -1;

nonzero:
  return 1;
}

static Sint
jffo_jump_form_dint(d)
Dint d;
{
  JFFO_JUMP(d, nonzero);
  return -1;

nonzero:
  return 1;
}

static Sint
jffo_jump_form_dint_mem(p)
Dint *p;
{
  Dint d;

  d = *p;
  JFFO_JUMP(d, nonzero);
  return -1;

nonzero:
  return 1;
}

static Sint
jffo_jump_form_two_labels(a, b)
uSint a;
uSint b;
{
  Dint da;
  Dint db;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  da = (Dint)a;
  db = (Dint)b;

  JFFO_JUMP(da, a_nonzero);
  JFFO_JUMP(db, b_nonzero);
  return 0;

a_nonzero:
  JFFO_JUMP(db, both_nonzero);
  return 1;

b_nonzero:
  return 2;

both_nonzero:
  return 3;
}
