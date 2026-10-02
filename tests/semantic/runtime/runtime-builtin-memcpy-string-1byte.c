#include "insns.h"

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct byte_holder {
  char a;
  unsigned char b;
  char c[2];
} __attribute__ ((packed));

static struct byte_holder g;

static int
check(got, exp, id)
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

static void
copy_a(p)
char *p;
{
  __builtin_memcpy(p, "A", 1);
}

static void
copy_zero(p)
char *p;
{
  __builtin_memcpy(p, "", 1);
}

int
main()
{
  struct byte_holder l;
  char plain;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 012345;

  plain = (char) 0777;
  copy_a(&plain);
  if (!check((int)plain, 'A', 0100)) return (int)semantic_fail_id;

  l.a = (char) 0777;
  copy_zero(&l.a);
  if (!check((int)l.a, 0, 0200)) return (int)semantic_fail_id;

  l.b = (unsigned char) 0;
  copy_a((char *)&l.b);
  if (!check((int)l.b, 'A', 0300)) return (int)semantic_fail_id;

  g.c[1] = (char) 0;
  copy_a(&g.c[1]);
  if (!check((int)g.c[1], 'A', 0400)) return (int)semantic_fail_id;

  semantic_sink = (uSint)plain + (uSint)l.b + (uSint)g.c[1];
  semantic_fail_id = 0;
  return 0;
}
