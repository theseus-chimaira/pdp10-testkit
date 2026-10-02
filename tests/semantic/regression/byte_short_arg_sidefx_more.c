volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;

static int mix(a, b, c, p, q)
char a;
unsigned char b;
short c;
char *p;
short *q;
{
    int r;
    r = a + b + c;
    r += *p;
    *p = (char)(*p + a);
    r += *q;
    *q = (short)(*q - c);
    return r + *p + *q;
}

int main()
{
    char ca[4];
    short sa[4];
    fail_id = 0;
    ca[0] = 7;
    ca[1] = 8;
    ca[2] = 9;
    ca[3] = 10;
    sa[0] = 100;
    sa[1] = -20;
    sa[2] = 30;
    sa[3] = -40;
    got = mix((char)3, (unsigned char)200, (short)-5, &ca[1], &sa[1]);
    if (got != 3 + 200 - 5 + 8 - 20 + 11 - 15) { fail_id = 1; return 1; }
    got1 = ca[1] + sa[1];
    if (got1 != -4) { fail_id = 2; return 1; }
    got2 = mix((char)4, (unsigned char)5, (short)6, &ca[2], &sa[2]);
    if (got2 != 4 + 5 + 6 + 9 + 30 + 13 + 24) { fail_id = 3; return 1; }
    got3 = ca[2] + sa[2];
    if (got3 != 37) { fail_id = 4; return 1; }
    return 0;
}
