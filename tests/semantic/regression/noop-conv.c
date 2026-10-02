#include "insns.h"

/*
 * No-op pointer conversion coverage.
 *
 * The original bug shape is:
 *
 *     int * -> char * -> int *
 *
 * On PDP-10 this is not a boring flat-address cast: char pointers are
 * byte pointers, while int/Sint pointers are word pointers.  These tests
 * check round-trips where the final C type is the original type.  If the
 * backend builds a byte pointer for the middle cast, it must not leave a
 * stale PS/byte-size field in the final word pointer.
 *
 * This is compile/assembly coverage only.
 */

static int gi;
static unsigned int gui;
static Sint gs;
static uSint gus;
static Dint gd;
static char gc[12];
static unsigned char guc[12];
static char6 gc6[12];
static char7 gc7[12];
static char8 gc8[12];
static char9 gc9[12];
static short16 gh16[8];
static short18 gh18[8];

static int * volatile v_intp;
static Sint * volatile v_sintp;
static char * volatile v_charp;
static char6 * volatile v_char6p;
static short18 * volatile v_h18p;

static int *g_int_from_char = (int *)(char *)&gi;
static int *g_int_from_uchar = (int *)(unsigned char *)&gi;
static Sint *g_sint_from_char = (Sint *)(char *)&gs;
static char *g_char_from_int = (char *)(int *)&gi;
static char6 *g_char6_from_char = (char6 *)(char *)gc6;
static short18 *g_h18_from_char = (short18 *)(char *)gh18;

static int *
noop(x)
int *x;
{
	return (int *)(char *)x;
}

static int *
noop_int_uchar(x)
int *x;
{
	return (int *)(unsigned char *)x;
}

static int *
noop_int_schar(x)
int *x;
{
	return (int *)(signed char *)x;
}

static int *
noop_int_void(x)
int *x;
{
	return (int *)(void *)x;
}

static unsigned int *
noop_uint_char(x)
unsigned int *x;
{
	return (unsigned int *)(char *)x;
}

static Sint *
noop_sint_char(x)
Sint *x;
{
	return (Sint *)(char *)x;
}

static uSint *
noop_usint_char(x)
uSint *x;
{
	return (uSint *)(unsigned char *)x;
}

static Dint *
noop_dint_char(x)
Dint *x;
{
	return (Dint *)(char *)x;
}

static char *
noop_char_int(x)
char *x;
{
	return (char *)(int *)x;
}

static unsigned char *
noop_uchar_int(x)
unsigned char *x;
{
	return (unsigned char *)(int *)x;
}

static char6 *
noop_char6_char(x)
char6 *x;
{
	return (char6 *)(char *)x;
}

static char7 *
noop_char7_char(x)
char7 *x;
{
	return (char7 *)(char *)x;
}

static char8 *
noop_char8_char(x)
char8 *x;
{
	return (char8 *)(char *)x;
}

static char9 *
noop_char9_char(x)
char9 *x;
{
	return (char9 *)(char *)x;
}

static uchar6 *
noop_uchar6_uchar(x)
uchar6 *x;
{
	return (uchar6 *)(unsigned char *)x;
}

static uchar7 *
noop_uchar7_uchar(x)
uchar7 *x;
{
	return (uchar7 *)(unsigned char *)x;
}

static uchar8 *
noop_uchar8_uchar(x)
uchar8 *x;
{
	return (uchar8 *)(unsigned char *)x;
}

static uchar9 *
noop_uchar9_uchar(x)
uchar9 *x;
{
	return (uchar9 *)(unsigned char *)x;
}

static short16 *
noop_short16_char(x)
short16 *x;
{
	return (short16 *)(char *)x;
}

static ushort16 *
noop_ushort16_uchar(x)
ushort16 *x;
{
	return (ushort16 *)(unsigned char *)x;
}

static short18 *
noop_short18_char(x)
short18 *x;
{
	return (short18 *)(char *)x;
}

static ushort18 *
noop_ushort18_uchar(x)
ushort18 *x;
{
	return (ushort18 *)(unsigned char *)x;
}

static int *
noop_int_char6(x)
int *x;
{
	return (int *)(char6 *)x;
}

static int *
noop_int_char9(x)
int *x;
{
	return (int *)(char9 *)x;
}

static Sint *
noop_sint_short18(x)
Sint *x;
{
	return (Sint *)(short18 *)x;
}

static int
load_noop_int(x)
int *x;
{
	return *noop(x);
}

static void
store_noop_int(x, v)
int *x;
int v;
{
	*noop(x) = v;
}

static Sint
load_noop_sint(x)
Sint *x;
{
	return *noop_sint_char(x);
}

static void
store_noop_sint(x, v)
Sint *x;
Sint v;
{
	*noop_sint_char(x) = v;
}

static char6
load_noop_char6(x)
char6 *x;
{
	return *noop_char6_char(x);
}

static void
store_noop_char6(x, v)
char6 *x;
char6 v;
{
	*noop_char6_char(x) = v;
}

static short18
load_noop_short18(x)
short18 *x;
{
	return *noop_short18_char(x);
}

static void
store_noop_short18(x, v)
short18 *x;
short18 v;
{
	*noop_short18_char(x) = v;
}

