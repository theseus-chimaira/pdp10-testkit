#include "insns.h"

/*
 * SOJ instruction family coverage for PDP-6/166 and KA10.
 *
 * Intended forms:
 *   SOJ    AC,label-ish decrement without useful branch condition
 *   SOJL   --AC; jump if AC <  0
 *   SOJE   --AC; jump if AC == 0
 *   SOJLE  --AC; jump if AC <= 0
 *   SOJA   --AC; unconditional jump
 *   SOJGE  --AC; jump if AC >= 0
 *   SOJN   --AC; jump if AC != 0
 *   SOJG   --AC; jump if AC >  0
 *
 * Memory decrement-and-branch belongs to SOS.c.  This file keeps the
 * decremented object in a register so the backend has a direct SOJ
 * opportunity.
 */

static Sint soj_ga;
static Sint soj_gb;

static Sint
sojl_loop(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (--ac < 0);
  return x + ac;
}

static Sint
soje_loop(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (--ac == 0);
  return x + ac;
}

static Sint
sojle_loop(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (--ac <= 0);
  return x + ac;
}

static Sint
sojge_loop(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (--ac >= 0);
  return x + ac;
}

static Sint
sojn_loop(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (--ac != 0);
  return x + ac;
}

static Sint
sojg_loop(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (--ac > 0);
  return x + ac;
}

static Sint
soja_loop(x, ac)
Sint x;
Sint ac;
{
again:
  x += ac;
  --ac;
  if (x & 1)
    goto again;
  return x + ac;
}

static Sint
soj_plain_dec(x, ac)
Sint x;
Sint ac;
{
  ac--;
  return x + ac;
}

static Sint
sojl_if(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac < 0)
    x += ac;
  return x;
}

static Sint
soje_if(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac == 0)
    x += ac;
  return x;
}

static Sint
sojle_if(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac <= 0)
    x += ac;
  return x;
}

static Sint
sojge_if(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac >= 0)
    x += ac;
  return x;
}

static Sint
sojn_if(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac != 0)
    x += ac;
  return x;
}

static Sint
sojg_if(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac > 0)
    x += ac;
  return x;
}

static Sint
sojl_goto(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac < 0)
    goto yes;
  return x;
yes:
  return x + ac;
}

static Sint
soje_goto(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac == 0)
    goto yes;
  return x;
yes:
  return x + ac;
}

static Sint
sojle_goto(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac <= 0)
    goto yes;
  return x;
yes:
  return x + ac;
}

static Sint
sojge_goto(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac >= 0)
    goto yes;
  return x;
yes:
  return x + ac;
}

static Sint
sojn_goto(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac != 0)
    goto yes;
  return x;
yes:
  return x + ac;
}

static Sint
sojg_goto(x, ac)
Sint x;
Sint ac;
{
  --ac;
  if (ac > 0)
    goto yes;
  return x;
yes:
  return x + ac;
}

static Sint
sojge_for_sum(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = n; --i >= 0; )
    s += i;

  return s;
}

static Sint
sojg_for_sum(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = n; --i > 0; )
    s += i;

  return s;
}

static Sint
sojn_for_sum(n)
Sint n;
{
  Sint i;
  Sint s;

  s = 0;
  for (i = n; --i != 0; )
    s += i;

  return s;
}

static Sint
soje_once(x, ac)
Sint x;
Sint ac;
{
  while (--ac == 0)
    x += ac;
  return x + ac;
}

static Sint
sojl_once(x, ac)
Sint x;
Sint ac;
{
  while (--ac < 0)
    x += ac;
  return x + ac;
}

static Sint
sojle_once(x, ac)
Sint x;
Sint ac;
{
  while (--ac <= 0)
    x += ac;
  return x + ac;
}

static Sint
sojge_once(x, ac)
Sint x;
Sint ac;
{
  while (--ac >= 0)
    x += ac;
  return x + ac;
}

static Sint
sojn_once(x, ac)
Sint x;
Sint ac;
{
  while (--ac != 0)
    x += ac;
  return x + ac;
}

static Sint
sojg_once(x, ac)
Sint x;
Sint ac;
{
  while (--ac > 0)
    x += ac;
  return x + ac;
}

static Sint
sojl_likely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (likely(--ac < 0));
  return x + ac;
}

static Sint
soje_likely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (likely(--ac == 0));
  return x + ac;
}

static Sint
sojle_likely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (likely(--ac <= 0));
  return x + ac;
}

static Sint
sojge_likely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (likely(--ac >= 0));
  return x + ac;
}

static Sint
sojn_likely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (likely(--ac != 0));
  return x + ac;
}

static Sint
sojg_likely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (likely(--ac > 0));
  return x + ac;
}

static Sint
sojl_unlikely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (unlikely(--ac < 0));
  return x + ac;
}

static Sint
soje_unlikely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (unlikely(--ac == 0));
  return x + ac;
}

static Sint
sojle_unlikely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (unlikely(--ac <= 0));
  return x + ac;
}

static Sint
sojge_unlikely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (unlikely(--ac >= 0));
  return x + ac;
}

static Sint
sojn_unlikely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (unlikely(--ac != 0));
  return x + ac;
}

static Sint
sojg_unlikely(x, ac)
Sint x;
Sint ac;
{
  do {
    x += ac;
  } while (unlikely(--ac > 0));
  return x + ac;
}

static Sint
sojge_global_bound(ac)
Sint ac;
{
  Sint x;

  x = soj_ga;
  do {
    x += ac;
  } while (--ac >= 0);
  soj_ga = x;
  return x + ac;
}

static Sint
sojg_global_bound(ac)
Sint ac;
{
  Sint x;

  x = soj_gb;
  do {
    x += ac;
  } while (--ac > 0);
  soj_gb = x;
  return x + ac;
}

static Sint
sojn_global_count(ac)
Sint ac;
{
  Sint x;

  x = soj_ga;
  do {
    x ^= ac;
  } while (--ac != 0);
  soj_ga = x;
  return x + ac;
}

static Sint
soje_global_count(ac)
Sint ac;
{
  Sint x;

  x = soj_gb;
  do {
    x ^= ac;
  } while (--ac == 0);
  soj_gb = x;
  return x + ac;
}

static Sint
sojl_nested(x, ac, y)
Sint x;
Sint ac;
Sint y;
{
  do {
    if (y)
      x += ac;
    else
      x ^= ac;
  } while (--ac < 0);
  return x + ac;
}

static Sint
sojg_nested(x, ac, y)
Sint x;
Sint ac;
Sint y;
{
  do {
    if (y)
      x += ac;
    else
      x ^= ac;
  } while (--ac > 0);
  return x + ac;
}
