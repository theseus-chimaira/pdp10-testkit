/* Independent physical layout and expression-precision guards.
** Expected values and raw words are computed in Python integers.
*/
typedef unsigned long W;
typedef unsigned long long U;
typedef signed long long S;
volatile unsigned fail_id;

struct shape1 { signed long long field:37; unsigned tail:35; };
static volatile union { struct shape1 f; W raw[2]; } x1 = { { -54670161493LL, 858993459UL } };
static struct shape1 ret1(struct shape1 v) { return v; }
static int check1(void)
{
    if (x1.raw[0] != 0464254742325UL) return 1;
    if (x1.raw[1] != 0406314631463UL) return 1;
    if (x1.f.field != -54670161493LL) return 2;
    if (ret1(x1.f).field != -54670161493LL) return 3;
    x1.f.field = 54670161492ULL;
    if (x1.raw[0] != 0313523035452UL) return 4;
    if (x1.raw[1] != 0006314631463UL) return 4;
    return 0;
}

struct shape2 { unsigned pad:35; unsigned long long field:37; unsigned tail:36; };
static volatile union { struct shape2 f; W raw[3]; } x2 = { { 1431655765UL, 82768791979ULL, 858993459UL } };
static struct shape2 ret2(struct shape2 v) { return v; }
static int check2(void)
{
    if (x2.raw[0] != 0025252525253UL) return 1;
    if (x2.raw[1] != 0150531704653UL) return 1;
    if (x2.raw[2] != 0006314631463UL) return 1;
    if (x2.f.field != 82768791979ULL) return 2;
    if (ret2(x2.f).field != 82768791979ULL) return 3;
    x2.f.field = 54670161492ULL;
    if (x2.raw[0] != 0025252525252UL) return 4;
    if (x2.raw[1] != 0627246073124UL) return 4;
    if (x2.raw[2] != 0006314631463UL) return 4;
    return 0;
}

struct shape3 { unsigned pad:31; signed long long field:71; unsigned tail:6; };
static volatile union { struct shape3 f; W raw[3]; } x3 = { { 1431655765UL, -1180591619466411406933LL, 51UL } };
static struct shape3 ret3(struct shape3 v) { return v; }
static int check3(void)
{
    if (x3.raw[0] != 0525252525260UL) return 1;
    if (x3.raw[1] != 0000000002215UL) return 1;
    if (x3.raw[2] != 0053170465363UL) return 1;
    if (x3.f.field != -1180591619466411406933LL) return 2;
    if (ret3(x3.f).field != -1180591619466411406933LL) return 3;
    x3.f.field = 1180591619466411406932ULL;
    if (x3.raw[0] != 0525252525257UL) return 4;
    if (x3.raw[1] != 0777777775562UL) return 4;
    if (x3.raw[2] != 0724607312463UL) return 4;
    return 0;
}

struct shape4 { unsigned pad:35; unsigned long long field:71; unsigned tail:2; };
static volatile union { struct shape4 f; W raw[3]; } x4 = { { 1431655765UL, 1180591621968411199915ULL, 3UL } };
static struct shape4 ret4(struct shape4 v) { return v; }
static int check4(void)
{
    if (x4.raw[0] != 0025252525253UL) return 1;
    if (x4.raw[1] != 0000000000110UL) return 1;
    if (x4.raw[2] != 0642547423257UL) return 1;
    if (x4.f.field != 1180591621968411199915ULL) return 2;
    if (ret4(x4.f).field != 1180591621968411199915ULL) return 3;
    x4.f.field = 1180591619466411406932ULL;
    if (x4.raw[0] != 0025252525252UL) return 4;
    if (x4.raw[1] != 0777777777667UL) return 4;
    if (x4.raw[2] != 0135230354523UL) return 4;
    return 0;
}

struct shape5 { unsigned pad:18; unsigned long long field:70; unsigned tail:20; };
static volatile union { struct shape5 f; W raw[3]; } x5 = { { 87381UL, 590295811609705548203ULL, 209715UL } };
static struct shape5 ret5(struct shape5 v) { return v; }
static int check5(void)
{
    if (x5.raw[0] != 0252525400000UL) return 1;
    if (x5.raw[1] != 0000110642547UL) return 1;
    if (x5.raw[2] != 0423254631463UL) return 1;
    if (x5.f.field != 590295811609705548203ULL) return 2;
    if (ret5(x5.f).field != 590295811609705548203ULL) return 3;
    x5.f.field = 590295809107705755220ULL;
    if (x5.raw[0] != 0252525377777UL) return 4;
    if (x5.raw[1] != 0777667135230UL) return 4;
    if (x5.raw[2] != 0354520631463UL) return 4;
    return 0;
}

