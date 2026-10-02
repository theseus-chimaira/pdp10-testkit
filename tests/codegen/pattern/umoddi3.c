#include "insns.h"

/*
 * Unsigned DImode modulo pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on unsigned DImode modulo by positive powers
 * of two.  Non-power-of-two unsigned DImode modulo belongs in
 * misc/libgcc-umoddi3.c, where the later assembly review should check
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

struct umoddi3_pair {
	uDint a;
	uDint b;
};

struct umoddi3_slot {
	uDint r;
	uDint keep;
};

static struct umoddi3_pair gu_pair = {
	(uDint)0123456701234,
	(uDint)-1
};
static struct umoddi3_slot gu_slot;

static uDint gu_arr[5] = {
	(uDint)0,
	(uDint)1,
	(uDint)-1,
	(uDint)0123456701234,
	((uDint)1 << 70)
};

static uDint
umoddi_mod2(a)
uDint a;
{
	return a % (uDint)2;
}

static uDint
umoddi_mod4(a)
uDint a;
{
	return a % (uDint)4;
}

static uDint
umoddi_mod8(a)
uDint a;
{
	return a % (uDint)010;
}

static uDint
umoddi_mod16(a)
uDint a;
{
	return a % (uDint)020;
}

static uDint
umoddi_mod64(a)
uDint a;
{
	return a % (uDint)0100;
}

static uDint
umoddi_mod512(a)
uDint a;
{
	return a % (uDint)01000;
}

static uDint
umoddi_mod4096(a)
uDint a;
{
	return a % (uDint)010000;
}

static uDint
umoddi_mod_bigword(a)
uDint a;
{
	return a % ((uDint)1 << 36);
}

static uDint
umoddi_mem2(p)
uDint *p;
{
	return *p % (uDint)2;
}

static uDint
umoddi_mem8(p)
uDint *p;
{
	return *p % (uDint)010;
}

static uDint
umoddi_global(void)
{
	return gu_a % (uDint)4;
}

static uDint
umoddi_volatile(void)
{
	uDint a;

	a = vgu_a;
	return a % (uDint)010;
}

static uDint
umoddi_high_const(void)
{
	return (uDint)-1 % (uDint)020;
}

static uDint
umoddi_high_shifted(void)
{
	return ((uDint)1 << 70) % (uDint)010000;
}

static uDint
umoddi_store(out, a)
uDint *out;
uDint a;
{
	uDint r;

	r = a % (uDint)4;
	*out = r;
	return r;
}

static uDint
umoddi_store_mem(out, in)
uDint *out;
uDint *in;
{
	*out = *in % (uDint)020;
	return *out;
}

static uDint
umoddi_update2(p)
uDint *p;
{
	*p = *p % (uDint)2;
	return *p;
}

static uDint
umoddi_update8(p)
uDint *p;
{
	*p %= (uDint)010;
	return *p;
}

static uDint
umoddi_struct(p)
struct umoddi3_pair *p;
{
	return p->a % (uDint)0100;
}

static uDint
umoddi_struct_store(p, s)
struct umoddi3_pair *p;
struct umoddi3_slot *s;
{
	s->r = p->b % (uDint)020;
	return s->r;
}

static uDint
umoddi_array(a, i)
uDint *a;
int i;
{
	return a[i] % (uDint)4;
}

static void
umoddi_array_store(a, i)
uDint *a;
int i;
{
	a[i] = a[i + 1] % (uDint)010;
}

static int
umoddi_branch(a)
uDint a;
{
	uDint r;

	r = a % (uDint)010;
	if (r == (uDint)0)
		return 0;
	if (r > (uDint)3)
		return 2;
	return 1;
}

static uDint
umoddi_call_arg(a)
uDint a;
{
	uDint r;

	r = a % (uDint)020;
	sink_udint(r);
	return r;
}

static uDint
umoddi_chain(a)
uDint a;
{
	uDint r;

	r = a % (uDint)0100;
	r = r % (uDint)010;
	return r;
}

uDint
use_umoddi3(a, i)
uDint a;
int i;
{
	uDint local[4];
	uDint r;

	local[0] = a;
	local[1] = (uDint)-1;
	local[2] = ((uDint)1 << 70);
	local[3] = (uDint)0123456701234;

	r = umoddi_mod2(a); sink_udint(r);
	r = umoddi_mod4(a); sink_udint(r);
	r = umoddi_mod8(a); sink_udint(r);
	r = umoddi_mod16(a); sink_udint(r);
	r = umoddi_mod64(a); sink_udint(r);
	r = umoddi_mod512(a); sink_udint(r);
	r = umoddi_mod4096(a); sink_udint(r);
	r = umoddi_mod_bigword(a); sink_udint(r);
	r = umoddi_mem2(&local[0]); sink_udint(r);
	r = umoddi_mem8(&local[1]); sink_udint(r);
	r = umoddi_global(); sink_udint(r);
	r = umoddi_volatile(); sink_udint(r);
	r = umoddi_high_const(); sink_udint(r);
	r = umoddi_high_shifted(); sink_udint(r);
	r = umoddi_store(&gu_b, a); sink_udint(r);
	r = umoddi_store_mem(&local[3], &local[2]); sink_udint(r);
	r = umoddi_update2(&local[0]); sink_udint(r);
	r = umoddi_update8(&local[1]); sink_udint(r);
	r = umoddi_struct(&gu_pair); sink_udint(r);
	r = umoddi_struct_store(&gu_pair, &gu_slot); sink_udint(r);
	r = umoddi_array(gu_arr, i & 3); sink_udint(r);
	umoddi_array_store(local, i & 1);
	r = (uDint)umoddi_branch(a); sink_udint(r);
	r = umoddi_call_arg(a); sink_udint(r);
	r = umoddi_chain(a); sink_udint(r);

	vgu_b = r;
	return r;
}
