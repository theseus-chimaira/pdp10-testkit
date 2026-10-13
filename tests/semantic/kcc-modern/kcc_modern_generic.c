volatile int __test_exit;
static int side;
static int f(int x) { return x; }
static int lv;
int main(void)
{
    short s = 0;
    char a[3];
    const int ci = 0;
    int r;
    side = 0;
    r = _Generic((side++), int: 11, default: (side += 100));
    if (r != 11 || side != 0) return 1;
    if (_Generic(s, short: 2, int: 3, default: 4) != 2) return 2;
    if (_Generic((short)0, short: 5, int: 6) != 5) return 3;
    if (_Generic(a, char *: 7, default: 8) != 7) return 4;
    if (_Generic(f, int (*)(int): 9, default: 10) != 9) return 5;
    if (_Generic(ci, int: 12, const int: 13) != 12) return 6;
    lv = 1;
    _Generic(lv, int: lv, default: side) = 14;
    if (lv != 14) return 7;
    return 0;
}
