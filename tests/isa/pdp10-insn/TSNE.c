#include "insns.h"

/*
 * TSNE instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended family:
 *   TSNE  AC,E    test AC against SWAP(E), skip if nonzero,
 *                 no modification
 *
 * Ordinary C branch shape:
 *
 *   if (ac & SWAP(e))
 *     ...
 *
 * Keep this file focused on swapped-source nonzero tests.  Direct
 * full-word nonzero tests belong to TDNE.c.  Right-half and left-half
 * immediate nonzero tests belong to TRNE.c and TLNE.c.  The zero-skip
 * swapped form belongs to TSNN.c.
 */

extern Sint f(void);

static Sint tsne_ga;
static Sint tsne_gb;
static uSint tsne_uga;
static volatile Sint tsne_vga;
static Sint tsne_buf[16];
static uSint tsne_ubuf[16];

struct tsne_pair {
  Sint a;
  Sint b;
};

struct tsne_upair {
  uSint a;
  uSint b;
};

static struct tsne_pair tsne_gp;
static struct tsne_upair tsne_ugp;

/*
 * Basic branch forms.
 */

static Sint
tsne_clear(ac, e)
Sint ac;
Sint e;
{
  if (ac & SWAP(e))
    return 0;
  return ac;
}

static Sint
tsne_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (ac & SWAP(e))
    return yes;
  return no;
}

static Sint
tsne_select_add(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (ac & SWAP(e))
    return yes + ac;
  return no + ac;
}

static Sint
tsne_call(ac, e)
Sint ac;
Sint e;
{
  if (ac & SWAP(e))
    return f();
  return ac;
}

static Sint
tsne_call_add(ac, e)
Sint ac;
Sint e;
{
  if (ac & SWAP(e))
    ac += f();
  return ac;
}

static Sint
tsne_likely(ac, e)
Sint ac;
Sint e;
{
  if (likely(ac & SWAP(e)))
    return 0;
  return ac;
}

static Sint
tsne_unlikely(ac, e)
Sint ac;
Sint e;
{
  if (unlikely(ac & SWAP(e)))
    return 0;
  return ac;
}

/*
 * Literal swapped masks.
 */

static Sint
tsne_literal_a(ac)
Sint ac;
{
  if (ac & SWAP(0123456123456))
    return 0;
  return ac;
}

static Sint
tsne_literal_b(ac)
Sint ac;
{
  if (ac & SWAP(0525252252525))
    return 0;
  return ac;
}

static Sint
tsne_literal_sparse(ac)
Sint ac;
{
  if (ac & SWAP(0707070070707))
    return 0;
  return ac;
}

static Sint
tsne_literal_left(ac)
Sint ac;
{
  if (ac & SWAP(0123456000000))
    return 0;
  return ac;
}

static Sint
tsne_literal_right(ac)
Sint ac;
{
  if (ac & SWAP(0000000123456))
    return 0;
  return ac;
}

static Sint
tsne_literal_signbit(ac)
Sint ac;
{
  if (ac & SWAP(0400000000000))
    return 0;
  return ac;
}

static Sint
tsne_literal_all(ac)
Sint ac;
{
  if (ac & SWAP(0777777777777))
    return 0;
  return ac;
}

/*
 * Memory, global, array, struct, and volatile sources.
 */

static Sint
tsne_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_mem_select(ac, e, yes, no)
Sint ac;
Sint *e;
Sint yes;
Sint no;
{
  Sint m;

  m = *e;
  if (ac & SWAP(m))
    return yes;
  return no;
}

static Sint
tsne_mem_call(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  if (ac & SWAP(m))
    return f();
  return ac;
}

static Sint
tsne_global(ac)
Sint ac;
{
  if (ac & SWAP(tsne_ga))
    return 0;
  return ac;
}

static Sint
tsne_global_global(void)
{
  if (tsne_ga & SWAP(tsne_gb))
    return 0;
  return tsne_ga;
}

static Sint
tsne_volatile_global(ac)
Sint ac;
{
  Sint m;

  m = tsne_vga;
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  Sint m;

  m = v[i & 017];
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_global_array(ac, i)
Sint ac;
Sint i;
{
  Sint m;

  m = tsne_buf[i & 017];
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  Sint ac;
  Sint m;

  ac = v[i & 017];
  m = v[j & 017];
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_struct_a(ac, p)
Sint ac;
struct tsne_pair *p;
{
  if (ac & SWAP(p->a))
    return 0;
  return ac;
}

static Sint
tsne_struct_b(ac, p)
Sint ac;
struct tsne_pair *p;
{
  if (ac & SWAP(p->b))
    return 0;
  return ac;
}

static Sint
tsne_global_struct_a(ac)
Sint ac;
{
  if (ac & SWAP(tsne_gp.a))
    return 0;
  return ac;
}

static Sint
tsne_global_struct_b(ac)
Sint ac;
{
  if (ac & SWAP(tsne_gp.b))
    return 0;
  return ac;
}

static Sint
tsne_struct_struct(p)
struct tsne_pair *p;
{
  if (p->a & SWAP(p->b))
    return 0;
  return p->a;
}

static Sint
tsne_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  Sint m;

  m = **pp;
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  Sint m;

  m = *e;
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static Sint
tsne_volatile_volatile(a, b)
volatile Sint *a;
volatile Sint *b;
{
  Sint ac;
  Sint m;

  ac = *a;
  m = *b;
  if (ac & SWAP(m))
    return 0;
  return ac;
}

/*
 * Boolean value results.  These are useful for setcc-style lowering:
 * the comparison must produce a 0/1 value, not merely control flow.
 */

static Sint
tsne_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & SWAP(e)) != 0;
}

