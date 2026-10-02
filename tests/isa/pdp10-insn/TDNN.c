#include "insns.h"

/*
 * TDNN instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended family:
 *   TDNN  AC,E    test AC against E,
 *                 skip if tested bits are zero,
 *                 no modification
 *
 * Ordinary C branch shape:
 *
 *   if (!(ac & e))
 *     ...
 *
 * Keep this file focused on full-word direct zero tests.  Right-half
 * immediate zero-skip belongs to TRNN.c.  Left-half immediate zero-skip
 * belongs to TLNN.c.  Swapped-source zero-skip belongs to TSNN.c.
 * Full-word direct nonzero-skip belongs to TDNE.c.
 */

extern Sint f(void);

static Sint tdnn_ga;
static Sint tdnn_gb;
static uSint tdnn_uga;
static volatile Sint tdnn_vga;
static Sint tdnn_buf[16];
static uSint tdnn_ubuf[16];

struct tdnn_pair {
  Sint a;
  Sint b;
};

struct tdnn_upair {
  uSint a;
  uSint b;
};

static struct tdnn_pair tdnn_gp;
static struct tdnn_upair tdnn_ugp;

/*
 * Basic full-word direct zero-test branch forms.
 */

static Sint
tdnn_clear(ac, e)
Sint ac;
Sint e;
{
  if (!(ac & e))
    return 0;
  return ac;
}

static Sint
tdnn_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (!(ac & e))
    return yes;
  return no;
}

static Sint
tdnn_select_add(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (!(ac & e))
    return yes + ac;
  return no + ac;
}

static Sint
tdnn_call(ac, e)
Sint ac;
Sint e;
{
  if (!(ac & e))
    return f();
  return ac;
}

static Sint
tdnn_call_add(ac, e)
Sint ac;
Sint e;
{
  if (!(ac & e))
    ac += f();
  return ac;
}

static Sint
tdnn_likely(ac, e)
Sint ac;
Sint e;
{
  if (likely(!(ac & e)))
    return 0;
  return ac;
}

static Sint
tdnn_unlikely(ac, e)
Sint ac;
Sint e;
{
  if (unlikely(!(ac & e)))
    return 0;
  return ac;
}

/*
 * Literal full-word masks.
 */

static Sint
tdnn_literal_a(ac)
Sint ac;
{
  if (!(ac & 0123456123456))
    return 0;
  return ac;
}

static Sint
tdnn_literal_b(ac)
Sint ac;
{
  if (!(ac & 0525252252525))
    return 0;
  return ac;
}

static Sint
tdnn_literal_sparse(ac)
Sint ac;
{
  if (!(ac & 0707070070707))
    return 0;
  return ac;
}

