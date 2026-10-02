#include "insns.h"

/*
 * ASHC instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   ASHC AC,count
 *   ASHC AC,(index)
 *   ASHC AC,@mem
 *   ASHC AC,disp(index)
 *
 * This file targets signed Dint arithmetic shifts.  Right shifts must
 * preserve the sign.  Left shifts are included because the same ASHC
 * family handles double-word arithmetic shifting with positive counts.
 *
 * Keep logical double shifts in LSHC.c.
 */

struct ashc_struct {
  Dint a;
  Dint b;
  Sint c;
} *p;

static Dint
ashc_r_const_0(a)
Dint a;
{
  return a >> 0;
}

static Dint
ashc_r_const_1(a)
Dint a;
{
  return a >> 1;
}

static Dint
ashc_r_const_2(a)
Dint a;
{
  return a >> 2;
}

static Dint
ashc_r_const_8(a)
Dint a;
{
  return a >> 8;
}

static Dint
ashc_r_const_9(a)
Dint a;
{
  return a >> 9;
}

static Dint
ashc_r_const_17(a)
Dint a;
{
  return a >> 17;
}

static Dint
ashc_r_const_18(a)
Dint a;
{
  return a >> 18;
}

static Dint
ashc_r_const_35(a)
Dint a;
{
  return a >> 35;
}

static Dint
ashc_r_const_36(a)
Dint a;
{
  return a >> 36;
}

static Dint
ashc_r_const_37(a)
Dint a;
{
  return a >> 37;
}

static Dint
ashc_r_const_54(a)
Dint a;
{
  return a >> 54;
}

static Dint
ashc_r_const_70(a)
Dint a;
{
  return a >> 70;
}

static Dint
ashc_l_const_1(a)
Dint a;
{
  return a << 1;
}

static Dint
ashc_l_const_2(a)
Dint a;
{
  return a << 2;
}

static Dint
ashc_l_const_8(a)
Dint a;
{
  return a << 8;
}

static Dint
ashc_l_const_9(a)
Dint a;
{
  return a << 9;
}

static Dint
ashc_l_const_18(a)
Dint a;
{
  return a << 18;
}

static Dint
ashc_l_const_35(a)
Dint a;
{
  return a << 35;
}

static Dint
ashc_l_const_36(a)
Dint a;
{
  return a << 36;
}

static Dint
ashc_l_const_37(a)
Dint a;
{
  return a << 37;
}

static Dint
ashc_l_const_70(a)
Dint a;
{
  return a << 70;
}

static Dint
ashc_r_var(a, n)
Dint a;
Sint n;
{
  return a >> n;
}

static Dint
ashc_l_var(a, n)
Dint a;
Sint n;
{
  return a << n;
}

static Dint
ashc_r_var_neg_count(a, n)
Dint a;
Sint n;
{
  return a >> (-n);
}

static Dint
ashc_l_var_neg_count(a, n)
Dint a;
Sint n;
{
  return a << (-n);
}

static Dint
ashc_r_var_plus_1(a, n)
Dint a;
Sint n;
{
  return a >> (n + 1);
}

static Dint
ashc_r_var_minus_1(a, n)
Dint a;
Sint n;
{
  return a >> (n - 1);
}

static Dint
ashc_r_one_plus_var(a, n)
Dint a;
Sint n;
{
  return a >> (1 + n);
}

static Dint
ashc_r_one_minus_var(a, n)
Dint a;
Sint n;
{
  return a >> (1 - n);
}

static Dint
ashc_l_var_plus_1(a, n)
Dint a;
Sint n;
{
  return a << (n + 1);
}

static Dint
ashc_l_var_minus_1(a, n)
Dint a;
Sint n;
{
  return a << (n - 1);
}

static Dint
ashc_l_one_plus_var(a, n)
Dint a;
Sint n;
{
  return a << (1 + n);
}

static Dint
ashc_l_one_minus_var(a, n)
Dint a;
Sint n;
{
  return a << (1 - n);
}

static Dint
ashc_r_masked_count(a, n)
Dint a;
uSint n;
{
  return a >> (n & 077);
}

