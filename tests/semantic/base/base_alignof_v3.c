volatile int __test_exit;

#include "test-compiler-compat-v1.h"
#define ALIGNOF_V3(t) TEST_ALIGNOF(t)

struct alignof_v3_s {
    char c;
    int i;
};

int main(void)
{
    if (ALIGNOF_V3(char) != 1) return 1;
    if (ALIGNOF_V3(short) != 2) return 2;
    if (ALIGNOF_V3(int) != 4) return 3;
    if (ALIGNOF_V3(long) != 4) return 4;
    if (ALIGNOF_V3(float) != 4) return 5;
    if (ALIGNOF_V3(double) != 4) return 6;
    if (ALIGNOF_V3(char *) != 4) return 7;
    if (ALIGNOF_V3(struct alignof_v3_s) != 4) return 8;
    return 0;
}
