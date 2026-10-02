/* flag: -munextended */
#include "insns.h"

/*
 * BLT coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   BLT for fixed-size block copy
 *   BLT or correct fallback sequence for variable-address block copy
 *   SETZM + BLT style clearing for fixed-size zero fill
 *   BLT-like aggregate copy for structs/arrays
 *
 * Sizes below are C storage units.  With 9-bit chars and 36-bit Sint,
 * sizeof(Sint) is expected to be 4 storage units, so 0400 storage units
 * copies 0100 full words.
 */

Sint a[0100];
Sint b[0100];

Sint c_small[04];
Sint d_small[04];

char ca[0400];
char cb[0400];

struct blt_small {
  Sint a;
  Sint b;
  Sint c;
  Sint d;
};

struct blt_mixed {
  char c0;
  char c1;
  Hint h0;
  Sint s0;
  Sint s1;
  char tail[7];
};

struct blt_large {
  Sint w[0100];
};

struct blt_small gs0;
struct blt_small gs1;
struct blt_mixed gm0;
struct blt_mixed gm1;
struct blt_large gl0;
struct blt_large gl1;

static void
blt_array_100(void)
{
  __builtin_memcpy(a, b, sizeof a);
}

static void
blt_array_4(void)
{
  __builtin_memcpy(c_small, d_small, sizeof c_small);
}

static void
blt_array_1_word(void)
{
  __builtin_memcpy(a, b, sizeof a[0]);
}

static void
blt_array_2_words(void)
{
  __builtin_memcpy(a, b, sizeof a[0] * 2);
}

static void
blt_array_3_words(void)
{
  __builtin_memcpy(a, b, sizeof a[0] * 3);
}

static void
blt_array_7_words(void)
{
  __builtin_memcpy(a, b, sizeof a[0] * 7);
}

static void
blt_array_010_words(void)
{
  __builtin_memcpy(a, b, sizeof a[0] * 010);
}

static void
blt_array_077_words(void)
{
  __builtin_memcpy(a, b, sizeof a[0] * 077);
}

static void
blt_array_offset_src(void)
{
  __builtin_memcpy(a, b + 1, sizeof a[0] * 077);
}

static void
blt_array_offset_dst(void)
{
  __builtin_memcpy(a + 1, b, sizeof a[0] * 077);
}

static void
blt_array_offset_both(void)
{
  __builtin_memcpy(a + 1, b + 2, sizeof a[0] * 075);
}

static void
blt_ptr_100(dest, src)
Sint *dest;
Sint *src;
{
  __builtin_memcpy(dest, src, 0400);
}

static void
blt_ptr_4(dest, src)
Sint *dest;
Sint *src;
{
  __builtin_memcpy(dest, src, 020);
}

static void
blt_ptr_1_word(dest, src)
Sint *dest;
Sint *src;
{
  __builtin_memcpy(dest, src, 04);
}

static void
blt_ptr_2_words(dest, src)
Sint *dest;
Sint *src;
{
  __builtin_memcpy(dest, src, 010);
}

static void
blt_ptr_indexed(dest, src, i, j)
Sint *dest;
Sint *src;
Sint i;
Sint j;
{
  __builtin_memcpy(dest + (i & 7), src + (j & 7), 040);
}

static void
blt_ptr_large_indexed(dest, src, i, j)
Sint *dest;
Sint *src;
Sint i;
Sint j;
{
  __builtin_memcpy(dest + (i & 077), src + (j & 077), 0200);
}

static void
blt_char_0400(void)
{
  __builtin_memcpy(ca, cb, sizeof ca);
}

static void
blt_char_unaligned_offsets(void)
{
  __builtin_memcpy(ca + 1, cb + 2, 077);
}

static void
blt_char_ptr(dest, src)
char *dest;
char *src;
{
  __builtin_memcpy(dest, src, 0400);
}

static void
blt_char_ptr_small(dest, src)
char *dest;
char *src;
{
  __builtin_memcpy(dest, src, 017);
}

static void
blt_clear_array_100(void)
{
  __builtin_memset(a, 0, sizeof a);
}

