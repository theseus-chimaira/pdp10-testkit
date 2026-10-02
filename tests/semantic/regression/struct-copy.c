#include "insns.h"

/*
 * Struct and aggregate copy coverage.
 *
 * This test is intentionally ordinary C89.  It exercises the cases that
 * should become MOVE/DMOVE sequences for small aggregates and BLT or a
 * correct word-copy sequence for larger aggregates.  It also covers the
 * PDP-10-specific scalar layouts inside structs: QI, HI, 32-bit fields,
 * 6/7/8/9-bit byte objects, and nested aggregates.
 */

struct sc_one {
	Sint a;
};

struct sc_pair {
	Sint a;
	Sint b;
};

struct sc_quad {
	Sint a;
	Sint b;
	Sint c;
	Sint d;
};

struct sc_large {
	Sint w[20];
};

struct sc_dint {
	Dint a;
	Dint b;
};

struct sc_qi {
	char c;
	signed char sc;
	unsigned char uc;
	Qint q;
	sQint sq;
	uQint uq;
};

struct sc_half {
	Hint h;
	uHint uh;
	short16 s16;
	ushort16 u16;
	short18 s18;
	ushort18 u18;
	H2int hp;
	uH2int uhp;
};

struct sc_bytes {
	char6 c6;
	uchar6 u6;
	char7 c7;
	uchar7 u7;
	char8 c8;
	uchar8 u8;
	char9 c9;
	uchar9 u9;
};

struct sc_32 {
	int32 s32;
	uint32 u32;
	Sint tail;
};

struct sc_packed {
	char6 c6;
	char7 c7;
	char8 c8;
	char9 c9;
	short16 s16;
	short18 s18;
	int32 s32;
	Sint word;
} __attribute__ ((packed));

struct sc_arrays {
	Sint w[8];
	char c[16];
	unsigned char uc[16];
	Hint h[6];
};

struct sc_nested {
	struct sc_pair p;
	struct sc_qi q;
	struct sc_half h;
	struct sc_large l;
	Sint tail;
};

struct sc_ptrs {
	char *cp;
	unsigned char *ucp;
	Sint *sp;
	void *vp;
	int (*fn) (int);
};

union sc_union {
	struct sc_pair p;
	struct sc_large l;
	Dint d;
};

static struct sc_one g_one = { (Sint)1 };
static struct sc_pair g_pair = { (Sint)1, (Sint)2 };
static struct sc_quad g_quad = { (Sint)1, (Sint)2, (Sint)3, (Sint)4 };
static struct sc_large g_large = {
	{ (Sint)0, (Sint)1, (Sint)2, (Sint)3, (Sint)4,
	  (Sint)5, (Sint)6, (Sint)7, (Sint)8, (Sint)9,
	  (Sint)10, (Sint)11, (Sint)12, (Sint)13, (Sint)14,
	  (Sint)15, (Sint)16, (Sint)17, (Sint)18, (Sint)19 }
};
static struct sc_dint g_dint = { (Dint)1, (Dint)-2 };
static struct sc_qi g_qi = { 1, -2, 3, (Qint)4, (sQint)-5, (uQint)6 };
static struct sc_half g_half;
static struct sc_bytes g_bytes;
static struct sc_32 g_32;
static struct sc_packed g_packed;
static struct sc_arrays g_arrays;
static struct sc_nested g_nested;
static struct sc_ptrs g_ptrs;
static union sc_union g_union;

static volatile struct sc_pair vg_pair;
static volatile struct sc_large vg_large;
static volatile struct sc_qi vg_qi;

static int
sc_fn(x)
int x;
{
	return x + 1;
}

#define COPY_FUNCS(NAME, TYPE) \
static TYPE copy_arg_##NAME(x) TYPE x; { return x; } \
static TYPE copy_load_##NAME(p) TYPE *p; { return *p; } \
static void copy_store_##NAME(d, s) TYPE *d; TYPE *s; { *d = *s; } \
static TYPE copy_index_##NAME(a, i, j) TYPE *a; int i; int j; { a[i] = a[j]; return a[i]; } \
static TYPE copy_cond_##NAME(a, b, c) TYPE a; TYPE b; int c; { if (c) a = b; return a; }

