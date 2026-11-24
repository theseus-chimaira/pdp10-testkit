/* Integer-derived D-format values must be normalized even when
   the optimizer would normally fold addition by zero.  Exercise
   unsigned high-bit input, continuation bits, and SF sign copying. */
static volatile unsigned int u;
static volatile int i;
static volatile float f;

int main(void)
{
    double d;
    float s;

    i = 0;
    d = i;
    if (d || d != 0.0) return 1;
    i = -1;
    d = i;
    if (d != -1.0) return 2;
    i = -0400000000000;
    d = i;
    if (d != -34359738368.0) return 3;
    u = 0400000000001U;
    d = u;
    if (d != 34359738369.0) return 4;
    u = 0777777777777U;
    d = u;
    if (d != 68719476735.0) return 5;
    u = 0400000000377U;
    s = u;
    if (s != 34359738368.0F) return 6;
    u = 0400000000401U;
    s = u;
    if (s != 34359738880.0F) return 7;
    u = 0777777777777U;
    s = u;
    if (s != 68719476736.0F) return 8;
    f = -1.25F;
    d = f;
    if (d != -1.25) return 9;
    f = 0.0F;
    d = f;
    if (d) return 10;
    return 0;
}