static int *
noop_int_plus(x, n)
int *x;
int n;
{
	return noop(x) + n;
}

static char6 *
noop_char6_plus(x, n)
char6 *x;
int n;
{
	return noop_char6_char(x) + n;
}

static short18 *
noop_short18_plus(x, n)
short18 *x;
int n;
{
	return noop_short18_char(x) + n;
}

static int
noop_int_diff(a, b)
int *a;
int *b;
{
	return noop(a) - noop(b);
}

static int
noop_char6_diff(a, b)
char6 *a;
char6 *b;
{
	return noop_char6_char(a) - noop_char6_char(b);
}

static int
noop_short18_diff(a, b)
short18 *a;
short18 *b;
{
	return noop_short18_char(a) - noop_short18_char(b);
}

static int
noop_compare_int(a, b)
int *a;
int *b;
{
	if (noop(a) == noop_int_uchar(b))
		return 1;
	if (noop_int_char6(a) != noop_int_char9(b))
		return 2;
	return 0;
}

static int *
noop_volatile_int(x)
int *x;
{
	v_intp = x;
	return (int *)(char *)v_intp;
}

static Sint *
noop_volatile_sint(x)
Sint *x;
{
	v_sintp = x;
	return (Sint *)(char *)v_sintp;
}

static char *
noop_volatile_char(x)
char *x;
{
	v_charp = x;
	return (char *)(int *)v_charp;
}

static char6 *
noop_volatile_char6(x)
char6 *x;
{
	v_char6p = x;
	return (char6 *)(char *)v_char6p;
}

static short18 *
noop_volatile_h18(x)
short18 *x;
{
	v_h18p = x;
	return (short18 *)(char *)v_h18p;
}

static void
call_noop_int(x)
int *x;
{
	extern void use_intp(int *);
	use_intp((int *)(char *)x);
}

static void
call_noop_sint(x)
Sint *x;
{
	extern void use_sintp(Sint *);
	use_sintp((Sint *)(char *)x);
}

static void
call_noop_char6(x)
char6 *x;
{
	extern void use_char6p(char6 *);
	use_char6p((char6 *)(char *)x);
}

static void
call_noop_short18(x)
short18 *x;
{
	extern void use_short18p(short18 *);
	use_short18p((short18 *)(char *)x);
}

int
use_noop_conv(ip, sp, dp, c6p, h18p, n)
int *ip;
Sint *sp;
Dint *dp;
char6 *c6p;
short18 *h18p;
int n;
{
	int sum;

	store_noop_int(ip, n);
	store_noop_sint(sp, (Sint)n);
	store_noop_char6(c6p, (char6)n);
	store_noop_short18(h18p, (short18)n);

	call_noop_int(ip);
	call_noop_sint(sp);
	call_noop_char6(c6p);
	call_noop_short18(h18p);

	sum = 0;
	sum += load_noop_int(ip);
	sum += (int)load_noop_sint(sp);
	sum += (int)*noop_dint_char(dp);
	sum += noop_int_schar(ip) == ip;
	sum += noop_int_void(ip) == ip;
	sum += (int)load_noop_char6(c6p);
	sum += (int)load_noop_short18(h18p);
	sum += noop_int_plus(ip, n & 3) - ip;
	sum += noop_char6_plus(c6p, n & 7) - c6p;
	sum += noop_short18_plus(h18p, n & 3) - h18p;
	sum += noop_int_diff(&gi, g_int_from_char);
	sum += noop_char6_diff(gc6, g_char6_from_char);
	sum += noop_short18_diff(gh18, g_h18_from_char);
	sum += noop_compare_int(ip, g_int_from_uchar);
	sum += noop_volatile_int(ip) == ip;
	sum += noop_volatile_sint(sp) == sp;
	sum += noop_volatile_char(gc) == gc;
	sum += noop_volatile_char6(c6p) == c6p;
	sum += noop_volatile_h18(h18p) == h18p;
	sum += noop_uint_char(&gui) == &gui;
	sum += noop_usint_char(&gus) == &gus;
	sum += noop_char_int(gc) == gc;
	sum += noop_uchar_int(guc) == guc;
	sum += noop_char7_char(gc7) == gc7;
	sum += noop_char8_char(gc8) == gc8;
	sum += noop_char9_char(gc9) == gc9;
	sum += noop_uchar6_uchar((uchar6 *)gc6) == (uchar6 *)gc6;
	sum += noop_uchar7_uchar((uchar7 *)gc7) == (uchar7 *)gc7;
	sum += noop_uchar8_uchar((uchar8 *)gc8) == (uchar8 *)gc8;
	sum += noop_uchar9_uchar((uchar9 *)gc9) == (uchar9 *)gc9;
	sum += noop_short16_char(gh16) == gh16;
	sum += noop_ushort16_uchar((ushort16 *)gh16) == (ushort16 *)gh16;
	sum += noop_ushort18_uchar((ushort18 *)gh18) == (ushort18 *)gh18;
	sum += noop_sint_short18(sp) == sp;
	sum += g_sint_from_char == &gs;
	sum += g_char_from_int == (char *)&gi;
	sum += (int)gd;
	return sum;
}
