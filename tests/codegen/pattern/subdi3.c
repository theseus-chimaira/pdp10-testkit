#include "insns.h"

/*
 * DImode subtraction pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on binary subtraction of double-word integers.
 * Unary negation belongs in negdi2.c; addition belongs in adddi3.c;
 * helper-fallback division and modulo live under misc/libgcc-*.c.
 *
 * Do not add inline assembly here.
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint gs_a = (Dint)1234567;
static Dint gs_b = (Dint)-7654321;
static Dint gs_c;
static volatile Dint vgs_a = (Dint)76543;
static volatile Dint vgs_b = (Dint)-37;
static volatile Dint vgs_c;

static uDint gus_a = (uDint)0123456701234;
static uDint gus_b = (uDint)0777777;
static uDint gus_c;
static volatile uDint vgus_a = (uDint)-1;
static volatile uDint vgus_b = (uDint)012345;
static volatile uDint vgus_c;

struct subdi3_pair {
	Dint a;
	Dint b;
	Dint c;
};

struct subdi3_upair {
	uDint a;
	uDint b;
	uDint c;
};

static struct subdi3_pair gs_pair = {
	(Dint)12345,
	(Dint)-37,
	(Dint)0
};

static struct subdi3_upair gus_pair = {
	(uDint)01234567,
	(uDint)0777,
	(uDint)0
};

static Dint gs_arr[4] = {
	(Dint)0,
	(Dint)1,
	(Dint)-1,
	(Dint)0123456701234
};

static uDint gus_arr[4] = {
	(uDint)0,
	(uDint)1,
	(uDint)-1,
	(uDint)0123456701234
};

static Dint
subdi_reg(a, b)
Dint a;
Dint b;
{
	return a - b;
}

static Dint
subdi_mem_left(ap, b)
Dint *ap;
Dint b;
{
	return *ap - b;
}

static Dint
subdi_mem_right(a, bp)
Dint a;
Dint *bp;
{
	return a - *bp;
}

static Dint
subdi_mem_mem(ap, bp)
Dint *ap;
Dint *bp;
{
	Dint a;
	Dint b;

	a = *ap;
	b = *bp;
	return a - b;
}

static Dint
subdi_global(void)
{
	return gs_a - gs_b;
}

static Dint
subdi_volatile(void)
{
	Dint a;
	Dint b;

	a = vgs_a;
	b = vgs_b;
	return a - b;
}

static Dint
subdi_const_zero(a)
Dint a;
{
	return a - (Dint)0;
}

static Dint
subdi_const_one(a)
Dint a;
{
	return a - (Dint)1;
}

static Dint
subdi_const_minus_one(a)
Dint a;
{
	return a - (Dint)-1;
}

static Dint
subdi_zero_left(a)
Dint a;
{
	return (Dint)0 - a;
}

static Dint
subdi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
	Dint r;

	r = a - b;
	*out = r;
	return r;
}

static Dint
subdi_store_mem(out, ap, bp)
Dint *out;
Dint *ap;
Dint *bp;
{
	*out = *ap - *bp;
	return *out;
}

static Dint
subdi_update_reg(p, a)
Dint *p;
Dint a;
{
	*p = *p - a;
	return *p;
}

static Dint
subdi_update_const(p)
Dint *p;
{
	*p = *p - (Dint)1;
	return *p;
}

static Dint
subdi_struct(p)
struct subdi3_pair *p;
{
	return p->a - p->b;
}

static Dint
subdi_struct_store(p)
struct subdi3_pair *p;
{
	p->c = p->a - p->b;
	return p->c;
}

static Dint
subdi_array(a, i)
Dint *a;
int i;
{
	return a[i] - a[i + 1];
}

static void
subdi_array_store(a, i)
Dint *a;
int i;
{
	a[i] = a[i] - a[i + 1];
}

static int
subdi_branch(a, b)
Dint a;
Dint b;
{
	Dint r;

	r = a - b;
	if (r < (Dint)0)
		return -1;
	if (r == (Dint)0)
		return 0;
	return 1;
}

static Dint
subdi_call_arg(a, b)
Dint a;
Dint b;
{
	Dint r;

	r = a - b;
	sink_dint(r);
	return r;
}

static uDint
usubdi_reg(a, b)
uDint a;
uDint b;
{
	return a - b;
}

static uDint
usubdi_mem_left(ap, b)
uDint *ap;
uDint b;
{
	return *ap - b;
}

static uDint
usubdi_mem_right(a, bp)
uDint a;
uDint *bp;
{
	return a - *bp;
}

static uDint
usubdi_mem_mem(ap, bp)
uDint *ap;
uDint *bp;
{
	uDint a;
	uDint b;

	a = *ap;
	b = *bp;
	return a - b;
}

static uDint
usubdi_global(void)
{
	return gus_a - gus_b;
}

static uDint
usubdi_volatile(void)
{
	uDint a;
	uDint b;

	a = vgus_a;
	b = vgus_b;
	return a - b;
}

static uDint
usubdi_const_zero(a)
uDint a;
{
	return a - (uDint)0;
}

static uDint
usubdi_const_one(a)
uDint a;
{
	return a - (uDint)1;
}

static uDint
usubdi_const_minus_one(a)
uDint a;
{
	return a - (uDint)-1;
}

static uDint
usubdi_zero_left(a)
uDint a;
{
	return (uDint)0 - a;
}

static uDint
usubdi_store(out, a, b)
uDint *out;
uDint a;
uDint b;
{
	uDint r;

	r = a - b;
	*out = r;
	return r;
}

static uDint
usubdi_store_mem(out, ap, bp)
uDint *out;
uDint *ap;
uDint *bp;
{
	*out = *ap - *bp;
	return *out;
}

static uDint
usubdi_update_reg(p, a)
uDint *p;
uDint a;
{
	*p = *p - a;
	return *p;
}

static uDint
usubdi_update_const(p)
uDint *p;
{
	*p = *p - (uDint)1;
	return *p;
}

static uDint
usubdi_struct(p)
struct subdi3_upair *p;
{
	return p->a - p->b;
}

static uDint
usubdi_struct_store(p)
struct subdi3_upair *p;
{
	p->c = p->a - p->b;
	return p->c;
}

static uDint
usubdi_array(a, i)
uDint *a;
int i;
{
	return a[i] - a[i + 1];
}

static void
usubdi_array_store(a, i)
uDint *a;
int i;
{
	a[i] = a[i] - a[i + 1];
}

static int
usubdi_branch(a, b)
uDint a;
uDint b;
{
	uDint r;

	r = a - b;
	if (r == (uDint)0)
		return 0;
	return 1;
}

static uDint
usubdi_call_arg(a, b)
uDint a;
uDint b;
{
	uDint r;

	r = a - b;
	sink_udint(r);
	return r;
}

Dint
use_subdi3(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint local[3];
	Dint r;

	local[0] = a;
	local[1] = b;
	local[2] = (Dint)13;

	r = subdi_reg(a, b); sink_dint(r);
	r = subdi_mem_left(&local[0], b); sink_dint(r);
	r = subdi_mem_right(a, &local[1]); sink_dint(r);
	r = subdi_mem_mem(&local[0], &local[1]); sink_dint(r);
	r = subdi_global(); sink_dint(r);
	r = subdi_volatile(); sink_dint(r);
	r = subdi_const_zero(a); sink_dint(r);
	r = subdi_const_one(a); sink_dint(r);
	r = subdi_const_minus_one(a); sink_dint(r);
	r = subdi_zero_left(a); sink_dint(r);
	r = subdi_store(&gs_c, a, b); sink_dint(r);
	r = subdi_store_mem(&local[2], &local[0], &local[1]); sink_dint(r);
	r = subdi_update_reg(&local[0], b); sink_dint(r);
	r = subdi_update_const(&local[1]); sink_dint(r);
	r = subdi_struct(&gs_pair); sink_dint(r);
	r = subdi_struct_store(&gs_pair); sink_dint(r);
	vgs_c = subdi_volatile();
	subdi_array_store(local, i & 1);
	r = subdi_array(gs_arr, i & 1); sink_dint(r);
	sink_dint((Dint)subdi_branch(a, b));
	r = subdi_call_arg(a, b);
	return r;
}

uDint
use_usubdi3(a, b, i)
uDint a;
uDint b;
int i;
{
	uDint local[3];
	uDint r;

	local[0] = a;
	local[1] = b;
	local[2] = (uDint)13;

	r = usubdi_reg(a, b); sink_udint(r);
	r = usubdi_mem_left(&local[0], b); sink_udint(r);
	r = usubdi_mem_right(a, &local[1]); sink_udint(r);
	r = usubdi_mem_mem(&local[0], &local[1]); sink_udint(r);
	r = usubdi_global(); sink_udint(r);
	r = usubdi_volatile(); sink_udint(r);
	r = usubdi_const_zero(a); sink_udint(r);
	r = usubdi_const_one(a); sink_udint(r);
	r = usubdi_const_minus_one(a); sink_udint(r);
	r = usubdi_zero_left(a); sink_udint(r);
	r = usubdi_store(&gus_c, a, b); sink_udint(r);
	r = usubdi_store_mem(&local[2], &local[0], &local[1]); sink_udint(r);
	r = usubdi_update_reg(&local[0], b); sink_udint(r);
	r = usubdi_update_const(&local[1]); sink_udint(r);
	r = usubdi_struct(&gus_pair); sink_udint(r);
	r = usubdi_struct_store(&gus_pair); sink_udint(r);
	vgus_c = usubdi_volatile();
	usubdi_array_store(local, i & 1);
	r = usubdi_array(gus_arr, i & 1); sink_udint(r);
	sink_udint((uDint)usubdi_branch(a, b));
	r = usubdi_call_arg(a, b);
	return r;
}
