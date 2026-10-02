#include "insns.h"

/*
 * AOBJ loop idiom coverage.
 *
 * This is an optimization target only.  Ordinary compare/add loops are
 * correct for early DAIMON; later the backend may recognize some of
 * these as AOBJN/AOBJP-style loops.
 *
 * Keep this file centered on natural counted loops:
 *
 *   for (i = 0; i < n; i++)
 *   while (p != e) ... *p++
 *   counted copy/fill/sum/find loops
 *
 * Non-unit strides and backwards loops are included only as fallback
 * controls; they need not become AOBJ loops.
 */

extern void sink_int();
extern void sink_words();

static int
sum_loop_index(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];

  return s;
}

static Sint
sum_loop_index_sint(p, n)
Sint *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];

  return s;
}

static int
sum_loop_index_offset(p, n, off)
int *p;
int n;
int off;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i + off];

  return s;
}

static int
sum_loop_pointer(p, n)
int *p;
int n;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  while (p != e)
    s += *p++;

  return s;
}

static Sint
sum_loop_pointer_sint(p, n)
Sint *p;
Sint n;
{
  Sint *e;
  Sint s;

  e = p + n;
  s = 0;

  while (p != e)
    s += *p++;

  return s;
}

static int
sum_loop_pointer_preinc(p, n)
int *p;
int n;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  while (p != e) {
    s += *p;
    ++p;
  }

  return s;
}

static int
sum_loop_pointer_for(p, n)
int *p;
int n;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  for (; p != e; ++p)
    s += *p;

  return s;
}

static int
sum_loop_pointer_less(p, n)
int *p;
int n;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  while (p < e)
    s += *p++;

  return s;
}

static int
sum_loop_pointer_guarded(p, n)
int *p;
int n;
{
  int *e;
  int s;

  if (n <= 0)
    return 0;

  e = p + n;
  s = 0;

  do {
    s += *p++;
  } while (p != e);

  return s;
}

static int
sum_loop_index_guarded(p, n)
int *p;
int n;
{
  int i;
  int s;

  if (n <= 0)
    return 0;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];

  return s;
}

static int
sum_loop_index_from_one(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 1; i <= n; i++)
    s += p[i - 1];

  return s;
}

static int
sum_loop_index_decrement_count(p, n)
int *p;
int n;
{
  int s;

  s = 0;
  while (n-- > 0)
    s += *p++;

  return s;
}

static int
sum_loop_index_countdown(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = n; i > 0; --i)
    s += *p++;

  return s;
}

static int
sum_loop_two_accumulators(p, n)
int *p;
int n;
{
  int i;
  int s0;
  int s1;

  s0 = 0;
  s1 = 0;

  for (i = 0; i < n; i++) {
    s0 += p[i];
    s1 += i;
  }

  return s0 + s1;
}

static int
sum_loop_with_seed(p, n, seed)
int *p;
int n;
int seed;
{
  int i;
  int s;

  s = seed;
  for (i = 0; i < n; i++)
    s += p[i];

  return s;
}

static int
sum_loop_with_call_after(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];

  sink_int(s);
  return s;
}

static int
sum_loop_pointer_with_call_after(p, n)
int *p;
int n;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  while (p != e)
    s += *p++;

  sink_int(s);
  return s;
}

static void
copy_loop_index(d, s, n)
int *d;
int *s;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    d[i] = s[i];
}

static void
copy_loop_pointer(d, s, n)
int *d;
int *s;
int n;
{
  int *e;

  e = s + n;
  while (s != e)
    *d++ = *s++;
}

static void
copy_loop_pointer_dest_end(d, s, n)
int *d;
int *s;
int n;
{
  int *e;

  e = d + n;
  while (d != e)
    *d++ = *s++;
}

static void
copy_loop_index_sint(d, s, n)
Sint *d;
Sint *s;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    d[i] = s[i];
}

static int
copy_loop_index_sum(d, s, n)
int *d;
int *s;
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; i++) {
    d[i] = s[i];
    r += d[i];
  }

  return r;
}

static int
copy_loop_pointer_sum(d, s, n)
int *d;
int *s;
int n;
{
  int *e;
  int r;

  e = s + n;
  r = 0;

  while (s != e) {
    *d = *s;
    r += *d;
    ++d;
    ++s;
  }

  return r;
}

static void
fill_loop_index(d, n, value)
int *d;
int n;
int value;
{
  int i;

  for (i = 0; i < n; i++)
    d[i] = value;
}

static void
fill_loop_pointer(d, n, value)
int *d;
int n;
int value;
{
  int *e;

  e = d + n;
  while (d != e)
    *d++ = value;
}

static void
zero_loop_index(d, n)
int *d;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    d[i] = 0;
}

static void
zero_loop_pointer(d, n)
int *d;
int n;
{
  int *e;

  e = d + n;
  while (d != e)
    *d++ = 0;
}

static int
update_loop_index(p, n, value)
int *p;
int n;
int value;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++) {
    p[i] += value;
    s += p[i];
  }

  return s;
}

static int
update_loop_pointer(p, n, value)
int *p;
int n;
int value;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  while (p != e) {
    *p += value;
    s += *p;
    ++p;
  }

  return s;
}

static int
and_loop_index(p, n, mask)
int *p;
int n;
int mask;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i] & mask;

  return s;
}

static int
xor_loop_index(p, n, key)
int *p;
int n;
int key;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s ^= p[i] ^ key;

  return s;
}

