/* Exercise independent wide operands and live values across the
   multi-instruction ADD/SUB expansion. All inputs are small enough
   that the separate wide limb representation issues cannot intervene. */
typedef unsigned long long wide;
static volatile unsigned digit_bias;
static volatile wide lhs, rhs;
static volatile wide observed;
volatile unsigned fail_id;

static wide parse(const char *s)
{
    wide acc;
    int d;
    acc = *s++ - '0';
    for (;;) {
        d = *s++;
        if (d == 0) break;
        acc = acc * 10 + (unsigned)(d - '0') + digit_bias;
    }
    return acc;
}

static wide add(wide a, wide b)
{
    wide c = a + b;
    observed = a;
    return c;
}

static wide sub(wide a, wide b)
{
    wide c = a - b;
    observed = b;
    return c;
}

int main(void)
{
    digit_bias = 0;
    fail_id = 1;
    if (parse("1234111111") != 1234111111ULL) return 1;
    fail_id = 2;
    if (parse("1234111127") != 1234111127ULL) return 2;
    lhs = 123456789ULL;
    rhs = 9876543ULL;
    fail_id = 3;
    if (add(lhs, rhs) != 133333332ULL || observed != lhs) return 3;
    fail_id = 4;
    if (sub(lhs, rhs) != 113580246ULL || observed != rhs) return 4;
    fail_id = 5;
    if (lhs + 7ULL != 123456796ULL || lhs - 7ULL != 123456782ULL) return 5;
    fail_id = 0;
    return 0;
}
