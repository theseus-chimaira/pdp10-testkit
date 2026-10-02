#include "insns.h"

/*
 * TLNN instruction-family pressure for PDP-6/166 and KA10.
 *
 * Intended family:
 *   TLNN  AC,imm18    test AC left half against imm18,
 *                     skip if tested bits are zero,
 *                     no modification
 *
 * Ordinary C branch shape:
 *
 *   if (!(ac & xxxxxx,,000000))
 *     ...
 *
 * Keep masks strictly in the left half.  Right-half zero-skip belongs
 * to TRNN.c; full-word direct zero-skip belongs to TDNN.c; swapped
 * zero-skip belongs to TSNN.c.  Nonzero left-half skip belongs to
 * TLNE.c.
 */

extern Sint f(void);

static Sint tlnn_ga;
static uSint tlnn_uga;
static volatile Sint tlnn_vga;
static Sint tlnn_buf[16];
static uSint tlnn_ubuf[16];

struct tlnn_pair {
  Sint a;
  Sint b;
};

struct tlnn_upair {
  uSint a;
  uSint b;
};

static struct tlnn_pair tlnn_gp;
static struct tlnn_upair tlnn_ugp;

/*
 * Basic left-half zero-test branch forms.
 */

static Sint
tlnn_clear(ac)
Sint ac;
{
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (!(ac & 0123456000000))
    return yes;
  return no;
}

static Sint
tlnn_select_add(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (!(ac & 0123456000000))
    return yes + ac;
  return no + ac;
}

static Sint
tlnn_call(ac)
Sint ac;
{
  if (!(ac & 0123456000000))
    return f();
  return ac;
}

static Sint
tlnn_call_add(ac)
Sint ac;
{
  if (!(ac & 0123456000000))
    ac += f();
  return ac;
}

static Sint
tlnn_likely(ac)
Sint ac;
{
  if (likely(!(ac & 0123456000000)))
    return 0;
  return ac;
}

static Sint
tlnn_unlikely(ac)
Sint ac;
{
  if (unlikely(!(ac & 0123456000000)))
    return 0;
  return ac;
}

/*
 * Different left-half masks.
 */

static Sint
tlnn_one(ac)
Sint ac;
{
  if (!(ac & 000001000000))
    return 0;
  return ac;
}

static Sint
tlnn_lowbits(ac)
Sint ac;
{
  if (!(ac & 0007777000000))
    return 0;
  return ac;
}

static Sint
tlnn_signbit(ac)
Sint ac;
{
  if (!(ac & 0400000000000))
    return 0;
  return ac;
}

static Sint
tlnn_all_left(ac)
Sint ac;
{
  if (!(ac & 0777777000000))
    return 0;
  return ac;
}

static Sint
tlnn_alt1(ac)
Sint ac;
{
  if (!(ac & 0525252000000))
    return 0;
  return ac;
}

static Sint
tlnn_alt2(ac)
Sint ac;
{
  if (!(ac & 0252525000000))
    return 0;
  return ac;
}

static Sint
tlnn_sparse(ac)
Sint ac;
{
  if (!(ac & 0707070000000))
    return 0;
  return ac;
}

static Sint
tlnn_edge(ac)
Sint ac;
{
  if (!(ac & 0400001000000))
    return 0;
  return ac;
}

/*
 * Memory, global, array, struct, and volatile sources.
 */

static Sint
tlnn_mem(p)
Sint *p;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_mem_select(p, yes, no)
Sint *p;
Sint yes;
Sint no;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456000000))
    return yes;
  return no;
}

static Sint
tlnn_mem_call(p)
Sint *p;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456000000))
    return f();
  return ac;
}

static Sint
tlnn_global(void)
{
  if (!(tlnn_ga & 0123456000000))
    return 0;
  return tlnn_ga;
}

