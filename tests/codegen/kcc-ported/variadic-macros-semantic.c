volatile int __test_exit;

#define ADD(a, ...) ((a) + (__VA_ARGS__))
#define CALL(fn, ...) fn(__VA_ARGS__)
#define LIST(...) __VA_ARGS__
#define CAT(a, ...) a ## __VA_ARGS__
#define SUFFIX(...) __VA_ARGS__ ## tail
#define NOTHING(...) __VA_ARGS__
#define BOTH(...) __VA_ARGS__ ## __VA_ARGS__
#define STR(...) #__VA_ARGS__
#define EXPAND(...) __VA_ARGS__

static int sum3(int a, int b, int c)
{
    return a + b + c;
}

static int foo = 11;
static int foo7 = 17;
static int tail = 19;
char *variadic_string = STR(alpha, beta, 3);

int main(void)
{
    int a[3] = { LIST(4, 5, 6) };
    int z = 1 NOTHING();
    int q = 1 BOTH();

    if (ADD(1, 2) != 3) return 1;
    if (CALL(sum3, 1, 2, 3) != 6) return 2;
    if (a[0] != 4 || a[1] != 5 || a[2] != 6) return 3;
    if (CAT(foo, 7) != 17) return 4;
    if (CAT(foo) != 11) return 5;
    if (SUFFIX() != 19) return 6;
    if (z != 1 || q != 1) return 7;
    if (ADD(EXPAND(2), EXPAND(3 + 4)) != 9) return 8;
    return 0;
}
