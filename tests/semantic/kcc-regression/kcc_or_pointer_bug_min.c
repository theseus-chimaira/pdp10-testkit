/*
 * Minimal KCC PDP-10 regression seed: pointer OR null check.
 *
 * Intended behavior:
 *   check_or(&a, &b) must return 33 and leave a=11, b=22.
 *
 * This is the compact form that exposed trouble in the DAIMOS
 * native bootdisk path under KCC:
 *
 *      if (p == 0 || q == 0)
 *
 * Workaround used in DAIMOS was to split the condition into two
 * separate if statements, as shown in check_split().
 *
 * C89 / K&R-compatible style, no headers, ASCII only.
 */

volatile int __test_exit;

int
check_or(p, q)
int *p;
int *q;
{
        if (p == 0 || q == 0)
                return -1;

        *p = *p + 1;
        *q = *q + 2;
        return *p + *q;
}

int
check_split(p, q)
int *p;
int *q;
{
        if (p == 0)
                return -1;
        if (q == 0)
                return -1;

        *p = *p + 1;
        *q = *q + 2;
        return *p + *q;
}

int
main()
{
        int a;
        int b;
        int r;

        a = 10;
        b = 20;
        r = check_or(&a, &b);
        if (r != 33)
                return 1;
        if (a != 11)
                return 2;
        if (b != 22)
                return 3;

        a = 10;
        b = 20;
        r = check_split(&a, &b);
        if (r != 33)
                return 4;
        if (a != 11)
                return 5;
        if (b != 22)
                return 6;

        return 0;
}
