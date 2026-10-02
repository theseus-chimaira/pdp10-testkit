#include "insns.h"

/*
 * Stack variable pointer coverage.
 *
 * This is a compile-only addressing/layout test.  It verifies that taking
 * addresses of stack scalars, stack arrays, stack struct fields, and mixed
 * frames produces the correct word, halfword, or byte pointer form.  The
 * callees are deliberately unprototyped so the file can pass different
 * numbers and kinds of pointer arguments in ordinary C89 style.
 */

extern void bar();
extern void use_int();

typedef signed char schar;
typedef unsigned char uchar;


#define ARRAY_BAR1(B) bar(&(B)[0])
#define ARRAY_BAR2(B) bar(&(B)[0], &(B)[1])
#define ARRAY_BAR3(B) bar(&(B)[0], &(B)[1], &(B)[2])
#define ARRAY_BAR4(B) bar(&(B)[0], &(B)[1], &(B)[2], &(B)[3])
#define ARRAY_BAR5(B) bar(&(B)[0], &(B)[1], &(B)[2], &(B)[3], &(B)[4])

#define SCALAR_VARS1(T) T a0
#define SCALAR_VARS2(T) T a0, a1
#define SCALAR_VARS3(T) T a0, a1, a2
#define SCALAR_VARS4(T) T a0, a1, a2, a3
#define SCALAR_VARS5(T) T a0, a1, a2, a3, a4

#define INIT_SCALARS1(T, X) a0 = (T)((X) + 0)
#define INIT_SCALARS2(T, X) INIT_SCALARS1(T, X); a1 = (T)((X) + 1)
#define INIT_SCALARS3(T, X) INIT_SCALARS2(T, X); a2 = (T)((X) + 2)
#define INIT_SCALARS4(T, X) INIT_SCALARS3(T, X); a3 = (T)((X) + 3)
#define INIT_SCALARS5(T, X) INIT_SCALARS4(T, X); a4 = (T)((X) + 4)

#define SCALAR_BAR1 bar(&a0)
#define SCALAR_BAR2 bar(&a0, &a1)
#define SCALAR_BAR3 bar(&a0, &a1, &a2)
#define SCALAR_BAR4 bar(&a0, &a1, &a2, &a3)
#define SCALAR_BAR5 bar(&a0, &a1, &a2, &a3, &a4)

#define TEST_ARRAY(T, N) \
void \
stack_array_##T##_##N(x) \
int x; \
{ \
	int i; \
	T b[N]; \
	for (i = 0; i < N; i++) \
		b[i] = (T)(x + i); \
	ARRAY_BAR##N(b); \
}

#define TEST_SCALARS(T, N) \
void \
stack_scalars_##T##_##N(x) \
int x; \
{ \
	SCALAR_VARS##N(T); \
	INIT_SCALARS##N(T, x); \
	SCALAR_BAR##N; \
}

#define TEST_PTR_WALK(T) \
void \
stack_ptr_walk_##T(x) \
int x; \
{ \
	T b[6]; \
	T *p; \
	int i; \
	for (i = 0; i < 6; i++) \
		b[i] = (T)(x + i); \
	p = &b[5]; \
	bar(p, p - 1, p - 2, p - 5); \
	p = &b[0]; \
	bar(p, p + 1, p + 3, p + 5); \
}

#define TEST_STRUCT(T) \
struct stack_struct_##T { \
	char pad0; \
	T a; \
	T b[3]; \
	T c; \
	char pad1; \
}; \
void \
stack_struct_##T(x) \
int x; \
{ \
	struct stack_struct_##T s; \
	s.pad0 = (char)x; \
	s.a = (T)(x + 1); \
	s.b[0] = (T)(x + 2); \
	s.b[1] = (T)(x + 3); \
	s.b[2] = (T)(x + 4); \
	s.c = (T)(x + 5); \
	s.pad1 = (char)(x + 6); \
	bar(&s.a, &s.b[0], &s.b[1], &s.b[2], &s.c); \
}

#define TEST_VOLATILE(T) \
void \
stack_volatile_##T(x) \
int x; \
{ \
	volatile T a; \
	volatile T b[3]; \
	a = (T)x; \
	b[0] = (T)(x + 1); \
	b[1] = (T)(x + 2); \
	b[2] = (T)(x + 3); \
	bar((T *)&a, (T *)&b[0], (T *)&b[1], (T *)&b[2]); \
}

#define TEST_TYPE(T) \
TEST_SCALARS(T, 1) \
TEST_SCALARS(T, 2) \
TEST_SCALARS(T, 3) \
TEST_SCALARS(T, 4) \
TEST_SCALARS(T, 5) \
TEST_ARRAY(T, 1) \
TEST_ARRAY(T, 2) \
TEST_ARRAY(T, 3) \
TEST_ARRAY(T, 4) \
TEST_ARRAY(T, 5) \
TEST_PTR_WALK(T) \
TEST_STRUCT(T) \
TEST_VOLATILE(T)

TEST_TYPE(char)
TEST_TYPE(schar)
TEST_TYPE(uchar)

