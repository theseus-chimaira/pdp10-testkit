#include "insns.h"


/*
 * Generic test-and-skip pattern pressure for PDP-6/166 and KA10.
 *
 * This is a pattern-level collector.  The large per-instruction-family
 * tests live under insn/, e.g. TRNE.c, TRNN.c, TLNE.c, TLNN.c,
 * TDNE.c, TDNN.c, TSNE.c, TSNN.c.
 *
 * Covered shapes:
 *   TRNE/TRNN  right-half immediate test
 *   TLNE/TLNN  left-half immediate test
 *   TDNE/TDNN  full-word direct test
 *   TSNE/TSNN  swapped-source test
 *
 * Do not use inline assembly here.
 */

extern Sint f(void);
extern void clobber(void);

static Sint tskip_ga;
static Sint tskip_gb;
static volatile Sint tskip_vga;
static Sint tskip_buf[16];

struct tskip_pair {
  Sint a;
  Sint b;
};

struct tskip_three {
  Sint a;
  Sint b;
  Sint c;
};

static struct tskip_pair tskip_gp;
static struct tskip_three tskip_gt;

/*
 * Original skeleton shapes, kept with short names.
 */

static Sint
trne(AC)
Sint AC;
{
  if (AC & 0123456)
    AC = 0;
  return AC;
}

static Sint
trnn(AC)
Sint AC;
{
  if (!(AC & 0123456))
    AC = 0;
  return AC;
}

static Sint
tlne(AC)
Sint AC;
{
  if (AC & 0123456000000)
    AC = 0;
  return AC;
}

static Sint
tlnn(AC)
Sint AC;
{
  if (!(AC & 0123456000000))
    AC = 0;
  return AC;
}

static Sint
tdne1(AC)
Sint AC;
{
  if (AC & 0123456123456)
    AC = 0;
  return AC;
}

static Sint
tdnn1(AC)
Sint AC;
{
  if (!(AC & 0123456123456))
    AC = 0;
  return AC;
}

static Sint
tdne2(AC, X)
Sint AC;
Sint *X;
{
  if (AC & *X)
    AC = 0;
  return AC;
}

static Sint
tdnn2(AC, X)
Sint AC;
Sint *X;
{
  if (!(AC & *X))
    AC = 0;
  return AC;
}

/*
 * Right-half immediate nonzero/zero tests.
 */

