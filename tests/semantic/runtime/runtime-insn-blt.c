#include "insns.h"

/* runtime-insn-blt.c - block copy behavior sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct blt_rec {
  Sint a;
  char9 b[3];
  short18 c;
  Sint d;
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
copy_words(dst, src, n)
Sint *dst;
Sint *src;
int n;
{
  int i;

  for (i = 0; i < n; i = i + 1)
    dst[i] = src[i];
}

NOINLINE static int
test_struct_copy(seed)
int seed;
{
  struct blt_rec src;
  struct blt_rec dst;

  src.a = (Sint)seed;
  src.b[0] = (char9)-1;
  src.b[1] = (char9)0123;
  src.b[2] = (char9)-0400;
  src.c = (short18)-012345;
  src.d = (Sint)(seed + 0100);

  dst = src;
  src.b[1] = (char9)-7;
  src.d = (Sint)0;

  if (!check_int((int)dst.a, seed, 0100)) return 0;
  if (!check_int((int)dst.b[0], -1, 0101)) return 0;
  if (!check_int((int)dst.b[1], 0123, 0102)) return 0;
  if (!check_int((int)dst.b[2], -0400, 0103)) return 0;
  if (!check_int((int)dst.c, -012345, 0104)) return 0;
  if (!check_int((int)dst.d, seed + 0100, 0105)) return 0;

  return 1;
}

NOINLINE static int
test_word_copy(seed)
int seed;
{
  Sint src[6];
  Sint dst[6];
  int i;

  for (i = 0; i < 6; i = i + 1)
    {
      src[i] = (Sint)(seed + i);
      dst[i] = (Sint)0;
    }

  copy_words(dst, src, 6);
  src[2] = (Sint)-1;

  for (i = 0; i < 6; i = i + 1)
    {
      if (!check_int((int)dst[i], seed + i, 0200 + i))
        return 0;
    }
  return 1;
}

int
runtime_insn_blt_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  if (!test_struct_copy(seed)) return 0;
  if (!test_word_copy(seed + 020)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_insn_blt_all(07))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
