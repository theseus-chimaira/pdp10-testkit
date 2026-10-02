volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

#ifdef __COMPILER_KCC__
#define EXPECT_ARG0 3067
#define EXPECT_ARG1 13633
#else
#define EXPECT_ARG0 2555
#define EXPECT_ARG1 10561
#endif
#define EXPECT_ARG2 139

static int f8(a,b,c,d,e,f,g,h)
char a;
unsigned char b;
short c;
unsigned short d;
char e;
unsigned char f;
short g;
unsigned short h;
{
    return (int)a + (int)b * 2 + (int)c * 3 + (int)d * 4 +
           (int)e * 5 + (int)f * 6 + (int)g * 7 + (int)h * 8;
}

static int chain(a,b,c,d)
char a;
unsigned char b;
short c;
unsigned short d;
{
    return f8(a,b,c,d,(char)(a-1),(unsigned char)(b+1),(short)(c-2),(unsigned short)(d+2));
}

int main()
{
    fail_id = 0;
    got = f8((char)-1, (unsigned char)255, (short)-2, (unsigned short)500,
             (char)3, (unsigned char)4, (short)-5, (unsigned short)6);
    if (got != EXPECT_ARG0) { fail_id = 1; return 1; }
    got1 = chain((char)-7, (unsigned char)200, (short)-300, (unsigned short)1000);
    if (got1 != EXPECT_ARG1) { fail_id = 2; return 1; }
    got2 = chain((char)12, (unsigned char)1, (short)2, (unsigned short)3);
    if (got2 != EXPECT_ARG2) { fail_id = 3; return 1; }
    return 0;
}
