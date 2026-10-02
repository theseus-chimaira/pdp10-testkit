#include "insns.h"

/*
 * Pointer increment coverage.
 *
 * This is the positive-increment companion to decrement-pointer.c.
 * It intentionally covers both ordinary word pointers and PDP-10 byte
 * pointers.  The important PDP-6/KA10 cases are:
 *
 *   - whole-word pointer increments should use normal address arithmetic
 *   - 6/7/8/9/18-bit byte pointers must advance through P/S correctly
 *   - increments across word boundaries must keep the local byte pointer sane
 *   - ++p, p++, p += n, p + const, and indexed forms should all compile
 */

#define INC_CONST(TAG, TYPE, N) \
static TYPE * \
inc_ ## TAG ## _ ## N (TYPE *p) \
{ \
	return p + N; \
}

#define INC_CONST_0_12(TAG, TYPE) \
INC_CONST (TAG, TYPE, 0) \
INC_CONST (TAG, TYPE, 1) \
INC_CONST (TAG, TYPE, 2) \
INC_CONST (TAG, TYPE, 3) \
INC_CONST (TAG, TYPE, 4) \
INC_CONST (TAG, TYPE, 5) \
INC_CONST (TAG, TYPE, 6) \
INC_CONST (TAG, TYPE, 7) \
INC_CONST (TAG, TYPE, 8) \
INC_CONST (TAG, TYPE, 9) \
INC_CONST (TAG, TYPE, 10) \
INC_CONST (TAG, TYPE, 11) \
INC_CONST (TAG, TYPE, 12)

#define PTR_INC_FOR_TYPE(TAG, TYPE) \
static TYPE arr_ ## TAG[48]; \
static TYPE *gp_ ## TAG = &arr_ ## TAG[8]; \
static TYPE * volatile vgp_ ## TAG = &arr_ ## TAG[12]; \
INC_CONST_0_12 (TAG, TYPE) \
static TYPE * \
inc_ ## TAG ## _dynamic (TYPE *p, int n) \
{ \
	return p + n; \
} \
static TYPE * \
addassign_ ## TAG (TYPE *p, int n) \
{ \
	p += n; \
	return p; \
} \
static TYPE * \
preinc_ ## TAG (TYPE *p) \
{ \
	++p; \
	return p; \
} \
static TYPE * \
postinc_ ## TAG (TYPE *p) \
{ \
	TYPE *q; \
	q = p++; \
	return p - q ? p : q; \
} \
static TYPE * \
global_inc_ ## TAG (void) \
{ \
	return gp_ ## TAG + 3; \
} \
static TYPE * \
volatile_inc_ ## TAG (int n) \
{ \
	TYPE *p; \
	p = vgp_ ## TAG; \
	p += n; \
	vgp_ ## TAG = p; \
	return p; \
} \
static TYPE * \
array_start_inc_ ## TAG (void) \
{ \
	return &arr_ ## TAG[0] + 15; \
} \
static TYPE * \
index_inc_ ## TAG (int i, int j) \
{ \
	TYPE *p; \
	p = &arr_ ## TAG[i]; \
	return p + j; \
} \
static TYPE \
load_after_ ## TAG (TYPE *p) \
{ \
	return *(p + 1); \
} \
static void \
store_after_ ## TAG (TYPE *p, TYPE x) \
{ \
	*(p + 2) = x; \
} \
static int \
diff_after_inc_ ## TAG (TYPE *p, int n) \
{ \
	TYPE *q; \
	q = p + n; \
	return q - p; \
} \
static int \
compare_after_inc_ ## TAG (TYPE *p, TYPE *q, int n) \
{ \
	p += n; \
	return p > q; \
}

/* Packed/scalar aggregate pointer sizes. */
typedef struct { Qint x[3]; } __attribute__ ((packed)) Qint3;
typedef struct { uQint x[3]; } __attribute__ ((packed)) uQint3;
typedef struct { Hint x[3]; } __attribute__ ((packed)) Hint3;
typedef struct { uHint x[3]; } __attribute__ ((packed)) uHint3;
typedef struct { Sint x[3]; } Sint3;
typedef struct { uSint x[3]; } uSint3;
typedef struct { char6 x[7]; } __attribute__ ((packed)) char6_7;
typedef struct { char7 x[6]; } __attribute__ ((packed)) char7_6;
typedef struct { char8 x[5]; } __attribute__ ((packed)) char8_5;
typedef struct { char9 x[5]; } __attribute__ ((packed)) char9_5;
typedef struct { short18 x[3]; } __attribute__ ((packed)) short18_3;

