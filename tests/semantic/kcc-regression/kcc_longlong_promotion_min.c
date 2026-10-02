/* kcc_longlong_promotion_min.c - sizeof and long long declarations. */

volatile int __test_exit;
volatile int fail_id;

typedef long long Dint;
typedef unsigned long long uDint;

static Dint ga;
static uDint gb;

int
main()
{
    int sz_ll;
    int sz_ull;
    int sz_words;
    Dint x;
    uDint y;

    fail_id = 0;
    __test_exit = 0;

    sz_ll = (int)sizeof(long long);
    sz_ull = (int)sizeof(unsigned long long);
    sz_words = (int)sizeof(Dint);

    if (sz_ll != sz_ull)
        fail_id = 1;
    if (sz_ll != sz_words)
        fail_id = 2;
    if (sz_ll < 2)
        fail_id = 3;

    x = ga;
    y = gb;
    ga = x;
    gb = y;

    return fail_id;
}