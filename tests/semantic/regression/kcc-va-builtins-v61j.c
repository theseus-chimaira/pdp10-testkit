/* Native descending stack cursor. Every unnamed argument occupies
 * a whole number of 36-bit words, not 32-bit host integer slots.
 * Exercise typed argument syntax without relying on header macros. */
#include <stdarg.h>
typedef __builtin_va_list cursor;
struct pair { unsigned long hi, lo; };
struct triple { int a, b, c; };
struct __attribute__((packed)) small { char a, b, c; };
static int number = 0123456701234L;
static int *numberptr = &number;
static volatile int visits;
volatile unsigned fail_id;
static cursor *visit(cursor *p) { ++visits; return p; }
static int plus(int x) { return x + 1; }
static int check(int tag, ...)
{
    cursor ap, other;
    va_list compat;
    struct pair p;
    struct triple t;
    struct small s;
    int (*fn)(int);
    fail_id = 1;
    __builtin_va_start(ap, tag);
    __builtin_va_copy(other, ap);
    if (__builtin_va_arg(*visit(&ap), unsigned long) != 0777777777777UL || visits != 1)
        return 1;
    if (__builtin_va_arg(other, unsigned long) != 0777777777777UL) return 2;
    fail_id = 2;
    va_copy(compat, ap);
    if (va_arg(compat, long long) != -34359738369LL) return 3;
    if (__builtin_va_arg(ap, long long) != -34359738369LL) return 4;
    if (__builtin_va_arg(ap, double) != 3.25) return 5;
    fail_id = 3;
    if (__builtin_va_arg(ap, int **)[0] != &number) return 6;
    p = __builtin_va_arg(ap, struct pair);
    if (p.hi != 0400000000000UL || p.lo != 0777777777777UL) return 7;
    t = __builtin_va_arg(ap, struct triple);
    if (t.a != 3 || t.b != -5 || t.c != 7) return 8;
    fail_id = 4;
    s = __builtin_va_arg(ap, struct small);
    if (s.a != 1 || s.b != 2 || s.c != 3) return 9;
    fn = __builtin_va_arg(ap, int (*)(int));
    if (fn(9) != 10 || __builtin_va_arg(ap, int) != -11) return 10;
    __builtin_va_end(*visit(&ap));
    if (visits != 2) return 11;
    va_end(compat);
    __builtin_va_end(other);
    return 0;
}
static int last_wide(int a, int b, int c, long long last, ...)
{
    cursor ap;
    int result;
    __builtin_va_start(ap, last);
    if (sizeof(__builtin_va_arg(ap, long long)) != 8) return -1;
    __builtin_va_arg(ap, int); /* Discarded value must advance cursor. */
    result = __builtin_va_arg(ap, int);
    __builtin_va_end(ap);
    return result;
}
int main(void)
{
    struct pair p = {0400000000000UL, 0777777777777UL};
    struct triple t = {3, -5, 7};
    struct small s = {1, 2, 3};
    int rc;
    if (sizeof(s) != 3 || sizeof(int) != 4) return 13;
    rc = check(0, 0777777777777UL, -34359738369LL, 3.25,
                   &numberptr, p, t, s, plus, -11);
    if (rc) return rc;
    fail_id = 5;
    if (last_wide(1, 2, 3, -123456789012LL, 17, 42) != 42) return 12;
    fail_id = 0;
    return 0;
}
