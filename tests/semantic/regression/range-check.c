#include "insns.h"

/*
 * Range-check and range-compare coverage.
 *
 * The PDP-10 backend has special output for combined range tests such
 * as
 *
 *     x < low || x > high
 *     x >= low && x <= high
 *     (unsigned)(x - low) <= width
 *
 * This file keeps the C source ordinary and tries to expose the common
 * branch, boolean-value, memory-operand, and single-target shapes.
 */

extern void bar(void);
extern void baz(void);
extern void use_int(int);

static int g_low = 017;
static int g_high = 042;
static int g_int = 023;
static volatile int vg_int = 025;
static Sint gs_int = (Sint)031;
static volatile Sint vgs_int = (Sint)033;

#define RLOW  017
#define RHIGH 042
#define RWIDTH (RHIGH - RLOW)

#define OR_VOID(N, LOW, HIGH, BODY, TAIL) \
static void \
range_or_ ## N (int x) \
{ \
	if (x < (LOW) || x > (HIGH)) { BODY; } \
	TAIL; \
}

#define AND_VOID(N, LOW, HIGH, BODY, TAIL) \
static void \
range_and_ ## N (int x) \
{ \
	if (x > (LOW) && x < (HIGH)) { BODY; } \
	TAIL; \
}

#define OR_VALUE(N, LOW, HIGH) \
static int \
range_or_value_ ## N (int x) \
{ \
	return x < (LOW) || x > (HIGH); \
}

#define AND_VALUE(N, LOW, HIGH) \
static int \
range_and_value_ ## N (int x) \
{ \
	return x > (LOW) && x < (HIGH); \
}

OR_VOID(call, RLOW, RHIGH, bar(), baz())
OR_VOID(ret, RLOW, RHIGH, bar(); return, baz())
OR_VOID(doublecall, RLOW, RHIGH, bar(); bar(), baz())
OR_VOID(doubletail, RLOW, RHIGH, bar(), baz(); baz())

AND_VOID(call, RLOW, RHIGH, bar(), baz())
AND_VOID(ret, RLOW, RHIGH, bar(); return, baz())
AND_VOID(doublecall, RLOW, RHIGH, bar(); bar(), baz())
AND_VOID(doubletail, RLOW, RHIGH, bar(), baz(); baz())

OR_VOID(zero, 0, RHIGH, bar(), baz())
AND_VOID(zero, -1, RHIGH, bar(), baz())
OR_VOID(neg, -7, RHIGH, bar(), baz())
AND_VOID(neg, -8, RHIGH, bar(), baz())
OR_VOID(one, 1, 077, bar(), baz())
AND_VOID(one, 0, 077, bar(), baz())

OR_VALUE(small, RLOW, RHIGH)
OR_VALUE(zero, 0, RHIGH)
OR_VALUE(neg, -7, RHIGH)
OR_VALUE(large, 0400000, 0400077)

AND_VALUE(small, RLOW, RHIGH)
AND_VALUE(zero, -1, RHIGH)
AND_VALUE(neg, -8, RHIGH)
AND_VALUE(large, 0377777, 0400077)

static int
range_inside_closed(x)
int x;
{
	return x >= RLOW && x <= RHIGH;
}

static int
range_outside_closed(x)
int x;
{
	return x < RLOW || x > RHIGH;
}

static int
range_inside_open(x)
int x;
{
	return x > RLOW && x < RHIGH;
}

static int
range_outside_open(x)
int x;
{
	return x <= RLOW || x >= RHIGH;
}

static int
range_unsigned_inside(x)
int x;
{
	return (unsigned int)(x - RLOW) <= (unsigned int)RWIDTH;
}

static int
range_unsigned_outside(x)
int x;
{
	return (unsigned int)(x - RLOW) > (unsigned int)RWIDTH;
}

static int
range_unsigned_inside_zero(x)
int x;
{
	return (unsigned int)x <= (unsigned int)RHIGH;
}

static int
range_unsigned_outside_zero(x)
int x;
{
	return (unsigned int)x > (unsigned int)RHIGH;
}

static int
range_unsigned_inside_neg(x)
int x;
{
	return (unsigned int)(x + 7) <= (unsigned int)(RHIGH + 7);
}

static int
range_unsigned_outside_neg(x)
int x;
{
	return (unsigned int)(x + 7) > (unsigned int)(RHIGH + 7);
}

static int
range_branch_inside(x)
int x;
{
	if ((unsigned int)(x - RLOW) <= (unsigned int)RWIDTH)
		return x + 1;
	return x - 1;
}

