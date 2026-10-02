volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;

static int divmix(a, b)
int a;
int b;
{
    return (a / b) * 100 + (a % b);
}

int main()
{
    int a;
    int b;
    fail_id = 0;
    a = -37;
    b = 5;
    got = divmix(a, b);
    if (got != -702) { fail_id = 1; return 1; }
    got1 = divmix(37, -5);
    if (got1 != -698) { fail_id = 2; return 1; }
    got2 = divmix(-37, -5);
    if (got2 != 698) { fail_id = 3; return 1; }
    got3 = divmix(0777777, 9);
    if (got3 != (((0777777 / 9) * 100) + (0777777 % 9))) { fail_id = 4; return 1; }
    return 0;
}
