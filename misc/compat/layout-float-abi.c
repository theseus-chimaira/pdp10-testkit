struct signed_bits_v10 {
    signed int a:6;
    signed int b:9;
    signed int c:18;
};

struct cross_bits_v10 {
    unsigned int a:20;
    unsigned int b:20;
    unsigned int c:20;
};

int abi_signed_bits_v10(struct signed_bits_v10 x)
{
    return x.a + x.b + x.c;
}

int abi_cross_bits_v10(struct cross_bits_v10 x)
{
    return x.a + x.b + x.c;
}

float abi_float_return_v10(float x)
{
    return x + 1.0f;
}

double abi_double_return_v10(double x)
{
    return x + 1.0;
}

float abi_float_call_v10(float (*fn)(float), float x)
{
    return fn(x);
}

double abi_double_call_v10(double (*fn)(double), double x)
{
    return fn(x);
}

int abi_signed_layout_words_v10(void)
{
    return sizeof(struct signed_bits_v10) / sizeof(int);
}

int abi_cross_layout_words_v10(void)
{
    return sizeof(struct cross_bits_v10) / sizeof(int);
}
