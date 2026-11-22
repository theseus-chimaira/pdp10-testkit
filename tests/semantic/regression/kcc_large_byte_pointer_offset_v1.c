/* Signed and positive byte-pointer displacement at word boundaries. */
static char bytes[1600];
static short halves[1100];
static volatile int delta = 11;

int main(void)
{
    char *b;
    char *q;
    short *s;
    int n;

    b = bytes + 2;
    q = b + 1003;
    *q = 57;
    if (bytes[1005] != 57)
        return 1;
    q -= 1003;
    if (q != b)
        return 2;

    s = halves + 1;
    s += 503;
    *s = 12345;
    if (halves[504] != 12345)
        return 3;
    s -= 503;
    if (s != halves + 1)
        return 4;

    n = delta;
    q = b + n;
    *q = 71;
    if (bytes[13] != 71)
        return 5;
    q -= n;
    if (q != b)
        return 6;
    return 0;
}
