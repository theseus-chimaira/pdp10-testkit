/* KCC GNU memory builtins must call the real freestanding libc even
   when a translation unit has static functions with those same names.
   This C89 test also verifies the byte-pointer return values.  */

static int
strcmp(char *a, char *b)
{
    (void)a;
    (void)b;
    return 7;
}

static char *
memcpy(char *dst, char *src, unsigned int len)
{
    (void)dst;
    (void)src;
    (void)len;
    return (char *)0;
}

static char *
memset(char *dst, int ch, unsigned int len)
{
    (void)dst;
    (void)ch;
    (void)len;
    return (char *)0;
}

int
main(void)
{
    char src[8] = "ABCD";
    char dst[8];

    if (__builtin_memcpy(dst, src, 5) != dst) return 1;
    if (__builtin_strcmp(dst, src) != 0) return 2;
    if (strcmp(dst, src) != 7) return 3;
    if (memcpy(dst, src, 5) != (char *)0) return 4;

    if (__builtin_memset(dst + 2, 0, 2) != dst + 2) return 5;
    if (dst[0] != 'A' || dst[1] != 'B') return 6;
    if (dst[2] != 0 || dst[3] != 0 || dst[4] != 0) return 7;
    if (memset(dst, 0, 1) != (char *)0) return 8;

    if (__builtin_strcmp("X", "X\376") >= 0) return 9;
    return 0;
}
