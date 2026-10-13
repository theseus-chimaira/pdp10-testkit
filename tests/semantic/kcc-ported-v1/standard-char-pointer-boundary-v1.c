/* Imported unchanged from KCC shell regression: standard-char-pointer-boundary. */
volatile int __test_exit;
static char *saved;
static char *keep(char *p)
{
    saved = p;
    return saved;
}
int main(void)
{
    char buf[3];
    char *local_null = (void *)0;
    char *p;

    buf[0] = 11;
    buf[1] = 22;
    buf[2] = 33;
    p = keep(buf + 1);
    if (p != buf + 1) return 1;
    if (*p != 22) return 2;
    if (saved != buf + 1) return 3;
    if (local_null != 0) return 4;
    return 0;
}
