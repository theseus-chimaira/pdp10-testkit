volatile int __test_exit;
volatile int fail_id;
volatile int got;

int main(void)
{
    int n, once, keep;
    int first_n;

    fail_id = 0;
    n = 3;
    once = 0;
    keep = 0;
    first_n = n;
    {
        int first[first_n];
        first[0] = 11;
again:
        if (once++) {
            if (first[0] != 11 || keep != 7) {
                fail_id = 1;
                return 1;
            }
        } else {
            int second[n + 1];
            second[0] = 7;
            keep = second[0];
            goto again;
        }
        got = first[0] + keep;
    }
    if (got != 18) { fail_id = 2; return 1; }
    return 0;
}