static Sint
trne_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (ac & 0123456)
    return yes;
  return no;
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
trne_call(ac)
Sint ac;
{
  if (ac & 0123456)
    return f();
  return ac;
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
trne_one(ac)
Sint ac;
{
  if (ac & 0000001)
    return 1;
  return ac;
}

static Sint
trnn_one(ac)
Sint ac;
{
  if (!(ac & 0000001))
    return 1;
  return ac;
}

static Sint
trne_highbit(ac)
Sint ac;
{
  if (ac & 0400000)
    return 1;
  return ac;
}

static Sint
trnn_highbit(ac)
Sint ac;
{
  if (!(ac & 0400000))
    return 1;
  return ac;
}

static Sint
trne_all_right(ac)
Sint ac;
{
  if (ac & 0777777)
    return 1;
  return ac;
}

static Sint
trnn_all_right(ac)
Sint ac;
{
  if (!(ac & 0777777))
    return 1;
  return ac;
}

static Sint
trne_likely(ac)
Sint ac;
{
  if (likely(ac & 0123456))
    return 1;
  return ac;
}

static Sint
trnn_unlikely(ac)
Sint ac;
{
  if (unlikely(!(ac & 0123456)))
    return 1;
  return ac;
}

/*
 * Left-half immediate nonzero/zero tests.
 */

static Sint
tlne_select(ac, yes, no)
Sint ac;
Sint yes;
Sint no;
{
  if (ac & 0123456000000)
    return yes;
  return no;
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
tlne_call(ac)
Sint ac;
{
  if (ac & 0123456000000)
    return f();
  return ac;
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
tlne_one(ac)
Sint ac;
{
  if (ac & 000001000000)
    return 1;
  return ac;
}

static Sint
tlnn_one(ac)
Sint ac;
{
  if (!(ac & 000001000000))
    return 1;
  return ac;
}

static Sint
tlne_signbit(ac)
Sint ac;
{
  if (ac & 0400000000000)
    return 1;
  return ac;
}

static Sint
tlnn_signbit(ac)
Sint ac;
{
  if (!(ac & 0400000000000))
    return 1;
  return ac;
}

static Sint
tlne_all_left(ac)
Sint ac;
{
  if (ac & 0777777000000)
    return 1;
  return ac;
}

static Sint
tlnn_all_left(ac)
Sint ac;
{
  if (!(ac & 0777777000000))
    return 1;
  return ac;
}

static Sint
tlne_likely(ac)
Sint ac;
{
  if (likely(ac & 0123456000000))
    return 1;
  return ac;
}

static Sint
tlnn_unlikely(ac)
Sint ac;
{
  if (unlikely(!(ac & 0123456000000)))
    return 1;
  return ac;
}

/*
 * Full-word direct nonzero/zero tests.
 */

static Sint
tdne_literal(ac)
Sint ac;
{
  if (ac & 0123456123456)
    return 1;
  return ac;
}

static Sint
tdnn_literal(ac)
Sint ac;
{
  if (!(ac & 0123456123456))
    return 1;
  return ac;
}

static Sint
tdne_literal_left(ac)
Sint ac;
{
  if (ac & 0123456000000)
    return 1;
  return ac;
}

static Sint
tdnn_literal_left(ac)
Sint ac;
{
  if (!(ac & 0123456000000))
    return 1;
  return ac;
}

static Sint
tdne_literal_right(ac)
Sint ac;
{
  if (ac & 0000000123456)
    return 1;
  return ac;
}

static Sint
tdnn_literal_right(ac)
Sint ac;
{
  if (!(ac & 0000000123456))
    return 1;
  return ac;
}

static Sint
tdne_reg(ac, e, yes, no)
Sint ac;
Sint e;
Sint yes;
Sint no;
{
  if (ac & e)
    return yes;
  return no;
}

static Sint
tdnn_reg(ac, e, yes, no)
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
tdne_mem(ac, p)
Sint ac;
Sint *p;
{
  if (ac & *p)
    return 1;
  return ac;
}

static Sint
tdnn_mem(ac, p)
Sint ac;
Sint *p;
{
  if (!(ac & *p))
    return 1;
  return ac;
}

static Sint
tdne_mem_loaded(ac, p)
Sint ac;
Sint *p;
{
  Sint e;

  e = *p;
  if (ac & e)
    return 1;
  return ac;
}

static Sint
tdnn_mem_loaded(ac, p)
Sint ac;
Sint *p;
{
  Sint e;

  e = *p;
  if (!(ac & e))
    return 1;
  return ac;
}

static Sint
tdne_global(ac)
Sint ac;
{
  if (ac & tskip_ga)
    return 1;
  return ac;
}

static Sint
tdnn_global(ac)
Sint ac;
{
  if (!(ac & tskip_ga))
    return 1;
  return ac;
}

static Sint
tdne_global_global()
{
  if (tskip_ga & tskip_gb)
    return 1;
  return tskip_ga;
}

static Sint
tdnn_global_global()
{
  if (!(tskip_ga & tskip_gb))
    return 1;
  return tskip_ga;
}

static Sint
tdne_volatile(ac)
Sint ac;
{
  Sint e;

  e = tskip_vga;
  if (ac & e)
    return 1;
  return ac;
}

static Sint
tdnn_volatile(ac)
Sint ac;
{
  Sint e;

  e = tskip_vga;
  if (!(ac & e))
    return 1;
  return ac;
}

static Sint
tdne_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  if (ac & v[i & 017])
    return 1;
  return ac;
}

static Sint
tdnn_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  if (!(ac & v[i & 017]))
    return 1;
  return ac;
}

static Sint
tdne_global_array(ac, i)
Sint ac;
Sint i;
{
  if (ac & tskip_buf[i & 017])
    return 1;
  return ac;
}

static Sint
tdnn_global_array(ac, i)
Sint ac;
Sint i;
{
  if (!(ac & tskip_buf[i & 017]))
    return 1;
  return ac;
}

static Sint
tdne_struct_a(ac, p)
Sint ac;
struct tskip_pair *p;
{
  if (ac & p->a)
    return 1;
  return ac;
}

static Sint
tdnn_struct_a(ac, p)
Sint ac;
struct tskip_pair *p;
{
  if (!(ac & p->a))
    return 1;
  return ac;
}

static Sint
tdne_struct_ab(p)
struct tskip_pair *p;
{
  if (p->a & p->b)
    return 1;
  return p->a;
}

static Sint
tdnn_struct_ab(p)
struct tskip_pair *p;
{
  if (!(p->a & p->b))
    return 1;
  return p->a;
}

/*
 * Swapped-source nonzero/zero tests.
 */

static Sint
tsne_reg(ac, e, yes, no)
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
tsnn_reg(ac, e, yes, no)
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
tsne_literal(ac)
Sint ac;
{
  if (ac & SWAP(0123456123456))
    return 1;
  return ac;
}

static Sint
tsnn_literal(ac)
Sint ac;
{
  if (!(ac & SWAP(0123456123456)))
    return 1;
  return ac;
}

static Sint
tsne_mem(ac, p)
Sint ac;
Sint *p;
{
  if (ac & SWAP(*p))
    return 1;
  return ac;
}

static Sint
tsnn_mem(ac, p)
Sint ac;
Sint *p;
{
  if (!(ac & SWAP(*p)))
    return 1;
  return ac;
}

static Sint
tsne_mem_loaded(ac, p)
Sint ac;
Sint *p;
{
  Sint e;

  e = *p;
  if (ac & SWAP(e))
    return 1;
  return ac;
}

static Sint
tsnn_mem_loaded(ac, p)
Sint ac;
Sint *p;
{
  Sint e;

  e = *p;
  if (!(ac & SWAP(e)))
    return 1;
  return ac;
}

static Sint
tsne_global(ac)
Sint ac;
{
  if (ac & SWAP(tskip_ga))
    return 1;
  return ac;
}

static Sint
tsnn_global(ac)
Sint ac;
{
  if (!(ac & SWAP(tskip_ga)))
    return 1;
  return ac;
}

static Sint
tsne_global_global()
{
  if (tskip_ga & SWAP(tskip_gb))
    return 1;
  return tskip_ga;
}

static Sint
tsnn_global_global()
{
  if (!(tskip_ga & SWAP(tskip_gb)))
    return 1;
  return tskip_ga;
}

static Sint
tsne_volatile(ac)
Sint ac;
{
  Sint e;

  e = tskip_vga;
  if (ac & SWAP(e))
    return 1;
  return ac;
}

static Sint
tsnn_volatile(ac)
Sint ac;
{
  Sint e;

  e = tskip_vga;
  if (!(ac & SWAP(e)))
    return 1;
  return ac;
}

static Sint
tsne_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  if (ac & SWAP(v[i & 017]))
    return 1;
  return ac;
}

