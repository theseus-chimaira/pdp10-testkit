#include "insns.h"

/*
 * Unsigned DImode modulo libgcc fallback coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Intent:
 *   - exercise ordinary C unsigned DImode modulo forms which must not
 *     be implemented with XKL/KL-only instructions in PDP-6/KA10 output
 *   - make the later assembly review check for the intended libgcc
 *     helper path, normally __umoddi3, for non-power-of-two modulo
 *   - keep power-of-two modulo out of this file; that belongs with
 *     shift/logical/mask coverage, not the full fallback helper test
 */

static uDint gum_a = (uDint)-1;
static uDint gum_b = (uDint)37;
static uDint gum_c;
static volatile uDint vgum_a = (uDint)-123456;
static volatile uDint vgum_b = (uDint)11;

struct umoddi_pair {
	uDint a;
	uDint b;
};

struct umoddi_slot {
	uDint r;
	uDint bias;
};

static struct umoddi_pair gum_pair = { (uDint)-76543, (uDint)19 };
static struct umoddi_slot gum_slot = { (uDint)0, (uDint)5 };

static uDint
nonzero_udint(x)
uDint x;
{
	if (x == (uDint)0)
		return (uDint)3;
	return x;
}

static uDint
umoddi_var(a, b)
uDint a;
uDint b;
{
	return a % nonzero_udint(b);
}

static uDint
umoddi_mem(ap, bp)
uDint *ap;
uDint *bp;
{
	return *ap % nonzero_udint(*bp);
}

static uDint
umoddi_global(void)
{
	return gum_a % nonzero_udint(gum_b);
}

static uDint
umoddi_volatile(void)
{
	uDint a;
	uDint b;

	a = vgum_a;
	b = vgum_b;
	return a % nonzero_udint(b);
}

static uDint
umoddi_const_3(a)
uDint a;
{
	return a % (uDint)3;
}

static uDint
umoddi_const_5(a)
uDint a;
{
	return a % (uDint)5;
}

static uDint
umoddi_const_37(a)
uDint a;
{
	return a % (uDint)37;
}

static uDint
umoddi_high_num(a, b)
uDint a;
uDint b;
{
	return (a | ((uDint)-1 - (uDint)0777777)) % nonzero_udint(b);
}

static uDint
umoddi_high_den(a, b)
uDint a;
uDint b;
{
	return a % nonzero_udint(b | ((uDint)1 << 30));
}

static uDint
umoddi_store(out, a, b)
uDint *out;
uDint a;
uDint b;
{
	uDint r;

	r = a % nonzero_udint(b);
	*out = r;
	return r;
}

static void
umoddi_update(p, b)
uDint *p;
uDint b;
{
	*p = *p % nonzero_udint(b);
}

static uDint
umoddi_struct(p)
struct umoddi_pair *p;
{
	return p->a % nonzero_udint(p->b);
}

static uDint
umoddi_struct_store(p, s)
struct umoddi_pair *p;
struct umoddi_slot *s;
{
	s->r = p->a % nonzero_udint(p->b);
	return s->r + s->bias;
}

static int
umoddi_branch(a, b)
uDint a;
uDint b;
{
	uDint r;

	r = a % nonzero_udint(b);
	if (r == (uDint)0)
		return 0;
	if (r > ((uDint)1 << 30))
		return 2;
	return 1;
}

static uDint
umoddi_array(a, i)
uDint *a;
int i;
{
	return a[i] % nonzero_udint(a[i + 1]);
}

static uDint
umoddi_mix(a, b, c)
uDint a;
uDint b;
uDint c;
{
	uDint r1;
	uDint r2;

	r1 = a % nonzero_udint(b);
	r2 = c % nonzero_udint(r1 + (uDint)7);
	return r1 + r2;
}

static uDint
umoddi_call_arg(a, b)
uDint a;
uDint b;
{
	extern void use_udint(uDint);
	uDint r;

	r = a % nonzero_udint(b);
	use_udint(r);
	return r;
}

uDint
use_libgcc_umoddi3(a, b, i)
uDint a;
uDint b;
int i;
{
	uDint arr[3];

	arr[0] = a | ((uDint)1 << 30);
	arr[1] = b;
	arr[2] = (uDint)13;
	gum_c = umoddi_store(&gum_c, a, b);
	umoddi_update(&arr[0], arr[1]);
	return umoddi_var(a, b)
	    + umoddi_mem(&arr[0], &arr[2])
	    + umoddi_global()
	    + umoddi_volatile()
	    + umoddi_const_3(a)
	    + umoddi_const_5(a)
	    + umoddi_const_37(a)
	    + umoddi_high_num(a, b)
	    + umoddi_high_den(a, b)
	    + umoddi_struct(&gum_pair)
	    + umoddi_struct_store(&gum_pair, &gum_slot)
	    + (uDint)umoddi_branch(a, b)
	    + umoddi_array(arr, i & 1)
	    + umoddi_mix(a, b, gum_c)
	    + umoddi_call_arg(a, b);
}
