struct abi_one36_v25 {
    int a;
};

struct abi_two36_v25 {
    int a;
    int b;
};

int
abi_take_one_v25(struct abi_one36_v25 x, int y)
{
    return x.a + y;
}

int
abi_take_two_v25(struct abi_two36_v25 x, int y)
{
    return x.a + x.b + y;
}
