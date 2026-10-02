#include "insns.h"

/*
 * TRNN instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended family:
 *   TRNN  AC,imm18    test AC right half against imm18,
 *                     skip if tested bits are zero,
 *                     no modification
 *
 * Ordinary C branch shape:
 *
 *   if (!(ac & 000000,,xxxxxx))
 *     ...
 *
 * Keep masks strictly in the right half.  Left-half zero-skip belongs
 * to TLNN.c; full-word direct zero-skip belongs to TDNN.c; swapped
 * zero-skip belongs to TSNN.c.  Nonzero right-half skip belongs to
 * TRNE.c.
 */

extern Sint f(void);

static Sint trnn_ga;
static uSint trnn_uga;
static volatile Sint trnn_vga;
static Sint trnn_buf[16];
static uSint trnn_ubuf[16];

struct trnn_pair {
  Sint a;
  Sint b;
};

struct trnn_upair {
  uSint a;
  uSint b;
};

static struct trnn_pair trnn_gp;
static struct trnn_upair trnn_ugp;

/*
 * Basic right-half zero-test branch forms.
 */

static Sint
trnn_clear(ac)
Sint ac;
{
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (!(ac & 0123456))
    return yes;
  return no;
}

static Sint
trnn_select_add(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (!(ac & 0123456))
    return yes + ac;
  return no + ac;
}

static Sint
trnn_call(ac)
Sint ac;
{
  if (!(ac & 0123456))
    return f();
  return ac;
}

static Sint
trnn_call_add(ac)
Sint ac;
{
  if (!(ac & 0123456))
    ac += f();
  return ac;
}

static Sint
trnn_likely(ac)
Sint ac;
{
  if (likely(!(ac & 0123456)))
    return 0;
  return ac;
}

static Sint
trnn_unlikely(ac)
Sint ac;
{
  if (unlikely(!(ac & 0123456)))
    return 0;
  return ac;
}

/*
 * Different right-half masks.
 */

static Sint
trnn_one(ac)
Sint ac;
{
  if (!(ac & 0000001))
    return 0;
  return ac;
}

static Sint
trnn_lowbits(ac)
Sint ac;
{
  if (!(ac & 0007777))
    return 0;
  return ac;
}

static Sint
trnn_highbit(ac)
Sint ac;
{
  if (!(ac & 0400000))
    return 0;
  return ac;
}

static Sint
trnn_all_right(ac)
Sint ac;
{
  if (!(ac & 0777777))
    return 0;
  return ac;
}

static Sint
trnn_alt1(ac)
Sint ac;
{
  if (!(ac & 0525252))
    return 0;
  return ac;
}

static Sint
trnn_alt2(ac)
Sint ac;
{
  if (!(ac & 0252525))
    return 0;
  return ac;
}

static Sint
trnn_sparse(ac)
Sint ac;
{
  if (!(ac & 0707070))
    return 0;
  return ac;
}

static Sint
trnn_edge(ac)
Sint ac;
{
  if (!(ac & 0400001))
    return 0;
  return ac;
}

/*
 * Memory, global, array, struct, and volatile sources.
 */

static Sint
trnn_mem(p)
Sint *p;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_mem_select(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456))
    return yes;
  return no;
}

static Sint
trnn_mem_call(p)
Sint *p;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456))
    return f();
  return ac;
}

static Sint
trnn_global(void)
{
  if (!(trnn_ga & 0123456))
    return 0;
  return trnn_ga;
}

static Sint
trnn_volatile_global(void)
{
  Sint ac;

  ac = trnn_vga;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_array(v, i)
Sint *v;
Sint i;
{
  Sint ac;

  ac = v[i & 017];
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_global_array(i)
Sint i;
{
  Sint ac;

  ac = trnn_buf[i & 017];
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_struct_a(p)
struct trnn_pair *p;
{
  Sint ac;

  ac = p->a;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_struct_b(p)
struct trnn_pair *p;
{
  Sint ac;

  ac = p->b;
  if (!(ac & 0525252))
    return 0;
  return ac;
}

static Sint
trnn_global_struct_a(void)
{
  Sint ac;

  ac = trnn_gp.a;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_global_struct_b(void)
{
  Sint ac;

  ac = trnn_gp.b;
  if (!(ac & 0525252))
    return 0;
  return ac;
}

static Sint
trnn_indirect(pp)
Sint **pp;
{
  Sint ac;

  ac = **pp;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
trnn_volatile(p)
volatile Sint *p;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

/*
 * Boolean value results.  These are useful for setcc-style lowering:
 * the test must produce a 0/1 value, not merely control flow.
 */

static Sint
trnn_bool(ac)
Sint ac;
{
  return (ac & 0123456) == 0;
}

static Sint
trnn_bool_not(ac)
Sint ac;
{
  return !((ac & 0123456) == 0);
}

static Sint
trnn_bool_one(ac)
Sint ac;
{
  return (ac & 0000001) == 0;
}

static Sint
trnn_bool_highbit(ac)
Sint ac;
{
  return (ac & 0400000) == 0;
}

static Sint
trnn_bool_all_right(ac)
Sint ac;
{
  return (ac & 0777777) == 0;
}

static Sint
trnn_bool_mem(p)
Sint *p;
{
  return (*p & 0123456) == 0;
}

static Sint
trnn_bool_global(void)
{
  return (trnn_ga & 0123456) == 0;
}

static Sint
trnn_bool_volatile(p)
volatile Sint *p;
{
  return (*p & 0123456) == 0;
}

static Sint
trnn_bool_add(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456) == 0) + y;
}

static Sint
trnn_bool_or(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456) == 0) | y;
}

static Sint
trnn_bool_xor(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456) == 0) ^ y;
}

