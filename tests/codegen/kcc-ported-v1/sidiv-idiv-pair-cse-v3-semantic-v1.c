volatile int __test_exit;
int gx;
int gy;
int matrix[32][32];

int q_then_r_const(int x)
{
    return (x / 5) * 37 + (x % 5);
}

int r_then_q_const(int x)
{
    return (x % 5) * 37 + (x / 5);
}

int idx_qr_const(void)
{
    return matrix[gx / 5][gx % 5];
}

int idx_rq_const(void)
{
    return matrix[gx % 5][gx / 5];
}

int idx_rq_var(void)
{
    return matrix[gx % gy][gx / gy];
}

int main(void)
{
    gx = 23;
    gy = 5;
    if (q_then_r_const(gx) != 151) return 1;
    if (r_then_q_const(gx) != 115) return 2;

    matrix[4][3] = 403;
    matrix[3][4] = 304;
    if (idx_qr_const() != 403) return 3;
    if (idx_rq_const() != 304) return 4;
    if (idx_rq_var() != 304) return 5;

    gx = -23;
    if (q_then_r_const(gx) != -151) return 6;
    if (r_then_q_const(gx) != -115) return 7;
    return 0;
}
