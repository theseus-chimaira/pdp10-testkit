typedef long long abi_int71_v24;

struct abi_five36_v24 {
    int a;
    int b;
    int c;
    int d;
    int e;
};

typedef struct abi_five36_v24 (*abi_make_fn_v24)(int, int, int, int, int);

extern int abi_get_sp(void);
extern int abi_stack_sum6(int, int, int, int, int, int);
extern int abi_check_preserved_v24(void);
extern struct abi_five36_v24 abi_make_five_v24(int, int, int, int, int);
extern abi_int71_v24 abi_mixed_width_v24(int, abi_int71_v24, int *,
    unsigned char, abi_int71_v24);

static int
check_five_v24(struct abi_five36_v24 r, int base)
{
    return r.a != base || r.b != base + 1 || r.c != base + 2 ||
        r.d != base + 3 || r.e != base + 4;
}

int
main(void)
{
    int before;
    int middle;
    int after;
    int word;
    struct abi_five36_v24 r;
    abi_make_fn_v24 fn;
    abi_int71_v24 wide;

    before = abi_get_sp();
    if (abi_stack_sum6(1, 2, 3, 4, 5, 6) != 21)
        return 1;
    middle = abi_get_sp();
    if (abi_stack_sum6(6, 5, 4, 3, 2, 1) != 21)
        return 2;
    after = abi_get_sp();
    if (before != middle || middle != after)
        return 3;

    if (abi_check_preserved_v24() != 0)
        return 4;

    r = abi_make_five_v24(10, 11, 12, 13, 14);
    if (check_five_v24(r, 10))
        return 5;
    fn = abi_make_five_v24;
    r = (*fn)(20, 21, 22, 23, 24);
    if (check_five_v24(r, 20))
        return 6;

    word = 3;
    wide = abi_mixed_width_v24(1, (abi_int71_v24)2, &word,
        (unsigned char)4, (abi_int71_v24)5);
    if (wide != (abi_int71_v24)15)
        return 7;

    return 0;
}
