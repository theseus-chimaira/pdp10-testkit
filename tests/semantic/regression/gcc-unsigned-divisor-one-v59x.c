/* Native DIV quotient is signed: full-width unsigned division by one
 * must not issue DIV. Force runtime divisors and independent constants. */
volatile unsigned long numerator, divisor;
volatile unsigned fail_id;
static unsigned long quotient(unsigned long n, unsigned long d)
{
    return n / d;
}
static unsigned long remainder(unsigned long n, unsigned long d)
{
    return n % d;
}
static int both(unsigned long n, unsigned long d,
                unsigned long q, unsigned long r)
{
    return n / d == q && n % d == r;
}
int main(void)
{
    numerator = 0777777777777UL;
    divisor = 1;
    fail_id = 1;
    if (quotient(numerator, divisor) != 0777777777777UL ||
        remainder(numerator, divisor) != 0 ||
        !both(numerator, divisor, 0777777777777UL, 0)) return 1;
    fail_id = 2;
    numerator = 0400000000000UL;
    if (quotient(numerator, divisor) != 0400000000000UL ||
        remainder(numerator, divisor) != 0 ||
        !both(numerator, divisor, 0400000000000UL, 0)) return 2;
    fail_id = 3;
    numerator = 0777777777777UL;
    divisor = 2;
    if (!both(numerator, divisor, 0377777777777UL, 1)) return 3;
    divisor = 0400000000000UL;
    if (!both(numerator, divisor, 1, 0377777777777UL)) return 3;
    divisor = 0777777777777UL;
    if (!both(numerator, divisor, 1, 0)) return 3;
    numerator = 3;
    if (!both(numerator, divisor, 0, 3)) return 3;
    divisor = 1;
    if (!both(numerator, divisor, 3, 0)) return 3;
    fail_id = 0;
    return 0;
}
