/* flag: -O2 */
#include "insns.h"

/*
 * casesi / switch lowering coverage for PDP-6/166 and KA10.
 *
 * Dense switches should keep the casesi/jump-table path visible.
 * Sparse switches may lower to compare chains; that is acceptable.
 *
 * Important source shapes:
 *
 *   dense 0-based switch
 *   dense nonzero-low switch
 *   dense negative-low switch
 *   sparse positive/negative switch
 *   grouped cases
 *   fall-through cases
 *   switch result assigned to a variable
 *   switch with side effects before return
 *   nested switches
 *
 * The backend casesi expander subtracts the low bound, performs range
 * checks, then emits an indirect JRST through the selected table word.
 */

extern void sink_int();
enum switch_color {
  sw_red,
  sw_green,
  sw_blue,
  sw_yellow,
  sw_black,
  sw_white
} x;

static int
switch_dense(x)
int x;
{
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 3:
    return 13;
  case 4:
    return 14;
  case 5:
    return 15;
  default:
    return -1;
  }
}

static Sint
switch_dense_sint(x)
Sint x;
{
  switch (x) {
  case 0:
    return 010;
  case 1:
    return 011;
  case 2:
    return 012;
  case 3:
    return 013;
  case 4:
    return 014;
  case 5:
    return 015;
  case 6:
    return 016;
  case 7:
    return 017;
  default:
    return -1;
  }
}

static int
switch_dense_offset(x)
int x;
{
  switch (x) {
  case 10:
    return 100;
  case 11:
    return 101;
  case 12:
    return 102;
  case 13:
    return 103;
  case 14:
    return 104;
  case 15:
    return 105;
  default:
    return -1;
  }
}

static int
switch_dense_negative(x)
int x;
{
  switch (x) {
  case -3:
    return 30;
  case -2:
    return 31;
  case -1:
    return 32;
  case 0:
    return 33;
  case 1:
    return 34;
  case 2:
    return 35;
  case 3:
    return 36;
  default:
    return -1;
  }
}

static int
switch_dense_octal(x)
int x;
{
  switch (x) {
  case 020:
    return 1;
  case 021:
    return 2;
  case 022:
    return 3;
  case 023:
    return 4;
  case 024:
    return 5;
  case 025:
    return 6;
  case 026:
    return 7;
  default:
    return 0;
  }
}

static int
switch_dense_large_low(x)
int x;
{
  switch (x) {
  case 0123400:
    return 1;
  case 0123401:
    return 2;
  case 0123402:
    return 3;
  case 0123403:
    return 4;
  case 0123404:
    return 5;
  case 0123405:
    return 6;
  default:
    return -1;
  }
}

static int
switch_dense_with_hole(x)
int x;
{
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 4:
    return 14;
  case 5:
    return 15;
  case 6:
    return 16;
  default:
    return -1;
  }
}

static int
switch_dense_many(x)
int x;
{
  switch (x) {
  case 0:
    return 100;
  case 1:
    return 101;
  case 2:
    return 102;
  case 3:
    return 103;
  case 4:
    return 104;
  case 5:
    return 105;
  case 6:
    return 106;
  case 7:
    return 107;
  case 8:
    return 108;
  case 9:
    return 109;
  case 10:
    return 110;
  case 11:
    return 111;
  default:
    return -1;
  }
}

static int
switch_sparse(x)
int x;
{
  switch (x) {
  case -20:
    return 1;
  case -1:
    return 2;
  case 0:
    return 3;
  case 20:
    return 4;
  case 0400:
    return 5;
  default:
    return 0;
  }
}

static int
switch_sparse_large(x)
int x;
{
  switch (x) {
  case -0123456:
    return -1;
  case 0:
    return 0;
  case 0123456:
    return 1;
  case 0123456123:
    return 2;
  case 0777777:
    return 3;
  default:
    return -2;
  }
}

static int
switch_sparse_no_default(x)
int x;
{
  int r;

  r = 0;
  switch (x) {
  case -10:
    r = 1;
    break;
  case 10:
    r = 2;
    break;
  case 01000:
    r = 3;
    break;
  }

  return r;
}

static int
switch_one_case(x)
int x;
{
  switch (x) {
  case 0:
    return 1;
  default:
    return -1;
  }
}

static int
switch_two_cases(x)
int x;
{
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  default:
    return -1;
  }
}

static int
switch_three_cases(x)
int x;
{
  switch (x) {
  case -1:
    return 1;
  case 0:
    return 2;
  case 1:
    return 3;
  default:
    return 0;
  }
}

static int
switch_grouped(x)
int x;
{
  switch (x) {
  case 0:
  case 1:
    return 10;
  case 2:
  case 3:
    return 20;
  case 4:
  case 5:
    return 30;
  default:
    return -1;
  }
}

static int
switch_grouped_negative(x)
int x;
{
  switch (x) {
  case -4:
  case -3:
    return 1;
  case -2:
  case -1:
    return 2;
  case 0:
  case 1:
    return 3;
  default:
    return 0;
  }
}

