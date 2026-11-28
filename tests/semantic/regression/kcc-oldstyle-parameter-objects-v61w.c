/* Old-style definitions receive promoted arguments, but the parameter
 * objects retain their declared types, sizes, addresses and assignments. */
static volatile int minus_one = -1;
static volatile int high_char = 0400;
static volatile int high_short = 0400000;
static volatile double fractional = 1.000000007450580596923828125;
static int checks(int, int, int, double, int, int);
static int checks(u, c, s, f, us, last)
unsigned char u;
signed char c;
short s;
float f;
unsigned short us;
int last;
{
    unsigned char *p = &u;
    signed char *q = &c;
    short *r = &s;
    float *fp = &f;
    unsigned short *up = &us;
    if (sizeof(u) != 1 || sizeof(c) != 1 || sizeof(s) != 2 ||
        sizeof(f) != 4 || sizeof(us) != 2) return 1;
    if (u != 0777U || *p != 0777U || c != -256 || *q != -256) return 2;
    if (s != -131072 || *r != -131072 || us != 0777777U || *up != 0777777U) return 3;
    if (f != 1.0F || *fp != 1.0F || last != 73) return 4;
    *p = 0177; *q = -17; *r = -23; *fp = 3.5F; *up = 4;
    if (u != 0177 || c != -17 || s != -23 || f != 3.5F || us != 4) return 5;
    return 0;
}
static int regarg(c)
register unsigned char c;
{
    c += 2;
    return c;
}
int main(void)
{
    int rc = checks(minus_one,high_char,high_short,fractional,minus_one,73);
    if (rc) return rc;
    if (regarg(minus_one) != 1) return 6;
    return 0;
}
