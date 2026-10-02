#include "insns.h"

/*
 * Varargs ABI coverage for DAIMON kprintf-style code.
 *
 * This deliberately uses GCC builtins rather than <stdarg.h>, so the
 * backend can be tested before a target C library exists.  The cases
 * cover promoted narrow integers, pointer arguments, unsigned values,
 * looped va_arg stepping, DImode arguments, function pointers, and
 * enough arguments to cross the default register-argument boundary.
 */

struct va_pair {
	int a;
	unsigned int b;
};

struct va_dpair {
	Dint a;
	Dint b;
};

struct va_ptrs {
	char *cp;
	unsigned char *ucp;
	Qint *qp;
	Hint *hp;
	Sint *sp;
	Dint *dp;
};

typedef int (*va_int_fn)(int);
typedef void (*va_void_fn)(int);

static int gv0;
static int gv1;
static unsigned int guv0;
static char gcbuf[12];
static unsigned char gucbuf[12];
static Qint gqbuf[8];
static uQint guqbuf[8];
static Hint ghbuf[8];
static uHint guhbuf[8];
static Sint gsbuf[8];
static uSint gusbuf[8];
static Dint gdbuf[4];
static uDint gudbuf[4];
static char6 g6buf[8];
static char7 g7buf[8];
static char8 g8buf[8];
static char9 g9buf[8];
static short16 gs16buf[8];
static short18 gs18buf[8];
static struct va_pair gvpair = { 1, 2U };
static struct va_dpair gvdpair = { (Dint)3, (Dint)-4 };
static volatile int vgv0;
static volatile Dint vgvd0;

static int add1(x)
int x;
{
	return x + 1;
}

static int sub1(x)
int x;
{
	return x - 1;
}

static int neg1(x)
int x;
{
	return -x;
}

static void
sink_int(int x)
{
	gv0 = x;
}

static void
sink_dint(Dint x)
{
	gdbuf[0] = x;
}

static int
sum_mixed(int tag, ...)
{
	__builtin_va_list ap;
	int a;
	unsigned int b;
	int c;
	int d;
	int e;
	int *p;
	int r;

	__builtin_va_start(ap, tag);
	a = __builtin_va_arg(ap, int);
	b = __builtin_va_arg(ap, unsigned int);
	c = __builtin_va_arg(ap, int);
	d = __builtin_va_arg(ap, int);
	e = __builtin_va_arg(ap, int);
	p = __builtin_va_arg(ap, int *);
	__builtin_va_end(ap);

	r = tag + a + (int)b + (char)c + (short)d + e;
	if (p != 0)
		r += *p;
	return r;
}

static int
sum_many_ints(int tag, ...)
{
	__builtin_va_list ap;
	int r;
	int a0;
	int a1;
	int a2;
	int a3;
	int a4;
	int a5;
	int a6;
	int a7;
	int a8;

	__builtin_va_start(ap, tag);
	a0 = __builtin_va_arg(ap, int);
	a1 = __builtin_va_arg(ap, int);
	a2 = __builtin_va_arg(ap, int);
	a3 = __builtin_va_arg(ap, int);
	a4 = __builtin_va_arg(ap, int);
	a5 = __builtin_va_arg(ap, int);
	a6 = __builtin_va_arg(ap, int);
	a7 = __builtin_va_arg(ap, int);
	a8 = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);

	r = tag + a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8;
	return r;
}

static unsigned int
xor_unsigned_va(int n, ...)
{
	__builtin_va_list ap;
	unsigned int r;
	int i;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++)
		r ^= __builtin_va_arg(ap, unsigned int);
	__builtin_va_end(ap);
	return r;
}

static int
sum_char_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++)
		r += (char)__builtin_va_arg(ap, int);
	__builtin_va_end(ap);
	return r;
}

static int
sum_signed_char_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++)
		r += (signed char)__builtin_va_arg(ap, int);
	__builtin_va_end(ap);
	return r;
}

static unsigned int
sum_unsigned_char_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	unsigned int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++)
		r += (unsigned char)__builtin_va_arg(ap, int);
	__builtin_va_end(ap);
	return r;
}

