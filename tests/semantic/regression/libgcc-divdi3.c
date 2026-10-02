#include "insns.h"

/*
 * Signed DImode division libgcc fallback coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Intent:
 *   - exercise ordinary C signed DImode division forms which should not
 *     be implemented with PDP-6/KA10-only-invalid DDIV output
 *   - make the later assembly review check for the intended libgcc
 *     helper path, normally __divdi3, for non-power-of-two division
 *   - keep power-of-two division out of this file; that belongs with
 *     shift/bias coverage, not the full fallback helper test
 */

static Dint gd_a = (Dint)12345;
static Dint gd_b = (Dint)-37;
static Dint gd_c;
static volatile Dint vgd_a = (Dint)-9876;
static volatile Dint vgd_b = (Dint)11;

struct divdi_pair {
	Dint a;
	Dint b;
};

struct divdi_slot {
	Dint q;
	Dint bias;
};

static struct divdi_pair gd_pair = { (Dint)76543, (Dint)-19 };
static struct divdi_slot gd_slot;

static Dint
nonzero_dint(x)
Dint x;
{
	if (x == (Dint)0)
		return (Dint)3;
	return x;
}

static Dint
divdi_var(a, b)
Dint a;
Dint b;
{
	return a / nonzero_dint(b);
}

static Dint
divdi_mem(ap, bp)
Dint *ap;
Dint *bp;
{
	return *ap / nonzero_dint(*bp);
}

static Dint
divdi_global(void)
{
	return gd_a / nonzero_dint(gd_b);
}

static Dint
divdi_volatile(void)
{
	Dint a;
	Dint b;

	a = vgd_a;
	b = vgd_b;
	return a / nonzero_dint(b);
}

static Dint
divdi_const_pos(a)
Dint a;
{
	return a / (Dint)3;
}

static Dint
divdi_const_neg(a)
Dint a;
{
	return a / (Dint)-5;
}

static Dint
divdi_neg_num(a, b)
Dint a;
Dint b;
{
	return -a / nonzero_dint(b);
}

static Dint
divdi_both_neg(a, b)
Dint a;
Dint b;
{
	return -a / nonzero_dint(-b);
}

static Dint
divdi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
	Dint q;

	q = a / nonzero_dint(b);
	*out = q;
	return q;
}

static void
divdi_update(p, b)
Dint *p;
Dint b;
{
	*p = *p / nonzero_dint(b);
}

static Dint
divdi_struct(p)
struct divdi_pair *p;
{
	return p->a / nonzero_dint(p->b);
}

static Dint
divdi_struct_store(p, s)
struct divdi_pair *p;
struct divdi_slot *s;
{
	s->q = p->a / nonzero_dint(p->b);
	return s->q + s->bias;
}

static int
divdi_branch(a, b)
Dint a;
Dint b;
{
	Dint q;

	q = a / nonzero_dint(b);
	if (q < (Dint)0)
		return -1;
	if (q == (Dint)0)
		return 0;
	return 1;
}

static Dint
divdi_array(a, i)
Dint *a;
int i;
{
	return a[i] / nonzero_dint(a[i + 1]);
}

static Dint
divdi_mix(a, b, c)
Dint a;
Dint b;
Dint c;
{
	Dint q1;
	Dint q2;

	q1 = a / nonzero_dint(b);
	q2 = c / nonzero_dint(q1 + (Dint)7);
	return q1 + q2;
}

static Dint
divdi_call_arg(a, b)
Dint a;
Dint b;
{
	extern void use_dint(Dint);
	Dint q;

	q = a / nonzero_dint(b);
	use_dint(q);
	return q;
}

static Dint
use_libgcc_divdi3(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint arr[3];

	arr[0] = a;
	arr[1] = b;
	arr[2] = (Dint)-13;
	gd_c = divdi_store(&gd_c, a, b);
	divdi_update(&arr[0], arr[1]);
	return divdi_var(a, b)
	    + divdi_mem(&arr[0], &arr[2])
	    + divdi_global()
	    + divdi_volatile()
	    + divdi_const_pos(a)
	    + divdi_const_neg(a)
	    + divdi_neg_num(a, b)
	    + divdi_both_neg(a, b)
	    + divdi_struct(&gd_pair)
	    + divdi_struct_store(&gd_pair, &gd_slot)
	    + (Dint)divdi_branch(a, b)
	    + divdi_array(arr, i & 1)
	    + divdi_mix(a, b, gd_c)
	    + divdi_call_arg(a, b);
}