COPY_FUNCS(one, struct sc_one)
COPY_FUNCS(pair, struct sc_pair)
COPY_FUNCS(quad, struct sc_quad)
COPY_FUNCS(large, struct sc_large)
COPY_FUNCS(dint, struct sc_dint)
COPY_FUNCS(qi, struct sc_qi)
COPY_FUNCS(half, struct sc_half)
COPY_FUNCS(bytes, struct sc_bytes)
COPY_FUNCS(sc32, struct sc_32)
COPY_FUNCS(packed, struct sc_packed)
COPY_FUNCS(arrays, struct sc_arrays)
COPY_FUNCS(nested, struct sc_nested)
COPY_FUNCS(ptrs, struct sc_ptrs)

static union sc_union
copy_union_arg(x)
union sc_union x;
{
	return x;
}

static void
copy_union_store(d, s)
union sc_union *d;
union sc_union *s;
{
	*d = *s;
}

static struct sc_pair
make_pair(a, b)
Sint a;
Sint b;
{
	struct sc_pair r;

	r.a = a;
	r.b = b;
	return r;
}

static struct sc_large
make_large(x)
Sint x;
{
	struct sc_large r;
	int i;

	for (i = 0; i < 20; i++)
		r.w[i] = x + (Sint)i;
	return r;
}

static struct sc_nested
make_nested(x)
Sint x;
{
	struct sc_nested r;

	r.p = make_pair(x, x + (Sint)1);
	r.q = g_qi;
	r.h = g_half;
	r.l = make_large(x + (Sint)2);
	r.tail = x + (Sint)3;
	return r;
}

static Sint
sum_pair(x)
struct sc_pair x;
{
	return x.a + x.b;
}

static Sint
sum_quad(x)
struct sc_quad x;
{
	return x.a + x.b + x.c + x.d;
}

static Sint
sum_large(x)
struct sc_large x;
{
	return x.w[0] + x.w[3] + x.w[7] + x.w[13] + x.w[19];
}

static Sint
sum_nested(x)
struct sc_nested x;
{
	return x.p.a + x.p.b + x.l.w[0] + x.l.w[19] + x.tail;
}

static void
copy_globals(void)
{
	g_one = copy_arg_one(g_one);
	g_pair = copy_arg_pair(g_pair);
	g_quad = copy_arg_quad(g_quad);
	g_large = copy_arg_large(g_large);
	g_dint = copy_arg_dint(g_dint);
	g_qi = copy_arg_qi(g_qi);
	g_half = copy_arg_half(g_half);
	g_bytes = copy_arg_bytes(g_bytes);
	g_32 = copy_arg_sc32(g_32);
	g_packed = copy_arg_packed(g_packed);
	g_arrays = copy_arg_arrays(g_arrays);
	g_nested = copy_arg_nested(g_nested);
	g_ptrs = copy_arg_ptrs(g_ptrs);
	g_union = copy_union_arg(g_union);
}

static void
copy_global_to_pointer(d)
struct sc_large *d;
{
	*d = g_large;
}

static void
copy_pointer_to_global(s)
struct sc_large *s;
{
	g_large = *s;
}

static void
copy_member_pair(d, s)
struct sc_nested *d;
struct sc_nested *s;
{
	d->p = s->p;
}

static void
copy_member_large(d, s)
struct sc_nested *d;
struct sc_nested *s;
{
	d->l = s->l;
}

static void
copy_member_qi(d, s)
struct sc_nested *d;
struct sc_nested *s;
{
	d->q = s->q;
}

static void
copy_adjacent_large(a)
struct sc_large *a;
{
	a[1] = a[0];
	a[2] = a[1];
}

static void
copy_adjacent_pair(a)
struct sc_pair *a;
{
	a[1] = a[0];
	a[2] = a[1];
}

static struct sc_pair
copy_from_volatile_pair(void)
{
	struct sc_pair r;

	r = vg_pair;
	return r;
}

static void
copy_to_volatile_pair(x)
struct sc_pair x;
{
	vg_pair = x;
}

static struct sc_large
copy_from_volatile_large(void)
{
	struct sc_large r;

	r = vg_large;
	return r;
}

static void
copy_to_volatile_large(x)
struct sc_large x;
{
	vg_large = x;
}

static struct sc_qi
copy_from_volatile_qi(void)
{
	struct sc_qi r;

	r = vg_qi;
	return r;
}

static void
copy_to_volatile_qi(x)
struct sc_qi x;
{
	vg_qi = x;
}

