#include "insns.h"

/*
 * Native 9-bit char and QI memory coverage.
 *
 * DAIMON drivers should be able to use plain C char objects, arrays,
 * pointer indexing, volatile device-like locations, and stack locals
 * without open-coding byte extraction.
 *
 * This file is intentionally limited to native 9-bit QI memory.  The
 * non-native 6/7/8-bit packed byte cases live in the byte-extract-* tests.
 */

extern void clobber (void);
extern void use_int (int);
extern void use_uint (unsigned int);

struct qi_pair {
	char c;
	signed char sc;
	unsigned char uc;
	Qint q;
	sQint sq;
	uQint uq;
};

struct qi_packed {
	char a;
	unsigned char b;
	Qint c;
	uQint d;
} __attribute__ ((packed));

union qi_union {
	char c;
	unsigned char uc;
	Qint q;
	uQint uq;
	Sint word;
};

static char ca[17];
static signed char sca[17];
static unsigned char uca[17];
static Qint qa[17];
static sQint sqa[17];
static uQint uqa[17];

static char ca_init[9] = { 0, 1, 2, 3, 4, 5, 6, 7, 010 };
static unsigned char uca_init[9] = {
	(unsigned char)0, (unsigned char)1, (unsigned char)2,
	(unsigned char)3, (unsigned char)0177, (unsigned char)0200,
	(unsigned char)0377, (unsigned char)0400, (unsigned char)0777
};
static Qint qa_init[9] = {
	(Qint)0, (Qint)1, (Qint)-1, (Qint)0177, (Qint)0200,
	(Qint)0377, (Qint)0400, (Qint)0777, (Qint)-0400
};
static uQint uqa_init[9] = {
	(uQint)0, (uQint)1, (uQint)0177, (uQint)0200, (uQint)0377,
	(uQint)0400, (uQint)0777, (uQint)0123, (uQint)0456
};

static char gc;
static signed char gsc;
static unsigned char guc;
static Qint gq;
static sQint gsq;
static uQint guq;

static volatile char vc;
static volatile signed char vsc;
static volatile unsigned char vuc;
static volatile Qint vq;
static volatile sQint vsq;
static volatile uQint vuq;
static volatile char vca[9];
static volatile unsigned char vuca[9];
static volatile Qint vqa[9];
static volatile uQint vuqa[9];

static struct qi_pair qp;
static struct qi_pair qpa[5];
static struct qi_packed qpk;
static union qi_union qu;

static char *gcp = ca;
static unsigned char *gucp = uca;
static Qint *gqp = qa;
static uQint *guqp = uqa;
static volatile char *gvcp = vca;

static int
load_char_index (int i)
{
	return ca[i];
}

static int
load_schar_index (int i)
{
	return sca[i];
}

static unsigned int
load_uchar_index (int i)
{
	return uca[i];
}

static int
load_qint_index (int i)
{
	return qa[i];
}

static int
load_sqint_index (int i)
{
	return sqa[i];
}

static unsigned int
load_uqint_index (int i)
{
	return uqa[i];
}

static int
load_char_ptr (char *p, int i)
{
	return p[i];
}

static int
load_schar_ptr (signed char *p, int i)
{
	return p[i];
}

static unsigned int
load_uchar_ptr (unsigned char *p, int i)
{
	return p[i];
}

static int
load_qint_ptr (Qint *p, int i)
{
	return p[i];
}

static unsigned int
load_uqint_ptr (uQint *p, int i)
{
	return p[i];
}

static int
load_const_boundaries (void)
{
	return ca[0] + ca[3] + ca[4] + ca[7] + ca[8]
	    + ca[15] + ca[16]
	    + (int)uca[0] + (int)uca[3] + (int)uca[4]
	    + (int)uca[7] + (int)uca[8]
	    + qa[0] + qa[3] + qa[4] + qa[7] + qa[8]
	    + (int)uqa[0] + (int)uqa[3] + (int)uqa[4]
	    + (int)uqa[7] + (int)uqa[8];
}

