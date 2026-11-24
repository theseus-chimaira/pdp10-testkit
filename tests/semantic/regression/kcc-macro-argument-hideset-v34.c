/* Preserve recursion suppression when an expanded argument is collected
 * by a second macro invocation. The real functions are deliberately
 * shadowed by recursive macros and must remain callable.
 */
static int twice(int x) { return 2 * x; }
static int triple(int x) { return 3 * x; }
#define twice(x) 2 + twice(x)
#define triple(x) 3 + triple(x)
#define WRAP(x) twice(x)
#define OTHER(x) triple(x)
#define ID(x) x
#define FORWARD(x) ID(x)

int main(void)
{
    if (WRAP(9) != 20) return 1;
    if (WRAP(WRAP(9)) != 42) return 2;
    if (WRAP(WRAP(WRAP(9))) != 86) return 3;
    if (FORWARD(WRAP(WRAP(9))) != 42) return 4;
    if (WRAP(OTHER(4)) != 32) return 5;
    if (OTHER(WRAP(4)) != 33) return 6;
    if (twice(twice(9)) != 42) return 7;
    return 0;
}
