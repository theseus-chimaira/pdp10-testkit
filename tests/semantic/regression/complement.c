#include "insns.h"

/*
 * Bitwise complement and arithmetic-negation equivalence coverage.
 *
 * The original smoke test only used three algebraic forms:
 *   ~x + 1
 *   -x - 1
 *   -(x + 1)
 *
 * Keep those, but also cover plain complement, memory operands, stores,
 * unsigned variants, sub-word scalar promotion, constants, branches, and
 * values reused through volatile memory.
 */

static Sint gs0;
static Sint gs1 = 1;
static Sint gs2 = -1;
static uSint gu0;
static volatile Sint vgs;
static volatile uSint vgu;

static Qint gq;
static uQint guq;
static Hint gh;
static uHint guh;

struct complement_words {
	Sint a;
	Sint b;
	uSint u;
	Qint q;
	uQint uq;
	Hint h;
	uHint uh;
};

static struct complement_words gw;

static void
clobber(x)
void *x;
{
	vgs = (Sint)(unsigned long)x;
}

static Sint neg(AC)
Sint AC;
{
	return ~AC + 1;
}

static Sint not(AC)
Sint AC;
{
	return -AC - 1;
}

static Sint not2(AC)
Sint AC;
{
	return -(AC + 1);
}

static Sint
plain_complement(x)
Sint x;
{
	return ~x;
}

static Sint
plain_negative(x)
Sint x;
{
	return -x;
}

static Sint
complement_plus_one(x)
Sint x;
{
	return ~x + 1;
}

static Sint
negative_minus_one(x)
Sint x;
{
	return -x - 1;
}

static Sint
negative_parenthesized(x)
Sint x;
{
	return -(x + 1);
}

static Sint
complement_of_sum(a, b)
Sint a;
Sint b;
{
	return ~(a + b);
}

static Sint
complement_of_difference(a, b)
Sint a;
Sint b;
{
	return ~(a - b);
}

static Sint
complement_after_shift(x, n)
Sint x;
int n;
{
	return ~(x << (n & 7));
}

static Sint
complement_before_shift(x, n)
Sint x;
int n;
{
	return (~x) >> (n & 7);
}

static uSint
u_plain_complement(x)
uSint x;
{
	return ~x;
}

static uSint
u_complement_plus_one(x)
uSint x;
{
	return ~x + 1;
}

static uSint
u_negative_minus_one(x)
uSint x;
{
	return -x - 1;
}

static uSint
u_xor_all_ones(x)
uSint x;
{
	return x ^ (uSint)-1;
}

static Sint
mem_complement(p)
Sint *p;
{
	return ~*p;
}

static uSint
umem_complement(p)
uSint *p;
{
	return ~*p;
}

static Sint
volatile_mem_complement()
{
	return ~vgs;
}

static uSint
volatile_umem_complement()
{
	return ~vgu;
}

static Sint
store_complement(p, x)
Sint *p;
Sint x;
{
	*p = ~x;
	return *p;
}

static Sint
store_negative(p, x)
Sint *p;
Sint x;
{
	*p = -x;
	return *p;
}

static Sint
store_complement_plus_one(p, x)
Sint *p;
Sint x;
{
	*p = ~x + 1;
	return *p;
}

static Sint
update_complement(p)
Sint *p;
{
	*p = ~*p;
	return *p;
}

static Sint
update_negative(p)
Sint *p;
{
	*p = -*p;
	return *p;
}

static Sint
struct_complement(s)
struct complement_words *s;
{
	s->b = ~s->a;
	s->u = ~s->u;
	return s->b + (Sint)s->u;
}

static Sint
struct_negative_forms(s)
struct complement_words *s;
{
	s->a = ~s->b + 1;
	s->b = -s->a - 1;
	return s->a + s->b;
}

static Sint
q_complement(x)
Qint x;
{
	return (Sint)~x;
}

static Sint
uq_complement(x)
uQint x;
{
	return (Sint)~x;
}

static Sint
h_complement(x)
Hint x;
{
	return (Sint)~x;
}

static Sint
uh_complement(x)
uHint x;
{
	return (Sint)~x;
}

static Sint
q_mem_complement(p)
Qint *p;
{
	return (Sint)~*p;
}

