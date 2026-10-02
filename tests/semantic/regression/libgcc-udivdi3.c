#include "insns.h"

/*
 * Unsigned DImode division libgcc fallback coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Intent:
 *   - exercise ordinary C unsigned DImode division forms which must not
 *     be implemented with XKL/KL-only instructions in PDP-6/KA10 output
 *   - make the later assembly review check for the intended libgcc
 *     helper path, normally __udivdi3, for non-power-of-two division
 *   - keep power-of-two division out of this file; that belongs with
 *     shift/logical coverage, not the full fallback helper test
 */

static uDint gu_a = (uDint)-1;
static uDint gu_b = (uDint)37;
static uDint gu_c;
static volatile uDint vgu_a = (uDint)-123456;
static volatile uDint vgu_b = (uDint)11;

struct udivdi_pair {
	uDint a;
	uDint b;
};

struct udivdi_slot {
	uDint q;
	uDint bias;
};

static struct udivdi_pair gu_pair = { (uDint)-76543, (uDint)19 };
static struct udivdi_slot gu_slot = { (uDint)0, (uDint)5 };

static uDint
nonzero_udint(x)
uDint x;
{
	if (x == (uDint)0)
		return (uDint)3;
	return x;
}

static uDint
udivdi_var(a, b)
uDint a;
uDint b;
{
	return a / nonzero_udint(b);
}

static uDint
udivdi_mem(ap, bp)
uDint *ap;
uDint *bp;
{
	return *ap / nonzero_udint(*bp);
}

static uDint
udivdi_global(void)
{
	return gu_a / nonzero_udint(gu_b);
}

static uDint
udivdi_volatile(void)
{
	uDint a;
	uDint b;

	a = vgu_a;
	b = vgu_b;
	return a / nonzero_udint(b);
}

static uDint
udivdi_const_3(a)
uDint a;
{
	return a / (uDint)3;
}

static uDint
udivdi_const_5(a)
uDint a;
{
	return a / (uDint)5;
}

static uDint
udivdi_const_37(a)
uDint a;
{
	return a / (uDint)37;
}

static uDint
udivdi_high_num(a, b)
uDint a;
uDint b;
{
	return (a | ((uDint)-1 - (uDint)0777777)) / nonzero_udint(b);
}

static uDint
udivdi_high_den(a, b)
uDint a;
uDint b;
{
	return a / nonzero_udint(b | ((uDint)1 << 30));
}

static uDint
udivdi_store(out, a, b)
uDint *out;
uDint a;
uDint b;
{
	uDint q;

	q = a / nonzero_udint(b);
	*out = q;
	return q;
}

static void
udivdi_update(p, b)
uDint *p;
uDint b;
{
	*p = *p / nonzero_udint(b);
}

static uDint
udivdi_struct(p)
struct udivdi_pair *p;
{
	return p->a / nonzero_udint(p->b);
}

static uDint
udivdi_struct_store(p, s)
struct udivdi_pair *p;
struct udivdi_slot *s;
{
	s->q = p->a / nonzero_udint(p->b);
	return s->q + s->bias;
}

static int
udivdi_branch(a, b)
uDint a;
uDint b;
{
	uDint q;

	q = a / nonzero_udint(b);
	if (q == (uDint)0)
		return 0;
	if (q > ((uDint)1 << 30))
		return 2;
	return 1;
}

static uDint
udivdi_array(a, i)
uDint *a;
int i;
{
	return a[i] / nonzero_udint(a[i + 1]);
}

static uDint
udivdi_mix(a, b, c)
uDint a;
uDint b;
uDint c;
{
	uDint q1;
	uDint q2;

	q1 = a / nonzero_udint(b);
	q2 = c / nonzero_udint(q1 + (uDint)7);
	return q1 + q2;
}

static uDint
udivdi_call_arg(a, b)
uDint a;
uDint b;
{
	extern void use_udint(uDint);
	uDint q;

	q = a / nonzero_udint(b);
	use_udint(q);
	return q;
}

uDint
use_libgcc_udivdi3(a, b, i)
uDint a;
uDint b;
int i;
{
	uDint arr[3];

	arr[0] = a | ((uDint)1 << 30);
	arr[1] = b;
	arr[2] = (uDint)13;
	gu_c = udivdi_store(&gu_c, a, b);
	udivdi_update(&arr[0], arr[1]);
	return udivdi_var(a, b)
	    + udivdi_mem(&arr[0], &arr[2])
	    + udivdi_global()
	    + udivdi_volatile()
	    + udivdi_const_3(a)
	    + udivdi_const_5(a)
	    + udivdi_const_37(a)
	    + udivdi_high_num(a, b)
	    + udivdi_high_den(a, b)
	    + udivdi_struct(&gu_pair)
	    + udivdi_struct_store(&gu_pair, &gu_slot)
	    + (uDint)udivdi_branch(a, b)
	    + udivdi_array(arr, i & 1)
	    + udivdi_mix(a, b, gu_c)
	    + udivdi_call_arg(a, b);
}
