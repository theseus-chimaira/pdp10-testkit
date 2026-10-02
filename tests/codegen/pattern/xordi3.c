#include "insns.h"

/*
 * DImode bitwise XOR pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on binary exclusive-or of double-word
 * integers.  Other logical operations belong in anddi3.c, iordi3.c,
 * and one_cmpldi2.c.
 *
 * Do not add inline assembly here.
 */

extern void sink_dint(Dint);
extern void sink_udint(uDint);

static Dint gx_a = (Dint)0123456701234;
static Dint gx_b = (Dint)-0765432107654;
static Dint gx_c;
static volatile Dint vgx_a = (Dint)07654321;
static volatile Dint vgx_b = (Dint)-01234567;
static volatile Dint vgx_c;

static uDint gux_a = (uDint)0123456701234;
static uDint gux_b = (uDint)-1;
static uDint gux_c;
static volatile uDint vgux_a = (uDint)0765432107654;
static volatile uDint vgux_b = (uDint)-1;
static volatile uDint vgux_c;

static Dint gx_low18_mask = (Dint)0777777;
static Dint gx_low_word_mask = (Dint)((uSint)-1);
static Dint gx_high_word_mask = ((Dint)-1) << 36;
static Dint gx_cross_mask = (((Dint)0123456) << 36) ^ (Dint)0654321;

static uDint gux_low18_mask = (uDint)0777777;
static uDint gux_low_word_mask = (uDint)((uSint)-1);
static uDint gux_high_word_mask = ((uDint)-1) << 36;
static uDint gux_cross_mask = (((uDint)0707070) << 36) ^ (uDint)0070707;

struct xordi3_pair {
	Dint a;
	Dint b;
	Dint c;
};

struct xordi3_upair {
	uDint a;
	uDint b;
	uDint c;
};

static struct xordi3_pair gx_pair = {
	(Dint)01234567,
	(Dint)-07654321,
	(Dint)0
};

static struct xordi3_upair gux_pair = {
	(uDint)0777777,
	(uDint)-1,
	(uDint)0
};

static Dint gx_arr[4] = {
	(Dint)0,
	(Dint)1,
	(Dint)-1,
	(Dint)0123456701234
};

static uDint gux_arr[4] = {
	(uDint)0,
	(uDint)1,
	(uDint)-1,
	(uDint)0123456701234
};

static Dint
xordi_reg(a, b)
Dint a;
Dint b;
{
	return a ^ b;
}

static uDint
uxordi_reg(a, b)
uDint a;
uDint b;
{
	return a ^ b;
}

static Dint
xordi_mem_left(ap, b)
Dint *ap;
Dint b;
{
	return *ap ^ b;
}

static Dint
xordi_mem_right(a, bp)
Dint a;
Dint *bp;
{
	return a ^ *bp;
}

static Dint
xordi_mem_mem(ap, bp)
Dint *ap;
Dint *bp;
{
	Dint a;
	Dint b;

	a = *ap;
	b = *bp;
	return a ^ b;
}

static uDint
uxordi_mem_mem(ap, bp)
uDint *ap;
uDint *bp;
{
	uDint a;
	uDint b;

	a = *ap;
	b = *bp;
	return a ^ b;
}

static Dint
xordi_global(void)
{
	return gx_a ^ gx_b;
}

static uDint
uxordi_global(void)
{
	return gux_a ^ gux_b;
}

static Dint
xordi_volatile(void)
{
	Dint a;
	Dint b;

	a = vgx_a;
	b = vgx_b;
	return a ^ b;
}

static uDint
uxordi_volatile(void)
{
	uDint a;
	uDint b;

	a = vgux_a;
	b = vgux_b;
	return a ^ b;
}

static Dint
xordi_const_zero(a)
Dint a;
{
	return a ^ (Dint)0;
}

static Dint
xordi_const_allones(a)
Dint a;
{
	return a ^ (Dint)-1;
}

static Dint
xordi_const_one(a)
Dint a;
{
	return a ^ (Dint)1;
}

static Dint
xordi_low18(a)
Dint a;
{
	return a ^ gx_low18_mask;
}

static Dint
xordi_low_word(a)
Dint a;
{
	return a ^ gx_low_word_mask;
}

static Dint
xordi_high_word(a)
Dint a;
{
	return a ^ gx_high_word_mask;
}

static Dint
xordi_cross_mask(a)
Dint a;
{
	return a ^ gx_cross_mask;
}

static uDint
uxordi_const_zero(a)
uDint a;
{
	return a ^ (uDint)0;
}

static uDint
uxordi_const_allones(a)
uDint a;
{
	return a ^ (uDint)-1;
}

static uDint
uxordi_low18(a)
uDint a;
{
	return a ^ gux_low18_mask;
}

static uDint
uxordi_low_word(a)
uDint a;
{
	return a ^ gux_low_word_mask;
}

static uDint
uxordi_high_word(a)
uDint a;
{
	return a ^ gux_high_word_mask;
}

static uDint
uxordi_cross_mask(a)
uDint a;
{
	return a ^ gux_cross_mask;
}

static Dint
xordi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
	Dint r;

	r = a ^ b;
	*out = r;
	return r;
}

static uDint
uxordi_store(out, a, b)
uDint *out;
uDint a;
uDint b;
{
	uDint r;

	r = a ^ b;
	*out = r;
	return r;
}

static Dint
xordi_store_mem(out, ap, bp)
Dint *out;
Dint *ap;
Dint *bp;
{
	*out = *ap ^ *bp;
	return *out;
}

