#include "insns.h"

/*
 * DImode negation pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on unary negation of double-word integers.
 * Ordinary subtraction belongs in subdi3.c; helper-fallback division
 * and modulo live under misc/libgcc-*.c.
 *
 * Do not add inline assembly here.
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint gn_a = (Dint)1234567;
static Dint gn_b;
static volatile Dint vgn_a = (Dint)-7654321;
static volatile Dint vgn_b;

static uDint gun_a = (uDint)0123456701234;
static uDint gun_b;
static volatile uDint vgun_a = (uDint)-1;
static volatile uDint vgun_b;

struct negdi2_pair {
	Dint a;
	Dint b;
};

struct negdi2_upair {
	uDint a;
	uDint b;
};

static struct negdi2_pair gn_pair = { (Dint)12345, (Dint)-37 };
static struct negdi2_upair gun_pair = { (uDint)0777777, (uDint)-1 };

static Dint gn_arr[4] = {
	(Dint)0,
	(Dint)1,
	(Dint)-1,
	(Dint)0123456701234
};

static uDint gun_arr[4] = {
	(uDint)0,
	(uDint)1,
	(uDint)-1,
	(uDint)0123456701234
};

static Dint
negdi_reg(a)
Dint a;
{
	return -a;
}

static Dint
negdi_zero_sub(a)
Dint a;
{
	return (Dint)0 - a;
}

static Dint
negdi_mem(p)
Dint *p;
{
	return -*p;
}

static Dint
negdi_global(void)
{
	return -gn_a;
}

static Dint
negdi_volatile(void)
{
	Dint a;

	a = vgn_a;
	return -a;
}

static Dint
negdi_const_zero(void)
{
	return -(Dint)0;
}

static Dint
negdi_const_one(void)
{
	return -(Dint)1;
}

static Dint
negdi_const_minus_one(void)
{
	return -(Dint)-1;
}

static Dint
negdi_store(out, a)
Dint *out;
Dint a;
{
	Dint r;

	r = -a;
	*out = r;
	return r;
}

static Dint
negdi_store_mem(out, in)
Dint *out;
Dint *in;
{
	*out = -*in;
	return *out;
}

static Dint
negdi_update(p)
Dint *p;
{
	*p = -*p;
	return *p;
}

static Dint
negdi_struct(p)
struct negdi2_pair *p;
{
	return -p->a;
}

static Dint
negdi_struct_store(p)
struct negdi2_pair *p;
{
	p->b = -p->a;
	return p->b;
}

static Dint
negdi_array(a, i)
Dint *a;
int i;
{
	return -a[i];
}

static void
negdi_array_store(a, i)
Dint *a;
int i;
{
	a[i] = -a[i + 1];
}

static int
negdi_branch(a)
Dint a;
{
	Dint r;

	r = -a;
	if (r < (Dint)0)
		return -1;
	if (r == (Dint)0)
		return 0;
	return 1;
}

static Dint
negdi_call_arg(a)
Dint a;
{
	Dint r;

	r = -a;
	sink_dint(r);
	return r;
}

static Dint
negdi_mix(a, b)
Dint a;
Dint b;
{
	Dint r1;
	Dint r2;

	r1 = -a;
	r2 = -b;
	return r1 + r2;
}

static uDint
unegdi_reg(a)
uDint a;
{
	return -a;
}

static uDint
unegdi_zero_sub(a)
uDint a;
{
	return (uDint)0 - a;
}

static uDint
unegdi_mem(p)
uDint *p;
{
	return -*p;
}

static uDint
unegdi_global(void)
{
	return -gun_a;
}

static uDint
unegdi_volatile(void)
{
	uDint a;

	a = vgun_a;
	return -a;
}

static uDint
unegdi_store(out, a)
uDint *out;
uDint a;
{
	uDint r;

	r = -a;
	*out = r;
	return r;
}

static uDint
unegdi_update(p)
uDint *p;
{
	*p = -*p;
	return *p;
}

static uDint
unegdi_struct(p)
struct negdi2_upair *p;
{
	return -p->a;
}

static uDint
unegdi_struct_store(p)
struct negdi2_upair *p;
{
	p->b = -p->a;
	return p->b;
}

static uDint
unegdi_array(a, i)
uDint *a;
int i;
{
	return -a[i];
}

static void
unegdi_array_store(a, i)
uDint *a;
int i;
{
	a[i] = -a[i + 1];
}

static uDint
unegdi_call_arg(a)
uDint a;
{
	uDint r;

	r = -a;
	sink_udint(r);
	return r;
}

Dint
use_negdi2(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint local[3];

	local[0] = a;
	local[1] = b;
	local[2] = (Dint)-13;
	gn_b = negdi_store(&gn_b, a);
	vgn_b = negdi_volatile();
	negdi_array_store(local, i & 1);
	return negdi_reg(a)
	    + negdi_zero_sub(b)
	    + negdi_mem(&local[0])
	    + negdi_global()
	    + vgn_b
	    + negdi_const_zero()
	    + negdi_const_one()
	    + negdi_const_minus_one()
	    + negdi_store_mem(&local[2], &local[1])
	    + negdi_update(&local[0])
	    + negdi_struct(&gn_pair)
	    + negdi_struct_store(&gn_pair)
	    + negdi_array(gn_arr, i & 3)
	    + (Dint)negdi_branch(a)
	    + negdi_call_arg(b)
	    + negdi_mix(a, b);
}

uDint
use_unegdi2(a, b, i)
uDint a;
uDint b;
int i;
{
	uDint local[3];

	local[0] = a;
	local[1] = b;
	local[2] = (uDint)-13;
	gun_b = unegdi_store(&gun_b, a);
	vgun_b = unegdi_volatile();
	unegdi_array_store(local, i & 1);
	return unegdi_reg(a)
	    + unegdi_zero_sub(b)
	    + unegdi_mem(&local[0])
	    + unegdi_global()
	    + vgun_b
	    + unegdi_update(&local[0])
	    + unegdi_struct(&gun_pair)
	    + unegdi_struct_store(&gun_pair)
	    + unegdi_array(gun_arr, i & 3)
	    + unegdi_call_arg(b);
}