static int
switch_fallthrough(x)
int x;
{
  int r;

  r = 0;
  switch (x) {
  case 0:
    r += 1;
  case 1:
    r += 2;
    break;
  case 2:
  case 3:
    r += 4;
    break;
  default:
    r = -1;
  }

  return r;
}

static int
switch_fallthrough_dense(x)
int x;
{
  int r;

  r = 0;
  switch (x) {
  case 0:
    r += 1;
  case 1:
    r += 2;
  case 2:
    r += 3;
    break;
  case 3:
    r += 4;
  case 4:
    r += 5;
    break;
  default:
    r = -1;
  }

  return r;
}

static int
switch_assign_result(x, seed)
int x;
int seed;
{
  int r;

  r = seed;
  switch (x) {
  case 0:
    r += 10;
    break;
  case 1:
    r += 11;
    break;
  case 2:
    r += 12;
    break;
  case 3:
    r += 13;
    break;
  case 4:
    r += 14;
    break;
  default:
    r = -1;
    break;
  }

  return r;
}

static int
switch_assign_no_default(x, seed)
int x;
int seed;
{
  int r;

  r = seed;
  switch (x) {
  case 0:
    r += 1;
    break;
  case 1:
    r += 2;
    break;
  case 2:
    r += 3;
    break;
  case 3:
    r += 4;
    break;
  }

  return r;
}

static int
switch_side_effects(x, p)
int x;
int *p;
{
  switch (x) {
  case 0:
    *p += 1;
    return *p;
  case 1:
    *p += 2;
    return *p;
  case 2:
    *p += 3;
    return *p;
  case 3:
    *p += 4;
    return *p;
  default:
    *p = -1;
    return *p;
  }
}

static int
switch_side_effects_join(x, p)
int x;
int *p;
{
  int r;

  switch (x) {
  case 0:
    *p += 1;
    r = 10;
    break;
  case 1:
    *p += 2;
    r = 11;
    break;
  case 2:
    *p += 3;
    r = 12;
    break;
  case 3:
    *p += 4;
    r = 13;
    break;
  default:
    *p = -1;
    r = -1;
    break;
  }

  return r + *p;
}

static int
switch_with_call(x)
int x;
{
  int r;

  switch (x) {
  case 0:
    r = 10;
    break;
  case 1:
    r = 11;
    break;
  case 2:
    r = 12;
    break;
  case 3:
    r = 13;
    break;
  default:
    r = -1;
    break;
  }

  sink_int(r);
  return r;
}

static int
switch_call_in_cases(x)
int x;
{
  switch (x) {
  case 0:
    sink_int(0);
    return 10;
  case 1:
    sink_int(1);
    return 11;
  case 2:
    sink_int(2);
    return 12;
  case 3:
    sink_int(3);
    return 13;
  default:
    sink_int(-1);
    return -1;
  }
}

static int
switch_mem_input(p)
int *p;
{
  int x;

  x = *p;
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 3:
    return 13;
  default:
    return -1;
  }
}

static int
switch_volatile_input(p)
volatile int *p;
{
  int x;

  x = *p;
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 3:
    return 13;
  default:
    return -1;
  }
}

static int
switch_expr_input(x, y)
int x;
int y;
{
  switch (x + y) {
  case 0:
    return 1;
  case 1:
    return 2;
  case 2:
    return 3;
  case 3:
    return 4;
  case 4:
    return 5;
  default:
    return -1;
  }
}

static int
switch_masked_input(x)
int x;
{
  switch (x & 7) {
  case 0:
    return 010;
  case 1:
    return 011;
  case 2:
    return 012;
  case 3:
    return 013;
  case 4:
    return 014;
  case 5:
    return 015;
  case 6:
    return 016;
  default:
    return 017;
  }
}

static int
switch_shifted_input(x)
int x;
{
  switch ((x >> 1) & 7) {
  case 0:
    return 0;
  case 1:
    return 10;
  case 2:
    return 20;
  case 3:
    return 30;
  case 4:
    return 40;
  case 5:
    return 50;
  case 6:
    return 60;
  case 7:
    return 70;
  default:
    return -1;
  }
}

static int
switch_char_input(x)
char x;
{
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 3:
    return 13;
  default:
    return -1;
  }
}

static int
switch_qint_input(x)
Qint x;
{
  switch (x) {
  case -2:
    return 1;
  case -1:
    return 2;
  case 0:
    return 3;
  case 1:
    return 4;
  case 2:
    return 5;
  default:
    return 0;
  }
}

static int
switch_uqint_input(x)
uQint x;
{
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 3:
    return 13;
  case 4:
    return 14;
  default:
    return -1;
  }
}

static int
switch_hint_input(x)
Hint x;
{
  switch (x) {
  case -2:
    return 1;
  case -1:
    return 2;
  case 0:
    return 3;
  case 1:
    return 4;
  case 2:
    return 5;
  default:
    return 0;
  }
}

