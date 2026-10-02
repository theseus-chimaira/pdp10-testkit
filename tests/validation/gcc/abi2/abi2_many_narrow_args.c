volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int mix(a, b, c, d, e, f, g, h, i)
char a;
short b;
char c;
int d;
short e;
char f;
int g;
char h;
short i;
{
    return a + b * 2 + c * 3 + d - e + f * 4 + g + h * 5 - i;
}

int main()
{
    fail_id = 0;
    got = mix((char)3, (short)4, (char)5, 30, (short)6,
              (char)7, 11, (char)8, (short)9);
    if (got != 120) { fail_id = 1; return 1; }
    got1 = mix((char)9, (short)2, (char)1, 10, (short)3,
               (char)4, 5, (char)6, (short)7);
    if (got1 != 67) { fail_id = 2; return 1; }
    return 0;
}
