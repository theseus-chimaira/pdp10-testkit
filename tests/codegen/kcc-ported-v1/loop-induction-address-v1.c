/* codegen-kcc-check: "loop-induction-address" */
/* codegen-kcc-policy-only: yes */
volatile int sink;
extern void use_word(int);

int simple(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a + i;
        s += v[i];
    }
    return s;
}

int with_continue(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        if (i == 2)
            continue;
        v[i] = a + i;
        s += v[i];
    }
    return s;
}

int branch_calls(int a)
{
    int v[6];
    int expect[6];
    int i;
    for (i = 0; i < 6; ++i) {
        if (v[i] != expect[i]) {
            use_word(v[i]);
            use_word(expect[i]);
        }
    }
    return a;
}

int body_write(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        if (a)
            ++i;
        s += v[i];
    }
    return s;
}

int address_taken(int a)
{
    int v[6];
    int i, s = 0;
    int *q = &i;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        s += v[i];
    }
    sink = *q;
    return s;
}

int volatile_array(int a)
{
    volatile int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        s += v[i];
    }
    return s;
}

int byte_array(int a)
{
    char v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
        v[i] = a;
        s += v[i];
    }
    return s;
}

int stride_two(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; i += 2) {
        v[i] = a;
        s += v[i];
    }
    return s;
}

int labelled(int a)
{
    int v[6];
    int i, s = 0;
    for (i = 0; i < 6; ++i) {
again:
        v[i] = a;
        s += v[i];
        if (s == -1)
            goto again;
    }
    return s;
}
