#include "insns.h"

/*
 * Struct pointer and component-offset regression coverage.
 *
 * The original bug shape is small structures containing word, halfword,
 * and byte-sized members.  The test takes the address of stack structs,
 * passes struct pointers to an opaque call, and reads/writes members
 * through struct pointers.  This stresses the PDP-10 backend paths that
 * compute field addresses and byte/halfword component offsets.
 */

extern void scalar_memory_forms();
extern void use_int(int);
extern void use_ptr(void *);

struct A { int a; short b; };
struct B { int a; char b; };
struct C { short a; char b; };
struct D { char a; char b; };

struct E { Sint a; Qint b; Hint c; };
struct F { Qint a; Sint b; Qint c; };
struct G { char6 a; char7 b; char8 c; char9 d; Sint e; };
struct H { short16 a; short18 b; int32 c; Sint d; };
struct I { unsigned char a; uQint b; uHint c; uSint d; };
struct J { char a; Sint b; char c; } __attribute__ ((packed));

struct Inner {
	Qint q;
	Hint h;
};

struct Outer {
	Sint head;
	struct Inner inner;
	Qint tail;
};

struct Arr {
	Sint head;
	Qint q[3];
	Hint h[2];
	char c[4];
};

struct Bits {
	unsigned int a : 18;
	int b : 9;
	unsigned int c : 9;
	Sint d;
};

static struct A ga;
static struct B gb;
static struct C gc;
static struct D gd;
static struct E ge;
static struct F gf;
static struct G gg;
static struct H gh;
static struct I gi;
static struct J gj;
static struct Outer go;
static struct Arr garr;
static struct Bits gbits;

static volatile struct A vga;
static volatile struct E vge;
static volatile struct Arr vgarr;

#define POINTER(S) \
static void ptr_ ## S (void) \
{ \
	struct S p; \
	scalar_memory_forms(&p); \
}

#define FIELD_ADDR(S, F, T) \
static T *addr_ ## S ## _ ## F (struct S *p) \
{ \
	return &p->F; \
} \
static void stack_addr_ ## S ## _ ## F (void) \
{ \
	struct S p; \
	scalar_memory_forms(&p.F); \
}

#define FIELD_RW(S, F, T) \
static T load_ ## S ## _ ## F (struct S *p) \
{ \
	return p->F; \
} \
static void store_ ## S ## _ ## F (struct S *p, T x) \
{ \
	p->F = x; \
} \
static T update_ ## S ## _ ## F (struct S *p, T x) \
{ \
	p->F = (T)(p->F + x); \
	return p->F; \
}

#define FIELD(S, F, T) FIELD_RW(S, F, T) FIELD_ADDR(S, F, T)

POINTER(A)
FIELD(A, a, int)
FIELD(A, b, short)

POINTER(B)
FIELD(B, a, int)
FIELD(B, b, char)

POINTER(C)
FIELD(C, a, short)
FIELD(C, b, char)

POINTER(D)
FIELD(D, a, char)
FIELD(D, b, char)

POINTER(E)
FIELD(E, a, Sint)
FIELD(E, b, Qint)
FIELD(E, c, Hint)

POINTER(F)
FIELD(F, a, Qint)
FIELD(F, b, Sint)
FIELD(F, c, Qint)

POINTER(G)
FIELD(G, a, char6)
FIELD(G, b, char7)
FIELD(G, c, char8)
FIELD(G, d, char9)
FIELD(G, e, Sint)

POINTER(H)
FIELD(H, a, short16)
FIELD(H, b, short18)
FIELD(H, c, int32)
FIELD(H, d, Sint)

POINTER(I)
FIELD(I, a, unsigned char)
FIELD(I, b, uQint)
FIELD(I, c, uHint)
FIELD(I, d, uSint)

POINTER(J)
FIELD(J, a, char)
FIELD(J, b, Sint)
FIELD(J, c, char)

POINTER(Outer)
FIELD(Outer, head, Sint)
FIELD(Outer, tail, Qint)

POINTER(Arr)
FIELD(Arr, head, Sint)

POINTER(Bits)
FIELD(Bits, d, Sint)

static Qint
load_outer_q(p)
struct Outer *p;
{
	return p->inner.q;
}

static void
store_outer_q(p, x)
struct Outer *p;
Qint x;
{
	p->inner.q = x;
}

static Hint
load_outer_h(p)
struct Outer *p;
{
	return p->inner.h;
}

static void
store_outer_h(p, x)
struct Outer *p;
Hint x;
{
	p->inner.h = x;
}

static Qint *
addr_outer_q(p)
struct Outer *p;
{
	return &p->inner.q;
}

static Hint *
addr_outer_h(p)
struct Outer *p;
{
	return &p->inner.h;
}

