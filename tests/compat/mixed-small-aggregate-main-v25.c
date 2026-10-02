struct abi_one36_v25 {
    int a;
};

struct abi_two36_v25 {
    int a;
    int b;
};

extern int abi_take_one_v25(struct abi_one36_v25, int);
extern int abi_take_two_v25(struct abi_two36_v25, int);

int
main(void)
{
    struct abi_one36_v25 one;
    struct abi_two36_v25 two;

    one.a = 7;
    if (abi_take_one_v25(one, 11) != 18)
        return 1;

    two.a = 13;
    two.b = 17;
    if (abi_take_two_v25(two, 19) != 49)
        return 2;

    return 0;
}
