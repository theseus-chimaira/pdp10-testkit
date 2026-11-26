/* Constant queries must fold at -n as well as optimized compilation.
   None of the operands may be evaluated or require a linker provider. */
extern int missing_function(void);
extern int missing_object;
extern void *alloca(unsigned int);
static volatile int v = 7;
static int ordinary = 9;
static int a[4];
volatile unsigned fail_id;

enum { arithmetic_constant = __builtin_constant_p((1234 + 45) & ~7) };
static int initializer = __builtin_constant_p(missing_function());
static int initializer_effect = __builtin_constant_p(++v);
static int literal_constant = __builtin_constant_p("literal");

static int query_alloca(unsigned int n)
{
    return __builtin_constant_p(alloca(n));
}

static int query_parameter(int n)
{
    return __builtin_constant_p(n + 1);
}

int main(void)
{
    fail_id = 1;
    if (arithmetic_constant != 1 || initializer || initializer_effect ||
        literal_constant != 1) return 1;
    fail_id = 2;
    if (!__builtin_constant_p(1) || !__builtin_constant_p(1.25) ||
        !__builtin_constant_p(1ULL << 40) ||
        !__builtin_constant_p(sizeof(a))) return 2;
    fail_id = 3;
    if (__builtin_constant_p(ordinary) || __builtin_constant_p(v) ||
        __builtin_constant_p(&ordinary) || __builtin_constant_p(a) ||
        __builtin_constant_p(missing_object) ||
        __builtin_constant_p(missing_function())) return 3;
    fail_id = 4;
    if (__builtin_constant_p(v++) || __builtin_constant_p(++ordinary) ||
        __builtin_constant_p(v = 17) ||
        __builtin_constant_p((missing_function(), 1))) return 4;
    if (v != 7 || ordinary != 9) return 4;
    fail_id = 5;
    if (!__builtin_constant_p(__builtin_constant_p(v++)) ||
        !__builtin_constant_p(0 && missing_function()) ||
        query_alloca(31) || query_parameter(12)) return 5;
    if (v != 7 || ordinary != 9) return 5;
    fail_id = 0;
    return 0;
}
