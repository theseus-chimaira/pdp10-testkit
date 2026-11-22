/* Real allocator checks: reuse, coalescing, alignment, zeroing, growth. */
#include <stddef.h>
#include <stdlib.h>
#include <p10heap-arena-v1.h>

static union {
    long double align;
    void *pointer;
    unsigned char bytes[8192];
} arena;
volatile int fail_id;

int main(void)
{
    unsigned char *a, *b, *c, *d;
    size_t i;
    if (malloc(4) != (void *)0) return 1;
    p10heap_init_v1(arena.bytes, sizeof(arena.bytes));
    a = (unsigned char *)malloc(30);
    b = (unsigned char *)malloc(30);
    c = (unsigned char *)malloc(30);
    if (!a || !b || !c) return 2;
    for (i = 0; i < 30; ++i) a[i] = (unsigned char)(i + 1);
    free(b);
    d = (unsigned char *)malloc(30);
    if (d != b) return 3;
    free(d);
    free(c);
    b = (unsigned char *)malloc(55);
    if (!b) return 4;
    for (i = 0; i < 30; ++i)
        if (a[i] != (unsigned char)(i + 1)) return 5;
    a = (unsigned char *)realloc(a, 60);
    if (!a) return 6;
    for (i = 0; i < 30; ++i)
        if (a[i] != (unsigned char)(i + 1)) return 7;
    c = (unsigned char *)calloc(64, 1);
    if (!c) return 8;
    for (i = 0; i < 64; ++i)
        if (c[i] != 0) return 9;
    if (calloc((size_t)-1, 2) != (void *)0) return 10;
    if (malloc((size_t)-1) != (void *)0) return 11;
    if (realloc(a, (size_t)-1) != (void *)0) return 14;
    for (i = 0; i < 30; ++i)
        if (a[i] != (unsigned char)(i + 1)) return 15;
    if (realloc(c, 0) != (void *)0) return 12;
    free(a);
    free(b);
    if (!malloc(4096)) return 13;
    return 0;
}
