#include "insns.h"

/*
 * Ordinary function pointer and indirect-call coverage.
 *
 * This is not computed-goto work.  It checks the normal C cases DAIMON
 * might use: conditional function pointers, function-pointer tables,
 * function pointers stored in structures, callbacks passed as arguments,
 * and function pointers returned from helper functions.
 */

typedef int (*ifn) (int);
typedef unsigned int (*ufn) (unsigned int);
typedef int (*binfn) (int, int);
typedef void (*vfn) (int *);
typedef Qint (*qfn) (Qint);
typedef uQint (*uqfn) (uQint);
typedef Hint (*hfn) (Hint);
typedef uHint (*uhfn) (uHint);
typedef char (*cfn) (char);
typedef unsigned char (*ucfn) (unsigned char);

struct fp_slot {
	ifn fn;
	int bias;
};

struct fp_pair {
	ifn left;
	ifn right;
};

struct fp_table_slot {
	ifn fn[3];
	int bias[3];
};

struct bin_slot {
	binfn fn;
	int lhs;
	int rhs;
};

struct cb_slot {
	vfn fn;
	int value;
};

static int fp_one (int x) { return x + 1; }
static int fp_two (int x) { return x + 2; }
static int fp_three (int x) { return x + 3; }
static int fp_neg (int x) { return -x; }
static int fp_not (int x) { return ~x; }

static unsigned int ufp_one (unsigned int x) { return x + 1; }
static unsigned int ufp_flip (unsigned int x) { return x ^ 077; }

static int bin_add (int a, int b) { return a + b; }
static int bin_sub (int a, int b) { return a - b; }
static int bin_mul_small (int a, int b) { return a * b; }

static void cb_inc (int *p) { *p = *p + 1; }
static void cb_neg (int *p) { *p = -*p; }

static Qint q_inc (Qint x) { return (Qint)(x + 1); }
static Qint q_neg (Qint x) { return (Qint)-x; }
static uQint uq_inc (uQint x) { return (uQint)(x + 1); }
static Hint h_inc (Hint x) { return (Hint)(x + 1); }
static Hint h_neg (Hint x) { return (Hint)-x; }
static uHint uh_inc (uHint x) { return (uHint)(x + 1); }
static char c_inc (char x) { return (char)(x + 1); }
static unsigned char uc_inc (unsigned char x) { return (unsigned char)(x + 1); }

static ifn g_ifn = fp_one;
static ifn g_ifn2 = fp_two;
static ifn g_ifn_table[5] = { fp_one, fp_two, fp_three, fp_neg, fp_not };
static ufn g_ufn_table[2] = { ufp_one, ufp_flip };
static binfn g_bin_table[3] = { bin_add, bin_sub, bin_mul_small };
static vfn g_cb_table[2] = { cb_inc, cb_neg };
static qfn g_q_table[2] = { q_inc, q_neg };
static uqfn g_uq_table[1] = { uq_inc };
static hfn g_h_table[2] = { h_inc, h_neg };
static uhfn g_uh_table[1] = { uh_inc };
static cfn g_c_table[1] = { c_inc };
static ucfn g_uc_table[1] = { uc_inc };

static ifn volatile v_ifn;
static binfn volatile v_binfn;
static vfn volatile v_vfn;

static struct fp_slot g_slot = { fp_two, 10 };
static struct fp_pair g_pair = { fp_one, fp_neg };
static struct fp_slot g_slots[3] = {
	{ fp_one, 1 },
	{ fp_two, 2 },
	{ fp_neg, 3 }
};
static struct fp_table_slot g_table_slot = {
	{ fp_one, fp_two, fp_neg },
	{ 1, 2, 3 }
};
static struct bin_slot g_bin_slot = { bin_add, 4, 5 };
static struct cb_slot g_cb_slot = { cb_inc, 7 };

static int
call_fp_arg (ifn fp, int x)
{
	return (*fp) (x);
}

static int
call_fp_global (int x)
{
	return (*g_ifn) (x) + (*g_ifn2) (x);
}

static int
call_fp_cond (int n)
{
	ifn fp;

	fp = n ? fp_one : fp_two;
	return (*fp) (n);
}

static ifn
choose_fp_cond (int n)
{
	if (n < 0)
		return fp_neg;
	if (n == 0)
		return fp_one;
	return fp_two;
}

static int
call_fp_returned (int n, int x)
{
	ifn fp;

	fp = choose_fp_cond (n);
	return (*fp) (x);
}

static int
call_fp_table_local (int i, int x)
{
	ifn fp_table[4];

	fp_table[0] = fp_one;
	fp_table[1] = fp_two;
	fp_table[2] = fp_three;
	fp_table[3] = fp_neg;
	return (*fp_table[i & 3]) (x);
}

static int
call_fp_table_static (int i, int x)
{
	static ifn fp_table[4] = { fp_one, fp_two, fp_three, fp_not };

	return (*fp_table[i & 3]) (x);
}

static int
call_fp_table_global (int i, int x)
{
	return (*g_ifn_table[i % 5]) (x);
}