static int
load_initialized_qi (int i)
{
	return ca_init[i] + (int)uca_init[i] + qa_init[i] + (int)uqa_init[i]
	    + ca_init[0] + ca_init[4] + ca_init[8]
	    + (int)uca_init[4] + (int)uca_init[8]
	    + qa_init[2] + qa_init[8]
	    + (int)uqa_init[6];
}

static int
store_char_index (int i, int x)
{
	ca[i] = (char)x;
	sca[i] = (signed char)(x + 1);
	uca[i] = (unsigned char)(x + 2);
	qa[i] = (Qint)(x + 3);
	sqa[i] = (sQint)(x + 4);
	uqa[i] = (uQint)(x + 5);
	return ca[i] + sca[i] + (int)uca[i] + qa[i] + sqa[i]
	    + (int)uqa[i];
}

static int
store_char_ptr (char *p, int i, int x)
{
	p[i] = (char)x;
	p[i + 1] = (char)(x + 1);
	return p[i] + p[i + 1];
}

static unsigned int
store_uchar_ptr (unsigned char *p, int i, unsigned int x)
{
	p[i] = (unsigned char)x;
	p[i + 1] = (unsigned char)(x + 1);
	return (unsigned int)p[i] + (unsigned int)p[i + 1];
}

static int
store_qint_ptr (Qint *p, int i, int x)
{
	p[i] = (Qint)x;
	p[i + 1] = (Qint)(x + 1);
	return p[i] + p[i + 1];
}

static unsigned int
store_uqint_ptr (uQint *p, int i, unsigned int x)
{
	p[i] = (uQint)x;
	p[i + 1] = (uQint)(x + 1);
	return (unsigned int)p[i] + (unsigned int)p[i + 1];
}

static int
post_store_result (int i, int x)
{
	int r;

	r = (ca[i] = (char)x);
	r += (uca[i + 1] = (unsigned char)(x + 1));
	r += (qa[i + 2] = (Qint)(x + 2));
	r += (uqa[i + 3] = (uQint)(x + 3));
	return r;
}

static int
copy_char_ptr (char *d, char *s, int n)
{
	int i;
	int sum;

	sum = 0;
	for (i = 0; i < n; i++) {
		d[i] = s[i];
		sum += d[i];
	}
	return sum;
}

static unsigned int
copy_uchar_ptr (unsigned char *d, unsigned char *s, int n)
{
	int i;
	unsigned int sum;

	sum = 0;
	for (i = 0; i < n; i++) {
		d[i] = s[i];
		sum += d[i];
	}
	return sum;
}

static int
copy_qint_ptr (Qint *d, Qint *s, int n)
{
	int i;
	int sum;

	sum = 0;
	for (i = 0; i < n; i++) {
		d[i] = s[i];
		sum += d[i];
	}
	return sum;
}

static unsigned int
copy_uqint_ptr (uQint *d, uQint *s, int n)
{
	int i;
	unsigned int sum;

	sum = 0;
	for (i = 0; i < n; i++) {
		d[i] = s[i];
		sum += d[i];
	}
	return sum;
}

static int
walk_char_ptr (char *p, int n)
{
	int i;
	int sum;

	sum = 0;
	for (i = 0; i < n; i++)
		sum += *p++;
	return sum;
}

static unsigned int
walk_uchar_ptr (unsigned char *p, int n)
{
	int i;
	unsigned int sum;

	sum = 0;
	for (i = 0; i < n; i++)
		sum += *p++;
	return sum;
}

static int
walk_qint_ptr (Qint *p, int n)
{
	int i;
	int sum;

	sum = 0;
	for (i = 0; i < n; i++)
		sum += *p++;
	return sum;
}

static int
preinc_char_ptr (char *p)
{
	int a;
	int b;

	a = *++p;
	b = *++p;
	return a + b;
}

static int
postinc_char_ptr (char *p)
{
	int a;
	int b;

	a = *p++;
	b = *p++;
	return a + b;
}

static int
load_struct_qi (struct qi_pair *p)
{
	return p->c + p->sc + (int)p->uc + p->q + p->sq + (int)p->uq;
}