static int
switch_unsigned_input(x)
unsigned int x;
{
  switch (x) {
  case 0:
    return 10;
  case 1:
    return 11;
  case 2:
    return 12;
  case 3:
    return 13;
  case 4:
    return 14;
  case 5:
    return 15;
  default:
    return 0;
  }
}

static int
switch_enum_input(x)
enum switch_color x;
{
  switch (x) {
  case sw_red:
    return 1;
  case sw_green:
    return 2;
  case sw_blue:
    return 3;
  case sw_yellow:
    return 4;
  case sw_black:
    return 5;
  case sw_white:
    return 6;
  default:
    return 0;
  }
}

static int
switch_nested(x, y)
int x;
int y;
{
  switch (x) {
  case 0:
    switch (y) {
    case 0:
      return 00;
    case 1:
      return 01;
    case 2:
      return 02;
    default:
      return -1;
    }
  case 1:
    switch (y) {
    case 0:
      return 10;
    case 1:
      return 11;
    case 2:
      return 12;
    default:
      return -1;
    }
  case 2:
    return 20;
  default:
    return -2;
  }
}

static int
switch_nested_dense_sparse(x, y)
int x;
int y;
{
  switch (x) {
  case 0:
    return switch_dense(y);
  case 1:
    return switch_sparse(y);
  case 2:
    return switch_fallthrough(y);
  case 3:
    return switch_dense_negative(y);
  default:
    return -1;
  }
}

static int
switch_loop_dispatch(v, n)
int *v;
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i) {
    switch (v[i & 017] & 7) {
    case 0:
      r += 1;
      break;
    case 1:
      r += 2;
      break;
    case 2:
      r += 3;
      break;
    case 3:
      r += 4;
      break;
    case 4:
      r += 5;
      break;
    default:
      r -= 1;
      break;
    }
  }

  return r;
}

static int
switch_loop_with_break(v, n)
int *v;
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i) {
    switch (v[i & 017]) {
    case 0:
      return r;
    case 1:
      r += 1;
      break;
    case 2:
      r += 2;
      break;
    case 3:
      r += 3;
      break;
    default:
      r -= 1;
      break;
    }
  }

  return r;
}

static int
switch_loop_with_continue(v, n)
int *v;
int n;
{
  int i;
  int r;

  r = 0;
  for (i = 0; i < n; ++i) {
    switch (v[i & 017]) {
    case 0:
      continue;
    case 1:
      r += 1;
      break;
    case 2:
      r += 2;
      break;
    case 3:
      r += 3;
      break;
    default:
      r -= 1;
      break;
    }
  }

  return r;
}

static int
switch_store_result(x, p)
int x;
int *p;
{
  switch (x) {
  case 0:
    *p = 10;
    break;
  case 1:
    *p = 11;
    break;
  case 2:
    *p = 12;
    break;
  case 3:
    *p = 13;
    break;
  case 4:
    *p = 14;
    break;
  default:
    *p = -1;
    break;
  }

  return *p;
}

static int
switch_store_global(x)
int x;
{
  static int g;

  switch (x) {
  case 0:
    g = 1;
    break;
  case 1:
    g = 2;
    break;
  case 2:
    g = 3;
    break;
  case 3:
    g = 4;
    break;
  default:
    g = -1;
    break;
  }

  return g;
}

static int
switch_return_address_like(x)
int x;
{
  switch (x) {
  case 0:
    return 0400;
  case 1:
    return 0401;
  case 2:
    return 0402;
  case 3:
    return 0403;
  case 4:
    return 0404;
  default:
    return 0;
  }
}

static Sint
switch_return_large_values(x)
int x;
{
  switch (x) {
  case 0:
    return 0123456123456;
  case 1:
    return 0777777777777;
  case 2:
    return 0400000000000;
  case 3:
    return 0000000777777;
  default:
    return -1;
  }
}

static int
switch_default_middle_source_order(x)
int x;
{
  switch (x) {
  case 2:
    return 20;
  default:
    return -1;
  case 0:
    return 0;
  case 1:
    return 10;
  case 3:
    return 30;
  }
}

static int
switch_empty_default(x)
int x;
{
  int r;

  r = 0;
  switch (x) {
  case 0:
    r = 1;
    break;
  case 1:
    r = 2;
    break;
  case 2:
    r = 3;
    break;
  default:
    break;
  }

  return r;
}

static int
switch_no_cases(x)
int x;
{
  int r;

  r = x;
  switch (x) {
  default:
    r = -1;
    break;
  }

  return r;
}

static int
use_switches(x)
int x;
{
  return switch_dense(x)
       + switch_sparse(x)
       + switch_fallthrough(x);
}

static int
use_more_switches(x, y)
int x;
int y;
{
  return switch_dense_offset(x)
       + switch_dense_negative(y)
       + switch_grouped(x)
       + switch_nested_dense_sparse(x, y);
}

