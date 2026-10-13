extern int abi_clobber_v24(int);

int
abi_pressure_v24(int a, int b, int c, int d)
{
    int x1 = a + 1;
    int x2 = b + 2;
    int x3 = c + 3;
    int x4 = d + 4;
    int x5 = a + b + 5;
    int x6 = c + d + 6;
    int q = abi_clobber_v24(a + b + c + d);

    return x1 + x2 + x3 + x4 + x5 + x6 + q;
}
