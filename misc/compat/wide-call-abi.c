typedef long long int71_t;

int71_t abi_ret(int71_t x)
{
    return x;
}

int71_t abi_add2(int71_t a, int71_t b)
{
    return a + b;
}

int abi_cmp(int71_t a, int71_t b)
{
    return a < b;
}

int71_t abi_call_ret(int71_t x)
{
    return abi_ret(x);
}

int71_t abi_call_add2(int71_t a, int71_t b)
{
    return abi_add2(a, b);
}
