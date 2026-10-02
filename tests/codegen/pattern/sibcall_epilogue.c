#include "insns.h"


/*
 * Sibling-call / tail-call epilogue pressure.
 *
 * This is a pattern-level test, not an opcode-family test.
 *
 * We want ordinary C shapes where the final action of a function is
 * returning another function call:
 *
 *   return callee(args);
 *
 * These should pressure the backend epilogue/sibcall path rather than
 * normal call + return sequences.
 *
 * Do not use inline assembly here.
 */

extern Sint scalar_memory_forms();
extern Sint f0();
extern Sint f1();
extern Sint f2();
extern Sint f3();
extern Sint f4();
extern Sint f5();
extern Sint f6();
extern Sint fptr();
extern Sint gptr();

static Sint sibcall_ga;
static Sint sibcall_gb;
static Sint sibcall_gc;
static volatile Sint sibcall_vga;

static Sint sibcall_buf[16];

struct sibcall_pair {
  Sint a;
  Sint b;
};

struct sibcall_trip {
  Sint a;
  Sint b;
  Sint c;
};

static struct sibcall_pair sibcall_gp;
static struct sibcall_trip sibcall_gt;

/*
 * Original tiny shape, kept intentionally.
 */

static Sint
bar(AC1)
Sint AC1;
{
  return scalar_memory_forms(AC1);
}

static Sint
baz(AC1)
Sint AC1;
{
  return bar(AC1);
}

/*
 * Direct tail calls.
 */

static Sint
sibcall_direct0()
{
  return f0();
}

static Sint
sibcall_direct1(a)
Sint a;
{
  return f1(a);
}

static Sint
sibcall_direct2(a, b)
Sint a;
Sint b;
{
  return f2(a, b);
}

static Sint
sibcall_direct3(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return f3(a, b, c);
}

static Sint
sibcall_direct4(a, b, c, d)
Sint a;
Sint b;
Sint c;
Sint d;
{
  return f4(a, b, c, d);
}

static Sint
sibcall_direct5(a, b, c, d, e)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
{
  return f5(a, b, c, d, e);
}

static Sint
sibcall_direct6(a, b, c, d, e, h)
Sint a;
Sint b;
Sint c;
Sint d;
Sint e;
Sint h;
{
  return f6(a, b, c, d, e, h);
}

/*
 * Tail calls with simple argument rewrites.
 */

static Sint
sibcall_add_arg(a)
Sint a;
{
  return f1(a + 1);
}

static Sint
sibcall_sub_arg(a)
Sint a;
{
  return f1(a - 1);
}

static Sint
sibcall_neg_arg(a)
Sint a;
{
  return f1(-a);
}

static Sint
sibcall_not_arg(a)
Sint a;
{
  return f1(~a);
}

static Sint
sibcall_and_arg(a)
Sint a;
{
  return f1(a & 0777777);
}

static Sint
sibcall_or_arg(a)
Sint a;
{
  return f1(a | 0123456);
}

static Sint
sibcall_xor_arg(a)
Sint a;
{
  return f1(a ^ 0525252);
}

static Sint
sibcall_shift_left_arg(a)
Sint a;
{
  return f1(a << 1);
}

static Sint
sibcall_shift_right_arg(a)
Sint a;
{
  return f1(a >> 1);
}

static Sint
sibcall_two_rewrite(a, b)
Sint a;
Sint b;
{
  return f2(a + b, a - b);
}

static Sint
sibcall_three_rewrite(a, b, c)
Sint a;
Sint b;
Sint c;
{
  return f3(a + b, b + c, a ^ c);
}

/*
 * Tail calls through wrapper chains.
 */

static Sint
sibcall_wrap1(a)
Sint a;
{
  return f1(a);
}

static Sint
sibcall_wrap2(a)
Sint a;
{
  return sibcall_wrap1(a);
}

static Sint
sibcall_wrap3(a)
Sint a;
{
  return sibcall_wrap2(a);
}

static Sint
sibcall_wrap4(a)
Sint a;
{
  return sibcall_wrap3(a);
}

static Sint
sibcall_wrap_add1(a)
Sint a;
{
  return f1(a + 1);
}

static Sint
sibcall_wrap_add2(a)
Sint a;
{
  return sibcall_wrap_add1(a + 1);
}