static int
sum_short_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++)
		r += (short)__builtin_va_arg(ap, int);
	__builtin_va_end(ap);
	return r;
}

static unsigned int
sum_ushort_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	unsigned int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++)
		r += (unsigned short)__builtin_va_arg(ap, int);
	__builtin_va_end(ap);
	return r;
}

static int
sum_qi_promoted_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++) {
		int x;

		x = __builtin_va_arg(ap, int);
		r += (Qint)x;
	}
	__builtin_va_end(ap);
	return r;
}

static int
sum_hi_promoted_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++) {
		int x;

		x = __builtin_va_arg(ap, int);
		r += (Hint)x;
	}
	__builtin_va_end(ap);
	return r;
}

static int
sum_sized_promoted_va(int n, ...)
{
	__builtin_va_list ap;
	int r;
	int x6;
	int x7;
	int x8;
	int x9;
	int x16;
	int x18;
	int x32;

	__builtin_va_start(ap, n);
	x6 = __builtin_va_arg(ap, int);
	x7 = __builtin_va_arg(ap, int);
	x8 = __builtin_va_arg(ap, int);
	x9 = __builtin_va_arg(ap, int);
	x16 = __builtin_va_arg(ap, int);
	x18 = __builtin_va_arg(ap, int);
	x32 = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);

	r = (int)(char6)x6 + (int)(char7)x7 + (int)(char8)x8;
	r += (int)(char9)x9 + (int)(short16)x16;
	r += (int)(short18)x18 + (int)(int32)x32;
	return r + n;
}

static int
sum_ptr_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;
	int *p;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++) {
		p = __builtin_va_arg(ap, int *);
		if (p != 0)
			r += *p;
	}
	__builtin_va_end(ap);
	return r;
}

static int
sum_byte_ptr_va(int n, ...)
{
	__builtin_va_list ap;
	char *cp;
	unsigned char *ucp;
	char6 *p6;
	char7 *p7;
	char8 *p8;
	char9 *p9;
	short16 *p16;
	short18 *p18;
	int r;

	__builtin_va_start(ap, n);
	cp = __builtin_va_arg(ap, char *);
	ucp = __builtin_va_arg(ap, unsigned char *);
	p6 = __builtin_va_arg(ap, char6 *);
	p7 = __builtin_va_arg(ap, char7 *);
	p8 = __builtin_va_arg(ap, char8 *);
	p9 = __builtin_va_arg(ap, char9 *);
	p16 = __builtin_va_arg(ap, short16 *);
	p18 = __builtin_va_arg(ap, short18 *);
	__builtin_va_end(ap);

	r = n;
	r += cp[0] + (int)ucp[1];
	r += (int)p6[2] + (int)p7[3] + (int)p8[4] + (int)p9[5];
	r += (int)p16[0] + (int)p18[1];
	return r;
}

static int
sum_machine_ptr_va(int n, ...)
{
	__builtin_va_list ap;
	Qint *qp;
	uQint *uqp;
	Hint *hp;
	uHint *uhp;
	Sint *sp;
	uSint *usp;
	Dint *dp;
	uDint *udp;
	struct va_pair *vp;
	int r;

	__builtin_va_start(ap, n);
	qp = __builtin_va_arg(ap, Qint *);
	uqp = __builtin_va_arg(ap, uQint *);
	hp = __builtin_va_arg(ap, Hint *);
	uhp = __builtin_va_arg(ap, uHint *);
	sp = __builtin_va_arg(ap, Sint *);
	usp = __builtin_va_arg(ap, uSint *);
	dp = __builtin_va_arg(ap, Dint *);
	udp = __builtin_va_arg(ap, uDint *);
	vp = __builtin_va_arg(ap, struct va_pair *);
	__builtin_va_end(ap);

	r = n;
	r += (int)*qp + (int)*uqp + (int)*hp + (int)*uhp;
	r += (int)*sp + (int)*usp;
	r += (int)*dp + (int)*udp;
	r += vp->a + (int)vp->b;
	return r;
}

static Dint
sum_dint_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	Dint r;

	__builtin_va_start(ap, n);
	r = (Dint)0;
	for (i = 0; i < n; i++)
		r += __builtin_va_arg(ap, Dint);
	__builtin_va_end(ap);
	return r;
}

