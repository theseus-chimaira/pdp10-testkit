#include "insns.h"

/*
 * TSNN instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended family:
 *   TSNN  AC,E    test AC against SWAP(E),
 *                 skip if tested bits are zero,
 *                 no modification
 *
 * Ordinary C branch shape:
 *
 *   if (!(ac & SWAP(e)))
 *     ...
 *
 * Keep this file focused on swapped-source zero tests.  Direct
 * full-word zero-skip belongs to TDNN.c.  Right-half and left-half
 * immediate zero-skip belong to TRNN.c and TLNN.c.  Swapped-source
 * nonzero-skip belongs to TSNE.c.
 */

extern Sint f(void);

static Sint tsnn_ga;
static Sint tsnn_gb;
static uSint tsnn_uga;
static volatile Sint tsnn_vga;
static Sint tsnn_buf[16];
static uSint tsnn_ubuf[16];

struct tsnn_pair {
  Sint a;
  Sint b;
};

struct tsnn_upair {
  uSint a;
  uSint b;
};

static struct tsnn_pair tsnn_gp;
static struct tsnn_upair tsnn_ugp;

/*
 * Basic swapped-source zero-test branch forms.
 */

static Sint
tsnn_clear(ac, e)
Sint ac;
Sint e;
{
  if (!(ac & SWAP(e)))
    return 0;
  return ac;
}

static Sint
tsnn_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (!(ac & SWAP(e)))
    return yes;
  return no;
}

static Sint
tsnn_select_add(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (!(ac & SWAP(e)))
    return yes + ac;
  return no + ac;
}

static Sint
tsnn_call(ac, e)
Sint ac;
Sint e;
{
  if (!(ac & SWAP(e)))
    return f();
  return ac;
}

static Sint
tsnn_call_add(ac, e)
Sint ac;
Sint e;
{
  if (!(ac & SWAP(e)))
    ac += f();
  return ac;
}

static Sint
tsnn_likely(ac, e)
Sint ac;
Sint e;
{
  if (likely(!(ac & SWAP(e))))
    return 0;
  return ac;
}

static Sint
tsnn_unlikely(ac, e)
Sint ac;
Sint e;
{
  if (unlikely(!(ac & SWAP(e))))
    return 0;
  return ac;
}

/*
 * Literal swapped masks.
 */

static Sint
tsnn_literal_a(ac)
Sint ac;
{
  if (!(ac & SWAP(0123456123456)))
    return 0;
  return ac;
}

static Sint
tsnn_literal_b(ac)
Sint ac;
{
  if (!(ac & SWAP(0525252252525)))
    return 0;
  return ac;
}

static Sint
tsnn_literal_sparse(ac)
Sint ac;
{
  if (!(ac & SWAP(0707070070707)))
    return 0;
  return ac;
}

static Sint
tsnn_literal_left(ac)
Sint ac;
{
  if (!(ac & SWAP(0123456000000)))
    return 0;
  return ac;
}

static Sint
tsnn_literal_right(ac)
Sint ac;
{
  if (!(ac & SWAP(0000000123456)))
    return 0;
  return ac;
}

static Sint
tsnn_literal_signbit(ac)
Sint ac;
{
  if (!(ac & SWAP(0400000000000)))
    return 0;
  return ac;
}

static Sint
tsnn_literal_all(ac)
Sint ac;
{
  if (!(ac & SWAP(0777777777777)))
    return 0;
  return ac;
}

/*
 * Memory, global, array, struct, and volatile sources.
 */

static Sint
tsnn_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_mem_select(ac, e, yes, no)
Sint ac;
Sint *e;
Sint yes;
Sint no;
{
  Sint m;

  m = *e;
  if (!(ac & SWAP(m)))
    return yes;
  return no;
}

static Sint
tsnn_mem_call(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  if (!(ac & SWAP(m)))
    return f();
  return ac;
}

static Sint
tsnn_global(ac)
Sint ac;
{
  if (!(ac & SWAP(tsnn_ga)))
    return 0;
  return ac;
}

static Sint
tsnn_global_global(void)
{
  if (!(tsnn_ga & SWAP(tsnn_gb)))
    return 0;
  return tsnn_ga;
}

