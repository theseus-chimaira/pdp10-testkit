/* codegen-require: CAMN IDIV */
/* codegen-forbid-form: POP_AC_AC JFCL1 SET_MEMREF */
volatile int ga;
volatile int gb;
volatile int gq;
volatile int gr;
static int divi(a, b)
int a;
int b;
{
    return a / b;
}
static int modi(a, b)
int a;
int b;
{
    return a % b;
}
int main()
{
    ga = -0400000000000;
    gb = 3;
    gq = divi(ga, gb);
    gr = modi(ga, gb);
    return (gq == 0 && gr == 0) ? 1 : 0;
}
