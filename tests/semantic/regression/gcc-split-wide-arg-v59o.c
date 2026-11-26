/* The fifth word of a fixed-argument call straddles the native
   four-AC argument window.  Its stack word and AC word must come
   from the same object, in the established PDP-10 argument order. */
typedef unsigned long long U;
typedef unsigned long W;
typedef union { U wide; struct { W hi, lo; } word; } Pair;
static volatile Pair operand;
static volatile W sentinel[12];
static volatile W hi_seen, lo_seen, tag_seen;
static volatile U a_seen;
volatile unsigned fail_id;

static void __attribute__((noinline))
receive(U a, W tag, U m)
{
    Pair copy;
    copy.wide = m;
    a_seen = a;
    tag_seen = tag;
    hi_seen = copy.word.hi;
    lo_seen = copy.word.lo;
}

static int __attribute__((noinline))
memory_argument(void)
{
    volatile Pair p[5];
    unsigned i;
    for (i = 0; i < 5; ++i) {
        p[i].word.hi = 10 + i;
        p[i].word.lo = 20 + i;
    }
    receive(3ULL, 27, p[0].wide);
    return hi_seen != 10 || lo_seen != 20 || a_seen != 3 || tag_seen != 27;
}

int main(void)
{
    unsigned i;
    for (i = 0; i < 12; ++i) sentinel[i] = 100 + i;
    operand.word.hi = 7;
    operand.word.lo = 1234567;
    fail_id = 1;
    receive(5ULL, 99, operand.wide);
    if (hi_seen != 7 || lo_seen != 1234567 || a_seen != 5 || tag_seen != 99)
        return 1;
    fail_id = 2;
    if (memory_argument()) return 2;
    fail_id = 3;
    receive(5ULL, 101, 42ULL);
    if (hi_seen != 0 || lo_seen != 42 || a_seen != 5 || tag_seen != 101)
        return 3;
    fail_id = 0;
    return 0;
}