static Sint
tsnn_volatile_global(ac)
Sint ac;
{
  Sint m;

  m = tsnn_vga;
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  Sint m;

  m = v[i & 017];
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_global_array(ac, i)
Sint ac;
Sint i;
{
  Sint m;

  m = tsnn_buf[i & 017];
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  Sint ac;
  Sint m;

  ac = v[i & 017];
  m = v[j & 017];
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_struct_a(ac, p)
Sint ac;
struct tsnn_pair *p;
{
  if (!(ac & SWAP(p->a)))
    return 0;
  return ac;
}

static Sint
tsnn_struct_b(ac, p)
Sint ac;
struct tsnn_pair *p;
{
  if (!(ac & SWAP(p->b)))
    return 0;
  return ac;
}

static Sint
tsnn_global_struct_a(ac)
Sint ac;
{
  if (!(ac & SWAP(tsnn_gp.a)))
    return 0;
  return ac;
}

static Sint
tsnn_global_struct_b(ac)
Sint ac;
{
  if (!(ac & SWAP(tsnn_gp.b)))
    return 0;
  return ac;
}

static Sint
tsnn_struct_struct(p)
struct tsnn_pair *p;
{
  if (!(p->a & SWAP(p->b)))
    return 0;
  return p->a;
}

static Sint
tsnn_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  Sint m;

  m = **pp;
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  Sint m;

  m = *e;
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static Sint
tsnn_volatile_volatile(a, b)
volatile Sint *a;
volatile Sint *b;
{
  Sint ac;
  Sint m;

  ac = *a;
  m = *b;
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

/*
 * Boolean value results.  These are useful for setcc-style lowering:
 * the test must produce a 0/1 value, not merely control flow.
 */

static Sint
tsnn_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & SWAP(e)) == 0;
}

static Sint
tsnn_bool_not(ac, e)
Sint ac;
Sint e;
{
  return !((ac & SWAP(e)) == 0);
}

static Sint
tsnn_bool_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return (ac & SWAP(m)) == 0;
}

static Sint
tsnn_bool_global(ac)
Sint ac;
{
  return (ac & SWAP(tsnn_ga)) == 0;
}

static Sint
tsnn_bool_literal(ac)
Sint ac;
{
  return (ac & SWAP(0123456123456)) == 0;
}

static Sint
tsnn_bool_left_literal(ac)
Sint ac;
{
  return (ac & SWAP(0123456000000)) == 0;
}

static Sint
tsnn_bool_right_literal(ac)
Sint ac;
{
  return (ac & SWAP(0000000123456)) == 0;
}

static Sint
tsnn_bool_signbit(ac)
Sint ac;
{
  return (ac & SWAP(0400000000000)) == 0;
}

static Sint
tsnn_bool_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) == 0) + y;
}

static Sint
tsnn_bool_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) == 0) | y;
}

static Sint
tsnn_bool_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) == 0) ^ y;
}

static Sint
tsnn_bool_mul(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) == 0) * y;
}

/*
 * Tests where the masked value is also used after the branch.
 */

static Sint
tsnn_value_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & m;
  if (!t)
    return yes + t;
  return no + t;
}

static Sint
tsnn_value_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & m;
  if (!t)
    return t + f();
  return ac;
}

static Sint
tsnn_value_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac & m;
  if (!t)
    return 0;
  return t + ac;
}

static Sint
tsnn_sources_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint m;

  m = SWAP(e);
  if (!(ac & m))
    return ac + e + y;
  return y;
}

static Sint
tsnn_memory_sources_live(ap, ep, y)
Sint *ap;
Sint *ep;
Sint y;
{
  Sint ac;
  Sint e;
  Sint m;

  ac = *ap;
  e = *ep;
  m = SWAP(e);
  if (!(ac & m))
    return ac + e + y;
  return y;
}

/*
 * Compound control-flow shapes.
 */

static Sint
tsnn_nested(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (!(ac & SWAP(e))) {
    if (x)
      return 1;
    return 2;
  }

  return 3;
}

static Sint
tsnn_else_if(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (!(ac & SWAP(e)))
    return 1;
  else if (x)
    return 2;
  return 3;
}

