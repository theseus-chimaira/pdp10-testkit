#include "insns.h"

/* runtime-struct-pointer-fields.c - struct pointer field addressing sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct field_leaf {
  char6 c6;
  uchar7 u7;
  char8 c8[2];
  char9 c9;
  short16 s16;
  short18 s18[2];
  Sint word;
};

struct field_box {
  Sint tag;
  struct field_leaf leaf[3];
  struct field_leaf *alias;
  uchar9 tail;
};

static struct field_box global_box;

static int
check_int(got, exp, id)
int got;
int exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint) id;
      semantic_sink = (uSint) got;
      return 0;
    }
  return 1;
}

NOINLINE static void
fill_leaf(p, seed)
struct field_leaf *p;
int seed;
{
  p->c6 = (char6)-31;
  p->u7 = (uchar7)127;
  p->c8[0] = (char8)-127;
  p->c8[1] = (char8)126;
  p->c9 = (char9)(seed - 020);
  p->s16 = (short16)-1234;
  p->s18[0] = (short18)-012345;
  p->s18[1] = (short18)012345;
  p->word = (Sint)(seed + 0100);
}

NOINLINE static int
check_leaf(p, seed, base)
struct field_leaf *p;
int seed;
int base;
{
  char8 *pc8;
  short18 *ps18;

  if (!check_int((int)p->c6, -31, base + 0)) return 0;
  if (!check_int((int)p->u7, 127, base + 1)) return 0;
  if (!check_int((int)p->c8[0], -127, base + 2)) return 0;
  if (!check_int((int)p->c8[1], 126, base + 3)) return 0;
  if (!check_int((int)p->c9, seed - 020, base + 4)) return 0;
  if (!check_int((int)p->s16, -1234, base + 5)) return 0;
  if (!check_int((int)p->s18[0], -012345, base + 6)) return 0;
  if (!check_int((int)p->s18[1], 012345, base + 7)) return 0;
  if (!check_int((int)p->word, seed + 0100, base + 8)) return 0;

  pc8 = &p->c8[0];
  pc8 = pc8 + 1;
  *pc8 = (char8)-12;
  if (!check_int((int)p->c8[1], -12, base + 9)) return 0;

  ps18 = &p->s18[0];
  ps18 = ps18 + 1;
  *ps18 = (short18)-0345;
  if (!check_int((int)p->s18[1], -0345, base + 10)) return 0;

  p->c9 = (char9)-15;
  if (!check_int((int)(*&p->c9), -15, base + 11)) return 0;

  return 1;
}

NOINLINE static int
test_box(p, seed, base)
struct field_box *p;
int seed;
int base;
{
  struct field_leaf *lp;

  p->tag = (Sint)seed;
  fill_leaf(&p->leaf[0], seed + 1);
  fill_leaf(&p->leaf[1], seed + 2);
  fill_leaf(&p->leaf[2], seed + 3);
  p->alias = &p->leaf[1];
  p->tail = (uchar9)0456;

  if (!check_int((int)p->tag, seed, base + 0)) return 0;
  if (!check_leaf(&p->leaf[0], seed + 1, base + 0100)) return 0;

  lp = p->alias;
  if (!check_leaf(lp, seed + 2, base + 0200)) return 0;
  lp = lp + 1;
  lp->c6 = (char6)-7;
  lp->s16 = (short16)3210;
  if (!check_int((int)p->leaf[2].c6, -7, base + 0300)) return 0;
  if (!check_int((int)p->leaf[2].s16, 3210, base + 0301)) return 0;
  if (!check_int((int)(lp - &p->leaf[0]), 2, base + 0302)) return 0;
  if (!check_int((int)p->tail, 0456, base + 0303)) return 0;

  semantic_sink = semantic_sink + (uSint)(int)p->leaf[2].s16;
  return 1;
}

int
runtime_struct_pointer_fields_all(seed)
int seed;
{
  struct field_box local_box;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_box(&local_box, seed, 01000)) return 0;
  if (!test_box(&global_box, seed + 010, 02000)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_struct_pointer_fields_all(030))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