static Sint
tlnn_volatile_global(void)
{
  Sint ac;

  ac = tlnn_vga;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_array(v, i)
Sint *v;
Sint i;
{
  Sint ac;

  ac = v[i & 017];
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_global_array(i)
Sint i;
{
  Sint ac;

  ac = tlnn_buf[i & 017];
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_struct_a(p)
struct tlnn_pair *p;
{
  Sint ac;

  ac = p->a;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_struct_b(p)
struct tlnn_pair *p;
{
  Sint ac;

  ac = p->b;
  if (!(ac & 0525252000000))
    return 0;
  return ac;
}

static Sint
tlnn_global_struct_a(void)
{
  Sint ac;

  ac = tlnn_gp.a;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_global_struct_b(void)
{
  Sint ac;

  ac = tlnn_gp.b;
  if (!(ac & 0525252000000))
    return 0;
  return ac;
}

static Sint
tlnn_indirect(pp)
Sint **pp;
{
  Sint ac;

  ac = **pp;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
tlnn_volatile(p)
volatile Sint *p;
{
  Sint ac;

  ac = *p;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

/*
 * Boolean value results.  These are useful for setcc-style lowering:
 * the test must produce a 0/1 value, not merely control flow.
 */

static Sint
tlnn_bool(ac)
Sint ac;
{
  return (ac & 0123456000000) == 0;
}

static Sint
tlnn_bool_not(ac)
Sint ac;
{
  return !((ac & 0123456000000) == 0);
}

static Sint
tlnn_bool_one(ac)
Sint ac;
{
  return (ac & 000001000000) == 0;
}

static Sint
tlnn_bool_signbit(ac)
Sint ac;
{
  return (ac & 0400000000000) == 0;
}

static Sint
tlnn_bool_all_left(ac)
Sint ac;
{
  return (ac & 0777777000000) == 0;
}

static Sint
tlnn_bool_mem(p)
Sint *p;
{
  return (*p & 0123456000000) == 0;
}

static Sint
tlnn_bool_global(void)
{
  return (tlnn_ga & 0123456000000) == 0;
}

static Sint
tlnn_bool_volatile(p)
volatile Sint *p;
{
  return (*p & 0123456000000) == 0;
}

static Sint
tlnn_bool_add(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456000000) == 0) + y;
}

static Sint
tlnn_bool_or(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456000000) == 0) | y;
}

static Sint
tlnn_bool_xor(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456000000) == 0) ^ y;
}

static Sint
tlnn_bool_mul(ac, y)
Sint ac;
Sint y;
{
  return ((ac & 0123456000000) == 0) * y;
}

/*
 * Tests where the masked value is also used after the branch.
 */

static Sint
tlnn_value_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  Sint t;

  t = ac & 0123456000000;
  if (!t)
    return yes + t;
  return no + t;
}

static Sint
tlnn_value_call(ac)
Sint ac;
{
  Sint t;

  t = ac & 0123456000000;
  if (!t)
    return t + f();
  return ac;
}

static Sint
tlnn_value_mem(p)
Sint *p;
{
  Sint ac;
  Sint t;

  ac = *p;
  t = ac & 0123456000000;
  if (!t)
    return 0;
  return t + ac;
}

static Sint
tlnn_source_live(ac, y)
Sint ac;
Sint y;
{
  Sint t;

  t = ac & 0123456000000;
  if (!t)
    return ac + y;
  return y;
}

static Sint
tlnn_memory_source_live(p, y)
Sint *p;
Sint y;
{
  Sint ac;
  Sint t;

  ac = *p;
  t = ac & 0123456000000;
  if (!t)
    return ac + y;
  return y;
}

/*
 * Compound control-flow shapes.
 */

static Sint
tlnn_nested(ac, x)
Sint ac;
Sint x;
{
  if (!(ac & 0123456000000)) {
    if (x)
      return 1;
    return 2;
  }

  return 3;
}

static Sint
tlnn_else_if(ac, x)
Sint ac;
Sint x;
{
  if (!(ac & 0123456000000))
    return 1;
  else if (x)
    return 2;
  return 3;
}

