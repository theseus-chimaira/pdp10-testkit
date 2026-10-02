#include "insns.h"

/*
 * Store coverage for left-justified 32-bit fields in 36-bit words.
 *
 * PDP-10 32-bit scalar fields leave four low bits in the containing
 * word.  Some layouts make those low bits junk, so the store may be
 * lowered as a shift plus a word store.  Other layouts name or use the
 * low four bits, so the store must preserve them, typically by using a
 * deposit-byte/bitfield sequence.
 *
 * This file intentionally keeps to ordinary C.  It covers signed and
 * unsigned 32-bit objects, bit-field layouts where the low four bits are
 * junk or live, arrays, globals, volatile memory, and update forms.
 */

#define BITS 32
#define JUNK_BITS (36 - BITS)

/* An int32 is always followed by four junk bits. */
struct A {
	int32 x;
	int y;
};

/* A uint32 has the same left-justified storage issue. */
struct AU {
	uint32 x;
	unsigned int y;
};

/* The rightmost bits in the first word are explicitly unnamed junk. */
struct B {
	int x : BITS;
	int : JUNK_BITS;
	int y : 1;
};

struct BU {
	unsigned int x : BITS;
	unsigned int : JUNK_BITS;
	unsigned int y : 1;
};

/* The rightmost bits fall into the gap between x and a following word. */
struct C {
	int x : BITS;
	int y;
};

struct CU {
	unsigned int x : BITS;
	unsigned int y;
};

/* Nothing follows x, so the final four bits are junk. */
struct D {
	int x : BITS;
};

struct DU {
	unsigned int x : BITS;
};

/* The final four bits are named and therefore must be preserved. */
struct E {
	int x : BITS;
	int y : JUNK_BITS;
};

struct EU {
	unsigned int x : BITS;
	unsigned int y : JUNK_BITS;
};

/* Named low bits before another full word: still not junk. */
struct F {
	int x : BITS;
	int low : JUNK_BITS;
	int y;
};

struct FU {
	unsigned int x : BITS;
	unsigned int low : JUNK_BITS;
	unsigned int y;
};

/* Two adjacent 32-bit fields force two independent partial-word stores. */
struct G {
	int32 x;
	int32 y;
};

struct GU {
	uint32 x;
	uint32 y;
};

static struct A ga = { (int32)012345, 1 };
static struct AU gau = { (uint32)012345, 1 };
static struct B gb = { 012345, 1 };
static struct BU gbu = { 012345, 1 };
static struct C gc = { 012345, 2 };
static struct CU gcu = { 012345, 2 };
static struct D gd = { 012345 };
static struct DU gdu = { 012345 };
static struct E ge = { 012345, 017 };
static struct EU geu = { 012345, 017 };
static struct F gf = { 012345, 017, 3 };
static struct FU gfu = { 012345, 017, 3 };
static struct G gg = { (int32)012345, (int32)-7 };
static struct GU ggu = { (uint32)012345, (uint32)0777 };

static volatile struct A vga;
static volatile struct E vge;
static volatile struct G vgg;

static int32 data32[4] = { (int32)1, (int32)-2, (int32)3, (int32)-4 };
static uint32 udata32[4] = { (uint32)1, (uint32)2, (uint32)3, (uint32)4 };
static volatile int32 vdata32[4];
static volatile uint32 vudata32[4];

#define STORE_STRUCT(TAG, TYPE) \
static void \
store_##TAG(p, y) \
struct TAG *p; \
TYPE y; \
{ \
	p->x = y; \
} \
static TYPE \
store_ret_##TAG(p, y) \
struct TAG *p; \
TYPE y; \
{ \
	p->x = y; \
	return p->x; \
} \
static void \
store_const_##TAG(p) \
struct TAG *p; \
{ \
	p->x = (TYPE)-1; \
} \
static TYPE \
load_##TAG(p) \
struct TAG *p; \
{ \
	return p->x; \
} \
static TYPE \
update_##TAG(p, y) \
struct TAG *p; \
TYPE y; \
{ \
	p->x = (TYPE)(p->x + y); \
	return p->x; \
}

