#include "insns.h"

/*
 * DImode one's-complement pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on unary bitwise complement of double-word
 * integers.  Ordinary logical binary operations belong in anddi3.c,
 * iordi3.c, and xordi3.c.  Arithmetic negation belongs in negdi2.c.
 *
 * Do not add inline assembly here.
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint gc_a = (Dint)0123456701234;
static Dint gc_b;
static volatile Dint vgc_a = (Dint)-0765432107654;
static volatile Dint vgc_b;

static uDint guc_a = (uDint)0123456701234;
static uDint guc_b;
static volatile uDint vguc_a = (uDint)-1;
static volatile uDint vguc_b;

struct one_cmpldi2_pair {
	Dint a;
	Dint b;
};

struct one_cmpldi2_upair {
	uDint a;
	uDint b;
};

static struct one_cmpldi2_pair gc_pair = {
	(Dint)01234567,
	(Dint)-07654321
};

static struct one_cmpldi2_upair guc_pair = {
	(uDint)0777777,
	(uDint)-1
};

static Dint gc_arr[4] = {
	(Dint)0,
	(Dint)1,
	(Dint)-1,
	(Dint)0123456701234
};

static uDint guc_arr[4] = {
	(uDint)0,
	(uDint)1,
	(uDint)-1,
	(uDint)0123456701234
};

static Dint
onecmpldi_reg(a)
Dint a;
{
	return ~a;
}

static uDint
uonecmpldi_reg(a)
uDint a;
{
	return ~a;
}

static Dint
onecmpldi_mem(p)
Dint *p;
{
	return ~*p;
}

static uDint
uonecmpldi_mem(p)
uDint *p;
{
	return ~*p;
}

static Dint
onecmpldi_global(void)
{
	return ~gc_a;
}

static uDint
uonecmpldi_global(void)
{
	return ~guc_a;
}

static Dint
onecmpldi_volatile(void)
{
	Dint a;

	a = vgc_a;
	return ~a;
}

static uDint
uonecmpldi_volatile(void)
{
	uDint a;

	a = vguc_a;
	return ~a;
}

static Dint
onecmpldi_const_zero(void)
{
	return ~(Dint)0;
}

static Dint
onecmpldi_const_one(void)
{
	return ~(Dint)1;
}

static Dint
onecmpldi_const_minus_one(void)
{
	return ~(Dint)-1;
}

static Dint
onecmpldi_store(out, a)
Dint *out;
Dint a;
{
	Dint r;

	r = ~a;
	*out = r;
	return r;
}

static uDint
uonecmpldi_store(out, a)
uDint *out;
uDint a;
{
	uDint r;

	r = ~a;
	*out = r;
	return r;
}

static Dint
onecmpldi_store_mem(out, in)
Dint *out;
Dint *in;
{
	*out = ~*in;
	return *out;
}

static uDint
uonecmpldi_store_mem(out, in)
uDint *out;
uDint *in;
{
	*out = ~*in;
	return *out;
}

static Dint
onecmpldi_update(p)
Dint *p;
{
	*p = ~*p;
	return *p;
}

static uDint
uonecmpldi_update(p)
uDint *p;
{
	*p = ~*p;
	return *p;
}

static void
onecmpldi_update_void(p)
Dint *p;
{
	*p = ~*p;
}

static void
uonecmpldi_update_void(p)
uDint *p;
{
	*p = ~*p;
}

static Dint
onecmpldi_struct(p)
struct one_cmpldi2_pair *p;
{
	return ~p->a;
}

static uDint
uonecmpldi_struct(p)
struct one_cmpldi2_upair *p;
{
	return ~p->a;
}

static Dint
onecmpldi_struct_store(p)
struct one_cmpldi2_pair *p;
{
	p->b = ~p->a;
	return p->b;
}

static uDint
uonecmpldi_struct_store(p)
struct one_cmpldi2_upair *p;
{
	p->b = ~p->a;
	return p->b;
}

static Dint
onecmpldi_array(a, i)
Dint *a;
int i;
{
	return ~a[i];
}

static uDint
uonecmpldi_array(a, i)
uDint *a;
int i;
{
	return ~a[i];
}

static void
onecmpldi_array_store(a, i)
Dint *a;
int i;
{
	a[i] = ~a[i + 1];
}

static void
uonecmpldi_array_store(a, i)
uDint *a;
int i;
{
	a[i] = ~a[i + 1];
}

static Dint
onecmpldi_call_arg(a)
Dint a;
{
	Dint r;

	r = ~a;
	sink_dint(r);
	return r;
}

static uDint
uonecmpldi_call_arg(a)
uDint a;
{
	uDint r;

	r = ~a;
	sink_udint(r);
	return r;
}

static Dint
onecmpldi_double_mem(ap, bp)
Dint *ap;
Dint *bp;
{
	Dint a;
	Dint b;

	a = ~*ap;
	b = ~*bp;
	sink_dint(a);
	return b;
}

static uDint
uonecmpldi_double_mem(ap, bp)
uDint *ap;
uDint *bp;
{
	uDint a;
	uDint b;

	a = ~*ap;
	b = ~*bp;
	sink_udint(a);
	return b;
}

Dint
use_one_cmpldi2(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint local[3];
	Dint r;

	local[0] = a;
	local[1] = b;
	local[2] = (Dint)-13;

	r = onecmpldi_reg(a);
	sink_dint(r);
	r = onecmpldi_mem(&local[0]);
	sink_dint(r);
	r = onecmpldi_global();
	sink_dint(r);
	r = onecmpldi_volatile();
	vgc_b = r;
	sink_dint(r);
	r = onecmpldi_const_zero();
	sink_dint(r);
	r = onecmpldi_const_one();
	sink_dint(r);
	r = onecmpldi_const_minus_one();
	sink_dint(r);
	r = onecmpldi_store(&gc_b, a);
	sink_dint(r);
	r = onecmpldi_store_mem(&local[2], &local[1]);
	sink_dint(r);
	r = onecmpldi_update(&local[0]);
	sink_dint(r);
	onecmpldi_update_void(&local[1]);
	r = onecmpldi_struct(&gc_pair);
	sink_dint(r);
	r = onecmpldi_struct_store(&gc_pair);
	sink_dint(r);
	onecmpldi_array_store(local, i & 1);
	r = onecmpldi_array(gc_arr, i & 3);
	sink_dint(r);
	r = onecmpldi_call_arg(b);
	sink_dint(r);
	r = onecmpldi_double_mem(&local[0], &local[2]);

	return r;
}

uDint
use_uone_cmpldi2(a, b, i)
uDint a;
uDint b;
int i;
{
	uDint local[3];
	uDint r;

	local[0] = a;
	local[1] = b;
	local[2] = (uDint)-13;

	r = uonecmpldi_reg(a);
	sink_udint(r);
	r = uonecmpldi_mem(&local[0]);
	sink_udint(r);
	r = uonecmpldi_global();
	sink_udint(r);
	r = uonecmpldi_volatile();
	vguc_b = r;
	sink_udint(r);
	r = uonecmpldi_store(&guc_b, a);
	sink_udint(r);
	r = uonecmpldi_store_mem(&local[2], &local[1]);
	sink_udint(r);
	r = uonecmpldi_update(&local[0]);
	sink_udint(r);
	uonecmpldi_update_void(&local[1]);
	r = uonecmpldi_struct(&guc_pair);
	sink_udint(r);
	r = uonecmpldi_struct_store(&guc_pair);
	sink_udint(r);
	uonecmpldi_array_store(local, i & 1);
	r = uonecmpldi_array(guc_arr, i & 3);
	sink_udint(r);
	r = uonecmpldi_call_arg(b);
	sink_udint(r);
	r = uonecmpldi_double_mem(&local[0], &local[2]);

	return r;
}
