#include "insns.h"


/*
 * MOVN/MOVNM/MOVNS coverage.
 *
 * This file intentionally keeps the Sfloat cases active.  Floating point
 * is normally outside the first PDP-6/KA10 test pass, but MOVN is also a
 * normal sign-change operation for single floating values.  These cases
 * are useful as compiler reaction tests: they should either compile into
 * sane MOVN-family output or expose the current FP limitation clearly.
 */

static Sint gs_a = (Sint)012345;
static Sint gs_b = (Sint)-0777;
static volatile Sint vgs_a = (Sint)-0123;

static Sfloat gf_a = (Sfloat)1.25;
static Sfloat gf_b = (Sfloat)-2.5;
static volatile Sfloat vgf_a = (Sfloat)-3.75;

struct movn_i_slot {
	Sint x;
	Sint y;
};

struct movn_f_slot {
	Sfloat x;
	Sfloat y;
};

static struct movn_i_slot gi_slot = { (Sint)010, (Sint)-020 };
static struct movn_f_slot gf_slot = { (Sfloat)4.5, (Sfloat)-6.25 };

static Sint
movn_reg(a, e)
Sint a;
Sint e;
{
	(void)a;
	return -e;
}

static Sint
movn_mem(a, e)
Sint a;
Sint *e;
{
	(void)a;
	return -*e;
}

static Sint
movni_small(a)
Sint a;
{
	return -(a + (Sint)1);
}

static Sint
movnm_store(a, e)
Sint a;
Sint *e;
{
	*e = -a;
	return *e;
}

static Sint
movns_self(e)
Sint *e;
{
	*e = -*e;
	return *e;
}

static Sint
movn_global(void)
{
	return -gs_a + -gs_b;
}

static Sint
movn_volatile(void)
{
	Sint x;

	x = vgs_a;
	return -x;
}

static Sint
movn_struct(p)
struct movn_i_slot *p;
{
	p->x = -p->x;
	p->y = -p->y;
	return p->x + p->y;
}

static Sint
movn_branch(a)
Sint a;
{
	Sint x;

	x = -a;
	if (x < (Sint)0)
		return (Sint)-1;
	if (x == (Sint)0)
		return (Sint)0;
	return (Sint)1;
}

static Sfloat
fmovn_reg(a, e)
Sfloat a;
Sfloat e;
{
	(void)a;
	return -e;
}

static Sfloat
fmovn_mem(a, e)
Sfloat a;
Sfloat *e;
{
	(void)a;
	return -*e;
}

static Sfloat
fmovnm_store(a, e)
Sfloat a;
Sfloat *e;
{
	*e = -a;
	return *e;
}

static Sfloat
fmovns_self(e)
Sfloat *e;
{
	*e = -*e;
	return *e;
}

static Sfloat
fmovn_global(void)
{
	return -gf_a + -gf_b;
}

static Sfloat
fmovn_volatile(void)
{
	Sfloat x;

	x = vgf_a;
	return -x;
}

static Sfloat
fmovn_struct(p)
struct movn_f_slot *p;
{
	p->x = -p->x;
	p->y = -p->y;
	return p->x + p->y;
}

BOTH (movns_both_int, -*b)
BOTH1 (Sfloat, movns_both_float, -*b)

Sint
use_movn_int(a, b)
Sint a;
Sint b;
{
	Sint t;

	t = b;
	gs_a = movnm_store(a, &gs_a);
	movns_self(&t);
	return movn_reg(a, b)
	    + movn_mem(a, &t)
	    + movni_small(a)
	    + movn_global()
	    + movn_volatile()
	    + movn_struct(&gi_slot)
	    + movn_branch(a)
	    + movns_both_intaa(a, &t)
	    + movns_both_intbb(a, &t);
}

Sfloat
umvflt(a, b)
Sfloat a;
Sfloat b;
{
	Sfloat t;

	t = b;
	gf_a = fmovnm_store(a, &gf_a);
	fmovns_self(&t);
	return fmovn_reg(a, b)
	    + fmovn_mem(a, &t)
	    + fmovn_global()
	    + fmovn_volatile()
	    + fmovn_struct(&gf_slot)
	    + movns_both_floataa(a, &t)
	    + movns_both_floatbb(a, &t);
}