PTR_INC_FOR_TYPE (char_, char)
PTR_INC_FOR_TYPE (uchar_, unsigned char)
PTR_INC_FOR_TYPE (char6, char6)
PTR_INC_FOR_TYPE (uchar6, uchar6)
PTR_INC_FOR_TYPE (char7, char7)
PTR_INC_FOR_TYPE (uchar7, uchar7)
PTR_INC_FOR_TYPE (char8, char8)
PTR_INC_FOR_TYPE (uchar8, uchar8)
PTR_INC_FOR_TYPE (char9, char9)
PTR_INC_FOR_TYPE (uchar9, uchar9)
PTR_INC_FOR_TYPE (short16, short16)
PTR_INC_FOR_TYPE (ushort16, ushort16)
PTR_INC_FOR_TYPE (short18, short18)
PTR_INC_FOR_TYPE (ushort18, ushort18)
PTR_INC_FOR_TYPE (Qint, Qint)
PTR_INC_FOR_TYPE (uQint, uQint)
PTR_INC_FOR_TYPE (Hint, Hint)
PTR_INC_FOR_TYPE (uHint, uHint)
PTR_INC_FOR_TYPE (Sint, Sint)
PTR_INC_FOR_TYPE (uSint, uSint)
PTR_INC_FOR_TYPE (Dint, Dint)
PTR_INC_FOR_TYPE (uDint, uDint)
PTR_INC_FOR_TYPE (Qint3, Qint3)
PTR_INC_FOR_TYPE (uQint3, uQint3)
PTR_INC_FOR_TYPE (Hint3, Hint3)
PTR_INC_FOR_TYPE (uHint3, uHint3)
PTR_INC_FOR_TYPE (Sint3, Sint3)
PTR_INC_FOR_TYPE (uSint3, uSint3)
PTR_INC_FOR_TYPE (char6_7, char6_7)
PTR_INC_FOR_TYPE (char7_6, char7_6)
PTR_INC_FOR_TYPE (char8_5, char8_5)
PTR_INC_FOR_TYPE (char9_5, char9_5)
PTR_INC_FOR_TYPE (short18_3, short18_3)

static char *
char_bridge_inc (char9 *p, int n)
{
	char *q;

	q = (char *)p;
	q += n;
	return q;
}

static void *
void_bridge_inc (uchar9 *p, int n)
{
	uchar9 *q;

	q = p;
	q += n;
	return (void *)q;
}

static char9 *
cast_back_inc (char *p, int n)
{
	char9 *q;

	q = (char9 *)p;
	return q + n;
}

static int
mixed_byte_word_control (char9 *bp, Sint *wp, int n)
{
	char9 *bq;
	Sint *wq;

	bq = bp + n;
	wq = wp + n;
	return (bq - bp) + (wq - wp);
}

static int
cross_word_byte_increments (int i)
{
	int r;

	r = 0;
	r += diff_after_inc_char6 (&arr_char6[0], 5);
	r += diff_after_inc_char6 (&arr_char6[0], 6);
	r += diff_after_inc_char6 (&arr_char6[0], 7);
	r += diff_after_inc_char7 (&arr_char7[0], 4);
	r += diff_after_inc_char7 (&arr_char7[0], 5);
	r += diff_after_inc_char7 (&arr_char7[0], 6);
	r += diff_after_inc_char8 (&arr_char8[0], 3);
	r += diff_after_inc_char8 (&arr_char8[0], 4);
	r += diff_after_inc_char8 (&arr_char8[0], 5);
	r += diff_after_inc_char9 (&arr_char9[0], 3);
	r += diff_after_inc_char9 (&arr_char9[0], 4);
	r += diff_after_inc_char9 (&arr_char9[0], 5);
	r += diff_after_inc_short18 (&arr_short18[0], 1);
	r += diff_after_inc_short18 (&arr_short18[0], 2);
	r += diff_after_inc_short18 (&arr_short18[0], 3);
	r += diff_after_inc_char9 (&arr_char9[0], i);
	return r;
}

static int
use_increment_pointers (int i, int j)
{
	int r;

	r = 0;
	r += diff_after_inc_char9 (&arr_char9[4], i);
	r += diff_after_inc_uchar9 (&arr_uchar9[4], j);
	r += diff_after_inc_char6 (&arr_char6[4], 5);
	r += diff_after_inc_char7 (&arr_char7[4], 6);
	r += diff_after_inc_char8 (&arr_char8[4], 7);
	r += diff_after_inc_short18 (&arr_short18[4], 3);
	r += diff_after_inc_Sint (&arr_Sint[4], 4);
	r += compare_after_inc_char9 (&arr_char9[4], &arr_char9[10], i);
	r += compare_after_inc_Sint (&arr_Sint[4], &arr_Sint[10], j);
	r += mixed_byte_word_control (&arr_char9[4], &arr_Sint[4], i);
	r += cross_word_byte_increments (j);
	return r;
}
