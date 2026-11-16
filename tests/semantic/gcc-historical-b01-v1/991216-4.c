/* GCC execute/991216-4.c: nested-loop reversal. */
static volatile int start_size = 5;
static volatile int start_tries = 10;
static int bug(int size, int tries)
{
    int i;
    int num = 0;
    while (num < size) {
        for (i = 1; i < tries; ++i)
            ++num;
    }
    return num;
}
int main(void)
{
    return bug(start_size, start_tries) != 9;
}