static Dint
ashc_l_masked_count(a, n)
Dint a;
uSint n;
{
  return a << (n & 077);
}

static Dint
ashc_r_small_masked_count(a, n)
Dint a;
uSint n;
{
  return a >> (n & 035);
}

static Dint
ashc_l_small_masked_count(a, n)
Dint a;
uSint n;
{
  return a << (n & 035);
}

static Dint
ashc_r_count_from_mem(a, p)
Dint a;
Sint *p;
{
  return a >> *p;
}

static Dint
ashc_l_count_from_mem(a, p)
Dint a;
Sint *p;
{
  return a << *p;
}

static Dint
ashc_r_count_from_mem_neg(a, p)
Dint a;
Sint *p;
{
  return a >> (-*p);
}

static Dint
ashc_l_count_from_mem_neg(a, p)
Dint a;
Sint *p;
{
  return a << (-*p);
}

static Dint
ashc_r_count_from_mem_plus(a, p)
Dint a;
Sint *p;
{
  return a >> (*p + 1);
}

static Dint
ashc_l_count_from_mem_plus(a, p)
Dint a;
Sint *p;
{
  return a << (*p + 1);
}

static Dint
ashc_r_value_from_mem(p, n)
Dint *p;
Sint n;
{
  return *p >> n;
}

static Dint
ashc_l_value_from_mem(p, n)
Dint *p;
Sint n;
{
  return *p << n;
}

static Dint
ashc_r_value_and_count_from_mem(p, q)
Dint *p;
Sint *q;
{
  return *p >> *q;
}

static Dint
ashc_l_value_and_count_from_mem(p, q)
Dint *p;
Sint *q;
{
  return *p << *q;
}

static Dint
ashc_r_store_result(dst, a, n)
Dint *dst;
Dint a;
Sint n;
{
  *dst = a >> n;
  return *dst;
}

static Dint
ashc_l_store_result(dst, a, n)
Dint *dst;
Dint a;
Sint n;
{
  *dst = a << n;
  return *dst;
}

static void
ashc_r_store_void(dst, a, n)
Dint *dst;
Dint a;
Sint n;
{
  *dst = a >> n;
}

static void
ashc_l_store_void(dst, a, n)
Dint *dst;
Dint a;
Sint n;
{
  *dst = a << n;
}

static Dint
ashc_r_assign_local(a, n, m)
Dint a;
Sint n;
Sint m;
{
  a >>= n;
  a >>= m;
  return a;
}

static Dint
ashc_l_assign_local(a, n, m)
Dint a;
Sint n;
Sint m;
{
  a <<= n;
  a <<= m;
  return a;
}

static Dint
ashc_r_assign_mem(p, n)
Dint *p;
Sint n;
{
  *p >>= n;
  return *p;
}

static Dint
ashc_l_assign_mem(p, n)
Dint *p;
Sint n;
{
  *p <<= n;
  return *p;
}

static Dint
ashc_r_volatile_value(p, n)
volatile Dint *p;
Sint n;
{
  return *p >> n;
}

static Dint
ashc_l_volatile_value(p, n)
volatile Dint *p;
Sint n;
{
  return *p << n;
}

static Dint
ashc_r_volatile_count(a, p)
Dint a;
volatile Sint *p;
{
  return a >> *p;
}

static Dint
ashc_l_volatile_count(a, p)
Dint a;
volatile Sint *p;
{
  return a << *p;
}

static void
ashc_r_volatile_store(p, a, n)
volatile Dint *p;
Dint a;
Sint n;
{
  *p = a >> n;
}

static void
ashc_l_volatile_store(p, a, n)
volatile Dint *p;
Dint a;
Sint n;
{
  *p = a << n;
}

static Dint
ashc_from_sint_r(a, n)
Sint a;
Sint n;
{
  return ((Dint)a) >> n;
}

static Dint
ashc_from_sint_l(a, n)
Sint a;
Sint n;
{
  return ((Dint)a) << n;
}

static Dint
ashc_from_uint_l(a, n)
uSint a;
Sint n;
{
  return ((Dint)a) << n;
}