static uDint
xor_udint_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	uDint r;

	__builtin_va_start(ap, n);
	r = (uDint)0;
	for (i = 0; i < n; i++)
		r ^= __builtin_va_arg(ap, uDint);
	__builtin_va_end(ap);
	return r;
}

static Dint
mixed_dint_va(int tag, ...)
{
	__builtin_va_list ap;
	Dint a;
	uDint b;
	Dint *p;
	struct va_dpair *dp;
	Dint r;

	__builtin_va_start(ap, tag);
	a = __builtin_va_arg(ap, Dint);
	b = __builtin_va_arg(ap, uDint);
	p = __builtin_va_arg(ap, Dint *);
	dp = __builtin_va_arg(ap, struct va_dpair *);
	__builtin_va_end(ap);

	r = a + (Dint)b + *p + dp->a - dp->b;
	return r + (Dint)tag;
}

static int
call_int_fn_va(int x, ...)
{
	__builtin_va_list ap;
	int (*fp)(int);
	int (*fp2)(int);
	int r;

	__builtin_va_start(ap, x);
	fp = __builtin_va_arg(ap, va_int_fn);
	fp2 = __builtin_va_arg(ap, va_int_fn);
	__builtin_va_end(ap);

	r = (*fp)(x);
	r += (*fp2)(x + 1);
	return r;
}

static void
consume_with_callback(int x, ...)
{
	__builtin_va_list ap;
	void (*fp)(int);
	int y;

	__builtin_va_start(ap, x);
	fp = __builtin_va_arg(ap, va_void_fn);
	y = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);

	(*fp)(x + y);
}

static int
sum_pairs_va(int n, ...)
{
	__builtin_va_list ap;
	int i;
	int r;
	struct va_pair p;

	__builtin_va_start(ap, n);
	r = 0;
	for (i = 0; i < n; i++) {
		p = __builtin_va_arg(ap, struct va_pair);
		r += p.a + (int)p.b;
	}
	__builtin_va_end(ap);
	return r;
}

static int
restart_va(int first, ...)
{
	__builtin_va_list ap;
	int a;
	int b;
	int c;

	__builtin_va_start(ap, first);
	a = __builtin_va_arg(ap, int);
	b = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);

	__builtin_va_start(ap, first);
	c = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);

	return first + a + b + c;
}

static int
skip_and_read_va(int tag, ...)
{
	__builtin_va_list ap;
	int a;
	int b;
	int c;
	int *p;

	__builtin_va_start(ap, tag);
	a = __builtin_va_arg(ap, int);
	p = __builtin_va_arg(ap, int *);
	b = __builtin_va_arg(ap, int);
	c = __builtin_va_arg(ap, int);
	__builtin_va_end(ap);

	if (p != 0)
		return tag + a + *p + b + c;
	return tag + a + b + c;
}

static int
local_varargs_arrays(int x)
{
	int li[6];
	char lc[8];
	unsigned char luc[8];
	Qint lq[4];
	Hint lh[4];
	Dint ld[3];

	li[0] = x;
	li[1] = x + 1;
	li[2] = x + 2;
	li[3] = x + 3;
	li[4] = x + 4;
	li[5] = x + 5;
	lc[0] = (char)x;
	lc[1] = (char)(x + 1);
	luc[0] = (unsigned char)(x + 2);
	luc[1] = (unsigned char)(x + 3);
	lq[0] = (Qint)x;
	lq[1] = (Qint)(x + 1);
	lh[0] = (Hint)(x + 2);
	lh[1] = (Hint)(x + 3);
	ld[0] = (Dint)x;
	ld[1] = (Dint)(x + 1);
	ld[2] = (Dint)(x + 2);

	return sum_ptr_va(6, &li[0], &li[1], &li[2], &li[3], &li[4], &li[5])
	    + sum_char_va(4, lc[0], lc[1], luc[0], luc[1])
	    + sum_qi_promoted_va(2, lq[0], lq[1])
	    + sum_hi_promoted_va(2, lh[0], lh[1])
	    + (int)sum_dint_va(3, ld[0], ld[1], ld[2]);
}

