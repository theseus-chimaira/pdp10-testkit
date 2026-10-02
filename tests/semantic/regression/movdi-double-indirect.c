#include "insns.h"

/*
 * DImode move coverage for double-word integer loads/stores through
 * pointers and indirect pointers.
 *
 * This test is deliberately about moving Dint/uDint objects, not about
 * DImode arithmetic.  Avoid division, multiplication, and long-long
 * operator coverage here; those belong in the pattern/libgcc tests.
 */

struct movdi_pair {
	Dint a;
	Dint b;
};

struct movdi_ptr_slot {
	Dint *p;
	Dint value;
};

struct umovdi_pair {
	uDint a;
	uDint b;
};

static Dint gd_a = (Dint)012345;
static Dint gd_b;
static Dint gd_arr[4] = {
	(Dint)1,
	(Dint)2,
	(Dint)3,
	(Dint)4
};
static volatile Dint vgd_a = (Dint)-0123;
static volatile Dint vgd_b;

static uDint ugd_a = (uDint)012345;
static uDint ugd_b;
static volatile uDint vugd_a = (uDint)0777777;
static volatile uDint vugd_b;

static struct movdi_pair gd_pair = { (Dint)010, (Dint)020 };
static struct movdi_ptr_slot gd_slot = { &gd_a, (Dint)0 };
static struct umovdi_pair ugd_pair = { (uDint)030, (uDint)040 };

Dint
movdi(dummy, p)
Tint dummy;
Dint *p;
{
	return *p;
}

static Dint
movdi_arg(dummy, x)
Tint dummy;
Dint x;
{
	Dint y;

	y = x;
	return y;
}

static Dint
movdi_load(p)
Dint *p;
{
	Dint x;

	x = *p;
	return x;
}

static void
movdi_store(p, x)
Dint *p;
Dint x;
{
	*p = x;
}

static Dint
movdi_copy(d, s)
Dint *d;
Dint *s;
{
	Dint x;

	x = *s;
	*d = x;
	return *d;
}

static Dint
movdi_double_indirect(pp)
Dint **pp;
{
	Dint x;

	x = **pp;
	return x;
}

static void
movdi_store_double_indirect(pp, x)
Dint **pp;
Dint x;
{
	**pp = x;
}

static Dint
movdi_struct_load(p)
struct movdi_pair *p;
{
	Dint x;

	x = p->a;
	return x;
}

static void
movdi_struct_store(p, x)
struct movdi_pair *p;
Dint x;
{
	p->b = x;
}

static Dint
movdi_struct_copy(d, s)
struct movdi_pair *d;
struct movdi_pair *s;
{
	d->a = s->b;
	d->b = s->a;
	return d->a;
}

static Dint
movdi_array_load(p, i)
Dint *p;
int i;
{
	Dint x;

	x = p[i];
	return x;
}

static void
movdi_array_store(p, i, x)
Dint *p;
int i;
Dint x;
{
	p[i] = x;
}

static Dint
movdi_global_load()
{
	Dint x;

	x = gd_a;
	return x;
}

static void
movdi_global_store(x)
Dint x;
{
	gd_b = x;
}

static Dint
movdi_volatile_load()
{
	Dint x;

	x = vgd_a;
	return x;
}

static void
movdi_volatile_store(x)
Dint x;
{
	vgd_b = x;
}

static Dint
movdi_conditional(c, a, b)
int c;
Dint a;
Dint b;
{
	Dint x;

	if (c)
		x = a;
	else
		x = b;
	return x;
}

static Dint
movdi_slot_load(sp)
struct movdi_ptr_slot *sp;
{
	Dint x;

	x = *sp->p;
	sp->value = x;
	return sp->value;
}

static void
movdi_slot_store(sp, x)
struct movdi_ptr_slot *sp;
Dint x;
{
	*sp->p = x;
	sp->value = x;
}

static Dint
movdi_call_arg(x)
Dint x;
{
	extern void use_dint(Dint);

	use_dint(x);
	return x;
}

static Dint
movdi_call_return(x)
Dint x;
{
	extern Dint ret_dint(Dint);

	return ret_dint(x);
}

static uDint
umovdi_arg(x)
uDint x;
{
	uDint y;

	y = x;
	return y;
}

static uDint
umovdi_load(p)
uDint *p;
{
	uDint x;

	x = *p;
	return x;
}

static void
umovdi_store(p, x)
uDint *p;
uDint x;
{
	*p = x;
}

static uDint
umovdi_global_load()
{
	uDint x;

	x = ugd_a;
	return x;
}

static uDint
umovdi_volatile_load()
{
	uDint x;

	x = vugd_a;
	return x;
}

static void
umovdi_volatile_store(x)
uDint x;
{
	vugd_b = x;
}

static uDint
umovdi_struct_load(p)
struct umovdi_pair *p;
{
	uDint x;

	x = p->a;
	return x;
}

Dint
use_movdi_double_indirect(dummy, p, pp, sp, i)
Tint dummy;
Dint *p;
Dint **pp;
struct movdi_pair *sp;
int i;
{
	Dint local[3];
	Dint x;
	Dint *lp;
	struct movdi_pair pair;
	struct movdi_ptr_slot slot;

	local[0] = gd_a;
	local[1] = *p;
	local[2] = gd_arr[i & 1];
	lp = &local[1];

	pair.a = local[0];
	pair.b = local[1];
	slot.p = lp;
	slot.value = local[2];

	x = movdi(dummy, p);
	movdi_global_store(x);
	x = movdi_arg(dummy, x);
	x = movdi_load(lp);
	movdi_store(&local[2], x);
	x = movdi_copy(&gd_b, &local[2]);
	x = movdi_double_indirect(pp);
	movdi_store_double_indirect(&slot.p, x);
	x = movdi_struct_load(sp);
	movdi_struct_store(&pair, x);
	x = movdi_struct_copy(&pair, &gd_pair);
	x = movdi_array_load(gd_arr, i & 3);
	movdi_array_store(gd_arr, (i + 1) & 3, x);
	x = movdi_global_load();
	x = movdi_volatile_load();
	movdi_volatile_store(x);
	x = movdi_conditional(i, local[0], local[1]);
	x = movdi_slot_load(&gd_slot);
	movdi_slot_store(&slot, x);
	x = movdi_call_arg(x);
	x = movdi_call_return(x);
	return x;
}

uDint
use_umovdi_double_indirect(p, i)
uDint *p;
int i;
{
	uDint local[2];
	uDint x;

	local[0] = ugd_a;
	local[1] = *p;
	x = umovdi_arg(local[i & 1]);
	x = umovdi_load(&local[0]);
	umovdi_store(&ugd_b, x);
	x = umovdi_global_load();
	x = umovdi_volatile_load();
	umovdi_volatile_store(x);
	x = umovdi_struct_load(&ugd_pair);
	return x;
}
