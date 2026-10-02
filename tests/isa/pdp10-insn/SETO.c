#include "insns.h"

/*
 * SETO instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SETO   AC <- -1
 *   SETOI  AC <- -1
 *   SETOM  memory <- -1
 *   SETOB  AC and memory both receive -1
 *
 * SETO and SETOI are hard to distinguish from C because the effective
 * address is ignored semantically.  Keep argument/global/address-flavored
 * forms anyway so the backend has opportunities to choose all variants.
 */

static Sint seto_ga;
static Sint seto_gb;
static uSint seto_uga;
static Sint seto_buf[16];

struct seto_pair {
  Sint a;
  Sint b;
};

static struct seto_pair seto_gp;

static Sint
seto_void(void)
{
  return -1;
}

static Sint
seto_arg_ignored(a)
Sint a;
{
  return -1;
}

static Sint
seto_two_args_ignored(a, b)
Sint a;
Sint b;
{
  return -1;
}

static Sint
seto_after_expr(a, b)
Sint a;
Sint b;
{
  a += b;
  return -1;
}

static Sint
seto_after_load(p)
Sint *p;
{
  Sint a;

  a = *p;
  return a | -1;
}

static Sint
seto_global_ignored(void)
{
  return seto_ga | -1;
}

static Sint
seto_literal_or(a)
Sint a;
{
  return a | 0777777777777;
}

static Sint
seto_literal_assign(void)
{
  Sint a;

  a = 0777777777777;
  return a;
}

static void
setom_mem(p)
Sint *p;
{
  *p = -1;
}

static void
setom_global_a(void)
{
  seto_ga = -1;
}

static void
setom_global_b(void)
{
  seto_gb = -1;
}

static void
setom_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = -1;
}

static void
setom_global_array(i)
Sint i;
{
  seto_buf[i & 017] = -1;
}

static void
setom_struct_a(p)
struct seto_pair *p;
{
  p->a = -1;
}

static void
setom_struct_b(p)
struct seto_pair *p;
{
  p->b = -1;
}

static void
setom_global_struct_a(void)
{
  seto_gp.a = -1;
}

static void
setom_global_struct_b(void)
{
  seto_gp.b = -1;
}

static void
setom_indirect(pp)
Sint **pp;
{
  **pp = -1;
}

static void
setom_volatile(p)
volatile Sint *p;
{
  *p = -1;
}

static Sint
setom_return_mem(p)
Sint *p;
{
  *p = -1;
  return *p;
}

static Sint
setom_return_global(void)
{
  seto_ga = -1;
  return seto_ga;
}

static Sint
setom_return_array(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = -1;
  return v[i & 017];
}

static Sint
setom_return_struct_a(p)
struct seto_pair *p;
{
  p->a = -1;
  return p->a;
}

static Sint
setom_return_struct_b(p)
struct seto_pair *p;
{
  p->b = -1;
  return p->b;
}

static Sint
setob_mem_return(p)
Sint *p;
{
  *p = -1;
  return *p;
}

static Sint
setob_global_return(void)
{
  seto_ga = -1;
  return seto_ga;
}

static Sint
setob_array_return(v, i)
Sint *v;
Sint i;
{
  v[i & 017] = -1;
  return v[i & 017];
}

static Sint
setob_struct_a_return(p)
struct seto_pair *p;
{
  p->a = -1;
  return p->a;
}

static Sint
setob_struct_b_return(p)
struct seto_pair *p;
{
  p->b = -1;
  return p->b;
}

static uSint
useto_void(void)
{
  return (uSint)-1;
}

static uSint
useto_literal(void)
{
  return 0777777777777;
}

static void
usetom_mem(p)
uSint *p;
{
  *p = (uSint)-1;
}

static void
usetom_global(void)
{
  seto_uga = (uSint)-1;
}

static uSint
usetob_mem_return(p)
uSint *p;
{
  *p = (uSint)-1;
  return *p;
}

static sQint
seto_qi(void)
{
  return (sQint)-1;
}

static uQint
seto_uqi(void)
{
  return (uQint)-1;
}

static Hint
seto_hi(void)
{
  return (Hint)-1;
}

static uHint
seto_uhi(void)
{
  return (uHint)-1;
}

static void
setom_qi(p)
sQint *p;
{
  *p = (sQint)-1;
}

static void
setom_uqi(p)
uQint *p;
{
  *p = (uQint)-1;
}

static void
setom_hi(p)
Hint *p;
{
  *p = (Hint)-1;
}

static void
setom_uhi(p)
uHint *p;
{
  *p = (uHint)-1;
}

static Sint
seto_compare_form(a)
Sint a;
{
  if (a)
    return -1;
  return -1;
}

static Sint
seto_branch_form(a)
Sint a;
{
  if (a < 0)
    seto_ga = -1;
  else
    seto_gb = -1;

  return -1;
}

static Sint
seto_chain(p, q)
Sint *p;
Sint *q;
{
  *p = -1;
  *q = -1;
  return -1;
}

BOTH (setob_mem, -1)
BOTH1 (uSint, usetob_mem, (uSint)-1)
