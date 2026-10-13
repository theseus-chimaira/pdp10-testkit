/* codegen-kcc-check: "shared-fixed-epilogue" */
volatile int __test_exit;

static int
multi_return(int a, int b, int c, int d, int e)
{
    volatile int v[6];

    v[0] = a + e;
    v[1] = b + 2;
    v[2] = c + 3;
    v[3] = d + 4;
    if (a < 0)
        return v[0];
    if (b == 7)
        return v[1];
    if (c > 20)
        return v[2];
    return v[0] + v[1] + v[2] + v[3];
}

int
main(void)
{
    if (multi_return(-3, 1, 2, 3, 9) != 6)
        return 1;
    if (multi_return(1, 7, 2, 3, 9) != 9)
        return 2;
    if (multi_return(1, 1, 21, 3, 9) != 24)
        return 3;
    if (multi_return(1, 1, 2, 3, 9) != 25)
        return 4;
    return 0;
}
