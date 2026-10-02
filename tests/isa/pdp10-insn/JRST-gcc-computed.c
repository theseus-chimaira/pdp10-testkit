/* flag: -O2 */
#include "insns.h"

/* GCC labels-as-values/computed-goto coverage split from JRST.c. */
#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint
jrst_computed_arg(pc)
void *pc;
{
  OPAQUE_REG(pc);
  goto *pc;
}

static Sint
jrst_computed_arg_after_mask(pc, a)
void *pc;
Sint a;
{
  if (a == 0)
    return 0;

  OPAQUE_REG(pc);
  goto *pc;
}

static Sint
jrst_computed_mem(pp)
void **pp;
{
  void *pc;

  pc = *pp;
  OPAQUE_REG(pc);
  goto *pc;
}

static Sint
jrst_computed_index(table, i)
void **table;
Sint i;
{
  void *pc;

  pc = table[i & 7];
  OPAQUE_REG(pc);
  goto *pc;
}

static Sint
jrst_computed_local(i)
Sint i;
{
  static void *table[] = {
    &&l0, &&l1, &&l2, &&l3,
    &&l4, &&l5, &&l6, &&l7
  };
  void *pc;

  pc = table[i & 7];
  OPAQUE_REG(pc);
  goto *pc;

l0:
  return 0;
l1:
  return 1;
l2:
  return 2;
l3:
  return 3;
l4:
  return 4;
l5:
  return 5;
l6:
  return 6;
l7:
  return 7;
}

static Sint
jrst_computed_local_fallthrough(i, a)
Sint i;
Sint a;
{
  static void *table[] = {
    &&add0, &&add1, &&add2, &&add3
  };
  void *pc;

  pc = table[i & 3];
  OPAQUE_REG(pc);
  goto *pc;

add0:
  a += 0;
  goto done;

add1:
  a += 1;
  goto done;

add2:
  a += 2;
  goto done;

add3:
  a += 3;

done:
  return a;
}

static Sint
jrst_computed_two_tables(i, j)
Sint i;
Sint j;
{
  static void *t0[] = { &&a0, &&a1, &&a2, &&a3 };
  static void *t1[] = { &&b0, &&b1, &&b2, &&b3 };
  void *pc;

  if (i < 0)
    pc = t0[j & 3];
  else
    pc = t1[j & 3];

  OPAQUE_REG(pc);
  goto *pc;

a0:
  return 010;
a1:
  return 011;
a2:
  return 012;
a3:
  return 013;

b0:
  return 020;
b1:
  return 021;
b2:
  return 022;
b3:
  return 023;
}

static Sint
jrst_computed_store_label(slot, i)
void **slot;
Sint i;
{
  if (i == 0)
    *slot = &&zero;
  else
    *slot = &&nonzero;

  goto **slot;

zero:
  return 0;

nonzero:
  return 1;
}

static Sint
jrst_computed_reload_label(slot, i)
void **slot;
Sint i;
{
  void *pc;

  if (i == 0)
    *slot = &&zero;
  else
    *slot = &&nonzero;

  pc = *slot;
  OPAQUE_REG(pc);
  goto *pc;

zero:
  return 0;

nonzero:
  return 1;
}

static Sint
jrst_label_value_return(i)
Sint i;
{
  void *pc;

  if (i == 0)
    pc = &&zero;
  else
    pc = &&one;

  OPAQUE_REG(pc);

  if (i < 0)
    return (Sint)pc;

  goto *pc;

zero:
  return 0;

one:
  return 1;
}

static Sint
jrst_threaded_interpreter(code, n)
uQint *code;
Sint n;
{
  static void *ops[] = { &&op0, &&op1, &&op2, &&halt };
  Sint pc;
  Sint acc;
  void *target;

  pc = 0;
  acc = 0;

dispatch:
  if (pc >= n)
    goto halt;

  target = ops[code[pc] & 3];
  ++pc;
  OPAQUE_REG(target);
  goto *target;

op0:
  acc += 1;
  goto dispatch;

op1:
  acc += 2;
  goto dispatch;

op2:
  acc += 3;
  goto dispatch;

halt:
  return acc;
}
