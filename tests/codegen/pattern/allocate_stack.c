#include "insns.h"

/*
 * allocate_stack pattern coverage for PDP-6/166 and KA10.
 *
 * This file is centered on __builtin_alloca and the backend's
 * allocate_stack expander:
 *
 *   result pointer = address of SP + 1
 *   stack adjust   = rounded-up storage units / 4 words
 *
 * Constant sizes exercise the compile-time rounding path.
 * Variable sizes exercise:
 *
 *   y = size + 3
 *   y = y >> 2
 *   stack_adjust(y)
 *
 * On PDP-6/KA10 this must not require real ADJSP.  The backend should
 * lower constant adjusts to add sp,[n,,n], and dynamic adjusts through
 * the no-KL10 register fallback.
 */

extern void scalar_memory_forms();
extern void use_ptr();
extern void use_sint();
extern void use_usint();

static void
alloc_const_one_word(void)
{
  Sint *x;

  x = (Sint *) __builtin_alloca(sizeof(Sint));
  x[0] = 0;
  scalar_memory_forms(x);
}

static void
alloc_const_two_words(void)
{
  Sint *x;

  x = (Sint *) __builtin_alloca(2 * sizeof(Sint));
  x[0] = 0;
  x[1] = 0;
  scalar_memory_forms(x);
}