static void
blt_clear_array_4(void)
{
  __builtin_memset(c_small, 0, sizeof c_small);
}

static void
blt_clear_array_1_word(void)
{
  __builtin_memset(a, 0, sizeof a[0]);
}

static void
blt_clear_array_2_words(void)
{
  __builtin_memset(a, 0, sizeof a[0] * 2);
}

static void
blt_clear_array_3_words(void)
{
  __builtin_memset(a, 0, sizeof a[0] * 3);
}

static void
blt_clear_array_offset(void)
{
  __builtin_memset(a + 1, 0, sizeof a[0] * 077);
}

static void
blt_clear_ptr_100(dest)
Sint *dest;
{
  __builtin_memset(dest, 0, 0400);
}

static void
blt_clear_ptr_4(dest)
Sint *dest;
{
  __builtin_memset(dest, 0, 020);
}

static void
blt_clear_ptr_1_word(dest)
Sint *dest;
{
  __builtin_memset(dest, 0, 04);
}

static void
blt_clear_ptr_indexed(dest, i)
Sint *dest;
Sint i;
{
  __builtin_memset(dest + (i & 7), 0, 040);
}

static void
blt_clear_char_0400(void)
{
  __builtin_memset(ca, 0, sizeof ca);
}

static void
blt_clear_char_unaligned(void)
{
  __builtin_memset(ca + 1, 0, 077);
}

static void
blt_clear_char_ptr(dest)
char *dest;
{
  __builtin_memset(dest, 0, 0400);
}

static void
blt_clear_char_ptr_small(dest)
char *dest;
{
  __builtin_memset(dest, 0, 017);
}

static void
blt_struct_small(void)
{
  gs0 = gs1;
}

static void
blt_struct_mixed(void)
{
  gm0 = gm1;
}

static void
blt_struct_large(void)
{
  gl0 = gl1;
}

static void
blt_struct_small_ptr(dest, src)
struct blt_small *dest;
struct blt_small *src;
{
  *dest = *src;
}

static void
blt_struct_mixed_ptr(dest, src)
struct blt_mixed *dest;
struct blt_mixed *src;
{
  *dest = *src;
}

static void
blt_struct_large_ptr(dest, src)
struct blt_large *dest;
struct blt_large *src;
{
  *dest = *src;
}

static struct blt_small
blt_struct_small_return(src)
struct blt_small *src;
{
  return *src;
}

static struct blt_mixed
blt_struct_mixed_return(src)
struct blt_mixed *src;
{
  return *src;
}

static void
blt_struct_small_arg(x)
struct blt_small x;
{
  gs0 = x;
}

static void
blt_struct_mixed_arg(x)
struct blt_mixed x;
{
  gm0 = x;
}

static void
blt_local_array_copy(src)
Sint *src;
{
  Sint local[010];

  __builtin_memcpy(local, src, sizeof local);
  __builtin_memcpy(a, local, sizeof local);
}

static Sint
blt_local_array_use(src)
Sint *src;
{
  Sint local[010];

  __builtin_memcpy(local, src, sizeof local);
  return local[0] + local[7];
}

static void
blt_local_clear_and_copy(src)
Sint *src;
{
  Sint local[010];

  __builtin_memset(local, 0, sizeof local);
  __builtin_memcpy(local, src, sizeof local);
  __builtin_memcpy(a, local, sizeof local);
}

static void
blt_nested_struct_copy(dst, src)
struct blt_large *dst;
struct blt_large *src;
{
  struct blt_large tmp;

  tmp = *src;
  *dst = tmp;
}

static void
blt_memmove_like_forward(dest, src)
Sint *dest;
Sint *src;
{
  __builtin_memcpy(dest + 1, src, 0400);
}

static void
blt_memmove_like_backward(dest, src)
Sint *dest;
Sint *src;
{
  __builtin_memcpy(dest, src + 1, 0400);
}

static void
blt_nonzero_memset_word(dest)
Sint *dest;
{
  __builtin_memset(dest, 0377, 0400);
}

static void
blt_nonzero_memset_char(dest)
char *dest;
{
  __builtin_memset(dest, 0123, 077);
}
