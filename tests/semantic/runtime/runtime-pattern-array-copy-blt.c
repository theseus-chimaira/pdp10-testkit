#include "insns.h"

/* runtime-pattern-array-copy-blt.c - fixed-size array memcpy/memset BLT sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static void
copy_word_count(dst, src, n)
uSint *dst;
uSint *src;
int n;
{
  while (n > 0)
    {
      *dst = *src;
      dst = dst + 1;
      src = src + 1;
      n = n - 1;
    }
}

static void
set_word_count(dst, value, n)
uSint *dst;
uSint value;
int n;
{
  while (n > 0)
    {
      *dst = value;
      dst = dst + 1;
      n = n - 1;
    }
}
#define COPY_WORDS(DST, SRC, NWORDS) copy_word_count((DST), (SRC), (NWORDS))
#define SET_WORDS(DST, VALUE, NWORDS) set_word_count((DST), (uSint)(VALUE), (NWORDS))

static uSint src[040];
static uSint dst[040];

static int
check_uint(got, exp, id)
uSint got;
uSint exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint) id;
      semantic_sink = got;
      return 0;
    }
  return 1;
}

NOINLINE static void
init_arrays(seed)
int seed;
{
  int i;
  for (i = 0; i < 040; i = i + 1)
    {
      src[i] = (uSint)(seed + i);
      dst[i] = (uSint)(070000 + i);
    }
}

NOINLINE static void
memcpy_full()
{
  COPY_WORDS(dst, src, 020);
}

NOINLINE static void
memcpy_offset()
{
  COPY_WORDS(dst + 3, src + 5, 012);
}

NOINLINE static void
memset_zero_middle()
{
  SET_WORDS(dst + 4, 0, 010);
}

int
main()
{
  int i;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 023;

  init_arrays(01000);
  memcpy_full();
  for (i = 0; i < 020; i = i + 1)
    if (!check_uint(dst[i], src[i], 04000 + i)) return (int)semantic_fail_id;
  if (!check_uint(dst[020], (uSint)(070000 + 020), 04040)) return (int)semantic_fail_id;

  init_arrays(02000);
  memcpy_offset();
  if (!check_uint(dst[2], (uSint)(070000 + 2), 04100)) return (int)semantic_fail_id;
  for (i = 0; i < 012; i = i + 1)
    if (!check_uint(dst[i + 3], src[i + 5], 04110 + i)) return (int)semantic_fail_id;
  if (!check_uint(dst[015], (uSint)(070000 + 015), 04140)) return (int)semantic_fail_id;

  init_arrays(03000);
  memset_zero_middle();
  if (!check_uint(dst[3], (uSint)(070000 + 3), 04200)) return (int)semantic_fail_id;
  for (i = 0; i < 010; i = i + 1)
    if (!check_uint(dst[i + 4], (uSint)0, 04210 + i)) return (int)semantic_fail_id;
  if (!check_uint(dst[014], (uSint)(070000 + 014), 04240)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
