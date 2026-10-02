#include "insns.h"

/*
 * Pointer decrement coverage.
 *
 * This is the negative-increment companion to ordinary pointer-add tests.
 * It intentionally covers both word pointers and PDP-10 byte pointers.
 *
 * Interesting PDP-6/KA10 cases:
 *   - whole-word pointer decrements should become ordinary word-address math
 *   - 9-bit and other byte pointers need correct local byte-pointer P/S state
 *   - negative byte-pointer adjustment must not require ADJBP on PDP-6/KA10
 *   - constants around word boundaries should exercise ADD/SUB plus IBP paths
 */

#define DEC_CONST(TAG, TYPE, N) \
static TYPE * \
dec_ ## TAG ## _ ## N (TYPE *p) \
{ \
	return p - N; \
}

#define DEC_CONST_1_12(TAG, TYPE) \
DEC_CONST (TAG, TYPE, 1) \
DEC_CONST (TAG, TYPE, 2) \
DEC_CONST (TAG, TYPE, 3) \
DEC_CONST (TAG, TYPE, 4) \
DEC_CONST (TAG, TYPE, 5) \
DEC_CONST (TAG, TYPE, 6) \
DEC_CONST (TAG, TYPE, 7) \
DEC_CONST (TAG, TYPE, 8) \
DEC_CONST (TAG, TYPE, 9) \
DEC_CONST (TAG, TYPE, 10) \
DEC_CONST (TAG, TYPE, 11) \
DEC_CONST (TAG, TYPE, 12)

#define PTR_DEC_FOR_TYPE(TAG, TYPE) \
static TYPE arr_ ## TAG[40]; \
static TYPE *gp_ ## TAG = &arr_ ## TAG[24]; \
static TYPE * volatile vgp_ ## TAG = &arr_ ## TAG[28]; \
DEC_CONST_1_12 (TAG, TYPE) \
static TYPE * \
dec_ ## TAG ## _0 (TYPE *p) \
{ \
	return p - 0; \
} \
static TYPE * \
dec_ ## TAG ## _dynamic (TYPE *p, int n) \
{ \
	return p - n; \
} \
static TYPE * \
subassign_ ## TAG (TYPE *p, int n) \
{ \
	p -= n; \
	return p; \
} \
static TYPE * \
predec_ ## TAG (TYPE *p) \
{ \
	--p; \
	return p; \
} \
static TYPE * \
postdec_ ## TAG (TYPE *p) \
{ \
	TYPE *q; \
	q = p--; \
	return q - p ? p : q; \
} \
static TYPE * \
global_dec_ ## TAG (void) \
{ \
	return gp_ ## TAG - 3; \
} \
static TYPE * \
volatile_dec_ ## TAG (int n) \
{ \
	TYPE *p; \
	p = vgp_ ## TAG; \
	p -= n; \
	vgp_ ## TAG = p; \
	return p; \
} \
static TYPE * \
array_end_dec_ ## TAG (void) \
{ \
	return &arr_ ## TAG[39] - 15; \
} \
static TYPE * \
index_dec_ ## TAG (int i, int j) \
{ \
	TYPE *p; \
	p = &arr_ ## TAG[i]; \
	return p - j; \
} \
static TYPE \
load_before_ ## TAG (TYPE *p) \
{ \
	return *(p - 1); \
} \
static void \
store_before_ ## TAG (TYPE *p, TYPE x) \
{ \
	*(p - 2) = x; \
} \
static int \
diff_after_dec_ ## TAG (TYPE *p, int n) \
{ \
	TYPE *q; \
	q = p - n; \
	return p - q; \
} \
static int \
compare_after_dec_ ## TAG (TYPE *p, TYPE *q, int n) \
{ \
	p -= n; \
	return p < q; \
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

PTR_DEC_FOR_TYPE (char_, char)
PTR_DEC_FOR_TYPE (uchar_, unsigned char)
PTR_DEC_FOR_TYPE (char6, char6)
PTR_DEC_FOR_TYPE (uchar6, uchar6)
PTR_DEC_FOR_TYPE (char7, char7)
PTR_DEC_FOR_TYPE (uchar7, uchar7)
PTR_DEC_FOR_TYPE (char8, char8)
PTR_DEC_FOR_TYPE (uchar8, uchar8)
PTR_DEC_FOR_TYPE (char9, char9)
PTR_DEC_FOR_TYPE (uchar9, uchar9)
PTR_DEC_FOR_TYPE (short16, short16)
PTR_DEC_FOR_TYPE (ushort16, ushort16)
PTR_DEC_FOR_TYPE (short18, short18)
PTR_DEC_FOR_TYPE (ushort18, ushort18)
PTR_DEC_FOR_TYPE (Qint, Qint)
PTR_DEC_FOR_TYPE (uQint, uQint)
PTR_DEC_FOR_TYPE (Hint, Hint)
PTR_DEC_FOR_TYPE (uHint, uHint)
PTR_DEC_FOR_TYPE (Sint, Sint)
PTR_DEC_FOR_TYPE (uSint, uSint)
PTR_DEC_FOR_TYPE (Dint, Dint)
PTR_DEC_FOR_TYPE (uDint, uDint)
PTR_DEC_FOR_TYPE (Qint3, Qint3)
PTR_DEC_FOR_TYPE (uQint3, uQint3)
PTR_DEC_FOR_TYPE (Hint3, Hint3)
PTR_DEC_FOR_TYPE (uHint3, uHint3)
PTR_DEC_FOR_TYPE (Sint3, Sint3)
PTR_DEC_FOR_TYPE (uSint3, uSint3)
PTR_DEC_FOR_TYPE (char6_7, char6_7)
PTR_DEC_FOR_TYPE (char7_6, char7_6)
PTR_DEC_FOR_TYPE (char8_5, char8_5)
PTR_DEC_FOR_TYPE (char9_5, char9_5)
PTR_DEC_FOR_TYPE (short18_3, short18_3)

static char *
char_bridge_dec (char9 *p, int n)
{
	char *q;

	q = (char *)p;
	q -= n;
	return q;
}

static void *
void_bridge_dec (uchar9 *p, int n)
{
	uchar9 *q;

	q = p;
	q -= n;
	return (void *)q;
}

static int
mixed_byte_word_control (char9 *bp, Sint *wp, int n)
{
	char9 *bq;
	Sint *wq;

	bq = bp - n;
	wq = wp - n;
	return (bp - bq) + (wp - wq);
}

static int
use_decrement_pointers (int i, int j)
{
	int r;

	r = 0;
	r += diff_after_dec_char9 (&arr_char9[20], i);
	r += diff_after_dec_uchar9 (&arr_uchar9[20], j);
	r += diff_after_dec_char6 (&arr_char6[20], 5);
	r += diff_after_dec_char7 (&arr_char7[20], 6);
	r += diff_after_dec_char8 (&arr_char8[20], 7);
	r += diff_after_dec_short18 (&arr_short18[20], 3);
	r += diff_after_dec_Sint (&arr_Sint[20], 4);
	r += compare_after_dec_char9 (&arr_char9[20], &arr_char9[10], i);
	r += compare_after_dec_Sint (&arr_Sint[20], &arr_Sint[10], j);
	r += mixed_byte_word_control (&arr_char9[20], &arr_Sint[20], i);
	return r;
}
