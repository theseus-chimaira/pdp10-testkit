#include "insns.h"


/*
 * Global data layout and initializer coverage.
 *
 * This test is deliberately about objects, not one instruction family:
 *   - external/static .data and .bss objects
 *   - scalar sub-word globals and arrays
 *   - 9-bit char strings and ordinary char objects
 *   - packed byte-size objects
 *   - structs, unions, nested aggregates, partial initializers
 *   - global pointer initializers, including offsets into arrays
 *   - function-local static .data/.bss objects
 */

struct gd_scalars {
	char c;
	unsigned char uc;
	Qint q;
	uQint uq;
	Hint h;
	uHint uh;
	Sint s;
	uSint us;
	int32 i32;
	uint32 ui32;
};

struct gd_bytes {
	char6 c6;
	uchar6 u6;
	char7 c7;
	uchar7 u7;
	char8 c8;
	uchar8 u8;
	char9 c9;
	uchar9 u9;
	short16 s16;
	ushort16 u16;
	short18 s18;
	ushort18 u18;
};

struct gd_packed {
	char6 c6[7];
	char7 c7[6];
	char8 c8[5];
	char9 c9[5];
	short18 h18[3];
} __attribute__ ((packed));

union gd_union {
	Sint s;
	struct gd_scalars sc;
	char bytes[4];
};

/* Public symbols: let assembly review see ordinary external data too. */
Sint gpbs;
uSint gpbu;
char gpbc;
Sint gpds = 0123456;
uSint gpdu = 0765432;
char gpdc = 'G';
char gpst[] = "global-data";

/* Static zero-initialized data. */
static Sint gd_bss_sint;
static uSint gd_bss_usint;
static Qint gd_bss_qint;
static uQint gd_bss_uqint;
static Hint gd_bss_hint;
static uHint gd_bss_uhint;
static char gd_bss_char;
static unsigned char gd_bss_uchar;
static char6 gd_bss_c6[9];
static uchar6 gd_bss_u6[9];
static char7 gd_bss_c7[9];
static uchar7 gd_bss_u7[9];
static char8 gd_bss_c8[9];
static uchar8 gd_bss_u8[9];
static char9 gd_bss_c9[9];
static uchar9 gd_bss_u9[9];
static short16 gd_bss_s16[5];
static ushort16 gd_bss_u16[5];
static short18 gd_bss_s18[5];
static ushort18 gd_bss_u18[5];
static Sint gd_bss_sarr[8];
static Dint gd_bss_darr[3];
static struct gd_scalars gd_bss_struct;
static struct gd_bytes gd_bss_bytes;
static struct gd_packed gd_bss_packed;
static union gd_union gd_bss_union;

/* Static initialized scalar data. */
static Sint gd_data_sint = 012345670123;
static uSint gd_data_usint = 0765432107;
static Qint gd_data_qint = -5;
static uQint gd_data_uqint = 0377;
static Hint gd_data_hint = -01234;
static uHint gd_data_uhint = 076543;
static char gd_data_char = 'D';
static signed char gd_data_schar = -3;
static unsigned char gd_data_uchar = 0377;
static int32 gd_data_i32 = 0123456701;
static uint32 gd_data_ui32 = 0765432107;
static Dint gd_data_dint = 01234567;
static uDint gd_data_udint = 07654321;

static volatile Sint gd_v_sint = 01234;
static volatile uSint gd_v_usint = 05670;
static volatile char gd_v_char = 'V';
static volatile unsigned char gd_v_uchar = 0200;

/* Arrays with full and partial initializers. */
static Sint gd_init_sarr[8] = {
	01, 02, 03, 04, 05, 06, 07, 010
};
static Sint gd_part_sarr[8] = { 011, 022, 033 };
static Dint gd_init_darr[3] = { 01, -02, 03 };
static char gd_msg[] = "DAIMON\0GCC";
static char gd_msg2[12] = "PDP-10";
static unsigned char gd_raw_chars[8] = {
	000, 001, 0177, 0200, 0376, 0377, 'A', 0
};