static Sint
trnn_bool_mul(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456) == 0) * y;
}

/*
 * Tests where the masked value is also used after the branch.
 */

static Sint
trnn_value_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & 0123456;
  if (!t)
    return yes + t;
  return no + t;
}

static Sint
trnn_value_call(ac)
Sint ac;
{
  Sint t;

  t = ac & 0123456;
  if (!t)
    return t + f();
  return ac;
}

static Sint
trnn_value_mem(p)
Sint *p;
{
  Sint ac;
  Sint t;

  ac = *p;
  t = ac & 0123456;
  if (!t)
    return 0;
  return t + ac;
}

static Sint
trnn_source_live(ac, y)
Sint ac;
Sint y;
{
  Sint t;

  t = ac & 0123456;
  if (!t)
    return ac + y;
  return y;
}

static Sint
trnn_memory_source_live(p, y)
Sint *p;
Sint y;
{
  Sint ac;
  Sint t;

  ac = *p;
  t = ac & 0123456;
  if (!t)
    return ac + y;
  return y;
}

/*
 * Compound control-flow shapes.
 */

static Sint
trnn_nested(ac, x)
Sint ac;
Sint x;
{
  if (!(ac & 0123456)) {
    if (x)
      return 1;
    return 2;
  }

  return 3;
}

static Sint
trnn_else_if(ac, x)
Sint ac;
Sint x;
{
  if (!(ac & 0123456))
    return 1;
  else if (x)
    return 2;
  return 3;
}

static Sint
trnn_loop_break(ac, n)
Sint ac;
Sint n;
{
  while (n-- > 0) {
    if (!(ac & 0123456))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
trnn_loop_count(ac, n)
Sint ac;
Sint n;
{
  Sint c;

  c = 0;
  while (n-- > 0) {
    if (!(ac & 0123456))
      ++c;
    ac += 1;
  }

  return c;
}

static Sint
trnn_loop_mask_change(ac, n)
Sint ac;
Sint n;
{
  while (n-- > 0) {
    if (!(ac & 0400000))
      return ac;
    ac += 0100;
  }

  return ac;
}

/*
 * Unsigned variants.  Same machine-level operation, but signedness
 * must not block recognition.
 */

static uSint
utrnn_clear(ac)
uSint ac;
{
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static uSint
utrnn_select(ac, yes, no)
uSint ac;
uSint yes;
uSint no;
{
  if (!(ac & 0123456))
    return yes;
  return no;
}

static uSint
utrnn_one(ac)
uSint ac;
{
  if (!(ac & 0000001))
    return 0;
  return ac;
}

static uSint
utrnn_highbit(ac)
uSint ac;
{
  if (!(ac & 0400000))
    return 0;
  return ac;
}

static uSint
utrnn_all_right(ac)
uSint ac;
{
  if (!(ac & 0777777))
    return 0;
  return ac;
}

static uSint
utrnn_mem(p)
uSint *p;
{
  uSint ac;

  ac = *p;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static uSint
utrnn_global(void)
{
  if (!(trnn_uga & 0123456))
    return 0;
  return trnn_uga;
}

static uSint
utrnn_array(v, i)
uSint *v;
Sint i;
{
  uSint ac;

  ac = v[i & 017];
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static uSint
utrnn_global_array(i)
Sint i;
{
  uSint ac;

  ac = trnn_ubuf[i & 017];
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static uSint
utrnn_struct_a(p)
struct trnn_upair *p;
{
  uSint ac;

  ac = p->a;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static uSint
utrnn_global_struct_a(void)
{
  uSint ac;

  ac = trnn_ugp.a;
  if (!(ac & 0123456))
    return 0;
  return ac;
}

static Sint
utrnn_bool(ac)
uSint ac;
{
  return (ac & 0123456) == 0;
}

static Sint
utrnn_bool_mem(p)
uSint *p;
{
  return (*p & 0123456) == 0;
}

static Sint
utrnn_bool_literal(ac)
uSint ac;
{
  return (ac & 0525252) == 0;
}

static uSint
utrnn_call_add(ac)
uSint ac;
{
  if (!(ac & 0123456))
    ac += (uSint)f();
  return ac;
}

/*
 * Promoted small-type inputs.  These are secondary pressure only.
 */

static Sint
trnn_sqi(a)
sQint a;
{
  if (!(((Sint)a) & 0123456))
    return 0;
  return a;
}

static Sint
trnn_uqi(a)
uQint a;
{
  if (!(((Sint)a) & 0123456))
    return 0;
  return a;
}

static Sint
trnn_hi(a)
Hint a;
{
  if (!(((Sint)a) & 0123456))
    return 0;
  return a;
}

static Sint
trnn_uhi(a)
uHint a;
{
  if (!(((Sint)a) & 0123456))
    return 0;
  return a;
}

static Sint
trnn_sqi_bool(a)
sQint a;
{
  return (((Sint)a) & 0123456) == 0;
}

static Sint
trnn_uqi_bool(a)
uQint a;
{
  return (((Sint)a) & 0123456) == 0;
}

static Sint
trnn_hi_bool(a)
Hint a;
{
  return (((Sint)a) & 0123456) == 0;
}

static Sint
trnn_uhi_bool(a)
uHint a;
{
  return (((Sint)a) & 0123456) == 0;
}

static Sint
trnn_sqi_highbit(a)
sQint a;
{
  if (!(((Sint)a) & 0400000))
    return 0;
  return a;
}

static Sint
trnn_hi_all_right(a)
Hint a;
{
  if (!(((Sint)a) & 0777777))
    return 0;
  return a;
}
