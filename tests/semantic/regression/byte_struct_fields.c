volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
struct S { char a; int b; unsigned char c; char d[3]; };
struct S gs;
int main()
{
    struct S s;
    struct S *p;
    fail_id = 0;
    s.a = 5;
    s.b = 02000;
    s.c = 0377;
    s.d[0] = 1;
    s.d[1] = 2;
    s.d[2] = 3;
    got = s.a;
    if (got != 5) { fail_id = 1; return 1; }
    got1 = s.c;
    if (got1 != 0377) { fail_id = 2; return 1; }
    got2 = s.d[0] + s.d[1] + s.d[2];
    if (got2 != 6) { fail_id = 3; return 1; }
    gs = s;
    p = &gs;
    got3 = p->a + p->c + p->d[2];
    if (got3 != 0407) { fail_id = 4; return 1; }
    got4 = p->b;
    if (got4 != 02000) { fail_id = 5; return 1; }
    return 0;
}
