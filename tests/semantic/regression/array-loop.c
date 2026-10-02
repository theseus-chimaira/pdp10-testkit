#include "insns.h"

/*
 * Array loop and struct-field loop pressure.
 *
 * File:
 *   misc/array-loop.c
 *
 * This is a misc code-generation test, not a single instruction-pattern
 * test.
 *
 * It stresses:
 *   - induction variables
 *   - forward and reverse loops
 *   - array[i].field addressing
 *   - struct field stores through indexed arrays
 *   - byte-sized, halfword-sized, and word-sized array elements
 *   - pointer-walk loops
 *   - zeroing, copying, summing, and conditional updates
 *
 * On PDP-10 this is useful because word arrays should use ordinary
 * address arithmetic, while Qint/char and Hint objects may need
 * byte-pointer or halfword handling.  PDP-6/KA10 must not require
 * KL10 ADJBP.
 */

extern Sint f(void);
extern uSint uf(void);
extern void clobber(void);

struct scalar_memory_forms {
  int x;
  int y;
};

struct scalar_memory_forms bar[10];

static struct scalar_memory_forms smf_big[32];
static volatile struct scalar_memory_forms smf_vbig[32];

struct qpair {
  Qint x;
  Qint y;
};

struct uqpair {
  uQint x;
  uQint y;
};

struct hpair {
  Hint x;
  Hint y;
};

struct uhpair {
  uHint x;
  uHint y;
};

struct spair {
  Sint x;
  Sint y;
};

struct upair {
  uSint x;
  uSint y;
};

struct mixed_loop {
  Qint q;
  Hint h;
  Sint s;
  char c;
};

static struct qpair qpair_arr[32];
static struct uqpair uqpair_arr[32];
static struct hpair hpair_arr[32];
static struct uhpair uhpair_arr[32];
static struct spair spair_arr[32];
static struct upair upair_arr[32];
static struct mixed_loop mixed_arr[32];

static volatile struct qpair vqpair_arr[32];
static volatile struct hpair vhpair_arr[32];
static volatile struct spair vspair_arr[32];

static Qint q_arr[64];
static uQint uq_arr[64];
static Hint h_arr[64];
static uHint uh_arr[64];
static Sint s_arr[64];
static uSint us_arr[64];
static char c_arr[64];

static volatile Qint vq_arr[64];
static volatile Hint vh_arr[64];
static volatile Sint vs_arr[64];
static volatile char vc_arr[64];

/*
 * Original small test shape.
 */

static void
baz()
{
  int i;

  bar[0].y = 0;
  for (i = 0; i < 10; i++)
    bar[i].y = 0;
}

/*
 * Basic fixed-bound struct loops.
 */

static void
smf_zero_y_10()
{
  int i;

  for (i = 0; i < 10; i++)
    bar[i].y = 0;
}

static void
smf_zero_x_10()
{
  int i;

  for (i = 0; i < 10; i++)
    bar[i].x = 0;
}

static void
smf_zero_both_10()
{
  int i;

  for (i = 0; i < 10; i++) {
    bar[i].x = 0;
    bar[i].y = 0;
  }
}

static void
smf_set_y_index_10()
{
  int i;

  for (i = 0; i < 10; i++)
    bar[i].y = i;
}

static void
smf_set_x_plus_y_10()
{
  int i;

  for (i = 0; i < 10; i++)
    bar[i].x = bar[i].y + i;
}

static int
smf_sum_y_10()
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < 10; i++)
    s += bar[i].y;
  return s;
}

static int
smf_sum_xy_10()
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < 10; i++)
    s += bar[i].x + bar[i].y;
  return s;
}

static int
smf_count_nonzero_y_10()
{
  int i;
  int n;

  n = 0;
  for (i = 0; i < 10; i++)
    if (bar[i].y != 0)
      n++;
  return n;
}

/*
 * Reverse and countdown loops.
 */

static void
smf_zero_y_reverse_10()
{
  int i;

  for (i = 9; i >= 0; i--)
    bar[i].y = 0;
}

static int
smf_sum_y_reverse_10()
{
  int i;
  int s;

  s = 0;
  for (i = 9; i >= 0; i--)
    s += bar[i].y;
  return s;
}

static void
smf_zero_y_countdown_10()
{
  int i;

  i = 10;
  while (i > 0) {
    i--;
    bar[i].y = 0;
  }
}

