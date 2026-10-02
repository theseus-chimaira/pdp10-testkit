#include "insns.h"

/* runtime-string-char9.c - native 9-bit char string sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

static char global_text[] = "DAIMON";
static char global_buf[12];

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
copy_text(dst, src)
char *dst;
char *src;
{
  int i;

  i = 0;
  while (src[i] != 0)
    {
      dst[i] = src[i];
      i = i + 1;
    }
  dst[i] = 0;
  return i;
}

int
runtime_string_char9_all(seed)
int seed;
{
  char local[12];
  char *p;
  int n;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  n = copy_text(local, global_text);
  if (!check_int(n, 6, 0100)) return 0;
  if (!check_int((int)local[0], 'D', 0101)) return 0;
  if (!check_int((int)local[5], 'N', 0102)) return 0;
  if (!check_int((int)local[6], 0, 0103)) return 0;

  p = &local[0];
  p = p + 3;
  if (!check_int((int)*p, 'M', 0200)) return 0;
  *p = 'X';
  if (!check_int((int)local[3], 'X', 0201)) return 0;

  n = copy_text(global_buf, local);
  if (!check_int(n, 6, 0300)) return 0;
  if (!check_int((int)global_buf[3], 'X', 0301)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_string_char9_all(010))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
