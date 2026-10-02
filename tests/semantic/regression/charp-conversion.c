/*
 * Byte-pointer conversion coverage.
 *
 * PDP-10 byte pointers carry byte-size/position information.  A C cast
 * between char6/char7/char8/char9/char pointers is therefore more than a
 * plain word-pointer type change: later loads, stores, indexing and pointer
 * differences must use the destination byte size.
 */

#include "insns.h"
typedef char6 schar6;
typedef char7 schar7;
typedef char8 schar8;
typedef char9 schar9;

extern void clobber(void);

static schar6 sg6[48];
static schar7 sg7[48];
static schar8 sg8[48];
static schar9 sg9[48];

static char6 g6[48];
static char7 g7[48];
static char8 g8[48];
static char9 g9[48];

static uchar6 ug6[48];
static uchar7 ug7[48];
static uchar8 ug8[48];
static uchar9 ug9[48];

static char gc[48];
static unsigned char guc[48];
static int gw[16];

static schar6 *volatile v_s6;
static schar7 *volatile v_s7;
static schar8 *volatile v_s8;
static schar9 *volatile v_s9;

static char6 *volatile v_6;
static char7 *volatile v_7;
static char8 *volatile v_8;
static char9 *volatile v_9;

static uchar6 *volatile v_u6;
static uchar7 *volatile v_u7;
static uchar8 *volatile v_u8;
static uchar9 *volatile v_u9;

static char *volatile v_c;
static unsigned char *volatile v_uc;
static int *volatile v_w;
static void *volatile v_void;

#define CAST_ONLY(N, TO, FROM, VTO, VFROM)              \
static TO *                                             \
ret_ ## N (FROM *p)                                     \
{                                                       \
	return (TO *)p;                                      \
}                                                       \
                                                        \
static TO *                                             \
add0_ ## N (FROM *p)                                    \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return q;                                           \
}                                                       \
                                                        \
static TO *                                             \
add1_ ## N (FROM *p)                                    \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return q + 1;                                       \
}                                                       \
                                                        \
static TO *                                             \
addi_ ## N (FROM *p, int i)                             \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return q + i;                                       \
}                                                       \
                                                        \
static void                                             \
save_ ## N (FROM *p)                                    \
{                                                       \
	VTO = (TO *)p;                                      \
}                                                       \
                                                        \
static TO *                                             \
reload_ ## N (void)                                     \
{                                                       \
	FROM *p;                                            \
	p = VFROM;                                          \
	clobber();                                          \
	return (TO *)p;                                     \
}

#define CAST_DEREF(N, TO, FROM, VTO, VFROM)             \
CAST_ONLY(N, TO, FROM, VTO, VFROM)                      \
                                                        \
static int                                              \
load0_ ## N (FROM *p)                                   \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return (int)q[0];                                   \
}                                                       \
                                                        \
static int                                              \
load1_ ## N (FROM *p)                                   \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return (int)q[1];                                   \
}                                                       \
                                                        \
static int                                              \
load5_ ## N (FROM *p)                                   \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return (int)q[5];                                   \
}                                                       \
                                                        \
static int                                              \
loadi_ ## N (FROM *p, int i)                            \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return (int)q[i];                                   \
}                                                       \
                                                        \
static void                                             \
store0_ ## N (FROM *p, int x)                           \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	q[0] = (TO)x;                                       \
}                                                       \
                                                        \
static void                                             \
store1_ ## N (FROM *p, int x)                           \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	q[1] = (TO)(x + 1);                                 \
}                                                       \
                                                        \
static void                                             \
storei_ ## N (FROM *p, int i, int x)                    \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	q[i] = (TO)x;                                       \
}                                                       \
                                                        \
static int                                              \
diff_ ## N (FROM *p, FROM *r)                           \
{                                                       \
	TO *q;                                               \
	TO *s;                                               \
	q = (TO *)p;                                        \
	s = (TO *)r;                                        \
	return q - s;                                       \
}                                                       \
                                                        \
static int                                              \
sum_ ## N (FROM *p)                                     \
{                                                       \
	TO *q;                                               \
	q = (TO *)p;                                        \
	return (int)q[0] + (int)q[1] + (int)q[3] + (int)q[4];\
}

#define VOID_PAIR(N, T, VT)                             \
static void *                                           \
to_void_ ## N (T *p)                                    \
{                                                       \
	return (void *)p;                                    \
}                                                       \
                                                        \
static T *                                              \
from_void_ ## N (void *p)                               \
{                                                       \
	return (T *)p;                                       \
}                                                       \
                                                        \
