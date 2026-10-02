volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;

static int swmix(n)
int n;
{
    int i;
    int sum;
    sum = 0;
    for (i = 0; i < n; ++i) {
        if (i == 17) break;
        switch (i & 7) {
        case 0:
            sum += i + 1;
            break;
        case 1:
        case 2:
            sum += i * 2;
            continue;
        case 3:
            sum -= i;
            break;
        case 4:
            sum += 11;
            /* fall through */
        case 5:
            sum += 3;
            break;
        default:
            sum += (i & 1) ? -2 : 5;
            break;
        }
        if ((sum & 3) == 2)
            sum += 7;
    }
    return sum;
}

static int dowhile_mix(n)
int n;
{
    int i;
    int acc;
    i = 0;
    acc = 1;
    do {
        switch (n - i) {
        case 0:
            acc += 100;
            break;
        case 1:
            acc += i;
            break;
        case 2:
            acc *= 2;
            break;
        default:
            acc += (i * 3) - 1;
            break;
        }
        ++i;
    } while (i < n);
    return acc;
}

int main()
{
    got = swmix(8);
    if (got != 31) { fail_id = 1; return 1; }
    got1 = swmix(25);
    if (got1 != 104) { fail_id = 2; return 1; }
    got2 = dowhile_mix(5);
    if (got2 != 18) { fail_id = 3; return 1; }
    return 0;
}