static char6 gd_c6[8] = { -1, 0, 1, 2, 017, 037, -020, 0 };
static uchar6 gd_u6[8] = { 000, 001, 002, 037, 040, 076, 077, 0 };
static char7 gd_c7[8] = { -1, 0, 1, 2, 037, 077, -040, 0 };
static uchar7 gd_u7[8] = { 000, 001, 002, 077, 0100, 0176, 0177, 0 };
static char8 gd_c8[8] = { -1, 0, 1, 2, 077, 0177, -0100, 0 };
static uchar8 gd_u8[8] = { 000, 001, 002, 0177, 0200, 0376, 0377, 0 };
static char9 gd_c9[8] = { -1, 0, 1, 2, 0177, 0377, -0200, 0 };
static uchar9 gd_u9[8] = { 000, 001, 002, 0377, 0400, 0776, 0777, 0 };
static short16 gd_s16[5] = { -1, 0, 1, 077777, -0100000 };
static ushort16 gd_u16[5] = { 0, 1, 077777, 0100000, 0177777 };
static short18 gd_s18[5] = { -1, 0, 1, 0377777, -0400000 };
static ushort18 gd_u18[5] = { 0, 1, 0377777, 0400000, 0777777 };

static struct gd_scalars gd_data_struct = {
	'a', 0201, -7, (uQint)0777, -0123, 07654,
	0123456, 0765432, 01234567, 07654321
};

static struct gd_bytes gd_data_bytes = {
	-1, 077, -2, 0177, -3, 0377, -4, 0777,
	-0100, 0177777, -0200000, 0777777
};

static struct gd_packed gd_data_packed = {
	{ 0, 1, 2, 3, 4, 5, 6 },
	{ 0, 1, 2, 3, 4, 5 },
	{ 0, 1, 2, 3, 4 },
	{ 0, 1, 2, 3, 4 },
	{ 0, 1, 2 }
};

static union gd_union gd_data_union_s = { 01234567 };
static union gd_union gd_data_union_sc;
static const Sint gd_const_sint = 04567;
static const char gd_const_msg[] = "const-data";

/* Global pointer initializers. */
static Sint *gd_ptr_sint = &gd_data_sint;
static uSint *gd_ptr_usint = &gd_data_usint;
static char *gd_ptr_msg0 = &gd_msg[0];
static char *gd_ptr_msg4 = &gd_msg[4];
static unsigned char *gd_ptr_raw3 = &gd_raw_chars[3];
static uchar6 *gd_ptr_u6 = &gd_u6[5];
static uchar7 *gd_ptr_u7 = &gd_u7[5];
static uchar8 *gd_ptr_u8 = &gd_u8[5];
static uchar9 *gd_ptr_u9 = &gd_u9[5];
static short18 *gd_ptr_s18 = &gd_s18[3];
static Sint *gd_ptr_sarr = &gd_init_sarr[2];
static Dint *gd_ptr_darr = &gd_init_darr[1];
static char *gd_ptr_public_string = &gpst[2];
static const Sint *gd_ptr_const_sint = &gd_const_sint;
static const char *gd_ptr_const_msg = &gd_const_msg[3];

static Sint *gd_ptr_table[4] = {
	&gd_data_sint, &gd_bss_sint, &gd_init_sarr[0], &gd_part_sarr[2]
};

static char *gd_char_ptr_table[4] = {
	&gd_msg[0], &gd_msg[3], &gd_msg2[1], &gpst[4]
};

static void *gd_void_ptrs[4] = {
	&gd_data_sint, gd_msg, gd_raw_chars, &gd_data_struct
};

static int
idx8(i)
int i;
{
	return i & 7;
}

static int
idx5(i)
int i;
{
	return i % 5;
}