static int
smf_sum_y_countdown_10()
{
  int i;
  int s;

  i = 10;
  s = 0;
  while (i > 0) {
    i--;
    s += bar[i].y;
  }
  return s;
}

/*
 * Dynamic bound loops.  These keep the compare/branch path less
 * constant-foldable.
 */

static void
smf_zero_y_n(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    smf_big[i & 037].y = 0;
}

static void
smf_set_y_n(n, v)
Sint n;
Sint v;
{
  Sint i;

  for (i = 0; i < n; i++)
    smf_big[i & 037].y = v;
}

static Sint
smf_sum_y_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += smf_big[i & 037].y;
  return s;
}

static Sint
smf_sum_x_y_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += smf_big[i & 037].x + smf_big[i & 037].y;
  return s;
}

static void
smf_zero_y_n_reverse(n)
Sint n;
{
  Sint i;

  i = n;
  while (i > 0) {
    i--;
    smf_big[i & 037].y = 0;
  }
}

static Sint
smf_find_first_y(n, v)
Sint n;
Sint v;
{
  Sint i;

  for (i = 0; i < n; i++)
    if (smf_big[i & 037].y == v)
      return i;
  return -1;
}

/*
 * Volatile struct array loops.
 */

static void
smf_volatile_zero_y_10()
{
  int i;

  for (i = 0; i < 10; i++)
    smf_vbig[i].y = 0;
}

static int
smf_volatile_sum_y_10()
{
  int i;
  int s;

  s = 0;
  for (i = 0; i < 10; i++)
    s += smf_vbig[i].y;
  return s;
}

static void
smf_volatile_set_y_n(n, v)
Sint n;
Sint v;
{
  Sint i;

  for (i = 0; i < n; i++)
    smf_vbig[i & 037].y = v;
}

/*
 * Word-sized scalar array loops.
 */

static void
s_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    s_arr[i] = 0;
}

static void
s_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    s_arr[i] = i;
}

static void
s_set_value_32(v)
Sint v;
{
  Sint i;

  for (i = 0; i < 32; i++)
    s_arr[i] = v;
}

static Sint
s_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += s_arr[i];
  return s;
}

static Sint
s_sum_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += s_arr[i & 077];
  return s;
}

static void
s_copy_32(dst, src)
Sint *dst;
Sint *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

static void
s_add_arrays_32(dst, a, b)
Sint *dst;
Sint *a;
Sint *b;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = a[i] + b[i];
}

static void
s_zero_even_32()
{
  Sint i;

  for (i = 0; i < 32; i += 2)
    s_arr[i] = 0;
}

static void
s_zero_stride3_30()
{
  Sint i;

  for (i = 0; i < 30; i += 3)
    s_arr[i] = 0;
}

static Sint
s_sum_reverse_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 31; i >= 0; i--)
    s += s_arr[i];
  return s;
}

/*
 * Unsigned word-sized scalar array loops.
 */

static void
us_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    us_arr[i] = 0;
}

static void
us_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    us_arr[i] = (uSint)i;
}

static uSint
us_sum_32()
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += us_arr[i];
  return s;
}

static void
us_copy_32(dst, src)
uSint *dst;
uSint *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

/*
 * Qint/uQint byte-sized array loops.
 */

static void
q_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    q_arr[i] = 0;
}

static void
q_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    q_arr[i] = (Qint)i;
}

static void
q_set_value_32(v)
Qint v;
{
  Sint i;

  for (i = 0; i < 32; i++)
    q_arr[i] = v;
}

static Sint
q_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += q_arr[i];
  return s;
}

static Sint
q_sum_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += q_arr[i & 077];
  return s;
}

static void
q_copy_32(dst, src)
Qint *dst;
Qint *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

static void
q_zero_even_32()
{
  Sint i;

  for (i = 0; i < 32; i += 2)
    q_arr[i] = 0;
}

static void
q_zero_stride3_30()
{
  Sint i;

  for (i = 0; i < 30; i += 3)
    q_arr[i] = 0;
}

static Sint
q_sum_reverse_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 31; i >= 0; i--)
    s += q_arr[i];
  return s;
}

static void
uq_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    uq_arr[i] = 0;
}

static void
uq_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    uq_arr[i] = (uQint)i;
}

static uSint
uq_sum_32()
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += uq_arr[i];
  return s;
}

static void
uq_copy_32(dst, src)
uQint *dst;
uQint *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

/*
 * Hint/uHint halfword-sized array loops.
 */

