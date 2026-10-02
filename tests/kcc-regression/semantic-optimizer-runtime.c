volatile int __test_exit;

static int
assign_expr(int *p, int x)
{
    return (*p = x);
}

static int
compound_expr(int *p, int x)
{
    return (*p += x);
}

static int
index_expr(int *p, int i)
{
    return p[i + 1];
}

static int
const_minus(int x)
{
    return 7 - x;
}

static int
dup_index(int *p, int i)
{
    return p[i] + p[i];
}

/* Object optimization must not push a negation backward through unsigned
 * division/remainder.  In particular, (-x) % d is not -(x % d) in unsigned
 * arithmetic.  DAS's packed opcode lookup exposed this as an adjacent-table
 * selection when compiling (2U - (x % 3U)) * 10U. */
static unsigned
unsigned_remainder_negation(unsigned x)
{
    return (2U - (x % 3U)) * 10U;
}

int
main(void)
{
    int a[4];
    int x;

    a[0] = 3;
    a[1] = 5;
    a[2] = 11;
    a[3] = 17;
    x = 1;

    if (assign_expr(&x, 9) != 9 || x != 9)
        return 1;
    if (compound_expr(&x, 4) != 13 || x != 13)
        return 2;
    if (index_expr(a, 1) != 11)
        return 3;
    if (const_minus(4) != 3)
        return 4;
    if (dup_index(a, 2) != 22)
        return 5;
    if ((x == 13) != 1 || (x != 7) != 1 || (x < 20) != 1)
        return 6;
    if (unsigned_remainder_negation(319U) != 10U)
        return 7;
    if (unsigned_remainder_negation(318U) != 20U)
        return 8;
    if (unsigned_remainder_negation(320U) != 0U)
        return 9;
    return 0;
}
