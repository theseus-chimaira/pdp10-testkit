typedef long long int71_t;

struct five36 { int a, b, c, d, e; };
union words71 { int71_t value; struct { int high, low; } words; };
struct bitpack_v9 { unsigned a:6; unsigned b:9; unsigned c:18; };
typedef int (*abi_fn1_t)(int);

struct five36 abi_ret_five36(int a, int b, int c, int d, int e)
{
    struct five36 r;
    r.a = a; r.b = b; r.c = c; r.d = d; r.e = e;
    return r;
}

int abi_call_five36(void)
{
    struct five36 r = abi_ret_five36(1, 2, 3, 4, 5);
    return r.a + r.e;
}

int abi_union_high(union words71 u)
{
    return u.words.high;
}

int abi_bitpack_sum(struct bitpack_v9 x)
{
    return x.a + x.b + x.c;
}

int abi_increment(int x)
{
    return x + 1;
}

int abi_call_function_pointer(abi_fn1_t f, int x)
{
    return f(x);
}
