#include "insns.h"

/* runtime-reduce-blt-word-copy.c - fixed word-copy/BLT reducer.

   Scope: PDP-6/KA10 SImode word arrays.  This test intentionally avoids
   byte-offset memcpy; it is meant to isolate whole-word aggregate copy and
   BLT/fallback semantics. */

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
#define COPY_WORDS(DST, SRC, NWORDS) copy_word_count((DST), (SRC), (NWORDS))

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
copy_words_010(dst, src)
uSint *dst;
uSint *src;
{
  COPY_WORDS(dst, src, 010);
}

NOINLINE static void
copy_words_offset(dst, src)
uSint *dst;
uSint *src;
{
  COPY_WORDS(dst + 1, src + 2, 06);
}

int
main()
{
  uSint src[020];
  uSint dst[020];
  int i;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 020;

  for (i = 0; i < 020; i = i + 1)
    {
      src[i] = (uSint)(01000 + i);
      dst[i] = (uSint)(070000 + i);
    }

  copy_words_010(dst, src);

  for (i = 0; i < 010; i = i + 1)
    if (!check_uint(dst[i], src[i], 01000 + i))
      return (int) semantic_fail_id;

  for (i = 010; i < 020; i = i + 1)
    if (!check_uint(dst[i], (uSint)(070000 + i), 01100 + i))
      return (int) semantic_fail_id;

  src[3] = (uSint)0777777;
  if (!check_uint(dst[3], (uSint)01003, 01200))
    return (int) semantic_fail_id;

  for (i = 0; i < 020; i = i + 1)
    {
      src[i] = (uSint)(02000 + i);
      dst[i] = (uSint)(060000 + i);
    }

  copy_words_offset(dst, src);

  if (!check_uint(dst[0], (uSint)060000, 01300))
    return (int) semantic_fail_id;
  for (i = 0; i < 06; i = i + 1)
    if (!check_uint(dst[i + 1], src[i + 2], 01310 + i))
      return (int) semantic_fail_id;
  if (!check_uint(dst[07], (uSint)060007, 01320))
    return (int) semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
