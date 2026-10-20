/* KCC PDP-6 regression: a signed 71-bit automatic stored in memory
 * must be loaded with its low-word ABI sign copy removed.  Otherwise
 * numerically equal negative values compare different.  C89 dialect
 * with the compiler's long long extension.
 */
extern void abort(void);

volatile long long saved_v1;

static void
check(long long n)
{
    long long r;

    saved_v1 = n;
    r = saved_v1;
    if (r != n)
        abort();
}

int
main(void)
{
    check(0LL);
    check(1LL);
    check(-1LL);
    check(1234567890123LL);
    check(-1234567890123LL);
    return 0;
}
