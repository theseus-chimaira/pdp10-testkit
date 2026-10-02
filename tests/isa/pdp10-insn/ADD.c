#include "insns.h"

/*
 * ADD instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms:
 *   ADD   register/memory and literal source additions
 *   ADDI  small positive immediate/address additions
 *   ADDM  memory destination update
 *   ADDB  update accumulator and memory with the same sum
 *
 * Keep this file integer-only.
 */

static Sint
add_reg_reg(a, y)
Sint a;
Sint y;
{
  return a + y;
}

static Sint
add_reg_mem(a, y)
Sint a;
Sint *y;
{
  return a + *y;
}

static Sint
add_mem_reg(y, a)
Sint *y;
Sint a;
{
  return *y + a;
}

static Sint
add_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return *a + *y;
}

static Sint
addi_small(a)
Sint a;
{
  return a + 0123456;
}

static Sint
addi_one(a)
Sint a;
{
  return a + 1;
}

static Sint
addi_max18(a)
Sint a;
{
  return a + 0777777;
}

static Sint
addi_mid18(a)
Sint a;
{
  return a + 0400000;
}

static Sint
add_literal(a)
Sint a;
{
  return a + 0123456123456;
}

static Sint
add_literal_left(a)
Sint a;
{
  return 0123456123456 + a;
}

static Sint
add_literal_high(a)
Sint a;
{
  return a + 0377777000000;
}

static void
addm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y += a;
}

static void
addm_mem_mem(dst, src)
Sint *dst;
Sint *src;
{
  *dst += *src;
}

static void
addm_const(dst)
Sint *dst;
{
  *dst += 0123456;
}

static Sint
addm_then_load(a, y)
Sint a;
Sint *y;
{
  *y += a;
  return *y;
}

static Sint
add_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  a += b;
  a += c;
  return a;
}

static uSint
uadd_reg_reg(a, y)
uSint a;
uSint y;
{
  return a + y;
}

static uSint
uadd_reg_mem(a, y)
uSint a;
uSint *y;
{
  return a + *y;
}

static uSint
uaddi_literal(a)
uSint a;
{
  return a + 0777777;
}

static Sint
add_qi_promote(a, b)
sQint a;
sQint b;
{
  return a + b;
}

static Sint
addu_qi_promote(a, b)
uQint a;
uQint b;
{
  return a + b;
}

static Sint
add_hi_promote(a, b)
Hint a;
Hint b;
{
  return a + b;
}

static Sint
addu_hi_promote(a, b)
uHint a;
uHint b;
{
  return a + b;
}

static Sint *
add_ptr_reg(p, n)
Sint *p;
Sint n;
{
  return p + n;
}

static Sint *
add_ptr_small(p)
Sint *p;
{
  return p + 0123456;
}

static Sint *
add_ptr_one(p)
Sint *p;
{
  return p + 1;
}

static Sint *
add_ptr_large(p)
Sint *p;
{
  return p + 01234561234;
}

static Sint
addi_index(a, idx)
Sint a;
Sint idx;
{
  return a + (idx & 0777777);
}

static Sint
addi_index_disp(a, idx)
Sint a;
Sint idx;
{
  return a + ((idx + 01234) & 0777777);
}

static Sint
add_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return a + *y;
}

static void
addm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y += a;
}

BOTH (addb_reg_mem, a + *b)
BOTH (addb_mem_reg, *b + a)
BOTH1 (uSint, uaddb_reg_mem, a + *b)
