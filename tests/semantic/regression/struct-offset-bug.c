#include "insns.h"

/*
 * Struct member offset regression coverage.
 *
 * The original bug shape is tiny but important:
 *
 *     struct S { int a; int b[1]; };
 *     x->b[0] = 0;
 *     i = 0; x->b[i] = 0;
 *
 * Constant and variable indexing of the same one-element member array
 * must use the same offset.  PDP-10 byte and halfword objects make this
 * more interesting because the address may be a byte pointer rather
 * than a plain word address.
 */

struct scalar_memory_forms
{
	int a;
	int b[1];
};

struct scalar_memory_forms2
{
	int a;
	int b[2];
	int c;
};

static struct scalar_memory_forms g_scalar_one;
static struct scalar_memory_forms2 g_scalar_two;

static void
f1(x)
struct scalar_memory_forms *x;
{
	x->b[0] = 0;
}

static void
f2(x)
struct scalar_memory_forms *x;
{
	int i;

	i = 0;
	x->b[i] = 0;
}

static int
f3(x)
struct scalar_memory_forms *x;
{
	return x->b[0];
}

static int
f4(x)
struct scalar_memory_forms *x;
{
	int i;

	i = 0;
	return x->b[i];
}

static int *
f5(x)
struct scalar_memory_forms *x;
{
	return &x->b[0];
}

static int *
f6(x)
struct scalar_memory_forms *x;
{
	int i;

	i = 0;
	return &x->b[i];
}

static void
f7(x, y)
struct scalar_memory_forms2 *x;
int y;
{
	int i;

	i = y & 1;
	x->b[i] = y;
}

static int
f8(x, y)
struct scalar_memory_forms2 *x;
int y;
{
	int i;

	i = y & 1;
	return x->b[i];
}

