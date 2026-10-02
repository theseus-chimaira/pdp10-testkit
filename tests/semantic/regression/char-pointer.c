#include "insns.h"

/*
 * char pointer and scalar-memory address coverage.
 *
 * PDP-10 scalar QI/HI objects may live in sub-word positions even when
 * their enclosing object is word-addressed.  Taking their address and
 * converting it to char * must preserve the byte-pointer position/size
 * information.  This file deliberately exercises global initializers,
 * returned field addresses, casts, dereferences, pointer arithmetic,
 * pointer differences, and volatile pointer reloads.
 */

struct scalar_block {
	char c0, c1, c2, c3, c4, c5, c6, c7;
	unsigned char u0, u1, u2, u3;
	Qint q0, q1, q2, q3, q4, q5, q6, q7, q8, q9;
	uQint uq0, uq1, uq2;
	Hint h0, h1, h2, h3;
	uHint uh0, uh1;
	Sint s0, s1;
};

static struct scalar_block g;
static struct scalar_block ga[3];

static char carr[16];
static unsigned char uarr[16];
static Qint qarr[16];
static uQint uqarr[16];
static Hint harr[8];
static uHint uharr[8];
static Sint sarr[4];

static volatile int sink;
static char *volatile vcp;
static unsigned char *volatile vucp;
static Qint *volatile vqp;
static Hint *volatile vhp;
static Sint *volatile vsp;

#define FIELD_PTRS(T, X) \
static T *ptr_ ## X = &g.X; \
static T *ret_ ## X (void) { return &g.X; } \
static char *retc_ ## X (void) { return (char *)&g.X; } \
static unsigned char *retuc_ ## X (void) { return (unsigned char *)&g.X; }

#define CHAR_FIELD(X) FIELD_PTRS(char, X)
#define UCHAR_FIELD(X) FIELD_PTRS(unsigned char, X)
#define Q_FIELD(X) FIELD_PTRS(Qint, X)
#define UQ_FIELD(X) FIELD_PTRS(uQint, X)
#define H_FIELD(X) FIELD_PTRS(Hint, X)
#define UH_FIELD(X) FIELD_PTRS(uHint, X)
#define S_FIELD(X) FIELD_PTRS(Sint, X)

CHAR_FIELD(c0)
CHAR_FIELD(c1)
CHAR_FIELD(c2)
CHAR_FIELD(c3)
CHAR_FIELD(c4)
CHAR_FIELD(c5)
CHAR_FIELD(c6)
CHAR_FIELD(c7)
UCHAR_FIELD(u0)
UCHAR_FIELD(u1)
UCHAR_FIELD(u2)
UCHAR_FIELD(u3)
Q_FIELD(q0)
Q_FIELD(q1)
Q_FIELD(q2)
Q_FIELD(q3)
Q_FIELD(q4)
Q_FIELD(q5)
Q_FIELD(q6)
Q_FIELD(q7)
Q_FIELD(q8)
Q_FIELD(q9)
UQ_FIELD(uq0)
UQ_FIELD(uq1)
UQ_FIELD(uq2)
H_FIELD(h0)
H_FIELD(h1)
H_FIELD(h2)
H_FIELD(h3)
UH_FIELD(uh0)
UH_FIELD(uh1)
S_FIELD(s0)
S_FIELD(s1)

static char *ptr_carr0 = &carr[0];
static char *ptr_carr5 = &carr[5];
static unsigned char *ptr_uarr7 = &uarr[7];
static char *ptr_qarr0 = (char *)&qarr[0];
static char *ptr_qarr5 = (char *)&qarr[5];
static char *ptr_harr0 = (char *)&harr[0];
static char *ptr_harr3 = (char *)&harr[3];
static char *ptr_sarr0 = (char *)&sarr[0];

static char *
cast_q_to_char(p)
Qint *p;
{
	return (char *)p;
}

static Qint *
cast_char_to_q(p)
char *p;
{
	return (Qint *)p;
}

static char *
cast_h_to_char(p)
Hint *p;
{
	return (char *)p;
}

static Hint *
cast_char_to_h(p)
char *p;
{
	return (Hint *)p;
}

static char *
cast_s_to_char(p)
Sint *p;
{
	return (char *)p;
}

static Sint *
cast_char_to_s(p)
char *p;
{
	return (Sint *)p;
}

static void *
field_to_void(p)
struct scalar_block *p;
{
	return (void *)&p->q7;
}

static char *
void_to_char(p)
void *p;
{
	return (char *)p;
}

static Qint *
void_to_q(p)
void *p;
{
	return (Qint *)p;
}

