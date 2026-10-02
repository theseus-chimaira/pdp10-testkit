/* codegen-forbid-form: POP_AC_AC JFCL1 SET_MEMREF */
volatile int ga;
volatile int gb;
volatile int sink;
static int h(a, b, c, d, e, f, g, h0)
int a;
int b;
int c;
int d;
int e;
int f;
int g;
int h0;
{
    int local[12];
    int i;
    int s;
    s = 0;
    for (i = 0; i < 12; ++i) {
        local[i] = a + b - c + d - e + f - g + h0 + i;
        s += local[i];
    }
    return s;
}
int main()
{
    ga = 3;
    gb = 5;
    sink = h(ga, gb, 1, 2, 3, 4, 5, 6);
    return sink == 0 ? 1 : 0;
}
