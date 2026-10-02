/* KCC modern C smoke: GNU typeof / __typeof / __typeof__. */

volatile int __test_exit;

typedef int myint;

struct pair {
        int a;
        int b;
};

int
main()
{
        int x;
        int side;
        typeof(x) y;
        __typeof(x + y) z;
        __typeof__(int *) p;
        typeof(struct pair) s;
        typeof(++x) q;
        myint m;
        typeof(m) n;

        x = 5;
        side = 1;
        y = 6;
        z = 7;
        p = &x;
        *p = *p + 1;
        s.a = 2;
        s.b = 3;
        q = 11;
        m = 13;
        n = 17;

        if (x != 6)
                return 1;
        if (side != 1)
                return 2;
        if (y != 6 || z != 7)
                return 3;
        if (s.a + s.b != 5)
                return 4;
        if (q != 11)
                return 5;
        if (m + n != 30)
                return 6;

        return 0;
}
