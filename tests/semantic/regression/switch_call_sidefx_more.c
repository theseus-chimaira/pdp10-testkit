volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;

static int bump(p, x)
int *p;
int x;
{
    *p = *p + x;
    return *p;
}

static int swcall(n)
int n;
{
    int i;
    int acc;
    acc = 0;
    for (i = 0; i < n; ++i) {
        switch ((i + acc) & 7) {
        case 0:
            got = bump(&acc, 1);
            acc += got;
            break;
        case 1:
        case 6:
            acc -= i;
            break;
        case 2:
            acc += i * 3;
            continue;
        case 3:
            acc = acc + 5;
            break;
        case 4:
            acc = acc - bump(&i, 1);
            break;
        default:
            acc += (i & 1) ? 4 : -3;
            break;
        }
        if (acc > 40)
            break;
    }
    return acc + i;
}

int main()
{
    fail_id = 0;
    got = swcall(6);
    if (got != 36) { fail_id = 1; return 1; }
    got1 = swcall(12);
    if (got1 != 54) { fail_id = 2; return 1; }
    got2 = swcall(20);
    if (got2 != 54) { fail_id = 3; return 1; }
    return 0;
}
