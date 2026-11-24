/* KCC v31: real GNU alloca storage in the caller's dynamic stack frame.
 *
 * Before v31, the compiler emitted a call to an undefined external alloca.
 * Test genuine writable 9-bit byte storage, more than one allocation,
 * separate nested calls, and restoration of SP across function returns.
 * All assertions use the original guest return-value oracle.
 */
volatile int alloca_witness_v31;

static int
callee_v31(int x)
{
    volatile int scratch[4];
    scratch[0] = x;
    scratch[1] = scratch[0] + 1;
    return scratch[1];
}

static int
check_alloca_v31(int count)
{
    unsigned char *first;
    unsigned char *second;
    int *word;
    int i;

    first = (unsigned char *) alloca(count);
    for (i = 0; i < count; ++i)
        first[i] = (unsigned char)((i * 7 + 17) & 255);

    second = (unsigned char *) __builtin_alloca(9);
    for (i = 0; i < 9; ++i)
        second[i] = (unsigned char)(200 + i);

    word = (int *) alloca(4);
    *word = 012345670123;

    if (callee_v31(count) != count + 1)
        return 1;
    for (i = 0; i < count; ++i)
        if (first[i] != (unsigned char)((i * 7 + 17) & 255))
            return 2;
    for (i = 0; i < 9; ++i)
        if (second[i] != (unsigned char)(200 + i))
            return 3;
    if (*word != 012345670123)
        return 4;
    alloca_witness_v31 += first[0] + second[0];
    return 0;
}

int
main(void)
{
    int i;

    for (i = 0; i < 32; ++i)
        if (check_alloca_v31(5 + (i % 29)) != 0)
            return 1;
    if (alloca_witness_v31 != 32 * (17 + 200))
        return 2;
    return 0;
}