static Sint
h_mem_complement(p)
Hint *p;
{
	return (Sint)~*p;
}

static Sint
subword_store_complement(s, q, h)
struct complement_words *s;
Qint q;
Hint h;
{
	s->q = ~q;
	s->uq = ~((uQint)q);
	s->h = ~h;
	s->uh = ~((uHint)h);
	return (Sint)s->q + (Sint)s->uq + (Sint)s->h + (Sint)s->uh;
}

static Sint
complement_zero()
{
	return ~((Sint)0);
}

static Sint
complement_one()
{
	return ~((Sint)1);
}

static Sint
complement_minus_one()
{
	return ~((Sint)-1);
}

static uSint
complement_unsigned_zero()
{
	return ~((uSint)0);
}

static Sint
branch_on_complement_zero(x)
Sint x;
{
	if (~x == 0)
		return 11;
	return 22;
}

static Sint
branch_on_complement_nonzero(x)
Sint x;
{
	if (~x != 0)
		return 33;
	return 44;
}

static Sint
branch_on_complement_sign(x)
Sint x;
{
	if (~x < 0)
		return 55;
	return 66;
}

static Sint
branch_on_complement_mask(x, mask)
Sint x;
Sint mask;
{
	if ((~x & mask) != 0)
		return 77;
	return 0100;
}

static Sint
select_complement(cond, a, b)
int cond;
Sint a;
Sint b;
{
	return cond ? ~a : ~b;
}

static Sint
mixed_complement(a, b, p)
Sint a;
Sint b;
Sint *p;
{
	Sint x;

	x = ~a;
	*p = ~b + 1;
	return x + *p + (-a - 1) + -(b + 1);
}

static Sint
force_globals(x)
Sint x;
{
	gs0 = ~x;
	gs1 = ~gs0 + 1;
	gs2 = -gs1 - 1;
	gu0 = ~((uSint)x);
	gq = (Qint)~x;
	guq = (uQint)~((uSint)x);
	gh = (Hint)~x;
	guh = (uHint)~((uSint)x);
	clobber(&gw);
	return gs0 + gs1 + gs2 + (Sint)gu0
	    + (Sint)gq + (Sint)guq + (Sint)gh + (Sint)guh;
}

static Sint
use_complement_all(a, b, n)
Sint a;
Sint b;
int n;
{
	Sint t;

	t = neg(a);
	t += not(b);
	t += not2(a + b);
	t += plain_complement(a);
	t += plain_negative(b);
	t += complement_plus_one(a);
	t += negative_minus_one(b);
	t += negative_parenthesized(a);
	t += complement_of_sum(a, b);
	t += complement_of_difference(a, b);
	t += complement_after_shift(a, n);
	t += complement_before_shift(b, n);
	t += (Sint)u_plain_complement((uSint)a);
	t += (Sint)u_complement_plus_one((uSint)b);
	t += (Sint)u_negative_minus_one((uSint)a);
	t += (Sint)u_xor_all_ones((uSint)b);
	t += mem_complement(&gs0);
	t += (Sint)umem_complement(&gu0);
	t += volatile_mem_complement();
	t += (Sint)volatile_umem_complement();
	t += store_complement(&gs0, a);
	t += store_negative(&gs1, b);
	t += store_complement_plus_one(&gs2, a + b);
	t += update_complement(&gs0);
	t += update_negative(&gs1);
	t += struct_complement(&gw);
	t += struct_negative_forms(&gw);
	t += q_complement((Qint)a);
	t += uq_complement((uQint)b);
	t += h_complement((Hint)a);
	t += uh_complement((uHint)b);
	t += q_mem_complement(&gq);
	t += h_mem_complement(&gh);
	t += subword_store_complement(&gw, (Qint)a, (Hint)b);
	t += complement_zero();
	t += complement_one();
	t += complement_minus_one();
	t += (Sint)complement_unsigned_zero();
	t += branch_on_complement_zero(a);
	t += branch_on_complement_nonzero(b);
	t += branch_on_complement_sign(a + b);
	t += branch_on_complement_mask(a, b);
	t += select_complement(n & 1, a, b);
	t += mixed_complement(a, b, &gs0);
	t += force_globals(t);
	return t;
}