static int
range_branch_outside(x)
int x;
{
	if ((unsigned int)(x - RLOW) > (unsigned int)RWIDTH)
		return x + 2;
	return x - 2;
}

static int
range_mem_inside(p)
int *p;
{
	int x;

	x = *p;
	if (x >= RLOW && x <= RHIGH)
		return x;
	return 0;
}

static int
range_mem_outside(p)
int *p;
{
	int x;

	x = *p;
	if (x < RLOW || x > RHIGH)
		return 1;
	return 0;
}

static int
range_mem_unsigned(p)
int *p;
{
	int x;

	x = *p;
	return (unsigned int)(x - RLOW) <= (unsigned int)RWIDTH;
}

static int
range_global_inside(void)
{
	return g_int >= RLOW && g_int <= RHIGH;
}

static int
range_global_limits(x)
int x;
{
	if (x < g_low || x > g_high)
		return -1;
	return 1;
}

static int
range_volatile_inside(void)
{
	int x;

	x = vg_int;
	return x >= RLOW && x <= RHIGH;
}

static int
range_sint_inside(x)
Sint x;
{
	return x >= (Sint)RLOW && x <= (Sint)RHIGH;
}

static int
range_sint_mem(p)
Sint *p;
{
	Sint x;

	x = *p;
	return x < (Sint)RLOW || x > (Sint)RHIGH;
}

static int
range_sint_volatile(void)
{
	Sint x;

	x = vgs_int;
	return x >= (Sint)RLOW && x <= (Sint)RHIGH;
}

static int
range_u_compare(x)
unsigned int x;
{
	return x >= (unsigned int)RLOW && x <= (unsigned int)RHIGH;
}

static int
range_u_outside(x)
unsigned int x;
{
	return x < (unsigned int)RLOW || x > (unsigned int)RHIGH;
}

static int
range_qi_promote(x)
Qint x;
{
	return x >= (Qint)3 && x <= (Qint)17;
}

static int
range_hi_promote(x)
Hint x;
{
	return x < (Hint)-20 || x > (Hint)20;
}

static int
range_select(x, a, b)
int x;
int a;
int b;
{
	if ((unsigned int)(x - RLOW) <= (unsigned int)RWIDTH)
		return a;
	return b;
}

static void
range_call_arg(x)
int x;
{
	use_int((unsigned int)(x - RLOW) <= (unsigned int)RWIDTH);
}

static int
range_store_flag(out, x)
int *out;
int x;
{
	*out = x < RLOW || x > RHIGH;
	return *out;
}

static int
range_mixed_arith(x)
int x;
{
	int y;

	y = x + 3;
	if ((unsigned int)(y - RLOW) <= (unsigned int)RWIDTH)
		return y + 5;
	return y - 5;
}

static int
range_large_literal(x)
int x;
{
	if ((unsigned int)(x - 0400000) <= (unsigned int)077)
		return 1;
	return 0;
}

int
use_range_check(x, p)
int x;
int *p;
{
	int r;

	r = 0;
	r += range_or_value_small(x);
	r += range_or_value_zero(x);
	r += range_or_value_neg(x);
	r += range_or_value_large(x);
	r += range_and_value_small(x);
	r += range_and_value_zero(x);
	r += range_and_value_neg(x);
	r += range_and_value_large(x);
	r += range_inside_closed(x);
	r += range_outside_closed(x);
	r += range_inside_open(x);
	r += range_outside_open(x);
	r += range_unsigned_inside(x);
	r += range_unsigned_outside(x);
	r += range_unsigned_inside_zero(x);
	r += range_unsigned_outside_zero(x);
	r += range_unsigned_inside_neg(x);
	r += range_unsigned_outside_neg(x);
	r += range_branch_inside(x);
	r += range_branch_outside(x);
	r += range_mem_inside(p);
	r += range_mem_outside(p);
	r += range_mem_unsigned(p);
	r += range_global_inside();
	r += range_global_limits(x);
	r += range_volatile_inside();
	r += range_sint_inside((Sint)x);
	r += range_sint_mem(&gs_int);
	r += range_sint_volatile();
	r += range_u_compare((unsigned int)x);
	r += range_u_outside((unsigned int)x);
	r += range_qi_promote((Qint)x);
	r += range_hi_promote((Hint)x);
	r += range_select(x, 11, 22);
	r += range_store_flag(p, x);
	r += range_mixed_arith(x);
	r += range_large_literal(x);
	range_call_arg(x);
	return r;
}
