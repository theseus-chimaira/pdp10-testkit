volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

static int sum_matrix(int n, int m, int a[n][m])
{
    int i, j, s;
    s = 0;
    for (i = 0; i < n; ++i)
        for (j = 0; j < m; ++j)
            s += a[i][j];
    return s;
}

static int scope_sum(int n)
{
    int i, s;
    s = 0;
    for (i = 0; i < 5; ++i) {
        int a[n + i];
        a[0] = i + 1;
        s += a[0];
        if (i == 1)
            continue;
        if (i == 3)
            break;
    }
    return s;
}

int main(void)
{
    int n, m, i, j;
    int a_bound_count;
    int a_n;
    int fixed[3][5];

    fail_id = 0;
    if (&fixed[2] - &fixed[0] != 2) { fail_id = 1; return 1; }
    n = 3;
    m = 5;
    a_bound_count = 0;
    a_n = n;
    {
        int a[(++a_bound_count, a_n)][m];
        char c[n][m];
        short h[n][m];

        if (a_bound_count != 1) { fail_id = 2; return 1; }
        a_n = 7;
        if ((int)sizeof(a) != 60) { fail_id = 3; return 1; }
        if ((int)sizeof(c) != 15) { fail_id = 4; return 1; }
        if ((int)sizeof(h) != 30) { fail_id = 5; return 1; }

        for (i = 0; i < n; ++i)
            for (j = 0; j < m; ++j) {
                a[i][j] = i * 100 + j;
                c[i][j] = (char)(i * 10 + j);
                h[i][j] = (short)(i * 20 + j);
            }

        if (a[2][4] != 204) { fail_id = 6; return 1; }
        if (c[2][4] != 24) { fail_id = 7; return 1; }
        if (h[2][4] != 44) { fail_id = 8; return 1; }
        if (&a[2] - &a[0] != 2) { fail_id = 9; return 1; }
        if (&c[2] - &c[0] != 2) { fail_id = 10; return 1; }
        if (&h[2] - &h[0] != 2) { fail_id = 11; return 1; }

        got = sum_matrix(n, m, a);
        if (got != 1530) { fail_id = 12; return 1; }
    }

    got1 = scope_sum(3);
    if (got1 != 10) { fail_id = 13; return 1; }

    n = 3;
    {
        typedef int row[n];
        row r;
        n = 5;
        r[0] = 7;
        got2 = (int)sizeof(row);
        got3 = (int)sizeof(r);
        if (got2 != 12 || got3 != 12 || r[0] != 7) {
            fail_id = 14;
            return 1;
        }
    }

    return 0;
}
