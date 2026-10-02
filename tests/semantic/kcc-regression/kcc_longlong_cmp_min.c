/* kcc_longlong_cmp_min.c - KCC long long compare smoke test. */

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
    Dint x;
    Dint y;
    Dint z;
    fail_id = 0;
    __test_exit = 0;

    x = (Dint)68719482085LL;
    y = (Dint)68719482085LL;
    z = (Dint)1LL;

    if (!check_bool(x == y, 1, 1))
	return fail_id;
    if (!check_bool(x == z, 0, 2))
	return fail_id;
    if (!check_bool(x != z, 1, 3))
	return fail_id;
    if (!check_bool(x != y, 0, 4))
	return fail_id;

    if (!check_bool(x < y, 0, 5))
	return fail_id;
    if (!check_bool(x <= y, 1, 6))
	return fail_id;
    if (!check_bool(x > y, 0, 7))
	return fail_id;
    if (!check_bool(x >= y, 1, 8))
	return fail_id;

    if (!check_bool(x < z, 0, 9))
	return fail_id;
    if (!check_bool(x > z, 1, 10))
	return fail_id;
    if (!check_bool(x <= z, 0, 11))
	return fail_id;
    if (!check_bool(x >= z, 1, 12))
	return fail_id;

    if (!check_pack(signed_cmp_pack(x, y), 051, 13))
	return fail_id;
    if (!check_pack(signed_cmp_pack(x, z), 062, 14))
	return fail_id;
    if (!check_pack(signed_cmp_pack(z, x), 016, 15))
	return fail_id;

    return fail_id;
}
