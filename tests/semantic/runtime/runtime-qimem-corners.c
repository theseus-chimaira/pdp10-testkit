#include "insns.h"

/* runtime-qimem-corners.c - QI memory extract/store corner cases. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct qi_corners {
  Qint q[5];
  uQint uq[5];
  char c[5];
  signed char sc[5];
  unsigned char uc[5];
} __attribute__ ((packed));

static struct qi_corners global_qi;
static volatile Qint volatile_q;
static volatile uQint volatile_uq;

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

NOINLINE static int
test_qi_arrays(p, base)
struct qi_corners *p;
int base;
{
  Qint *pq;
  uQint *puq;

  p->q[0] = (Qint)0;
  p->q[1] = (Qint)0377;
  p->q[2] = (Qint)0400;
  p->q[3] = (Qint)0777;
  p->q[4] = (Qint)-1;
  p->uq[0] = (uQint)0;
  p->uq[1] = (uQint)0377;
  p->uq[2] = (uQint)0400;
  p->uq[3] = (uQint)0777;
  p->uq[4] = (uQint)-1;

  if (!check_int((int)p->q[0], 0, base + 0)) return 0;
  if (!check_int((int)p->q[1], 0377, base + 1)) return 0;
  if (!check_int((int)p->q[2], -0400, base + 2)) return 0;
  if (!check_int((int)p->q[3], -1, base + 3)) return 0;
  if (!check_int((int)p->q[4], -1, base + 4)) return 0;
  if (!check_int((int)p->uq[0], 0, base + 5)) return 0;
  if (!check_int((int)p->uq[1], 0377, base + 6)) return 0;
  if (!check_int((int)p->uq[2], 0400, base + 7)) return 0;
  if (!check_int((int)p->uq[3], 0777, base + 8)) return 0;
  if (!check_int((int)p->uq[4], 0777, base + 9)) return 0;

  pq = &p->q[1];
  pq[2] = (Qint)-0200;
  if (!check_int((int)p->q[3], -0200, base + 10)) return 0;

  puq = &p->uq[1];
  puq[2] = (uQint)0123;
  if (!check_int((int)p->uq[3], 0123, base + 11)) return 0;

  p->c[0] = (char)0777;
  p->sc[0] = (signed char)0777;
  p->uc[0] = (unsigned char)0777;
  if (!check_int((int)p->sc[0], -1, base + 12)) return 0;
  if (!check_int((int)p->uc[0], 0777, base + 13)) return 0;

  semantic_sink = semantic_sink + (uSint)(int)p->q[3] + (uSint)(int)p->uq[3];
  return 1;
}

NOINLINE static int
test_qi_volatile(base)
int base;
{
  volatile_q = (Qint)0400;
  volatile_uq = (uQint)0777;
  if (!check_int((int)volatile_q, -0400, base + 0)) return 0;
  if (!check_int((int)volatile_uq, 0777, base + 1)) return 0;

  volatile_q = (Qint)-0200;
  volatile_uq = (uQint)-0200;
  if (!check_int((int)volatile_q, -0200, base + 2)) return 0;
  if (!check_int((int)volatile_uq, 0600, base + 3)) return 0;

  return 1;
}

int
runtime_qimem_corners_all(seed)
int seed;
{
  struct qi_corners local_qi;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_qi_arrays(&local_qi, 0100)) return 0;
  if (!test_qi_arrays(&global_qi, 0200)) return 0;
  if (!test_qi_volatile(0300)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_qimem_corners_all(01))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
