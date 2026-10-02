#include "insns.h"

/* runtime-struct-subword.c - semantic struct/subword address sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

struct subword_record {
  Sint lead;
  char6 c6[4];
  uchar6 u6[4];
  char7 c7;
  uchar7 u7;
  char8 c8[2];
  uchar8 u8[2];
  char9 c9[3];
  uchar9 u9[3];
  short16 s16;
  ushort16 u16;
  short18 s18[2];
  ushort18 u18[2];
  Qint q[3];
  uQint uq[3];
  Hint h[2];
  uHint uh[2];
  Sint tail;
};

struct packed_subword_record {
  char6 c6;
  char7 c7;
  char8 c8;
  char9 c9;
  short16 s16;
  short18 s18;
  Qint q;
  Hint h;
  Sint word;
} __attribute__ ((packed));

static struct subword_record global_rec;
static volatile struct subword_record volatile_rec;
static struct packed_subword_record packed_rec;

static int
check_int(got, exp, id)
int got;
int exp;
int id;
{
  if (got != exp)
    {
      semantic_fail_id = (uSint)id;
      semantic_sink = (uSint)got;
      return 0;
    }
  return 1;
}

NOINLINE static void
fill_record(p, seed)
struct subword_record *p;
int seed;
{
  p->lead = (Sint)seed;
  p->c6[0] = (char6)-1;
  p->c6[1] = (char6)31;
  p->c6[2] = (char6)-32;
  p->u6[0] = (uchar6)0;
  p->u6[1] = (uchar6)63;
  p->c7 = (char7)-64;
  p->u7 = (uchar7)127;
  p->c8[0] = (char8)-128;
  p->c8[1] = (char8)127;
  p->u8[0] = (uchar8)0;
  p->u8[1] = (uchar8)255;
  p->c9[0] = (char9)-256;
  p->c9[1] = (char9)255;
  p->c9[2] = (char9)(seed + 5);
  p->u9[0] = (uchar9)0;
  p->u9[1] = (uchar9)511;
  p->s16 = (short16)-32768;
  p->u16 = (ushort16)65535;
  p->s18[0] = (short18)-0200000;
  p->s18[1] = (short18)0177777;
  p->u18[0] = (ushort18)0;
  p->u18[1] = (ushort18)0377777;
  p->q[0] = (Qint)-256;
  p->q[1] = (Qint)255;
  p->q[2] = (Qint)-1;
  p->uq[0] = (uQint)0;
  p->uq[1] = (uQint)511;
  p->h[0] = (Hint)-0200000;
  p->h[1] = (Hint)0177777;
  p->uh[0] = (uHint)0;
  p->uh[1] = (uHint)0377777;
  p->tail = (Sint)(seed + 1);
}

NOINLINE static int
check_record(p, base)
struct subword_record *p;
int base;
{
  char9 *pc9;
  short18 *ps18;
  Qint *pq;
  Hint *ph;

  if (!check_int((int)p->lead, base, 1)) return 0;
  if (!check_int((int)p->c6[0], -1, 2)) return 0;
  if (!check_int((int)p->c6[1], 31, 3)) return 0;
  if (!check_int((int)p->c6[2], -32, 4)) return 0;
  if (!check_int((int)p->u6[1], 63, 5)) return 0;
  if (!check_int((int)p->c7, -64, 6)) return 0;
  if (!check_int((int)p->u7, 127, 7)) return 0;
  if (!check_int((int)p->c8[0], -128, 8)) return 0;
  if (!check_int((int)p->c8[1], 127, 9)) return 0;
  if (!check_int((int)p->u8[1], 255, 10)) return 0;
  if (!check_int((int)p->c9[0], -256, 11)) return 0;
  if (!check_int((int)p->c9[1], 255, 12)) return 0;
  if (!check_int((int)p->c9[2], base + 5, 13)) return 0;
  if (!check_int((int)p->u9[1], 511, 14)) return 0;
  if (!check_int((int)p->s16, -32768, 15)) return 0;
  if (!check_int((int)p->u16, 65535, 16)) return 0;
  if (!check_int((int)p->s18[0], -0200000, 17)) return 0;
  if (!check_int((int)p->s18[1], 0177777, 18)) return 0;
  if (!check_int((int)p->u18[1], 0377777, 19)) return 0;
  if (!check_int((int)p->q[0], -256, 20)) return 0;
  if (!check_int((int)p->q[1], 255, 21)) return 0;
  if (!check_int((int)p->q[2], -1, 22)) return 0;
  if (!check_int((int)p->uq[1], 511, 23)) return 0;
  if (!check_int((int)p->h[0], -0200000, 24)) return 0;
  if (!check_int((int)p->h[1], 0177777, 25)) return 0;
  if (!check_int((int)p->uh[1], 0377777, 26)) return 0;
  if (!check_int((int)p->tail, base + 1, 27)) return 0;

  pc9 = &p->c9[0];
  pc9 = pc9 + 2;
  *pc9 = (char9)-9;
  if (!check_int((int)p->c9[2], -9, 28)) return 0;
  if (!check_int((int)(pc9 - &p->c9[0]), 2, 29)) return 0;

  ps18 = &p->s18[0];
  ps18 = ps18 + 1;
  *ps18 = (short18)-10;
  if (!check_int((int)p->s18[1], -10, 30)) return 0;
  if (!check_int((int)(ps18 - &p->s18[0]), 1, 31)) return 0;

  pq = &p->q[0];
  pq = pq + 2;
  *pq = (Qint)-11;
  if (!check_int((int)p->q[2], -11, 32)) return 0;
  if (!check_int((int)(pq - &p->q[0]), 2, 33)) return 0;

  ph = &p->h[0];
  ph = ph + 1;
  *ph = (Hint)-12;
  if (!check_int((int)p->h[1], -12, 34)) return 0;
  if (!check_int((int)(ph - &p->h[0]), 1, 35)) return 0;

  return 1;
}

NOINLINE static int
test_local_and_global(seed)
int seed;
{
  struct subword_record local_rec;

  fill_record(&local_rec, seed);
  if (!check_record(&local_rec, seed)) return 0;

  fill_record(&global_rec, seed + 0100);
  if (!check_record(&global_rec, seed + 0100)) return 0;

  volatile_rec.lead = (Sint)(seed + 0200);
  volatile_rec.c9[1] = (char9)-13;
  volatile_rec.h[1] = (Hint)-14;
  if (!check_int((int)volatile_rec.lead, seed + 0200, 101)) return 0;
  if (!check_int((int)volatile_rec.c9[1], -13, 102)) return 0;
  if (!check_int((int)volatile_rec.h[1], -14, 103)) return 0;

  return 1;
}

NOINLINE static int
test_packed(seed)
int seed;
{
  char9 *pc9;

  packed_rec.c6 = (char6)-1;
  packed_rec.c7 = (char7)-2;
  packed_rec.c8 = (char8)-3;
  packed_rec.c9 = (char9)-4;
  packed_rec.s16 = (short16)-5;
  packed_rec.s18 = (short18)-6;
  packed_rec.q = (Qint)-7;
  packed_rec.h = (Hint)-8;
  packed_rec.word = (Sint)seed;

  if (!check_int((int)packed_rec.c6, -1, 201)) return 0;
  if (!check_int((int)packed_rec.c7, -2, 202)) return 0;
  if (!check_int((int)packed_rec.c8, -3, 203)) return 0;
  if (!check_int((int)packed_rec.c9, -4, 204)) return 0;
  if (!check_int((int)packed_rec.s16, -5, 205)) return 0;
  if (!check_int((int)packed_rec.s18, -6, 206)) return 0;
  if (!check_int((int)packed_rec.q, -7, 207)) return 0;
  if (!check_int((int)packed_rec.h, -8, 208)) return 0;
  if (!check_int((int)packed_rec.word, seed, 209)) return 0;

  pc9 = &packed_rec.c9;
  *pc9 = (char9)-15;
  if (!check_int((int)packed_rec.c9, -15, 210)) return 0;

  return 1;
}

int
runtime_struct_subword_all(seed)
int seed;
{
  semantic_fail_id = 0;
  semantic_sink = (uSint)seed;
  if (!test_local_and_global(seed)) return 0;
  if (!test_packed(seed)) return 0;
  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_struct_subword_all(0123))
    return 0;
  if (semantic_fail_id != 0)
    return (int)semantic_fail_id;
  return 0777777;
}