TEST_TYPE(Qint)
TEST_TYPE(sQint)
TEST_TYPE(uQint)
TEST_TYPE(Hint)
TEST_TYPE(uHint)
TEST_TYPE(Sint)
TEST_TYPE(uSint)
TEST_TYPE(Dint)
TEST_TYPE(uDint)

TEST_TYPE(char6)
TEST_TYPE(uchar6)
TEST_TYPE(char7)
TEST_TYPE(uchar7)
TEST_TYPE(char8)
TEST_TYPE(uchar8)
TEST_TYPE(char9)
TEST_TYPE(uchar9)
TEST_TYPE(short16)
TEST_TYPE(ushort16)
TEST_TYPE(short18)
TEST_TYPE(ushort18)
TEST_TYPE(int32)
TEST_TYPE(uint32)
TEST_TYPE(int36)
TEST_TYPE(uint36)

struct mixed_stack_frame {
	char c;
	Qint q;
	Hint h;
	Sint s;
	Dint d;
	char6 c6[7];
	char7 c7[6];
	char8 c8[5];
	char9 c9[5];
	short18 sh[3];
};

void
stack_mixed_frame(x)
int x;
{
	char lead;
	Qint q;
	Hint h;
	Sint s;
	Dint d;
	char6 c6[7];
	char7 c7[6];
	char8 c8[5];
	char9 c9[5];
	short18 sh[3];
	struct mixed_stack_frame m;

	lead = (char)x;
	q = (Qint)(x + 1);
	h = (Hint)(x + 2);
	s = (Sint)(x + 3);
	d = (Dint)(x + 4);
	c6[0] = (char6)(x + 5);
	c6[6] = (char6)(x + 6);
	c7[0] = (char7)(x + 7);
	c7[5] = (char7)(x + 8);
	c8[0] = (char8)(x + 9);
	c8[4] = (char8)(x + 10);
	c9[0] = (char9)(x + 11);
	c9[4] = (char9)(x + 12);
	sh[0] = (short18)(x + 13);
	sh[2] = (short18)(x + 14);

	m.c = lead;
	m.q = q;
	m.h = h;
	m.s = s;
	m.d = d;
	m.c6[0] = c6[0];
	m.c6[6] = c6[6];
	m.c7[0] = c7[0];
	m.c7[5] = c7[5];
	m.c8[0] = c8[0];
	m.c8[4] = c8[4];
	m.c9[0] = c9[0];
	m.c9[4] = c9[4];
	m.sh[0] = sh[0];
	m.sh[2] = sh[2];

	bar(&lead, &q, &h, &s, &d);
	bar(&c6[0], &c6[6], &c7[0], &c7[5], &c8[0], &c8[4]);
	bar(&c9[0], &c9[4], &sh[0], &sh[2]);
	bar(&m.c, &m.q, &m.h, &m.s, &m.d);
	bar(&m.c6[0], &m.c6[6], &m.c7[0], &m.c7[5]);
	bar(&m.c8[0], &m.c8[4], &m.c9[0], &m.c9[4], &m.sh[0], &m.sh[2]);
}

void
stack_address_values(x)
int x;
{
	char c[5];
	Hint h[5];
	Dint d[3];
	char9 b[5];
	char *cp;
	Hint *hp;
	Dint *dp;
	char9 *bp;

	c[0] = (char)x;
	c[4] = (char)(x + 1);
	h[0] = (Hint)(x + 2);
	h[4] = (Hint)(x + 3);
	d[0] = (Dint)(x + 4);
	d[2] = (Dint)(x + 5);
	b[0] = (char9)(x + 6);
	b[4] = (char9)(x + 7);

	cp = &c[4];
	hp = &h[4];
	dp = &d[2];
	bp = &b[4];

	bar(cp, cp - 4, hp, hp - 4, dp, dp - 2, bp, bp - 4);
	use_int((int)(cp - &c[0]));
	use_int((int)(hp - &h[0]));
	use_int((int)(dp - &d[0]));
	use_int((int)(bp - &b[0]));
}

void
use_stackvar_pointers(x)
int x;
{
	stack_scalars_Qint_5(x);
	stack_array_Qint_5(x);
	stack_ptr_walk_Qint(x);
	stack_struct_Qint(x);
	stack_volatile_Qint(x);

	stack_scalars_Hint_5(x);
	stack_array_Hint_5(x);
	stack_ptr_walk_Hint(x);
	stack_struct_Hint(x);
	stack_volatile_Hint(x);

	stack_scalars_Sint_5(x);
	stack_array_Sint_5(x);
	stack_ptr_walk_Sint(x);
	stack_struct_Sint(x);
	stack_volatile_Sint(x);

	stack_scalars_Dint_5(x);
	stack_array_Dint_5(x);
	stack_ptr_walk_Dint(x);
	stack_struct_Dint(x);
	stack_volatile_Dint(x);

	stack_scalars_char9_5(x);
	stack_array_char9_5(x);
	stack_ptr_walk_char9(x);
	stack_struct_char9(x);
	stack_volatile_char9(x);

	stack_scalars_short18_5(x);
	stack_array_short18_5(x);
	stack_ptr_walk_short18(x);
	stack_struct_short18(x);
	stack_volatile_short18(x);

	stack_mixed_frame(x);
	stack_address_values(x);
}
