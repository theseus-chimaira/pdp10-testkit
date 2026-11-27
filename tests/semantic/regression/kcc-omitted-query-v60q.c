/* The omitted true operand is the saved value of the condition. */
static volatile int calls;
static volatile int reads = 7;
static int objects[2] = { 12, 19 };
static int f(int n) { ++calls; return n; }
static int *ptr(int n) { ++calls; return n ? &objects[1] : 0; }
static double fp(double n) { ++calls; return n; }
static int ci = (5 ?: 9);
static int cz = (0 ?: 9);
static unsigned long long cw = ((1ULL << 40) ?: 3ULL);
int main(void)
{
    volatile int v = 5;
    int a;
    if (ci != 5 || cz != 9 || cw != (1ULL << 40)) return 1;
    calls = 0;
    a = f(12) ?: f(33);
    if (a != 12 || calls != 1) return 2;
    a = f(0) ?: f(33);
    if (a != 33 || calls != 3) return 3;
    a = v++ ?: 99;
    if (a != 5 || v != 6) return 4;
    a = reads++ ?: f(55);
    if (a != 7 || reads != 8 || calls != 3) return 5;
    if (*(ptr(1) ?: ptr(0)) != 19 || calls != 4) return 6;
    if (*(ptr(0) ?: &objects[0]) != 12 || calls != 5) return 7;
    if ((fp(2.5) ?: fp(4.0)) != 2.5 || calls != 6) return 8;
    if ((fp(0.0) ?: fp(4.0)) != 4.0 || calls != 8) return 9;
    if (((unsigned long long)f(4) << 40 ?: 1ULL) != (4ULL << 40)
        || calls != 9) return 10;
    if ((0 ?: 0 ?: 8) != 8) return 11;
    return 0;
}
