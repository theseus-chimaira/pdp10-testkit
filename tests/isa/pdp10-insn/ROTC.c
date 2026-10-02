#include "insns.h"

/*
 * ROTC instruction coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   ROTC AC,count
 *   ROTC AC,(index-register-count)
 *   ROTC AC,@memory-count
 *   ROTC AC,constant(index-register-count)
 *
 * Use uDint so the source expression is a double-word rotate, not an
 * arithmetic signed operation.  The plus/minus count forms are kept to
 * exercise combine patterns around shifted/adjusted counts.
 */

static uDint rotc_ga;
static uDint rotc_gb;
static Sint rotc_count;
static Sint rotc_counts[16];
static uDint rotc_buf[16];

struct rotc_pair {
  uDint a;
  uDint b;
};

static struct rotc_pair rotc_gp;

static uDint
rotcl_const_1(a)
uDint a;
{
  return ROTCL(a, 1);
}

static uDint
rotcl_const_2(a)
uDint a;
{
  return ROTCL(a, 2);
}

static uDint
rotcl_const_8(a)
uDint a;
{
  return ROTCL(a, 8);
}

static uDint
rotcl_const_9(a)
uDint a;
{
  return ROTCL(a, 9);
}

static uDint
rotcl_const_17(a)
uDint a;
{
  return ROTCL(a, 17);
}

static uDint
rotcl_const_18(a)
uDint a;
{
  return ROTCL(a, 18);
}

static uDint
rotcl_const_19(a)
uDint a;
{
  return ROTCL(a, 19);
}

static uDint
rotcl_const_35(a)
uDint a;
{
  return ROTCL(a, 35);
}

static uDint
rotcl_const_36(a)
uDint a;
{
  return ROTCL(a, 36);
}

static uDint
rotcl_const_37(a)
uDint a;
{
  return ROTCL(a, 37);
}

static uDint
rotcl_const_53(a)
uDint a;
{
  return ROTCL(a, 53);
}

static uDint
rotcl_const_54(a)
uDint a;
{
  return ROTCL(a, 54);
}

static uDint
rotcl_const_55(a)
uDint a;
{
  return ROTCL(a, 55);
}

static uDint
rotcl_const_71(a)
uDint a;
{
  return ROTCL(a, 71);
}

static uDint
rotcr_const_1(a)
uDint a;
{
  return ROTCR(a, 1);
}

static uDint
rotcr_const_2(a)
uDint a;
{
  return ROTCR(a, 2);
}

static uDint
rotcr_const_8(a)
uDint a;
{
  return ROTCR(a, 8);
}

static uDint
rotcr_const_9(a)
uDint a;
{
  return ROTCR(a, 9);
}

static uDint
rotcr_const_17(a)
uDint a;
{
  return ROTCR(a, 17);
}

static uDint
rotcr_const_18(a)
uDint a;
{
  return ROTCR(a, 18);
}

static uDint
rotcr_const_19(a)
uDint a;
{
  return ROTCR(a, 19);
}

static uDint
rotcr_const_35(a)
uDint a;
{
  return ROTCR(a, 35);
}

static uDint
rotcr_const_36(a)
uDint a;
{
  return ROTCR(a, 36);
}

static uDint
rotcr_const_37(a)
uDint a;
{
  return ROTCR(a, 37);
}

static uDint
rotcr_const_53(a)
uDint a;
{
  return ROTCR(a, 53);
}

static uDint
rotcr_const_54(a)
uDint a;
{
  return ROTCR(a, 54);
}

static uDint
rotcr_const_55(a)
uDint a;
{
  return ROTCR(a, 55);
}

static uDint
rotcr_const_71(a)
uDint a;
{
  return ROTCR(a, 71);
}

static uDint
rotcl_reg(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, x);
}

static uDint
rotcr_reg(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, x);
}

static uDint
rotcl_reg_neg(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, -x);
}

static uDint
rotcr_reg_neg(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, -x);
}

static uDint
rotcl_reg_plus_1(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, x + 1);
}

