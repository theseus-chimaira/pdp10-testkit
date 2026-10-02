#include "insns.h"

/*
 * Dynamic alloca coverage for early monitor/driver scratch buffers.
 *
 * allocate_stack.c covers fixed-size and mixed fixed/dynamic cases.
 * This file stays centered on variable allocation sizes:
 *
 *   n * sizeof(int)
 *   n * sizeof(char)
 *   n + constant byte buffers
 *   allocation after live values already exist
 *   multiple dynamic allocations in one function
 *   dynamic alloca inside loops/branches
 *
 * On PDP-6/KA10 this should exercise the non-ADJSP fallback path:
 * compute rounded word count, then adjust SP without requiring KL-style
 * ADJSP.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern void sink_words();
extern void sink_chars();
extern void sink_ptr();
extern void sink_int();

static int
alloca_words(n, seed)
int n;
int seed;
{
  int *p;
  int i;
  int sum;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca(n * sizeof(int));
  sum = seed;

  for (i = 0; i < n; i++) {
    p[i] = seed + i;
    sum += p[i];
  }

  sink_words(p, n);
  return sum;
}

static int
alloca_words_bounded(n, seed)
int n;
int seed;
{
  int *p;
  int i;
  int sum;

  n &= 017;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca((n + 1) * sizeof(int));
  sum = seed;

  for (i = 0; i <= n; i++) {
    p[i] = seed + i;
    sum += p[i];
  }

  sink_words(p, n + 1);
  return sum;
}

static int
alloca_words_plus_one(n, seed)
int n;
int seed;
{
  int *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca((n + 1) * sizeof(int));
  p[0] = seed;
  p[n] = seed + n;

  sink_words(p, n + 1);
  return p[0] + p[n];
}

static int
alloca_words_plus_three(n, seed)
int n;
int seed;
{
  int *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca((n + 3) * sizeof(int));
  p[0] = seed;
  p[n + 2] = seed + n;

  sink_words(p, n + 3);
  return p[0] + p[n + 2];
}

static int
alloca_words_from_mem(np, seed)
int *np;
int seed;
{
  int *p;
  int n;

  n = *np;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca(n * sizeof(int));
  p[0] = seed;
  p[n - 1] = seed + n;

  sink_words(p, n);
  return p[0] + p[n - 1];
}

static int
alloca_words_from_volatile(np, seed)
volatile int *np;
int seed;
{
  int *p;
  int n;

  n = *np;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca(n * sizeof(int));
  p[0] = seed;
  p[n - 1] = seed + n;

  sink_words(p, n);
  return p[0] + p[n - 1];
}

static int
alloca_chars(n, seed)
int n;
int seed;
{
  char *p;
  int i;
  int sum;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n * sizeof(char));
  sum = seed;

  for (i = 0; i < n; i++) {
    p[i] = (char)(seed + i);
    sum += p[i];
  }

  sink_chars(p, n);
  return sum;
}

static int
alloca_chars_plus_one(n, seed)
int n;
int seed;
{
  char *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 1);
  p[0] = (char)seed;
  p[n] = (char)(seed + n);

  sink_chars(p, n + 1);
  return p[0] + p[n];
}

static int
alloca_chars_plus_three(n, seed)
int n;
int seed;
{
  char *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 3);
  p[0] = (char)seed;
  p[n + 2] = (char)(seed + n);

  sink_chars(p, n + 3);
  return p[0] + p[n + 2];
}

static int
alloca_chars_plus_five(n, seed)
int n;
int seed;
{
  char *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 5);
  p[0] = (char)seed;
  p[n + 4] = (char)(seed + n);

  sink_chars(p, n + 5);
  return p[0] + p[n + 4];
}

static int
alloca_chars_bounded(n, seed)
int n;
int seed;
{
  char *p;
  int i;
  int sum;

  n &= 077;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 1);
  sum = seed;

  for (i = 0; i <= n; i++) {
    p[i] = (char)(seed + i);
    sum += p[i];
  }

  sink_chars(p, n + 1);
  return sum;
}

static int
alloca_chars_from_mem(np, seed)
int *np;
int seed;
{
  char *p;
  int n;

  n = *np;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n);
  p[0] = (char)seed;
  p[n - 1] = (char)(seed + n);

  sink_chars(p, n);
  return p[0] + p[n - 1];
}

static int
alloca_native_char_units(n, seed)
int n;
int seed;
{
  char *p;
  int i;
  int sum;

  n &= 0177;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n * sizeof(char));
  sum = seed;

  for (i = 0; i < n; i++) {
    p[i] = (char)(seed + i);
    sum += p[i];
  }

  sink_chars(p, n);
  return sum;
}

static int
alloca_qint_dynamic(n, seed)
int n;
int seed;
{
  Qint *p;
  int i;
  int sum;

  n &= 017;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (Qint *) __builtin_alloca((n + 1) * sizeof(Qint));
  sum = seed;

  for (i = 0; i <= n; i++) {
    p[i] = (Qint)(seed + i);
    sum += p[i];
  }

  sink_ptr(p);
  return sum;
}

static int
alloca_hint_dynamic(n, seed)
int n;
int seed;
{
  Hint *p;
  int i;
  int sum;

  n &= 017;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (Hint *) __builtin_alloca((n + 1) * sizeof(Hint));
  sum = seed;

  for (i = 0; i <= n; i++) {
    p[i] = (Hint)(seed + i);
    sum += p[i];
  }

  sink_ptr(p);
  return sum;
}

static int
alloca_expr_add(a, b, seed)
int a;
int b;
int seed;
{
  char *p;
  int n;

  n = (a + b) & 0777;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 3);
  p[0] = (char)seed;
  p[n + 2] = (char)(seed + n);

  sink_chars(p, n + 3);
  return p[0] + p[n + 2];
}

static int
alloca_expr_shift(a, seed)
int a;
int seed;
{
  int *p;
  int n;

  n = (a << 1) & 017;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca((n + 1) * sizeof(int));
  p[0] = seed;
  p[n] = seed + n;

  sink_words(p, n + 1);
  return p[0] + p[n];
}

static int
alloca_expr_mul(a, b, seed)
int a;
int b;
int seed;
{
  char *p;
  int n;

  n = (a * b) & 077;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 1);
  p[0] = (char)seed;
  p[n] = (char)(seed + n);

  sink_chars(p, n + 1);
  return p[0] + p[n];
}

static int
alloca_after_live_values(n, seed)
int n;
int seed;
{
  int live0;
  int live1;
  int live2;
  int *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  live0 = seed + 1;
  live1 = seed + 2;
  live2 = live0 + live1;

  p = (int *) __builtin_alloca(n * sizeof(int));
  p[0] = live0;
  p[n - 1] = live2;

  sink_words(p, n);
  return p[0] + p[n - 1] + live1;
}

static int
alloca_after_call(n, seed)
int n;
int seed;
{
  int *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  sink_int(seed);

  p = (int *) __builtin_alloca(n * sizeof(int));
  p[0] = seed;
  p[n - 1] = seed + n;

  sink_words(p, n);
  return p[0] + p[n - 1];
}

static int
alloca_before_and_after_call(n, seed)
int n;
int seed;
{
  int *a;
  int *b;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  a = (int *) __builtin_alloca(n * sizeof(int));
  a[0] = seed;

  sink_words(a, n);

  b = (int *) __builtin_alloca((n + 1) * sizeof(int));
  b[0] = seed + 1;
  b[n] = seed + n;

  sink_words(b, n + 1);
  return a[0] + b[0] + b[n];
}

static int
alloca_two_blocks(n, m)
int n;
int m;
{
  int *a;
  int *b;

  OPAQUE_REG(n);
  OPAQUE_REG(m);

  a = (int *) __builtin_alloca(n * sizeof(int));
  a[0] = n;

  b = (int *) __builtin_alloca(m * sizeof(int));
  b[0] = m;

  sink_words(a, n);
  sink_words(b, m);

  return a[0] + b[0];
}

static int
alloca_two_blocks_live(n, m, seed)
int n;
int m;
int seed;
{
  int *a;
  int *b;
  int live;

  OPAQUE_REG(n);
  OPAQUE_REG(m);
  OPAQUE_REG(seed);

  live = seed + n;

  a = (int *) __builtin_alloca(n * sizeof(int));
  a[0] = live;

  live += m;

  b = (int *) __builtin_alloca(m * sizeof(int));
  b[0] = live;

  sink_words(a, n);
  sink_words(b, m);

  return a[0] + b[0] + live;
}

static int
alloca_word_then_chars(n, m, seed)
int n;
int m;
int seed;
{
  int *a;
  char *b;

  OPAQUE_REG(n);
  OPAQUE_REG(m);
  OPAQUE_REG(seed);

  a = (int *) __builtin_alloca(n * sizeof(int));
  a[0] = seed;

  b = (char *) __builtin_alloca(m + 1);
  b[0] = (char)seed;
  b[m] = (char)(seed + m);

  sink_words(a, n);
  sink_chars(b, m + 1);

  return a[0] + b[0] + b[m];
}

static int
alloca_chars_then_word(n, m, seed)
int n;
int m;
int seed;
{
  char *a;
  int *b;

  OPAQUE_REG(n);
  OPAQUE_REG(m);
  OPAQUE_REG(seed);

  a = (char *) __builtin_alloca(n + 1);
  a[0] = (char)seed;
  a[n] = (char)(seed + n);

  b = (int *) __builtin_alloca(m * sizeof(int));
  b[0] = seed + m;

  sink_chars(a, n + 1);
  sink_words(b, m);

  return a[0] + a[n] + b[0];
}

static int
alloca_three_blocks(n, m, k)
int n;
int m;
int k;
{
  int *a;
  int *b;
  int *c;

  OPAQUE_REG(n);
  OPAQUE_REG(m);
  OPAQUE_REG(k);

  a = (int *) __builtin_alloca(n * sizeof(int));
  b = (int *) __builtin_alloca(m * sizeof(int));
  c = (int *) __builtin_alloca(k * sizeof(int));

  a[0] = n;
  b[0] = m;
  c[0] = k;

  sink_words(a, n);
  sink_words(b, m);
  sink_words(c, k);

  return a[0] + b[0] + c[0];
}

static int
alloca_branch(flag, n, seed)
int flag;
int n;
int seed;
{
  OPAQUE_REG(flag);
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  if (flag) {
    int *p;

    p = (int *) __builtin_alloca(n * sizeof(int));
    p[0] = seed;
    p[n - 1] = seed + n;
    sink_words(p, n);
    return p[0] + p[n - 1];
  } else {
    char *p;

    p = (char *) __builtin_alloca(n + 1);
    p[0] = (char)seed;
    p[n] = (char)(seed + n);
    sink_chars(p, n + 1);
    return p[0] + p[n];
  }
}

static int
alloca_branch_after_live(flag, n, seed)
int flag;
int n;
int seed;
{
  int live;

  OPAQUE_REG(flag);
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  live = seed + n;

  if (flag) {
    int *p;

    p = (int *) __builtin_alloca((n + 1) * sizeof(int));
    p[0] = live;
    p[n] = live + 1;
    sink_words(p, n + 1);
    return p[0] + p[n] + live;
  }

  live += 3;
  return live;
}

static int
alloca_loop_const_count(n, seed)
int n;
int seed;
{
  int i;
  int sum;

  n &= 7;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  sum = seed;

  for (i = 0; i < n; i++) {
    int *p;

    p = (int *) __builtin_alloca(2 * sizeof(int));
    p[0] = seed + i;
    p[1] = seed - i;
    sink_words(p, 2);
    sum += p[0] + p[1];
  }

  return sum;
}

static int
alloca_loop_dynamic_count(n, seed)
int n;
int seed;
{
  int i;
  int sum;

  n &= 7;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  sum = seed;

  for (i = 0; i < n; i++) {
    int *p;

    p = (int *) __builtin_alloca((i + 1) * sizeof(int));
    p[0] = seed + i;
    p[i] = seed - i;
    sink_words(p, i + 1);
    sum += p[0] + p[i];
  }

  return sum;
}

static int
alloca_loop_char_count(n, seed)
int n;
int seed;
{
  int i;
  int sum;

  n &= 7;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  sum = seed;

  for (i = 0; i < n; i++) {
    char *p;

    p = (char *) __builtin_alloca(i + 1);
    p[0] = (char)(seed + i);
    p[i] = (char)(seed - i);
    sink_chars(p, i + 1);
    sum += p[0] + p[i];
  }

  return sum;
}

static int
alloca_address_difference(n, m)
int n;
int m;
{
  char *a;
  char *b;

  OPAQUE_REG(n);
  OPAQUE_REG(m);

  a = (char *) __builtin_alloca(n + 1);
  b = (char *) __builtin_alloca(m + 1);

  a[0] = 1;
  b[0] = 2;

  sink_chars(a, n + 1);
  sink_chars(b, m + 1);

  return b - a;
}

static int
alloca_escape_pointer(n, seed)
int n;
int seed;
{
  int *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca(n * sizeof(int));
  p[0] = seed;
  p[n - 1] = seed + n;

  sink_ptr(p);
  sink_words(p, n);

  return p[0] + p[n - 1];
}

static int
alloca_dynamic_with_struct(n, seed)
int n;
int seed;
{
  struct local_pair {
    int a;
    int b;
  } *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (struct local_pair *)
    __builtin_alloca(n * sizeof(struct local_pair));

  p[0].a = seed;
  p[0].b = seed + 1;
  p[n - 1].a = seed + n;
  p[n - 1].b = seed + n + 1;

  sink_ptr(p);

  return p[0].a + p[0].b + p[n - 1].a + p[n - 1].b;
}

static int
alloca_words_and_scalar_spills(n, seed)
int n;
int seed;
{
  int *p;
  int a0;
  int a1;
  int a2;
  int a3;
  int a4;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  a0 = seed + 0;
  a1 = seed + 1;
  a2 = seed + 2;
  a3 = seed + 3;
  a4 = seed + 4;

  p = (int *) __builtin_alloca(n * sizeof(int));

  p[0] = a0 + a1;
  p[n - 1] = a2 + a3 + a4;

  sink_words(p, n);

  return p[0] + p[n - 1] + a0 + a1 + a2 + a3 + a4;
}

static int
alloca_nested_call_arg(n, seed)
int n;
int seed;
{
  int *p;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (int *) __builtin_alloca(n * sizeof(int));
  p[0] = seed;
  p[n - 1] = seed + n;

  sink_words(p, n);
  sink_int(p[0] + p[n - 1]);

  return p[0] + p[n - 1];
}

static int
alloca_small_runtime_rounding(n, seed)
int n;
int seed;
{
  char *p;

  n &= 3;
  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  p = (char *) __builtin_alloca(n + 1);
  p[0] = (char)seed;
  p[n] = (char)(seed + n);

  sink_chars(p, n + 1);
  return p[0] + p[n];
}

/*
 * Original skeleton driver shape, kept with short name.
 */

static int
use_alloca_dynamic(n, seed)
int n;
int seed;
{
  return alloca_words(n, seed)
      + alloca_chars(n + 1, seed)
      + alloca_two_blocks(n, n + 1);
}
