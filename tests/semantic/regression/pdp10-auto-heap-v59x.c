/* The selected startup, not the allocator library, supplies this arena. */
#include <stdlib.h>
#include <stddef.h>
volatile unsigned fail_id;
volatile unsigned __test_exit;
int main(void)
{
    unsigned char *a, *b;
    size_t i;
    fail_id = 1;
    a = (unsigned char *)malloc(24);
    b = (unsigned char *)calloc(24, 1);
    if (!a || !b || a == b) return 1;
    for (i = 0; i < 24; ++i) {
        if (b[i]) return 1;
        a[i] = (unsigned char)(0500 + i);
    }
    fail_id = 2;
    if (malloc(16384)) return 2;
    for (i = 0; i < 24; ++i)
        if (a[i] != (unsigned char)(0500 + i)) return 2;
    free(a);
    free(b);
    fail_id = 3;
    a = (unsigned char *)malloc(16376);
    if (!a || malloc(1)) return 3;
    a[0] = 0777;
    a[16375] = 0401;
    if (a[0] != 0777 || a[16375] != 0401) return 3;
    free(a);
    fail_id = 0;
    return 0;
}
