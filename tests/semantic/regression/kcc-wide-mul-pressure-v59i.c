/* Test destructive multiplication of two high36:low35 operands.
   Expected limbs were calculated independently modulo 2^71. */
typedef unsigned long long U;
typedef unsigned long W;
static volatile U a, b;
static volatile W x, y;

static U product(U p, U q) { return p * q; }
static U scalar_product(W p, W q) { return (U)p * (U)q; }
static void save(U z) { a = z; }
static void pressured(W p, W q, W r)
{
    U z;
    z = ((U)p + r) * (U)q;
    save(z);
}

static int check(W ah, W al, W bh, W bl, W zh, W zl)
{
    U z;
    a = ((U)ah << 35) | al;
    b = ((U)bh << 35) | bl;
    z = product(a, b);
    return (W)(z >> 35) != zh || ((W)z & 0377777777777UL) != zl;
}

int main(void)
{
    if (check(01UL, 00UL, 01UL, 00UL, 0400000000000UL, 00UL)) return 1;
    if (check(01UL, 01UL, 01UL, 01UL, 0400000000002UL, 01UL)) return 2;
    if (check(03UL, 0377777777777UL, 05UL, 0377777777776UL, 0777777777762UL, 02UL)) return 3;
    if (check(0777777777777UL, 0377777777777UL, 0777777777777UL, 0377777777777UL, 00UL, 01UL)) return 4;
    if (check(0777777777777UL, 00UL, 01UL, 00UL, 0400000000000UL, 00UL)) return 5;
    if (check(01UL, 00UL, 0777777777777UL, 00UL, 0400000000000UL, 00UL)) return 6;
    if (check(0777777777776UL, 0377777777777UL, 0777777777775UL, 0377777777777UL, 03UL, 01UL)) return 7;
    if (check(0400000000000UL, 00UL, 02UL, 00UL, 00UL, 00UL)) return 8;
    if (check(00UL, 0377777777777UL, 00UL, 0377777777777UL, 0377777777776UL, 01UL)) return 9;
    if (check(00UL, 0377777777777UL, 01UL, 0377777777777UL, 0777777777775UL, 01UL)) return 10;
    if (check(0123456701234UL, 023456701234UL, 0654321076543UL, 012345670123UL, 0725704573476UL, 0356774714224UL)) return 11;

    /* Two scalar arguments remain reserved during wide evaluation. */
    x = 0400000000003UL;
    y = 0400000000005UL;
    a = scalar_product(x, y);
    if ((W)(a >> 35) != 0400000000010UL || (a & 0377777777777ULL) != 15)
        return 12;
    /* Three reserved argument ACs leave only the two operand pairs.
       The saved low word must then occupy one transient stack slot. */
    pressured(0400000000002UL, 0400000000005UL, 1);
    if ((W)(a >> 35) != 0400000000010UL || (a & 0377777777777ULL) != 15)
        return 13;
    return 0;
}
