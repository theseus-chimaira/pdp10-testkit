#include "insns.h"

/*
 * Pointer conversion coverage.
 *
 * This file is intentionally broader than noop-conv.c.  noop-conv.c
 * checks round-trips that should collapse back to the original pointer
 * kind.  This file checks explicit conversions between PDP-10 word,
 * halfword, and byte pointer types, including cases where the byte
 * pointer position/size bits are semantically important.
 *
 * Scope:
 *   - pdp6 / 166
 *   - ka10
 */

typedef signed char schar;
typedef unsigned char uchar;

struct pc_words {
	Qint q;
	uQint uq;
	Hint h;
	uHint uh;
	Sint s;
	uSint us;
	Dint d;
	uDint ud;
	int36 w;
	uint36 uw;
};

struct pc_bytes {
	char c[8];
	uchar uc[8];
	char6 c6[12];
	uchar6 u6[12];
	char7 c7[12];
	uchar7 u7[12];
	char8 c8[12];
	uchar8 u8[12];
	char9 c9[12];
	uchar9 u9[12];
	short16 s16[8];
	ushort16 u16[8];
	short18 s18[8];
	ushort18 u18[8];
};

static struct pc_words gw = {
	(Qint)1, (uQint)2, (Hint)3, (uHint)4,
	(Sint)5, (uSint)6, (Dint)7, (uDint)8,
	(int36)9, (uint36)10
};

static struct pc_bytes gb;
static void *volatile gvptr;
static char *volatile gcptr;
static char6 *volatile gc6ptr;
static char7 *volatile gc7ptr;
static char8 *volatile gc8ptr;
static char9 *volatile gc9ptr;
static short18 *volatile gs18ptr;
static int36 *volatile gwptr;

#define CONVERT(T1, T2) \
static T2 *convert##T1##T2 (T1 *x) { return (T2 *)x; }

#define CONVERT_N(N, T1, T2) \
static T2 *convert_ ## N (T1 *x) { return (T2 *)x; }

#define ROUND_N(N, T1, T2) \
static T1 *round_ ## N (T1 *x) { return (T1 *)(T2 *)x; }

#define VOID_N(N, T1) \
static void *to_void_ ## N (T1 *x) { return (void *)x; } \
static T1 *from_void_ ## N (void *x) { return (T1 *)x; }

#define ADD_N(N, T1, T2) \
static T2 *add_ ## N (T1 *x, int n) { return ((T2 *)x) + n; }

#define DIFF_N(N, T1, T2) \
static int diff_ ## N (T1 *x, T1 *y) { return (T2 *)x - (T2 *)y; }

#define LOAD_N(N, T1, T2) \
static T2 load_ ## N (T1 *x) { return *((T2 *)x); }

#define STORE_N(N, T1, T2) \
static void store_ ## N (T1 *x, T2 y) { *((T2 *)x) = y; }

#define BASIC_N(N, T1, T2) \
CONVERT_N (N, T1, T2) \
ROUND_N (N, T1, T2) \
ADD_N (N, T1, T2) \
DIFF_N (N, T1, T2)

#define FULL_N(N, T1, T2) \
BASIC_N (N, T1, T2) \
LOAD_N (N, T1, T2) \
STORE_N (N, T1, T2)

/* Keep the original visible names for the old word/scalar cases. */
CONVERT (Qint, Hint)
CONVERT (Qint, Sint)
CONVERT (Hint, Qint)
CONVERT (Hint, Sint)
CONVERT (Sint, Qint)
CONVERT (Sint, Hint)

/* Word, halfword, and scalar machine-mode pointer reinterpretation. */
FULL_N (q_h, Qint, Hint)
FULL_N (q_s, Qint, Sint)
FULL_N (q_w, Qint, int36)
FULL_N (uq_uh, uQint, uHint)
FULL_N (uq_us, uQint, uSint)
FULL_N (h_q, Hint, Qint)
FULL_N (h_s, Hint, Sint)
FULL_N (h_w, Hint, int36)
FULL_N (uh_uq, uHint, uQint)
FULL_N (uh_us, uHint, uSint)
FULL_N (s_q, Sint, Qint)
FULL_N (s_h, Sint, Hint)
FULL_N (s_d, Sint, Dint)
FULL_N (us_uq, uSint, uQint)
FULL_N (us_uh, uSint, uHint)
FULL_N (d_s, Dint, Sint)
FULL_N (ud_us, uDint, uSint)