static char *
scalar_memory_forms(p)
struct scalar_block *p;
{
	return (char *)&p->q7;
}

static char *
scalar_memory_half(p)
struct scalar_block *p;
{
	return (char *)&p->h3;
}

static char *
scalar_memory_word(p)
struct scalar_block *p;
{
	return (char *)&p->s1;
}

static int
load_global_field_pointers(void)
{
	int sum;

	sum = 0;
	sum += *ptr_c0;
	sum += *ptr_c7;
	sum += (int)*ptr_u0;
	sum += (int)*ptr_u3;
	sum += *ptr_q0;
	sum += *ptr_q7;
	sum += (int)*ptr_uq0;
	sum += (int)*ptr_uq2;
	sum += *ptr_h0;
	sum += *ptr_h3;
	sum += (int)*ptr_uh0;
	sum += (int)*ptr_uh1;
	sum += *ptr_s0;
	sum += *ptr_s1;
	return sum;
}

static int
store_global_field_pointers(x)
int x;
{
	*ptr_c0 = (char)x;
	*ptr_c7 = (char)(x + 1);
	*ptr_u0 = (unsigned char)(x + 2);
	*ptr_q0 = (Qint)(x + 3);
	*ptr_q7 = (Qint)(x + 4);
	*ptr_uq1 = (uQint)(x + 5);
	*ptr_h0 = (Hint)(x + 6);
	*ptr_h3 = (Hint)(x + 7);
	*ptr_uh1 = (uHint)(x + 8);
	*ptr_s0 = (Sint)(x + 9);
	return load_global_field_pointers();
}

static int
load_char_views(void)
{
	int sum;

	sum = 0;
	sum += *retc_c0();
	sum += *retc_c7();
	sum += *retc_q0();
	sum += *retc_q5();
	sum += *retc_q9();
	sum += *retc_uq2();
	sum += *retc_h0();
	sum += *retc_h3();
	sum += *retc_s0();
	sum += *retc_s1();
	return sum;
}

static unsigned int
load_uchar_views(void)
{
	unsigned int sum;

	sum = 0;
	sum += (unsigned int)*retuc_c0();
	sum += (unsigned int)*retuc_c7();
	sum += (unsigned int)*retuc_q0();
	sum += (unsigned int)*retuc_q5();
	sum += (unsigned int)*retuc_q9();
	sum += (unsigned int)*retuc_uq2();
	sum += (unsigned int)*retuc_h0();
	sum += (unsigned int)*retuc_h3();
	sum += (unsigned int)*retuc_s0();
	sum += (unsigned int)*retuc_s1();
	return sum;
}

static int
store_char_views(x)
int x;
{
	*retc_q0() = (char)x;
	*retc_q1() = (char)(x + 1);
	*retc_q5() = (char)(x + 5);
	*retc_q9() = (char)(x + 9);
	*retc_h0() = (char)(x + 10);
	*retc_h3() = (char)(x + 11);
	*retc_s1() = (char)(x + 12);
	return load_char_views();
}

static int
array_char_pointer_globals(void)
{
	int sum;

	sum = 0;
	*ptr_carr0 = 1;
	*ptr_carr5 = 2;
	*ptr_uarr7 = 3;
	*ptr_qarr0 = 4;
	*ptr_qarr5 = 5;
	*ptr_harr0 = 6;
	*ptr_harr3 = 7;
	*ptr_sarr0 = 8;
	sum += *ptr_carr0;
	sum += *ptr_carr5;
	sum += (int)*ptr_uarr7;
	sum += *ptr_qarr0;
	sum += *ptr_qarr5;
	sum += *ptr_harr0;
	sum += *ptr_harr3;
	sum += *ptr_sarr0;
	return sum;
}

static char *
array_q_char_addr(i)
int i;
{
	return (char *)&qarr[i];
}

static char *
array_h_char_addr(i)
int i;
{
	return (char *)&harr[i];
}

static char *
array_s_char_addr(i)
int i;
{
	return (char *)&sarr[i];
}

static int
array_char_deref(i, x)
int i;
int x;
{
	char *p;
	char *q;
	char *r;

	p = array_q_char_addr(i);
	q = array_h_char_addr(i & 7);
	r = array_s_char_addr(i & 3);
	*p = (char)x;
	*q = (char)(x + 1);
	*r = (char)(x + 2);
	return *p + *q + *r;
}

static int
field_char_index(p, i)
struct scalar_block *p;
int i;
{
	char *cp;

	cp = (char *)&p->q0;
	return cp[i];
}

