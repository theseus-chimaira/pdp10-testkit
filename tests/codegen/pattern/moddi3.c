#include "insns.h"

/*
 * Signed DImode modulo pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * Keep this file focused on C modulo forms that are expected to be
 * optimizable without the full signed DImode modulo helper: positive
 * power-of-two divisors and negative dividends.  Non-power-of-two
 * modulo belongs in misc/libgcc-moddi3.c, where the libgcc fallback
 * path is reviewed.
 *
 * Do not add inline assembly here.
 */

extern void sink_dint(Dint);

static Dint gm_a = (Dint)-123456;
static Dint gm_b;
static volatile Dint vgm_a = (Dint)-7654321;

struct moddi3_pair {
	Dint a;
	Dint b;
};

struct moddi3_slot {
	Dint r2;
	Dint r4;
	Dint r8;
};

static struct moddi3_pair gm_pair = { (Dint)-76543, (Dint)12345 };
static struct moddi3_slot gm_slot;
static Dint gm_arr[4] = {
	(Dint)-01000001,
	(Dint)0777777,
	(Dint)-37,
	(Dint)1234567
};

static Dint
moddi_by_2(a)
Dint a;
{
	return a % (Dint)2;
}

static Dint
moddi_by_4(a)
Dint a;
{
	return a % (Dint)4;
}

static Dint
moddi_by_8(a)
Dint a;
{
	return a % (Dint)8;
}

static Dint
moddi_by_16(a)
Dint a;
{
	return a % (Dint)16;
}

static Dint
moddi_by_64(a)
Dint a;
{
	return a % (Dint)64;
}

static Dint
moddi_by_512(a)
Dint a;
{
	return a % (Dint)512;
}

static Dint
moddi_by_4096(a)
Dint a;
{
	return a % (Dint)4096;
}

static Dint
moddi_by_262144(a)
Dint a;
{
	return a % (Dint)01000000;
}

static Dint
moddi_mem_2(p)
Dint *p;
{
	return *p % (Dint)2;
}

static Dint
moddi_mem_8(p)
Dint *p;
{
	return *p % (Dint)8;
}

static Dint
moddi_global_4(void)
{
	return gm_a % (Dint)4;
}

static Dint
moddi_volatile_16(void)
{
	Dint a;

	a = vgm_a;
	return a % (Dint)16;
}

static Dint
moddi_neg_num_2(a)
Dint a;
{
	return -a % (Dint)2;
}

static Dint
moddi_neg_num_8(a)
Dint a;
{
	return -a % (Dint)8;
}

static Dint
moddi_sum_8(a, b)
Dint a;
Dint b;
{
	return (a + b) % (Dint)8;
}

static Dint
moddi_diff_4(a, b)
Dint a;
Dint b;
{
	return (a - b) % (Dint)4;
}

static Dint
moddi_store_2(out, a)
Dint *out;
Dint a;
{
	Dint r;

	r = a % (Dint)2;
	*out = r;
	return r;
}

static Dint
moddi_store_64(out, a)
Dint *out;
Dint a;
{
	*out = a % (Dint)64;
	return *out;
}

static void
moddi_update_2(p)
Dint *p;
{
	*p = *p % (Dint)2;
}

static void
moddi_update_8(p)
Dint *p;
{
	*p %= (Dint)8;
}

static Dint
moddi_struct_4(p)
struct moddi3_pair *p;
{
	return p->a % (Dint)4;
}

static Dint
moddi_struct_sum_16(p)
struct moddi3_pair *p;
{
	return (p->a + p->b) % (Dint)16;
}

static Dint
moddi_struct_store(p, s)
struct moddi3_pair *p;
struct moddi3_slot *s;
{
	s->r2 = p->a % (Dint)2;
	s->r4 = p->b % (Dint)4;
	s->r8 = (p->a + p->b) % (Dint)8;
	return s->r2 + s->r4 + s->r8;
}

static Dint
moddi_array_2(a, i)
Dint *a;
int i;
{
	return a[i] % (Dint)2;
}

static Dint
moddi_array_32(a, i)
Dint *a;
int i;
{
	return a[i] % (Dint)32;
}

static int
moddi_branch(a)
Dint a;
{
	Dint r;

	r = a % (Dint)8;
	if (r < (Dint)0)
		return -1;
	if (r == (Dint)0)
		return 0;
	return 1;
}

static Dint
moddi_call_arg(a)
Dint a;
{
	Dint r;

	r = a % (Dint)16;
	sink_dint(r);
	return r;
}

static Dint
moddi_chain(a)
Dint a;
{
	Dint r;

	r = a % (Dint)64;
	r = (r + (Dint)17) % (Dint)8;
	return r;
}

Dint
use_moddi3(a, i)
Dint a;
int i;
{
	Dint local[4];

	local[0] = a;
	local[1] = (Dint)-01000001;
	local[2] = gm_arr[i & 3];
	local[3] = gm_pair.a;
	gm_b = moddi_store_2(&gm_b, a);
	moddi_update_8(&local[0]);
	return moddi_by_2(a)
	    + moddi_by_4(a)
	    + moddi_by_8(a)
	    + moddi_by_16(a)
	    + moddi_by_64(a)
	    + moddi_by_512(a)
	    + moddi_by_4096(a)
	    + moddi_by_262144(a)
	    + moddi_mem_2(&local[1])
	    + moddi_mem_8(&local[2])
	    + moddi_global_4()
	    + moddi_volatile_16()
	    + moddi_neg_num_2(a)
	    + moddi_neg_num_8(a)
	    + moddi_sum_8(a, local[3])
	    + moddi_diff_4(a, gm_b)
	    + moddi_store_64(&local[3], a)
	    + moddi_struct_4(&gm_pair)
	    + moddi_struct_sum_16(&gm_pair)
	    + moddi_struct_store(&gm_pair, &gm_slot)
	    + moddi_array_2(local, i & 3)
	    + moddi_array_32(gm_arr, i & 3)
	    + (Dint)moddi_branch(a)
	    + moddi_call_arg(a)
	    + moddi_chain(a);
}