static void
copy_stack_small(x)
Sint x;
{
	struct sc_pair a;
	struct sc_pair b;

	a = make_pair(x, x + (Sint)1);
	b = a;
	g_pair = b;
}

static void
copy_stack_large(x)
Sint x;
{
	struct sc_large a;
	struct sc_large b;
	struct sc_large c;

	a = make_large(x);
	b = a;
	c = b;
	g_large = c;
}

static void
copy_stack_nested(x)
Sint x;
{
	struct sc_nested a;
	struct sc_nested b;

	a = make_nested(x);
	b = a;
	g_nested = b;
}

static void
copy_array_member(d, s, i, j)
struct sc_arrays *d;
struct sc_arrays *s;
int i;
int j;
{
	d->w[i & 7] = s->w[j & 7];
	d->c[i & 15] = s->c[j & 15];
	d->uc[i & 15] = s->uc[j & 15];
	d->h[i % 6] = s->h[j % 6];
}

static void
copy_ptr_struct(d, s)
struct sc_ptrs *d;
struct sc_ptrs *s;
{
	*d = *s;
}

static int
call_fn_from_copied_ptrs(p, x)
struct sc_ptrs *p;
int x;
{
	struct sc_ptrs q;

	q = *p;
	if (q.fn)
		return (*q.fn)(x);
	return x;
}

static void
init_ptrs(void)
{
	g_ptrs.cp = (char *)&g_qi.c;
	g_ptrs.ucp = (unsigned char *)&g_qi.uc;
	g_ptrs.sp = &g_pair.a;
	g_ptrs.vp = (void *)&g_large;
	g_ptrs.fn = sc_fn;
}

static int
sizeof_structs(void)
{
	return (int)sizeof(struct sc_one)
	    + (int)sizeof(struct sc_pair)
	    + (int)sizeof(struct sc_quad)
	    + (int)sizeof(struct sc_large)
	    + (int)sizeof(struct sc_dint)
	    + (int)sizeof(struct sc_qi)
	    + (int)sizeof(struct sc_half)
	    + (int)sizeof(struct sc_bytes)
	    + (int)sizeof(struct sc_32)
	    + (int)sizeof(struct sc_packed)
	    + (int)sizeof(struct sc_arrays)
	    + (int)sizeof(struct sc_nested)
	    + (int)sizeof(struct sc_ptrs)
	    + (int)sizeof(union sc_union);
}

Sint
use_struct_copy(x, i)
Sint x;
int i;
{
	struct sc_large la[3];
	struct sc_pair pa[3];
	struct sc_nested n;
	struct sc_ptrs p;
	union sc_union u;
	Sint r;

	copy_globals();
	copy_stack_small(x);
	copy_stack_large(x + (Sint)1);
	copy_stack_nested(x + (Sint)2);

	la[0] = make_large(x);
	la[1] = copy_load_large(&g_large);
	la[2] = copy_cond_large(la[0], la[1], i);
	copy_store_large(&la[1], &la[2]);
	copy_adjacent_large(la);

	pa[0] = make_pair(x, x + (Sint)3);
	pa[1] = copy_load_pair(&g_pair);
	pa[2] = copy_index_pair(pa, 0, 1);
	copy_adjacent_pair(pa);

	n = make_nested(x + (Sint)4);
	copy_member_pair(&g_nested, &n);
	copy_member_large(&g_nested, &n);
	copy_member_qi(&g_nested, &n);
	copy_array_member(&g_arrays, &g_arrays, i, i + 1);

	init_ptrs();
	p = g_ptrs;
	copy_ptr_struct(&g_ptrs, &p);

	u.l = la[0];
	copy_union_store(&g_union, &u);

	copy_global_to_pointer(&la[0]);
	copy_pointer_to_global(&la[1]);
	copy_to_volatile_pair(pa[0]);
	copy_to_volatile_large(la[0]);
	copy_to_volatile_qi(g_qi);

	r = sum_pair(copy_from_volatile_pair());
	r += sum_large(copy_from_volatile_large());
	r += copy_from_volatile_qi().q;
	r += sum_pair(copy_arg_pair(pa[0]));
	r += sum_quad(copy_arg_quad(g_quad));
	r += sum_large(copy_arg_large(la[2]));
	r += sum_nested(copy_arg_nested(n));
	r += call_fn_from_copied_ptrs(&g_ptrs, (int)x);
	r += (Sint)sizeof_structs();
	return r;
}