static void
alloc_const_three_words(void)
{
  Sint *x;

  x = (Sint *) __builtin_alloca(3 * sizeof(Sint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  scalar_memory_forms(x);
}

static void
alloc_const_four_words(void)
{
  Sint *x;

  x = (Sint *) __builtin_alloca(4 * sizeof(Sint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  x[3] = 4;
  scalar_memory_forms(x);
}

static void
alloc_const_odd_1(void)
{
  char *x;

  x = (char *) __builtin_alloca(1);
  x[0] = 0;
  use_ptr(x);
}

static void
alloc_const_odd_2(void)
{
  char *x;

  x = (char *) __builtin_alloca(2);
  x[0] = 0;
  x[1] = 1;
  use_ptr(x);
}

static void
alloc_const_odd_3(void)
{
  char *x;

  x = (char *) __builtin_alloca(3);
  x[0] = 0;
  x[1] = 1;
  x[2] = 2;
  use_ptr(x);
}

static void
alloc_const_odd_4(void)
{
  char *x;

  x = (char *) __builtin_alloca(4);
  x[0] = 0;
  x[1] = 1;
  x[2] = 2;
  x[3] = 3;
  use_ptr(x);
}

static void
alloc_const_odd_5(void)
{
  char *x;

  x = (char *) __builtin_alloca(5);
  x[0] = 0;
  x[1] = 1;
  x[2] = 2;
  x[3] = 3;
  x[4] = 4;
  use_ptr(x);
}

static void
alloc_const_large(void)
{
  Sint *x;

  x = (Sint *) __builtin_alloca(64 * sizeof(Sint));
  x[0] = 1;
  x[63] = 0777777;
  scalar_memory_forms(x);
}

static void
alloc_const_large_odd(void)
{
  char *x;

  x = (char *) __builtin_alloca(257);
  x[0] = 1;
  x[256] = 2;
  use_ptr(x);
}

static Sint
alloc_const_sum(void)
{
  Sint *x;

  x = (Sint *) __builtin_alloca(4 * sizeof(Sint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  x[3] = 4;
  scalar_memory_forms(x);
  return x[0] + x[1] + x[2] + x[3];
}

static Sint
alloc_const_address_use(void)
{
  Sint *x;
  Sint *y;

  x = (Sint *) __builtin_alloca(2 * sizeof(Sint));
  y = x + 1;
  x[0] = 0123;
  y[0] = 0456;
  scalar_memory_forms(x);
  return x[0] + y[0];
}

static Sint
alloc_const_two_blocks(void)
{
  Sint *x;
  Sint *y;

  x = (Sint *) __builtin_alloca(2 * sizeof(Sint));
  y = (Sint *) __builtin_alloca(3 * sizeof(Sint));

  x[0] = 1;
  x[1] = 2;
  y[0] = 3;
  y[1] = 4;
  y[2] = 5;

  scalar_memory_forms(x);
  scalar_memory_forms(y);

  return x[0] + x[1] + y[0] + y[1] + y[2];
}

static Sint
alloc_const_with_call_pressure(a)
Sint a;
{
  extern void clobber(void);
  Sint *x;

  x = (Sint *) __builtin_alloca(4 * sizeof(Sint));
  x[0] = a;
  clobber();
  x[1] = a + 1;
  x[2] = a + 2;
  x[3] = a + 3;
  scalar_memory_forms(x);

  return x[0] + x[3];
}

static void
alloc_qi_small(void)
{
  Qint *x;

  x = (Qint *) __builtin_alloca(4 * sizeof(Qint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  x[3] = 4;
  use_ptr(x);
}

static Sint
alloc_qi_sum(void)
{
  Qint *x;

  x = (Qint *) __builtin_alloca(4 * sizeof(Qint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  x[3] = 4;
  use_ptr(x);

  return x[0] + x[1] + x[2] + x[3];
}

static void
alloc_hi_small(void)
{
  Hint *x;

  x = (Hint *) __builtin_alloca(4 * sizeof(Hint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  x[3] = 4;
  use_ptr(x);
}

static Sint
alloc_hi_sum(void)
{
  Hint *x;

  x = (Hint *) __builtin_alloca(4 * sizeof(Hint));
  x[0] = 1;
  x[1] = 2;
  x[2] = 3;
  x[3] = 4;
  use_ptr(x);

  return x[0] + x[1] + x[2] + x[3];
}

static void
alloc_struct_small(void)
{
  struct alloc_pair {
    Sint a;
    Sint b;
  } *x;

  x = (struct alloc_pair *) __builtin_alloca(sizeof(struct alloc_pair));
  x->a = 0123;
  x->b = 0456;
  use_ptr(x);
}

static Sint
alloc_struct_sum(void)
{
  struct alloc_three {
    Sint a;
    Sint b;
    Sint c;
  } *x;

  x = (struct alloc_three *) __builtin_alloca(sizeof(struct alloc_three));
  x->a = 1;
  x->b = 2;
  x->c = 3;
  use_ptr(x);

  return x->a + x->b + x->c;
}

static void
alloc_dynamic_bytes(n)
Sint n;
{
  char *x;

  x = (char *) __builtin_alloca(n);
  x[0] = 0;
  use_ptr(x);
}

static void
alloc_dynamic_bytes_plus(n)
Sint n;
{
  char *x;

  x = (char *) __builtin_alloca(n + 1);
  x[0] = 0;
  use_ptr(x);
}

static void
alloc_dynamic_bytes_plus_3(n)
Sint n;
{
  char *x;

  x = (char *) __builtin_alloca(n + 3);
  x[0] = 0;
  use_ptr(x);
}

static void
alloc_dynamic_bytes_masked(n)
Sint n;
{
  char *x;

  n &= 0777;
  x = (char *) __builtin_alloca(n);
  x[0] = 0;
  use_ptr(x);
}

static void
alloc_dynamic_words(n)
Sint n;
{
  Sint *x;

  x = (Sint *) __builtin_alloca(n * sizeof(Sint));
  x[0] = 0;
  scalar_memory_forms(x);
}

static Sint
alloc_dynamic_words_sum(n)
Sint n;
{
  Sint *x;
  Sint i;
  Sint s;

  x = (Sint *) __builtin_alloca(n * sizeof(Sint));
  s = 0;

  for (i = 0; i < n; ++i) {
    x[i] = i;
    s += x[i];
  }

  scalar_memory_forms(x);
  return s;
}

static Sint
alloc_dynamic_words_bounded(n)
Sint n;
{
  Sint *x;
  Sint i;
  Sint s;

  n &= 017;
  x = (Sint *) __builtin_alloca(n * sizeof(Sint));

  s = 0;
  for (i = 0; i < n; ++i) {
    x[i] = i + 1;
    s += x[i];
  }

  scalar_memory_forms(x);
  return s;
}

static void
alloc_dynamic_expr(a, b)
Sint a;
Sint b;
{
  char *x;
  Sint n;

  n = (a + b) & 0777;
  x = (char *) __builtin_alloca(n + 5);
  x[0] = 1;
  use_ptr(x);
}

static Sint
alloc_dynamic_expr_sum(a, b)
Sint a;
Sint b;
{
  Sint *x;
  Sint n;

  n = (a + b) & 017;
  x = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));
  x[0] = a;
  x[n] = b;
  scalar_memory_forms(x);

  return x[0] + x[n];
}

static void
alloc_dynamic_from_mem(p)
Sint *p;
{
  char *x;
  Sint n;

  n = *p;
  x = (char *) __builtin_alloca(n);
  x[0] = 0;
  use_ptr(x);
}

static Sint
alloc_dynamic_from_mem_sum(p)
Sint *p;
{
  Sint *x;
  Sint n;

  n = *p & 017;
  x = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));
  x[0] = n;
  x[n] = *p;
  scalar_memory_forms(x);

  return x[0] + x[n];
}

static void
alloc_dynamic_from_volatile(p)
volatile Sint *p;
{
  char *x;
  Sint n;

  n = *p;
  x = (char *) __builtin_alloca(n);
  x[0] = 0;
  use_ptr(x);
}

static Sint
alloc_dynamic_from_volatile_sum(p)
volatile Sint *p;
{
  Sint *x;
  Sint n;

  n = *p & 017;
  x = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));
  x[0] = n;
  x[n] = *p;
  scalar_memory_forms(x);

  return x[0] + x[n];
}

static Sint
alloc_dynamic_two_blocks(a, b)
Sint a;
Sint b;
{
  Sint *x;
  Sint *y;
  Sint n;
  Sint m;

  n = a & 017;
  m = b & 017;

  x = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));
  y = (Sint *) __builtin_alloca((m + 1) * sizeof(Sint));

  x[0] = a;
  x[n] = b;
  y[0] = b;
  y[m] = a;

  scalar_memory_forms(x);
  scalar_memory_forms(y);

  return x[0] + x[n] + y[0] + y[m];
}

static Sint
alloc_mixed_const_dynamic(n)
Sint n;
{
  Sint *a;
  Sint *b;

  n &= 017;

  a = (Sint *) __builtin_alloca(2 * sizeof(Sint));
  b = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));

  a[0] = 1;
  a[1] = 2;
  b[0] = n;
  b[n] = n + 1;

  scalar_memory_forms(a);
  scalar_memory_forms(b);

  return a[0] + a[1] + b[0] + b[n];
}

static Sint
alloc_inside_if(n, flag)
Sint n;
Sint flag;
{
  Sint *x;

  n &= 017;

  if (flag) {
    x = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));
    x[0] = n;
    x[n] = flag;
    scalar_memory_forms(x);
    return x[0] + x[n];
  }

  return n;
}

