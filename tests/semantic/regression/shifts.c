#include "insns.h"

/*
 * Shift, power-of-two multiply/divide, and power-of-two modulo coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * This file intentionally keeps full non-power-of-two DImode division and
 * modulo out of scope.  Those belong in the libgcc fallback tests.  Here we
 * want the inline shift/bias/mask forms that the backend may use for powers
 * of two, especially signed Dint division/modulo where negative values must
 * still follow C truncation-toward-zero semantics.
 */

static Sint gs = (Sint)-12345;
static uSint gus = (uSint)-1;
static Dint gd = (Dint)-1234567;
static uDint gud = (uDint)-1;
static volatile Sint vgs = (Sint)-77;
static volatile uSint vgus = (uSint)0777777;
static volatile Dint vgd = (Dint)-777777;
static volatile uDint vgud = (uDint)-1;

struct shift_s_slot {
	Sint a;
	uSint ua;
	int n;
};

struct shift_d_slot {
	Dint a;
	uDint ua;
	int n;
};

static struct shift_s_slot gs_slot = { (Sint)-99, (uSint)0777777, 3 };
static struct shift_d_slot gd_slot = { (Dint)-99999, (uDint)-1, 5 };

#define TEST(T, NAME, OP) \
static T \
NAME(x) \
T x; \
{ \
	return (OP); \
}

