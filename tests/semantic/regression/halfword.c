#include "insns.h"

/*
 * Halfword data and expression coverage.
 *
 * This is the misc companion to the individual HLL/HLR/HRL/HRR family
 * instruction tests.  It uses ordinary C forms that should naturally
 * become halfword extract/deposit, clear, set, swap, and sign-extension
 * sequences on PDP-6/KA10.
 */

#define RH 0000000777777L
#define LH 0777777000000L
#define SGN18 0000000400000L

struct signed_halves {
	Hint l;
	Hint r;
};

struct unsigned_halves {
	uHint l;
	uHint r;
};

struct signed_bits18 {
	int l : 18;
	int r : 18;
};

struct unsigned_bits18 {
	unsigned int l : 18;
	unsigned int r : 18;
};

struct half_mixed {
	Hint h0;
	uHint h1;
	Sint w;
	struct signed_bits18 b;
};

static Hint gh0;
static Hint gh1 = 0123456;
static uHint guh0;
static uHint guh1 = 0654321;
static Sint gw0;
static Sint gw1 = 0123456000001L;
static Sint gw2 = 0765432123456L;
static struct signed_halves gsh = { 0123456, -0123 };
static struct unsigned_halves guh = { 0123456, 0654321 };
static struct signed_bits18 gsb = { -1, 0123456 };
static struct unsigned_bits18 gub = { 0777777, 0123456 };
static struct half_mixed gmix = { -1, 0123456, 0123456000001L, { -2, 0123 } };
static volatile struct signed_halves vgsh;
static volatile struct unsigned_bits18 vgub;

static Hint hvec[8] = { 0, 1, -1, 0123456, -012345, 0377777, -0400000, 0777 };
static uHint uhvec[8] = { 0, 1, 0777777, 0123456, 0654321, 0400000, 0377777, 0777 };
static Sint wvec[6] = { 0, 1, -1, 0123456000001L, 0765432123456L, 0400000000000L };

#define RIGHT(X) ((Sint)((X) & RH))
#define LEFT(X)  ((Sint)((X) & LH))
#define TORIGHT(X) ((Sint)(((uSint)(X) >> 18) & RH))
#define TOLEFT(X) ((Sint)(((X) & RH) << 18))
#define SIGNR(X) ((Sint)(((X) << 18) >> 18))
#define SIGNL(X) ((Sint)((X) >> 18))

#define MK_BIN(NAME, EXPR) \
static Sint NAME(Sint x, Sint y) { return (Sint)(EXPR); } \
static Sint NAME##_mem(Sint *p, Sint y) { Sint x; x = *p; return (Sint)(EXPR); } \
static void NAME##_store(Sint *p, Sint y) { Sint x; x = *p; x = (Sint)(EXPR); *p = x; }

/* Preserve one half of x and insert/select the other half from y. */
MK_BIN(half_hrr_or,  LEFT(x) | RIGHT(y))
MK_BIN(half_hrr_add, LEFT(x) + RIGHT(y))
MK_BIN(half_hll_or,  RIGHT(x) | LEFT(y))
MK_BIN(half_hll_add, RIGHT(x) + LEFT(y))
MK_BIN(half_hrl_or,  RIGHT(x) | TOLEFT(y))
MK_BIN(half_hrl_add, RIGHT(x) + TOLEFT(y))
MK_BIN(half_hlr_or,  LEFT(x) | TORIGHT(y))
MK_BIN(half_hlr_add, LEFT(x) + TORIGHT(y))

/* Zero-fill and one-fill variants. */
MK_BIN(half_hrrz, RIGHT(y))
MK_BIN(half_hllz, LEFT(y))
MK_BIN(half_hrlz, TOLEFT(y))
MK_BIN(half_hlrz, TORIGHT(y))
MK_BIN(half_hrro, LH | RIGHT(y))
MK_BIN(half_hllo, RH | LEFT(y))
MK_BIN(half_hrlo, RH | TOLEFT(y))
MK_BIN(half_hlro, LH | TORIGHT(y))

/* Sign-extension style forms. */
MK_BIN(half_hrre, SIGNR(y))
MK_BIN(half_hlre, SIGNL(y))
MK_BIN(half_signr_masked, SIGNR(y & RH))
MK_BIN(half_signl_masked, SIGNL(y & LH))

static Sint
combine_from_halves(Hint l, Hint r)
{
	return ((Sint)l << 18) | RIGHT((Sint)r);
}

static Sint
combine_from_uhalves(uHint l, uHint r)
{
	return ((Sint)l << 18) | RIGHT((Sint)r);
}

static Sint
replace_right_field(struct signed_halves x, struct signed_halves y)
{
	x.r = y.r;
	return combine_from_halves(x.l, x.r);
}

static Sint
replace_left_field(struct signed_halves x, struct signed_halves y)
{
	x.l = y.l;
	return combine_from_halves(x.l, x.r);
}

static Sint
cross_hrl_field(struct signed_halves x, struct signed_halves y)
{
	x.l = y.r;
	return combine_from_halves(x.l, x.r);
}

static Sint
cross_hlr_field(struct signed_halves x, struct signed_halves y)
{
	x.r = y.l;
	return combine_from_halves(x.l, x.r);
}