static Sint
alloc_inside_loop(n)
Sint n;
{
  Sint i;
  Sint s;

  n &= 7;
  s = 0;

  for (i = 0; i < n; ++i) {
    Sint *x;

    x = (Sint *) __builtin_alloca(2 * sizeof(Sint));
    x[0] = i;
    x[1] = i + 1;
    scalar_memory_forms(x);
    s += x[0] + x[1];
  }

  return s;
}

static Sint
alloc_dynamic_inside_loop(n)
Sint n;
{
  Sint i;
  Sint s;

  n &= 7;
  s = 0;

  for (i = 0; i < n; ++i) {
    Sint *x;

    x = (Sint *) __builtin_alloca((i + 1) * sizeof(Sint));
    x[0] = i;
    x[i] = n;
    scalar_memory_forms(x);
    s += x[0] + x[i];
  }

  return s;
}

static Sint
alloc_address_difference(n)
Sint n;
{
  char *a;
  char *b;

  n &= 077;

  a = (char *) __builtin_alloca(5);
  b = (char *) __builtin_alloca(n + 1);

  a[0] = 1;
  b[0] = 2;

  use_ptr(a);
  use_ptr(b);

  return b - a;
}

static Sint
alloc_escape_to_external(n)
Sint n;
{
  Sint *x;

  n &= 017;
  x = (Sint *) __builtin_alloca((n + 1) * sizeof(Sint));

  x[0] = n;
  x[n] = n + 1;

  use_ptr(x);
  use_sint(x[0]);
  use_sint(x[n]);

  return x[0] + x[n];
}

/*
 * Original skeleton shape, kept with short name.
 */

static void
bar(void)
{
  int *x;

  x = (int *) __builtin_alloca(2 * sizeof(int));

  x[0] = 0;
  x[1] = 0;
  scalar_memory_forms(x);
}
