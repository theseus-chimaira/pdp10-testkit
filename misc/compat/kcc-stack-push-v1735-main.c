/* One stack argument, including pure and side-effecting call sites. */
extern int abi_sum5_v1735(int, int, int, int, int);
extern int abi_sum6_v1735(int, int, int, int, int, int);
extern int abi_tick_v1735(void);
extern int abi_get_sp(void);

int
main(void)
{
    int before, after;
    int a, b, c, d, e;

    before = abi_get_sp();
    if (abi_sum5_v1735(1, 2, 3, 4, 5) != 12345)
        return 1;
    a = 6;
    b = 7;
    c = 8;
    d = 9;
    e = 0;
    if (abi_sum5_v1735(a, b, c, d, e) != 67890)
        return 2;
    if (abi_sum5_v1735(a, b, c, d, abi_tick_v1735()) != 67901)
        return 3;
    if (abi_sum6_v1735(1, 2, 3, 4, 5, 6) != 123456)
        return 5;
    if (abi_sum6_v1735(1, 2, 3, 4, e, 6) != 123406)
        return 6;
    if (abi_sum6_v1735(1, 2, 3, 4, a, b) != 123467)
        return 8;
    if (abi_sum6_v1735(1, 2, 3, 4, 5, abi_tick_v1735()) != 123462)
        return 7;
    after = abi_get_sp();
    if (before != after)
        return 4;
    return 0;
}
