/* codegen-kcc-check: "memory-result-fold" */
/* codegen-kcc-policy-only: yes */
unsigned long a, b, c, d;

void f_add(x)
unsigned long x;
{
    a += x;
}

void f_and(x)
unsigned long x;
{
    b &= x;
}

void f_or(x)
unsigned long x;
{
    c |= x;
}

void f_xor(x)
unsigned long x;
{
    d ^= x;
}

void f_cand()
{
    b &= 7;
}

void f_cor()
{
    c |= 010;
}

void f_cxor()
{
    d ^= 077;
}

void f_complex(x)
unsigned long x;
{
    a += x + 1;
}

extern unsigned long ext(void);

unsigned long f_reg_call(x)
unsigned long x;
{
    x += ext();
    return x;
}
