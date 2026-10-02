typedef long long int71_t;

struct pair36 { int a; int b; };
struct pair71 { int71_t v; };
struct quad36 { int a; int b; int c; int d; };

struct pair36 abi_ret_pair36(int a, int b)
{
    struct pair36 r;
    r.a = a;
    r.b = b;
    return r;
}

struct pair71 abi_ret_pair71(int71_t v)
{
    struct pair71 r;
    r.v = v;
    return r;
}

struct quad36 abi_ret_quad36(int a, int b, int c, int d)
{
    struct quad36 r;
    r.a = a;
    r.b = b;
    r.c = c;
    r.d = d;
    return r;
}

int abi_call_pair36(void)
{
    struct pair36 r = abi_ret_pair36(1, 2);
    return r.a + r.b;
}

int71_t abi_call_pair71(int71_t v)
{
    struct pair71 r = abi_ret_pair71(v);
    return r.v;
}