static Sint
sibcall_wrap_add3(a)
Sint a;
{
  return sibcall_wrap_add2(a + 1);
}

/*
 * Tail calls using globals and volatile loads.
 */

static Sint
sibcall_global1()
{
  return f1(sibcall_ga);
}

static Sint
sibcall_global2(a)
Sint a;
{
  return f2(a, sibcall_ga);
}

static Sint
sibcall_global3(a)
Sint a;
{
  return f3(a, sibcall_ga, sibcall_gb);
}

static Sint
sibcall_global_expr(a)
Sint a;
{
  return f2(a + sibcall_ga, sibcall_gb ^ a);
}

static Sint
sibcall_volatile1(a)
Sint a;
{
  return f2(a, sibcall_vga);
}

static Sint
sibcall_volatile_expr(a)
Sint a;
{
  Sint v;

  v = sibcall_vga;
  return f2(a + v, v);
}

/*
 * Tail calls using memory operands.
 */

static Sint
sibcall_mem1(p)
Sint *p;
{
  return f1(*p);
}

static Sint
sibcall_mem2(p, q)
Sint *p;
Sint *q;
{
  return f2(*p, *q);
}

static Sint
sibcall_mem3(p, q, r)
Sint *p;
Sint *q;
Sint *r;
{
  return f3(*p, *q, *r);
}

static Sint
sibcall_mem_expr(p, q)
Sint *p;
Sint *q;
{
  return f2(*p + *q, *p ^ *q);
}

static Sint
sibcall_array(v, i)
Sint *v;
Sint i;
{
  return f1(v[i & 017]);
}

static Sint
sibcall_array2(v, i, j)
Sint *v;
Sint i;
Sint j;
{
  return f2(v[i & 017], v[j & 017]);
}

static Sint
sibcall_global_array(i)
Sint i;
{
  return f1(sibcall_buf[i & 017]);
}

static Sint
sibcall_global_array2(i, j)
Sint i;
Sint j;
{
  return f2(sibcall_buf[i & 017], sibcall_buf[j & 017]);
}

/*
 * Tail calls using struct fields.
 */

static Sint
sibcall_struct_a(p)
struct sibcall_pair *p;
{
  return f1(p->a);
}

static Sint
sibcall_struct_b(p)
struct sibcall_pair *p;
{
  return f1(p->b);
}

static Sint
sibcall_struct_ab(p)
struct sibcall_pair *p;
{
  return f2(p->a, p->b);
}

static Sint
sibcall_struct_expr(p)
struct sibcall_pair *p;
{
  return f2(p->a + p->b, p->a ^ p->b);
}

static Sint
sibcall_trip_abc(p)
struct sibcall_trip *p;
{
  return f3(p->a, p->b, p->c);
}

static Sint
sibcall_global_struct()
{
  return f2(sibcall_gp.a, sibcall_gp.b);
}

static Sint
sibcall_global_trip()
{
  return f3(sibcall_gt.a, sibcall_gt.b, sibcall_gt.c);
}

/*
 * Conditional tail calls.  Each branch ends in a call.
 */

static Sint
sibcall_if_else(a, b)
Sint a;
Sint b;
{
  if (a)
    return f1(a);
  return f1(b);
}

static Sint
sibcall_if_else_two(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (a < b)
    return f2(a, b);
  return f2(b, c);
}

static Sint
sibcall_if_else_mixed(a, b)
Sint a;
Sint b;
{
  if (a & 1)
    return f1(a + b);
  return f2(a, b);
}

static Sint
sibcall_nested(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (a) {
    if (b)
      return f1(a);
    return f2(a, c);
  }

  return f3(a, b, c);
}

static Sint
sibcall_cond_global(a)
Sint a;
{
  if (sibcall_ga)
    return f1(a);
  return f2(a, sibcall_gb);
}

static Sint
sibcall_cond_mem(p, a)
Sint *p;
Sint a;
{
  if (*p)
    return f1(a);
  return f2(a, *p);
}

/*
 * Switch ending in tail calls.
 */

static Sint
sibcall_switch(a, b)
Sint a;
Sint b;
{
  switch (a & 3) {
  case 0:
    return f1(a);
  case 1:
    return f2(a, b);
  case 2:
    return f3(a, b, sibcall_ga);
  default:
    return f1(b);
  }
}