static Sint
tsnn_array(ac, v, i)
Sint ac;
Sint *v;
Sint i;
{
  if (!(ac & SWAP(v[i & 017])))
    return 1;
  return ac;
}

static Sint
tsne_global_array(ac, i)
Sint ac;
Sint i;
{
  if (ac & SWAP(tskip_buf[i & 017]))
    return 1;
  return ac;
}

static Sint
tsnn_global_array(ac, i)
Sint ac;
Sint i;
{
  if (!(ac & SWAP(tskip_buf[i & 017])))
    return 1;
  return ac;
}

static Sint
tsne_struct_a(ac, p)
Sint ac;
struct tskip_pair *p;
{
  if (ac & SWAP(p->a))
    return 1;
  return ac;
}

static Sint
tsnn_struct_a(ac, p)
Sint ac;
struct tskip_pair *p;
{
  if (!(ac & SWAP(p->a)))
    return 1;
  return ac;
}

static Sint
tsne_struct_ab(p)
struct tskip_pair *p;
{
  if (p->a & SWAP(p->b))
    return 1;
  return p->a;
}

static Sint
tsnn_struct_ab(p)
struct tskip_pair *p;
{
  if (!(p->a & SWAP(p->b)))
    return 1;
  return p->a;
}

/*
 * Boolean-result forms.  These are not pure branch-only tests, but
 * they pressure the same test lowering when a 0/1 result is needed.
 */

