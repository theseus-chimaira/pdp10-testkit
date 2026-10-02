/* codegen-forbid-form: SET_MEMREF */
volatile int g0;
volatile int g1;
volatile int g2;
int main()
{
    int x;
    x = g2;
    g0 = 0;
    g1 = -1;
    if (x)
        g0 = x;
    return (g0 == x && g1 == -1) ? 0 : 1;
}
