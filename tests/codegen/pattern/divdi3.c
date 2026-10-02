#include "insns.h"


/*
 * Signed DImode division pattern coverage.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 *
 * The PDP-6/KA10 divdi3 expander only has a useful inline path for
 * positive power-of-two divisors: it biases negative values so C
 * division truncates toward zero, then reuses the arithmetic-right-shift
 * path.  Non-power-of-two DImode division belongs in
 * misc/libgcc-divdi3.c, where the libgcc fallback path is reviewed.
 *
 * Do not add inline assembly here.
 */

static Dint gd_a = (Dint)-123456;
static Dint gd_b;
static volatile Dint vgd_a = (Dint)-7654321;

struct divdi3_pair {
	Dint a;
	Dint b;
};

struct divdi3_slot {
	Dint q2;
	Dint q4;
	Dint q8;
};

static struct divdi3_pair gd_pair = { (Dint)-76543, (Dint)12345 };
static struct divdi3_slot gd_slot;
static Dint gd_arr[4] = {
	(Dint)-01000001,
	(Dint)0777777,
	(Dint)-37,
	(Dint)1234567
};

static Dint
divdi_by_2(a)
Dint a;
{
	return a / (Dint)2;
}

static Dint
divdi_by_4(a)
Dint a;
{
	return a / (Dint)4;
}

static Dint
divdi_by_8(a)
Dint a;
{
	return a / (Dint)8;
}

static Dint
divdi_by_16(a)
Dint a;
{
	return a / (Dint)16;
}

static Dint
divdi_by_64(a)
Dint a;
{
	return a / (Dint)64;
}

static Dint
divdi_by_512(a)
Dint a;
{
	return a / (Dint)512;
}

static Dint
divdi_by_4096(a)
Dint a;
{
	return a / (Dint)4096;
}

static Dint
divdi_by_262144(a)
Dint a;
{
	return a / (Dint)01000000;
}

static Dint
divdi_mem_2(p)
Dint *p;
{
	return *p / (Dint)2;
}

static Dint
divdi_mem_8(p)
Dint *p;
{
	return *p / (Dint)8;
}

static Dint
divdi_global_4(void)
{
	return gd_a / (Dint)4;
}

static Dint
divdi_volatile_16(void)
{
	Dint a;

	a = vgd_a;
	return a / (Dint)16;
}

static Dint
divdi_neg_num_2(a)
Dint a;
{
	return -a / (Dint)2;
}

static Dint
divdi_sum_8(a, b)
Dint a;
Dint b;
{
	return (a + b) / (Dint)8;
}

static Dint
divdi_diff_4(a, b)
Dint a;
Dint b;
{
	return (a - b) / (Dint)4;
}

static Dint
divdi_store_2(out, a)
Dint *out;
Dint a;
{
	Dint q;

	q = a / (Dint)2;
	*out = q;
	return q;
}

static Dint
divdi_store_64(out, a)
Dint *out;
Dint a;
{
	*out = a / (Dint)64;
	return *out;
}

static void
divdi_update_2(p)
Dint *p;
{
	*p = *p / (Dint)2;
}

static void
divdi_update_8(p)
Dint *p;
{
	*p /= (Dint)8;
}

static Dint
divdi_struct_4(p)
struct divdi3_pair *p;
{
	return p->a / (Dint)4;
}

static Dint
divdi_struct_sum_16(p)
struct divdi3_pair *p;
{
	return (p->a + p->b) / (Dint)16;
}

static Dint
divdi_struct_store(p, s)
struct divdi3_pair *p;
struct divdi3_slot *s;
{
	s->q2 = p->a / (Dint)2;
	s->q4 = p->b / (Dint)4;
	s->q8 = (p->a + p->b) / (Dint)8;
	return s->q2 + s->q4 + s->q8;
}

static Dint
divdi_array_2(a, i)
Dint *a;
int i;
{
	return a[i] / (Dint)2;
}

static Dint
divdi_array_32(a, i)
Dint *a;
int i;
{
	return a[i] / (Dint)32;
}

static int
divdi_branch_2(a)
Dint a;
{
	Dint q;

	q = a / (Dint)2;
	if (q < (Dint)0)
		return -1;
	if (q == (Dint)0)
		return 0;
	return 1;
}

static Dint
divdi_call_arg_4(a)
Dint a;
{
	extern void use_dint(Dint);
	Dint q;

	q = a / (Dint)4;
	use_dint(q);
	return q;
}

static Dint
divdi_chain(a)
Dint a;
{
	Dint q;

	q = a / (Dint)2;
	q = (q + (Dint)7) / (Dint)4;
	q = (q - (Dint)3) / (Dint)8;
	return q;
}

Dint
udvdi3(a, b, i)
Dint a;
Dint b;
int i;
{
	Dint tmp[4];

	tmp[0] = a;
	tmp[1] = b;
	tmp[2] = gd_arr[i & 3];
	tmp[3] = (Dint)-01000000;

	gd_b = divdi_store_2(&gd_b, a);
	divdi_update_2(&tmp[0]);
	divdi_update_8(&tmp[1]);

	return divdi_by_2(a)
	    + divdi_by_4(a)
	    + divdi_by_8(a)
	    + divdi_by_16(a)
	    + divdi_by_64(a)
	    + divdi_by_512(a)
	    + divdi_by_4096(a)
	    + divdi_by_262144(a)
	    + divdi_mem_2(&tmp[0])
	    + divdi_mem_8(&tmp[1])
	    + divdi_global_4()
	    + divdi_volatile_16()
	    + divdi_neg_num_2(b)
	    + divdi_sum_8(a, b)
	    + divdi_diff_4(a, b)
	    + divdi_store_64(&tmp[2], b)
	    + divdi_struct_4(&gd_pair)
	    + divdi_struct_sum_16(&gd_pair)
	    + divdi_struct_store(&gd_pair, &gd_slot)
	    + divdi_array_2(tmp, i & 3)
	    + divdi_array_32(gd_arr, i & 3)
	    + (Dint)divdi_branch_2(a)
	    + divdi_call_arg_4(b)
	    + divdi_chain(a + b);
}
