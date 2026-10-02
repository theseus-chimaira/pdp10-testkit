/* codegen-forbid-form: POP_AC_AC JFCL1 SET_MEMREF */
volatile int gi;
volatile int gj;
volatile int sink;
static int f(a, b)
int a;
int b;
{
    int local[8];
    int i;
    int s;
    s = 0;
    for (i = 0; i < 8; ++i) {
        local[i] = a + b + i;
        if ((local[i] & 1) != 0)
            s += local[i];
        else
            s -= local[i];
    }
    return s;
}
int main()
{
    gi = 5;
    gj = 2;
    sink = f(gi, gj);
    return sink == -4 ? 0 : 1;
}