static int
field_char_store_index(p, i, x)
struct scalar_block *p;
int i;
int x;
{
	char *cp;

	cp = (char *)&p->q0;
	cp[i] = (char)x;
	return cp[i];
}

static int
field_uchar_index(p, i)
struct scalar_block *p;
int i;
{
	unsigned char *cp;

	cp = (unsigned char *)&p->q0;
	return (int)cp[i];
}

static int
field_pointer_diffs(p)
struct scalar_block *p;
{
	int sum;

	sum = 0;
	sum += (char *)&p->c7 - (char *)&p->c0;
	sum += (char *)&p->q7 - (char *)&p->q0;
	sum += (char *)&p->q9 - (char *)&p->q1;
	sum += (char *)&p->uq2 - (char *)&p->uq0;
	sum += (char *)&p->h3 - (char *)&p->h0;
	sum += (char *)&p->uh1 - (char *)&p->uh0;
	sum += (char *)&p->s1 - (char *)&p->s0;
	return sum;
}

static int
array_pointer_diffs(i, j)
int i;
int j;
{
	int sum;

	sum = 0;
	sum += (char *)&carr[i] - (char *)&carr[j];
	sum += (char *)&qarr[i] - (char *)&qarr[j];
	sum += (char *)&uqarr[i] - (char *)&uqarr[j];
	sum += (char *)&harr[i & 7] - (char *)&harr[j & 7];
	sum += (char *)&uharr[i & 7] - (char *)&uharr[j & 7];
	sum += (char *)&sarr[i & 3] - (char *)&sarr[j & 3];
	return sum;
}

static int
roundtrip_q_char(x)
int x;
{
	char *p;
	Qint *q;

	p = (char *)&g.q3;
	q = cast_char_to_q(p);
	*q = (Qint)x;
	return *p + *q;
}

static int
roundtrip_h_char(x)
int x;
{
	char *p;
	Hint *q;

	p = (char *)&g.h2;
	q = cast_char_to_h(p);
	*q = (Hint)x;
	return *p + *q;
}

static int
roundtrip_s_char(x)
int x;
{
	char *p;
	Sint *q;

	p = (char *)&g.s1;
	q = cast_char_to_s(p);
	*q = (Sint)x;
	return *p + *q;
}

static int
volatile_pointer_reload(i, x)
int i;
int x;
{
	vcp = (char *)&ga[i & 1].q8;
	vucp = (unsigned char *)&ga[i & 1].uq2;
	vqp = (Qint *)vcp;
	vhp = (Hint *)&ga[i & 1].h3;
	vsp = (Sint *)&ga[i & 1].s1;
	*vcp = (char)x;
	*vucp = (unsigned char)(x + 1);
	*vqp = (Qint)(x + 2);
	*vhp = (Hint)(x + 3);
	*vsp = (Sint)(x + 4);
	return *vcp + (int)*vucp + *vqp + *vhp + *vsp;
}

static int
void_bridge(p, x)
struct scalar_block *p;
int x;
{
	void *vp;
	char *cp;
	Qint *qp;

	vp = field_to_void(p);
	cp = void_to_char(vp);
	qp = void_to_q(vp);
	*cp = (char)x;
	*qp = (Qint)(x + 1);
	return *cp + *qp;
}

static int
use_cast_helpers(i)
int i;
{
	char *cp;
	int sum;

	sum = 0;
	cp = cast_q_to_char(&qarr[i]);
	sum += *cp;
	cp = cast_h_to_char(&harr[i & 7]);
	sum += *cp;
	cp = cast_s_to_char(&sarr[i & 3]);
	sum += *cp;
	return sum;
}

static int
use_char_pointer_all(i, x)
int i;
int x;
{
	int sum;

	sum = 0;
	sum += store_global_field_pointers(x);
	sum += store_char_views(x + 10);
	sum += array_char_pointer_globals();
	sum += array_char_deref(i, x + 20);
	sum += field_char_index(&g, i & 7);
	sum += field_char_store_index(&g, i & 7, x + 30);
	sum += field_uchar_index(&g, i & 7);
	sum += field_pointer_diffs(&g);
	sum += array_pointer_diffs(i, i + 3);
	sum += roundtrip_q_char(x + 40);
	sum += roundtrip_h_char(x + 50);
	sum += roundtrip_s_char(x + 60);
	sum += volatile_pointer_reload(i, x + 70);
	sum += void_bridge(&g, x + 80);
	sum += use_cast_helpers(i);
	sum += (int)load_uchar_views();
	sum += *scalar_memory_forms(&g);
	sum += *scalar_memory_half(&g);
	sum += *scalar_memory_word(&g);
	sink = sum;
	return sum;
}