static uDint
rotcl_reg_plus_2(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, x + 2);
}

static uDint
rotcl_reg_minus_1(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, x - 1);
}

static uDint
rotcl_one_plus_reg(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, 1 + x);
}

static uDint
rotcl_one_minus_reg(a, x)
uDint a;
Sint x;
{
  return ROTCL(a, 1 - x);
}

static uDint
rotcr_reg_plus_1(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, x + 1);
}

static uDint
rotcr_reg_plus_2(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, x + 2);
}

static uDint
rotcr_reg_minus_1(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, x - 1);
}

static uDint
rotcr_one_plus_reg(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, 1 + x);
}

static uDint
rotcr_one_minus_reg(a, x)
uDint a;
Sint x;
{
  return ROTCR(a, 1 - x);
}

static uDint
rotcl_mem_count(a, p)
uDint a;
Sint *p;
{
  return ROTCL(a, *p);
}

static uDint
rotcr_mem_count(a, p)
uDint a;
Sint *p;
{
  return ROTCR(a, *p);
}

static uDint
rotcl_global_count(a)
uDint a;
{
  return ROTCL(a, rotc_count);
}

static uDint
rotcr_global_count(a)
uDint a;
{
  return ROTCR(a, rotc_count);
}

static uDint
rotcl_array_count(a, i)
uDint a;
Sint i;
{
  return ROTCL(a, rotc_counts[i & 017]);
}

static uDint
rotcr_array_count(a, i)
uDint a;
Sint i;
{
  return ROTCR(a, rotc_counts[i & 017]);
}

static uDint
rotcl_mem_value(p, x)
uDint *p;
Sint x;
{
  return ROTCL(*p, x);
}

static uDint
rotcr_mem_value(p, x)
uDint *p;
Sint x;
{
  return ROTCR(*p, x);
}

static uDint
rotcl_mem_value_const(p)
uDint *p;
{
  return ROTCL(*p, 1);
}

static uDint
rotcr_mem_value_const(p)
uDint *p;
{
  return ROTCR(*p, 1);
}

static uDint
rotcl_global_value(x)
Sint x;
{
  return ROTCL(rotc_ga, x);
}

static uDint
rotcr_global_value(x)
Sint x;
{
  return ROTCR(rotc_ga, x);
}

static uDint
rotcl_global_value_const(void)
{
  return ROTCL(rotc_ga, 36);
}

static uDint
rotcr_global_value_const(void)
{
  return ROTCR(rotc_ga, 36);
}

static uDint
rotcl_array_value(i, x)
Sint i;
Sint x;
{
  return ROTCL(rotc_buf[i & 017], x);
}

static uDint
rotcr_array_value(i, x)
Sint i;
Sint x;
{
  return ROTCR(rotc_buf[i & 017], x);
}

static uDint
rotcl_struct_a(p, x)
struct rotc_pair *p;
Sint x;
{
  return ROTCL(p->a, x);
}

static uDint
rotcr_struct_a(p, x)
struct rotc_pair *p;
Sint x;
{
  return ROTCR(p->a, x);
}

static uDint
rotcl_struct_b(p, x)
struct rotc_pair *p;
Sint x;
{
  return ROTCL(p->b, x);
}

static uDint
rotcr_struct_b(p, x)
struct rotc_pair *p;
Sint x;
{
  return ROTCR(p->b, x);
}

static uDint
rotcl_global_struct_a(x)
Sint x;
{
  return ROTCL(rotc_gp.a, x);
}

static uDint
rotcr_global_struct_a(x)
Sint x;
{
  return ROTCR(rotc_gp.a, x);
}

static uDint
rotcl_global_struct_b_const(void)
{
  return ROTCL(rotc_gp.b, 18);
}

static uDint
rotcr_global_struct_b_const(void)
{
  return ROTCR(rotc_gp.b, 18);
}

static void
rotcl_store(p, a, x)
uDint *p;
uDint a;
Sint x;
{
  *p = ROTCL(a, x);
}