static void
stack_outer_fields(void)
{
	struct Outer p;

	scalar_memory_forms(&p.inner);
	scalar_memory_forms(&p.inner.q);
	scalar_memory_forms(&p.inner.h);
	scalar_memory_forms(&p.tail);
}

static Qint
load_arr_q(p, i)
struct Arr *p;
int i;
{
	return p->q[i];
}

static void
store_arr_q(p, i, x)
struct Arr *p;
int i;
Qint x;
{
	p->q[i] = x;
}

static Hint
load_arr_h(p, i)
struct Arr *p;
int i;
{
	return p->h[i];
}

static void
store_arr_h(p, i, x)
struct Arr *p;
int i;
Hint x;
{
	p->h[i] = x;
}

static char
load_arr_c(p, i)
struct Arr *p;
int i;
{
	return p->c[i];
}

static void
store_arr_c(p, i, x)
struct Arr *p;
int i;
char x;
{
	p->c[i] = x;
}

static Qint *
addr_arr_q(p, i)
struct Arr *p;
int i;
{
	return &p->q[i];
}

static Hint *
addr_arr_h(p, i)
struct Arr *p;
int i;
{
	return &p->h[i];
}

static char *
addr_arr_c(p, i)
struct Arr *p;
int i;
{
	return &p->c[i];
}

static int
diff_arr_q(p)
struct Arr *p;
{
	return &p->q[2] - &p->q[0];
}

static int
diff_arr_h(p)
struct Arr *p;
{
	return &p->h[1] - &p->h[0];
}

static int
diff_arr_c(p)
struct Arr *p;
{
	return &p->c[3] - &p->c[0];
}

static unsigned int
load_bits_a(p)
struct Bits *p;
{
	return p->a;
}

static int
load_bits_b(p)
struct Bits *p;
{
	return p->b;
}

static unsigned int
load_bits_c(p)
struct Bits *p;
{
	return p->c;
}

static void
store_bits(p, a, b, c)
struct Bits *p;
unsigned int a;
int b;
unsigned int c;
{
	p->a = a;
	p->b = b;
	p->c = c;
}

static int
load_global_members(void)
{
	return ga.a + (int)ga.b
	    + gb.a + (int)gb.b
	    + (int)gc.a + (int)gc.b
	    + (int)gd.a + (int)gd.b
	    + ge.a + ge.b + ge.c
	    + gf.a + gf.b + gf.c
	    + gg.a + gg.b + gg.c + gg.d + gg.e
	    + gh.a + gh.b + gh.c + gh.d
	    + (int)gi.a + (int)gi.b + (int)gi.c + (int)gi.d
	    + (int)gj.a + gj.b + (int)gj.c
	    + go.head + go.inner.q + go.inner.h + go.tail
	    + garr.head + garr.q[1] + garr.h[1] + garr.c[1]
	    + (int)gbits.a + gbits.b + (int)gbits.c + gbits.d;
}

static int
load_volatile_members(void)
{
	return vga.a + (int)vga.b
	    + vge.a + vge.b + vge.c
	    + vgarr.head + vgarr.q[0] + vgarr.h[0] + vgarr.c[0];
}

static void
store_global_members(x)
int x;
{
	ga.a = x;
	ga.b = (short)(x + 1);
	gb.a = x + 2;
	gb.b = (char)(x + 3);
	gc.a = (short)(x + 4);
	gc.b = (char)(x + 5);
	gd.a = (char)(x + 6);
	gd.b = (char)(x + 7);
	ge.a = (Sint)(x + 8);
	ge.b = (Qint)(x + 9);
	ge.c = (Hint)(x + 10);
	gf.a = (Qint)(x + 11);
	gf.b = (Sint)(x + 12);
	gf.c = (Qint)(x + 13);
	gg.a = (char6)(x + 14);
	gg.b = (char7)(x + 15);
	gg.c = (char8)(x + 16);
	gg.d = (char9)(x + 17);
	gg.e = (Sint)(x + 18);
	gh.a = (short16)(x + 19);
	gh.b = (short18)(x + 20);
	gh.c = (int32)(x + 21);
	gh.d = (Sint)(x + 22);
	gi.a = (unsigned char)(x + 23);
	gi.b = (uQint)(x + 24);
	gi.c = (uHint)(x + 25);
	gi.d = (uSint)(x + 26);
	gj.a = (char)(x + 27);
	gj.b = (Sint)(x + 28);
	gj.c = (char)(x + 29);
}