static int
call_fp_struct (struct fp_slot *p, int x)
{
	return (*p->fn) (x + p->bias);
}

static int
call_fp_global_struct (int x)
{
	return (*g_slot.fn) (x + g_slot.bias);
}

static int
call_fp_struct_array (int i, int x)
{
	struct fp_slot *p;

	p = &g_slots[i % 3];
	return (*p->fn) (x + p->bias);
}

static int
call_fp_struct_table (int i, int x)
{
	struct fp_table_slot *p;

	p = &g_table_slot;
	return (*p->fn[i % 3]) (x + p->bias[i % 3]);
}

static int
call_fp_pair (int n, int x)
{
	ifn fp;

	fp = n ? g_pair.left : g_pair.right;
	return (*fp) (x);
}

static int
call_fp_pointer (ifn *pp, int x)
{
	ifn fp;

	fp = *pp;
	return (*fp) (x);
}

static int
store_fp_pointer (ifn *pp, int n)
{
	*pp = n ? fp_neg : fp_one;
	return (**pp) (n);
}

static int
call_fp_volatile (ifn fp, int x)
{
	v_ifn = fp;
	return (*v_ifn) (x);
}

static int
compare_fp (ifn fp, int x)
{
	if (fp == fp_one)
		return (*fp) (x) + 1;
	if (fp != fp_neg)
		return (*fp) (x) + 2;
	return (*fp) (x) + 3;
}

static int
call_bin_arg (binfn fp, int a, int b)
{
	return (*fp) (a, b);
}

static int
call_bin_table (int i, int a, int b)
{
	return (*g_bin_table[i % 3]) (a, b);
}

static int
call_bin_struct (struct bin_slot *p)
{
	return (*p->fn) (p->lhs, p->rhs);
}

static int
call_bin_volatile (binfn fp, int a, int b)
{
	v_binfn = fp;
	return (*v_binfn) (a, b);
}

static int
call_unsigned_fp (int i, unsigned int x)
{
	ufn fp;

	fp = g_ufn_table[i & 1];
	return (int)(*fp) (x);
}

static int
call_callback (vfn fp, int x)
{
	(*fp) (&x);
	return x;
}

static int
call_callback_table (int i, int x)
{
	vfn fp;

	fp = g_cb_table[i & 1];
	(*fp) (&x);
	return x;
}

static int
call_callback_struct (struct cb_slot *p)
{
	int x;

	x = p->value;
	(*p->fn) (&x);
	return x;
}

static int
call_callback_volatile (vfn fp, int x)
{
	v_vfn = fp;
	(*v_vfn) (&x);
	return x;
}

static int
call_small_return (int i, int x)
{
	Qint q;
	uQint uq;
	Hint h;
	uHint uh;
	char c;
	unsigned char uc;

	q = (*g_q_table[i & 1]) ((Qint)x);
	uq = (*g_uq_table[0]) ((uQint)x);
	h = (*g_h_table[i & 1]) ((Hint)x);
	uh = (*g_uh_table[0]) ((uHint)x);
	c = (*g_c_table[0]) ((char)x);
	uc = (*g_uc_table[0]) ((unsigned char)x);
	return (int)q + (int)uq + (int)h + (int)uh + (int)c + (int)uc;
}

static int
call_local_struct (int n, int x)
{
	struct fp_slot slot;
	struct fp_pair pair;
	ifn fp;

	slot.fn = n ? fp_three : fp_not;
	slot.bias = n + 4;
	pair.left = slot.fn;
	pair.right = fp_two;
	fp = n ? pair.left : pair.right;
	return (*fp) (x + slot.bias);
}

static int
use_function_pointer (int i, int x)
{
	ifn local;
	int sum;

	local = fp_two;
	sum = 0;
	sum += call_fp_arg (local, x);
	sum += call_fp_global (x);
	sum += call_fp_cond (x);
	sum += call_fp_returned (i, x);
	sum += call_fp_table_local (i, x);
	sum += call_fp_table_static (i, x);
	sum += call_fp_table_global (i, x);
	sum += call_fp_struct (&g_slot, x);
	sum += call_fp_global_struct (x);
	sum += call_fp_struct_array (i, x);
	sum += call_fp_struct_table (i, x);
	sum += call_fp_pair (i, x);
	sum += call_fp_pointer (&local, x);
	sum += store_fp_pointer (&local, x);
	sum += call_fp_volatile (local, x);
	sum += compare_fp (local, x);
	sum += call_bin_arg (bin_add, x, i);
	sum += call_bin_table (i, x, i);
	sum += call_bin_struct (&g_bin_slot);
	sum += call_bin_volatile (bin_sub, x, i);
	sum += call_unsigned_fp (i, (unsigned int)x);
	sum += call_callback (cb_inc, x);
	sum += call_callback_table (i, x);
	sum += call_callback_struct (&g_cb_slot);
	sum += call_callback_volatile (cb_neg, x);
	sum += call_small_return (i, x);
	sum += call_local_struct (i, x);
	return sum;
}
