#include "insns.h"

/*
 * ROT instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   ROT AC,count
 *   ROT AC,(index-register-count)
 *   ROT AC,@memory-count
 *   ROT AC,constant(index-register-count)
 *
 * Use unsigned 36-bit values.  The ROTL/ROTR macros are written as
 * logical shifts, so signed operands would test arithmetic-shift
 * behavior instead of clean rotate recognition.
 */

static uSint rot_ga;
static uSint rot_gb;
static Sint rot_count;
static Sint rot_counts[16];
static uSint rot_buf[16];

struct rot_pair {
  uSint a;
  uSint b;
};

static struct rot_pair rot_gp;

static uSint
rotl_const_1(ac)
uSint ac;
{
  return ROTL(ac, 1);
}

static uSint
rotl_const_2(ac)
uSint ac;
{
  return ROTL(ac, 2);
}

static uSint
rotl_const_8(ac)
uSint ac;
{
  return ROTL(ac, 8);
}

static uSint
rotl_const_9(ac)
uSint ac;
{
  return ROTL(ac, 9);
}

static uSint
rotl_const_17(ac)
uSint ac;
{
  return ROTL(ac, 17);
}

static uSint
rotl_const_18(ac)
uSint ac;
{
  return ROTL(ac, 18);
}

static uSint
rotl_const_19(ac)
uSint ac;
{
  return ROTL(ac, 19);
}

static uSint
rotl_const_27(ac)
uSint ac;
{
  return ROTL(ac, 27);
}

static uSint
rotl_const_35(ac)
uSint ac;
{
  return ROTL(ac, 35);
}

static uSint
rotr_const_1(ac)
uSint ac;
{
  return ROTR(ac, 1);
}

static uSint
rotr_const_2(ac)
uSint ac;
{
  return ROTR(ac, 2);
}

static uSint
rotr_const_8(ac)
uSint ac;
{
  return ROTR(ac, 8);
}

static uSint
rotr_const_9(ac)
uSint ac;
{
  return ROTR(ac, 9);
}

static uSint
rotr_const_17(ac)
uSint ac;
{
  return ROTR(ac, 17);
}

static uSint
rotr_const_18(ac)
uSint ac;
{
  return ROTR(ac, 18);
}

static uSint
rotr_const_19(ac)
uSint ac;
{
  return ROTR(ac, 19);
}

static uSint
rotr_const_27(ac)
uSint ac;
{
  return ROTR(ac, 27);
}

static uSint
rotr_const_35(ac)
uSint ac;
{
  return ROTR(ac, 35);
}

static uSint
rotl_reg(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, x);
}

static uSint
rotr_reg(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, x);
}

static uSint
rotl_reg_neg(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, -x);
}

static uSint
rotr_reg_neg(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, -x);
}

static uSint
rotl_reg_plus_1(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, x + 1);
}

static uSint
rotl_reg_plus_2(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, x + 2);
}

static uSint
rotl_reg_minus_1(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, x - 1);
}

static uSint
rotl_one_plus_reg(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, 1 + x);
}

static uSint
rotl_one_minus_reg(ac, x)
uSint ac;
Sint x;
{
  return ROTL(ac, 1 - x);
}

static uSint
rotr_reg_plus_1(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, x + 1);
}

static uSint
rotr_reg_plus_2(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, x + 2);
}

static uSint
rotr_reg_minus_1(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, x - 1);
}

static uSint
rotr_one_plus_reg(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, 1 + x);
}

static uSint
rotr_one_minus_reg(ac, x)
uSint ac;
Sint x;
{
  return ROTR(ac, 1 - x);
}

static uSint
rotl_mem_count(ac, p)
uSint ac;
Sint *p;
{
  return ROTL(ac, *p);
}

static uSint
rotr_mem_count(ac, p)
uSint ac;
Sint *p;
{
  return ROTR(ac, *p);
}

static uSint
rotl_global_count(ac)
uSint ac;
{
  return ROTL(ac, rot_count);
}

static uSint
rotr_global_count(ac)
uSint ac;
{
  return ROTR(ac, rot_count);
}

static uSint
rotl_array_count(ac, i)
uSint ac;
Sint i;
{
  return ROTL(ac, rot_counts[i & 017]);
}

static uSint
rotr_array_count(ac, i)
uSint ac;
Sint i;
{
  return ROTR(ac, rot_counts[i & 017]);
}

static uSint
rotl_mem_value(p, x)
uSint *p;
Sint x;
{
  return ROTL(*p, x);
}

static uSint
rotr_mem_value(p, x)
uSint *p;
Sint x;
{
  return ROTR(*p, x);
}

static uSint
rotl_mem_value_const(p)
uSint *p;
{
  return ROTL(*p, 1);
}

static uSint
rotr_mem_value_const(p)
uSint *p;
{
  return ROTR(*p, 1);
}

static uSint
rotl_global_value(x)
Sint x;
{
  return ROTL(rot_ga, x);
}

static uSint
rotr_global_value(x)
Sint x;
{
  return ROTR(rot_ga, x);
}

