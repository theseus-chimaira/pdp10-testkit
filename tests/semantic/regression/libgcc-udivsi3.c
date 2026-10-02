#include "insns.h"

/*
 * Unsigned SImode division libgcc fallback coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Intent:
 *   - exercise ordinary C unsigned SImode division forms which should
 *     use the intended runtime helper path, normally __udivsi3, when
 *     PDP-6/KA10 output cannot use a native unsigned-division pattern
 *   - avoid XKL/KL-only UIDIV/UDIV-style operations in PDP-6/KA10 output
 *   - keep power-of-two division out of this file; that belongs with
 *     shift/special-case coverage, not the full fallback helper test
 */

static uSint gu_a = (uSint)12345;
static uSint gu_b = (uSint)37;
static uSint gu_c;
static volatile uSint vgu_a = (uSint)-9876;
static volatile uSint vgu_b = (uSint)11;

struct udivsi_pair {
	uSint a;
	uSint b;
};

#define USI_HIGH 0400000000000U
#define USI_HIGH2 0200000000000U

struct udivsi_slot {
	uSint q;
	uSint bias;
};

static struct udivsi_pair gu_pair = { (uSint)-12345, (uSint)19 };
static struct udivsi_slot gu_slot = { (uSint)0, (uSint)7 };

static uSint
nonzero_usint(x)
uSint x;
{
	if (x == (uSint)0)
		return (uSint)3;
	return x;
}

static uSint
udivsi_var(a, b)
uSint a;
uSint b;
{
	return a / nonzero_usint(b);
}

static uSint
udivsi_mem(ap, bp)
uSint *ap;
uSint *bp;
{
	return *ap / nonzero_usint(*bp);
}

static uSint
udivsi_global(void)
{
	return gu_a / nonzero_usint(gu_b);
}

static uSint
udivsi_volatile(void)
{
	uSint a;
	uSint b;

	a = vgu_a;
	b = vgu_b;
	return a / nonzero_usint(b);
}

static uSint
udivsi_const_3(a)
uSint a;
{
	return a / (uSint)3;
}

static uSint
udivsi_const_5(a)
uSint a;
{
	return a / (uSint)5;
}

static uSint
udivsi_const_37(a)
uSint a;
{
	return a / (uSint)37;
}

static uSint
udivsi_high_num(a, b)
uSint a;
uSint b;
{
	return (a | USI_HIGH) / nonzero_usint(b);
}

static uSint
udivsi_high_den(a, b)
uSint a;
uSint b;
{
	return a / nonzero_usint(b | USI_HIGH2);
}

static uSint
udivsi_max_num(b)
uSint b;
{
	return (uSint)-1 / nonzero_usint(b);
}

static uSint
udivsi_store(out, a, b)
uSint *out;
uSint a;
uSint b;
{
	uSint q;

	q = a / nonzero_usint(b);
	*out = q;
	return q;
}

static void
udivsi_update(p, b)
uSint *p;
uSint b;
{
	*p = *p / nonzero_usint(b);
}

static uSint
udivsi_struct(p)
struct udivsi_pair *p;
{
	return p->a / nonzero_usint(p->b);
}

static uSint
udivsi_struct_store(p, s)
struct udivsi_pair *p;
struct udivsi_slot *s;
{
	s->q = p->a / nonzero_usint(p->b);
	return s->q + s->bias;
}

static int
udivsi_branch(a, b)
uSint a;
uSint b;
{
	uSint q;

	q = a / nonzero_usint(b);
	if (q == (uSint)0)
		return 0;
	if (q > (uSint)0777777)
		return 2;
	return 1;
}

static uSint
udivsi_array(a, i)
uSint *a;
int i;
{
	return a[i] / nonzero_usint(a[i + 1]);
}

static uSint
udivsi_mix(a, b, c)
uSint a;
uSint b;
uSint c;
{
	uSint q1;
	uSint q2;

	q1 = a / nonzero_usint(b);
	q2 = c / nonzero_usint(q1 + (uSint)7);
	return q1 + q2;
}

static uSint
udivsi_call_arg(a, b)
uSint a;
uSint b;
{
	extern void use_usint(uSint);
	uSint q;

	q = a / nonzero_usint(b);
	use_usint(q);
	return q;
}

uSint
use_libgcc_udivsi3(a, b, i)
uSint a;
uSint b;
int i;
{
	uSint arr[3];

	arr[0] = a | USI_HIGH;
	arr[1] = nonzero_usint(b);
	arr[2] = (uSint)13;
	gu_c = udivsi_store(&gu_c, a, b);
	udivsi_update(&arr[0], arr[1]);
	return udivsi_var(a, b)
	    + udivsi_mem(&arr[0], &arr[2])
	    + udivsi_global()
	    + udivsi_volatile()
	    + udivsi_const_3(a)
	    + udivsi_const_5(a)
	    + udivsi_const_37(a)
	    + udivsi_high_num(a, b)
	    + udivsi_high_den(a, b)
	    + udivsi_max_num(b)
	    + udivsi_struct(&gu_pair)
	    + udivsi_struct_store(&gu_pair, &gu_slot)
	    + (uSint)udivsi_branch(a, b)
	    + udivsi_array(arr, i & 1)
	    + udivsi_mix(a, b, gu_c)
	    + udivsi_call_arg(a, b);
}
