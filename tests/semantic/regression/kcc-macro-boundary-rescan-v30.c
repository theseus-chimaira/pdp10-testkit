/* KCC v30: function-like macro replacement crossing an input boundary.
 *
 * The closing ')' of the nested macro invocation is from a surrounding
 * stream.  The inner expansion must no longer hide an earlier macro;
 * recursion within a single replacement still must remain suppressed.
 * Before v30, c(c)(c) left an undefined function reference to c.
 */
static int d = 4;

#define c(x) d
#define d(x) c(2)

#define APPLY(x) NEXT
#define NEXT(x) (x)

#define SELF(x) SELF(x)
#define STR(x) #x
#define XSTR(x) STR(x)

static const char recursion_spelling[] = XSTR(SELF(7));

int main(void)
{
    if (c(c)(c) != 4)
        return 1;
    if (c(9)(9) != 4)
        return 2;
    if (c(c)(9) != 4)
        return 3;
    if (d(9) != 4)
        return 4;
    if (c(9) != 4)
        return 5;
    if (APPLY(0)(17) != 17)
        return 6;
    if (recursion_spelling[0] != 'S' ||
        recursion_spelling[1] != 'E' ||
        recursion_spelling[2] != 'L' ||
        recursion_spelling[3] != 'F' ||
        recursion_spelling[4] != '(' ||
        recursion_spelling[5] != '7' ||
        recursion_spelling[6] != ')' ||
        recursion_spelling[7] != 0)
        return 7;
    return 0;
}