static Sint
trne_bool(ac)
Sint ac;
{
  return (ac & 0123456) != 0;
}

static Sint
trnn_bool(ac)
Sint ac;
{
  return (ac & 0123456) == 0;
}

static Sint
tlne_bool(ac)
Sint ac;
{
  return (ac & 0123456000000) != 0;
}

static Sint
tlnn_bool(ac)
Sint ac;
{
  return (ac & 0123456000000) == 0;
}

static Sint
tdne_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & e) != 0;
}

static Sint
tdnn_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & e) == 0;
}

static Sint
tsne_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & SWAP(e)) != 0;
}

static Sint
tsnn_bool(ac, e)
Sint ac;
Sint e;
{
  return (ac & SWAP(e)) == 0;
}

static Sint
tdne_bool_mem(ac, p)
Sint ac;
Sint *p;
{
  return (ac & *p) != 0;
}

static Sint
tdnn_bool_mem(ac, p)
Sint ac;
Sint *p;
{
  return (ac & *p) == 0;
}

static Sint
tsne_bool_mem(ac, p)
Sint ac;
Sint *p;
{
  return (ac & SWAP(*p)) != 0;
}

static Sint
tsnn_bool_mem(ac, p)
Sint ac;
Sint *p;
{
  return (ac & SWAP(*p)) == 0;
}

/*
 * Branch forms where the tested value is also used after the branch.
 */

static Sint
trne_value_live(ac, y)
Sint ac;
Sint y;
{
  Sint t;

  t = ac & 0123456;
  if (t)
    return t + y;
  return ac + y;
}

static Sint
trnn_value_live(ac, y)
Sint ac;
Sint y;
{
  Sint t;

  t = ac & 0123456;
  if (!t)
    return ac + y;
  return t + y;
}

static Sint
tlne_value_live(ac, y)
Sint ac;
Sint y;
{
  Sint t;

  t = ac & 0123456000000;
  if (t)
    return t + y;
  return ac + y;
}

static Sint
tlnn_value_live(ac, y)
Sint ac;
Sint y;
{
  Sint t;

  t = ac & 0123456000000;
  if (!t)
    return ac + y;
  return t + y;
}

static Sint
tdne_value_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint t;

  t = ac & e;
  if (t)
    return t + y;
  return ac + e + y;
}

static Sint
tdnn_value_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint t;

  t = ac & e;
  if (!t)
    return ac + e + y;
  return t + y;
}

static Sint
tsne_value_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & m;
  if (t)
    return t + y;
  return ac + e + y;
}

static Sint
tsnn_value_live(ac, e, y)
Sint ac;
Sint e;
Sint y;
{
  Sint m;
  Sint t;

  m = SWAP(e);
  t = ac & m;
  if (!t)
    return ac + e + y;
  return t + y;
}

/*
 * Compound control-flow shapes.
 */

