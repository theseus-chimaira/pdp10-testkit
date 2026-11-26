/* Test native high36:low35 multiplication independently of wide
   constant splitting and shifts.  The physical operand pairs and
   product limbs are explicit; expected values use integer arithmetic
   modulo 2^71.  Only the redundant sign position is masked. */
typedef unsigned long long U;
typedef unsigned long W;
typedef union { U wide; struct { W hi, lo; } word; } Pair;
static volatile Pair a, b, result;
volatile unsigned fail_id;

static U __attribute__((noinline)) product(U x, U y)
{
    return x * y;
}

static int check(W ah, W al, W bh, W bl, W zh, W zl)
{
    a.word.hi = ah;
    a.word.lo = al;
    b.word.hi = bh;
    b.word.lo = bl;
    result.wide = product(a.wide, b.wide);
    return result.word.hi != zh ||
           (result.word.lo & 0377777777777UL) != zl;
}

int main(void)
{
    fail_id = 1;
    if (check(0, 0200000000000UL, 0, 2, 1, 0)) return 1;
    fail_id = 2;
    if (check(1, 1, 1, 1, 0400000000002UL, 1)) return 2;
    fail_id = 3;
    if (check(3, 0377777777777UL, 5, 0377777777776UL,
              0777777777762UL, 2)) return 3;
    fail_id = 4;
    if (check(0777777777777UL, 0777777777776UL,
              0777777777777UL, 0777777777777UL, 0, 2)) return 4;
    fail_id = 5;
    if (check(0777777777776UL, 0377777777777UL,
              0777777777775UL, 0377777777777UL, 3, 1)) return 5;
    fail_id = 6;
    if (check(0123456701234UL, 023456701234UL,
              0654321076543UL, 012345670123UL,
              0725704573476UL, 0356774714224UL)) return 6;
    fail_id = 0;
    return 0;
}
