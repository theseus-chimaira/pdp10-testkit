#include "insns.h"

/*
 * Native 9-bit string literal coverage.
 *
 * This file is intentionally about ordinary C string literals and
 * char-pointer access.  Full 6/7/8/9-bit data-range initializers live
 * in misc/chardata.c; byte extraction and pointer arithmetic have their
 * own misc tests.  Keep this one centered on literal packing,
 * termination, embedded NUL bytes, array initializers, pointer tables,
 * and ordinary char * use.
 */

static char s_empty[] = "";
static char s_word[] = "DAIMON";
static char s_adjacent[] = "PDP" "-" "10";
static char s_embedded[] = "A\000B\000C";
static char s_escapes[] = "\n\t\r\\\"";
static char s_octal9[] = "\000\001\177\200\377\400\777";
static char s_long[] =
	"0123456789"
	"abcdefghijklmnopqrstuvwxyz"
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

static unsigned char us_basic[] = "abc\000def\777";
static signed char ss_basic[] = "abc\000def\377";
static Qint qs_basic[] = { 'q', 'i', 'n', 't', 0, 'l', 'i', 't', 'e', 'r', 'a', 'l', 0 };
static uQint uqs_basic[] = { 'u', 'q', 'i', 'n', 't', 0, 'l', 'i', 't', 'e', 'r', 'a', 'l', 0777, 0 };

static char *p_empty = "";
static char *p_word = "word";
static char *p_embedded = "left\000right";
static char *p_octal9 = "\000\200\377\400\777";
static char *p_table[] = {
	"zero",
	"one\000tail",
	"two\377",
	"three\400\777"
};

struct literal_slot {
	char *p;
	char a[8];
	unsigned char u[8];
	Qint q[8];
};

static struct literal_slot slot = {
	"slot\000pointer",
	"array",
	"uchar\777",
	{ 'q', 'i', 'n', 't', 0, 'x', 0 }
};

static volatile char vchar_sink;
static volatile unsigned char vuchar_sink;
static char mutable_literal_buffer[16] = "mutable";
static char *volatile volatile_literal_pointer = "volatile\000ptr";

static int
literal_sizeof_arrays(void)
{
	return (int)sizeof s_empty
	    + (int)sizeof s_word
	    + (int)sizeof s_adjacent
	    + (int)sizeof s_embedded
	    + (int)sizeof s_octal9
	    + (int)sizeof us_basic
	    + (int)sizeof qs_basic
	   ;
}

static int
literal_sizeof_expr(void)
{
	return (int)sizeof ""
	    + (int)sizeof "A"
	    + (int)sizeof "ABCD"
	    + (int)sizeof "A\000B"
	    + (int)sizeof "\000\001\002\003\004";
}

static int
literal_direct_index(void)
{
	return "DAIMON"[0]
	    + "DAIMON"[5]
	    + "DAIMON"[6]
	    + "A\000B"[1]
	    + "A\000B"[2];
}

static unsigned int
literal_octal_index(void)
{
	return (unsigned char)"\000\001\177\200\377\400\777"[0]
	    + (unsigned char)"\000\001\177\200\377\400\777"[1]
	    + (unsigned char)"\000\001\177\200\377\400\777"[2]
	    + (unsigned char)"\000\001\177\200\377\400\777"[3]
	    + (unsigned char)"\000\001\177\200\377\400\777"[4]
	    + (unsigned char)"\000\001\177\200\377\400\777"[5]
	    + (unsigned char)"\000\001\177\200\377\400\777"[6];
}

static int
literal_array_index(int i)
{
	return s_word[i]
	    + s_adjacent[i & 7]
	    + s_embedded[i & 5]
	    + s_escapes[i & 4];
}

static unsigned int
literal_unsigned_arrays(int i)
{
	return (unsigned int)us_basic[i & 7]
	    + (unsigned int)uqs_basic[i & 15]
	   ;
}

static int
literal_signed_arrays(int i)
{
	return (int)ss_basic[i & 7]
	    + (int)qs_basic[i & 15]
	   ;
}

static int
literal_pointer_index(int i)
{
	return p_word[i & 3]
	    + p_embedded[i & 10]
	    + p_empty[0];
}

static unsigned int
literal_pointer_octal(int i)
{
	char *p;

	p = p_octal9;
	return (unsigned char)p[i & 4]
	    + (unsigned char)p[(i + 1) & 4]
	    + (unsigned char)p[(i + 2) & 4];
}

static char *
literal_return_pointer(int i)
{
	return p_table[i & 3];
}

static int
literal_table_index(int i, int j)
{
	char *p;

	p = literal_return_pointer(i);
	return p[j & 7];
}