static Dint
ashc_from_qi_r(a, n)
sQint a;
Sint n;
{
  return ((Dint)a) >> n;
}

static Dint
ashc_from_qi_l(a, n)
sQint a;
Sint n;
{
  return ((Dint)a) << n;
}

static Dint
ashc_from_hi_r(a, n)
Hint a;
Sint n;
{
  return ((Dint)a) >> n;
}

static Dint
ashc_from_hi_l(a, n)
Hint a;
Sint n;
{
  return ((Dint)a) << n;
}

static Dint
ashc_sign_extend_9(a)
Dint a;
{
  return (a << 63) >> 63;
}

static Dint
ashc_sign_extend_18(a)
Dint a;
{
  return (a << 54) >> 54;
}

static Dint
ashc_sign_extend_36(a)
Dint a;
{
  return (a << 36) >> 36;
}

static Dint
ashc_extract_high_word(a)
Dint a;
{
  return a >> 36;
}

static Dint
ashc_extract_high_half(a)
Dint a;
{
  return a >> 54;
}

static Dint
ashc_negative_literal_1(void)
{
  return ((Dint)-1) >> 1;
}

static Dint
ashc_negative_literal_36(void)
{
  return ((Dint)-1) >> 36;
}

static Dint
ashc_negative_literal_70(void)
{
  return ((Dint)-1) >> 70;
}

static Dint
ashc_one_l_35(void)
{
  return ((Dint)1) << 35;
}

static Dint
ashc_one_l_36(void)
{
  return ((Dint)1) << 36;
}

static Dint
ashc_one_l_70(void)
{
  return ((Dint)1) << 70;
}

static Dint
ashc_with_add(a, b, n)
Dint a;
Dint b;
Sint n;
{
  return (a + b) >> n;
}

static Dint
ashc_with_sub(a, b, n)
Dint a;
Dint b;
Sint n;
{
  return (a - b) >> n;
}

static Dint
ashc_left_with_add(a, b, n)
Dint a;
Dint b;
Sint n;
{
  return (a + b) << n;
}

static Dint
ashc_two_right_results(a, n)
Dint a;
Sint n;
{
  Dint x;
  Dint y;

  x = a >> n;
  y = a >> (n + 1);
  return x + y;
}

static Dint
ashc_two_left_results(a, n)
Dint a;
Sint n;
{
  Dint x;
  Dint y;

  x = a << n;
  y = a << (n + 1);
  return x + y;
}

static Dint
ashc_mixed_results(a, n)
Dint a;
Sint n;
{
  Dint x;
  Dint y;

  x = a >> n;
  y = a << (n + 1);
  return x + y;
}

static Dint
ashc_call_pressure(a, n)
Dint a;
Sint n;
{
  extern void clobber(void);
  Dint x;

  x = a >> n;
  clobber();
  return x + (a >> 1);
}

static Dint
ashc_left_call_pressure(a, n)
Dint a;
Sint n;
{
  extern void clobber(void);
  Dint x;

  x = a << n;
  clobber();
  return x + (a << 1);
}

static Dint
ashc_array_value(v, i, n)
Dint *v;
Sint i;
Sint n;
{
  return v[i & 7] >> n;
}

static Dint
ashc_array_count(a, v, i)
Dint a;
Sint *v;
Sint i;
{
  return a >> v[i & 7];
}

static Dint
ashc_left_array_value(v, i, n)
Dint *v;
Sint i;
Sint n;
{
  return v[i & 7] << n;
}

static Dint
ashc_left_array_count(a, v, i)
Dint a;
Sint *v;
Sint i;
{
  return a << v[i & 7];
}

static Dint
ashc_struct_value(p, n)
struct ashc_struct *p;
Sint n;
{
  return p->b >> n;
}

static Dint
ashc_struct_count(a, p)
Dint a;
struct ashc_struct *p;
{
  return a >> p->c;
}

static Dint
ashc_left_struct_value(p, n)
struct ashc_struct *p;
Sint n;
{
  return p->b << n;
}

static Dint
ashc_left_struct_count(a, p)
Dint a;
struct ashc_struct *p;
{
  return a << p->c;
}
