#include "insns.h"

/*
 * Unsigned SImode modulo libgcc fallback coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Intent:
 *   - exercise ordinary C unsigned SImode modulo forms which should
 *     use the intended runtime helper path, normally __umodsi3, when
 *     PDP-6/KA10 output cannot use a native unsigned-modulo pattern
 *   - avoid XKL/KL-only UIMOD/UMOD-style operations in PDP-6/KA10 output
 *   - keep power-of-two modulo out of this file; that belongs with
 *     shift/logical/mask coverage, not the full fallback helper test
 */

static uSint gum_a = (uSint)-1;
static uSint gum_b = (uSint)37;
static uSint gum_c;
static volatile uSint vgum_a = (uSint)-9876;
static volatile uSint vgum_b = (uSint)11;

struct umodsi_pair {
	uSint a;
	uSint b;
};

#define USI_HIGH 0400000000000U
#define USI_HIGH2 0200000000000U

struct umodsi_slot {
	uSint r;
	uSint bias;
};

static struct umodsi_pair gum_pair = { (uSint)-12345, (uSint)19 };
static struct umodsi_slot gum_slot = { (uSint)0, (uSint)5 };

static uSint
nonzero_usint(x)
uSint x;
{
	if (x == (uSint)0)
		return (uSint)3;
	return x;
}

static uSint
umodsi_var(a, b)
uSint a;
uSint b;
{
	return a % nonzero_usint(b);
}

static uSint
umodsi_mem(ap, bp)
uSint *ap;
uSint *bp;
{
	return *ap % nonzero_usint(*bp);
}

static uSint
umodsi_global(void)
{
	return gum_a % nonzero_usint(gum_b);
}

static uSint
umodsi_volatile(void)
{
	uSint a;
	uSint b;

	a = vgum_a;
	b = vgum_b;
	return a % nonzero_usint(b);
}

static uSint
umodsi_const_3(a)
uSint a;
{
	return a % (uSint)3;
}

static uSint
umodsi_const_5(a)
uSint a;
{
	return a % (uSint)5;
}

static uSint
umodsi_const_37(a)
uSint a;
{
	return a % (uSint)37;
}

static uSint
umodsi_high_num(a, b)
uSint a;
uSint b;
{
	return (a | USI_HIGH) % nonzero_usint(b);
}

static uSint
umodsi_high_den(a, b)
uSint a;
uSint b;
{
	return a % nonzero_usint(b | USI_HIGH2);
}

static uSint
umodsi_max_num(b)
uSint b;
{
	return (uSint)-1 % nonzero_usint(b);
}

static uSint
umodsi_store(out, a, b)
uSint *out;
uSint a;
uSint b;
{
	uSint r;

	r = a % nonzero_usint(b);
	*out = r;
	return r;
}

static void
umodsi_update(p, b)
uSint *p;
uSint b;
{
	*p = *p % nonzero_usint(b);
}

static uSint
umodsi_struct(p)
struct umodsi_pair *p;
{
	return p->a % nonzero_usint(p->b);
}

static uSint
umodsi_struct_store(p, s)
struct umodsi_pair *p;
struct umodsi_slot *s;
{
	s->r = p->a % nonzero_usint(p->b);
	return s->r + s->bias;
}

static int
umodsi_branch(a, b)
uSint a;
uSint b;
{
	uSint r;

	r = a % nonzero_usint(b);
	if (r == (uSint)0)
		return 0;
	if (r > (uSint)0777777)
		return 2;
	return 1;
}

static uSint
umodsi_array(a, i)
uSint *a;
int i;
{
	return a[i] % nonzero_usint(a[i + 1]);
}

static uSint
umodsi_mix(a, b, c)
uSint a;
uSint b;
uSint c;
{
	uSint r1;
	uSint r2;

	r1 = a % nonzero_usint(b);
	r2 = c % nonzero_usint(r1 + (uSint)7);
	return r1 + r2;
}

static uSint
umodsi_call_arg(a, b)
uSint a;
uSint b;
{
	extern void use_usint(uSint);
	uSint r;

	r = a % nonzero_usint(b);
	use_usint(r);
	return r;
}

uSint
use_libgcc_umodsi3(a, b, i)
uSint a;
uSint b;
int i;
{
	uSint arr[3];

	arr[0] = a | USI_HIGH;
	arr[1] = nonzero_usint(b);
	arr[2] = (uSint)13;
	gum_c = umodsi_store(&gum_c, a, b);
	umodsi_update(&arr[0], arr[1]);
	return umodsi_var(a, b)
	    + umodsi_mem(&arr[0], &arr[2])
	    + umodsi_global()
	    + umodsi_volatile()
	    + umodsi_const_3(a)
	    + umodsi_const_5(a)
	    + umodsi_const_37(a)
	    + umodsi_high_num(a, b)
	    + umodsi_high_den(a, b)
	    + umodsi_max_num(b)
	    + umodsi_struct(&gum_pair)
	    + umodsi_struct_store(&gum_pair, &gum_slot)
	    + (uSint)umodsi_branch(a, b)
	    + umodsi_array(arr, i & 1)
	    + umodsi_mix(a, b, gum_c)
	    + umodsi_call_arg(a, b);
}