static Sint
global_data_read_scalars(i)
int i;
{
	int j;
	Sint sum;

	j = idx8(i);
	sum = gpbs + gpds;
	sum += gd_bss_sint + gd_data_sint;
	sum += (Sint)gd_bss_usint + (Sint)gd_data_usint;
	sum += (Sint)gd_bss_qint + (Sint)gd_data_qint;
	sum += (Sint)gd_bss_uqint + (Sint)gd_data_uqint;
	sum += (Sint)gd_bss_hint + (Sint)gd_data_hint;
	sum += (Sint)gd_bss_uhint + (Sint)gd_data_uhint;
	sum += (Sint)gd_data_i32 + (Sint)gd_data_ui32;
	sum += (Sint)gd_data_dint + (Sint)gd_data_udint;
	sum += (Sint)gd_init_sarr[j] + (Sint)gd_part_sarr[j];
	sum += (Sint)gd_v_sint + (Sint)gd_v_usint;
	return sum;
}

static Sint
global_data_read_bytes(i)
int i;
{
	int j;
	Sint sum;

	j = idx8(i);
	sum = (Sint)gd_data_char + (Sint)gd_data_schar;
	sum += (Sint)gd_data_uchar + (Sint)gpdc;
	sum += (Sint)gd_msg[j] + (Sint)gd_msg2[j];
	sum += (Sint)gd_raw_chars[j];
	sum += (Sint)gd_c6[j] + (Sint)gd_u6[j];
	sum += (Sint)gd_c7[j] + (Sint)gd_u7[j];
	sum += (Sint)gd_c8[j] + (Sint)gd_u8[j];
	sum += (Sint)gd_c9[j] + (Sint)gd_u9[j];
	sum += (Sint)gd_s16[idx5(i)] + (Sint)gd_u16[idx5(i)];
	sum += (Sint)gd_s18[idx5(i)] + (Sint)gd_u18[idx5(i)];
	sum += (Sint)gd_v_char + (Sint)gd_v_uchar;
	return sum;
}

static Sint
global_data_read_structs(i)
int i;
{
	int j;
	Sint sum;

	j = idx5(i);
	sum = (Sint)gd_data_struct.c + (Sint)gd_data_struct.uc;
	sum += (Sint)gd_data_struct.q + (Sint)gd_data_struct.uq;
	sum += (Sint)gd_data_struct.h + (Sint)gd_data_struct.uh;
	sum += gd_data_struct.s + (Sint)gd_data_struct.us;
	sum += (Sint)gd_data_bytes.c6 + (Sint)gd_data_bytes.u6;
	sum += (Sint)gd_data_bytes.c7 + (Sint)gd_data_bytes.u7;
	sum += (Sint)gd_data_bytes.c8 + (Sint)gd_data_bytes.u8;
	sum += (Sint)gd_data_bytes.c9 + (Sint)gd_data_bytes.u9;
	sum += (Sint)gd_data_bytes.s16 + (Sint)gd_data_bytes.u16;
	sum += (Sint)gd_data_bytes.s18 + (Sint)gd_data_bytes.u18;
	sum += (Sint)gd_data_packed.c6[j];
	sum += (Sint)gd_data_packed.c7[j];
	sum += (Sint)gd_data_packed.c8[j];
	sum += (Sint)gd_data_packed.c9[j];
	sum += (Sint)gd_data_packed.h18[j % 3];
	sum += gd_data_union_s.s;
	return sum;
}

static Sint
global_data_use_pointers(i)
int i;
{
	int j;
	Sint sum;

	j = i & 3;
	sum = *gd_ptr_sint + (Sint)*gd_ptr_usint;
	sum += (Sint)gd_ptr_msg0[j] + (Sint)gd_ptr_msg4[-1];
	sum += (Sint)*gd_ptr_raw3;
	sum += (Sint)*gd_ptr_u6 + (Sint)*gd_ptr_u7;
	sum += (Sint)*gd_ptr_u8 + (Sint)*gd_ptr_u9;
	sum += (Sint)*gd_ptr_s18;
	sum += (Sint)*gd_ptr_sarr + (Sint)*gd_ptr_darr;
	sum += (Sint)*gd_ptr_public_string;
	sum += *gd_ptr_const_sint + (Sint)*gd_ptr_const_msg;
	sum += *gd_ptr_table[j];
	sum += (Sint)*gd_char_ptr_table[j];
	sum += *(Sint *)gd_void_ptrs[0];
	return sum;
}