static int
stack_component_mix(x)
int x;
{
	struct A a;
	struct B b;
	struct C c;
	struct D d;
	struct E e;
	struct F f;
	struct Arr ar;

	a.a = x;
	a.b = (short)(x + 1);
	b.a = x + 2;
	b.b = (char)(x + 3);
	c.a = (short)(x + 4);
	c.b = (char)(x + 5);
	d.a = (char)(x + 6);
	d.b = (char)(x + 7);
	e.a = (Sint)(x + 8);
	e.b = (Qint)(x + 9);
	e.c = (Hint)(x + 10);
	f.a = (Qint)(x + 11);
	f.b = (Sint)(x + 12);
	f.c = (Qint)(x + 13);
	ar.head = (Sint)(x + 14);
	ar.q[0] = (Qint)(x + 15);
	ar.q[1] = (Qint)(x + 16);
	ar.q[2] = (Qint)(x + 17);
	ar.h[0] = (Hint)(x + 18);
	ar.h[1] = (Hint)(x + 19);
	ar.c[0] = (char)(x + 20);
	ar.c[1] = (char)(x + 21);
	ar.c[2] = (char)(x + 22);
	ar.c[3] = (char)(x + 23);

	scalar_memory_forms(&a);
	scalar_memory_forms(&a.b);
	scalar_memory_forms(&b.b);
	scalar_memory_forms(&c.a);
	scalar_memory_forms(&c.b);
	scalar_memory_forms(&d.a);
	scalar_memory_forms(&d.b);
	scalar_memory_forms(&e.b);
	scalar_memory_forms(&e.c);
	scalar_memory_forms(&f.a);
	scalar_memory_forms(&f.c);
	scalar_memory_forms(&ar.q[1]);
	scalar_memory_forms(&ar.h[1]);
	scalar_memory_forms(&ar.c[3]);

	return a.a + (int)a.b + b.a + (int)b.b
	    + (int)c.a + (int)c.b + (int)d.a + (int)d.b
	    + e.a + e.b + e.c + f.a + f.b + f.c
	    + ar.head + ar.q[0] + ar.q[1] + ar.q[2]
	    + ar.h[0] + ar.h[1]
	    + ar.c[0] + ar.c[1] + ar.c[2] + ar.c[3];
}

static int
component_branch(p, x)
struct E *p;
int x;
{
	if (p->b < (Qint)x)
		return -1;
	if (p->c == (Hint)x)
		return 0;
	return 1;
}

static void
component_call(p)
struct Arr *p;
{
	use_int(p->head);
	use_int(p->q[1]);
	use_int(p->h[1]);
	use_int(p->c[1]);
	use_ptr(&p->q[2]);
	use_ptr(&p->h[0]);
	use_ptr(&p->c[3]);
}

int
use_struct_ptr_bug(x)
int x;
{
	struct E le;
	struct Outer lo;
	struct Arr la;
	struct Bits lb;

	store_global_members(x);
	le.a = (Sint)x;
	le.b = (Qint)(x + 1);
	le.c = (Hint)(x + 2);
	lo.head = (Sint)(x + 3);
	lo.inner.q = (Qint)(x + 4);
	lo.inner.h = (Hint)(x + 5);
	lo.tail = (Qint)(x + 6);
	la.head = (Sint)(x + 7);
	la.q[0] = (Qint)(x + 8);
	la.q[1] = (Qint)(x + 9);
	la.q[2] = (Qint)(x + 10);
	la.h[0] = (Hint)(x + 11);
	la.h[1] = (Hint)(x + 12);
	la.c[0] = (char)(x + 13);
	la.c[1] = (char)(x + 14);
	la.c[2] = (char)(x + 15);
	la.c[3] = (char)(x + 16);
	store_bits(&lb, (unsigned int)x, x + 1, (unsigned int)(x + 2));
	store_outer_q(&lo, (Qint)(x + 17));
	store_outer_h(&lo, (Hint)(x + 18));
	store_arr_q(&la, 1, (Qint)(x + 19));
	store_arr_h(&la, 1, (Hint)(x + 20));
	store_arr_c(&la, 2, (char)(x + 21));
	component_call(&la);

	return load_global_members()
	    + load_volatile_members()
	    + stack_component_mix(x)
	    + load_E_b(&le) + load_E_c(&le)
	    + update_E_b(&le, (Qint)1)
	    + update_E_c(&le, (Hint)1)
	    + load_outer_q(&lo) + load_outer_h(&lo)
	    + load_arr_q(&la, 1) + load_arr_h(&la, 1) + load_arr_c(&la, 2)
	    + diff_arr_q(&la) + diff_arr_h(&la) + diff_arr_c(&la)
	    + (addr_E_b(&le) == addr_outer_q(&lo))
	    + (addr_E_c(&le) == addr_outer_h(&lo))
	    + (addr_arr_q(&la, 0) != addr_arr_q(&la, 2))
	    + (addr_arr_h(&la, 0) != addr_arr_h(&la, 1))
	    + (addr_arr_c(&la, 0) != addr_arr_c(&la, 3))
	    + load_bits_a(&lb) + load_bits_b(&lb) + load_bits_c(&lb)
	    + component_branch(&le, x);
}