static uSint
rotl_global_value_const(void)
{
  return ROTL(rot_ga, 18);
}

static uSint
rotr_global_value_const(void)
{
  return ROTR(rot_ga, 18);
}

static uSint
rotl_array_value(i, x)
Sint i;
Sint x;
{
  return ROTL(rot_buf[i & 017], x);
}

static uSint
rotr_array_value(i, x)
Sint i;
Sint x;
{
  return ROTR(rot_buf[i & 017], x);
}

static uSint
rotl_struct_a(p, x)
struct rot_pair *p;
Sint x;
{
  return ROTL(p->a, x);
}

static uSint
rotr_struct_a(p, x)
struct rot_pair *p;
Sint x;
{
  return ROTR(p->a, x);
}

static uSint
rotl_struct_b(p, x)
struct rot_pair *p;
Sint x;
{
  return ROTL(p->b, x);
}

static uSint
rotr_struct_b(p, x)
struct rot_pair *p;
Sint x;
{
  return ROTR(p->b, x);
}

static uSint
rotl_global_struct_a(x)
Sint x;
{
  return ROTL(rot_gp.a, x);
}

static uSint
rotr_global_struct_a(x)
Sint x;
{
  return ROTR(rot_gp.a, x);
}

static uSint
rotl_global_struct_b_const(void)
{
  return ROTL(rot_gp.b, 9);
}

static uSint
rotr_global_struct_b_const(void)
{
  return ROTR(rot_gp.b, 9);
}

static void
rotl_store(p, ac, x)
uSint *p;
uSint ac;
Sint x;
{
  *p = ROTL(ac, x);
}

static void
rotr_store(p, ac, x)
uSint *p;
uSint ac;
Sint x;
{
  *p = ROTR(ac, x);
}

static void
rotl_store_const(p, ac)
uSint *p;
uSint ac;
{
  *p = ROTL(ac, 18);
}

static void
rotr_store_const(p, ac)
uSint *p;
uSint ac;
{
  *p = ROTR(ac, 18);
}

static void
rotl_store_global(ac, x)
uSint ac;
Sint x;
{
  rot_ga = ROTL(ac, x);
}

static void
rotr_store_global(ac, x)
uSint ac;
Sint x;
{
  rot_gb = ROTR(ac, x);
}

static uSint
rotl_store_return(p, ac, x)
uSint *p;
uSint ac;
Sint x;
{
  *p = ROTL(ac, x);
  return *p;
}

static uSint
rotr_store_return(p, ac, x)
uSint *p;
uSint ac;
Sint x;
{
  *p = ROTR(ac, x);
  return *p;
}

static void
rotl_update_mem(p, x)
uSint *p;
Sint x;
{
  *p = ROTL(*p, x);
}

static void
rotr_update_mem(p, x)
uSint *p;
Sint x;
{
  *p = ROTR(*p, x);
}

static void
rotl_update_mem_const(p)
uSint *p;
{
  *p = ROTL(*p, 1);
}

static void
rotr_update_mem_const(p)
uSint *p;
{
  *p = ROTR(*p, 1);
}

static void
rotl_update_global(x)
Sint x;
{
  rot_ga = ROTL(rot_ga, x);
}

static void
rotr_update_global(x)
Sint x;
{
  rot_gb = ROTR(rot_gb, x);
}

static uSint
rotl_mix_add(ac, x, y)
uSint ac;
Sint x;
uSint y;
{
  return ROTL(ac, x) + y;
}

static uSint
rotr_mix_add(ac, x, y)
uSint ac;
Sint x;
uSint y;
{
  return ROTR(ac, x) + y;
}

static uSint
rotl_mix_xor(ac, x, y)
uSint ac;
Sint x;
uSint y;
{
  return ROTL(ac, x) ^ y;
}

static uSint
rotr_mix_xor(ac, x, y)
uSint ac;
Sint x;
uSint y;
{
  return ROTR(ac, x) ^ y;
}

static uSint
rotl_chain(ac, x, y)
uSint ac;
Sint x;
Sint y;
{
  return ROTL(ROTL(ac, x), y);
}

static uSint
rotr_chain(ac, x, y)
uSint ac;
Sint x;
Sint y;
{
  return ROTR(ROTR(ac, x), y);
}

static uSint
rotl_rotr_chain(ac, x, y)
uSint ac;
Sint x;
Sint y;
{
  return ROTR(ROTL(ac, x), y);
}

static uSint
rotr_rotl_chain(ac, x, y)
uSint ac;
Sint x;
Sint y;
{
  return ROTL(ROTR(ac, x), y);
}

static uSint
rotl_small_type(a, x)
uHint a;
Sint x;
{
  return ROTL((uSint)a, x);
}

static uSint
rotr_small_type(a, x)
uHint a;
Sint x;
{
  return ROTR((uSint)a, x);
}

static uSint
rotl_byte_type(a, x)
uQint a;
Sint x;
{
  return ROTL((uSint)a, x);
}

static uSint
rotr_byte_type(a, x)
uQint a;
Sint x;
{
  return ROTR((uSint)a, x);
}