static void
store_struct_qi (struct qi_pair *p, int x)
{
	p->c = (char)x;
	p->sc = (signed char)(x + 1);
	p->uc = (unsigned char)(x + 2);
	p->q = (Qint)(x + 3);
	p->sq = (sQint)(x + 4);
	p->uq = (uQint)(x + 5);
}

static int
load_struct_array_qi (int i)
{
	return qpa[i].c + qpa[i].sc + (int)qpa[i].uc
	    + qpa[i].q + qpa[i].sq + (int)qpa[i].uq;
}

static int
store_struct_array_qi (int i, int x)
{
	qpa[i].c = (char)x;
	qpa[i].sc = (signed char)(x + 1);
	qpa[i].uc = (unsigned char)(x + 2);
	qpa[i].q = (Qint)(x + 3);
	qpa[i].sq = (sQint)(x + 4);
	qpa[i].uq = (uQint)(x + 5);
	return load_struct_array_qi (i);
}

static int
load_packed_qi (struct qi_packed *p)
{
	return p->a + (int)p->b + p->c + (int)p->d;
}

static void
store_packed_qi (struct qi_packed *p, int x)
{
	p->a = (char)x;
	p->b = (unsigned char)(x + 1);
	p->c = (Qint)(x + 2);
	p->d = (uQint)(x + 3);
}

static int
use_union_qi (int x)
{
	int r;

	qu.c = (char)x;
	r = qu.c;
	qu.uc = (unsigned char)(x + 1);
	r += (int)qu.uc;
	qu.q = (Qint)(x + 2);
	r += qu.q;
	qu.uq = (uQint)(x + 3);
	r += (int)qu.uq;
	return r + qu.word;
}

static int
load_volatile_qi (void)
{
	return vc + vsc + (int)vuc + vq + vsq + (int)vuq;
}

static int
load_volatile_array_qi (int i)
{
	return vca[i] + (int)vuca[i] + vqa[i] + (int)vuqa[i];
}

static int
store_volatile_qi (int i, int x)
{
	vc = (char)x;
	vsc = (signed char)(x + 1);
	vuc = (unsigned char)(x + 2);
	vq = (Qint)(x + 3);
	vsq = (sQint)(x + 4);
	vuq = (uQint)(x + 5);
	vca[i] = (char)(x + 6);
	vuca[i] = (unsigned char)(x + 7);
	vqa[i] = (Qint)(x + 8);
	vuqa[i] = (uQint)(x + 9);
	return load_volatile_qi () + load_volatile_array_qi (i);
}

static int
stack_qi (int x)
{
	char c[9];
	signed char sc[9];
	unsigned char uc[9];
	Qint q[9];
	sQint sq[9];
	uQint uq[9];
	int i;
	int sum;

	for (i = 0; i < 9; i++) {
		c[i] = (char)(x + i);
		sc[i] = (signed char)(x - i);
		uc[i] = (unsigned char)(x + i + 1);
		q[i] = (Qint)(x + i + 2);
		sq[i] = (sQint)(x - i - 2);
		uq[i] = (uQint)(x + i + 3);
	}

	sum = c[0] + c[3] + c[4] + c[8];
	sum += sc[0] + sc[3] + sc[4] + sc[8];
	sum += (int)uc[0] + (int)uc[3] + (int)uc[4] + (int)uc[8];
	sum += q[0] + q[3] + q[4] + q[8];
	sum += sq[0] + sq[3] + sq[4] + sq[8];
	sum += (int)uq[0] + (int)uq[3] + (int)uq[4] + (int)uq[8];
	return sum;
}

static int
pointer_roundtrip_qi (int i, int x)
{
	char *cp;
	unsigned char *ucp;
	Qint *qp0;
	uQint *uqp;
	void *vp;
	int r;

	cp = ca + i;
	vp = (void *)cp;
	cp = (char *)vp;
	*cp = (char)x;

	ucp = (unsigned char *)cp;
	*ucp = (unsigned char)(x + 1);
	qp0 = (Qint *)ucp;
	*qp0 = (Qint)(x + 2);
	uqp = (uQint *)qp0;
	*uqp = (uQint)(x + 3);

	r = *cp + (int)*ucp + *qp0 + (int)*uqp;
	return r + (int)(cp - ca);
}

