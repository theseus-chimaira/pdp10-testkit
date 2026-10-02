/* flag: -mlong-long-71bit */
#include "insns.h"

/*
 * DIV instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   DIV   double-word dividend in AC,AC+1 divided by register/memory
 *   DIVI  double-word dividend divided by small immediate
 *   DIV   double-word dividend divided by literal-pool constant
 *   DIVM  quotient stored into the divisor/result memory operand
 *
 * This is intentionally not the generic Sint / Sint divsi3 test.
 * IDIV covers ordinary single-word signed division.  This file targets
 * the PDP-10 DIV shape used by the 71-bit Dint path.
 *
 * DIVB is not covered here because the current backend says it is
 * missing.
 */

struct div_struct {
  Sint a;
  Sint b;
  Sint c;
};

struct div_divisor_struct {
  Sint a;
  Sint b;
  Sint c;
};

static Sint
div_reg(ac12, y)
Dint ac12;
Sint y;
{
  return (Sint)(ac12 / y);
}

static Sint
div_mem(ac12, y)
Dint ac12;
Sint *y;
{
  return (Sint)(ac12 / *y);
}

static Sint
div_volatile_mem(ac12, y)
Dint ac12;
volatile Sint *y;
{
  return (Sint)(ac12 / *y);
}

static Sint
divi_small(ac12)
Dint ac12;
{
  return (Sint)(ac12 / 0123456);
}

static Sint
divi_one(ac12)
Dint ac12;
{
  return (Sint)(ac12 / 1);
}

static Sint
divi_two(ac12)
Dint ac12;
{
  return (Sint)(ac12 / 2);
}

static Sint
divi_max18(ac12)
Dint ac12;
{
  return (Sint)(ac12 / 0777777);
}

static Sint
div_literal(ac12)
Dint ac12;
{
  return (Sint)(ac12 / 0123456123456);
}

static Sint
div_literal_2(ac12)
Dint ac12;
{
  return (Sint)(ac12 / 0377777000000);
}

static Sint
div_literal_neg(ac12)
Dint ac12;
{
  return (Sint)(ac12 / -0123456123);
}

static Sint
div_reg_from_mem(p, y)
Dint *p;
Sint y;
{
  return (Sint)(*p / y);
}

static Sint
div_mem_mem(p, y)
Dint *p;
Sint *y;
{
  return (Sint)(*p / *y);
}

static Sint
div_store(dst, ac12, y)
Sint *dst;
Dint ac12;
Sint y;
{
  *dst = (Sint)(ac12 / y);
  return *dst;
}

static void
div_store_void(dst, ac12, y)
Sint *dst;
Dint ac12;
Sint y;
{
  *dst = (Sint)(ac12 / y);
}

static Sint
div_assign_local(ac12, y, z)
Dint ac12;
Sint y;
Sint z;
{
  Sint q;

  q = (Sint)(ac12 / y);
  q = (Sint)(((Dint)q) / z);
  return q;
}

static Sint
div_with_add(ac12, y, addend)
Dint ac12;
Sint y;
Sint addend;
{
  return (Sint)(ac12 / y) + addend;
}

static Sint
div_with_sub(ac12, y, subtrahend)
Dint ac12;
Sint y;
Sint subtrahend;
{
  return (Sint)(ac12 / y) - subtrahend;
}

static Sint
div_with_mul(ac12, y, mul)
Dint ac12;
Sint y;
Sint mul;
{
  return (Sint)(ac12 / y) * mul;
}

static Sint
div_quot_rem_sum(ac12, y)
Dint ac12;
Sint y;
{
  Sint q;
  Sint r;

  q = (Sint)(ac12 / y);
  r = (Sint)(ac12 % y);
  return q + r;
}

static Sint
div_quot_rem_mem(ac12, y)
Dint ac12;
Sint *y;
{
  Sint q;
  Sint r;

  q = (Sint)(ac12 / *y);
  r = (Sint)(ac12 % *y);
  return q + r;
}

