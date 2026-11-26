/* A derived address must stay in the same physical AC across loop edges.
 * No prefetch, forged pointers, or external runtime dependencies. */
static unsigned long words[8];
static int global_index;
volatile unsigned fail_id;

static unsigned long
ternary_loop(unsigned int limit)
{
    unsigned int i;
    unsigned long v, sum = 0;
    for (i = 0; i < 8; ++i) {
        v = i < limit ? 1UL << i : 0UL;
        words[i] = v;
        sum += v;
    }
    return sum;
}

static int
nested_values(int a, int b, int c, int d)
{
    int i, total = 0;
    int data[8];
    for (i = 0; i < 8; ++i) {
        data[i] = (i & 1) ? (a + i) * (b + i) : (c + i) * (d + i);
        total += data[i];
    }
    return total;
}

static int
target(int x)
{
    return x + 7;
}

static int
early_or_tail(int x)
{
    int i, a[8];
    for (i = 0; i < 8; ++i)
        a[i] = (i & 1) ? x : x + i;
    if (x == 0)
        return a[6];
    return target(a[7]);
}

static int
full_registers(int x)
{
    register int r0 = x;
    register int r1 = x + 1;
    register int r2 = x + 2;
    register int r3 = x + 3;
    register int r4 = x + 4;
    int i, a[8], total = 0;
    for (i = 0; i < 8; ++i) {
        a[i] = i < 4 ? r0 + r1 + r2 : r2 + r3 + r4;
        total += a[i];
    }
    return total + r0 + r1 + r2 + r3 + r4;
}

static int
dynamic_frame(int n, int early)
{
    int dynamic[n], fixed[8];
    int i, sum = 0;
    dynamic[0] = 17;
    dynamic[n-1] = 29;
    for (i = 0; i < 8; ++i) {
        fixed[i] = i < n ? dynamic[0] + i : dynamic[n-1];
        sum += fixed[i];
    }
    if (early)
        return sum;
    return sum + dynamic[0] + dynamic[n-1];
}

static int
global_loop(void)
{
    int sum = 0;
    for (global_index = 0; global_index < 8; ++global_index) {
        words[global_index] = global_index + 1;
        sum += words[global_index];
    }
    return sum;
}

int main(void)
{
    int i, expect = 0;
    register int saved0 = 101;
    register int saved1 = 102;
    register int saved2 = 103;
    register int saved3 = 104;
    register int saved4 = 105;
    fail_id = 1;
    if (ternary_loop(5) != 31) return 1;
    for (i = 0; i < 8; ++i)
        if (words[i] != (i < 5 ? (1UL << i) : 0UL)) return 1;
    fail_id = 2;
    for (i = 0; i < 8; ++i)
        expect += (i & 1) ? (2+i)*(3+i) : (5+i)*(7+i);
    if (nested_values(2, 3, 5, 7) != expect) return 2;
    fail_id = 3;
    if (early_or_tail(0) != 6 || early_or_tail(11) != 18) return 3;
    fail_id = 4;
    if (full_registers(2) != 116) return 4;
    fail_id = 5;
    if (dynamic_frame(3, 1) != 199 || dynamic_frame(3, 0) != 245) return 5;
    fail_id = 6;
    if (global_loop() != 36 || global_index != 8) return 6;
    for (i = 0; i < 8; ++i)
        if (words[i] != (unsigned long)(i + 1)) return 6;
    fail_id = 7;
    if (saved0 != 101 || saved1 != 102 || saved2 != 103 ||
        saved3 != 104 || saved4 != 105) return 7;
    fail_id = 0;
    return 0;
}
