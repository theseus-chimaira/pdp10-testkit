volatile int clobber_sink;

void
clobber(void)
{
        clobber_sink++;
}

int
save2(int a, int b)
{
        int t;

        t = a;
        clobber();
        return t + b;
}

int
save3(int a, int b, int c, int d)
{
        int t;

        t = a + b;
        clobber();
        return t + c + d;
}

int
main(void)
{
        if (save2(12, 30) != 42)
                return 1;
        if (save3(10, 20, 5, 7) != 42)
                return 2;
        if (clobber_sink != 2)
                return 3;
        return 0;
}