static Sint
replace_right_ufield(struct unsigned_halves x, struct unsigned_halves y)
{
	x.r = y.r;
	return combine_from_uhalves(x.l, x.r);
}

static Sint
replace_left_ufield(struct unsigned_halves x, struct unsigned_halves y)
{
	x.l = y.l;
	return combine_from_uhalves(x.l, x.r);
}

static Sint
cross_hrl_ufield(struct unsigned_halves x, struct unsigned_halves y)
{
	x.l = y.r;
	return combine_from_uhalves(x.l, x.r);
}

static Sint
cross_hlr_ufield(struct unsigned_halves x, struct unsigned_halves y)
{
	x.r = y.l;
	return combine_from_uhalves(x.l, x.r);
}

static Sint
bit_right(struct signed_bits18 x, struct signed_bits18 y)
{
	x.r = y.r;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
bit_left(struct signed_bits18 x, struct signed_bits18 y)
{
	x.l = y.l;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
bit_cross_hrl(struct signed_bits18 x, struct signed_bits18 y)
{
	x.l = y.r;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
bit_cross_hlr(struct signed_bits18 x, struct signed_bits18 y)
{
	x.r = y.l;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
ubit_right(struct unsigned_bits18 x, struct unsigned_bits18 y)
{
	x.r = y.r;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
ubit_left(struct unsigned_bits18 x, struct unsigned_bits18 y)
{
	x.l = y.l;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
clear_right_bits(struct unsigned_bits18 x)
{
	x.r = 0;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
clear_left_bits(struct unsigned_bits18 x)
{
	x.l = 0;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
ones_right_bits(struct unsigned_bits18 x)
{
	x.r = 0777777;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
ones_left_bits(struct unsigned_bits18 x)
{
	x.l = 0777777;
	return ((Sint)x.l << 18) | RIGHT((Sint)x.r);
}

static Sint
load_hint_global(void)
{
	return gh0 + gh1 + (Sint)guh0 + (Sint)guh1;
}

static void
store_hint_global(Hint a, uHint b)
{
	gh0 = a;
	guh0 = b;
}

static Sint
load_half_arrays(int i)
{
	return (Sint)hvec[i] + (Sint)uhvec[i]
	    + combine_from_halves(hvec[i & 7], hvec[(i + 1) & 7]);
}

static void
store_half_arrays(int i, Sint x)
{
	hvec[i & 7] = (Hint)x;
	uhvec[(i + 1) & 7] = (uHint)TORIGHT(x);
	wvec[(i + 2) % 6] = LEFT(x) | RIGHT(wvec[i % 6]);
}

static Sint
volatile_half_struct(Sint x)
{
	vgsh.l = (Hint)TORIGHT(x);
	vgsh.r = (Hint)x;
	vgub.l = (unsigned int)TORIGHT(x);
	vgub.r = (unsigned int)x;
	return combine_from_halves(vgsh.l, vgsh.r)
	    + (((Sint)vgub.l << 18) | RIGHT((Sint)vgub.r));
}

static Sint
pointer_half_fields(struct half_mixed *p, Sint x)
{
	p->h0 = (Hint)TORIGHT(x);
	p->h1 = (uHint)x;
	p->w = LEFT(p->w) | RIGHT(x);
	p->b.r = (int)x;
	return p->h0 + (Sint)p->h1 + p->w + p->b.r;
}

static Sint
select_half(int n, Sint x, Sint y)
{
	if (n < 0)
		return LEFT(x) | RIGHT(y);
	if (n == 0)
		return RIGHT(x) | LEFT(y);
	if (n == 1)
		return TOLEFT(y) | RIGHT(x);
	return TORIGHT(y) | LEFT(x);
}

static Sint
compare_half(Sint x, Sint y)
{
	Sint a;
	Sint b;

	a = RIGHT(x);
	b = RIGHT(y);
	if (a == b)
		return SIGNL(x);
	if (a < b)
		return SIGNR(y);
	return TORIGHT(x) - TORIGHT(y);
}

static Sint
use_halfword(int i, Sint x, Sint y)
{
	struct signed_halves sh;
	struct unsigned_halves uh;
	struct signed_bits18 sb;
	struct unsigned_bits18 ub;

	sh = gsh;
	uh = guh;
	sb = gsb;
	ub = gub;

	store_hint_global((Hint)x, (uHint)y);
	store_half_arrays(i, x);

	return half_hrr_or(x, y)
	    + half_hll_or(x, y)
	    + half_hrl_or(x, y)
	    + half_hlr_or(x, y)
	    + half_hrrz(x, y)
	    + half_hllz(x, y)
	    + half_hrre(x, y)
	    + half_hlre(x, y)
	    + replace_right_field(sh, gsh)
	    + replace_left_ufield(uh, guh)
	    + bit_right(sb, gsb)
	    + ubit_left(ub, gub)
	    + load_hint_global()
	    + load_half_arrays(i)
	    + volatile_half_struct(x)
	    + pointer_half_fields(&gmix, y)
	    + select_half(i, x, y)
	    + compare_half(x, y)
	    + gw0 + gw1 + gw2;
}