static int
reload_global_ptrs (int i, int x)
{
	char *cp;
	unsigned char *ucp;
	Qint *qp0;
	uQint *uqp;
	volatile char *vcp;

	cp = gcp;
	ucp = gucp;
	qp0 = gqp;
	uqp = guqp;
	vcp = gvcp;
	clobber ();
	cp[i] = (char)x;
	ucp[i] = (unsigned char)(x + 1);
	qp0[i] = (Qint)(x + 2);
	uqp[i] = (uQint)(x + 3);
	vcp[i] = (char)(x + 4);
	return cp[i] + (int)ucp[i] + qp0[i] + (int)uqp[i] + vcp[i];
}

static int
compare_qi_values (int i, int x)
{
	int r;

	ca[i] = (char)x;
	sca[i] = (signed char)x;
	uca[i] = (unsigned char)x;
	qa[i] = (Qint)x;
	uqa[i] = (uQint)x;
	r = 0;
	if (sca[i] < (signed char)0)
		r -= 1;
	if (uca[i] > (unsigned char)0177)
		r += 2;
	if (qa[i] == (Qint)x)
		r += 4;
	if (uqa[i] != (uQint)0)
		r += 8;
	return r;
}

static int
scalar_globals_qi (int x)
{
	gc = (char)x;
	gsc = (signed char)(x + 1);
	guc = (unsigned char)(x + 2);
	gq = (Qint)(x + 3);
	gsq = (sQint)(x + 4);
	guq = (uQint)(x + 5);
	return gc + gsc + (int)guc + gq + gsq + (int)guq;
}

static int
call_qi_values (int i)
{
	use_int (ca[i]);
	use_uint (uca[i]);
	use_int (qa[i]);
	use_uint (uqa[i]);
	return ca[i] + (int)uca[i] + qa[i] + (int)uqa[i];
}

int
use_qimem_extract (int x, int i)
{
	int j;
	int r;

	j = i & 7;
	store_char_index (3, x);
	store_struct_qi (&qp, x);
	store_packed_qi (&qpk, x);
	r = 0;
	r += load_char_index (j);
	r += load_schar_index (j);
	r += (int)load_uchar_index (j);
	r += load_qint_index (j);
	r += load_sqint_index (j);
	r += (int)load_uqint_index (j);
	r += load_char_ptr (ca, j);
	r += load_schar_ptr (sca, j);
	r += (int)load_uchar_ptr (uca, j);
	r += load_qint_ptr (qa, j);
	r += (int)load_uqint_ptr (uqa, j);
	r += load_const_boundaries ();
	r += load_initialized_qi (j);
	r += store_char_index (j, x);
	r += store_char_ptr (ca, j, x);
	r += (int)store_uchar_ptr (uca, j, (unsigned int)x);
	r += store_qint_ptr (qa, j, x);
	r += (int)store_uqint_ptr (uqa, j, (unsigned int)x);
	r += post_store_result (j, x);
	r += copy_char_ptr (ca, ca_init, 9);
	r += (int)copy_uchar_ptr (uca, uca_init, 9);
	r += copy_qint_ptr (qa, qa_init, 9);
	r += (int)copy_uqint_ptr (uqa, uqa_init, 9);
	r += walk_char_ptr (ca, 9);
	r += (int)walk_uchar_ptr (uca, 9);
	r += walk_qint_ptr (qa, 9);
	r += preinc_char_ptr (ca);
	r += postinc_char_ptr (ca);
	r += load_struct_qi (&qp);
	r += store_struct_array_qi (j & 3, x);
	r += load_packed_qi (&qpk);
	r += use_union_qi (x);
	r += store_volatile_qi (j, x);
	r += stack_qi (x);
	r += pointer_roundtrip_qi (j, x);
	r += reload_global_ptrs (j, x);
	r += compare_qi_values (j, x);
	r += scalar_globals_qi (x);
	r += call_qi_values (j);
	return r;
}