static Sint
global_data_write_bss(i, v)
int i;
Sint v;
{
	int j;

	j = idx8(i);
	gpbs = v;
	gd_bss_sint = v + 1;
	gd_bss_usint = (uSint)(v + 2);
	gd_bss_qint = (Qint)(v + 3);
	gd_bss_uqint = (uQint)(v + 4);
	gd_bss_hint = (Hint)(v + 5);
	gd_bss_uhint = (uHint)(v + 6);
	gd_bss_char = (char)(v + 7);
	gd_bss_uchar = (unsigned char)(v + 8);
	gd_bss_c6[j] = (char6)v;
	gd_bss_u6[j] = (uchar6)(v + 1);
	gd_bss_c7[j] = (char7)(v + 2);
	gd_bss_u7[j] = (uchar7)(v + 3);
	gd_bss_c8[j] = (char8)(v + 4);
	gd_bss_u8[j] = (uchar8)(v + 5);
	gd_bss_c9[j] = (char9)(v + 6);
	gd_bss_u9[j] = (uchar9)(v + 7);
	gd_bss_s16[idx5(i)] = (short16)(v + 8);
	gd_bss_u16[idx5(i)] = (ushort16)(v + 9);
	gd_bss_s18[idx5(i)] = (short18)(v + 10);
	gd_bss_u18[idx5(i)] = (ushort18)(v + 11);
	gd_bss_sarr[j] = v + 12;
	gd_bss_darr[j % 3] = (Dint)v + 13;
	gd_bss_struct.s = v + 14;
	gd_bss_bytes.u9 = (uchar9)(v + 15);
	gd_bss_packed.c9[j % 5] = (char9)(v + 16);
	gd_bss_union.s = v + 17;
	return gpbs + gd_bss_sint + gd_bss_sarr[j]
	    + (Sint)gd_bss_darr[j % 3] + gd_bss_union.s;
}

static Sint
global_data_update_init(i, v)
int i;
Sint v;
{
	int j;

	j = idx8(i);
	gd_data_sint += v;
	gd_data_usint += (uSint)i;
	gd_init_sarr[j] = gd_init_sarr[j] + v;
	gd_part_sarr[j] = gd_part_sarr[j] - v;
	gd_msg[j] = (char)(gd_msg[j] + 1);
	gd_raw_chars[j] = (unsigned char)(gd_raw_chars[j] ^ 0177);
	gd_u9[j] = (uchar9)(gd_u9[j] + 1);
	gd_data_struct.s += v;
	gd_data_struct.h = (Hint)(gd_data_struct.h + i);
	gd_data_bytes.u18 = (ushort18)(gd_data_bytes.u18 + i);
	gd_data_packed.h18[j % 3] = (short18)v;
	gd_data_union_sc.sc.s = v;
	gd_v_sint = gd_v_sint + v;
	return gd_data_sint + gd_data_struct.s + gd_data_union_sc.sc.s
	    + (Sint)gd_data_packed.h18[j % 3];
}

static Sint
global_data_local_static(i)
int i;
{
	static Sint ls_bss;
	static Sint ls_data = 0123;
	static char ls_msg[] = "local";
	static uchar9 ls_u9[4] = { 0, 1, 0776, 0777 };
	int j;

	j = i & 3;
	ls_bss += i;
	ls_data += ls_bss;
	ls_msg[j] = (char)(ls_msg[j] + 1);
	ls_u9[j] = (uchar9)(ls_u9[j] + 1);
	return ls_bss + ls_data + (Sint)ls_msg[j] + (Sint)ls_u9[j];
}

Sint
global_data_mix(i, v)
int i;
Sint v;
{
	return global_data_read_scalars(i)
	    + global_data_read_bytes(i)
	    + global_data_read_structs(i)
	    + global_data_use_pointers(i)
	    + global_data_write_bss(i, v)
	    + global_data_update_init(i, v)
	    + global_data_local_static(i);
}

Sint
use_global_data(i, v)
int i;
Sint v;
{
	return global_data_mix(i, v);
}