static void
rotcr_store(p, a, x)
uDint *p;
uDint a;
Sint x;
{
  *p = ROTCR(a, x);
}

static void
rotcl_store_const(p, a)
uDint *p;
uDint a;
{
  *p = ROTCL(a, 36);
}

static void
rotcr_store_const(p, a)
uDint *p;
uDint a;
{
  *p = ROTCR(a, 36);
}

static void
rotcl_store_global(a, x)
uDint a;
Sint x;
{
  rotc_ga = ROTCL(a, x);
}

static void
rotcr_store_global(a, x)
uDint a;
Sint x;
{
  rotc_gb = ROTCR(a, x);
}

static uDint
rotcl_store_return(p, a, x)
uDint *p;
uDint a;
Sint x;
{
  *p = ROTCL(a, x);
  return *p;
}

static uDint
rotcr_store_return(p, a, x)
uDint *p;
uDint a;
Sint x;
{
  *p = ROTCR(a, x);
  return *p;
}

static void
rotcl_update_mem(p, x)
uDint *p;
Sint x;
{
  *p = ROTCL(*p, x);
}

static void
rotcr_update_mem(p, x)
uDint *p;
Sint x;
{
  *p = ROTCR(*p, x);
}

static void
rotcl_update_mem_const(p)
uDint *p;
{
  *p = ROTCL(*p, 1);
}

static void
rotcr_update_mem_const(p)
uDint *p;
{
  *p = ROTCR(*p, 1);
}

static void
rotcl_update_global(x)
Sint x;
{
  rotc_ga = ROTCL(rotc_ga, x);
}

static void
rotcr_update_global(x)
Sint x;
{
  rotc_gb = ROTCR(rotc_gb, x);
}

static uDint
rotcl_mix_add(a, x, y)
uDint a;
Sint x;
uDint y;
{
  return ROTCL(a, x) + y;
}

static uDint
rotcr_mix_add(a, x, y)
uDint a;
Sint x;
uDint y;
{
  return ROTCR(a, x) + y;
}

static uDint
rotcl_mix_xor(a, x, y)
uDint a;
Sint x;
uDint y;
{
  return ROTCL(a, x) ^ y;
}

static uDint
rotcr_mix_xor(a, x, y)
uDint a;
Sint x;
uDint y;
{
  return ROTCR(a, x) ^ y;
}

static uDint
rotcl_chain(a, x, y)
uDint a;
Sint x;
Sint y;
{
  return ROTCL(ROTCL(a, x), y);
}

static uDint
rotcr_chain(a, x, y)
uDint a;
Sint x;
Sint y;
{
  return ROTCR(ROTCR(a, x), y);
}

static uDint
rotcl_rotcr_chain(a, x, y)
uDint a;
Sint x;
Sint y;
{
  return ROTCR(ROTCL(a, x), y);
}

static uDint
rotcr_rotcl_chain(a, x, y)
uDint a;
Sint x;
Sint y;
{
  return ROTCL(ROTCR(a, x), y);
}

static uDint
rotcl_from_halves(hi, lo, x)
uSint hi;
uSint lo;
Sint x;
{
  uDint a;

  a = ((uDint)hi << 36) | lo;
  return ROTCL(a, x);
}

static uDint
rotcr_from_halves(hi, lo, x)
uSint hi;
uSint lo;
Sint x;
{
  uDint a;

  a = ((uDint)hi << 36) | lo;
  return ROTCR(a, x);
}

static uSint
rotcl_low_word(a, x)
uDint a;
Sint x;
{
  return (uSint)ROTCL(a, x);
}

static uSint
rotcr_low_word(a, x)
uDint a;
Sint x;
{
  return (uSint)ROTCR(a, x);
}

static uSint
rotcl_high_word(a, x)
uDint a;
Sint x;
{
  return (uSint)(ROTCL(a, x) >> 36);
}

static uSint
rotcr_high_word(a, x)
uDint a;
Sint x;
{
  return (uSint)(ROTCR(a, x) >> 36);
}