static Sint
tlnn_loop_break(ac, n)
Sint ac;
Sint n;
{
  while (n-- > 0) {
    if (!(ac & 0123456000000))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tlnn_loop_count(ac, n)
Sint ac;
Sint n;
{
  Sint c;

  c = 0;
  while (n-- > 0) {
    if (!(ac & 0123456000000))
      ++c;
    ac += 1;
  }

  return c;
}

static Sint
tlnn_loop_mask_change(ac, n)
Sint ac;
Sint n;
{
  while (n-- > 0) {
    if (!(ac & 0400000000000))
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
utlnn_clear(ac)
uSint ac;
{
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static uSint
utlnn_select(ac, yes, no)
uSint ac;
uSint yes;
uSint no;
{
  if (!(ac & 0123456000000))
    return yes;
  return no;
}

static uSint
utlnn_one(ac)
uSint ac;
{
  if (!(ac & 000001000000))
    return 0;
  return ac;
}

static uSint
utlnn_signbit(ac)
uSint ac;
{
  if (!(ac & 0400000000000))
    return 0;
  return ac;
}

static uSint
utlnn_all_left(ac)
uSint ac;
{
  if (!(ac & 0777777000000))
    return 0;
  return ac;
}

static uSint
utlnn_mem(p)
uSint *p;
{
  uSint ac;

  ac = *p;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static uSint
utlnn_global(void)
{
  if (!(tlnn_uga & 0123456000000))
    return 0;
  return tlnn_uga;
}

static uSint
utlnn_array(v, i)
uSint *v;
Sint i;
{
  uSint ac;

  ac = v[i & 017];
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static uSint
utlnn_global_array(i)
Sint i;
{
  uSint ac;

  ac = tlnn_ubuf[i & 017];
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static uSint
utlnn_struct_a(p)
struct tlnn_upair *p;
{
  uSint ac;

  ac = p->a;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static uSint
utlnn_global_struct_a(void)
{
  uSint ac;

  ac = tlnn_ugp.a;
  if (!(ac & 0123456000000))
    return 0;
  return ac;
}

static Sint
utlnn_bool(ac)
uSint ac;
{
  return (ac & 0123456000000) == 0;
}

static Sint
utlnn_bool_mem(p)
uSint *p;
{
  return (*p & 0123456000000) == 0;
}

static Sint
utlnn_bool_literal(ac)
uSint ac;
{
  return (ac & 0525252000000) == 0;
}

static uSint
utlnn_call_add(ac)
uSint ac;
{
  if (!(ac & 0123456000000))
    ac += (uSint)f();
  return ac;
}

/*
 * Promoted small-type inputs.  These are secondary pressure only.
 */

static Sint
tlnn_sqi(a)
sQint a;
{
  if (!(((Sint)a) & 0123456000000))
    return 0;
  return a;
}

static Sint
tlnn_uqi(a)
uQint a;
{
  if (!(((Sint)a) & 0123456000000))
    return 0;
  return a;
}

static Sint
tlnn_hi(a)
Hint a;
{
  if (!(((Sint)a) & 0123456000000))
    return 0;
  return a;
}

static Sint
tlnn_uhi(a)
uHint a;
{
  if (!(((Sint)a) & 0123456000000))
    return 0;
  return a;
}

static Sint
tlnn_sqi_bool(a)
sQint a;
{
  return (((Sint)a) & 0123456000000) == 0;
}

static Sint
tlnn_uqi_bool(a)
uQint a;
{
  return (((Sint)a) & 0123456000000) == 0;
}

static Sint
tlnn_hi_bool(a)
Hint a;
{
  return (((Sint)a) & 0123456000000) == 0;
}

static Sint
tlnn_uhi_bool(a)
uHint a;
{
  return (((Sint)a) & 0123456000000) == 0;
}

static Sint
tlnn_sqi_signbit(a)
sQint a;
{
  if (!(((Sint)a) & 0400000000000))
    return 0;
  return a;
}

static Sint
tlnn_hi_all_left(a)
Hint a;
{
  if (!(((Sint)a) & 0777777000000))
    return 0;
  return a;
}
