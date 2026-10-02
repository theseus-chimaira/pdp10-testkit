/* kcc_longlong_mul_min.c - KCC long long multiply smoke test. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;
typedef unsigned long long UDint;

static Dint ga;
static UDint gua;

static int
check_word(p, off, expect, id)
Dint *p;
int off;
unsigned expect;
int id;
{
    unsigned *w;

    w = (unsigned *)p;
    if (w[off] != expect)
	{
	fail_id = id;
	return 0;
	}
    return 1;
}

int
main()
{
    Dint a;
    Dint b;
    UDint ua;
    UDint ub;

    fail_id = 0;
    __test_exit = 0;

    a = (Dint)0123;
    b = (Dint)0456;
    ga = a * b;
    if (!check_word(&ga, 0, 0, 1))
	return fail_id;
    if (!check_word(&ga, 1, 060752, 2))
	return fail_id;

    ga = (Dint)0 * b;
    if (!check_word(&ga, 0, 0, 3))
	return fail_id;
    if (!check_word(&ga, 1, 0, 4))
	return fail_id;

    ga = (Dint)1 * b;
    if (!check_word(&ga, 0, 0, 5))
	return fail_id;
    if (!check_word(&ga, 1, 0456, 6))
	return fail_id;

    ga = (Dint)-1 * b;
    if (!check_word(&ga, 0, 0777777777777, 7))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777322, 8))
	return fail_id;

    ga = (Dint)-2 * (Dint)0123;
    if (!check_word(&ga, 0, 0777777777777, 9))
	return fail_id;
    if (!check_word(&ga, 1, 0777777777532, 10))
	return fail_id;

    ua = (UDint)0123;
    ub = (UDint)0456;
    gua = ua * ub;
    if (!check_word((Dint *)&gua, 0, 0, 11))
	return fail_id;
    if (!check_word((Dint *)&gua, 1, 060752, 12))
	return fail_id;

    return fail_id;
}