static Sint
div_quot_rem_const(ac12)
Dint ac12;
{
  Sint q;
  Sint r;

  q = (Sint)(ac12 / 0123456);
  r = (Sint)(ac12 % 0123456);
  return q + r;
}

static Sint
div_quot_rem_literal(ac12)
Dint ac12;
{
  Sint q;
  Sint r;

  q = (Sint)(ac12 / 0123456123456);
  r = (Sint)(ac12 % 0123456123456);
  return q + r;
}

static Sint
div_rem_only(ac12, y)
Dint ac12;
Sint y;
{
  return (Sint)(ac12 % y);
}

static Sint
div_rem_mem_only(ac12, y)
Dint ac12;
Sint *y;
{
  return (Sint)(ac12 % *y);
}

static Sint
div_rem_const_only(ac12)
Dint ac12;
{
  return (Sint)(ac12 % 0123456);
}

static Sint
divm_mem(ac12, y)
Dint ac12;
Sint *y;
{
  *y = (Sint)(ac12 / *y);
  return *y;
}

static void
divm_mem_void(ac12, y)
Dint ac12;
Sint *y;
{
  *y = (Sint)(ac12 / *y);
}

static Sint
divm_volatile_mem(ac12, y)
Dint ac12;
volatile Sint *y;
{
  *y = (Sint)(ac12 / *y);
  return *y;
}

static Sint
divm_array(ac12, v, i)
Dint ac12;
Sint *v;
Sint i;
{
  Sint *p;

  p = &v[i & 7];
  *p = (Sint)(ac12 / *p);
  return *p;
}

static Sint
divm_struct(ac12, p)
Dint ac12;
struct div_struct *p;
{
  p->b = (Sint)(ac12 / p->b);
  return p->b;
}

static Sint
div_array_divisor(ac12, v, i)
Dint ac12;
Sint *v;
Sint i;
{
  return (Sint)(ac12 / v[i & 7]);
}

static Sint
div_struct_divisor(ac12, p)
Dint ac12;
struct div_divisor_struct *p;
{
  return (Sint)(ac12 / p->c);
}

static Sint
div_call_pressure(ac12, y)
Dint ac12;
Sint y;
{
  extern void clobber(void);
  Sint q;

  q = (Sint)(ac12 / y);
  clobber();
  return q + y;
}

static Sint
div_two_divs(ac12, y, z)
Dint ac12;
Sint y;
Sint z;
{
  Sint q0;
  Sint q1;

  q0 = (Sint)(ac12 / y);
  q1 = (Sint)(ac12 / z);
  return q0 + q1;
}

static Sint
div_two_mem_divs(ac12, y, z)
Dint ac12;
Sint *y;
Sint *z;
{
  Sint q0;
  Sint q1;

  q0 = (Sint)(ac12 / *y);
  q1 = (Sint)(ac12 / *z);
  return q0 + q1;
}

static Sint
div_nested(ac12, y, z)
Dint ac12;
Sint y;
Sint z;
{
  Dint q;

  q = (Dint)(Sint)(ac12 / y);
  return (Sint)(q / z);
}

static Sint
div_from_sint_widen(a, b, y)
Sint a;
Sint b;
Sint y;
{
  Dint ac12;

  ac12 = ((Dint)a << 18) + b;
  return (Sint)(ac12 / y);
}

static Sint
div_from_uint_widen(a, b, y)
uSint a;
uSint b;
Sint y;
{
  Dint ac12;

  ac12 = ((Dint)a << 18) + b;
  return (Sint)(ac12 / y);
}

static Sint
div_small_signed_inputs(a, b, y)
Hint a;
sQint b;
Sint y;
{
  Dint ac12;

  ac12 = ((Dint)a << 9) + b;
  return (Sint)(ac12 / y);
}

static Sint
div_small_unsigned_inputs(a, b, y)
uHint a;
uQint b;
Sint y;
{
  Dint ac12;

  ac12 = ((Dint)a << 9) + b;
  return (Sint)(ac12 / y);
}
