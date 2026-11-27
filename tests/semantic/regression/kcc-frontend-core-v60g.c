/* C99 tentative arrays, compound literal postfix syntax and GNU aliases.
 * No hosted library or compiler-specific test stub is required. */
#include <stddef.h>

int one[];
int complete[];
extern int complete[3];
int initialized[];
int initialized[] = { 11, 12, 13, 14 };
extern int external_only[];
static int adjacent = 0377;
static __const int const_value = 19;
static __volatile__ unsigned state;
static __signed__ long signed_value = -3;
typedef __PTRDIFF_TYPE__ native_difference;
struct pair { int a, b; };
enum { size_pair = sizeof (struct pair){ 1, 2 } };
enum { is_const = (__extension__ (__builtin_constant_p(9 + 1))) };

int main(void)
{
    native_difference d;
    ptrdiff_t dp;
    int side = 0;
    /* Complete definitions and the implicitly completed one-element array. */
    one[0] = 0135;
    complete[2] = 7;
    d = &complete[2] - &complete[0];
    dp = d;
    if (one[0] != 0135 || adjacent != 0377 || dp != 2)
        return 1;
    if (sizeof complete != 3 * sizeof(int)
        || sizeof initialized != 4 * sizeof(int) || initialized[3] != 14)
        return 2;
    if (size_pair != sizeof(struct pair) || is_const != 1)
        return 3;
    if (sizeof (struct pair){ ++side, ++side }.b != sizeof(int) || side)
        return 4;
    if (sizeof (int[]){ 1, 2, 3 } != 3 * sizeof(int))
        return 5;
    if ((__extension__ (int)const_value) != 19 || signed_value != -3)
        return 6;
    state = 23;
    if (state != 23 || (__extension__ (__builtin_constant_p(state))) != 0)
        return 7;
    return 0;
}