static int
literal_cond_pointer(int x)
{
	char *p;

	p = x < 0 ? "negative" : x == 0 ? "zero" : "positive";
	return p[x & 7];
}

static int
literal_scan(char *p)
{
	int n;

	n = 0;
	while (p[n] != 0)
		n++;
	return n;
}

static int
literal_scan_globals(void)
{
	return literal_scan(s_empty)
	    + literal_scan(s_word)
	    + literal_scan(s_embedded)
	    + literal_scan(p_embedded)
	    + literal_scan("local\000tail");
}

static int
literal_sum(char *p, int n)
{
	int i;
	int sum;

	sum = 0;
	for (i = 0; i < n; i++)
		sum += p[i];
	return sum;
}

static unsigned int
literal_usum(unsigned char *p, int n)
{
	int i;
	unsigned int sum;

	sum = 0;
	for (i = 0; i < n; i++)
		sum += p[i];
	return sum;
}

static int
literal_sum_cases(int n)
{
	return literal_sum("abcdef", n & 7)
	    + literal_sum(s_long, n & 63)
	    + (int)literal_usum(us_basic, n & 7)
	    + (int)literal_usum((unsigned char *)"\377\400\777", n & 3);
}

static void
literal_copy_to_buffer(char *d, int n)
{
	char *s;
	int i;

	s = "copy\000tail\777";
	for (i = 0; i < n; i++)
		d[i] = s[i];
}

static int
literal_mutable_store(int x)
{
	mutable_literal_buffer[0] = (char)x;
	mutable_literal_buffer[1] = "XYZ"[x & 3];
	mutable_literal_buffer[2] = s_octal9[x & 6];
	return mutable_literal_buffer[0]
	    + mutable_literal_buffer[1]
	    + mutable_literal_buffer[2];
}

static int
literal_struct_fields(int i)
{
	return slot.p[i & 7]
	    + slot.a[i & 7]
	    + (int)slot.u[i & 7]
	    + slot.q[i & 7];
}

static void
literal_store_volatile(int i)
{
	char *p;

	p = volatile_literal_pointer;
	vchar_sink = p[i & 12];
	vuchar_sink = (unsigned char)"\000\177\200\377\400\777"[i & 5];
}

static int
literal_pass_pointer(int i)
{
	extern void use_char_pointer(char *);
	extern void use_uchar_pointer(unsigned char *);

	use_char_pointer("argument\000tail");
	use_char_pointer(s_word + (i & 3));
	use_uchar_pointer(us_basic + (i & 3));
	return literal_table_index(i, i + 1);
}

static int
literal_pointer_difference(void)
{
	char *p;
	char *q;

	p = s_long + 17;
	q = s_long + 2;
	return p - q;
}

static int
literal_compare_bytes(int i)
{
	unsigned char a;
	unsigned char b;

	a = (unsigned char)p_octal9[i & 4];
	b = (unsigned char)"\000\200\377\400\777"[(i + 1) & 4];
	if (a < b)
		return -1;
	if (a == b)
		return 0;
	return 1;
}

static int
literal_stack_array(int x)
{
	char local[8];
	unsigned char ulocal[8];

	local[0] = "stack"[0];
	local[1] = "stack"[x & 5];
	local[2] = s_embedded[x & 5];
	ulocal[0] = (unsigned char)"\377\400\777"[0];
	ulocal[1] = (unsigned char)"\377\400\777"[1];
	ulocal[2] = (unsigned char)"\377\400\777"[2];
	return local[0] + local[1] + local[2]
	    + (int)ulocal[0] + (int)ulocal[1] + (int)ulocal[2];
}

int
use_string_literals(int x)
{
	char tmp[16];

	literal_copy_to_buffer(tmp, x & 15);
	literal_store_volatile(x);
	return literal_sizeof_arrays()
	    + literal_sizeof_expr()
	    + literal_direct_index()
	    + (int)literal_octal_index()
	    + literal_array_index(x)
	    + (int)literal_unsigned_arrays(x)
	    + literal_signed_arrays(x)
	    + literal_pointer_index(x)
	    + (int)literal_pointer_octal(x)
	    + literal_table_index(x, x + 1)
	    + literal_cond_pointer(x)
	    + literal_scan_globals()
	    + literal_sum_cases(x)
	    + literal_mutable_store(x)
	    + literal_struct_fields(x)
	    + literal_pass_pointer(x)
	    + literal_pointer_difference()
	    + literal_compare_bytes(x)
	    + literal_stack_array(x)
	    + tmp[x & 15];
}
