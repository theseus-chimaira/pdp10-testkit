/* A forwarded two-word store must pass both original source words.
 * Check ordinary, split-register/stack and stack-only arguments. */
typedef struct { unsigned long hi, lo; } Pair;
static volatile unsigned long first = 0765432101234UL;
static volatile unsigned long second = 0123456707654UL;
static int pair(Pair p)
{
    return p.hi == first && p.lo == second;
}
static int split(int a, int b, int c, Pair p)
{
    return a == 1 && b == 2 && c == 3 && pair(p);
}
static int stack(int a, int b, int c, int e, Pair p)
{
    return a == 1 && b == 2 && c == 3 && e == 4 && pair(p);
}
int main(void)
{
    Pair p = { 0765432101234UL, 0123456707654UL };
    if (!pair(p)) return 1;
    if (!split(1,2,3,(Pair){0765432101234UL,0123456707654UL})) return 2;
    if (!stack(1,2,3,4,(Pair){0765432101234UL,0123456707654UL})) return 3;
    return 0;
}