static Sint
tsnn_loop_break(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  while (n-- > 0) {
    if (!(ac & SWAP(e)))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tsnn_loop_count(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  Sint c;

  c = 0;
  while (n-- > 0) {
    if (!(ac & SWAP(e)))
      ++c;
    ac += 1;
  }

  return c;
}

static Sint
tsnn_loop_memory(ac, ep, n)
Sint ac;
Sint *ep;
Sint n;
{
  Sint e;

  e = *ep;
  while (n-- > 0) {
    if (!(ac & SWAP(e)))
      return ac;
    ac += 1;
  }

  return ac;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
utsnn_clear(ac, e)
uSint ac;
uSint e;
{
  if (!(ac & SWAP(e)))
    return 0;
  return ac;
}

static uSint
utsnn_select(ac, e, yes, no)
uSint ac;
uSint e;
uSint yes;
uSint no;
{
  if (!(ac & SWAP(e)))
    return yes;
  return no;
}

static uSint
utsnn_mem(ac, e)
uSint ac;
uSint *e;
{
  uSint m;

  m = *e;
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static uSint
utsnn_global(ac)
uSint ac;
{
  if (!(ac & SWAP(tsnn_uga)))
    return 0;
  return ac;
}

static uSint
utsnn_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  uSint m;

  m = v[i & 017];
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static uSint
utsnn_global_array(ac, i)
uSint ac;
Sint i;
{
  uSint m;

  m = tsnn_ubuf[i & 017];
  if (!(ac & SWAP(m)))
    return 0;
  return ac;
}

static uSint
utsnn_struct_a(ac, p)
uSint ac;
struct tsnn_upair *p;
{
  if (!(ac & SWAP(p->a)))
    return 0;
  return ac;
}

static uSint
utsnn_global_struct_a(ac)
uSint ac;
{
  if (!(ac & SWAP(tsnn_ugp.a)))
    return 0;
  return ac;
}

static Sint
utsnn_bool(ac, e)
uSint ac;
uSint e;
{
  return (ac & SWAP(e)) == 0;
}

static Sint
utsnn_bool_mem(ac, e)
uSint ac;
uSint *e;
{
  uSint m;

  m = *e;
  return (ac & SWAP(m)) == 0;
}

static Sint
utsnn_bool_literal(ac)
uSint ac;
{
  return (ac & SWAP(0123456123456)) == 0;
}

static uSint
utsnn_call_add(ac, e)
uSint ac;
uSint e;
{
  if (!(ac & SWAP(e)))
    ac += (uSint)f();
  return ac;
}

/*
 * Promoted small-type inputs.  These are secondary pressure only.
 */

static Sint
tsnn_sqi(a, e)
sQint a;
Sint e;
{
  if (!(((Sint)a) & SWAP(e)))
    return 0;
  return a;
}

static Sint
tsnn_uqi(a, e)
uQint a;
Sint e;
{
  if (!(((Sint)a) & SWAP(e)))
    return 0;
  return a;
}

static Sint
tsnn_hi(a, e)
Hint a;
Sint e;
{
  if (!(((Sint)a) & SWAP(e)))
    return 0;
  return a;
}

static Sint
tsnn_uhi(a, e)
uHint a;
Sint e;
{
  if (!(((Sint)a) & SWAP(e)))
    return 0;
  return a;
}

static Sint
tsnn_sqi_sqi(a, b)
sQint a;
sQint b;
{
  if (!(((Sint)a) & SWAP((Sint)b)))
    return 0;
  return a;
}

static Sint
tsnn_uqi_uqi(a, b)
uQint a;
uQint b;
{
  if (!(((Sint)a) & SWAP((Sint)b)))
    return 0;
  return a;
}

static Sint
tsnn_hi_hi(a, b)
Hint a;
Hint b;
{
  if (!(((Sint)a) & SWAP((Sint)b)))
    return 0;
  return a;
}

static Sint
tsnn_uhi_uhi(a, b)
uHint a;
uHint b;
{
  if (!(((Sint)a) & SWAP((Sint)b)))
    return 0;
  return a;
}

static Sint
tsnn_sqi_bool(a, e)
sQint a;
Sint e;
{
  return (((Sint)a) & SWAP(e)) == 0;
}

static Sint
tsnn_uqi_bool(a, e)
uQint a;
Sint e;
{
  return (((Sint)a) & SWAP(e)) == 0;
}

static Sint
tsnn_hi_bool(a, e)
Hint a;
Sint e;
{
  return (((Sint)a) & SWAP(e)) == 0;
}

static Sint
tsnn_uhi_bool(a, e)
uHint a;
Sint e;
{
  return (((Sint)a) & SWAP(e)) == 0;
}
