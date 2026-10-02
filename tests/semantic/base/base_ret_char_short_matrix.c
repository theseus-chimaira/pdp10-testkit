volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

#ifdef __COMPILER_KCC__
#define EXPECT_RC_NEG 507
#define EXPECT_MIX_NEG 4709
#define EXPECT_MIX_RET 59523
#else
#define EXPECT_RC_NEG (-5)
#define EXPECT_MIX_NEG 4197
#define EXPECT_MIX_RET 59011
#endif

static char rc_neg()
{
    return (char)-5;
}

static unsigned char ruc_hi()
{
    return (unsigned char)250;
}

static short rs_neg()
{
    return (short)-1234;
}

static unsigned short rus_hi()
{
    return (unsigned short)60000U;
}

static int mix(a, b, c, d)
char a;
unsigned char b;
short c;
unsigned short d;
{
    return (int)a + (int)b + (int)c + (int)d;
}

int main()
{
    fail_id = 0;
    got = (int)rc_neg();
    if (got != EXPECT_RC_NEG) { fail_id = 1; return 1; }
    got1 = (int)ruc_hi();
    if (got1 != 250) { fail_id = 2; return 1; }
    got2 = (int)rs_neg();
    if (got2 != -1234) { fail_id = 3; return 1; }
    got3 = (int)rus_hi();
    if (got3 != 60000) { fail_id = 4; return 1; }
    got4 = mix((char)-3, (unsigned char)200, (short)-1000, (unsigned short)5000U);
    if (got4 != EXPECT_MIX_NEG) { fail_id = 5; return 1; }
    got5 = mix(rc_neg(), ruc_hi(), rs_neg(), rus_hi());
    if (got5 != EXPECT_MIX_RET) { fail_id = 6; return 1; }
    return 0;
}
