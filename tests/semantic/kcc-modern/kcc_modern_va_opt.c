volatile int __test_exit;

#define ADD_V6(x, ...) ((x) __VA_OPT__(+ (__VA_ARGS__)))
#define CALL_V6(fn, ...) fn(1 __VA_OPT__(, __VA_ARGS__))
#define CAT_V6(prefix, ...) prefix __VA_OPT__(## __VA_ARGS__)

static int f1_v6(int a) { return a; }
static int f2_v6(int a, int b) { return a + b; }
static int foo = 5;
static int foobar = 7;

int main(void)
{
    if (ADD_V6(1) != 1) return 1;
    if (ADD_V6(1, 2) != 3) return 2;
    if (CALL_V6(f1_v6) != 1) return 3;
    if (CALL_V6(f2_v6, 2) != 3) return 4;
    if (CAT_V6(foo) != 5) return 5;
    if (CAT_V6(foo, bar) != 7) return 6;
    return 0;
}
