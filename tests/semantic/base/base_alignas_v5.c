volatile int __test_exit;

#include "test-compiler-compat-v1.h"
#define ALIGNAS_V5(n) TEST_ALIGNAS(n)

struct alignas_v5_s {
    char a;
    ALIGNAS_V5(2) char b;
    char c;
    ALIGNAS_V5(4) char d;
};

ALIGNAS_V5(4) char alignas_v5_global;

int main(void)
{
    struct alignas_v5_s s;
    ALIGNAS_V5(4) char local;

    if ((char *)&s.b - (char *)&s != 2) return 1;
    if ((char *)&s.d - (char *)&s != 4) return 2;
    (void)alignas_v5_global;
    (void)local;
    return 0;
}
