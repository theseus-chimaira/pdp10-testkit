#include "insns.h"

/*
 * AOJ instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   AOJL   ++AC <  0
 *   AOJE   ++AC == 0
 *   AOJLE  ++AC <= 0
 *   AOJA   ++AC, unconditional jump
 *   AOJGE  ++AC >= 0
 *   AOJN   ++AC != 0
 *   AOJG   ++AC >  0
 *
 * Plain AOJ, opcode suffix "never", is not normally useful as a
 * compiler branch form.  A simple preincrement case is still included
 * as coverage for the non-branching increment shape, but ADDI is also
 * a valid lowering there.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

static Sint
aojl(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac < 0);

  return x + ac;
}

static Sint
aoje(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac == 0);

  return x + ac;
}

static Sint
aojle(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac <= 0);

  return x + ac;
}

static Sint
aojge(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac >= 0);

  return x + ac;
}

static Sint
aojn(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac != 0);

  return x + ac;
}

static Sint
aojg(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac > 0);

  return x + ac;
}

static Sint
aoja(x, ac)
Sint x;
Sint ac;
{
again:
  OPAQUE_REG(ac);
  x += ac;

  if (x == 0123456)
    return x + ac;

  ++ac;
  goto again;
}

static Sint
aoja_two_exits(x, ac)
Sint x;
Sint ac;
{
again:
  OPAQUE_REG(ac);
  x += ac;

  if (x < 0)
    return x + ac;
  if (x == 0)
    return ac;

  ++ac;
  goto again;
}

static Sint
aoj_plain_increment(x, ac)
Sint x;
Sint ac;
{
  OPAQUE_REG(ac);
  ++ac;
  return x + ac;
}

static Sint
aoj_preinc_value(x, ac)
Sint x;
Sint ac;
{
  OPAQUE_REG(ac);
  x += ++ac;
  return x + ac;
}

static Sint
aoj_nested_l_g(x, a, b)
Sint x;
Sint a;
Sint b;
{
  do {
    OPAQUE_REG(a);
    x += a;

    do {
      OPAQUE_REG(b);
      x += b;
    } while (++b > 0);
  } while (++a < 0);

  return x + a + b;
}

static Sint
aoj_nested_n_le(x, a, b)
Sint x;
Sint a;
Sint b;
{
  do {
    OPAQUE_REG(a);
    x += a;

    do {
      OPAQUE_REG(b);
      x += b;
    } while (++b <= 0);
  } while (++a != 0);

  return x + a + b;
}

static Sint
aoj_with_call(x, ac)
Sint x;
Sint ac;
{
  extern void clobber(void);

  do {
    OPAQUE_REG(ac);
    x += ac;
    clobber();
  } while (++ac > 0);

  return x + ac;
}

static Sint
aoj_with_memory_use(x, ac, p)
Sint x;
Sint ac;
Sint *p;
{
  do {
    OPAQUE_REG(ac);
    x += *p;
    x += ac;
  } while (++ac != 0);

  return x + ac + *p;
}

static Sint
aoj_threshold_l(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x ^= ac;
  } while (++ac < 0);

  return x + ac;
}

static Sint
aoj_threshold_ge(x, ac)
Sint x;
Sint ac;
{
  do {
    OPAQUE_REG(ac);
    x ^= ac;
  } while (++ac >= 0);

  return x + ac;
}

static Sint
aoje_from_minus_one(x)
Sint x;
{
  Sint ac;

  ac = -1;
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac == 0);

  return x + ac;
}

static Sint
aojn_from_minus_two(x)
Sint x;
{
  Sint ac;

  ac = -2;
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac != 0);

  return x + ac;
}

static uSint
uaojn(x, ac)
uSint x;
uSint ac;
{
  do {
    OPAQUE_REG(ac);
    x += ac;
  } while (++ac != 0);

  return x + ac;
}

static uSint
uaoja(x, ac)
uSint x;
uSint ac;
{
again:
  OPAQUE_REG(ac);
  x += ac;

  if (x == 0123456)
    return x + ac;

  ++ac;
  goto again;
}
