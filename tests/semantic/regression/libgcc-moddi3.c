#include "insns.h"

/*
 * Signed DImode modulo libgcc fallback coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Intent:
 *   - exercise ordinary C signed DImode modulo forms which must not be
 *     implemented with DDIV in PDP-6/KA10 output
 *   - make the later assembly review check for the intended libgcc
 *     helper path, normally __moddi3, for non-power-of-two modulo
 *   - keep power-of-two modulo out of this file; that belongs with
 *     shift/bias/mask coverage, not the full fallback helper test
 */

static Dint gm_a = (Dint)12345;
static Dint gm_b = (Dint)-37;
static Dint gm_c;
static volatile Dint vgm_a = (Dint)-9876;
static volatile Dint vgm_b = (Dint)11;

struct moddi_pair {
	Dint a;
	Dint b;
};

struct moddi_slot {
	Dint r;
	Dint bias;
};

static struct moddi_pair gm_pair = { (Dint)76543, (Dint)-19 };
static struct moddi_slot gm_slot = { (Dint)0, (Dint)5 };

static Dint
nonzero_dint(x)
Dint x;
{
	if (x == (Dint)0)
		return (Dint)3;
	return x;
}

static Dint
moddi_var(a, b)
Dint a;
Dint b;
{
	return a % nonzero_dint(b);
}

static Dint
moddi_mem(ap, bp)
Dint *ap;
Dint *bp;
{
	return *ap % nonzero_dint(*bp);
}

static Dint
moddi_global(void)
{
	return gm_a % nonzero_dint(gm_b);
}

static Dint
moddi_volatile(void)
{
	Dint a;
	Dint b;

	a = vgm_a;
	b = vgm_b;
	return a % nonzero_dint(b);
}

static Dint
moddi_const_pos(a)
Dint a;
{
	return a % (Dint)3;
}

static Dint
moddi_const_neg(a)
Dint a;
{
	return a % (Dint)-5;
}

static Dint
moddi_neg_num(a, b)
Dint a;
Dint b;
{
	return -a % nonzero_dint(b);
}

static Dint
moddi_both_neg(a, b)
Dint a;
Dint b;
{
	return -a % nonzero_dint(-b);
}

static Dint
moddi_store(out, a, b)
Dint *out;
Dint a;
Dint b;
{
	Dint r;

	r = a % nonzero_dint(b);
	*out = r;
	return r;
}

static void
moddi_update(p, b)
Dint *p;
Dint b;
{
	*p = *p % nonzero_dint(b);
}

static Dint
moddi_struct(p)
struct moddi_pair *p;
{
	return p->a % nonzero_dint(p->b);
}

static Dint
moddi_struct_store(p, s)
struct moddi_pair *p;
struct moddi_slot *s;
{
	s->r = p->a % nonzero_dint(p->b);
	return s->r + s->bias;
}

static int
moddi_branch(a, b)
Dint a;
Dint b;
{
	Dint r;

	r = a % nonzero_dint(b);
	if (r < (Dint)0)
		return -1;
	if (r == (Dint)0)
		return 0;
	return 1;
}

static Dint
moddi_array(a, i)
Dint *a;
int i;
{
	return a[i] % nonzero_dint(a[i + 1]);
}

static Dint
moddi_mix(a, b, c)
Dint a;
Dint b;
Dint c;
{
	Dint r1;
	Dint r2;

	r1 = a % nonzero_dint(b);
	r2 = c % nonzero_dint(r1 + (Dint)7);
	return r1 + r2;
}

static Dint
moddi_call_arg(a, b)
Dint a;
Dint b;
{
	extern void use_dint(Dint);
	Dint r;

	r = a % nonzero_dint(b);
	use_dint(r);
	return r;
}

Dint
use_libgcc_moddi3(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint arr[3];

	arr[0] = a;
	arr[1] = b;
	arr[2] = (Dint)-13;
	gm_c = moddi_store(&gm_c, a, b);
	moddi_update(&arr[0], arr[1]);
	return moddi_var(a, b)
	    + moddi_mem(&arr[0], &arr[2])
	    + moddi_global()
	    + moddi_volatile()
	    + moddi_const_pos(a)
	    + moddi_const_neg(a)
	    + moddi_neg_num(a, b)
	    + moddi_both_neg(a, b)
	    + moddi_struct(&gm_pair)
	    + moddi_struct_store(&gm_pair, &gm_slot)
	    + (Dint)moddi_branch(a, b)
	    + moddi_array(arr, i & 1)
	    + moddi_mix(a, b, gm_c)
	    + moddi_call_arg(a, b);
}