STORE_STRUCT(A, int32)
STORE_STRUCT(AU, uint32)
STORE_STRUCT(B, int)
STORE_STRUCT(BU, unsigned int)
STORE_STRUCT(C, int)
STORE_STRUCT(CU, unsigned int)
STORE_STRUCT(D, int)
STORE_STRUCT(DU, unsigned int)
STORE_STRUCT(E, int)
STORE_STRUCT(EU, unsigned int)
STORE_STRUCT(F, int)
STORE_STRUCT(FU, unsigned int)
STORE_STRUCT(G, int32)
STORE_STRUCT(GU, uint32)

static void
store_g_y(p, x, y)
struct G *p;
int32 x;
int32 y;
{
	p->x = x;
	p->y = y;
}

static void
store_gu_y(p, x, y)
struct GU *p;
uint32 x;
uint32 y;
{
	p->x = x;
	p->y = y;
}

static void
store_named_low(p, x, low)
struct E *p;
int x;
int low;
{
	p->x = x;
	p->y = low & 017;
}

static void
store_named_low_u(p, x, low)
struct EU *p;
unsigned int x;
unsigned int low;
{
	p->x = x;
	p->y = low & 017;
}

static int
preserve_named_low(p, x)
struct E *p;
int x;
{
	int old;

	old = p->y;
	p->x = x;
	return old + p->y;
}

static unsigned int
preserve_named_low_u(p, x)
struct EU *p;
unsigned int x;
{
	unsigned int old;

	old = p->y;
	p->x = x;
	return old + p->y;
}

static void
store_array(i, x)
int i;
int32 x;
{
	data32[i] = x;
}

static void
store_uarray(i, x)
int i;
uint32 x;
{
	udata32[i] = x;
}

static int32
load_array(i)
int i;
{
	return data32[i];
}

static uint32
load_uarray(i)
int i;
{
	return udata32[i];
}

static void
store_pointer(p, x)
int32 *p;
int32 x;
{
	*p = x;
}

static void
store_upointer(p, x)
uint32 *p;
uint32 x;
{
	*p = x;
}

static int32
update_pointer(p, x)
int32 *p;
int32 x;
{
	*p = (int32)(*p + x);
	return *p;
}

static uint32
update_upointer(p, x)
uint32 *p;
uint32 x;
{
	*p = (uint32)(*p + x);
	return *p;
}

static int32
store_indexed_pointer(p, i, x)
int32 *p;
int i;
int32 x;
{
	p[i] = x;
	return p[i];
}

static uint32
store_indexed_upointer(p, i, x)
uint32 *p;
int i;
uint32 x;
{
	p[i] = x;
	return p[i];
}

static int32
store_volatile_array(i, x)
int i;
int32 x;
{
	vdata32[i] = x;
	return vdata32[i];
}

static uint32
store_volatile_uarray(i, x)
int i;
uint32 x;
{
	vudata32[i] = x;
	return vudata32[i];
}

static int32
store_volatile_struct(x)
int32 x;
{
	vga.x = x;
	return vga.x;
}

static int
store_volatile_named_low(x, low)
int x;
int low;
{
	vge.y = low & 017;
	vge.x = x;
	return vge.y;
}

static int32
store_volatile_pair(x, y)
int32 x;
int32 y;
{
	vgg.x = x;
	vgg.y = y;
	return vgg.x + vgg.y;
}

static int32
stack_store32(x)
int32 x;
{
	struct A a;
	struct E e;
	int32 local[2];

	a.x = x;
	a.y = 1;
	e.x = (int)x;
	e.y = 017;
	local[0] = a.x;
	local[1] = (int32)e.x;
	return local[0] + local[1];
}

static uint32
stack_ustore32(x)
uint32 x;
{
	struct AU a;
	struct EU e;
	uint32 local[2];

	a.x = x;
	a.y = 1;
	e.x = (unsigned int)x;
	e.y = 017;
	local[0] = a.x;
	local[1] = (uint32)e.x;
	return local[0] + local[1];
}

static int
branch_store32(p, x)
struct E *p;
int x;
{
	p->x = x;
	if (p->x < 0)
		return -1;
	if (p->x == 0)
		return p->y;
	return 1 + p->y;
}

static unsigned int
branch_ustore32(p, x)
struct EU *p;
unsigned int x;
{
	p->x = x;
	if (p->x == 0)
		return p->y;
	return 1 + p->y;
}

