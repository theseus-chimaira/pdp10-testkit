#include "insns.h"

/* runtime-struct-copy-packed.c - packed subword struct copy sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct copy_inner {
  char6 c6;
  char9 c9;
  short18 h18;
} __attribute__ ((packed));

struct copy_rec {
  Sint tag;
  struct copy_inner inner[2];
  uchar8 bytes[3];
  ushort16 u16;
} __attribute__ ((packed));

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

NOINLINE static struct copy_rec
make_copy(seed)
int seed;
{
  struct copy_rec r;

  r.tag = (Sint)seed;
  r.inner[0].c6 = (char6)-31;
  r.inner[0].c9 = (char9)-255;
  r.inner[0].h18 = (short18)-012345;
  r.inner[1].c6 = (char6)30;
  r.inner[1].c9 = (char9)254;
  r.inner[1].h18 = (short18)012345;
  r.bytes[0] = (uchar8)0;
  r.bytes[1] = (uchar8)0377;
  r.bytes[2] = (uchar8)0123;
  r.u16 = (ushort16)65535;
  return r;
}

NOINLINE static int
check_copy(r, seed, base)
struct copy_rec *r;
int seed;
int base;
{
  if (!check_int((int)r->tag, seed, base + 0)) return 0;
  if (!check_int((int)r->inner[0].c6, -31, base + 1)) return 0;
  if (!check_int((int)r->inner[0].c9, -255, base + 2)) return 0;
  if (!check_int((int)r->inner[0].h18, -012345, base + 3)) return 0;
  if (!check_int((int)r->inner[1].c6, 30, base + 4)) return 0;
  if (!check_int((int)r->inner[1].c9, 254, base + 5)) return 0;
  if (!check_int((int)r->inner[1].h18, 012345, base + 6)) return 0;
  if (!check_int((int)r->bytes[1], 0377, base + 7)) return 0;
  if (!check_int((int)r->u16, 65535, base + 8)) return 0;
  return 1;
}

int
runtime_struct_copy_packed_all(seed)
int seed;
{
  struct copy_rec a;
  struct copy_rec b;

  semantic_fail_id = 0;
  semantic_sink = (uSint) seed;

  a = make_copy(seed);
  b = a;
  if (!check_copy(&b, seed, 0100)) return 0;

  a.inner[0].c9 = (char9)-1;
  a.bytes[1] = (uchar8)1;
  if (!check_int((int)b.inner[0].c9, -255, 0200)) return 0;
  if (!check_int((int)b.bytes[1], 0377, 0201)) return 0;

  b.inner[1].h18 = (short18)-077;
  if (!check_int((int)b.inner[1].h18, -077, 0202)) return 0;

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_struct_copy_packed_all(04))
    return 0;
  if (semantic_fail_id != 0)
    return (int) semantic_fail_id;
  return 0777777;
}
