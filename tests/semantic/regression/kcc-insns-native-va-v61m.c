/* Shared machine-type adapter must expose native GNU variadic builtins.
 * In particular, its old macros must not shadow packed-slot rounding,
 * cursor copy, or the evaluation of va_end's operand. */
#include "insns.h"
#if defined(__builtin_va_start) || defined(__builtin_va_arg) || \
    defined(__builtin_va_copy) || defined(__builtin_va_end)
#error Shared KCC header must not replace native variadic builtins
#endif

struct small { char a, b, c; } __attribute__((packed));
struct large { char a, b, c, d, e; } __attribute__((packed));
static volatile unsigned visits;
static __builtin_va_list *visit(__builtin_va_list *p)
{
    ++visits;
    return p;
}

static int check(int tag, ...)
{
    __builtin_va_list ap, copy;
    struct small s;
    struct large l;
    __builtin_va_start(ap, tag);
    if (__builtin_va_arg(ap, int) != 0777777) return 1;
    if (__builtin_va_arg(ap, uSint) != 0777777777777UL) return 2;
    __builtin_va_copy(copy, ap);
    if (__builtin_va_arg(*visit(&ap), Dint) != -34359738369LL) return 3;
    if (__builtin_va_arg(copy, Dint) != -34359738369LL) return 4;
    s = __builtin_va_arg(ap, struct small);
    if (s.a != 1 || s.b != 2 || s.c != 3) return 5;
    l = __builtin_va_arg(ap, struct large);
    if (l.a != 4 || l.b != 5 || l.c != 6 || l.d != 7 || l.e != 8) return 6;
    if (__builtin_va_arg(ap, Sint) != -34359738368L) return 7;
    __builtin_va_end(*visit(&ap));
    __builtin_va_end(copy);
    return visits == 2 ? 0 : 8;
}

int main(void)
{
    volatile uHint narrow = 0777777;
    struct small s = {1, 2, 3};
    struct large l = {4, 5, 6, 7, 8};
    if (sizeof(Sint) != 4 || sizeof(Dint) != 8 ||
        sizeof(s) != 3 || sizeof(l) != 5) return 9;
    return check(0, narrow, (uSint)0777777777777UL,
                 (Dint)-34359738369LL, s, l, (Sint)-34359738368L);
}