Sint
use_store32(a, b, i)
Sint a;
Sint b;
int i;
{
	int idx;
	Sint sum;

	idx = i & 3;
	store_A(&ga, (int32)a);
	store_AU(&gau, (uint32)a);
	store_B(&gb, a);
	store_BU(&gbu, (unsigned int)a);
	store_C(&gc, b);
	store_CU(&gcu, (unsigned int)b);
	store_D(&gd, a + b);
	store_DU(&gdu, (unsigned int)(a + b));
	store_E(&ge, a - b);
	store_EU(&geu, (unsigned int)(a - b));
	store_F(&gf, a ^ b);
	store_FU(&gfu, (unsigned int)(a ^ b));
	store_G(&gg, (int32)a);
	store_GU(&ggu, (uint32)b);
	store_g_y(&gg, (int32)a, (int32)b);
	store_gu_y(&ggu, (uint32)a, (uint32)b);
	store_named_low(&ge, a, b);
	store_named_low_u(&geu, (unsigned int)a, (unsigned int)b);
	store_array(idx, (int32)a);
	store_uarray(idx, (uint32)b);
	store_pointer(&data32[(idx + 1) & 3], (int32)b);
	store_upointer(&udata32[(idx + 2) & 3], (uint32)a);

	sum = (Sint)store_ret_A(&ga, (int32)a);
	sum += (Sint)store_ret_AU(&gau, (uint32)b);
	sum += (Sint)store_ret_B(&gb, a);
	sum += (Sint)store_ret_BU(&gbu, (unsigned int)b);
	sum += (Sint)store_ret_C(&gc, a + 1);
	sum += (Sint)store_ret_CU(&gcu, (unsigned int)(b + 1));
	sum += (Sint)store_ret_D(&gd, a + 2);
	sum += (Sint)store_ret_DU(&gdu, (unsigned int)(b + 2));
	sum += (Sint)store_ret_E(&ge, a + 3);
	sum += (Sint)store_ret_EU(&geu, (unsigned int)(b + 3));
	sum += (Sint)store_ret_F(&gf, a + 4);
	sum += (Sint)store_ret_FU(&gfu, (unsigned int)(b + 4));
	sum += (Sint)store_ret_G(&gg, (int32)(a + 5));
	sum += (Sint)store_ret_GU(&ggu, (uint32)(b + 5));
	sum += (Sint)update_A(&ga, (int32)1);
	sum += (Sint)update_AU(&gau, (uint32)1);
	sum += (Sint)update_B(&gb, 1);
	sum += (Sint)update_BU(&gbu, 1U);
	sum += (Sint)update_E(&ge, 1);
	sum += (Sint)update_EU(&geu, 1U);
	sum += (Sint)preserve_named_low(&ge, a);
	sum += (Sint)preserve_named_low_u(&geu, (unsigned int)b);
	sum += (Sint)load_A(&ga);
	sum += (Sint)load_AU(&gau);
	sum += (Sint)load_array(idx);
	sum += (Sint)load_uarray(idx);
	sum += (Sint)update_pointer(&data32[idx], (int32)7);
	sum += (Sint)update_upointer(&udata32[idx], (uint32)7);
	sum += (Sint)store_indexed_pointer(data32, idx, (int32)(a + b));
	sum += (Sint)store_indexed_upointer(udata32, idx, (uint32)(a - b));
	sum += (Sint)store_volatile_array(idx, (int32)a);
	sum += (Sint)store_volatile_uarray(idx, (uint32)b);
	sum += (Sint)store_volatile_struct((int32)a);
	sum += (Sint)store_volatile_named_low(a, b);
	sum += (Sint)store_volatile_pair((int32)a, (int32)b);
	sum += (Sint)stack_store32((int32)a);
	sum += (Sint)stack_ustore32((uint32)b);
	sum += (Sint)branch_store32(&ge, a);
	sum += (Sint)branch_ustore32(&geu, (unsigned int)b);
	store_const_A(&ga);
	store_const_AU(&gau);
	store_const_B(&gb);
	store_const_BU(&gbu);
	store_const_E(&ge);
	store_const_EU(&geu);
	return sum;
}
