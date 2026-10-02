#include "insns.h"

/*
 * ASH instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   ASH AC,count
 *   ASH AC,(index)
 *   ASH AC,@mem
 *   ASH AC,disp(index)
 *
 * C signed right shift maps to arithmetic shift right.  The backend
 * represents right shifts as ASH with a negative count.  Signed left
 * shift is deliberately not the focus here: the current backend emits
 * LSH for SI left shifts, so those cases belong in LSH.c and in the
 * ashlsi3 pattern test.
 */

struct ash_struct {
  Sint a;
  Sint b;
  Sint c;
} *p;

static Sint
ash_const_0(a)
Sint a;
{
  return a >> 0;
}

static Sint
ash_const_1(a)
Sint a;
{
  return a >> 1;
}

static Sint
ash_const_2(a)
Sint a;
{
  return a >> 2;
}

static Sint
ash_const_8(a)
Sint a;
{
  return a >> 8;
}

static Sint
ash_const_9(a)
Sint a;
{
  return a >> 9;
}

static Sint
ash_const_17(a)
Sint a;
{
  return a >> 17;
}

static Sint
ash_const_18(a)
Sint a;
{
  return a >> 18;
}

static Sint
ash_const_27(a)
Sint a;
{
  return a >> 27;
}

static Sint
ash_const_35(a)
Sint a;
{
  return a >> 35;
}

static Sint
ash_var(a, n)
Sint a;
Sint n;
{
  return a >> n;
}

static Sint
ash_var_neg_count(a, n)
Sint a;
Sint n;
{
  return a >> (-n);
}

static Sint
ash_var_plus_1(a, n)
Sint a;
Sint n;
{
  return a >> (n + 1);
}

static Sint
ash_var_minus_1(a, n)
Sint a;
Sint n;
{
  return a >> (n - 1);
}

static Sint
ash_one_plus_var(a, n)
Sint a;
Sint n;
{
  return a >> (1 + n);
}

static Sint
ash_one_minus_var(a, n)
Sint a;
Sint n;
{
  return a >> (1 - n);
}

static Sint
ash_masked_count(a, n)
Sint a;
uSint n;
{
  return a >> (n & 077);
}

static Sint
ash_masked_count_small(a, n)
Sint a;
uSint n;
{
  return a >> (n & 035);
}

static Sint
ash_count_from_mem(a, p)
Sint a;
Sint *p;
{
  return a >> *p;
}

static Sint
ash_count_from_mem_neg(a, p)
Sint a;
Sint *p;
{
  return a >> (-*p);
}

static Sint
ash_count_from_mem_plus(a, p)
Sint a;
Sint *p;
{
  return a >> (*p + 1);
}

static Sint
ash_value_from_mem(p, n)
Sint *p;
Sint n;
{
  return *p >> n;
}

static Sint
ash_value_and_count_from_mem(p, q)
Sint *p;
Sint *q;
{
  return *p >> *q;
}

static Sint
ash_store_result(dst, a, n)
Sint *dst;
Sint a;
Sint n;
{
  *dst = a >> n;
  return *dst;
}

static void
ash_store_void(dst, a, n)
Sint *dst;
Sint a;
Sint n;
{
  *dst = a >> n;
}

static Sint
ash_assign_local(a, n, m)
Sint a;
Sint n;
Sint m;
{
  a >>= n;
  a >>= m;
  return a;
}

static Sint
ash_assign_mem(p, n)
Sint *p;
Sint n;
{
  *p >>= n;
  return *p;
}

static Sint
ash_volatile_value(p, n)
volatile Sint *p;
Sint n;
{
  return *p >> n;
}

static Sint
ash_volatile_count(a, p)
Sint a;
volatile Sint *p;
{
  return a >> *p;
}

static void
ash_volatile_store(p, a, n)
volatile Sint *p;
Sint a;
Sint n;
{
  *p = a >> n;
}

static Sint
ash_qi_signed(a, n)
sQint a;
Sint n;
{
  return a >> n;
}

static Sint
ash_hi_signed(a, n)
Hint a;
Sint n;
{
  return a >> n;
}

static Sint
ash_qi_signed_const(a)
sQint a;
{
  return a >> 1;
}

static Sint
ash_hi_signed_const(a)
Hint a;
{
  return a >> 1;
}

static Sint
ash_sign_extend_9(a)
Sint a;
{
  return (a << 27) >> 27;
}

static Sint
ash_sign_extend_18(a)
Sint a;
{
  return (a << 18) >> 18;
}

static Sint
ash_extract_top_half(a)
Sint a;
{
  return a >> 18;
}

static Sint
ash_extract_top_byte(a)
Sint a;
{
  return a >> 27;
}

static Sint
ash_negative_literal_1(void)
{
  return ((Sint)-1) >> 1;
}

static Sint
ash_negative_literal_18(void)
{
  return ((Sint)-1) >> 18;
}

static Sint
ash_signbit_literal(void)
{
  return ((Sint)0400000000000) >> 35;
}

static Sint
ash_large_positive_literal(void)
{
  return ((Sint)0377777777777) >> 35;
}

static Sint
ash_with_add(a, b, n)
Sint a;
Sint b;
Sint n;
{
  return (a + b) >> n;
}

static Sint
ash_with_sub(a, b, n)
Sint a;
Sint b;
Sint n;
{
  return (a - b) >> n;
}

static Sint
ash_with_and(a, n)
Sint a;
Sint n;
{
  return (a & 0777777777777) >> n;
}

static Sint
ash_two_results(a, n)
Sint a;
Sint n;
{
  Sint x;
  Sint y;

  x = a >> n;
  y = a >> (n + 1);
  return x + y;
}

static Sint
ash_call_pressure(a, n)
Sint a;
Sint n;
{
  extern void clobber(void);
  Sint x;

  x = a >> n;
  clobber();
  return x + (a >> 1);
}

static Sint
ash_array_value(v, i, n)
Sint *v;
Sint i;
Sint n;
{
  return v[i & 7] >> n;
}

static Sint
ash_array_count(a, v, i)
Sint a;
Sint *v;
Sint i;
{
  return a >> v[i & 7];
}

static Sint
ash_struct_value(p, n)
struct ash_struct *p;
Sint n;
{
  return p->b >> n;
}

static Sint
ash_struct_count(a, p)
Sint a;
struct ash_struct *p;
{
  return a >> p->c;
}
