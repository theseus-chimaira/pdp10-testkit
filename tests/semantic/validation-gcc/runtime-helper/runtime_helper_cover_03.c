volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

int glob_a = 7;
short glob_b = 16;
char glob_c = 3;

static int read_globals()
{
    return glob_a + glob_b + glob_c;
}

static void write_globals(k)
int k;
{
    glob_a += k;
    glob_b = (short)(glob_b + k);
    glob_c = (char)(glob_c + k);
}

int main()
{
    fail_id = 0;
    got = read_globals();
    if (got != 26) { fail_id = 1; return 1; }
    write_globals(7);
    got1 = read_globals();
    if (got1 != 47) { fail_id = 2; return 1; }
    return 0;
}
