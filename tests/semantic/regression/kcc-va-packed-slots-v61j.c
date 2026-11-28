/* Stack argument extents round to physical 36-bit words, even when
 * the aggregate's C sizeof is not a multiple of sizeof(int). */
#include <stdarg.h>
struct small { char a, b, c; } __attribute__((packed));
struct large { char a, b, c, d, e; } __attribute__((packed));
volatile unsigned fail_id;
static int check(int tag, ...)
{
    va_list ap;
    struct small s;
    struct large l;
    va_start(ap, tag);
    fail_id = 1;
    s = va_arg(ap, struct small);
    if (s.a != 0111 || s.b != 0222 || s.c != 0333) return 1;
    fail_id = 2;
    l = va_arg(ap, struct large);
    if (l.a != 1 || l.b != 2 || l.c != 3 || l.d != 4 || l.e != 5) return 2;
    fail_id = 3;
    if (va_arg(ap, int) != -34359738368L) return 3;
    va_end(ap);
    fail_id = 0;
    return 0;
}
int main(void)
{
    struct small s = {0111, 0222, 0333};
    struct large l = {1, 2, 3, 4, 5};
    if (sizeof(s) != 3 || sizeof(l) != 5) return 4;
    return check(0, s, l, -34359738368L);
}
