volatile int __test_exit;

static int twice_plus(int x)
{
    return ({ int y = x + 1; y *= 2; y + 3; });
}

static int absolute_value(int x)
{
    return ({ int y = x; if (y < 0) y = -y; y; });
}

static int mixed_live(int a, int b)
{
    return a * 7 + ({ int y = b + 2; y * 3; }) + a;
}

static int side_effect(int *p)
{
    return ({ *p += 4; *p; });
}

int main(void)
{
    int x;

    if (twice_plus(4) != 13) return 1;
    if (absolute_value(-7) != 7) return 2;
    if (mixed_live(5, 6) != 64) return 3;
    if (({ int y = 2; ({ y += 3; y; }); }) != 5) return 4;
    if (sizeof(({ int y = 1; y; })) != sizeof(int)) return 5;
    x = 10;
    if (side_effect(&x) != 14 || x != 14) return 6;
    (void)({ int y = x; y += 1; });
    return 0;
}
