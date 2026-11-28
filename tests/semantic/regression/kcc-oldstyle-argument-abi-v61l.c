/* An old-style definition provides diagnostic information, not a
 * prototype. Calls still use the default argument promotions. */
static int old(a, b, c, d, e)
int a;
int b;
double c;
unsigned long d;
long long e;
{
    return a == -257 && b == 0777777 && c == 3.25 &&
           d == 0777777777777UL && e == -34359738369LL;
}
static int plain(a)
int a;
{
    return a == -257;
}
static int declared(int);
static int declared(a)
int a;
{
    return a == -257;
}
int main(void)
{
    volatile short a = -257;
    volatile unsigned short b = 0777777;
    volatile float c = 3.25f;
    volatile unsigned long d = 0777777777777UL;
    volatile long long e = -34359738369LL;
    int (*fp)() = old;
    if (!old(a, b, c, d, e)) return 1;
    if (!fp(a, b, c, d, e)) return 2;
    if (!plain(a) || !declared(a)) return 3;
    return 0;
}
