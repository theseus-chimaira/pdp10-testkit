/* Constant field references in small automatic arrays can be backed by
   a register, not memory.  Cover reads and writes with live values,
   including adjacent subword fields and both words of a register pair. */
static volatile int seed = 7;
volatile int fail_id;

int main(void)
{
    struct pair { int a, b; } pair[1];
    struct small { signed char a; unsigned char b; short c; } small[1];
    int n = seed;

    pair[0].a = n;
    pair[0].b = n + 3;
    if (pair[0].a != 7 || pair[0].b != 10) {
        fail_id = 1; return 1;
    }
    pair[0].b += seed;
    if (pair[0].a != 7 || pair[0].b != 17) {
        fail_id = 2; return 1;
    }

    small[0].a = -n;
    small[0].b = 0400 + n;
    small[0].c = -1000 - n;
    if (small[0].a != -7 || small[0].b != 0407 || small[0].c != -1007) {
        fail_id = 3; return 1;
    }
    small[0].b += seed;
    if (small[0].a != -7 || small[0].b != 0416 || small[0].c != -1007) {
        fail_id = 4; return 1;
    }
    return 0;
}
