/* kcc_longlong_cmp_sign_min.c - mixed-sign long long ordering regression. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;

static int
check_bool(got, expect, id)
int got;
int expect;
int id;
{
    if ((got != 0) != expect)
	{
	fail_id = id;
	return 0;
	}
    return 1;
}

static int
check_pack(got, expect, id)
int got;
int expect;
int id;
{
    if (got != expect)
	{
	fail_id = id;
	return 0;
	}
    return 1;
}

static int
signed_cmp_pack(a, b)
Dint a;
Dint b;
{
    int r;

    r = 0;
    if (a == b) r = r + 1;
    if (a != b) r = r + 2;
    if (a < b)  r = r + 4;
    if (a <= b) r = r + 8;
    if (a > b)  r = r + 16;
    if (a >= b) r = r + 32;

    return r;
}

int
main()
{
    Dint a;
    Dint n;
    Dint x;
    Dint z;
    Dint n1;
    Dint n2;

    fail_id = 0;
    __test_exit = 0;

    a = (Dint)0123;
    n = -((Dint)0123);
    x = (Dint)68719482085LL;
    z = (Dint)0LL;
    n1 = (Dint)-1LL;
    n2 = (Dint)-2LL;

    /*
     * Encoding:
     * eq=1, ne=2, lt=4, le=8, gt=16, ge=32
     */
    if (!check_pack(signed_cmp_pack(n, a), 016, 1))
	return fail_id;
    if (!check_pack(signed_cmp_pack(a, n), 062, 2))
	return fail_id;
    if (!check_bool(n < a, 1, 3))
	return fail_id;
    if (!check_bool(a > n, 1, 4))
	return fail_id;
    if (!check_bool(n <= a, 1, 5))
	return fail_id;
    if (!check_bool(a >= n, 1, 6))
	return fail_id;
    if (!check_bool(n > a, 0, 7))
	return fail_id;
    if (!check_bool(a < n, 0, 8))
	return fail_id;

    if (!check_pack(signed_cmp_pack(n, x), 016, 9))
	return fail_id;
    if (!check_pack(signed_cmp_pack(x, n), 062, 10))
	return fail_id;
    if (!check_bool(n < x, 1, 11))
	return fail_id;
    if (!check_bool(x > n, 1, 12))
	return fail_id;
    if (!check_bool(x >= n, 1, 13))
	return fail_id;
    if (!check_bool(n <= x, 1, 14))
	return fail_id;
    if (!check_bool(x < n, 0, 15))
	return fail_id;
    if (!check_bool(n >= x, 0, 16))
	return fail_id;

    if (!check_bool(n1 < z, 1, 20))
	return fail_id;
    if (!check_bool(z > n1, 1, 21))
	return fail_id;
    if (!check_bool(n2 < n1, 1, 22))
	return fail_id;
    if (!check_bool(n1 > n2, 1, 23))
	return fail_id;

    return fail_id;
}
