static int ticks_v1735;

int
abi_sum5_v1735(int a, int b, int c, int d, int e)
{
    return a * 10000 + b * 1000 + c * 100 + d * 10 + e;
}

int
abi_sum6_v1735(int a, int b, int c, int d, int e, int f)
{
    return a * 100000 + b * 10000 + c * 1000 + d * 100 + e * 10 + f;
}

int
abi_tick_v1735(void)
{
    return ++ticks_v1735 + 10;
}