static Sint
sibcall_switch_dense(a, b, c)
Sint a;
Sint b;
Sint c;
{
  switch (a & 7) {
  case 0:
    return f1(a);
  case 1:
    return f1(b);
  case 2:
    return f2(a, b);
  case 3:
    return f2(b, c);
  case 4:
    return f3(a, b, c);
  case 5:
    return f3(c, b, a);
  case 6:
    return f4(a, b, c, sibcall_ga);
  default:
    return f1(c);
  }
}

/*
 * Tail calls through function pointers.
 */

static Sint
sibcall_fptr1(fp, a)
Sint (*fp)();
Sint a;
{
  return (*fp)(a);
}

static Sint
sibcall_fptr2(fp, a, b)
Sint (*fp)();
Sint a;
Sint b;
{
  return (*fp)(a, b);
}

static Sint
sibcall_fptr_expr(fp, a, b)
Sint (*fp)();
Sint a;
Sint b;
{
  return (*fp)(a + b, a ^ b);
}

static Sint
sibcall_external_fptr(a)
Sint a;
{
  return fptr(a);
}

static Sint
sibcall_external_fptr2(a, b)
Sint a;
Sint b;
{
  return gptr(a, b);
}

/*
 * Calls after local computation.  Still tail calls because the call is
 * the final action.
 */

static Sint
sibcall_local1(a, b)
Sint a;
Sint b;
{
  Sint t;

  t = a + b;
  return f1(t);
}

static Sint
sibcall_local2(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;
  Sint y;

  x = a + b;
  y = b + c;
  return f2(x, y);
}

static Sint
sibcall_local3(a, b, c)
Sint a;
Sint b;
Sint c;
{
  Sint x;
  Sint y;
  Sint z;

  x = a + b;
  y = b ^ c;
  z = x - y;
  return f3(x, y, z);
}

static Sint
sibcall_local_memory(p, q)
Sint *p;
Sint *q;
{
  Sint a;
  Sint b;

  a = *p;
  b = *q;
  return f2(a + b, a ^ b);
}

/*
 * Tail calls after stores.  The store happens before the final call.
 */

static Sint
sibcall_store_then_call(p, a)
Sint *p;
Sint a;
{
  *p = a;
  return f1(a);
}

static Sint
sibcall_store_expr_then_call(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  *p = a + b;
  return f2(*p, b);
}

static Sint
sibcall_store_global_then_call(a)
Sint a;
{
  sibcall_ga = a;
  return f1(a);
}

static Sint
sibcall_store_struct_then_call(p, a)
struct sibcall_pair *p;
Sint a;
{
  p->a = a;
  return f2(p->a, p->b);
}

/*
 * Negative controls: these should normally need a real call followed by
 * more work, so they are not clean sibling-call candidates.
 */

static Sint
not_sibcall_add_after(a)
Sint a;
{
  return f1(a) + 1;
}

static Sint
not_sibcall_sub_after(a)
Sint a;
{
  return f1(a) - a;
}

static Sint
not_sibcall_store_after(p, a)
Sint *p;
Sint a;
{
  Sint r;

  r = f1(a);
  *p = r;
  return r;
}

static Sint
not_sibcall_use_after(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = f2(a, b);
  return r + a;
}

static Sint
not_sibcall_cond_after(a, b)
Sint a;
Sint b;
{
  Sint r;

  r = f2(a, b);
  if (r)
    return r;
  return a;
}

/*
 * Entry-style aggregators.  These make the file useful even when the
 * harness wants one visible callable symbol.
 */

Sint
sibcall_epilogue_smoke(a, b, c)
Sint a;
Sint b;
Sint c;
{
  if (a & 1)
    return sibcall_direct1(a);
  if (b & 1)
    return sibcall_direct2(a, b);
  if (c & 1)
    return sibcall_if_else(a, b);
  return sibcall_switch(a, b);
}

Sint
sbcmem(p, q, a)
Sint *p;
Sint *q;
Sint a;
{
  if (a & 1)
    return sibcall_mem2(p, q);
  if (a & 2)
    return sibcall_store_then_call(p, a);
  return sibcall_local_memory(p, q);
}

Sint
sbcneg(p, a, b)
Sint *p;
Sint a;
Sint b;
{
  if (a & 1)
    return not_sibcall_add_after(a);
  if (a & 2)
    return not_sibcall_store_after(p, b);
  return not_sibcall_use_after(a, b);
}