static int
find_loop(p, n, key)
int *p;
int n;
int key;
{
  int i;

  for (i = 0; i < n; i++)
    if (p[i] == key)
      return i;

  return -1;
}

static int
find_loop_pointer(p, n, key)
int *p;
int n;
int key;
{
  int *b;
  int *e;

  b = p;
  e = p + n;

  while (p != e) {
    if (*p == key)
      return p - b;
    ++p;
  }

  return -1;
}

static int
find_loop_pointer_less(p, n, key)
int *p;
int n;
int key;
{
  int *b;
  int *e;

  b = p;
  e = p + n;

  while (p < e) {
    if (*p == key)
      return p - b;
    ++p;
  }

  return -1;
}

static int
find_nonzero_index(p, n)
int *p;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    if (p[i] != 0)
      return i;

  return -1;
}

static int
find_nonzero_pointer(p, n)
int *p;
int n;
{
  int *b;
  int *e;

  b = p;
  e = p + n;

  while (p != e) {
    if (*p != 0)
      return p - b;
    ++p;
  }

  return -1;
}

static int
count_equal_index(p, n, key)
int *p;
int n;
int key;
{
  int i;
  int c;

  c = 0;
  for (i = 0; i < n; i++)
    if (p[i] == key)
      ++c;

  return c;
}

static int
count_equal_pointer(p, n, key)
int *p;
int n;
int key;
{
  int *e;
  int c;

  e = p + n;
  c = 0;

  while (p != e) {
    if (*p == key)
      ++c;
    ++p;
  }

  return c;
}

static int
compare_loop_index(a, b, n)
int *a;
int *b;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    if (a[i] != b[i])
      return i + 1;

  return 0;
}

static int
compare_loop_pointer(a, b, n)
int *a;
int *b;
int n;
{
  int *base;
  int *e;

  base = a;
  e = a + n;

  while (a != e) {
    if (*a != *b)
      return a - base + 1;
    ++a;
    ++b;
  }

  return 0;
}

static int
checksum_loop_index(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0123456;
  for (i = 0; i < n; i++)
    s = (s + p[i]) ^ (i + 1);

  return s;
}

static int
checksum_loop_pointer(p, n)
int *p;
int n;
{
  int *e;
  int s;
  int i;

  e = p + n;
  s = 0123456;
  i = 0;

  while (p != e) {
    s = (s + *p++) ^ (i + 1);
    ++i;
  }

  return s;
}

static int
loop_with_continue(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++) {
    if ((i & 1) != 0)
      continue;
    s += p[i];
  }

  return s;
}

static int
loop_with_break(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++) {
    if (p[i] == 0)
      break;
    s += p[i];
  }

  return s;
}

static int
pointer_loop_with_continue(p, n)
int *p;
int n;
{
  int *e;
  int s;
  int i;

  e = p + n;
  s = 0;
  i = 0;

  while (p != e) {
    if ((i & 1) == 0)
      s += *p;
    ++p;
    ++i;
  }

  return s;
}

static int
pointer_loop_with_break(p, n)
int *p;
int n;
{
  int *e;
  int s;

  e = p + n;
  s = 0;

  while (p != e) {
    if (*p == 0)
      break;
    s += *p;
    ++p;
  }

  return s;
}

static int
nested_small_loop(p, n)
int *p;
int n;
{
  int i;
  int j;
  int s;

  s = 0;

  for (i = 0; i < n; i++) {
    for (j = 0; j < 4; j++)
      s += p[(i + j) & 017];
  }

  return s;
}

static void
copy_nested_rows(d, s, rows, cols)
int *d;
int *s;
int rows;
int cols;
{
  int i;
  int j;

  for (i = 0; i < rows; i++)
    for (j = 0; j < cols; j++)
      d[(i * cols) + j] = s[(i * cols) + j];
}

/*
 * Fallback controls.  These are legitimate loop tests but are less
 * likely to become AOBJ loops because the stride or direction is not the
 * simple natural form.
 */

static int
sum_loop_stride2(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i += 2)
    s += p[i];

  return s;
}

static int
sum_loop_reverse_index(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = n - 1; i >= 0; --i)
    s += p[i];

  return s;
}

static int
sum_loop_reverse_pointer(p, n)
int *p;
int n;
{
  int *b;
  int *q;
  int s;

  b = p;
  q = p + n;
  s = 0;

  while (q != b)
    s += *--q;

  return s;
}

static int
sum_loop_scaled_index(p, n, scale)
int *p;
int n;
int scale;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i * scale];

  return s;
}

static int
copy_loop_stride2(d, s, n)
int *d;
int *s;
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; i += 2) {
    d[i] = s[i];
    r += d[i];
  }

  return r;
}

static int
sum_loop_volatile(p, n)
volatile int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++)
    s += p[i];

  return s;
}

static void
copy_loop_volatile(d, s, n)
volatile int *d;
volatile int *s;
int n;
{
  int i;

  for (i = 0; i < n; i++)
    d[i] = s[i];
}

static int
sum_loop_with_sink(p, n)
int *p;
int n;
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < n; i++) {
    s += p[i];
    sink_int(s);
  }

  return s;
}

static void
copy_loop_with_sink(d, s, n)
int *d;
int *s;
int n;
{
  int i;

  for (i = 0; i < n; i++) {
    d[i] = s[i];
    sink_words(d, i + 1);
  }
}