static Sint
tsne_bool_not(ac, e)
Sint ac;
Sint e;
{
  return !((ac & SWAP(e)) != 0);
}

static Sint
tsne_bool_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return (ac & SWAP(m)) != 0;
}

static Sint
tsne_bool_global(ac)
Sint ac;
{
  return (ac & SWAP(tsne_ga)) != 0;
}

static Sint
tsne_bool_literal(ac)
Sint ac;
{
  return (ac & SWAP(0123456123456)) != 0;
}

static Sint
tsne_bool_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) != 0) + y;
}

static Sint
tsne_bool_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) != 0) | y;
}

static Sint
tsne_bool_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & SWAP(e)) != 0) ^ y;
}

/*
 * Tests where the masked value is also used after the branch.
 */

static Sint
tsne_value_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & m;
  if (t)
    return yes + t;
  return no + t;
}

static Sint
tsne_value_call(ac, e)
Sint ac;
Sint e;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & m;
  if (t)
    return t + f();
  return ac;
}

static Sint
tsne_value_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = SWAP(*e);
  t = ac & m;
  if (t)
    return 0;
  return t + ac;
}

static Sint
tsne_sources_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint m;

  m = SWAP(e);
  if (ac & m)
    return ac + e + y;
  return y;
}

static Sint
tsne_memory_sources_live(ap, ep, y)
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
  if (ac & m)
    return ac + e + y;
  return y;
}

/*
 * Compound control-flow shapes.
 */

static Sint
tsne_nested(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (ac & SWAP(e)) {
    if (x)
      return 1;
    return 2;
  }

  return 3;
}

static Sint
tsne_else_if(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (ac & SWAP(e))
    return 1;
  else if (x)
    return 2;
  return 3;
}

static Sint
tsne_loop_break(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  while (n-- > 0) {
    if (ac & SWAP(e))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tsne_loop_count(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  Sint c;

  c = 0;
  while (n-- > 0) {
    if (ac & SWAP(e))
      ++c;
    ac += 1;
  }

  return c;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
utsne_clear(ac, e)
uSint ac;
uSint e;
{
  if (ac & SWAP(e))
    return 0;
  return ac;
}

static uSint
utsne_select(ac, e, yes, no)
uSint ac;
uSint e;
uSint yes;
uSint no;
{
  if (ac & SWAP(e))
    return yes;
  return no;
}

static uSint
utsne_mem(ac, e)
uSint ac;
uSint *e;
{
  uSint m;

  m = *e;
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static uSint
utsne_global(ac)
uSint ac;
{
  if (ac & SWAP(tsne_uga))
    return 0;
  return ac;
}

static uSint
utsne_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  uSint m;

  m = v[i & 017];
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static uSint
utsne_global_array(ac, i)
uSint ac;
Sint i;
{
  uSint m;

  m = tsne_ubuf[i & 017];
  if (ac & SWAP(m))
    return 0;
  return ac;
}

static uSint
utsne_struct_a(ac, p)
uSint ac;
struct tsne_upair *p;
{
  if (ac & SWAP(p->a))
    return 0;
  return ac;
}

static uSint
utsne_global_struct_a(ac)
uSint ac;
{
  if (ac & SWAP(tsne_ugp.a))
    return 0;
  return ac;
}

static Sint
utsne_bool(ac, e)
uSint ac;
uSint e;
{
  return (ac & SWAP(e)) != 0;
}

static Sint
utsne_bool_mem(ac, e)
uSint ac;
uSint *e;
{
  uSint m;

  m = *e;
  return (ac & SWAP(m)) != 0;
}

static Sint
utsne_bool_literal(ac)
uSint ac;
{
  return (ac & SWAP(0123456123456)) != 0;
}

static uSint
utsne_call_add(ac, e)
uSint ac;
uSint e;
{
  if (ac & SWAP(e))
    ac += (uSint)f();
  return ac;
}

/*
 * Promoted small-type inputs.  These are secondary pressure only.
 */

static Sint
tsne_sqi(a, e)
sQint a;
Sint e;
{
  if (((Sint)a) & SWAP(e))
    return 0;
  return a;
}

static Sint
tsne_uqi(a, e)
uQint a;
Sint e;
{
  if (((Sint)a) & SWAP(e))
    return 0;
  return a;
}

static Sint
tsne_hi(a, e)
Hint a;
Sint e;
{
  if (((Sint)a) & SWAP(e))
    return 0;
  return a;
}

static Sint
tsne_uhi(a, e)
uHint a;
Sint e;
{
  if (((Sint)a) & SWAP(e))
    return 0;
  return a;
}

static Sint
tsne_sqi_sqi(a, b)
sQint a;
sQint b;
{
  if (((Sint)a) & SWAP((Sint)b))
    return 0;
  return a;
}

static Sint
tsne_uqi_uqi(a, b)
uQint a;
uQint b;
{
  if (((Sint)a) & SWAP((Sint)b))
    return 0;
  return a;
}

static Sint
tsne_hi_hi(a, b)
Hint a;
Hint b;
{
  if (((Sint)a) & SWAP((Sint)b))
    return 0;
  return a;
}

static Sint
tsne_uhi_uhi(a, b)
uHint a;
uHint b;
{
  if (((Sint)a) & SWAP((Sint)b))
    return 0;
  return a;
}
