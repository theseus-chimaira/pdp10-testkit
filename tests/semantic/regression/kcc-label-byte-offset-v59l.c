/* Native GNU label values must use consistent C-byte coordinates.
   Distinct labels and a middle base exercise both offset signs. */
static volatile int visits;

static int dispatch(void)
{
    static void *table[] = { &&first, &&middle, &&last };
    static void *after = &&middle + 4;
    void *base = &&middle;
    void *target;
    short delta[3];
    int i;

    if (after != base + 4 || after - base != 4)
        return 1;
    for (i = 0; i < 3; ++i) {
        delta[i] = (short)(table[i] - base);
        if (base + delta[i] != table[i]) return 2;
        if (table[i] - delta[i] != base) return 3;
        if (delta[i] % 4 != 0) return 4;
    }
    if (delta[0] >= 0 || delta[1] != 0 || delta[2] <= 0)
        return 5;
    visits = 0;
    goto *table[0];
first:
    if (visits != 0) return 6;
    visits = 1;
    target = base + delta[2];
    if (target != &&last) return 7;
    goto *target;
middle:
    if (visits != 2) return 8;
    visits = 3;
    return 0;
last:
    if (visits != 1) return 9;
    visits = 2;
    goto *(table[2] + (short)(base - table[2]));
}

int main(void)
{
    int result = dispatch();
    if (result != 0) return result;
    return visits == 3 ? 0 : 10;
}