/* Ordinary char and explicit 9-bit char bridge cases. */
FULL_N (char_uchar, char, uchar)
FULL_N (uchar_char, uchar, char)
FULL_N (char_schar, char, schar)
FULL_N (char_char9, char, char9)
FULL_N (char9_char, char9, char)
FULL_N (uchar_uchar9, uchar, uchar9)
FULL_N (uchar9_uchar, uchar9, uchar)

/* PDP-10 packed byte pointer conversions. */
FULL_N (char6_char7, char6, char7)
FULL_N (char6_char8, char6, char8)
FULL_N (char6_char9, char6, char9)
FULL_N (char6_short18, char6, short18)
FULL_N (char6_int36, char6, int36)

FULL_N (char7_char6, char7, char6)
FULL_N (char7_char8, char7, char8)
FULL_N (char7_char9, char7, char9)
FULL_N (char7_short18, char7, short18)
FULL_N (char7_int36, char7, int36)

FULL_N (char8_char6, char8, char6)
FULL_N (char8_char7, char8, char7)
FULL_N (char8_char9, char8, char9)
FULL_N (char8_short18, char8, short18)
FULL_N (char8_int36, char8, int36)

FULL_N (char9_char6, char9, char6)
FULL_N (char9_char7, char9, char7)
FULL_N (char9_char8, char9, char8)
FULL_N (char9_short18, char9, short18)
FULL_N (char9_int36, char9, int36)

FULL_N (short18_char6, short18, char6)
FULL_N (short18_char7, short18, char7)
FULL_N (short18_char8, short18, char8)
FULL_N (short18_char9, short18, char9)
FULL_N (short18_int36, short18, int36)

FULL_N (int36_char6, int36, char6)
FULL_N (int36_char7, int36, char7)
FULL_N (int36_char8, int36, char8)
FULL_N (int36_char9, int36, char9)
FULL_N (int36_short18, int36, short18)

/* Unsigned packed byte conversions should follow the same pointer rules. */
FULL_N (uchar6_uchar7, uchar6, uchar7)
FULL_N (uchar6_uchar8, uchar6, uchar8)
FULL_N (uchar6_uchar9, uchar6, uchar9)
FULL_N (uchar7_uchar6, uchar7, uchar6)
FULL_N (uchar8_uchar6, uchar8, uchar6)
FULL_N (uchar8_uchar9, uchar8, uchar9)
FULL_N (uchar9_uchar6, uchar9, uchar6)
FULL_N (uchar9_uchar8, uchar9, uchar8)
FULL_N (ushort18_uchar9, ushort18, uchar9)
FULL_N (uchar9_ushort18, uchar9, ushort18)

/* Void-pointer bridge.  These should not preserve stale byte PS bits. */
VOID_N (q, Qint)
VOID_N (h, Hint)
VOID_N (s, Sint)
VOID_N (d, Dint)
VOID_N (c, char)
VOID_N (c6, char6)
VOID_N (c7, char7)
VOID_N (c8, char8)
VOID_N (c9, char9)
VOID_N (s18, short18)
VOID_N (w, int36)

/* Global pointer initializers with nontrivial target pointer kinds. */
static Hint *g_q_as_h = (Hint *)&gw.q;
static Sint *g_h_as_s = (Sint *)&gw.h;
static Qint *g_s_as_q = (Qint *)&gw.s;
static Dint *g_s_as_d = (Dint *)&gw.s;
static char6 *g_c9_as_c6 = (char6 *)gb.c9;
static char7 *g_c6_as_c7 = (char7 *)gb.c6;
static char8 *g_c9_as_c8 = (char8 *)gb.c9;
static char9 *g_c8_as_c9 = (char9 *)gb.c8;
static short18 *g_c9_as_s18 = (short18 *)gb.c9;
static int36 *g_c6_as_w = (int36 *)gb.c6;
static char9 *g_w_as_c9 = (char9 *)&gw.w;
static void *g_c7_as_void = (void *)gb.c7;

static Sint
use_word_pointer_conversions(n)
int n;
{
	Qint *qp;
	Hint *hp;
	Sint *sp;
	Dint *dp;
	Sint sum;

	qp = &gw.q;
	hp = convertQintHint(qp);
	sp = convertHintSint(hp);
	dp = convert_s_d(sp);
	gvptr = (void *)dp;
	sp = (Sint *)gvptr;
	store_s_h(sp, (Hint)n);
	sum = (Sint)load_q_h(qp);
	sum += (Sint)*convertSintQint(sp);
	sum += (Sint)(round_s_d(sp) == sp);
	sum += (Sint)(diff_s_d(sp, &gw.s));
	return sum;
}

