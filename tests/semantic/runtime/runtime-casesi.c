#include "insns.h"

/* runtime-casesi.c - semantic switch/tablejump sentry. */

#ifndef NOINLINE
#define NOINLINE __attribute__ ((noinline))
#endif

volatile uSint __test_exit;
volatile uSint semantic_fail_id;
volatile uSint semantic_sink;

enum runtime_color {
  rc_red,
  rc_green,
  rc_blue,
  rc_yellow,
  rc_black,
  rc_white
};

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

NOINLINE static int
sw_dense(x)
int x;
{
  switch (x) {
  case 0: return 10;
  case 1: return 11;
  case 2: return 12;
  case 3: return 13;
  case 4: return 14;
  case 5: return 15;
  default: return -1;
  }
}

NOINLINE static int
sw_offset(x)
int x;
{
  switch (x) {
  case 10: return 100;
  case 11: return 101;
  case 12: return 102;
  case 13: return 103;
  case 14: return 104;
  case 15: return 105;
  default: return -1;
  }
}

NOINLINE static int
sw_negative(x)
int x;
{
  switch (x) {
  case -3: return 30;
  case -2: return 31;
  case -1: return 32;
  case 0: return 33;
  case 1: return 34;
  case 2: return 35;
  case 3: return 36;
  default: return -1;
  }
}

NOINLINE static int
sw_sparse(x)
int x;
{
  switch (x) {
  case -100: return 1;
  case -7: return 2;
  case 0: return 3;
  case 17: return 4;
  case 0777: return 5;
  default: return -1;
  }
}

NOINLINE static int
sw_hole(x)
int x;
{
  switch (x) {
  case 0: return 10;
  case 1: return 11;
  case 2: return 12;
  case 4: return 14;
  case 5: return 15;
  case 6: return 16;
  default: return -1;
  }
}

NOINLINE static int
sw_enum(x)
enum runtime_color x;
{
  switch (x) {
  case rc_red: return 1;
  case rc_green: return 2;
  case rc_blue: return 3;
  case rc_yellow: return 4;
  case rc_black: return 5;
  case rc_white: return 6;
  default: return -1;
  }
}

NOINLINE static Sint
sw_large_values(x)
int x;
{
  switch (x) {
  case 0: return (Sint)0123456123456;
  case 1: return (Sint)-1;
  case 2: return (Sint)0400000000000;
  case 3: return (Sint)0000000777777;
  default: return (Sint)-2;
  }
}

static int
expect_dense(x)
int x;
{
  if (x >= 0 && x <= 5)
    return 10 + x;
  return -1;
}

static int
expect_offset(x)
int x;
{
  if (x >= 10 && x <= 15)
    return 90 + x;
  return -1;
}

static int
expect_negative(x)
int x;
{
  if (x >= -3 && x <= 3)
    return 33 + x;
  return -1;
}

static int
expect_sparse(x)
int x;
{
  if (x == -100) return 1;
  if (x == -7) return 2;
  if (x == 0) return 3;
  if (x == 17) return 4;
  if (x == 0777) return 5;
  return -1;
}

static int
expect_hole(x)
int x;
{
  if (x == 0) return 10;
  if (x == 1) return 11;
  if (x == 2) return 12;
  if (x == 4) return 14;
  if (x == 5) return 15;
  if (x == 6) return 16;
  return -1;
}

static int
expect_enum(x)
int x;
{
  if (x >= 0 && x <= 5)
    return x + 1;
  return -1;
}

static int
expect_large(x)
int x;
{
  if (x == 0) return 0123456123456;
  if (x == 1) return -1;
  if (x == 2) return 0400000000000;
  if (x == 3) return 0000000777777;
  return -2;
}

int
runtime_casesi_all(seed)
int seed;
{
  int x;
  int id;

  semantic_fail_id = 0;
  semantic_sink = (uSint)seed;
  id = 1;

  for (x = -2; x <= 7; x++) {
    if (!check_int(sw_dense(x), expect_dense(x), id)) return 0;
    id++;
  }
  for (x = 8; x <= 17; x++) {
    if (!check_int(sw_offset(x), expect_offset(x), id)) return 0;
    id++;
  }
  for (x = -5; x <= 5; x++) {
    if (!check_int(sw_negative(x), expect_negative(x), id)) return 0;
    id++;
  }
  for (x = -105; x <= -95; x++) {
    if (!check_int(sw_sparse(x), expect_sparse(x), id)) return 0;
    id++;
  }
  for (x = -1; x <= 8; x++) {
    if (!check_int(sw_hole(x), expect_hole(x), id)) return 0;
    id++;
  }
  for (x = -1; x <= 7; x++) {
    if (!check_int(sw_enum((enum runtime_color)x), expect_enum(x), id)) return 0;
    id++;
  }
  for (x = -1; x <= 4; x++) {
    if (!check_int((int)sw_large_values(x), expect_large(x), id)) return 0;
    id++;
  }

  semantic_fail_id = 0;
  return 1;
}

int
main()
{
  if (runtime_casesi_all(0123))
    return 0;
  if (semantic_fail_id != 0)
    return (int)semantic_fail_id;
  return 0777777;
}