static void                                             \
save_void_ ## N (T *p)                                  \
{                                                       \
	v_void = (void *)p;                                  \
}                                                       \
                                                        \
static T *                                              \
reload_void_ ## N (void)                                \
{                                                       \
	void *p;                                             \
	p = v_void;                                         \
	clobber();                                          \
	return (T *)p;                                      \
}                                                       \
                                                        \
static T *                                              \
reload_typed_ ## N (void)                               \
{                                                       \
	T *p;                                                \
	p = VT;                                             \
	clobber();                                          \
	return (T *)(void *)p;                              \
}

#define WORD_PAIR(N, T, VT)                             \
static int *                                            \
to_word_ ## N (T *p)                                    \
{                                                       \
	return (int *)p;                                     \
}                                                       \
                                                        \
static T *                                              \
from_word_ ## N (int *p)                                \
{                                                       \
	return (T *)p;                                       \
}                                                       \
                                                        \
static int                                              \
load_word_as_ ## N (int *p)                             \
{                                                       \
	T *q;                                                \
	q = (T *)p;                                         \
	return (int)q[1];                                   \
}                                                       \
                                                        \
static void                                             \
store_word_as_ ## N (int *p, int x)                     \
{                                                       \
	T *q;                                                \
	q = (T *)p;                                         \
	q[2] = (T)x;                                        \
}                                                       \
                                                        \
static T *                                              \
word_reload_ ## N (void)                                \
{                                                       \
	int *p;                                              \
	p = v_w;                                            \
	clobber();                                          \
	return (T *)p;                                      \
}                                                       \
                                                        \
static int *                                            \
byte_reload_word_ ## N (void)                           \
{                                                       \
	T *p;                                                \
	p = VT;                                             \
	clobber();                                          \
	return (int *)p;                                    \
}

/* Original unsigned byte-pointer cast matrix, with the previously skipped
 * reverse directions enabled. */
CAST_DEREF(char6_char7, char6, char7, v_6, v_7)
CAST_DEREF(char6_char8, char6, char8, v_6, v_8)
CAST_DEREF(char6_char9, char6, char9, v_6, v_9)
CAST_DEREF(char6_char,  char6, char,  v_6, v_c)

CAST_DEREF(char7_char6, char7, char6, v_7, v_6)
CAST_DEREF(char7_char8, char7, char8, v_7, v_8)
CAST_DEREF(char7_char9, char7, char9, v_7, v_9)
CAST_DEREF(char7_char,  char7, char,  v_7, v_c)

CAST_DEREF(char8_char6, char8, char6, v_8, v_6)
CAST_DEREF(char8_char7, char8, char7, v_8, v_7)
CAST_DEREF(char8_char9, char8, char9, v_8, v_9)
CAST_DEREF(char8_char,  char8, char,  v_8, v_c)

CAST_DEREF(char9_char6, char9, char6, v_9, v_6)
CAST_DEREF(char9_char7, char9, char7, v_9, v_7)
CAST_DEREF(char9_char8, char9, char8, v_9, v_8)
CAST_DEREF(char9_char,  char9, char,  v_9, v_c)

CAST_DEREF(char_char6, char, char6, v_c, v_6)
CAST_DEREF(char_char7, char, char7, v_c, v_7)
CAST_DEREF(char_char8, char, char8, v_c, v_8)
CAST_DEREF(char_char9, char, char9, v_c, v_9)

/* Normal unsigned char is not a typedef alias for the target-specific
 * ucharN names, so keep it explicit. */
CAST_DEREF(uchar_char6, unsigned char, char6, v_uc, v_6)
CAST_DEREF(uchar_char7, unsigned char, char7, v_uc, v_7)
CAST_DEREF(uchar_char8, unsigned char, char8, v_uc, v_8)
CAST_DEREF(uchar_char9, unsigned char, char9, v_uc, v_9)
CAST_DEREF(char6_uchar, char6, unsigned char, v_6, v_uc)
CAST_DEREF(char7_uchar, char7, unsigned char, v_7, v_uc)
CAST_DEREF(char8_uchar, char8, unsigned char, v_8, v_uc)
CAST_DEREF(char9_uchar, char9, unsigned char, v_9, v_uc)

/* Signed sized-byte pointers: same PS/byte-size mechanics, different load
 * interpretation after the cast. */
