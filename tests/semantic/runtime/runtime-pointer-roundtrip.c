#include "insns.h"

/* runtime-pointer-roundtrip.c - pointer conversion round-trip sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct round_record {
  char9 c9[4];
  uchar9 u9[4];
  short18 h18[3];
  Sint word[3];
};

static struct round_record global_rec;

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

NOINLINE static void *
as_void(p)
void *p;
{
  return p;
}

NOINLINE static uSint
as_word(p)
void *p;
{
  return (uSint) p;
}

NOINLINE static int
test_round_record(r, base)
struct round_record *r;
int base;
{
  void *vp;
  char9 *pc9;
  uchar9 *pu9;
  short18 *ph18;
  Sint *ps;
  uSint raw;

  r->c9[0] = (char9)-1;
  r->c9[1] = (char9)-255;
  r->c9[2] = (char9)254;
  r->u9[0] = (uchar9)0;
  r->u9[1] = (uchar9)0777;
  r->u9[2] = (uchar9)0456;
  r->h18[0] = (short18)-012345;
  r->h18[1] = (short18)012345;
  r->word[0] = (Sint)01234;
  r->word[1] = (Sint)-0567;

  pc9 = &r->c9[1];
  vp = as_void((void *)pc9);
  pc9 = (char9 *)vp;
  if (!check_int((int)*pc9, -255, base + 0)) return 0;
  *pc9 = (char9)-7;
  if (!check_int((int)r->c9[1], -7, base + 1)) return 0;

  pu9 = (uchar9 *)(void *)&r->u9[1];
  vp = as_void((void *)pu9);
  pu9 = (uchar9 *)vp;
  if (!check_int((int)*pu9, 0777, base + 2)) return 0;
  *pu9 = (uchar9)0123;
  if (!check_int((int)r->u9[1], 0123, base + 3)) return 0;

  ph18 = &r->h18[0];
  vp = (void *)(ph18 + 1);
  ph18 = (short18 *)vp;
  if (!check_int((int)*ph18, 012345, base + 4)) return 0;
  if (!check_int((int)(ph18 - &r->h18[0]), 1, base + 5)) return 0;

  ps = &r->word[0];
  raw = as_word((void *)(ps + 1));
  ps = (Sint *)raw;
  if (!check_int((int)*ps, -0567, base + 6)) return 0;
  *ps = (Sint)07654;
  if (!check_int((int)r->word[1], 07654, base + 7)) return 0;

  pc9 = (char9 *)(void *)&r->c9[0];
  vp = (void *)(pc9 + 2);
  pc9 = (char9 *)vp;
  if (!check_int((int)*pc9, 254, base + 8)) return 0;
  if (!check_int((int)(pc9 - &r->c9[0]), 2, base + 9)) return 0;

  semantic_sink = semantic_sink + raw + (uSint)(int)r->word[1];
  return 1;
}

int
runtime_pointer_roundtrip_all(seed)
int seed;
{
  struct round_record local_rec;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_round_record(&local_rec, 0100)) return 0;
  if (!test_round_record(&global_rec, 0200)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_pointer_roundtrip_all(07))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