struct shape6 { unsigned pad:12; signed long long field:52; unsigned tail:8; };
static volatile union { struct shape6 f; W raw[2]; } x6 = { { 1365UL, -2250548813788757LL, 51UL } };
static struct shape6 ret6(struct shape6 v) { return v; }
static int check6(void)
{
    if (x6.raw[0] != 0252540011064UL) return 1;
    if (x6.raw[1] != 0254742325463UL) return 1;
    if (x6.f.field != -2250548813788757LL) return 2;
    if (ret6(x6.f).field != -2250548813788757LL) return 3;
    x6.f.field = 2250548813788756ULL;
    if (x6.raw[0] != 0252537766713UL) return 4;
    if (x6.raw[1] != 0523035452063UL) return 4;
    return 0;
}

struct shape7 { unsigned pad:11; signed long long field:53; unsigned tail:8; };
static volatile union { struct shape7 f; W raw[2]; } x7 = { { 1365UL, -4502348627474005LL, 51UL } };
static struct shape7 ret7(struct shape7 v) { return v; }
static int check7(void)
{
    if (x7.raw[0] != 0525300011064UL) return 1;
    if (x7.raw[1] != 0254742325463UL) return 1;
    if (x7.f.field != -4502348627474005LL) return 2;
    if (ret7(x7.f).field != -4502348627474005LL) return 3;
    x7.f.field = 4502348627474004ULL;
    if (x7.raw[0] != 0525277766713UL) return 4;
    if (x7.raw[1] != 0523035452063UL) return 4;
    return 0;
}

struct precision { unsigned long long u:40; signed long long s:40;
                   unsigned long long v:52; unsigned tail:12; };
static volatile struct precision obj = {1099511627775ULL, -1LL, 0ULL, 0123};
static volatile unsigned calls;
static volatile struct precision *get(void) { ++calls; return &obj; }
static int precision_check(void)
{
    U old;
    if ((U)(obj.u + 1) != 0ULL) return 1;
    if (obj.u + 1ULL != 1099511627776ULL) return 2;
    if ((U)(~obj.u) != 0ULL || (U)(-obj.u) != 1ULL) return 3;
    if ((U)(obj.u + obj.s) != 1099511627774ULL) return 4;
    if (obj.s + 1ULL != 0ULL) return 5;
    if (obj.s + obj.v != 4503599627370495ULL) return 6;
    old = get()->u++;
    if (old != 1099511627775ULL || obj.u != 0 || calls != 1) return 7;
    if (--get()->u != 1099511627775ULL || calls != 2) return 8;
    if ((get()->u += 1) != 0ULL || calls != 3 || obj.u != 0) return 9;
    if ((get()->u = 1099511627778ULL) != 2ULL || calls != 4) return 10;
    if (obj.s != -1LL || obj.v != 0 || obj.tail != 0123) return 11;
    return 0;
}

/* Packed arrays may start at arbitrary native byte phases. */
struct packed { unsigned pad:7; signed long long field:40; unsigned tail:7; } __attribute__((packed));
static volatile struct packed pk[2] = {{0123,-3LL,045},{045,-5LL,0123}};
static int packed_check(void)
{
    int i;
    /* Exact six-byte stride, not an ordinary two-word aggregate. */
    if (sizeof(struct packed) != 6 || sizeof(pk) != 12) return 4;
    for (i = 0; i < 2; ++i) {
        if (pk[i].field != -3LL - 2*i) return 1;
        pk[i].field ^= 2LL;
        if (pk[i].field != (-3LL - 2*i ^ 2LL)) return 2;
    }
    if (pk[0].pad != 0123 || pk[0].tail != 045 ||
        pk[1].pad != 045 || pk[1].tail != 0123) return 3;
    return 0;
}

int main(void)
{
    int rc;
    fail_id = 1; if ((rc = check1()) != 0) return rc;
    fail_id = 2; if ((rc = check2()) != 0) return rc;
    fail_id = 3; if ((rc = check3()) != 0) return rc;
    fail_id = 4; if ((rc = check4()) != 0) return rc;
    fail_id = 5; if ((rc = check5()) != 0) return rc;
    fail_id = 6; if ((rc = check6()) != 0) return rc;
    fail_id = 7; if ((rc = check7()) != 0) return rc;
    fail_id = 8; if ((rc = precision_check()) != 0) return rc;
    fail_id = 9; if ((rc = packed_check()) != 0) return rc;
    fail_id = 0;
    return 0;
}