static void
h_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    h_arr[i] = 0;
}

static void
h_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    h_arr[i] = (Hint)i;
}

static void
h_set_value_32(v)
Hint v;
{
  Sint i;

  for (i = 0; i < 32; i++)
    h_arr[i] = v;
}

static Sint
h_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += h_arr[i];
  return s;
}

static Sint
h_sum_n(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += h_arr[i & 077];
  return s;
}

static void
h_copy_32(dst, src)
Hint *dst;
Hint *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

static void
h_zero_even_32()
{
  Sint i;

  for (i = 0; i < 32; i += 2)
    h_arr[i] = 0;
}

static Sint
h_sum_reverse_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 31; i >= 0; i--)
    s += h_arr[i];
  return s;
}

static void
uh_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    uh_arr[i] = 0;
}

static void
uh_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    uh_arr[i] = (uHint)i;
}

static uSint
uh_sum_32()
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += uh_arr[i];
  return s;
}

static void
uh_copy_32(dst, src)
uHint *dst;
uHint *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

/*
 * char array loops.  Default target char is 9-bit in this backend
 * family, so these overlap with Qint-like byte-pointer cases.
 */

static void
c_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    c_arr[i] = 0;
}

static void
c_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    c_arr[i] = (char)i;
}

static Sint
c_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += c_arr[i];
  return s;
}

static void
c_copy_32(dst, src)
char *dst;
char *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

/*
 * Struct arrays with Qint fields.
 */

static void
qpair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    qpair_arr[i].y = 0;
}

static void
qpair_zero_xy_32()
{
  Sint i;

  for (i = 0; i < 32; i++) {
    qpair_arr[i].x = 0;
    qpair_arr[i].y = 0;
  }
}

static void
qpair_set_y_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    qpair_arr[i].y = (Qint)i;
}

static Sint
qpair_sum_y_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += qpair_arr[i].y;
  return s;
}

static Sint
qpair_sum_xy_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += qpair_arr[i].x + qpair_arr[i].y;
  return s;
}

static void
qpair_copy_32(dst, src)
struct qpair *dst;
struct qpair *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

static Sint
qpair_find_y(v)
Qint v;
{
  Sint i;

  for (i = 0; i < 32; i++)
    if (qpair_arr[i].y == v)
      return i;
  return -1;
}

static void
uqpair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    uqpair_arr[i].y = 0;
}

static uSint
uqpair_sum_y_32()
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += uqpair_arr[i].y;
  return s;
}

/*
 * Struct arrays with Hint fields.
 */

static void
hpair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    hpair_arr[i].y = 0;
}

static void
hpair_zero_xy_32()
{
  Sint i;

  for (i = 0; i < 32; i++) {
    hpair_arr[i].x = 0;
    hpair_arr[i].y = 0;
  }
}

static void
hpair_set_y_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    hpair_arr[i].y = (Hint)i;
}

static Sint
hpair_sum_y_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += hpair_arr[i].y;
  return s;
}

static Sint
hpair_sum_xy_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += hpair_arr[i].x + hpair_arr[i].y;
  return s;
}

static void
hpair_copy_32(dst, src)
struct hpair *dst;
struct hpair *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

static void
uhpair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    uhpair_arr[i].y = 0;
}

static uSint
uhpair_sum_y_32()
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += uhpair_arr[i].y;
  return s;
}

/*
 * Struct arrays with Sint/uSint fields.
 */

static void
spair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    spair_arr[i].y = 0;
}

static void
spair_zero_xy_32()
{
  Sint i;

  for (i = 0; i < 32; i++) {
    spair_arr[i].x = 0;
    spair_arr[i].y = 0;
  }
}

static void
spair_set_y_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    spair_arr[i].y = i;
}

static Sint
spair_sum_y_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += spair_arr[i].y;
  return s;
}

static Sint
spair_sum_xy_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += spair_arr[i].x + spair_arr[i].y;
  return s;
}

static void
spair_copy_32(dst, src)
struct spair *dst;
struct spair *src;
{
  Sint i;

  for (i = 0; i < 32; i++)
    dst[i] = src[i];
}

static void
upair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    upair_arr[i].y = 0;
}

static uSint
upair_sum_y_32()
{
  Sint i;
  uSint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += upair_arr[i].y;
  return s;
}

/*
 * Mixed struct field loops.
 */

