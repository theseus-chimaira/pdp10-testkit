#include "insns.h"

/*
 * MOVS instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   MOVS   AC <- swapped source word
 *   MOVSI  AC <- immediate/address in left half
 *   MOVSM  memory <- swapped AC/source register
 *   MOVSS  memory <- swapped memory word, self form
 *
 * MOVSS is intentionally tested even if the current backend still lowers
 * it as load/swap/store.  The test belongs here because the instruction
 * exists on the target and the backend should eventually learn it.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static uSint movs_ga;
static uSint movs_gb;
static uSint movs_buf[16];

struct movs_pair {
  uSint a;
  uSint b;
};

static struct movs_pair movs_gp;

static uSint
movs_reg_reg(a, e)
uSint a;
uSint e;
{
  return SWAP(e);
}

static uSint
movs_reg_self(a)
uSint a;
{
  OPAQUE_REG(a);
  return SWAP(a);
}

static uSint
movs_mem(p)
uSint *p;
{
  return SWAP(*p);
}

static uSint
movs_mem_plus(p, x)
uSint *p;
uSint x;
{
  return SWAP(*p) + x;
}

static uSint
movs_mem_xor(p, x)
uSint *p;
uSint x;
{
  return SWAP(*p) ^ x;
}

static uSint
movs_global_a(void)
{
  return SWAP(movs_ga);
}

static uSint
movs_global_b(void)
{
  return SWAP(movs_gb);
}

static uSint
movs_array(v, i)
uSint *v;
Sint i;
{
  return SWAP(v[i & 017]);
}

static uSint
movs_global_array(i)
Sint i;
{
  return SWAP(movs_buf[i & 017]);
}

static uSint
movs_struct_a(p)
struct movs_pair *p;
{
  return SWAP(p->a);
}

static uSint
movs_struct_b(p)
struct movs_pair *p;
{
  return SWAP(p->b);
}

static uSint
movs_global_struct_a(void)
{
  return SWAP(movs_gp.a);
}

static uSint
movs_global_struct_b(void)
{
  return SWAP(movs_gp.b);
}

static uSint
movs_indirect(pp)
uSint **pp;
{
  uSint *p;

  p = *pp;
  return SWAP(*p);
}

static uSint
movsi_zero(void)
{
  return ((uSint)0) << 18;
}

static uSint
movsi_one(void)
{
  return ((uSint)1) << 18;
}

static uSint
movsi_small(void)
{
  return ((uSint)0123456) << 18;
}

static uSint
movsi_max18(void)
{
  return ((uSint)0777777) << 18;
}

static uSint
movsi_pattern(void)
{
  return 0123456000000;
}

static uSint
movsi_address_global(void)
{
  return ((uSint)&movs_ga) << 18;
}

static uSint
movsi_address_array(void)
{
  return ((uSint)&movs_buf[3]) << 18;
}

static void
movsm_reg_mem(a, p)
uSint a;
uSint *p;
{
  *p = SWAP(a);
}

static void
movsm_reg_global(a)
uSint a;
{
  movs_ga = SWAP(a);
}

static void
movsm_reg_array(a, v, i)
uSint a;
uSint *v;
Sint i;
{
  v[i & 017] = SWAP(a);
}

static void
movsm_reg_struct_a(a, p)
uSint a;
struct movs_pair *p;
{
  p->a = SWAP(a);
}

static void
movsm_reg_struct_b(a, p)
uSint a;
struct movs_pair *p;
{
  p->b = SWAP(a);
}

static uSint
movsm_return_original(a, p)
uSint a;
uSint *p;
{
  OPAQUE_REG(a);
  *p = SWAP(a);
  return a;
}

static uSint
movsm_return_swapped(a, p)
uSint a;
uSint *p;
{
  *p = SWAP(a);
  return *p;
}

static void
movsm_mem_to_mem(dst, src)
uSint *dst;
uSint *src;
{
  *dst = SWAP(*src);
}

static void
movss_mem(p)
uSint *p;
{
  *p = SWAP(*p);
}

static uSint
movss_mem_return(p)
uSint *p;
{
  *p = SWAP(*p);
  return *p;
}

static void
movss_global_a(void)
{
  movs_ga = SWAP(movs_ga);
}

static void
movss_global_b(void)
{
  movs_gb = SWAP(movs_gb);
}

static void
movss_array(v, i)
uSint *v;
Sint i;
{
  v[i & 017] = SWAP(v[i & 017]);
}

static void
movss_global_array(i)
Sint i;
{
  movs_buf[i & 017] = SWAP(movs_buf[i & 017]);
}

static void
movss_struct_a(p)
struct movs_pair *p;
{
  p->a = SWAP(p->a);
}

static void
movss_struct_b(p)
struct movs_pair *p;
{
  p->b = SWAP(p->b);
}

static uSint
movss_struct_a_return(p)
struct movs_pair *p;
{
  p->a = SWAP(p->a);
  return p->a;
}
