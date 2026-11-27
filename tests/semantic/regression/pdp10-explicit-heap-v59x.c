/* A caller-owned arena has no heap before explicit initialization.
 * Check exact capacity, overflow, reuse, coalescing and preserved data.
 */
#include <stddef.h>
#include <stdlib.h>
#include <p10heap-arena-v1.h>
static union {
    long double alignment;
    unsigned char bytes[256];
} arena;
volatile unsigned fail_id;
int main(void)
{
    unsigned char *a, *b, *c;
    size_t i;
    fail_id = 1;
    if (malloc(4) || calloc(1, 4) || realloc(0, 4)) return 1;
    p10heap_init_v1(arena.bytes, sizeof(arena.bytes));
    fail_id = 2;
    a = (unsigned char *)malloc(24);
    b = (unsigned char *)malloc(24);
    if (!a || !b || a == b) return 2;
    for (i = 0; i < 24; ++i) a[i] = (unsigned char)(0400 + i);
    fail_id = 3;
    c = (unsigned char *)realloc(a, 48);
    if (!c || c == a) return 3;
    for (i = 0; i < 24; ++i)
        if (c[i] != (unsigned char)(0400 + i)) return 3;
    fail_id = 4;
    if (realloc(c, 256) || malloc((size_t)-1) || calloc((size_t)-1, 2))
        return 4;
    for (i = 0; i < 24; ++i)
        if (c[i] != (unsigned char)(0400 + i)) return 4;
    free(b);
    free(c);
    fail_id = 5;
    a = (unsigned char *)calloc(1, 248);
    if (!a || malloc(1)) return 5;
    for (i = 0; i < 248; ++i)
        if (a[i] != 0) return 5;
    free(a);
    fail_id = 6;
    a = (unsigned char *)malloc(16);
    if (!a || realloc(a, 0) || !malloc(248)) return 6;
    p10heap_init_v1(0, 0);
    if (malloc(1)) return 6;
    fail_id = 0;
    return 0;
}
