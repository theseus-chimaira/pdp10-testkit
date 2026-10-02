#include "insns.h"

/*
 * FFS coverage for KA10.
 *
 * PDP-6 is marked unsupp in the matrix.  KA10 has no native FFS opcode;
 * the backend expands __builtin_ffs through a JFFO-based sequence:
 *
 *   t = x & -x
 *   JFFO t,...
 *
 * So this file tests the compiler-visible FFS operation, not an actual
 * KA10 FFS instruction.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

struct ffs_struct {
  Sint a;
  Sint b;
  Sint c;
} *p;

static Sint
ffs_reg(x)
Sint x;
{
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_mem(p)
Sint *p;
{
  Sint x;

  x = *p;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_volatile_mem(p)
volatile Sint *p;
{
  Sint x;

  x = *p;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_unsigned_reg(x)
uSint x;
{
  OPAQUE_REG(x);
  return __builtin_ffs((Sint)x);
}

static Sint
ffs_unsigned_mem(p)
uSint *p;
{
  uSint x;

  x = *p;
  OPAQUE_REG(x);
  return __builtin_ffs((Sint)x);
}

static Sint
ffs_zero_value(x)
Sint x;
{
  x &= 0;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_low_bit(x)
Sint x;
{
  x |= 1;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_low_9_bits(x)
Sint x;
{
  x &= 0777;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_low_18_bits(x)
Sint x;
{
  x &= 0777777;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_high_18_bits(x)
Sint x;
{
  x &= 0777777000000;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_sign_bit(x)
Sint x;
{
  x |= 0400000000000;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_shift_left(x, n)
Sint x;
Sint n;
{
  x = x << (n & 017);
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_shift_right(x, n)
Sint x;
Sint n;
{
  x = x >> (n & 017);
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_isolated_lowbit(x)
Sint x;
{
  x = x & -x;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_complement(x)
Sint x;
{
  x = ~x;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_xor(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a ^ b;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_or(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a | b;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_and(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a & b;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_add(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a + b;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_sub(a, b)
Sint a;
Sint b;
{
  Sint x;

  x = a - b;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_qi_signed(x)
sQint x;
{
  Sint y;

  y = x;
  OPAQUE_REG(y);
  return __builtin_ffs(y);
}

static Sint
ffs_qi_unsigned(x)
uQint x;
{
  Sint y;

  y = x;
  OPAQUE_REG(y);
  return __builtin_ffs(y);
}

static Sint
ffs_hi_signed(x)
Hint x;
{
  Sint y;

  y = x;
  OPAQUE_REG(y);
  return __builtin_ffs(y);
}

static Sint
ffs_hi_unsigned(x)
uHint x;
{
  Sint y;

  y = x;
  OPAQUE_REG(y);
  return __builtin_ffs(y);
}

static Sint
ffs_array(v, i)
Sint *v;
Sint i;
{
  Sint x;

  x = v[i & 7];
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_struct(p)
struct ffs_struct *p;
{
  Sint x;

  x = p->b;
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}

static Sint
ffs_store(dst, x)
Sint *dst;
Sint x;
{
  OPAQUE_REG(x);
  *dst = __builtin_ffs(x);
  return *dst;
}

static void
ffs_store_void(dst, x)
Sint *dst;
Sint x;
{
  OPAQUE_REG(x);
  *dst = __builtin_ffs(x);
}

static Sint
ffs_branch_zero(x)
Sint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_ffs(x);
  if (r == 0)
    return 1;
  return r;
}

static Sint
ffs_branch_nonzero(x)
Sint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_ffs(x);
  if (r != 0)
    return r + 1;
  return 0;
}

static Sint
ffs_compare_low(x)
Sint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_ffs(x);
  if (r <= 9)
    return r;
  return 0;
}

static Sint
ffs_compare_high(x)
Sint x;
{
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_ffs(x);
  if (r > 18)
    return r;
  return 0;
}

static Sint
ffs_two_values(a, b)
Sint a;
Sint b;
{
  Sint x;
  Sint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  x = __builtin_ffs(a);
  y = __builtin_ffs(b);

  return x + y;
}

static Sint
ffs_call_pressure(x)
Sint x;
{
  extern void clobber(void);
  Sint r;

  OPAQUE_REG(x);
  r = __builtin_ffs(x);
  clobber();

  return r + x;
}

static Sint
ffs_loop(v, n)
Sint *v;
Sint n;
{
  Sint i;
  Sint r;
  Sint x;

  r = 0;
  for (i = 0; i < n; ++i) {
    x = v[i & 7];
    OPAQUE_REG(x);
    r += __builtin_ffs(x);
  }

  return r;
}

static Sint
ffs_nested_expr(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;

  x = (a & -a) | ((b ^ c) & 0777777);
  OPAQUE_REG(x);
  return __builtin_ffs(x);
}