static Sint
use_byte_pointer_conversions(i, x)
int i;
Sint x;
{
	char6 *p6;
	char7 *p7;
	char8 *p8;
	char9 *p9;
	short18 *ph;
	int36 *pw;
	Sint sum;

	p6 = &gb.c6[i & 3];
	p7 = convert_char6_char7(p6);
	p8 = convert_char7_char8(p7);
	p9 = convert_char8_char9(p8);
	ph = convert_char9_short18(p9);
	pw = convert_short18_int36(ph);

	gc6ptr = p6;
	gc7ptr = p7;
	gc8ptr = p8;
	gc9ptr = p9;
	gs18ptr = ph;
	gwptr = pw;

	store_char6_char9(p6, (char9)x);
	store_char9_char6(p9, (char6)x);
	store_short18_char9(ph, (char9)x);
	*pw = (int36)x;

	sum = (Sint)load_char6_char9(gc6ptr);
	sum += (Sint)load_char9_char6(gc9ptr);
	sum += (Sint)load_short18_char9(gs18ptr);
	sum += (Sint)(add_char6_char7(p6, 1) - p7);
	sum += (Sint)(add_char9_short18(p9, 1) - ph);
	sum += (Sint)diff_char8_char9(&gb.c8[5], &gb.c8[1]);
	return sum;
}

static Sint
use_unsigned_byte_pointer_conversions(i, x)
int i;
uSint x;
{
	uchar6 *p6;
	uchar8 *p8;
	uchar9 *p9;
	ushort18 *ph;
	Sint sum;

	p6 = &gb.u6[i & 3];
	p8 = convert_uchar6_uchar8(p6);
	p9 = convert_uchar8_uchar9(p8);
	ph = convert_uchar9_ushort18(p9);
	store_uchar6_uchar9(p6, (uchar9)x);
	store_uchar9_ushort18(p9, (ushort18)x);
	sum = (Sint)load_uchar6_uchar9(p6);
	sum += (Sint)load_uchar9_ushort18(p9);
	sum += (Sint)(round_uchar9_ushort18(p9) == p9);
	sum += (Sint)diff_uchar8_uchar9(&gb.u8[7], &gb.u8[2]);
	sum += (Sint)(ph == convert_uchar9_ushort18(p9));
	return sum;
}

static Sint
use_void_bridge(i)
int i;
{
	void *v;
	char9 *p9;
	int36 *pw;
	Sint sum;

	p9 = &gb.c9[i & 3];
	v = to_void_c9(p9);
	gc9ptr = from_void_c9(v);
	v = to_void_w(&gw.w);
	pw = from_void_w(v);
	gvptr = to_void_c7(&gb.c7[i & 3]);
	gc7ptr = from_void_c7((void *)gvptr);
	sum = (Sint)(gc9ptr == p9);
	sum += (Sint)(pw == &gw.w);
	sum += (Sint)(gc7ptr == &gb.c7[i & 3]);
	return sum;
}

static Sint
use_global_pointer_conversions(i)
int i;
{
	Sint sum;

	sum = (Sint)*g_q_as_h;
	sum += *g_h_as_s;
	sum += (Sint)*g_s_as_q;
	sum += (Sint)(g_s_as_d == (Dint *)&gw.s);
	sum += (Sint)(g_c9_as_c6 == (char6 *)gb.c9);
	sum += (Sint)(g_c6_as_c7 == (char7 *)gb.c6);
	sum += (Sint)(g_c9_as_c8 == (char8 *)gb.c9);
	sum += (Sint)(g_c8_as_c9 == (char9 *)gb.c8);
	sum += (Sint)(g_c9_as_s18 == (short18 *)gb.c9);
	sum += (Sint)(g_c6_as_w == (int36 *)gb.c6);
	sum += (Sint)(g_w_as_c9 == (char9 *)&gw.w);
	sum += (Sint)(from_void_c7(g_c7_as_void) == gb.c7);
	sum += (Sint)i;
	return sum;
}

Sint
use_pointer_conversion(i, x)
int i;
Sint x;
{
	return use_word_pointer_conversions(i)
	    + use_byte_pointer_conversions(i, x)
	    + use_unsigned_byte_pointer_conversions(i, (uSint)x)
	    + use_void_bridge(i)
	    + use_global_pointer_conversions(i);
}