static void
mixed_zero_all_32()
{
  Sint i;

  for (i = 0; i < 32; i++) {
    mixed_arr[i].q = 0;
    mixed_arr[i].h = 0;
    mixed_arr[i].s = 0;
    mixed_arr[i].c = 0;
  }
}

static void
mixed_set_index_32()
{
  Sint i;

  for (i = 0; i < 32; i++) {
    mixed_arr[i].q = (Qint)i;
    mixed_arr[i].h = (Hint)i;
    mixed_arr[i].s = i;
    mixed_arr[i].c = (char)i;
  }
}

static Sint
mixed_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += mixed_arr[i].q + mixed_arr[i].h
      + mixed_arr[i].s + mixed_arr[i].c;
  return s;
}

static Sint
mixed_find_s(v)
Sint v;
{
  Sint i;

  for (i = 0; i < 32; i++)
    if (mixed_arr[i].s == v)
      return i;
  return -1;
}

/*
 * Volatile scalar and struct loops.
 */

static void
vq_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vq_arr[i] = 0;
}

static Sint
vq_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vq_arr[i];
  return s;
}

static void
vh_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vh_arr[i] = 0;
}

static Sint
vh_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vh_arr[i];
  return s;
}

static void
vs_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vs_arr[i] = 0;
}

static Sint
vs_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vs_arr[i];
  return s;
}

static void
vc_zero_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vc_arr[i] = 0;
}

static Sint
vc_sum_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vc_arr[i];
  return s;
}

static void
vqpair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vqpair_arr[i].y = 0;
}

static Sint
vqpair_sum_y_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vqpair_arr[i].y;
  return s;
}

static void
vhpair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vhpair_arr[i].y = 0;
}

static Sint
vhpair_sum_y_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vhpair_arr[i].y;
  return s;
}

static void
vspair_zero_y_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    vspair_arr[i].y = 0;
}

static Sint
vspair_sum_y_32()
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < 32; i++)
    s += vspair_arr[i].y;
  return s;
}

/*
 * Pointer-walk loops.
 */

static void
s_ptr_zero(p, n)
Sint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

static Sint
s_ptr_sum(p, n)
Sint *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += *p++;
  return s;
}

static void
q_ptr_zero(p, n)
Qint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

static Sint
q_ptr_sum(p, n)
Qint *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += *p++;
  return s;
}

static void
h_ptr_zero(p, n)
Hint *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

static Sint
h_ptr_sum(p, n)
Hint *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += *p++;
  return s;
}

static void
c_ptr_zero(p, n)
char *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    *p++ = 0;
}

static Sint
c_ptr_sum(p, n)
char *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += *p++;
  return s;
}

static void
qpair_ptr_zero_y(p, n)
struct qpair *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++) {
    p->y = 0;
    p++;
  }
}

static Sint
qpair_ptr_sum_y(p, n)
struct qpair *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++) {
    s += p->y;
    p++;
  }
  return s;
}

static void
hpair_ptr_zero_y(p, n)
struct hpair *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++) {
    p->y = 0;
    p++;
  }
}

static Sint
hpair_ptr_sum_y(p, n)
struct hpair *p;
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++) {
    s += p->y;
    p++;
  }
  return s;
}

static void
spair_ptr_zero_y(p, n)
struct spair *p;
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++) {
    p->y = 0;
    p++;
  }
}

/*
 * Loops with conditionals inside.
 */

static void
s_zero_if_negative(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    if (s_arr[i & 077] < 0)
      s_arr[i & 077] = 0;
}

static void
q_zero_if_negative(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    if (q_arr[i & 077] < 0)
      q_arr[i & 077] = 0;
}

static void
h_zero_if_negative(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    if (h_arr[i & 077] < 0)
      h_arr[i & 077] = 0;
}

static Sint
s_count_positive(n)
Sint n;
{
  Sint i;
  Sint c;

  c = 0;
  for (i = 0; i < n; i++)
    if (s_arr[i & 077] > 0)
      c++;
  return c;
}

static Sint
q_count_positive(n)
Sint n;
{
  Sint i;
  Sint c;

  c = 0;
  for (i = 0; i < n; i++)
    if (q_arr[i & 077] > 0)
      c++;
  return c;
}

static Sint
h_count_positive(n)
Sint n;
{
  Sint i;
  Sint c;

  c = 0;
  for (i = 0; i < n; i++)
    if (h_arr[i & 077] > 0)
      c++;
  return c;
}

/*
 * do/while and while forms.
 */

