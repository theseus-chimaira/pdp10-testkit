/* Hosted DImode folding must not require a host integer wider than 64 bits. */

unsigned long long
uadd71(void)
{
    return (((unsigned long long)0123456701234L << 35) | 076543210123L)
         + (((unsigned long long)0000000000001L << 35) | 000000000007L);
}

unsigned long long
usub71(void)
{
    return (((unsigned long long)0765432107654L << 35) | 012345670123L)
         - (((unsigned long long)0000000000123L << 35) | 000000000077L);
}

unsigned long long
ubit71(void)
{
    return ((((unsigned long long)0712345670123L << 35) | 076543210123L)
          ^ (((unsigned long long)0076543210765L << 35) | 012345670765L));
}

unsigned long long
ulsh71(void)
{
    return (((unsigned long long)0000000000001L << 35) | 000000000003L) << 17;
}

unsigned long long
ursh71(void)
{
    return (((unsigned long long)0765432107654L << 35) | 012345670123L) >> 19;
}

long long
srsh71(void)
{
    return (((long long)0400000000000L << 35) | 012345670123L) >> 13;
}

int
scmp71(void)
{
    return (((long long)0400000000000L << 35) | 1LL)
         < (((long long)0000000000001L << 35) | 1LL);
}

long long
neg71(void)
{
    return -(((long long)0000000000123L << 35) | 076543210123L);
}

unsigned long long
lit34m1(void)
{
    return 0x3ffffffffULL;
}

unsigned long long
lit34(void)
{
    return 0x400000000ULL;
}

unsigned long long
lit35m1(void)
{
    return 0x7ffffffffULL;
}

unsigned long long
lit35(void)
{
    return 0x800000000ULL;
}

unsigned long long
lit36(void)
{
    return 0x1000000000ULL;
}

unsigned long long
lit70(void)
{
    return 0x400000000000000000ULL;
}

unsigned long long
lit70m1(void)
{
    return 0x3fffffffffffffffffULL;
}

unsigned long long
lit70dec(void)
{
    return 1180591620717411303424ULL;
}

long long
litneg70(void)
{
    return -0x400000000000000000LL;
}

unsigned long long
litcast70(void)
{
    return (unsigned long long)0x400000000000000000ULL;
}