static uDint
uxordi_store_mem(out, ap, bp)
uDint *out;
uDint *ap;
uDint *bp;
{
	*out = *ap ^ *bp;
	return *out;
}

static Dint
xordi_update_reg(p, a)
Dint *p;
Dint a;
{
	*p = *p ^ a;
	return *p;
}

static uDint
uxordi_update_reg(p, a)
uDint *p;
uDint a;
{
	*p = *p ^ a;
	return *p;
}

static Dint
xordi_update_const(p)
Dint *p;
{
	*p = *p ^ gx_cross_mask;
	return *p;
}

static uDint
uxordi_update_const(p)
uDint *p;
{
	*p = *p ^ gux_cross_mask;
	return *p;
}

static Dint
xordi_struct(p)
struct xordi3_pair *p;
{
	return p->a ^ p->b;
}

static uDint
uxordi_struct(p)
struct xordi3_upair *p;
{
	return p->a ^ p->b;
}

static Dint
xordi_struct_store(p)
struct xordi3_pair *p;
{
	p->c = p->a ^ p->b;
	return p->c;
}

static uDint
uxordi_struct_store(p)
struct xordi3_upair *p;
{
	p->c = p->a ^ p->b;
	return p->c;
}

static Dint
xordi_array(a, i)
Dint *a;
int i;
{
	return a[i] ^ a[i + 1];
}

static uDint
uxordi_array(a, i)
uDint *a;
int i;
{
	return a[i] ^ a[i + 1];
}

static void
xordi_array_store(a, i)
Dint *a;
int i;
{
	a[i] = a[i] ^ a[i + 1];
}

static void
uxordi_array_store(a, i)
uDint *a;
int i;
{
	a[i] = a[i] ^ a[i + 1];
}

static int
xordi_branch(a, b)
Dint a;
Dint b;
{
	Dint r;

	r = a ^ b;
	if (r < (Dint)0)
		return -1;
	if (r == (Dint)0)
		return 0;
	return 1;
}

static int
uxordi_branch(a, b)
uDint a;
uDint b;
{
	uDint r;

	r = a ^ b;
	if (r == (uDint)0)
		return 0;
	return 1;
}

static Dint
xordi_call_arg(a, b)
Dint a;
Dint b;
{
	Dint r;

	r = a ^ b;
	sink_dint(r);
	return r;
}

static uDint
uxordi_call_arg(a, b)
uDint a;
uDint b;
{
	uDint r;

	r = a ^ b;
	sink_udint(r);
	return r;
}

Dint
use_xordi3(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint local[3];
	Dint r;

	local[0] = a;
	local[1] = b;
	local[2] = gx_cross_mask;
	gx_c = xordi_store(&gx_c, a, b);
	vgx_c = xordi_volatile();
	xordi_array_store(local, i & 1);

	r = xordi_reg(a, b); sink_dint(r);
	r = xordi_mem_left(&local[0], b); sink_dint(r);
	r = xordi_mem_right(a, &local[1]); sink_dint(r);
	r = xordi_mem_mem(&local[0], &local[2]); sink_dint(r);
	r = xordi_global(); sink_dint(r);
	r = vgx_c; sink_dint(r);
	r = xordi_const_zero(a); sink_dint(r);
	r = xordi_const_allones(a); sink_dint(r);
	r = xordi_const_one(a); sink_dint(r);
	r = xordi_low18(a); sink_dint(r);
	r = xordi_low_word(a); sink_dint(r);
	r = xordi_high_word(a); sink_dint(r);
	r = xordi_cross_mask(a); sink_dint(r);
	r = xordi_store_mem(&local[2], &local[0], &local[1]); sink_dint(r);
	r = xordi_update_reg(&local[0], b); sink_dint(r);
	r = xordi_update_const(&local[1]); sink_dint(r);
	r = xordi_struct(&gx_pair); sink_dint(r);
	r = xordi_struct_store(&gx_pair); sink_dint(r);
	r = xordi_array(gx_arr, i & 1); sink_dint(r);
	sink_dint((Dint)xordi_branch(a, b));
	r = xordi_call_arg(a, b); sink_dint(r);
	return r;
}

uDint
use_uxordi3(a, b, i)
uDint a;
uDint b;
int i;
{
	uDint local[3];
	uDint r;

	local[0] = a;
	local[1] = b;
	local[2] = gux_cross_mask;
	gux_c = uxordi_store(&gux_c, a, b);
	vgux_c = uxordi_volatile();
	uxordi_array_store(local, i & 1);

	r = uxordi_reg(a, b); sink_udint(r);
	r = uxordi_mem_mem(&local[0], &local[2]); sink_udint(r);
	r = uxordi_global(); sink_udint(r);
	r = vgux_c; sink_udint(r);
	r = uxordi_const_zero(a); sink_udint(r);
	r = uxordi_const_allones(a); sink_udint(r);
	r = uxordi_low18(a); sink_udint(r);
	r = uxordi_low_word(a); sink_udint(r);
	r = uxordi_high_word(a); sink_udint(r);
	r = uxordi_cross_mask(a); sink_udint(r);
	r = uxordi_store_mem(&local[2], &local[0], &local[1]); sink_udint(r);
	r = uxordi_update_reg(&local[0], b); sink_udint(r);
	r = uxordi_update_const(&local[1]); sink_udint(r);
	r = uxordi_struct(&gux_pair); sink_udint(r);
	r = uxordi_struct_store(&gux_pair); sink_udint(r);
	r = uxordi_array(gux_arr, i & 1); sink_udint(r);
	sink_udint((uDint)uxordi_branch(a, b));
	r = uxordi_call_arg(a, b); sink_udint(r);
	return r;
}
