#include "insns.h"

/* runtime-pattern-struct-assign-blt.c - larger struct assignment / BLT sentry.

   Exercises store through pointer, return-by-value, and array-element aggregate
   assignment.  If this fails while small struct assignment passes, inspect BLT
   length/end-address generation, stack temporaries, and source/destination ACs. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct large_words {
  Sint w[020];
};

struct mixed_large {
  Sint tag;
  char9 c[4];
  short18 h[4];
  Sint tail[012];
};

static struct large_words g_large_a;
static struct large_words g_large_b;
static struct large_words g_large_arr[3];
static struct mixed_large g_mixed_a;
static struct mixed_large g_mixed_b;

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
init_large(p, seed)
struct large_words *p;
int seed;
{
  int i;
  for (i = 0; i < 020; i = i + 1)
    p->w[i] = (Sint)(seed + i);
}

NOINLINE static int
check_large(p, seed, base)
struct large_words *p;
int seed;
int base;
{
  int i;
  for (i = 0; i < 020; i = i + 1)
    if (!check_int((int)p->w[i], seed + i, base + i))
      return 0;
  return 1;
}

NOINLINE static void
copy_large_store(d, s)
struct large_words *d;
struct large_words *s;
{
  *d = *s;
}

NOINLINE static struct large_words
copy_large_return(x)
struct large_words x;
{
  return x;
}

NOINLINE static void
copy_large_index(a, i, j)
struct large_words *a;
int i;
int j;
{
  a[i] = a[j];
}

NOINLINE static void
init_mixed(p, seed)
struct mixed_large *p;
int seed;
{
  int i;
  p->tag = (Sint)seed;
  p->c[0] = (char9)-1;
  p->c[1] = (char9)0123;
  p->c[2] = (char9)-0200;
  p->c[3] = (char9)077;
  for (i = 0; i < 4; i = i + 1)
    p->h[i] = (short18)(seed + 020 + i);
  for (i = 0; i < 012; i = i + 1)
    p->tail[i] = (Sint)(seed + 0100 + i);
}

NOINLINE static int
check_mixed(p, seed, base)
struct mixed_large *p;
int seed;
int base;
{
  int i;
  if (!check_int((int)p->tag, seed, base + 0)) return 0;
  if (!check_int((int)p->c[0], -1, base + 1)) return 0;
  if (!check_int((int)p->c[1], 0123, base + 2)) return 0;
  if (!check_int((int)p->c[2], -0200, base + 3)) return 0;
  if (!check_int((int)p->c[3], 077, base + 4)) return 0;
  for (i = 0; i < 4; i = i + 1)
    if (!check_int((int)p->h[i], seed + 020 + i, base + 010 + i)) return 0;
  for (i = 0; i < 012; i = i + 1)
    if (!check_int((int)p->tail[i], seed + 0100 + i, base + 020 + i)) return 0;
  return 1;
}

NOINLINE static void
copy_mixed_store(d, s)
struct mixed_large *d;
struct mixed_large *s;
{
  *d = *s;
}

int
main()
{
  struct large_words local_a;
  struct large_words local_b;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 022;

  init_large(&g_large_a, 01000);
  init_large(&g_large_b, 07000);
  copy_large_store(&g_large_b, &g_large_a);
  g_large_a.w[5] = (Sint)-1;
  if (!check_large(&g_large_b, 01000, 03000)) return (int)semantic_fail_id;

  init_large(&local_a, 02000);
  local_b = copy_large_return(local_a);
  local_a.w[7] = (Sint)-7;
  if (!check_large(&local_b, 02000, 03100)) return (int)semantic_fail_id;

  init_large(&g_large_arr[0], 03000);
  init_large(&g_large_arr[1], 04000);
  init_large(&g_large_arr[2], 05000);
  copy_large_index(g_large_arr, 2, 0);
  g_large_arr[0].w[0] = (Sint)-010;
  if (!check_large(&g_large_arr[2], 03000, 03200)) return (int)semantic_fail_id;

  init_mixed(&g_mixed_a, 06000);
  init_mixed(&g_mixed_b, 07000);
  copy_mixed_store(&g_mixed_b, &g_mixed_a);
  g_mixed_a.c[1] = (char9)-7;
  g_mixed_a.tail[4] = (Sint)0;
  if (!check_mixed(&g_mixed_b, 06000, 03300)) return (int)semantic_fail_id;

  semantic_fail_id = 0;
  semantic_sink = (uSint) 1;
  return 0;
}
