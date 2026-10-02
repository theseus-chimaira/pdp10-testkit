#include "insns.h"

/*
 * Unsigned DImode division pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on unsigned DImode division by positive
 * powers of two.  Non-power-of-two unsigned DImode division belongs in
 * misc/libgcc-udivdi3.c, where the later assembly review should check
 * for the intended libgcc helper path instead of an invalid PDP-6/KA10
 * instruction sequence.
 *
 * Do not add inline assembly here.
 */

extern void sink_udint(uDint);

static uDint gu_a = (uDint)0123456701234;
static uDint gu_b;
static volatile uDint vgu_a = (uDint)-1;
static volatile uDint vgu_b;

struct udivdi3_pair {
	uDint a;
	uDint b;
};

struct udivdi3_slot {
	uDint q;
	uDint keep;
};

static struct udivdi3_pair gu_pair = {
	(uDint)0123456701234,
	(uDint)-1
};
static struct udivdi3_slot gu_slot;

static uDint gu_arr[5] = {
	(uDint)0,
	(uDint)1,
	(uDint)-1,
	(uDint)0123456701234,
	((uDint)1 << 70)
};

static uDint
udivdi_div2(a)
uDint a;
{
	return a / (uDint)2;
}

static uDint
udivdi_div4(a)
uDint a;
{
	return a / (uDint)4;
}

static uDint
udivdi_div8(a)
uDint a;
{
	return a / (uDint)010;
}

static uDint
udivdi_div16(a)
uDint a;
{
	return a / (uDint)020;
}

static uDint
udivdi_div64(a)
uDint a;
{
	return a / (uDint)0100;
}

static uDint
udivdi_div512(a)
uDint a;
{
	return a / (uDint)01000;
}

static uDint
udivdi_div4096(a)
uDint a;
{
	return a / (uDint)010000;
}

static uDint
udivdi_div_bigword(a)
uDint a;
{
	return a / ((uDint)1 << 36);
}

static uDint
udivdi_mem2(p)
uDint *p;
{
	return *p / (uDint)2;
}

static uDint
udivdi_mem8(p)
uDint *p;
{
	return *p / (uDint)010;
}

static uDint
udivdi_global(void)
{
	return gu_a / (uDint)4;
}

static uDint
udivdi_volatile(void)
{
	uDint a;

	a = vgu_a;
	return a / (uDint)010;
}

static uDint
udivdi_high_const(void)
{
	return (uDint)-1 / (uDint)2;
}

static uDint
udivdi_high_shifted(void)
{
	return ((uDint)1 << 70) / (uDint)010000;
}

static uDint
udivdi_store(out, a)
uDint *out;
uDint a;
{
	uDint q;

	q = a / (uDint)4;
	*out = q;
	return q;
}

static uDint
udivdi_store_mem(out, in)
uDint *out;
uDint *in;
{
	*out = *in / (uDint)020;
	return *out;
}

static uDint
udivdi_update2(p)
uDint *p;
{
	*p = *p / (uDint)2;
	return *p;
}

static uDint
udivdi_update8(p)
uDint *p;
{
	*p /= (uDint)010;
	return *p;
}

static uDint
udivdi_struct(p)
struct udivdi3_pair *p;
{
	return p->a / (uDint)0100;
}

static uDint
udivdi_struct_store(p, s)
struct udivdi3_pair *p;
struct udivdi3_slot *s;
{
	s->q = p->b / (uDint)020;
	return s->q;
}

static uDint
udivdi_array(a, i)
uDint *a;
int i;
{
	return a[i] / (uDint)4;
}

static void
udivdi_array_store(a, i)
uDint *a;
int i;
{
	a[i] = a[i + 1] / (uDint)010;
}

static int
udivdi_branch(a)
uDint a;
{
	uDint q;

	q = a / (uDint)010;
	if (q == (uDint)0)
		return 0;
	if (q > (uDint)0777777)
		return 2;
	return 1;
}

static uDint
udivdi_call_arg(a)
uDint a;
{
	uDint q;

	q = a / (uDint)020;
	sink_udint(q);
	return q;
}

uDint
use_udivdi3(a, i)
uDint a;
int i;
{
	uDint local[4];
	uDint r;

	local[0] = a;
	local[1] = (uDint)-1;
	local[2] = ((uDint)1 << 70);
	local[3] = (uDint)0123456701234;

	r = udivdi_div2(a); sink_udint(r);
	r = udivdi_div4(a); sink_udint(r);
	r = udivdi_div8(a); sink_udint(r);
	r = udivdi_div16(a); sink_udint(r);
	r = udivdi_div64(a); sink_udint(r);
	r = udivdi_div512(a); sink_udint(r);
	r = udivdi_div4096(a); sink_udint(r);
	r = udivdi_div_bigword(a); sink_udint(r);
	r = udivdi_mem2(&local[0]); sink_udint(r);
	r = udivdi_mem8(&local[1]); sink_udint(r);
	r = udivdi_global(); sink_udint(r);
	r = udivdi_volatile(); sink_udint(r);
	r = udivdi_high_const(); sink_udint(r);
	r = udivdi_high_shifted(); sink_udint(r);
	r = udivdi_store(&gu_b, a); sink_udint(r);
	r = udivdi_store_mem(&local[3], &local[2]); sink_udint(r);
	r = udivdi_update2(&local[0]); sink_udint(r);
	r = udivdi_update8(&local[1]); sink_udint(r);
	r = udivdi_struct(&gu_pair); sink_udint(r);
	r = udivdi_struct_store(&gu_pair, &gu_slot); sink_udint(r);
	r = udivdi_array(gu_arr, i & 3); sink_udint(r);
	udivdi_array_store(local, i & 1);
	r = (uDint)udivdi_branch(a); sink_udint(r);
	r = udivdi_call_arg(a); sink_udint(r);

	vgu_b = r;
	return r;
}
