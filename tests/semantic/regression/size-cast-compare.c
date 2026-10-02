/* flag: -O2 */
/*
 * PDP-10 exact-size cast/compare sentry.
 *
 * This test is deliberately separate from return-promote.c.  It checks
 * that casts to __attribute__ ((size (N))) integer types are narrowed to
 * exactly N bits before comparison or conversion back to int.
 *
 * The bug this catches is using the containing GCC mode width instead of
 * the declared PDP-10 size attribute width.  For example, uchar6_t must
 * use a 077 mask, not a QImode 0777 mask; ushort16_t must use a 0177777
 * mask, not an HImode 0777777/right-half mask.
 */

#include "insns.h"
#define NOINLINE __attribute__ ((noinline))

typedef char6 char6_t;
typedef uchar6 uchar6_t;
typedef char7 char7_t;
typedef uchar7 uchar7_t;
typedef char8 char8_t;
typedef uchar8 uchar8_t;
typedef char9 char9_t;
typedef uchar9 uchar9_t;
typedef short16 short16_t;
typedef ushort16 ushort16_t;
typedef short18 short18_t;
typedef ushort18 ushort18_t;


NOINLINE int
cast_char6_to_int (int x)
{
  return (int) (char6_t) x;
}

NOINLINE int
cast_uchar6_to_int (int x)
{
  return (int) (uchar6_t) x;
}

NOINLINE int
cmp_char6_pair (int a, int b)
{
  return (char6_t) a == (char6_t) b;
}

NOINLINE int
cmp_uchar6_pair (int a, int b)
{
  return (uchar6_t) a == (uchar6_t) b;
}

NOINLINE int
cast_char7_to_int (int x)
{
  return (int) (char7_t) x;
}

NOINLINE int
cast_uchar7_to_int (int x)
{
  return (int) (uchar7_t) x;
}

NOINLINE int
cmp_char7_pair (int a, int b)
{
  return (char7_t) a == (char7_t) b;
}

NOINLINE int
cmp_uchar7_pair (int a, int b)
{
  return (uchar7_t) a == (uchar7_t) b;
}

NOINLINE int
cast_char8_to_int (int x)
{
  return (int) (char8_t) x;
}

NOINLINE int
cast_uchar8_to_int (int x)
{
  return (int) (uchar8_t) x;
}

NOINLINE int
cmp_char8_pair (int a, int b)
{
  return (char8_t) a == (char8_t) b;
}

NOINLINE int
cmp_uchar8_pair (int a, int b)
{
  return (uchar8_t) a == (uchar8_t) b;
}

NOINLINE int
cast_char9_to_int (int x)
{
  return (int) (char9_t) x;
}

NOINLINE int
cast_uchar9_to_int (int x)
{
  return (int) (uchar9_t) x;
}

NOINLINE int
cmp_char9_pair (int a, int b)
{
  return (char9_t) a == (char9_t) b;
}

NOINLINE int
cmp_uchar9_pair (int a, int b)
{
  return (uchar9_t) a == (uchar9_t) b;
}

NOINLINE int
cast_short16_to_int (int x)
{
  return (int) (short16_t) x;
}

NOINLINE int
cast_ushort16_to_int (int x)
{
  return (int) (ushort16_t) x;
}

NOINLINE int
cmp_short16_pair (int a, int b)
{
  return (short16_t) a == (short16_t) b;
}

NOINLINE int
cmp_ushort16_pair (int a, int b)
{
  return (ushort16_t) a == (ushort16_t) b;
}

NOINLINE int
cast_short18_to_int (int x)
{
  return (int) (short18_t) x;
}

NOINLINE int
cast_ushort18_to_int (int x)
{
  return (int) (ushort18_t) x;
}

NOINLINE int
cmp_short18_pair (int a, int b)
{
  return (short18_t) a == (short18_t) b;
}

NOINLINE int
cmp_ushort18_pair (int a, int b)
{
  return (ushort18_t) a == (ushort18_t) b;
}

int
size_cast_compare_all (void)
{
  int ok;

  ok = 1;

  /* Unsigned exact-width wrap to zero. */
  ok = ok && cast_uchar6_to_int (0100) == 0;
  ok = ok && cmp_uchar6_pair (0100, 0);
  ok = ok && cast_uchar7_to_int (0200) == 0;
  ok = ok && cmp_uchar7_pair (0200, 0);
  ok = ok && cast_uchar8_to_int (0400) == 0;
  ok = ok && cmp_uchar8_pair (0400, 0);
  ok = ok && cast_uchar9_to_int (01000) == 0;
  ok = ok && cmp_uchar9_pair (01000, 0);
  ok = ok && cast_ushort16_to_int (0200000) == 0;
  ok = ok && cmp_ushort16_pair (0200000, 0);
  ok = ok && cast_ushort18_to_int (01000000) == 0;
  ok = ok && cmp_ushort18_pair (01000000, 0);

  /* Unsigned exact-width nonzero masks. */
  ok = ok && cast_uchar6_to_int (077) == 077;
  ok = ok && cast_uchar7_to_int (0177) == 0177;
  ok = ok && cast_uchar8_to_int (0377) == 0377;
  ok = ok && cast_uchar9_to_int (0777) == 0777;
  ok = ok && cast_ushort16_to_int (0177777) == 0177777;
  ok = ok && cast_ushort18_to_int (0777777) == 0777777;

  /* Signed exact-width wrap to zero. */
  ok = ok && cast_char6_to_int (0100) == 0;
  ok = ok && cmp_char6_pair (0100, 0);
  ok = ok && cast_char7_to_int (0200) == 0;
  ok = ok && cmp_char7_pair (0200, 0);
  ok = ok && cast_char8_to_int (0400) == 0;
  ok = ok && cmp_char8_pair (0400, 0);
  ok = ok && cast_char9_to_int (01000) == 0;
  ok = ok && cmp_char9_pair (01000, 0);
  ok = ok && cast_short16_to_int (0200000) == 0;
  ok = ok && cmp_short16_pair (0200000, 0);
  ok = ok && cast_short18_to_int (01000000) == 0;
  ok = ok && cmp_short18_pair (01000000, 0);

  /* Signed exact-width sign extension. */
  ok = ok && cast_char6_to_int (077) == -1;
  ok = ok && cast_char7_to_int (0177) == -1;
  ok = ok && cast_char8_to_int (0377) == -1;
  ok = ok && cast_char9_to_int (0777) == -1;
  ok = ok && cast_short16_to_int (0177777) == -1;
  ok = ok && cast_short18_to_int (0777777) == -1;

  return ok;
}
