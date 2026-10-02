#include "insns.h"

/* runtime-reduce-struct-assign-small.c - small aggregate assignment reducer. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct one_word { Sint a; };
struct two_word { Sint a; Sint b; };
struct four_word { Sint a; Sint b; Sint c; Sint d; };
struct mixed_small {
  char9 c0;
  char9 c1;
  short18 h;
  Sint w;
};

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
copy_one(d, s)
struct one_word *d;
struct one_word *s;
{
  *d = *s;
}

NOINLINE static void
copy_two(d, s)
struct two_word *d;
struct two_word *s;
{
  *d = *s;
}

NOINLINE static void
copy_four(d, s)
struct four_word *d;
struct four_word *s;
{
  *d = *s;
}

NOINLINE static void
copy_mixed(d, s)
struct mixed_small *d;
struct mixed_small *s;
{
  *d = *s;
}

NOINLINE static struct two_word
return_two(x)
struct two_word x;
{
  return x;
}

int
main()
{
  struct one_word o1, o2;
  struct two_word t1, t2, t3;
  struct four_word f1, f2;
  struct mixed_small m1, m2;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 021;

  o1.a = (Sint)0123; o2.a = (Sint)0;
  copy_one(&o2, &o1);
  o1.a = (Sint)0777;
  if (!check_int((int)o2.a, 0123, 02000)) return (int)semantic_fail_id;

  t1.a = (Sint)1; t1.b = (Sint)-2;
  t2.a = (Sint)0; t2.b = (Sint)0;
  copy_two(&t2, &t1);
  t1.a = (Sint)0777;
  if (!check_int((int)t2.a, 1, 02010)) return (int)semantic_fail_id;
  if (!check_int((int)t2.b, -2, 02011)) return (int)semantic_fail_id;

  t3 = return_two(t2);
  if (!check_int((int)t3.a, 1, 02012)) return (int)semantic_fail_id;
  if (!check_int((int)t3.b, -2, 02013)) return (int)semantic_fail_id;

  f1.a = (Sint)10; f1.b = (Sint)11; f1.c = (Sint)-12; f1.d = (Sint)13;
  f2.a = f2.b = f2.c = f2.d = (Sint)0;
  copy_four(&f2, &f1);
  f1.c = (Sint)0;
  if (!check_int((int)f2.a, 10, 02020)) return (int)semantic_fail_id;
  if (!check_int((int)f2.b, 11, 02021)) return (int)semantic_fail_id;
  if (!check_int((int)f2.c, -12, 02022)) return (int)semantic_fail_id;
  if (!check_int((int)f2.d, 13, 02023)) return (int)semantic_fail_id;

  m1.c0 = (char9)-1;
  m1.c1 = (char9)0123;
  m1.h = (short18)-012345;
  m1.w = (Sint)077654;
  m2.c0 = m2.c1 = (char9)0;
  m2.h = (short18)0;
  m2.w = (Sint)0;
  copy_mixed(&m2, &m1);
  m1.c1 = (char9)7;
  if (!check_int((int)m2.c0, -1, 02030)) return (int)semantic_fail_id;
  if (!check_int((int)m2.c1, 0123, 02031)) return (int)semantic_fail_id;
  if (!check_int((int)m2.h, -012345, 02032)) return (int)semantic_fail_id;
  if (!check_int((int)m2.w, 077654, 02033)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
