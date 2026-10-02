/* flag: -O2 */
/*
 * PDP-10 exact-size cast branch sentry.
 *
 * This is the companion to size-cast-compare.c.  That file exercises
 * boolean-as-value comparisons, which usually go through store-flag
 * expansion.  This file forces real conditional branches by calling
 * noinline side-effect helpers on each arm.
 *
 * Purpose: decide whether the PDP-10 compare-and-jump path also needs
 * exact __attribute__ ((size (N))) narrowing, or whether the store-flag
 * fix is sufficient.
 *
 * Expected code shape for exact-width branch compares:
 *   uchar6_t:    mask with 077, not 0777
 *   uchar7_t:    mask with 0177, not 0777
 *   uchar8_t:    mask with 0377, not 0777
 *   ushort16_t:  mask with 0177777, not right-half/HImode 0777777
 *   signed size(6/7/8/16): exact sign extension, not QI/HI container width
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


static volatile int size_cast_branch_sink;

NOINLINE int
branch_yes (void)
{
  size_cast_branch_sink += 1;
  return 1;
}

NOINLINE int
branch_no (void)
{
  size_cast_branch_sink += 2;
  return 0;
}

NOINLINE int
branch_char6_eq (int a, int b)
{
  if ((char6_t) a == (char6_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_uchar6_eq (int a, int b)
{
  if ((uchar6_t) a == (uchar6_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_char7_eq (int a, int b)
{
  if ((char7_t) a == (char7_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_uchar7_eq (int a, int b)
{
  if ((uchar7_t) a == (uchar7_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_char8_eq (int a, int b)
{
  if ((char8_t) a == (char8_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_uchar8_eq (int a, int b)
{
  if ((uchar8_t) a == (uchar8_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_char9_eq (int a, int b)
{
  if ((char9_t) a == (char9_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_uchar9_eq (int a, int b)
{
  if ((uchar9_t) a == (uchar9_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_short16_eq (int a, int b)
{
  if ((short16_t) a == (short16_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_ushort16_eq (int a, int b)
{
  if ((ushort16_t) a == (ushort16_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_short18_eq (int a, int b)
{
  if ((short18_t) a == (short18_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_ushort18_eq (int a, int b)
{
  if ((ushort18_t) a == (ushort18_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_char6_ne (int a, int b)
{
  if ((char6_t) a != (char6_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_uchar6_ne (int a, int b)
{
  if ((uchar6_t) a != (uchar6_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_short16_ne (int a, int b)
{
  if ((short16_t) a != (short16_t) b)
    return branch_yes ();
  return branch_no ();
}

NOINLINE int
branch_ushort16_ne (int a, int b)
{
  if ((ushort16_t) a != (ushort16_t) b)
    return branch_yes ();
  return branch_no ();
}

int
size_cast_branch_all (void)
{
  int ok;

  ok = 1;

  /* Unsigned exact-width wrap equality. */
  ok = ok && branch_uchar6_eq (0100, 0);
  ok = ok && branch_uchar7_eq (0200, 0);
  ok = ok && branch_uchar8_eq (0400, 0);
  ok = ok && branch_uchar9_eq (01000, 0);
  ok = ok && branch_ushort16_eq (0200000, 0);
  ok = ok && branch_ushort18_eq (01000000, 0);

  /* Signed exact-width wrap equality. */
  ok = ok && branch_char6_eq (0100, 0);
  ok = ok && branch_char7_eq (0200, 0);
  ok = ok && branch_char8_eq (0400, 0);
  ok = ok && branch_char9_eq (01000, 0);
  ok = ok && branch_short16_eq (0200000, 0);
  ok = ok && branch_short18_eq (01000000, 0);

  /* Exact-width non-equality sentries. */
  ok = ok && branch_uchar6_ne (077, 0);
  ok = ok && branch_char6_ne (077, 0);
  ok = ok && branch_ushort16_ne (0177777, 0);
  ok = ok && branch_short16_ne (0177777, 0);

  return ok;
}
