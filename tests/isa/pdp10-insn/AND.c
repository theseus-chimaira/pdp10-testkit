#include "insns.h"

/*
 * AND instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended instruction forms from andsi3:
 *   AND    register/memory and literal source
 *   ANDI   right-half immediate mask
 *   ANDM   memory destination update
 *   ANDB   update accumulator and memory with same result
 *
 * The same andsi3 pattern also selects TLZ and ANDCMI for special
 * constants.  Keep those here too, because they are generated from C
 * '&' and are part of the practical AND lowering surface.
 */

static Sint
and_reg_reg(a, y)
Sint a;
Sint y;
{
  return a & y;
}

static Sint
and_reg_mem(a, y)
Sint a;
Sint *y;
{
  return a & *y;
}

static Sint
and_mem_reg(y, a)
Sint *y;
Sint a;
{
  return *y & a;
}

static Sint
and_mem_mem(a, y)
Sint *a;
Sint *y;
{
  return *a & *y;
}

static Sint
andi_small(a)
Sint a;
{
  return a & 0123456;
}

static Sint
andi_one(a)
Sint a;
{
  return a & 1;
}

static Sint
andi_low6(a)
Sint a;
{
  return a & 077;
}

static Sint
andi_low9(a)
Sint a;
{
  return a & 0777;
}

static Sint
andi_low18(a)
Sint a;
{
  return a & 0777777;
}

static Sint
and_literal(a)
Sint a;
{
  return a & 0123456123456;
}

static Sint
and_literal_left(a)
Sint a;
{
  return 0123456123456 & a;
}

static Sint
and_literal_sparse(a)
Sint a;
{
  return a & 0525252252525;
}

static Sint
and_keep_left(a)
Sint a;
{
  return a & 0777777000000;
}

static Sint
and_keep_right(a)
Sint a;
{
  return a & 0000000777777;
}

static Sint
and_keep_left_some_right(a)
Sint a;
{
  return a & 0777777012345;
}

static Sint
and_keep_right_some_left(a)
Sint a;
{
  return a & 0123456777777;
}

static Sint
and_clear_low_bit(a)
Sint a;
{
  return a & 0777777777776;
}

static Sint
and_clear_high_bit(a)
Sint a;
{
  return a & 0377777777777;
}

static Sint
andm_reg_mem(a, y)
Sint a;
Sint *y;
{
  *y = *y & a;
}

static void
andm_void(a, y)
Sint a;
Sint *y;
{
  *y &= a;
}

static void
andm_const(y)
Sint *y;
{
  *y &= 0123456;
}

static Sint
andm_then_load(a, y)
Sint a;
Sint *y;
{
  *y &= a;
  return *y;
}

static Sint
and_assign_local(a, b, c)
Sint a;
Sint b;
Sint c;
{
  a &= b;
  a &= c;
  return a;
}

static uSint
uand_reg_reg(a, y)
uSint a;
uSint y;
{
  return a & y;
}

static uSint
uand_reg_mem(a, y)
uSint a;
uSint *y;
{
  return a & *y;
}

static uSint
uandi_low18(a)
uSint a;
{
  return a & 0777777;
}

static uSint
uand_literal(a)
uSint a;
{
  return a & 0123456123456;
}

static uSint
uand_keep_left(a)
uSint a;
{
  return a & 0777777000000;
}

static uSint
uand_keep_right(a)
uSint a;
{
  return a & 0000000777777;
}

static uSint
uand_tlz_const(a)
uSint a;
{
  return a & 0123456777777;
}

static uSint
uand_andcmi_const(a)
uSint a;
{
  return a & 0777777012345;
}

static Sint
and_qi_promote(a, b)
sQint a;
sQint b;
{
  return a & b;
}

static Sint
andu_qi_promote(a, b)
uQint a;
uQint b;
{
  return a & b;
}

static Sint
and_hi_promote(a, b)
Hint a;
Hint b;
{
  return a & b;
}

static Sint
andu_hi_promote(a, b)
uHint a;
uHint b;
{
  return a & b;
}

static Sint
and_qi_mask(a)
uQint a;
{
  return a & 0777;
}

static Sint
and_hi_mask(a)
uHint a;
{
  return a & 0777777;
}

static Sint
and_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  return a & *y;
}

static void
andm_volatile_mem(a, y)
Sint a;
volatile Sint *y;
{
  *y &= a;
}

/*
 * Special register-address forms from the AND/TLZ helper patterns.
 * These are not separate ISA families here; they are selected from
 * ordinary C '&' expressions.
 */

static uSint
andi_reg_form(a, b)
uSint a;
uSint b;
{
  return b & (a & 0777777);
}

static uSint
andi_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return b & ((a + 01234) & 0777777);
}

static uSint
tlz_reg_form(a, b)
uSint a;
uSint b;
{
  return b & ~(a << 18);
}

static uSint
tlz_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return b & ~((a << 18) + 0123456000000);
}

static uSint
andcmi_reg_form(a, b)
uSint a;
uSint b;
{
  return b & ~(a & 0777777);
}

static uSint
andcmi_reg_plus_form(a, b)
uSint a;
uSint b;
{
  return b & ~((a + 01234) & 0777777);
}

BOTH (andb_reg_mem, a & *b)
BOTH (andb_mem_reg, *b & a)
BOTH1 (uSint, uandb_reg_mem, a & *b)