CAST_DEREF(schar6_schar7, schar6, schar7, v_s6, v_s7)
CAST_DEREF(schar7_schar6, schar7, schar6, v_s7, v_s6)
CAST_DEREF(schar8_schar9, schar8, schar9, v_s8, v_s9)
CAST_DEREF(schar9_schar8, schar9, schar8, v_s9, v_s8)
CAST_DEREF(schar6_char,   schar6, char,   v_s6, v_c)
CAST_DEREF(char_schar6,   char,   schar6, v_c,  v_s6)
CAST_DEREF(schar9_char,   schar9, char,   v_s9, v_c)
CAST_DEREF(char_schar9,   char,   schar9, v_c,  v_s9)

/* Explicit ucharN aliases, to catch code paths that distinguish typedefs. */
CAST_DEREF(uchar6_uchar7, uchar6, uchar7, v_u6, v_u7)
CAST_DEREF(uchar7_uchar6, uchar7, uchar6, v_u7, v_u6)
CAST_DEREF(uchar8_uchar9, uchar8, uchar9, v_u8, v_u9)
CAST_DEREF(uchar9_uchar8, uchar9, uchar8, v_u9, v_u8)
CAST_DEREF(uchar6_char,   uchar6, char,   v_u6, v_c)
CAST_DEREF(char_uchar6,   char,   uchar6, v_c,  v_u6)
CAST_DEREF(uchar9_char,   uchar9, char,   v_u9, v_c)
CAST_DEREF(char_uchar9,   char,   uchar9, v_c,  v_u9)

VOID_PAIR(char6, char6, v_6)
VOID_PAIR(char7, char7, v_7)
VOID_PAIR(char8, char8, v_8)
VOID_PAIR(char9, char9, v_9)
VOID_PAIR(char_plain, char, v_c)
VOID_PAIR(uchar_plain, unsigned char, v_uc)
VOID_PAIR(schar6, schar6, v_s6)
VOID_PAIR(schar9, schar9, v_s9)

WORD_PAIR(char6, char6, v_6)
WORD_PAIR(char7, char7, v_7)
WORD_PAIR(char8, char8, v_8)
WORD_PAIR(char9, char9, v_9)
WORD_PAIR(char_plain, char, v_c)
WORD_PAIR(uchar_plain, unsigned char, v_uc)

static int
use_charp_conversions(int i, int x)
{
	int sum;
	char6 *p6;
	char7 *p7;
	char8 *p8;
	char9 *p9;
	char *pc;
	unsigned char *puc;

	p6 = g6;
	p7 = g7;
	p8 = g8;
	p9 = g9;
	pc = gc;
	puc = guc;

	v_6 = g6;
	v_7 = g7;
	v_8 = g8;
	v_9 = g9;
	v_u6 = ug6;
	v_u7 = ug7;
	v_u8 = ug8;
	v_u9 = ug9;
	v_s6 = sg6;
	v_s7 = sg7;
	v_s8 = sg8;
	v_s9 = sg9;
	v_c = gc;
	v_uc = guc;
	v_w = gw;
	v_void = gc;

	storei_char6_char7(p7, i, x);
	storei_char7_char6(p6, i, x + 1);
	storei_char8_char9(p9, i, x + 2);
	storei_char9_char8(p8, i, x + 3);
	storei_char_char9(p9, i, x + 4);
	storei_char9_char(pc, i, x + 5);
	storei_uchar_char8(p8, i, x + 6);
	storei_char8_uchar(puc, i, x + 7);
	storei_schar6_schar7(sg7, i, x + 8);
	storei_schar9_schar8(sg8, i, x + 9);

	clobber();

	sum = 0;
	sum += load0_char6_char7(p7);
	sum += load1_char7_char6(p6);
	sum += load5_char8_char9(p9);
	sum += loadi_char9_char8(p8, i);
	sum += sum_char_char6(p6);
	sum += sum_char6_char(pc);
	sum += diff_char6_char9(p9 + 17, p9 + 2);
	sum += diff_char9_char6(p6 + 17, p6 + 2);
	sum += diff_char_char9(p9 + 17, p9 + 2);
	sum += diff_char9_char(pc + 17, pc + 2);
	sum += (ret_char6_char7(p7) == p6);
	sum += (add1_char7_char6(p6) != p7);
	sum += (addi_char8_char9(p9, i) != p8);
	sum += (reload_char9_char8() != p9);
	sum += (from_void_char6(to_void_char7(p7)) != p6);
	sum += (from_void_char9(to_void_char_plain(pc)) != p9);
	sum += (from_word_char8(to_word_char9(p9)) != p8);
	sum += (byte_reload_word_char6() != gw);
	sum += load_word_as_char7(gw);
	sum += load_word_as_uchar_plain(gw);

	return sum;
}