static Sint
tdnn_literal_left(ac)
Sint ac;
{
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tdnn_literal_right(ac)
Sint ac;
{
  if (!(ac & 0000000123456))
    return 0;
  return ac;
}

static Sint
tdnn_literal_signbit(ac)
Sint ac;
{
  if (!(ac & 0400000000000))
    return 0;
  return ac;
}

static Sint
tdnn_literal_all(ac)
Sint ac;
{
  if (!(ac & 0777777777777))
    return 0;
  return ac;
}

/*
 * Memory, global, array, struct, and volatile sources.
 */

static Sint
tdnn_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_mem_select(ac, e, yes, no)
Sint ac;
Sint *e;
Sint yes;
Sint no;
{
  Sint m;

  m = *e;
  if (!(ac & m))
    return yes;
  return no;
}

static Sint
tdnn_mem_call(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  if (!(ac & m))
    return f();
  return ac;
}

static Sint
tdnn_global(ac)
Sint ac;
{
  if (!(ac & tdnn_ga))
    return 0;
  return ac;
}

static Sint
tdnn_global_global(void)
{
  if (!(tdnn_ga & tdnn_gb))
    return 0;
  return tdnn_ga;
}

static Sint
tdnn_volatile_global(ac)
Sint ac;
{
  Sint m;

  m = tdnn_vga;
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  Sint m;

  m = v[i & 017];
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_global_array(ac, i)
Sint ac;
Sint i;
{
  Sint m;

  m = tdnn_buf[i & 017];
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_array_array(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  Sint ac;
  Sint m;

  ac = v[i & 017];
  m = v[j & 017];
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_struct_a(ac, p)
Sint ac;
struct tdnn_pair *p;
{
  if (!(ac & p->a))
    return 0;
  return ac;
}

static Sint
tdnn_struct_b(ac, p)
Sint ac;
struct tdnn_pair *p;
{
  if (!(ac & p->b))
    return 0;
  return ac;
}

static Sint
tdnn_global_struct_a(ac)
Sint ac;
{
  if (!(ac & tdnn_gp.a))
    return 0;
  return ac;
}

static Sint
tdnn_global_struct_b(ac)
Sint ac;
{
  if (!(ac & tdnn_gp.b))
    return 0;
  return ac;
}

static Sint
tdnn_struct_struct(p)
struct tdnn_pair *p;
{
  if (!(p->a & p->b))
    return 0;
  return p->a;
}

static Sint
tdnn_indirect(ac, pp)
Sint ac;
Sint **pp;
{
  Sint m;

  m = **pp;
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_volatile(ac, e)
Sint ac;
volatile Sint *e;
{
  Sint m;

  m = *e;
  if (!(ac & m))
    return 0;
  return ac;
}

static Sint
tdnn_volatile_volatile(a, b)
volatile Sint *a;
volatile Sint *b;
{
  Sint ac;
  Sint m;

  ac = *a;
  m = *b;
  if (!(ac & m))
    return 0;
  return ac;
}

/*
 * Boolean value results.  These are useful for setcc-style lowering:
 * the test must produce a 0/1 value, not merely control flow.
 */

static Sint
tdnn_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & e) == 0;
}

static Sint
tdnn_bool_not(ac, e)
Sint ac;
Sint e;
{
  return !((ac & e) == 0);
}

static Sint
tdnn_bool_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;

  m = *e;
  return (ac & m) == 0;
}

static Sint
tdnn_bool_global(ac)
Sint ac;
{
  return (ac & tdnn_ga) == 0;
}

static Sint
tdnn_bool_literal(ac)
Sint ac;
{
  return (ac & 0123456123456) == 0;
}

static Sint
tdnn_bool_left_literal(ac)
Sint ac;
{
  return (ac & 0123456000000) == 0;
}

static Sint
tdnn_bool_right_literal(ac)
Sint ac;
{
  return (ac & 0000000123456) == 0;
}

static Sint
tdnn_bool_signbit(ac)
Sint ac;
{
  return (ac & 0400000000000) == 0;
}

static Sint
tdnn_bool_add(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & e) == 0) + y;
}

static Sint
tdnn_bool_or(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & e) == 0) | y;
}

static Sint
tdnn_bool_xor(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & e) == 0) ^ y;
}

static Sint
tdnn_bool_mul(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  return ((ac & e) == 0) * y;
}

/*
 * Tests where the masked value is also used after the branch.
 */

static Sint
tdnn_value_select(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & e;
  if (!t)
    return yes + t;
  return no + t;
}

static Sint
tdnn_value_call(ac, e)
Sint ac;
Sint e;
{
  Sint t;

  t = ac & e;
  if (!t)
    return t + f();
  return ac;
}

static Sint
tdnn_value_mem(ac, e)
Sint ac;
Sint *e;
{
  Sint m;
  Sint t;

  m = *e;
  t = ac & m;
  if (!t)
    return 0;
  return t + ac;
}

static Sint
tdnn_sources_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint t;

  t = ac & e;
  if (!t)
    return ac + e + y;
  return y;
}

static Sint
tdnn_memory_sources_live(ap, ep, y)
Sint *ap;
Sint *ep;
Sint y;
{
  Sint ac;
  Sint e;
  Sint t;

  ac = *ap;
  e = *ep;
  t = ac & e;
  if (!t)
    return ac + e + y;
  return y;
}

/*
 * Compound control-flow shapes.
 */

static Sint
tdnn_nested(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (!(ac & e)) {
    if (x)
      return 1;
    return 2;
  }

  return 3;
}

static Sint
tdnn_else_if(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (!(ac & e))
    return 1;
  else if (x)
    return 2;
  return 3;
}

