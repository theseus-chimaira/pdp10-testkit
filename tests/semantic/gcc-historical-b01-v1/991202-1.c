/* GCC execute/991202-1.c: exit condition in an expanding do/while. */
int x, y;
static volatile int initial = 2;
int main(void)
{
    x = initial;
    y = x;
    do {
        x = y;
        y = 2 * y;
    } while (!((y - x) >= 20));
    return x != 32 || y != 64;
}