static Sint
tdne_nested(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (ac & e) {
    if (x)
      return 1;
    return 2;
  }

  return 3;
}

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
tdne_else_if(ac, e, x)
Sint ac;
Sint e;
Sint x;
{
  if (ac & e)
    return 1;
  else if (x)
    return 2;
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

/*
 * Loop pressure.
 */

static Sint
trne_loop(ac, n)
Sint ac;
Sint n;
{
  while (n-- > 0) {
    if (ac & 0123456)
      return n;
    ++ac;
  }

  return ac;
}

static Sint
trnn_loop(ac, n)
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
tlne_loop(ac, n)
Sint ac;
Sint n;
{
  while (n-- > 0) {
    if (ac & 0123456000000)
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tlnn_loop(ac, n)
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
tdne_loop(ac, e, n)
Sint ac;
Sint e;
Sint n;
{
  while (n-- > 0) {
    if (ac & e)
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tdnn_loop(ac, e, n)
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
tsne_loop(ac, e, n)
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
tsnn_loop(ac, e, n)
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
tdne_loop_memory(ac, p, n)
Sint ac;
Sint *p;
Sint n;
{
  Sint e;

  e = *p;
  while (n-- > 0) {
    if (ac & e)
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tdnn_loop_memory(ac, p, n)
Sint ac;
Sint *p;
Sint n;
{
  Sint e;

  e = *p;
  while (n-- > 0) {
    if (!(ac & e))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tsne_loop_memory(ac, p, n)
Sint ac;
Sint *p;
Sint n;
{
  Sint e;

  e = *p;
  while (n-- > 0) {
    if (ac & SWAP(e))
      return n;
    ++ac;
  }

  return ac;
}

static Sint
tsnn_loop_memory(ac, p, n)
Sint ac;
Sint *p;
Sint n;
{
  Sint e;

  e = *p;
  while (n-- > 0) {
    if (!(ac & SWAP(e)))
      return n;
    ++ac;
  }

  return ac;
}

/*
 * Call-pressure cases.
 */

static Sint
tdne_call_pressure(ac, e)
Sint ac;
Sint e;
{
  Sint r;

  if (ac & e)
    r = f();
  else
    r = ac;

  clobber();
  return r;
}

static Sint
tdnn_call_pressure(ac, e)
Sint ac;
Sint e;
{
  Sint r;

  if (!(ac & e))
    r = f();
  else
    r = ac;

  clobber();
  return r;
}

static Sint
tsne_call_pressure(ac, e)
Sint ac;
Sint e;
{
  Sint r;

  if (ac & SWAP(e))
    r = f();
  else
    r = ac;

  clobber();
  return r;
}

static Sint
tsnn_call_pressure(ac, e)
Sint ac;
Sint e;
{
  Sint r;

  if (!(ac & SWAP(e)))
    r = f();
  else
    r = ac;

  clobber();
  return r;
}

/*
 * Visible smoke entry points for harnesses that prefer externally
 * callable symbols.
 */

Sint
test_and_skip_right_left_smoke(ac)
Sint ac;
{
  Sint r;

  r = trne(ac);
  r += trnn(ac);
  r += tlne(ac);
  r += tlnn(ac);
  r += trne_loop(ac, 3);
  r += tlnn_loop(ac, 3);
  return r;
}

Sint
tskdir(ac, e, p)
Sint ac;
Sint e;
Sint *p;
{
  Sint r;

  r = tdne_reg(ac, e, 1, 2);
  r += tdnn_reg(ac, e, 3, 4);
  r += tdne2(ac, p);
  r += tdnn2(ac, p);
  r += tdne_loop_memory(ac, p, 3);
  return r;
}

Sint
tskswp(ac, e, p)
Sint ac;
Sint e;
Sint *p;
{
  Sint r;

  r = tsne_reg(ac, e, 1, 2);
  r += tsnn_reg(ac, e, 3, 4);
  r += tsne_mem(ac, p);
  r += tsnn_mem(ac, p);
  r += tsnn_loop_memory(ac, p, 3);
  return r;
}