static void
s_do_zero_10()
{
  Sint i;

  i = 0;
  do {
    s_arr[i] = 0;
    i++;
  } while (i < 10);
}

static Sint
s_do_sum_10()
{
  Sint i;
  Sint s;

  i = 0;
  s = 0;
  do {
    s += s_arr[i];
    i++;
  } while (i < 10);
  return s;
}

static void
q_do_zero_10()
{
  Sint i;

  i = 0;
  do {
    q_arr[i] = 0;
    i++;
  } while (i < 10);
}

static Sint
q_do_sum_10()
{
  Sint i;
  Sint s;

  i = 0;
  s = 0;
  do {
    s += q_arr[i];
    i++;
  } while (i < 10);
  return s;
}

static void
h_do_zero_10()
{
  Sint i;

  i = 0;
  do {
    h_arr[i] = 0;
    i++;
  } while (i < 10);
}

static Sint
h_do_sum_10()
{
  Sint i;
  Sint s;

  i = 0;
  s = 0;
  do {
    s += h_arr[i];
    i++;
  } while (i < 10);
  return s;
}

/*
 * Calls and barriers around loops.
 */

static void
s_zero_after_call(n)
Sint n;
{
  Sint i;

  clobber();
  for (i = 0; i < n; i++)
    s_arr[i & 077] = 0;
}

static Sint
s_sum_after_call(n)
Sint n;
{
  Sint i;
  Sint s;

  clobber();
  s = 0;
  for (i = 0; i < n; i++)
    s += s_arr[i & 077];
  return s;
}

static void
q_zero_after_call(n)
Sint n;
{
  Sint i;

  clobber();
  for (i = 0; i < n; i++)
    q_arr[i & 077] = 0;
}

static Sint
q_sum_after_call(n)
Sint n;
{
  Sint i;
  Sint s;

  clobber();
  s = 0;
  for (i = 0; i < n; i++)
    s += q_arr[i & 077];
  return s;
}

static void
h_zero_after_call(n)
Sint n;
{
  Sint i;

  clobber();
  for (i = 0; i < n; i++)
    h_arr[i & 077] = 0;
}

static Sint
h_sum_after_call(n)
Sint n;
{
  Sint i;
  Sint s;

  clobber();
  s = 0;
  for (i = 0; i < n; i++)
    s += h_arr[i & 077];
  return s;
}

static Sint
loop_with_call_each_time(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = 0; i < n; i++)
    s += f();
  return s;
}

static void
loop_store_call_each_time(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    s_arr[i & 077] = f();
}

static void
q_loop_store_call_each_time(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    q_arr[i & 077] = (Qint)f();
}

static void
h_loop_store_call_each_time(n)
Sint n;
{
  Sint i;

  for (i = 0; i < n; i++)
    h_arr[i & 077] = (Hint)f();
}

/*
 * Copy between differently-shaped loops.
 */

static void
q_to_s_copy_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    s_arr[i] = q_arr[i];
}

static void
h_to_s_copy_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    s_arr[i] = h_arr[i];
}

static void
s_to_q_copy_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    q_arr[i] = (Qint)s_arr[i];
}

static void
s_to_h_copy_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    h_arr[i] = (Hint)s_arr[i];
}

static void
c_to_s_copy_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    s_arr[i] = c_arr[i];
}

static void
s_to_c_copy_32()
{
  Sint i;

  for (i = 0; i < 32; i++)
    c_arr[i] = (char)s_arr[i];
}

/*
 * Nested small loops.
 */

static void
s_nested_zero()
{
  Sint i;
  Sint j;

  for (i = 0; i < 4; i++)
    for (j = 0; j < 8; j++)
      s_arr[(i * 8 + j) & 077] = 0;
}

static Sint
s_nested_sum()
{
  Sint i;
  Sint j;
  Sint s;

  s = 0;
  for (i = 0; i < 4; i++)
    for (j = 0; j < 8; j++)
      s += s_arr[(i * 8 + j) & 077];
  return s;
}

static void
q_nested_zero()
{
  Sint i;
  Sint j;

  for (i = 0; i < 4; i++)
    for (j = 0; j < 8; j++)
      q_arr[(i * 8 + j) & 077] = 0;
}

static Sint
q_nested_sum()
{
  Sint i;
  Sint j;
  Sint s;

  s = 0;
  for (i = 0; i < 4; i++)
    for (j = 0; j < 8; j++)
      s += q_arr[(i * 8 + j) & 077];
  return s;
}
