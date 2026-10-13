/* CPU-specific KCC negative byte-pointer adjustment checks. */
volatile int __test_exit;
char *m1(char *p) { return p - 1; }
char *m2(char *p) { return p - 2; }
char *m3(char *p) { return p - 3; }
char *m4(char *p) { return p - 4; }
char *m5(char *p) { return p - 5; }

int main(void)
{
        char a[16];
        char *p;
        int i;

        for (i = 0; i < 16; ++i)
                a[i] = i + 1;
        p = &a[9];
        if (*m1(p) != 9) return 1;
        if (*m2(p) != 8) return 2;
        if (*m3(p) != 7) return 3;
        if (*m4(p) != 6) return 4;
        if (*m5(p) != 5) return 5;
        return 0;
}
