struct abi_five36_v24 {
    int a;
    int b;
    int c;
    int d;
    int e;
};

struct abi_five36_v24
abi_make_five_v24(int a, int b, int c, int d, int e)
{
    struct abi_five36_v24 r;

    r.a = a;
    r.b = b;
    r.c = c;
    r.d = d;
    r.e = e;
    return r;
}