static Sint
tdnn_loop_break(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  while (n-- > 0) {
    if (!(ac & e))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tdnn_loop_count(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  Sint c;

  c = 0;
  while (n-- > 0) {
    if (!(ac & e))
      ++c;
    ac += 1;
  }

  return c;
}

static Sint
tdnn_loop_memory(ac, ep, n)
Sint ac;
Sint *ep;
Sint n;
{
  Sint e;

  e = *ep;
  while (n-- > 0) {
    if (!(ac & e))
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
utdnn_clear(ac, e)
uSint ac;
uSint e;
{
  if (!(ac & e))
    return 0;
  return ac;
}

static uSint
utdnn_select(ac, e, yes, no)
uSint ac;
uSint e;
uSint yes;
uSint no;
{
  if (!(ac & e))
    return yes;
  return no;
}

static uSint
utdnn_mem(ac, e)
uSint ac;
uSint *e;
{
  uSint m;

  m = *e;
  if (!(ac & m))
    return 0;
  return ac;
}

static uSint
utdnn_global(ac)
uSint ac;
{
  if (!(ac & tdnn_uga))
    return 0;
  return ac;
}

static uSint
utdnn_array(ac, v, i)
uSint ac;
uSint *v;
Sint i;
{
  uSint m;

  m = v[i & 017];
  if (!(ac & m))
    return 0;
  return ac;
}

static uSint
utdnn_global_array(ac, i)
uSint ac;
Sint i;
{
  uSint m;

  m = tdnn_ubuf[i & 017];
  if (!(ac & m))
    return 0;
  return ac;
}

static uSint
utdnn_struct_a(ac, p)
uSint ac;
struct tdnn_upair *p;
{
  if (!(ac & p->a))
    return 0;
  return ac;
}

static uSint
utdnn_global_struct_a(ac)
uSint ac;
{
  if (!(ac & tdnn_ugp.a))
    return 0;
  return ac;
}

static Sint
utdnn_bool(ac, e)
uSint ac;
uSint e;
{
  return (ac & e) == 0;
}

static Sint
utdnn_bool_mem(ac, e)
uSint ac;
uSint *e;
{
  uSint m;

  m = *e;
  return (ac & m) == 0;
}

static Sint
utdnn_bool_literal(ac)
uSint ac;
{
  return (ac & 0123456123456) == 0;
}

static uSint
utdnn_call_add(ac, e)
uSint ac;
uSint e;
{
  if (!(ac & e))
    ac += (uSint)f();
  return ac;
}

/*
 * Promoted small-type inputs.  These are secondary pressure only.
 */

static Sint
tdnn_sqi(a, e)
sQint a;
Sint e;
{
  if (!(((Sint)a) & e))
    return 0;
  return a;
}

static Sint
tdnn_uqi(a, e)
uQint a;
Sint e;
{
  if (!(((Sint)a) & e))
    return 0;
  return a;
}

static Sint
tdnn_hi(a, e)
Hint a;
Sint e;
{
  if (!(((Sint)a) & e))
    return 0;
  return a;
}

static Sint
tdnn_uhi(a, e)
uHint a;
Sint e;
{
  if (!(((Sint)a) & e))
    return 0;
  return a;
}

static Sint
tdnn_sqi_sqi(a, b)
sQint a;
sQint b;
{
  if (!(((Sint)a) & ((Sint)b)))
    return 0;
  return a;
}

static Sint
tdnn_uqi_uqi(a, b)
uQint a;
uQint b;
{
  if (!(((Sint)a) & ((Sint)b)))
    return 0;
  return a;
}

static Sint
tdnn_hi_hi(a, b)
Hint a;
Hint b;
{
  if (!(((Sint)a) & ((Sint)b)))
    return 0;
  return a;
}

static Sint
tdnn_uhi_uhi(a, b)
uHint a;
uHint b;
{
  if (!(((Sint)a) & ((Sint)b)))
    return 0;
  return a;
}

static Sint
tdnn_sqi_bool(a, e)
sQint a;
Sint e;
{
  return (((Sint)a) & e) == 0;
}

static Sint
tdnn_uqi_bool(a, e)
uQint a;
Sint e;
{
  return (((Sint)a) & e) == 0;
}

static Sint
tdnn_hi_bool(a, e)
Hint a;
Sint e;
{
  return (((Sint)a) & e) == 0;
}

static Sint
tdnn_uhi_bool(a, e)
uHint a;
Sint e;
{
  return (((Sint)a) & e) == 0;
}