#define TAIL1(NAME, T)                                                   \
struct NAME                                                              \
{                                                                        \
	T a;                                                              \
	T b[1];                                                           \
};                                                                       \
static struct NAME g_##NAME;                                             \
static void store_##NAME##_const(struct NAME *p, T v) { p->b[0] = v; }   \
static void store_##NAME##_index(struct NAME *p, T v)                    \
{                                                                        \
	int i;                                                            \
	i = 0;                                                            \
	p->b[i] = v;                                                      \
}                                                                        \
static T load_##NAME##_const(struct NAME *p) { return p->b[0]; }         \
static T load_##NAME##_index(struct NAME *p)                             \
{                                                                        \
	int i;                                                            \
	i = 0;                                                            \
	return p->b[i];                                                    \
}                                                                        \
static T *addr_##NAME##_const(struct NAME *p) { return &p->b[0]; }       \
static T *addr_##NAME##_index(struct NAME *p)                            \
{                                                                        \
	int i;                                                            \
	i = 0;                                                            \
	return &p->b[i];                                                   \
}                                                                        \
static int diff_##NAME(struct NAME *p)                                   \
{                                                                        \
	return addr_##NAME##_index(p) - addr_##NAME##_const(p);           \
}                                                                        \
static T use_##NAME(T v)                                                 \
{                                                                        \
	store_##NAME##_const(&g_##NAME, v);                               \
	store_##NAME##_index(&g_##NAME, (T)(v + 1));                      \
	*addr_##NAME##_const(&g_##NAME) = load_##NAME##_index(&g_##NAME); \
	*addr_##NAME##_index(&g_##NAME) = load_##NAME##_const(&g_##NAME); \
	return (T)(load_##NAME##_const(&g_##NAME)                         \
	    + load_##NAME##_index(&g_##NAME)                              \
	    + (T)diff_##NAME(&g_##NAME));                                 \
}

#define TAIL2(NAME, T)                                                   \
struct NAME                                                              \
{                                                                        \
	T a;                                                              \
	T b[2];                                                           \
	T c;                                                              \
};                                                                       \
static struct NAME g_##NAME;                                             \
static void store_##NAME##_dyn(struct NAME *p, int i, T v)               \
{                                                                        \
	p->b[i & 1] = v;                                                 \
}                                                                        \
static T load_##NAME##_dyn(struct NAME *p, int i)                        \
{                                                                        \
	return p->b[i & 1];                                               \
}                                                                        \
static T *addr_##NAME##_dyn(struct NAME *p, int i)                       \
{                                                                        \
	return &p->b[i & 1];                                              \
}                                                                        \
static int diff_##NAME##_dyn(struct NAME *p, int i)                      \
{                                                                        \
	return addr_##NAME##_dyn(p, i) - &p->b[0];                        \
}                                                                        \
static T use_##NAME(T v, int i)                                          \
{                                                                        \
	store_##NAME##_dyn(&g_##NAME, i, v);                              \
	*addr_##NAME##_dyn(&g_##NAME, i + 1) = (T)(v + 1);                \
	return (T)(load_##NAME##_dyn(&g_##NAME, i)                        \
	    + load_##NAME##_dyn(&g_##NAME, i + 1)                         \
	    + (T)diff_##NAME##_dyn(&g_##NAME, i));                        \
}

TAIL1(tail_int_one, int)
TAIL1(tail_uint_one, unsigned int)
TAIL1(tail_char_one, char)
TAIL1(tail_uchar_one, unsigned char)
TAIL1(tail_qint_one, Qint)
TAIL1(tail_uqint_one, uQint)
TAIL1(tail_hint_one, Hint)
TAIL1(tail_uhint_one, uHint)
TAIL1(tail_char6_one, char6)
TAIL1(tail_uchar6_one, uchar6)
TAIL1(tail_char7_one, char7)
TAIL1(tail_uchar7_one, uchar7)
TAIL1(tail_char8_one, char8)
TAIL1(tail_uchar8_one, uchar8)
TAIL1(tail_char9_one, char9)
TAIL1(tail_uchar9_one, uchar9)
TAIL1(tail_short16_one, short16)
TAIL1(tail_ushort16_one, ushort16)
TAIL1(tail_short18_one, short18)
TAIL1(tail_ushort18_one, ushort18)
TAIL1(tail_int32_one, int32)
TAIL1(tail_uint32_one, uint32)
TAIL1(tail_sint_one, Sint)
TAIL1(tail_usint_one, uSint)
TAIL1(tail_dint_one, Dint)
TAIL1(tail_udint_one, uDint)

TAIL2(tail_int_two, int)
TAIL2(tail_qint_two, Qint)
TAIL2(tail_hint_two, Hint)
TAIL2(tail_char8_two, char8)
TAIL2(tail_char9_two, char9)
TAIL2(tail_short18_two, short18)
TAIL2(tail_sint_two, Sint)
TAIL2(tail_dint_two, Dint)

struct nested_tail
{
	Sint tag;
	struct scalar_memory_forms inner;
	Sint after;
};

struct packed_tail
{
	Qint a;
	char8 b[1];
	Hint c;
} __attribute__ ((packed));

static struct nested_tail g_nested;
static struct packed_tail g_packed;
static volatile struct scalar_memory_forms2 gv_scalar_two;

static void
store_nested_const(p, v)
struct nested_tail *p;
int v;
{
	p->inner.b[0] = v;
}

static void
store_nested_index(p, v)
struct nested_tail *p;
int v;
{
	int i;

	i = 0;
	p->inner.b[i] = v;
}

static int
load_nested_mix(p)
struct nested_tail *p;
{
	int i;

	i = 0;
	return p->inner.b[0] + p->inner.b[i] + p->after;
}

static void
store_packed_const(p, v)
struct packed_tail *p;
int v;
{
	p->b[0] = v;
}

static void
store_packed_index(p, v)
struct packed_tail *p;
int v;
{
	int i;

	i = 0;
	p->b[i] = v;
}

static char8
load_packed_mix(p)
struct packed_tail *p;
{
	int i;

	i = 0;
	return (char8)(p->b[0] + p->b[i]);
}

static int
volatile_struct_offset(i, v)
int i;
int v;
{
	gv_scalar_two.b[i & 1] = v;
	return gv_scalar_two.b[0] + gv_scalar_two.b[1];
}

static int
stack_struct_offset(v)
int v;
{
	struct scalar_memory_forms one;
	struct scalar_memory_forms2 two;
	int i;

	i = 0;
	one.a = v;
	one.b[0] = v + 1;
	two.a = v + 2;
	two.b[0] = one.b[i];
	two.b[1] = two.b[i] + one.a;
	two.c = two.b[1] + 1;
	return one.b[0] + two.b[0] + two.b[1] + two.c;
}

int
use_struct_offset_bug(v)
int v;
{
	Dint d;
	uDint ud;

	f1(&g_scalar_one);
	f2(&g_scalar_one);
	g_scalar_one.b[0] = v;
	f7(&g_scalar_two, v);
	d = use_tail_dint_one((Dint)v);
	ud = use_tail_udint_one((uDint)v);
	store_nested_const(&g_nested, v);
	store_nested_index(&g_nested, v + 1);
	store_packed_const(&g_packed, (char8)v);
	store_packed_index(&g_packed, (char8)(v + 1));

	return f3(&g_scalar_one)
	    + f4(&g_scalar_one)
	    + *f5(&g_scalar_one)
	    + *f6(&g_scalar_one)
	    + f8(&g_scalar_two, v)
	    + (int)use_tail_int_one(v)
	    + (int)use_tail_uint_one((unsigned int)v)
	    + (int)use_tail_char_one((char)v)
	    + (int)use_tail_uchar_one((unsigned char)v)
	    + (int)use_tail_qint_one((Qint)v)
	    + (int)use_tail_uqint_one((uQint)v)
	    + (int)use_tail_hint_one((Hint)v)
	    + (int)use_tail_uhint_one((uHint)v)
	    + (int)use_tail_char6_one((char6)v)
	    + (int)use_tail_uchar6_one((uchar6)v)
	    + (int)use_tail_char7_one((char7)v)
	    + (int)use_tail_uchar7_one((uchar7)v)
	    + (int)use_tail_char8_one((char8)v)
	    + (int)use_tail_uchar8_one((uchar8)v)
	    + (int)use_tail_char9_one((char9)v)
	    + (int)use_tail_uchar9_one((uchar9)v)
	    + (int)use_tail_short16_one((short16)v)
	    + (int)use_tail_ushort16_one((ushort16)v)
	    + (int)use_tail_short18_one((short18)v)
	    + (int)use_tail_ushort18_one((ushort18)v)
	    + (int)use_tail_int32_one((int32)v)
	    + (int)use_tail_uint32_one((uint32)v)
	    + (int)use_tail_sint_one((Sint)v)
	    + (int)use_tail_usint_one((uSint)v)
	    + (int)d
	    + (int)ud
	    + (int)use_tail_int_two(v, v)
	    + (int)use_tail_qint_two((Qint)v, v)
	    + (int)use_tail_hint_two((Hint)v, v)
	    + (int)use_tail_char8_two((char8)v, v)
	    + (int)use_tail_char9_two((char9)v, v)
	    + (int)use_tail_short18_two((short18)v, v)
	    + (int)use_tail_sint_two((Sint)v, v)
	    + (int)use_tail_dint_two((Dint)v, v)
	    + load_nested_mix(&g_nested)
	    + (int)load_packed_mix(&g_packed)
	    + volatile_struct_offset(v, v + 3)
	    + stack_struct_offset(v);
}