int
use_varargs(int x)
{
	Dint da;
	Dint db;
	uDint uda;
	uDint udb;
	struct va_pair p0;
	struct va_pair p1;
	int r;

	gv0 = x;
	gv1 = x + 1;
	guv0 = (unsigned int)(x + 2);
	vgv0 = x + 3;
	gcbuf[0] = (char)x;
	gcbuf[1] = (char)(x + 1);
	gucbuf[0] = (unsigned char)(x + 2);
	gucbuf[1] = (unsigned char)(x + 3);
	gqbuf[0] = (Qint)x;
	gqbuf[1] = (Qint)(x + 1);
	guqbuf[0] = (uQint)(x + 2);
	ghbuf[0] = (Hint)(x + 3);
	guhbuf[0] = (uHint)(x + 4);
	gsbuf[0] = (Sint)(x + 5);
	gusbuf[0] = (uSint)(x + 6);
	gdbuf[0] = (Dint)(x + 7);
	gudbuf[0] = (uDint)(x + 8);
	g6buf[2] = (char6)x;
	g7buf[3] = (char7)(x + 1);
	g8buf[4] = (char8)(x + 2);
	g9buf[5] = (char9)(x + 3);
	gs16buf[0] = (short16)(x + 4);
	gs18buf[1] = (short18)(x + 5);
	da = (Dint)x + gvdpair.a;
	db = (Dint)(x + 9) - gvdpair.b;
	uda = (uDint)(unsigned int)(x + 10);
	udb = (uDint)(unsigned int)(x + 11);
	vgvd0 = da;
	p0.a = x;
	p0.b = (unsigned int)(x + 1);
	p1.a = x + 2;
	p1.b = (unsigned int)(x + 3);

	r = sum_mixed(7, x, 2U, 'A', -3, 5, &gv0);
	r += sum_many_ints(9, x, x + 1, x + 2, x + 3, x + 4,
	    x + 5, x + 6, x + 7, x + 8);
	r += (int)xor_unsigned_va(5, 1U, 2U, 4U, 010U, guv0);
	r += sum_char_va(5, 'a', 'b', 'c', x, -1);
	r += sum_signed_char_va(4, -1, x, 'd', 'e');
	r += (int)sum_unsigned_char_va(4, 0377, x, 'f', 'g');
	r += sum_short_va(5, 1, 2, 3, x, -4);
	r += (int)sum_ushort_va(4, 0177777, x, 5, 6);
	r += sum_qi_promoted_va(4, gqbuf[0], guqbuf[0], gcbuf[0], gucbuf[0]);
	r += sum_hi_promoted_va(4, ghbuf[0], guhbuf[0], gs16buf[0], gs18buf[1]);
	r += sum_sized_promoted_va(7, g6buf[2], g7buf[3], g8buf[4],
	    g9buf[5], gs16buf[0], gs18buf[1], x);
	r += sum_ptr_va(4, &gv0, &gv1, (int *)0, (int *)&vgv0);
	r += sum_byte_ptr_va(8, gcbuf, gucbuf, g6buf, g7buf, g8buf, g9buf,
	    gs16buf, gs18buf);
	r += sum_machine_ptr_va(9, &gqbuf[0], &guqbuf[0], &ghbuf[0],
	    &guhbuf[0], &gsbuf[0], &gusbuf[0], &gdbuf[0], &gudbuf[0], &gvpair);
	r += (int)sum_dint_va(4, da, db, gdbuf[0], vgvd0);
	r += (int)xor_udint_va(4, uda, udb, gudbuf[0], (uDint)017);
	r += (int)mixed_dint_va(3, da, uda, &gdbuf[0], &gvdpair);
	r += call_int_fn_va(x, add1, sub1);
	r += call_int_fn_va(x, neg1, add1);
	consume_with_callback(x, sink_int, 3);
	sink_dint(sum_dint_va(2, da, db));
	r += sum_pairs_va(2, p0, p1);
	r += restart_va(x, x + 1, x + 2);
	r += skip_and_read_va(x, x + 1, &gv1, x + 2, x + 3);
	r += local_varargs_arrays(x);
	return r;
}
