/* Ordinary C99 casts, independent of the GCC-only historical guards.
   Feed native high36:low35 integer limbs explicitly. The expected
   floating constants do not depend on long long constant folding. */
typedef unsigned long W;
typedef union { long long s; unsigned long long u; W w[2]; } Pair;
static volatile Pair input, output;
static volatile float sf;
static volatile double df;
volatile unsigned fail_id;

int main(void)
{
    input.w[0] = 1;
    input.w[1] = 17;
    fail_id = 1;
    sf = (float)input.s;
    if (sf != 34359738368.0F) return 1;
    fail_id = 2;
    df = (double)input.s;
    if (df != 34359738385.0) return 2;
    fail_id = 3;
    sf = 34359738368.0F;
    output.s = (long long)sf;
    if (output.w[0] != 1 || (output.w[1] & 0377777777777UL) != 0) return 3;
    fail_id = 4;
    df = -34359738385.0;
    output.s = (long long)df;
    if (output.w[0] != 0777777777776UL ||
        (output.w[1] & 0377777777777UL) != 0377777777757UL) return 4;
    fail_id = 0;
    return 0;
}