#define TEST2(T, SNAME, UNAME, SOP, UOP) \
TEST(T, SNAME, SOP) \
TEST(u##T, UNAME, UOP)

/* Single-word constant shifts and multiply-by-power-of-two. */
TEST2(Sint, ashl1,  lshl1,  x << 1, x << 1)
TEST2(Sint, ashl2,  lshl2,  x << 2, x << 2)
TEST2(Sint, ashl3,  lshl3,  x << 3, x << 3)
TEST2(Sint, ashl4,  lshl4,  x << 4, x << 4)
TEST2(Sint, ashl8,  lshl8,  x << 8, x << 8)
TEST2(Sint, ashl18, lshl18, x << 18, x << 18)
TEST2(Sint, smul2,  umul2,  x * 2, x * 2)
TEST2(Sint, smul4,  umul4,  x * 4, x * 4)
TEST2(Sint, smul8,  umul8,  x * 8, x * 8)

/* Single-word right shifts. */
TEST2(Sint, ashr1,  lshr1,  x >> 1, x >> 1)
TEST2(Sint, ashr2,  lshr2,  x >> 2, x >> 2)
TEST2(Sint, ashr3,  lshr3,  x >> 3, x >> 3)
TEST2(Sint, ashr4,  lshr4,  x >> 4, x >> 4)
TEST2(Sint, ashr8,  lshr8,  x >> 8, x >> 8)
TEST2(Sint, ashr18, lshr18, x >> 18, x >> 18)
TEST2(Sint, ashr35, lshr35, x >> 35, x >> 35)

/* Single-word power-of-two division.  Signed cases need bias for negatives. */
TEST2(Sint, sdiv2,  udiv2,  x / 2, x / 2)
TEST2(Sint, sdiv4,  udiv4,  x / 4, x / 4)
TEST2(Sint, sdiv8,  udiv8,  x / 8, x / 8)
TEST2(Sint, sdiv16, udiv16, x / 16, x / 16)

/* Single-word power-of-two modulo.  Signed cases must keep C remainder sign. */
TEST2(Sint, smod2,  umod2,  x % 2, x % 2)
TEST2(Sint, smod4,  umod4,  x % 4, x % 4)
TEST2(Sint, smod8,  umod8,  x % 8, x % 8)
TEST2(Sint, smod16, umod16, x % 16, x % 16)

/* Double-word constant shifts and multiply-by-power-of-two. */
TEST2(Dint, dashl1,  dlshl1,  x << 1, x << 1)
TEST2(Dint, dashl2,  dlshl2,  x << 2, x << 2)
TEST2(Dint, dashl3,  dlshl3,  x << 3, x << 3)
TEST2(Dint, dashl4,  dlshl4,  x << 4, x << 4)
TEST2(Dint, dashl8,  dlshl8,  x << 8, x << 8)
TEST2(Dint, dashl18, dlshl18, x << 18, x << 18)
TEST2(Dint, dashl35, dlshl35, x << 35, x << 35)
TEST2(Dint, dashl36, dlshl36, x << 36, x << 36)
TEST2(Dint, dsmul2,  dumul2,  x * 2, x * 2)
TEST2(Dint, dsmul4,  dumul4,  x * 4, x * 4)
TEST2(Dint, dsmul8,  dumul8,  x * 8, x * 8)

/* Double-word right shifts, including cross-word boundaries. */
TEST2(Dint, dashr1,  dlshr1,  x >> 1, x >> 1)
TEST2(Dint, dashr2,  dlshr2,  x >> 2, x >> 2)
TEST2(Dint, dashr3,  dlshr3,  x >> 3, x >> 3)
TEST2(Dint, dashr4,  dlshr4,  x >> 4, x >> 4)
TEST2(Dint, dashr8,  dlshr8,  x >> 8, x >> 8)
TEST2(Dint, dashr18, dlshr18, x >> 18, x >> 18)
TEST2(Dint, dashr35, dlshr35, x >> 35, x >> 35)
TEST2(Dint, dashr36, dlshr36, x >> 36, x >> 36)
TEST2(Dint, dashr37, dlshr37, x >> 37, x >> 37)
TEST2(Dint, dashr63, dlshr63, x >> 63, x >> 63)
TEST2(Dint, dashr70, dlshr70, x >> 70, x >> 70)

/* Double-word power-of-two division. */
TEST2(Dint, dsdiv2,  dudiv2,  x / 2, x / 2)
TEST2(Dint, dsdiv4,  dudiv4,  x / 4, x / 4)
TEST2(Dint, dsdiv8,  dudiv8,  x / 8, x / 8)
TEST2(Dint, dsdiv16, dudiv16, x / 16, x / 16)
TEST2(Dint, dsdiv32, dudiv32, x / 32, x / 32)
TEST2(Dint, dsdiv64, dudiv64, x / 64, x / 64)

/* Double-word power-of-two modulo. */
TEST2(Dint, dsmod2,  dumod2,  x % 2, x % 2)
TEST2(Dint, dsmod4,  dumod4,  x % 4, x % 4)
TEST2(Dint, dsmod8,  dumod8,  x % 8, x % 8)
TEST2(Dint, dsmod16, dumod16, x % 16, x % 16)
TEST2(Dint, dsmod32, dumod32, x % 32, x % 32)
TEST2(Dint, dsmod64, dumod64, x % 64, x % 64)

static Sint
sashl_var(x, n)
Sint x;
int n;
{
	return x << n;
}

static uSint
ulshl_var(x, n)
uSint x;
int n;
{
	return x << n;
}

static Sint
sashr_var(x, n)
Sint x;
int n;
{
	return x >> n;
}

static uSint
ulshr_var(x, n)
uSint x;
int n;
{
	return x >> n;
}

static Dint
dashl_var(x, n)
Dint x;
int n;
{
	return x << n;
}

static uDint
dlshl_var(x, n)
uDint x;
int n;
{
	return x << n;
}

static Dint
dashr_var(x, n)
Dint x;
int n;
{
	return x >> n;
}

static uDint
dlshr_var(x, n)
uDint x;
int n;
{
	return x >> n;
}

static Sint
sdiv_pow2_neg_bias(x, n)
Sint x;
int n;
{
	Sint q;

	q = x / 2;
	if (n & 1)
		q += x / 4;
	else
		q += x / 8;
	return q;
}

static Dint
div_pow2_neg_bias(x, n)
Dint x;
int n;
{
	Dint q;

	q = x / (Dint)2;
	if (n & 1)
		q += x / (Dint)4;
	else
		q += x / (Dint)8;
	return q;
}

static Sint
smod_pow2_neg(x, n)
Sint x;
int n;
{
	Sint r;

	r = x % 2;
	if (n & 1)
		r += x % 4;
	else
		r += x % 8;
	return r;
}

static Dint
dmod_pow2_neg(x, n)
Dint x;
int n;
{
	Dint r;

	r = x % (Dint)2;
	if (n & 1)
		r += x % (Dint)4;
	else
		r += x % (Dint)8;
	return r;
}

static Sint
shift_s_mem(p, n)
Sint *p;
int n;
{
	Sint x;

	x = *p;
	*p = (x << 1) + (x >> 1) + (x / 4) + (x % 8) + (x << n);
	return *p;
}

static uSint
shift_us_mem(p, n)
uSint *p;
int n;
{
	uSint x;

	x = *p;
	*p = (x << 1) + (x >> 1) + (x / 4) + (x % 8) + (x >> n);
	return *p;
}

static Dint
shift_d_mem(p, n)
Dint *p;
int n;
{
	Dint x;

	x = *p;
	*p = (x << 1) + (x >> 1) + (x / (Dint)4) + (x % (Dint)8)
	    + (x << n);
	return *p;
}

static uDint
shift_ud_mem(p, n)
uDint *p;
int n;
{
	uDint x;

	x = *p;
	*p = (x << 1) + (x >> 1) + (x / (uDint)4) + (x % (uDint)8)
	    + (x >> n);
	return *p;
}

static Sint
shift_s_struct(p)
struct shift_s_slot *p;
{
	p->a = (p->a << 1) + (p->a >> 2) + (p->a / 8) + (p->a % 4);
	p->ua = (p->ua << 2) + (p->ua >> 3) + (p->ua / 8) + (p->ua % 4);
	return p->a + (Sint)p->ua;
}

static Dint
shift_d_struct(p)
struct shift_d_slot *p;
{
	p->a = (p->a << 1) + (p->a >> 2) + (p->a / (Dint)8)
	    + (p->a % (Dint)4);
	p->ua = (p->ua << 2) + (p->ua >> 3) + (p->ua / (uDint)8)
	    + (p->ua % (uDint)4);
	return p->a + (Dint)p->ua;
}

static int
shift_branch_s(x)
Sint x;
{
	Sint q;
	Sint r;

	q = x / 8;
	r = x % 8;
	if (q < (Sint)0)
		return -1;
	if (r == (Sint)0)
		return 0;
	return 1;
}

static int
shift_branch_d(x)
Dint x;
{
	Dint q;
	Dint r;

	q = x / (Dint)8;
	r = x % (Dint)8;
	if (q < (Dint)0)
		return -1;
	if (r == (Dint)0)
		return 0;
	return 1;
}

static Dint
shift_call_arg(x)
Dint x;
{
	extern void use_dint(Dint);
	Dint y;

	y = (x << 1) + (x >> 1) + (x / (Dint)4) + (x % (Dint)8);
	use_dint(y);
	return y;
}

Dint
use_shifts(s, us, d, ud, n)
Sint s;
uSint us;
Dint d;
uDint ud;
int n;
{
	Sint ls;
	uSint lus;
	Dint ld;
	uDint lud;

	ls = gs + vgs + s;
	lus = gus + vgus + us;
	ld = gd + vgd + d;
	lud = gud + vgud + ud;

	gs = shift_s_mem(&ls, n);
	gus = shift_us_mem(&lus, n);
	gd = shift_d_mem(&ld, n);
	gud = shift_ud_mem(&lud, n);

	return (Dint)ashl1(ls)
	    + (Dint)ashl18(ls)
	    + (Dint)lshl18(lus)
	    + (Dint)ashr35(ls)
	    + (Dint)lshr35(lus)
	    + (Dint)sdiv2(ls)
	    + (Dint)sdiv8(ls)
	    + (Dint)udiv8(lus)
	    + (Dint)smod8(ls)
	    + (Dint)umod8(lus)
	    + dashl36(ld)
	    + dlshl36(lud)
	    + dashr70(ld)
	    + dlshr70(lud)
	    + dsdiv2(ld)
	    + dsdiv8(ld)
	    + dudiv8(lud)
	    + dsmod8(ld)
	    + dumod8(lud)
	    + (Dint)sashl_var(ls, n)
	    + (Dint)ulshr_var(lus, n)
	    + dashl_var(ld, n)
	    + dlshr_var(lud, n)
	    + (Dint)sdiv_pow2_neg_bias(ls, n)
	    + div_pow2_neg_bias(ld, n)
	    + (Dint)smod_pow2_neg(ls, n)
	    + dmod_pow2_neg(ld, n)
	    + (Dint)shift_s_struct(&gs_slot)
	    + shift_d_struct(&gd_slot)
	    + (Dint)shift_branch_s(ls)
	    + (Dint)shift_branch_d(ld)
	    + shift_call_arg(ld);
}
