volatile int __test_exit;
volatile int vx, vy;
int matrix[7][7];

int q_then_r(x, y)
int x, y;
{
    int q, r;
    q = x / y;
    r = x % y;
    return q * 100 + r;
}

int r_then_q(x, y)
int x, y;
{
    int q, r;
    r = x % y;
    q = x / y;
    return q * 100 + r;
}

int direct_index(x, y)
int x, y;
{
    return matrix[x % y][x / y];
}

unsigned int uq_then_r(x, y)
unsigned int x, y;
{
    unsigned int q, r;
    q = x / y;
    r = x % y;
    return q * 100U + r;
}

unsigned int ur_then_q(x, y)
unsigned int x, y;
{
    unsigned int q, r;
    r = x % y;
    q = x / y;
    return q * 100U + r;
}

int main(void)
{
    vx = 23;
    vy = 5;
    if (q_then_r(vx, vy) != 403) return 1;
    if (r_then_q(vx, vy) != 403) return 2;
    matrix[3][4] = 1234;
    matrix[4][3] = 567;
    if (direct_index(vx, vy) != 1234) return 3;
    if (uq_then_r(23U, 5U) != 403U) return 6;
    if (ur_then_q(23U, 5U) != 403U) return 7;

    vx = -23;
    vy = 5;
    if (q_then_r(vx, vy) != -403) return 4;
    if (r_then_q(vx, vy) != -403) return 5;
    return 0;
}
